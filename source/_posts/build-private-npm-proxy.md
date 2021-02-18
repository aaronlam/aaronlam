---
title: 搭建公司内部的npm私服
date: 2019-01-01 08:00:00
tags:
  - Node.js
  - npm
categories:
  - Node.js
---

由于我们公司内部的前端项目越来越多并且迭代速度越来越快，项目里的业务系统也精细的进行了不同的划分，那么这些项目之间的公共代码以及公共组件的提取、维护、管理问题就也愈显的突出。所以，最近都在进行公共库的维护以及公共组件的提取工作，然后再把这些公共库和公共组件库以依赖包的形式进行管理，同样的我们使用了 SemVer 来进行版本号的规范化，最后再以依赖包的形式进行发布。这就让我们可以把这些单独“拎出来的代码”能够以 `npm install` 或 `yarn add` 的形式来进行依赖包安装，然后再引入到实际用到的每个项目里，这样一旦这些公共库或公共组件库更新了，就不用在每个项目里一份一份的复制粘贴了，直接 `npm update` 或 `yarn upgrade` 了事。

但是，对于一些公共库的代码可能会涉及到比较核心的业务逻辑，就导致我们没办法把这些库代码的依赖包以 npm 包的形式发布到公网的 npm 仓库；同时，由于每次前端项目进行依赖包安装时，其安装的速度都依赖于网络以及第三方镜像。所以，这就迫切的需要有一个公司内部的 npm 私有仓库了，也就是 npm 私服。在我研究了目前 npm 私服的几乎所有搭建方式后，总结下来总共有以下几种：

付费：

