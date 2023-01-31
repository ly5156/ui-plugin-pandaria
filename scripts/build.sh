#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BASE_DIR="$( cd $SCRIPT_DIR && cd .. & pwd)"

CYAN="\033[96m"
YELLOW="\033[93m"
RESET="\033[0m"
BOLD="\033[1m"
NORMAL="\033[22m"
CHECK="\xE2\x9C\x94"

GITHUB_SOURCE=$(git config --get remote.origin.url | sed -e 's/^git@.*:\([[:graph:]]*\).git/\1/')
GITHUB_BRANCH="main"
PLUGINS=( "$@" )

echo -e "${CYAN}${BOLD}Build UI Plugins${RESET}"

echo -e "${CYAN}GitHub Repository: ${GITHUB_SOURCE}${RESET}"
echo -e "${CYAN}GitHub Branch    : ${GITHUB_BRANCH}${RESET}"

# --------------------------------------------------------------------------------
# Check that we have the required commands avaialble for this script
# --------------------------------------------------------------------------------

if ! [[ -d ${BASE_DIR}/node_modules ]]; then
  echo -e "${YELLOW}You must run ${BOLD}yarn install${NORMAL} before running this script${RESET}"
  exit 1
fi

COMMANDS=("node" "jq" "yq" "git" "helm" "yarn")
HAVE_COMMANDS="true"
for CMD in "${COMMANDS[@]}"
do
  if ! command -v ${CMD} >/dev/null; then
    echo -e "${YELLOW}This script requires ${BOLD}${CMD}${NORMAL} to be installed and on your PATH${RESET}"
    HAVE_COMMANDS="false"
  fi
done

if [ "${HAVE_COMMANDS}" == "false" ]; then
  exit 1
fi

ASSETS=${BASE_DIR}/assets
CHARTS=${BASE_DIR}/charts
mkdir -p ${ASSETS}
mkdir -p ${CHARTS}

TMP=${BASE_DIR}/tmp
CHART_TMP=${BASE_DIR}/tmp/_charts
rm -rf ${TMP}
mkdir -p ${TMP}

CHART_TEMPLATE=${BASE_DIR}/tmp/ui-plugin-server

# --------------------------------------------------------------------------------
# Clone the plugin server template into the temporary folder
# --------------------------------------------------------------------------------
pushd ${TMP} > /dev/null
git clone -q https://github.com/rancher/ui-plugin-server.git
popd > /dev/null

# --------------------------------------------------------------------------------
# Iterate through all packages - built them all or build only those specified on the command line
# --------------------------------------------------------------------------------

for d in pkg/*/ ; do
  pkg=$(basename $d)

  if [ -z "$1" ] || [[ " ${PLUGINS[*]} " =~ " ${pkg} " ]]; then
    # Check we don't already have a published version by looking in the assets folder
    PKG_VERSION=$(jq -r .version ./pkg/${pkg}/package.json)
    PKG_NAME="${pkg}-${PKG_VERSION}"
    PKG_ASSET=${ASSETS}/${pkg}/${PKG_NAME}.tgz

    echo -e "${CYAN}${BOLD}Building plugin: ${pkg} (${PKG_VERSION}) ${RESET}"

    echo "Package version: ${PKG_VERSION}"
    echo "Package folder:  ${PKG_NAME}"

    # --------------------------------------------------------------------------------
    # Build the plugin from source
    # --------------------------------------------------------------------------------
    echo -e "${CYAN}Building plugin from source code${RESET}"
    FORCE_COLOR=1 yarn build-pkg $pkg | cat

    echo -e "${CYAN}Adding plugin code ...${RESET}"

    EXT_FOLDER=${BASE_DIR}/extensions/${pkg}/${PKG_VERSION}
    PKG_DIST="${BASE_DIR}/dist-pkg/${PKG_NAME}"

    rm -rf ${EXT_FOLDER}

    mkdir -p ${EXT_FOLDER}/plugin

    # Copy the code into the folder
    cp -R ${PKG_DIST}/* ${EXT_FOLDER}/plugin

    pushd ${BASE_DIR}/extensions/${pkg}/${PKG_VERSION} > /dev/null
    rm -f plugin/report.html
    find plugin -type f | sort > files.txt
    popd > /dev/null

    # --------------------------------------------------------------------------------
    # Create the Helm chart
    # --------------------------------------------------------------------------------

    if [ -f ${PKG_ASSET} ] && [ "${FORCE}" == "false" ]; then
      echo -e "${YELLOW}Helm chart has already been created - skipping (run with -f to force build)${RESET}"
      continue;
    fi

    CHART_FOLDER=${CHARTS}/${pkg}/${PKG_VERSION}

    mkdir -p ${ASSETS}/${pkg}
    rm -rf ${CHART_FOLDER}
    mkdir -p ${CHART_FOLDER}

    cp -R ${CHART_TEMPLATE}/charts/ui-plugin-server/* ${CHART_FOLDER}

    # Update Chart.yaml and values.yaml from the package file metadata
    # Use the script from the template repository
    echo -e "${CYAN}Patching Helm chart template${RESET}"

    CHART=${CHART_FOLDER} REGISTRY="${REGISTRY}" ORG="${REGISTRY_ORG}" PACKAGE_JSON=${BASE_DIR}/pkg/${pkg}/package.json ${CHART_TEMPLATE}/scripts/patch

    # Copy README file from the plugin to the Helm chart, if there is one
    if [ -f "./pkg/${pkg}/README.md" ]; then
      cp ./pkg/${pkg}/README.md ${CHART_FOLDER}/README.md
    fi

    echo "Patching for GitHub build"
    pushd ${CHART_FOLDER} > /dev/null
    cd templates
    mv cr.yaml temp.cr
    rm *.yaml
    mv temp.cr cr.yaml
    ENDPOINT=https://raw.githubusercontent.com/${GITHUB_SOURCE}/${GITHUB_BRANCH}/extensions/${pkg}/${PKG_VERSION}
    sed -i.bak -e 's@endpoint: .*@endpoint: '"${ENDPOINT}"'@g' cr.yaml       
    rm *.bak
    popd > /dev/null

    yq -i 'del(.pluginServer)' ${CHART_FOLDER}/values.yaml

    # Package into a .tgz helm chart
    helm package ${CHART_FOLDER} -d ${ASSETS}/${pkg}

    # --------------------------------------------------------------------------------
    # Update the helm index just for this chart 
    # --------------------------------------------------------------------------------
    HELM_INDEX=${BASE_DIR}/index.yaml

    if [ -f "${HELM_INDEX}" ]; then
      UPDATE="--merge ${HELM_INDEX}"
    fi

    # Base URL referencing assets directly from GitHub
    BASE_URL="assets/${pkg}"

    rm -rf ${CHART_TMP}
    mkdir -p ${CHART_TMP}
    cp ${ASSETS}/${pkg}/*.tgz ${CHART_TMP}

    helm repo index ${CHART_TMP} --url ${BASE_URL} ${UPDATE}

    cp ${CHART_TMP}/index.yaml ${HELM_INDEX}

  fi
done

echo -e "${CYAN}${BOLD}${CHECK} One or more packages built${RESET}"
popd > /dev/null

# Clean up
rm -rf ${CHART_TMP}
rm -rf ${TMP}
