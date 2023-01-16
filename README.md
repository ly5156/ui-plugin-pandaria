# UI Plugin Pandaria

## Project setup

1. 修改 `dashboard/shell/package.json` 文件:

在 `dependencies` 值中，添加依赖: `"crypto-js": "^4.1.1"`

2. 进入dashboard IU（中国版 Prime UI）shell 目录，执行下面命令，在 `shell` 目录下添加 `rancher-components` 软链接，指向`pkg/rancher-components/src/components`:

```shell
ln -s ../pkg/rancher-components/src/components rancher-components
```

3. 进入 `dashboard/shell` 目录，执行下面命令，为`@rancher/shell`包建一个全局软链接，指向当前源码:

```shell
 yarn link
```

4. 在 ui plugin 根目录中，执行下面命令，将`@rancher/shell`依赖指向上一步建立的软链接：
```shell
yarn link "@rancher/shell"   
```

5. 在 ui plugin 根目录中，执行下面命令，下载依赖：

```shell
yarn install

```

6. 在 ui plugin 根目录中，执行下面命令，启动开发环境：

```shell
API=<rancher server address> yarn mem-dev --spa

```

`yarn link` ref: https://classic.yarnpkg.com/lang/en/docs/cli/link/