1. [MyGet](https://www.myget.org/)：9 刀每月，两个账号，1GB 空间
2. [NPM Org](https://www.npmjs.com/)：每个账号每月 7 刀

免费：

1. [DIY NPM](https://docs.npmjs.com/misc/registry)
2. [CNPM](https://github.com/cnpm/cnpmjs.org)
3. [Nexus](https://www.sonatype.com/)
4. [Sinopia](https://www.npmjs.com/package/sinopia)
5. [Verdaccio](https://verdaccio.org/)

首先排除付费，根据搭建方式和易用程度来选本来是选择 Sinopia 的，因为其搭建十分简单友好，基本就是傻瓜式的。不过到其 GitHub Repo 页面看到貌似已经放弃维护很多年了，然后再深入调查发现有一群人出了个分支，而这个分支就是 Verdaccio。然后还发现 Verdaccio 延续了 Sinopia 的简单便捷，并且这个库也在积极维护中，看起来就比 Sinopia 靠谱一点。最后就果断的选择了 Verdaccio 来搭建公司内部的 npm 私服。

不过如果公司内部有 Java 技术栈团队的可以尝试一下 Nexus，因为看到他貌似也可以进行 maven/gralde 仓库的统一管理。而我们公司虽然也有 Java 技术栈的团队，但是由于我们部门后端是 .Net 技术栈，遂放弃！

<!--more-->

## 搭建步骤

在搭建时我是向公司的运维同学申请了一台内存 4GB 的 Linux 虚拟机，这个配置的话在后续的使用中也没有出现过太大的问题。所以，大家可以根据实际情况来挑选合适的配置进行搭建。但下面的演示步骤，我拿的是 Windows 开发机进行演示的。无须担心，他们的搭建步骤基本是一致的。

### 1. 安装 Node.js

由于我的电脑已经安装上了，所以这里就不再演示了。

### 2. 安装 Verdaccio 依赖包

```shell
npm i -g verdaccio
```

如果安装过程报了 grywarn 的权限错误的话，那么需要加上 `--unsafe-perm`，如下命令：

```shell
npm i -g verdaccio --unsafe-perm
```

### 3. 启动 Verdaccio

安装完依赖包后，我们就可以在命令行中输入 `verdaccio` 命令启动，如下所示：

![启动Verdaccio](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210145307.png)

此时，我们在浏览器中，输入 `http://localhost:4873` 就可以看到用 Verdaccio 搭建好的 npm 私服了，如下所示：

![Verdaccio首页](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210145522.png)

## 使用步骤

### 1. 安装 nrm/yrm

在使用 Verdaccio 所搭建的 npm 私服之前，我们可以先安装 `nrm` 或者 `yrm` 来管理自己的 npm 源，这两个命令行工具可以帮助我们快速的修改、切换、增加源。由于 `nrm` 和 `yrm` 的使用方式是类似的，所以下面都以 `nrm` 作为演示的例子。

执行下面的命令安装其依赖包：

```shell
npm i -g nrm
```

如果想了解更多关于 `nrm` 的命令，可以执行命令 `nrm --help` 来查看所列出的所有命令。

### 2. 使用 nrm 添加私服源

我们刚刚已经启动了 Verdaccio，也就表明我们使用 Verdaccio 所搭建的 npm 私服源正在悄悄运行中了。此时，如果我们想要使用他的话就可以用 `nrm` 来添加该私服源。当然不使用 `nrm` ，手动使用命令 `npm config set registry http://127.0.0.1:4873` 去设置 npm 的源地址，或者在项目根目录下创建 `.npmrc` 配置文件来配置项目使用的源地址也是可以的，不过为了便捷性我们还是使用 `nrm` 吧。

执行下面的命令添加 npm 私服源：

```shell
# 这里的verdaccio是名字，可以输入任意名字
nrm add verdaccio http://127.0.0.1:4873
```

添加完后，此时我们就可以执行以下命令，列出目前所有的源：

```shell
nrm ls
```

下图中所列出的就是 `nrm` 中我们所有能够切换的 npm 源了，刚添加的私服源在最下面：

![所有npm源](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210152437.png)

### 3. 利用 nrm 使用私服源

上面我们已经列出了所有能切换的 npm 源了，列表中也出现了我们所添加的私服源。

执行下面的命令把当前 npm 的源切换到私服源：

```shell
nrm use verdaccio
```

如下图所示，我们就已经切换到刚添加的私服源了：

![切换私服源](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210153024.png)

### 4. 创建私服源账号

有发布过 npm 包的同学应该知道，在发布前我们都需要先注册 npm 官方源的账号，这样我们才能够把我们开发的 npm 包发布到对应的账号下供别人使用。而我们的私服源也是同样道理，如果要发布包到私服里，也是需要先创建一个私服的账号。我们刚刚已经使用 `nrm` 把 npm 的源切换到了 verdaccio （私服）源下，那么如何创建账号？往下看！

执行以下命令后就可以根据提示创建账号：

```shell
npm adduser
```

如下图所示，我在自己搭建的私服源中创建了 test 账号：

![创建私服源账号](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210154239.png)

### 5. 登录私服源账号

既然账号都已经创建了，自然就可以使用刚刚的账号登录到所搭建的私服源中。

执行以下命令登录私服源账号：

```shell
npm login
```

如下图所示，如我们的预期一样，所注册的账号已经可以登录到私服源了：

![登录私服源账号](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210154239.png)

### 6. 发布包到私服源

现在，我们可以尝试一下创建一个项目然后把该项目发布到私服源中。我这里是随便创建了一个文件夹 `verdaccio-npm-publish-demo`，然后用 VSCode 打开后在终端执行 `npm init` 初始化项目，再创建一个 `index.js` 文件，内容就为 `console.log('publish demo')`，如下：

![项目概览图](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210160045.png)

此时，我们回到在终端中，执行命令 `npm login` 登录到私服源中，然后再执行命令 `npm publish` 来把包发布到私服源里去。此时终端就会显示包已经发布成功，如下：

![私服源包发布](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210164544.png)

我们访问私服源的首页，也会看到我们刚刚所发布的包，如下：

![已发布的包](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210164312.png)

### 7. 安装私服源里的包

我们已经把项目 `verdaccio-npm-publish-demo` 以包的形式发布到私服源里了，那么自然的就能够在其他项目里安装这个包。**我们可以像平常安装包依赖一样安装这个包，前提是我们已经把 npm 的源切换到了私服源。**我这里创建了多一个项目 `verdaccio-npm-install-demo` 来演示安装私服源里的依赖包。

如下图所示，项目 `verdaccio-npm-install-demo` 里安装了私服源里的 `verdaccio-npm-publish-demo` 依赖包：

![私服源依赖包安装](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201210165808.png)

## 优化配置

从上面启动 Verdaccio 的信息来看，他的配置文件应该是 `C:\Users\Administrator\AppData\Roaming\verdaccio\` 文件夹下的 `config.yaml` 文件，所以，我们接下来都会在该配置文件中做进一步的配置。

### 1. 外网访问

如果外网也需要访问该 npm 私服的话，那么需要在配置文件的底部增加以下配置：

```yaml
listen: 0.0.0.0:4873
```

### 2. 用户控制

在上文中可以看到 Verdaccio 默认是允许任何人创建账号的，如果没有进一步的配置，那么所创建账号的账号都会有 publish 的权限。所以，如果我们要把控好权限，就要进一步的配置他。

此时，我们打开配置文件，进行以下修改：

```diff
auth:
  htpasswd:
    file: ./htpasswd
+   max_users: -1
    # Maximum amount of users allowed to register, defaults to "+inf".
    # You can set this to -1 to disable registration.
    # max_users: 1000
```

问题来了，如果设置为了 `max_users: -1`，那以后要怎么增加用户呢？有以下两种方式：

1. 手动编辑 `htpasswd` 文件
2. 使用第三方工具，以 命令的形式增加用户

执行以下命令安装 sinopia-adduser（没错，由于 Verdaccio 是由 Sinopia 所分支出来的，所以工具也通用）：

```shell
npm i g sinopia-adduser
```

安装好后，到 `htpasswd` 文件目录下，运行一下命令：

```shell
sinopia-adduser
```

### 3. 权限控制

既然用户已经控制住了，权限当然也要进行控制。我们可以在 Verdaccio 的配置文件中，发现 `packages` 的配置项，内容如下：

```yaml
packages:
  "@*/*":
    # scoped packages
    access: $all
    publish: $authenticated
    unpublish: $authenticated
    proxy: npmjs

  "**":
    # allow all users (including non-authenticated users) to read and
    # publish all packages
    #
    # you can specify usernames/groupnames (depending on your auth plugin)
    # and three keywords: "$all", "$anonymous", "$authenticated"
    access: $all

    # allow all known users to publish/publish packages
    # (anyone can register by default, remember?)
    publish: $authenticated
    unpublish: $authenticated

    # if package is not available locally, proxy requests to 'npmjs' registry
    proxy: npmjs
```

下面简单的介绍一下以上的一些配置项含义：

首先，上面对于 `packages` 配置项的子配置项有两个，一个是 `@*/*` 另外一个是 `**`，而这两个配置项有个名称叫 `scope`，其作用是用来匹配依赖包名字的。那这样就不难发现 `@*/*` 应该就是用来匹配类似 `@babel/preset-env` 这种依赖包的，而 `**` 就是用来匹配 `webpack` 这种依赖包的。这样的话，我们就可以针对依赖包的名字做以下的详细配置。

权限：

- `access` 表示哪一类用户可以安装此类依赖包（install）
- `publish` 表示哪一类用户可以发布此类依赖包（publish）
- `proxy` 这里的值对应的是配置文件中的 `uplinks` 配置项里的子项名称，`uplinks` 配置项是配置上游 npm 源的。而 `proxy` 配置项的作用是如果私服源不存在依赖包，那就去对应配置的上游 npm 源获取。

值得含义：

- `$all` 表示所有人（已注册，未注册）都可以执行对应操作
- `$authenticated` 表示只有注册且登录的用户才可以执行对应操作
- `$anonymous` 表示只有未注册登录可以执行对应操作

那就是说，如果我们需要指定某个用户才有权限，就直接配置上其账号名称即可（多个用户用空格隔开），比如：

```yaml
access: aaronlam test
```

修改完配置后重启 verdaccio 即可！

## 进程守护

如果此时直接在服务器中执行命令 `verdaccio` 开启 npm 私服的话，那么就没办法保证其进程能够一直安全的运行。万一进程挂了，那就麻烦大了，所以我们需要使用 Node.js 里的进程守护工具 `pm2` 来对 `verdaccio` 进程进行托管启动。

执行以下命令安装依赖包：

```shell
npm i -g pm2
```

安装好后，我们就可以通过以下命令让 `pm2` 来托管运行我们的 `verdaccio`：

```shell
pm2 start verdaccio
```

此时，我们可以通过以下命令来查看 `verdaccio` 的实时日志：

```shell
pm2 show verdaccio
```

至此，我们对于搭建公司内部的 npm 私服就完成啦！其实 `verdaccio` 还有其他的一些插件可以搭配使用，这个就让大家自己去探索了。另外，关于 `pm2` 命令行进程守护工具的更多用法，可以移步到 [pm2 官网的文档](https://pm2.keymetrics.io/docs/usage/quick-start/)查看。
