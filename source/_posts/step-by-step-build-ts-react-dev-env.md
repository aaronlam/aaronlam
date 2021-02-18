---
title: 从零一步步搭建属于自己的TypeScript+React开发环境
date: 2020-02-15 00:00:00
tags:
  - TypeScript
  - React
  - 开发环境
categories:
  - 前端
---

如果现在要开发一个 React 项目，那最快的方式应该就是直接使用 Facebook 官方开源的脚手架 [creat-react-app](https://github.com/facebook/create-react-app)，简称：CRA。但是，随着项目的业务场景复杂度提升，难免会需要在开发环境里做一些配置上的调整。这个时候就只能把脚手架进行 eject 后，亲自上阵修改 Webpack 的配置了，即便是这样 CRA 对于 Webpack 的配置灵活度也是相对的不太高。如果这个时候对 Webpack 不够熟练的话，就会有种心有余而力不足的感觉。

想当初我为了要给公司的前端项目搭建开发环境时，也是被 Webpack 折腾的死去活来，配置 Webpack 的时候总是记不住配置里的那些字段，而且配置时还要牵扯到一系列的工具，像 ES6 编译器 Babel、CSS 预处理器 less/sass、CSS 后处理器 postcss，还有各种 webapck 的 loader 和 plugin。所以，在刚开始的一段时间里都还是直接 CRA 了事。不过在经过一段时间的毒打后，在后续的项目里逐渐的把 CRA 替换为自行搭建的开发环境。现在让我从零开始一个前端项目的话，我更多的会选择自己去搭建开发环境，其次才会去选择官方的 CLI。

而这篇文章最主要目的是想让大家（特别是新手）能够从零开始，一步一步搭建出一个完整的开发环境。然后在搭建的过程中，一点一点的了解每一步中所配置项的作用及其原理，每一个插件的作用及其影响并对比同功能插件的差别。只要跟着步骤来走，就一定能实现所说的同样功能。

先附上项目地址：[webpack-typescript-react-practice2](https://github.com/aaronlam/webpack-typescript-react-practice2)

<!--more-->

## 能学到什么

在大家通篇阅读及实践后，将会学到如下这些知识点：

1. 项目中常用的配置文件
2. 项目统一代码风格和规范配置
3. 项目统一代码提交规范配置
4. Webpack 基本配置
5. TypeScript + React 开发环境搭建
6. Webpack 公共构建环境优化
7. Webpack 开发构建环境优化
8. Webpack 生产构建环境优化

## 项目初始化及配置文件

我使用的开发机和编辑器分别是 win 10 和 VSCode，Node 版本为 12.10.0，命令行使用的是 VSCode 中的 Terminal。在实践过程中所安装的全部依赖均为目前最新版本，并且文章会不定时更新，确保文章具有时效性。

### 1. package.json

搭建项目的第一步就是新建项目文件夹，然后初始化项目，生成项目配置文件 package.json。

```shell
# 新建项目文件夹
mkdir webpack-react-typescript-practice
# 切换工作路径到项目文件夹
cd $_
# 初始化项目，生成项目配置文件
npm init -y
```

你可以将 `webpack-react-typescript-practice` 替换成你想要的项目名称，命令中的 `$_` 表示上一条命令的最后参数，在这里就表示项目文件夹名称。在初始化项目时，你也可以使用 `yarn` 进行初始化。但是在这里我们就以 `npm` 作为初始化工具，在后续的过程中也会用 `npm` 来进行依赖包的安装。

然后通过修改默认的项目配置文件后，内容如下：

```json
{
  "name": "webpack-typescript-react-practice2",
  "version": "1.0.0",
  "description": "Quickly create react + typescript project development environment",
  "main": "index.js",
  "scripts": {},
  "keywords": ["react-typescript-project"],
  "author": {
    "name": "aaronlam",
    "url": "https://www.aaronlam.xyz",
    "email": "a@aaronlam.xyz"
  },
  "license": "MIT",
  "bugs": {
    "url": "https://github.com/aaronlam/webpack-typescript-react-practice2/issues"
  },
  "homepage": "https://github.com/aaronlam/webpack-typescript-react-practice2#readme"
}
```

暂时修改了以下配置：

- description：增加了对该项目的描述，当项目 push 到 github 后，在 github 进行 repo 搜索时，关键字就会与 description 进行匹配
- scripts：把默认生成的 test 项删除
- keywords：增加了项目的关键字，当项目 publish 到 npm 后，开发者在 npm 搜索时，合适的关键字能更容易被搜索到
- author：添加了项目的作者信息
- license：修改了项目的协议

### 2. LICENSE

可以根据项目的性质，到网站 [choose a license](https://choosealicense.com/) 选择一个合适的 license（一般没有特别的需求，都会选择较为宽松的 MIT 协议），复制到项目根目录下的 LICENSE 文件内即可，然后修改其中的年份和作者名，如下：

```text
MIT License

Copyright (c) [2020] [Aaronlam]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 3. .gitignore

说到 `.gitignore` 配置文件，那我们就要先来一波 git 本地仓库初始化，执行以下命令来初始化 git 本地仓库：

```shell
# 初始化git仓库
git init
```

git ignore，顾名思义就是让 git 选择性根据规则忽略掉一些文件的版本控制。VSCode 也会监听该文件之外的所有文件，如果没有进行忽略的文件有所改动时，在 git 进行提交时就会被识别为需要提交的文件。

`node_modules` 是我们安装第三方依赖包的文件夹，这个是肯定要添加到 `.gitignore` 中的，且不说这个文件夹里面成千上万个文件会给编辑器带来的性能压力，也会给提交至远端的版本管理服务器造成不小的压力。另外就是这个文件夹内的东西，完全是可以通过命令 `npm install` 获取到。

所以不需要进行版本控制的文件或文件夹都要添加进来，比如项目中常见的：build, dist 文件夹等，还有操作系统中默认生成的，如 MacOS 系统生成的 DS_Store 文件等。但是，我们对于系统或者编辑器自动生成的文件并不都是了如指掌的，那么我们就可以通过 VSCode 的 [gitignore](https://marketplace.visualstudio.com/items?itemName=codezombiech.gitignore) 插件来生成 `.gitignore` 文件常用的配置规则信息。

![gitignore插件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201126141031.png)

安装好插件后，<kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>p</kbd> 唤出 VSCode 的命令面板，输入 `Add gitignore` 命令，即可在输入框继续输入系统或者编辑器名字，来自动生成相应需要忽略的文件或文件夹规则至 `.gitignore` 文件中。可操作多次，后续操作的规则信息将自动追加至 `.gitignore` 文件中。

我添加了以下几个忽略规则配置项：

1. Node
2. Windows
3. MacOS
4. VSCode

大家可以酌情添加，如果插件中没有的规则，可自行手动添加至 `.gitignore` 中，具体的配置规则可以[参考这里](https://git-scm.com/docs/gitignore)，比如我自己就添加了 `dist` 和 `build`，用于忽略后续 webapck 打包构建出的文件。

![gitignore添加规则](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201126143100.gif)

### 4. .npmrc

众所周知，由于有股神秘不可抗拒的力量，国内无论是 github 还是 npm 的连接速度都是非常抽搐的。大家也不想在使用 npm 安装项目依赖包时，忍受着如龟速般的安装进度。所以我们一般都会在 Terminal 里输入以下命令把 npm 或 yarn 的源切换为淘宝的镜像源。

```shell
npm config set registery https://registery.npm.taobao.org
# or
yarn config set registery https://registery.npm.taobao.org
```

又或者是全局安装 `nrm` 或者 `yrm`，使用这两个插件来进行 npm 或 yarn 源的切换：

```shell
# 全局安装nrm
npm i -g nrm
# 使用nrm切换淘宝镜像源
nrm use taobao
# 通过nrm ls可以看到其他的镜像源
nrm ls

  npm -------- https://registry.npmjs.org/
  yarn ------- https://registry.yarnpkg.com/
  cnpm ------- http://r.cnpmjs.org/
* taobao ----- https://registry.npm.taobao.org/
  nj --------- https://registry.nodejitsu.com/
  npmMirror -- https://skimdb.npmjs.com/registry/
  edunpm ----- http://registry.enpmjs.org/

# 或全局安装yrm
yarn global add yrm
# 使用yrm切换淘宝镜像源
yrm use taobao
# 通过yrm ls可以看到其他的镜像源
yrm ls

  ...

```

**但是！**大家想想，万一某个同学 clone 了你的项目之后，准备在本地开发的时，他先前并没有设置淘宝 npm 镜像源，这时他就需要进行一次以上的动作，又或者他正全然不知的忍受着龟速的依赖包安装进度。

而我们作为项目的搭建者，从便利性考虑应该创建 `.npmrc` 配置文件，而该配置文件是给 npm 使用的配置文件，当然如果你使用 yarn 的话，yarn 也会遵守 `.npmrc` 的配置，虽然 yarn 也有自己专门的配置文件 `.yarnrc`。随后我们在配置文件内把 npm 的源设置为淘宝的 npm 镜像源。

```shell
# 创建.npmrc文件
touch .npmrc
# 在该文件内输入配置
registery=https://registery.npm.taobao.org/
```

自此，我们在 npm 依赖包安装的速度上过上了小康生活！

### 5. README.md

`README.md` 就是项目的说明书，只要在 github 流浪过的开发人员肯定都会看到过项目底下的各种说明页面，而这些说明页面都是 github 根据 `README.md` 文件自动渲染显示的。而这个文件对于一个好的开源项目是无比重要的，且文件的内容要足够简洁清晰明了。

一般我们会在 `README.md` 里添加一些实用的 badges（徽章），例如持续集成工具 Travis CI 对于项目 build 状态的徽章，或者 denpendencies 版本是否过期的徽章等。而 badge 本质上就是一个链接，只不过文字部分换成了 svg 渲染的图片，我们可以在网站 [shields.io](https://shields.io/) 中找到各种各样的 badge，平时逛 github 项目的时候看到喜欢的 badge 也可以收藏一下。

不过，由于我们的项目目前还没有实质性内容，所以先把 `README.md` 文件创建先，后续我们再回过头来补充他！

```shell
# 创建README.md文件
touch README.md
```

## 统一代码风格和规范配置

非常好呀！无惊无险的来到了非常重要的**统一代码风格和规范配置**章节，在多人共同开发一个项目的时候问题就是每个人的代码风格都会有所差异，随着项目版本的不停迭代，维护人员的不断更替。项目里的代码就会变得越来越不可维护，比如 jack、mike、nick 三人的开发风格如下：

```text
// jack紧凑型风格
const add=(a,b)=>{return a+b;}

// mike常规型风格
const add =  (a, b) => {
    return a + b
}

// nick紧凑规范型风格
var add = (a,b) => {
    return a+b
}
```

对于一个刚接手这种项目的你，然而你又有强迫症，会不会顿时产生一个念头，**人间不值得！**如果我们从项目搭建的开始就有手段去约束项目中的代码风格，使其风格统一，将会极大地提升代码的可维护性，很重要的一点是能够关爱每位强迫症开发患者。

### 1. EditorConfig

EditorConfig 是跨编辑器维护代码风格一致性的规范，通过其 `.editorconfig` 文件，我们可以让多个开发人员，使用不同的编辑器时使代码格式化风格仍然能保持一致。有的 IDE 会直接内置 EditorConfig 规范，如：IDEA。但 VSCode 则需要安装[EditorConfig For VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)插件来进行支持。

![EditorConfig For VS Code插件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201126155008.png)

安装完插件后，在 VSCode 中使用快捷键 <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>p</kbd> 唤出命令面板，输入 `Generate .editorcondig` 即可快速生成 `.editorconfig` 文件。但是，有时候因为 VSCode 抽风会时不时的找不到该命令，如果你恰好也找不到，那么我们就手动创建该配置文件把。

该配置文件的配置信息特别简单，就几个配置项，如下：

```text
root = true

[*]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
end_of_line = unset
```

在插件和配置都准备就绪后，编辑器就会先读取该配置文件，把配置文件内的格式化规则覆盖到编辑器默认的 Formatter 规则中。以下是对上面规则项的简单介绍：

- indent_style：缩进风格，可选的配置有 tab 和 space
- indent_size：缩进大小，可设定为 1-8 的数字，设定多少就表示缩进多少个 tab/space
- charset：编码格式，通常都是 utf-8
- trim_trailing_whitespace：去除多余的空格，比如在末尾多打了个空格，则会自动去除
- insert_final_newline：在末尾插入一空行，个人比较喜欢这个风格，大家喜欢的话也可以设为 true
- end_of_line：换行符，可选的配置有 lf, cr, crlf, unset。有那么多选择的原因是因为各个操作系统之间的换行符不同导致的，Windows 的为 crlf，Linux 和现代 MacOS 为 lf，早期的 MacOS 为 cr。而这里我们设置为 unset，表示让其换行符遵守当前操作系统。

### 2. Prettier

#### EditorConfig 和 Prettier

上面我们使用了 EditorConfig 来为我们进行跨编辑器维护代码风格，Prettier 也是用来维护代码风格的东西，乍一看，两个东西的作用貌似是一样的呀。为什么同一个项目要配置两个格式化工具？我们可以看有些著名的开源项目如：React、VSCode 等就是两个都使用了，所以都用上自然有他们的道理。

首先 **Prettier 分为 VSCode 插件和 Node 命令行工具**，我们要搞清楚 EditorConfig 和 Prettier 的区别，就要先搞清楚 Prettier 的 VSCode 插件和 Node 命令行工具的区别。

Prettier 的 VSCode 插件和 Node 命令行工具本质上的区别在于：

- Prettier 插件是用于替换 VSCode 默认的 Formatter，开发者可以在编码的期间使用 VSCode 快捷键 <kbd>alt</kbd> + <kbd>shift</kbd> + <kbd>f</kbd> 触发格式化操作
- Prettier 命令行工具是用于让开发者可以在命令行中通过使用 Prettier 提供的命令进行代码的格式化。但是通常我们不会在命令行中直接使用，而会与 eslint 以及 lint-staged 搭配使用**（后面会提到）**

他们俩的共同点就是都会通过**读取 `.prettierrc` 配置文件，或者 `package.json` 项目配置文件中 prettier 属性里配置的格式化规则来设置其格式化风格**。而不同的是 Prettier VSCode 插件还会读取插件设置界面中配置的格式化规则来设置其格式化的风格。

EditorConfig 和 Prettier 本质上的区别在于：

- EditorConfig 的配置文件格中的式化规则是**直接覆盖编辑器内默认 Formatter 的规则，并且他的格式化规则是不涉及具体语言的**，你配置了 `.editorconfig` 文件，当使用 VSCode 快捷键 <kbd>alt</kbd> + <kbd>shift</kbd> + <kbd>f</kbd> 进代码行格式化的时候，其格式化的代码风格就是 EditorConfig 所配置的风格。
- Prettier 的 VSCode 插件是**用于替代 VSCode 中默认的 Formatter，并且要根据具体的语言进行格式化。**你启用了插件，并把该插件作为 VSCode 的默认 Formatter 的同时还通过配置文件配置了其格式化规则。当使用 VSCode 快捷键 <kbd>alt</kbd> + <kbd>shift</kbd> + <kbd>f</kbd> 进代码行格式化的时候，其格式化的代码风格就是 Prettier 所配置的风格
- Prettier 命令行工具则是**用于与其他命令行工具搭配使用**，如：eslint、lint-staged 等

所以总的来说，EditorConfig 与 Prettier 插件的功能大概相同，只是一个用于覆盖 VSCode 默认 Formatter 的格式化规则，而另外一个则是用于替代 VSCode 默认的 Formatter，他们两个都属于编辑器插件类的东西，**一旦用 Prettier 插件替代了默认的 Formatter，那 EditorConfig 自然也就失效了。不过他们两个的配置文件内要是存在重合的格式化规则的时候，最好让他们保持一致！**而 Prettier 命令行工具则是与他们属于不同维度的东西，他作用于命令行中与其他命令行工具搭配使用，从而在不同维度让代码的风格保持一致。

好了啰嗦了那么多，其目的就是让大家能够搞清楚他们三个的关联关系，以至于达到知其然知其所以然的效果。

#### Prettier Node 命令行工具

在我们的项目中执行以下命令安装 Prettier 命令行工具，使其成为我们项目中的第一个依赖包：

```shell
# i是intall简写，-D则是--save-dev简写，整体表示为以本地开发依赖安装
npm i -D prettier
```

安装完后，在根目录新建 `.prettierrc` 配置文件，并输入以下配置规则：

```json
{
  "trailingComma": "all",
  "tabWidth": 2,
  "semi": true,
  "singleQuote": true,
  "endOfLine": "auto",
  "printWidth": 120
}
```

Prettier 官方秉承 opinionated 的原则，可以理解为独断专行，自以为是。所以其可配置的规则项还是很少的，大概 20 多个左右。大部分的规则已经按照社区的共识，以最佳实践、最好看的代码风格进行格式化了。下面就简单介绍上述的规则项，感兴趣的还可以去 [Prettier Playground](https://prettier.io/playground/) 把玩把玩：

- trailingComma：对象的最后一个属性末尾会添加逗号，如：`{ a: 1, b: 2, }`
- tabWidth：缩进大小（与 `.editorConfig` 的 `indent_size` 保持一致）
- semi：分号是否添加
- singleQuote：是否使用单引号
- endOfLine：换行符号（与 `.editorConfig` 的 `end_of_line` 保持一致）
- printWidth：单行代码最长长度，超过后会自动换行

因为目前我们还没有代码文件，所以也就没办法在命令行里用 Prettier 展示一番他的威力。

#### Prettier VSCode 插件

我们在 VSCode 中安装 [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) 插件：

![Prettier - Code formatter插件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201126183753.png)

插件安装完后，我们在项目的根目录新建一个 `.vscode` 文件夹，然后在此文件夹下再新建一个 `settings.json` 文件。虽然是 `.json` 后缀的文件，但是其实是 `jsonc` 格式的文件，`jsonc` 和 `json` 文件的区别就在于，是否能添加注释，而这个 `c` 就是 `cmmont`（注释）的意思。

而该文件与 VSCode 的全局配置文件 `settings.json` 一样，都是用于配置 VSCode 的。但是该文件的优先级会高于 VSCode 全局的 `settings.json`，这样当别人 clone 了项目进行协同开发，也不会因为全局的 `settings.json` 的配置不同而导致 prettier 或后面会讲到的 eslint 或 stylelint 失效，接下来我们暂时添加以下内容到文件中：

```json
{
  // 指定哪些文件不参与搜索
  "search.exclude": {
    "**/node_modules": true,
    "dist": true,
    "yarn.lock": true
  },
  // 指定哪些文件不被VSCode监听，预防启动VSCode时扫描的文件太多，导致CPU占用过高
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/*/**": true,
    "**/dist/**": true
  },
  // 保存时，自动进行一次代码风格格式化
  "editor.formatOnSave": true,
  // 配置VSCode使用Prettier插件替代默认的Formatter
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[less]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[scss]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[yaml]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

`editor.formatOnSave` 的作用是在我们保存时，自动执行一次代码风格格式化，而不同的代码该使用什么格式化器？接下来的配置便是设置各种代码的默认格式化插件为 prettier，而该插件便会根据先前在项目根目录创建的 `.prettierrc` 配置文件中所配置的规则进行代码风格格式化。

既然都创建了 `.vscode` 文件夹，那就顺带一提我们还可以通过在 `.vscode` 文件夹下新建 `extensions.json` 文件，在文件中配置一些用于向别人推荐的 VSCode 插件。在他们打开该项目时，如果有推荐的插件未安装 VSCode 就会提示用户安装，他们也可以在插件市场勾选过滤条件只显示推荐的插件来查看，配置如下：

```json
{
  "recommendations": ["esbenp.prettier-vscode"]
}
```

### 3. ESLint

在上面我们配置了 EditorConfig 和 Prettier ，他们俩都是为了**解决代码风格格式化的工具**，从解决的层面来说**前者是解决通用代码风格，后者是解决具体语言代码风格**。而 ESLint 则是**用作代码风格、代码质量的规范化工具**，虽然各种 lint 工具有一定的格式化代码的能力。但是其主要功能并不是负责代码格式化，所以代码格式化的工作就交由前面两个专门进行代码风格格式化的工具进行处理了。

ESLint 能在我们编写代码时帮助我们检测出代码可能出现的隐性问题，帮我们排除掉不良代码的“坏味道”，降低项目中 Bug 出现的机率，提高项目整体的代码质量。我们可以通过 ESLint 命令行工具提供的 `eslint --fix` 命令进行一些问题代码的转换。如：`var a = {}`，执行命令转换后：`const a = {}`。当然 ESLint 还有许多类似的强制转换代码为最佳写法的规则，而在无法自动转换时就会出现红线提示，强迫开发人员寻求更好的解决方案。

在我们的项目中执行以下命令安装 ESLint 命令行工具：

> 很多的依赖包即可以全局安装，也可以作为本地开发依赖或生产依赖来安装。但在这里我们都选择以本地开发依赖来安装。因为，我们没办法确保别人在开发这个项目的时候也全局安装了依赖包，而且以本地开发以来或生产依赖安装还能确保大家使用的版本一致，避免不必要的麻烦。

```shell
npm i -D eslint
```

安装成功后，执行以下命令，使用 ESLint 命令行工具所提供的交互式配置生成器，进行配置文件的生成：

```shell
npx eslint --init
```

在继续交互式配置文件生成介绍前，我们先来了解一下 `npx` 是什么。`npx` 是 npm 5.2 自带的一个命令，其中的 `x` 就是和文件类型描述符的那个 `x` 一样表示 `execute` 执行的意思。该命令的意思是，如果本地安装了 `eslint` 就会使用本地的 `eslint`，否则就会去全局中查找，若全局中也没有找到，就在临时目录下载 `eslint`，执行完毕后删除。也就是说我们可以用以下两种方式的其中一种代替 `npx`：

```shell
# 执行项目本地的eslint
./node_modules/.bin/eslint --init

# 或者全局安装，执行全局的eslint
npm i -g eslint
eslint --init
```

那这两种方式与 `npx` 对比，有什么缺点：

1. 第一种，命令中的路径过于长，输入命令执行时过于繁琐
2. 第二种，上面也说过全局安装就没办法确保别人也安装了，同时容易出现版本不一致的问题

了解完毕！我们回到交互式配置文件生成，执行完上述命令后命令行就会询问下面的问题，关于每一个问题的详细说明，大家感兴趣可以看一下这篇文章 [Setting up ESLINT in your JavaScript Project with VS Code](https://dev.to/devdammak/setting-up-eslint-in-your-javascript-project-with-vs-code-2amf):

- How would you like to use ESLint?

  我们选择第三条：`To check syntax, find problems, and enforce code style`，用于检查语法、检查问题代码并强制代码风格

- What type of modules does your project use?

  项目非配置代码都是采用的 ES6 模块系统导入导出，选择 `JavaScript modules (import/export) `

- Which framework does your project use?

  显然，我们需要选择 `react`

- Does your project use TypeScript?

  同样的毫无疑问的选择 `Yes`，这样 eslint 的配置文件会给我们默认添加上支持 TypeScript 的 `parse` 以及插件 `plugins` 等

- Where does your code run?

  `Browser` 和 `Node` 环境都选上，因为我们后面可能会编写一些 node 代码

- How would you like to define a style for your project?

  选择 `Use a popular style guide`，即使用社区已经制定好的代码风格，我们去遵守就行

- Which style guide do you want to follow?

  选择 `Airbnb` （爱彼迎）风格，都是社区里总结出来的最佳实践

- What format do you want your config file to be in?

  选择 `JavaScript`，即生成的配置文件是 js 文件，配置更加灵活，虽然灵活。但是 js 格式没办法使用 VSCode 提供的 JSON Validate 功能

- Would you like to install them now with npm?

  选择 `Yes`

经过漫长安装后，我猜你的项目根目录应该会长出了新的文件 `.eslintrc.js`，这便是 eslint 的配置文件了。其么默认的内容如下：

```javascript
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: ["plugin:react/recommended", "airbnb"],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 12,
    sourceType: "module",
  },
  plugins: ["react", "@typescript-eslint"],
  rules: {},
};
```

可以看到相对于非 TypeScript 项目，使用 `@typescript-eslint/parser` 替换掉了默认的 parse，并添加了 `@typescript-eslint` 插件。而配置中的各个属性字段的作用大家可以在 [Configuring ESLint](https://eslint.bootcss.com/docs/user-guide/configuring) 中详细了解，可能会对 `extends` 和 `plugins` 的关系产生疑惑，其实 `plugins` 就是插件的意思，都是需要 npm 包的安装才可以使用，只不过这里支持简写，所以看不出来而已。而 `extends` 就是已经下载的插件的某些预设规则。

现在我们对该配置文件作以下修改：

- 根据 [eslint-config-airbnb](https://www.npmjs.com/package/eslint-config-airbnb) 的官方说明，如果要开启 React Hooks 的检查，需要在 `extends` 属性中添加一项 `airbnb/hooks`

- 根据 [@typescript-eslint/eslint-plugin](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin) 的官方说明，在 `extends` 属性中添加
  `plugin:@typescript-eslint/recommended` 可以开启针对 TypeScript 的语法推荐的规则定义

- 为了让 `eslint-plugin-import` 能够正确解析 `ts` `tsx` `json` 等后缀名。我们还需要指定允许的后缀名，添加 `settings` 属性，加入以下配置：

  ```javascript
  settings: {
    'import/reslover': {
      node: {
        // 指定eslint-plugin-import解析的后缀名，出现频率高的文件类型放在前面
        extensions: ['.ts', '.tsx', '.js', '.json'],
      },
    },
  }
  ```

- 因为目前 `eslint-plugin-import` 与 TypeScript 搭配存在 Bug，需要添加一条很重要的 `rule`，不然在 `.ts` 和 `.tsx` 模块文件中引入另一个模块会报错，添加以下规则到 `rules` 即可：

  ```javascript
  // eslint-plugin-import和typescript搭配不能正确处理后缀名bug
  rules: {
    'import/extensions': [
      ERROR,
      'ignorePackage',
      {
        ts: 'never',
        tsx: 'never',
        json: 'never',
        js: 'never',
      },
    ],
  }
  ```

接下来安装 3 个社区中比较优秀的 eslint 插件：

1. `eslint-plugin-promise` 可以帮助你把 Promise 语法写成最佳实践
2. `eslint-plugin-unicorn` 提供了循环依赖检测，文件名大小写风格约束等非常使用的规则集合
3. `eslint-plugin-eslint-comments` 用于检测出无用的 `eslint-disable` 注释

执行以下命令进行安装上面 3 个 eslint 插件依赖包：

```shell
npm i -D eslint-plugin-promise eslint-plugin-unicorn eslint-plugin-eslint-comments
```

配置文件在作了部分修改后，现在配置文件的内容长这样：

```javascript
const OFF = 0;
const WARN = 1;
const ERROR = 2;

module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    "airbnb",
    "airbnb/hooks",
    "plugin:eslint-comments/recommended",
    "plugin:react/recommended",
    "plugin:unicorn/recommended",
    "plugin:promise/recommended",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 12,
    sourceType: "module",
  },
  settings: {
    "import/resolver": {
      node: {
        // 指定eslint-plugin-import解析的后缀名，出现频率高的文件类型放在前面
        extensions: [".ts", ".tsx", ".js", ".json"],
      },
    },
  },
  plugins: ["react", "unicorn", "promise", "@typescript-eslint"],
  rules: {
    // eslint-plugin-import和typescript搭配不能正确处理后缀名bug
    "import/extensions": [
      ERROR,
      "ignorePackages",
      {
        ts: "never",
        tsx: "never",
        json: "never",
        js: "never",
      },
    ],
  },
};
```

> 当然这还没完，在后面的配置过程中，我们还需要对 `.eslintrc.js` 配置文件进行更改。比如还要解决 eslint 和 pittier 规则冲突等问题，所以在这里先卖个关子。

此时我们就新建一个 `hello.ts` 文件，在文件内敲入以下代码：

```javascript
var add = (a, b) => {
  console.log(a + b);

  return a + b;
};

export default add;
```

此时你应该会发现没有任何的错误提示，很明显代码里使用了违反规则的变量定义符号 `var`，理论上来说 eslint 应该要报错，但没有报错。我们可以通过 OUTPUT 窗口得知，其实是因为 `@typescript-eslint/eslint-plugin` 这个插件需要我们安装 TypeScript 依赖，

![缺少typescript依赖](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201127132331.png)

虽然 TypeScript 部分的内容应该在后面才开始讲。但是为了 eslint 插件现在能够正常工作，我们就先执行以下命令安装 TypeScript 依赖：

```shell
npm i -D typescipt
```

安装完之后，再回头看看 `hello.ts` 文件的内容，就一堆红色波浪线了！

![eslint生效](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201127133702.png)

其实安装 ESLint VSCode 插件后，是能够支持自动修复功能的，所以我们安装 [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) 插件：

![ESLint插件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201127134336.png)

然后我们到先前创建的 `.vscode/settings.json` 配置文件中添加以下配置信息：

```json
{
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  // 代替VSCode的TS语法只能提示
  "typescript.tsdk": "./node_modules/typescript/lib",
  // 保存时，自动进行一次eslint代码修复
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

这时，我们回到 `hello.ts` 中，保存文件时，VSCode 就会通知 ESLint，而 ESLint 插件就会根据 `.eslintrc.js` 配置文件中的配置信息来修复问题代码，如下所示：

![ESLint保存时修复问题代码](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201127141242.gif)

不过有时候我们并不希望 ESLint 或 Prettier 对某些文件作任何修改，比如某个特定的情况下我想去看看打包后的内容。但是打包后的内容肯定不符合各种 lint 规则，但我又不希望在按下保存时对其进行修复，此时就需要我们创建两个配置文件 `.eslintignore` 和 `.prettierignore`，一般会保持这两个配置文件的内容一致，内容如下：

```text
/node_modules
/build
/dist
```

我们先添加以上三个比较常见的文件夹做忽略就好了，后续可以视情况添加更多需要忽略的文件或文件夹。

### 4. StyleLint

经过上面猛如虎的操作，项目里的 JS 或者 TS 代码已经能够保持较好的代码风格和代码规范了。但是除了他们两个，还有样式代码的代码规范要统一。这个的确很有必要，毕竟做事要做全套！

根据 [stylelint 官网介绍](https://stylelint.io/user-guide/get-started)，我们需要先执行以下命令安装两个依赖包：

```shell
npm i -D stylelint stylelint-config-standard
```

然后再项目根目录新建 `.stylelintrc` 配置文件，输入以下内容：

```javascript
module.exports = {
  extends: ["stylelint-config-standard"],
  rules: {
    "comment-empty-line-before": null,
    "declaration-empty-line-before": null,
    "function-name-case": "lower",
    "no-descending-specificity": null,
    "no-invalid-double-slash-comments": null,
  },
  ignoreFiles: ["node_modules/**/*"],
};
```

同样，简单介绍一下配上信息里的三个属性：

- extend：其实和 eslint 配置里的类似，都是扩展，使用 stylelint 已经预设好的一些规则
- rules：就是具体的规则，如果对默认的规则不满意，可以自己做具体的修改
- ignoreFiles：与 eslint 需要单独创建 ignore 配置文件不同，stylelint 配置文件里就支持忽略的属性字段。这里我们先添加 `node_modules` 和 `build`，后面视情况再做添加

> 其中关于 xxx/\*\*/\* 这种写法感兴趣的，可以 Google 一下：[glob 模式](https://www.google.com/search?q=glob%E6%A8%A1%E5%BC%8F)

和 eslint 一样，想要在编辑代码时有错误提示和自动修复功能，就需要 stylelint VSCode 插件
，所以我们安装 [stylelint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint) 插件：

![stylelint插件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201127145516.png)

安装完后，我们对先前的 `.vscode/settings.json` 配置文件，添加以下代码：

```json
{
  // 保存时，自动进行一次代码风格格式化
  "editor.formatOnSave": true,
  // 保存时，自动进行一次eslint和styleline代码修复
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.fixAll.stylelint": true
  },
  // 使用stylelint自身的校验即可
  "css.validate": false,
  "less.validate": false,
  "scss.validate": false
}
```

我们随便创建一个 `.less` 文件，测试一下刚刚的配置是否生效。可以看到在样式代码文件里，已经有错误提示和保存时的自动修复问题代码的功能了：

![stylelint保存时自动修复问题代码](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201127150647.gif)

现在我们可以再下载社区里一些比较优秀的 stylelint 扩展和插件：

- `stylelint-config-rational-order` 用于规范我们在书写样式属性时，按照以下的属性类型顺序来排序

```text
Positioning
Box Modal
Typography
Visual
Anumation
Misc
```

- `stylelint-declaration-block-no-ignored-properties` 用于提示我们写出的矛盾样式，比如下面 `css` 代码中的 `width` 属性是会被浏览器忽略，这样可以避免我们犯一些书写样式时的低级错误

```css
 {
  display: inline;
  width: 100px;
}
```

再来执行以下命令安装一波依赖：

```shell
npm i -D stylelint-order stylelint-config-rational-order stylelint-declaration-block-no-ignored-properties
```

安装完后，我们把 `.stylelintrc.js` 配置文件修改成以下内容：

```javascript
module.exports = {
  extends: ["stylelint-config-standard", "stylelint-config-rational-order"],
  plugins: [
    "stylelint-order",
    "stylelint-declaration-block-no-ignored-properties",
  ],
  rules: {
    "plugin/declaration-block-no-ignored-properties": true,
    "comment-empty-line-before": null,
    "declaration-empty-line-before": null,
    "function-name-case": "lower",
    "no-descending-specificity": null,
    "no-invalid-double-slash-comments": null,
  },
  ignoreFiles: ["node_modules/**/*"],
};
```

至此，关于 stylelint 的相关配置就暂告一段落啦！其实以上关于 stylelint 所配置的信息都是参考 [ant-design 的 stylelint 配置文件](https://github.com/ant-design/ant-design/blob/master/.stylelintrc.json)来进行配置的。但是，对于具体的规则以及插件大家都可以在其官网浏览查找，然后添加自己想要的规则定义。

### 5. 命令行中的 lint

在上面篇幅中，我们都是以 VSCode 插件的形式来使用到 lint，也提到过 lint 可以使用 lint 命令行工具所提供的命令来规范化我们的代码。当然 prettier 也能够通过 prettier 命令行工具所提供的命令来格式化我们的代码。

我们在项目配置文件 `package.json` 中的 `scripts` 属性添加以下配置信息：

```json
{
  "scripts": {
    "lint": "npm run lint-eslint && npm run lint-stylelint",
    "lint-eslint": "eslint -c .eslintrc.js --ext .ts,.tsx,.js src",
    "lint-stylelint": "stylelint --config .stylelintrc.js src/**/*.{less,scss,css}"
  }
}
```

这样，我们在控制台的命令行界面中执行 `npm run lint-eslint` 时，eslint 就会以 `.eslintrc.js` 配置文件里配置的代码规范， 到 `src` 文件夹下对指定后缀的代码文件内容进行检测，而 `npm run lint-stylelint` 也是类似原理。执行 `npm run lint` 的话会按顺序合并执行前两个指令。

我估计有小伙伴就会问，前面都已经在 `.vscode/settings.json` 配置文件里配置了保存代码时自动进行一次代码风格格式化（`editor.formatOnSave`）和代码规范修复（`editor.codeActionsOnSave`）了，为啥还需要配置 `package.json` 里 `scripts` 属性的 lint 命令？其实，这是为了提供给后面章节中提到的 lint-staged 使用的，而 lint-staged 是什么？跟着我继续走，很快你就会知道了！

### 6. 解决 lint 与 Prettier 的冲突

前面在 ESLint 小节开头里也说了， 虽然 lint 工具有一定的格式化代码的能力，但是其主要功能并不是负责格式化代码，所以格式化代码的工作就交由前面两个专门进行代码风格格式化的工具进行处理了。所以有时候 eslint 和 stylelint 的格式化规则会与 prettier 的格式化规则产生冲突，比如在配置文件 `.eslintrc.js` 中属性 `extends` 中的配置设置了缩进为 4，但是在配置文件 `.prettierrc` 中设置了缩进为 2，那就会出现保存时，先是 eslint 自定修复缩进为 4，然后 prettier 又不开心的把缩进改为 2，然后 eslint 也不开心，直接报错！

![ESLint与Prettier冲突](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201127162605.gif)

那已经冲突了，我们要如何解决呢？其实官方已经提供了很好的解决方案，在查阅 Prettier 官网文档中的 [Integrating with Linters](https://prettier.io/docs/en/integrating-with-linters.html) 章节可知，针对 eslint 和 stylelint 都有相应的插件支持解决该类问题，其原理基本都是禁用其与 prettier 发生冲突的规则，从而达到解决冲突的效果。

#### 1. 解决 ESLint 与 Prettier 的冲突

执行以下命令安装 [eslint-config-prettier](https://github.com/prettier/eslint-config-prettier) ，这样就可以禁用 eslint 中所有和 prettier 产生冲突的规则。

```shell
npm i -D eslint-config-prettier
```

安装完后，再到 `.eslintrc.js` 配置文件的 `extends` 属性中，添加以下配置：

```javascript
{
    extends: [
    // ...
    'prettier',
    'prettier/react',
    'prettier/unicorn',
    'prettier/@typescript-eslint',
  ],
}
```

这里需要注意，**新增的配置信息需要放在原来 `extends` 属性配置信息的最后面**，这样才能覆盖掉冲突的规则。

#### 2. 解决 Stylelint 与 Prettier 的冲突

Stylelint 与 Prettier 的冲突解决方法是与 ESLint 的解决方法一样的，先执行以下命令安装 [stylelint-config-prettier](https://github.com/prettier/stylelint-config-prettier)：

```shell
npm i -D stylelint-config-prettier
```

安装完后，再到 `.stylelintrc.js` 配置文件的 `extends` 属性中，添加以下配置：

```javascript
{
  extends: [
    // ...
    'stylelint-config-prettier'
  ]
}
```

同样要注意，**新增的配置信息需要放在原来 `extends` 属性配置信息的最后面**，这样才能覆盖掉冲突的规则。

### 7. lint-staged

我们前面已经成功的让代码在保存时，就自动的格式化并规范化所编写的代码，乍一看，好像是挺完美了！但是，其实在 commit 代码文件到 git 时，是可能会有漏网之鱼的。那有没有一种办法就是在代码 `git commit` 前帮我们把 git stage 区（暂存区）的代码文件，再进行一次格式化和规范化？

答案，是有的，而且还有俩：

1. [pretty-quick](https://github.com/azz/pretty-quick)
2. [lint-staged](https://github.com/okonet/lint-staged)

不过我们这里选择使用 lint-staged，因为 pretty-quick 功能比较单一，只是提供了 prettier 格式化 stage 区代码的功能，没办法配合 eslint 和 stylelint 一同使用，而且还不能通过配置文件来加以配置。而 lint-staged 就更加灵活，通过他我们可以同时配合 eslint, stylelint, prettier 一起使用，正可谓一个字，爽！

为了达到在我们每次 `git commit` 前，都自动的格式化和规范化代码，我们需要给 git 命令配置钩子，使其可以在 commit 前先执行我们的命令。这里我们使用 [husky](https://github.com/typicode/husky) 工具就可以很轻松的达到这样的目标。

先执行以下命令安装 husky 和 lint-staged 依赖包：

```shell
npm i -D husky lint-staged
```

> 这里需要注意，已经 `git init` 初始化过 git 本地仓库后才能安装 husky 依赖包。因为在安装 husky 时 husky 会在 `.git\hooks` 文件夹里配置 git 的钩子脚本，如果还未初始化 git 本地仓库就没有 `.git\hooks` 文件夹，就会导致 husky 配置钩子脚本失败。但是你已经不幸的先安装 husky 了，那么可以先执行 `npm uninstall -D husky` 卸载已经安装了的 husky 依赖包，然后再来初始化本地 git 仓库后，执行上面的脚本重新安装 husky 即可。

随后，回到 package.json 配置文件，添加以下代码：

```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "*.{ts,tsx,js}": ["eslint -c .eslintrc.js"],
    "*.{less,scss,css}": ["stylelint --config .stylelintrc.js"],
    "*.{ts,tsx,js,json,html,yml,less,scss,css,md}": ["prettier --write"]
  }
}
```

以上的配置大概的意思是，在我们 `git commit` 后，会先对 git stage 区中后缀为 `.ts` `.tsx` `.js` 的文件进行 eslint 规范校验，`--config` 的作用是指定配置文件。之后的同理，也是对后缀为 `.less` `.scss` `.css` 的文件进行 stylelint 校验。需要注意的是，我们在这里并没有添加 `--fix` 来进行自动修复不符合规则的代码，因为 lint 出的代码问题，可能涉及到具体语法层面的东西，所以需要我们人为判断才能进行修复，否则很容易出现问题。

但是对于 prettier 的话，由于其格式化不涉及具体语法层面的东西，所以我们使用 `--write` 来格式化所有符合后缀匹配文件里的内容。

> 另外，可能大家看到一些教程或者项目里头，会发现他们配置 lint-staged 还加了 git add 命令，实际上 lint-staged 在 V10 版本开始，任何被修改了的原 staged 区的文件都会自动被 git add。所以，我们不需要再自己配置上 git add 命令了。

## 统一代码提交规范配置

在多人协作的项目中，如果 git 的提交说明足够清晰准确，那么在后期协作以及 bug 处理时就会变得有据可查。并且还可以根据规范的提交说明快速生成开发日志，从而方便开发者或者用户追踪项目的开发信息和功能特性。建议大家阅读 [Commit message 和 Change log 编写指南（阮一峰）](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)

### 1. commitlint

[commitlint](https://github.com/conventional-changelog/commitlint) 可以帮助我们在执行 `git commit -m "message"` 时，对 `"message"` 进行格式规范的检查。而 commitlint 有一个扩展 [conventinal-changelog](https://github.com/conventional-changelog/commitlint) 可以帮助我们根据格式规范化后的 git message 快速生成 changelog。另外还有一个支持在命令行中进行可视化 `git commit` 的插件 [commitizen](https://github.com/commitizen/cz-cli)，但我们这里就不进行配置了，感兴趣的同学可以自行了解。

首先执行以下命令，安装 commitlint 相关依赖包：

```shell
npm i -D @commitlint/cli @commlint/config-conventional
```

[@commitlint/config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional) 类似 `.eslintrc.js` 配置文件中 `extends` 属性的扩展，他是官方推荐的 angular 风格的 commitlint 配置，提供了一些对于 commint message 的 lint 规则。

他默认支持的提交类型有以下这几个：

```json
[
  "build", // 改变了build 工具，如：webpack
  "ci", // 持续集成的相关变更
  "chore", // 构建过程或辅助工具的变动
  "docs", // 文档变更
  "feat", // 新功能
  "fix", // 修复Bug
  "perf", // 性能优化
  "rafactor", // 某个功能重构
  "revert", // 撤销上一次commit
  "style", // 样式代码变更
  "test" // 自动化测试变更
]
```

我们在项目根目录创建配置文件 `.commitlintrc.js`，这就是我们的 commitlint 配置文件，配置以下代码：

```javascript
module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "type-enum": [
      2,
      "always",
      // 比默认值多了一个 deps，用于表示依赖增、删、改等提交
      [
        "build",
        "ci",
        "chore",
        "deps",
        "docs",
        "feat",
        "fix",
        "perf",
        "refactor",
        "revert",
        "style",
        "test",
      ],
    ],
  },
};
```

然后，我们回到 `package.json` 配置文件，在 `husky` 属性里增加一个用于执行 commitlint 的 git 的钩子：

```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint --config .commitlintrc.js -E HUSKY_GIT_PARAMS"
    }
  }
}
```

当我们调用 `git commit -m "message"` 时，git 的 `commit-msg` 钩子就会把保存 commit message 的文件路径临时赋给环境变量 `HUSKY_GIT_PARAMS`，然后 `commitlint` 就会去 lint 这个文件中的 commit message。

我们接着再配置自动生成 changelog，执行以下命令安装 conventional-changelog-cli 依赖包：

```shell
npm i -D conventional-changelog-cli
```

再回到 `package.json` 配置文件，在 `scripts` 属性里配置多一个新的命令：

```json
{
  "scripts": {
    "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s"
  }
}
```

这样我们就可以在命令行中通过 `npm run changelog` 来生成 angular 风格的 changelog 了，`conventional-changelog` 会读取提交历史中 type 为 `fix` `feat` 等的 commit message 自动生成 changelog。

现在就来测试一下我们上面所配置的，有没有如预期一样正常运行吧！我们执行以下不规范的 commit message 命令进行提交变更（规范的 commit message ，其 type 应为 chore，所以应该 commitlint 应该会报错）：

```shell
# 提交所有变更文件到暂存区
git add -A
# 把暂存区的所有变更文件提交到分支
git commit -m "chora: add commitlint to force commit style"
```

如预期那样，出现了如下图的报错：

![commitlint报错](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201129013626.png)

那我们把 commit message 中的 type 进行更正，就能成功 commit 啦！更正后的 commit 脚本如下：

```shell
git commit -m "chore: add commitlint to force commit style"
```

这时我们就成功的 commit，然后再执行以下命令就能把变更提交到远端的 git 版本管理服务器：

```shell
git push origin master
```

呼，经历了那么漫长的配置之路，我们终于搭建了一个较为完善的项目开发环境。前面这些只是餐前小菜，而接下来才是真正的正菜，我们需要开始在当前这个环境之上把 Webpack 相关的东西加进来，搭建起真正可以进行项目开发的环境，是不是有点期待？那就带着期待一起往下走吧！

## Webpack 基本配置

相信看到这里的你，应该是把上面的章节都实践了一遍。如果没有的话，也没有关系！因为下文的内容，其实也可以做为以 Webpack 为构建打包工具，搭建起项目开发环境的一个参考。你可以参考其中使用到的配置，了解其在整个项目环境流程中起到的作用并加深记忆，还可以考虑是否能把他们配置到你现有的开发环境里。

对于 Webpack 的基本配置，都会尽可能的以详细解释和具体操作去把所有产生的问题全部打破，希望大家还是能够耐心阅读！

> 请注意，下文中的：Webpack 版本为 4+ ，Webapck CLI 版本为：3+，Webpack Dev Server 版本为 3+

### 1. 事前准备

想要使用 Webpack，那就得执行以下命令安装两个关于 Webpack 的项目开发依赖包：

```shell
# 限定安装大版本为4的Webapck，和大版本为3的Webapck CLI
npm i -D webpack@4 webpack-cli@3
```

- webpack：这个应该不用多做解释，前端项目常用的项目构建打包工具
- webpack-cli：此依赖包是 Webpack 的命令行工具，用于在命令行中使用 Webpack

接着我们在项目根目录下创建一个新的文件夹 `scripts`，在文件夹内再创建一个文件夹 `config`，在 `config` 文件夹里头创建一个 `.js` 文件 `webpack.common.js`，此时目录结构应该如下：

```text
scripts/
  config/
  webpack.common.js
```

这样设计目录结构的原因是，我们会分为开发构建环境和生产构建环境，而这两个构建环境所使用的 Webpack 脚本中的配置有相同的部分也有不相同的部分，相同的部分我们一般都放在所创建的 `webpack.common.js` 通用构建打包配置文件内，不同的部分就另外分别创建两个环境的构建打包配置文件。然后后续会把这两个环境的配置文件和通用配置文件中的配置信息通过 `webapck-merge` 依赖包进行合并处理。

### 2. 配置 input, output

**input（入口）和 output（出口）**是 Webpack 的核心概念之一，顾名思义就大概能猜到他们是用来干嘛的，入口就是给 Webpack 指定一个或多个构建打包的入口及其对应的出口，Webpack 经过一系列的构建操作打包操作后就把产出物输出到对应的出口中。（注：可以多个出口 js 文件对应一个 html 模板，也可以多个出口 js 文件对应多个 html 模板，需要通过 Webpack 的 `html-webpack-plugin` 插件配合处理）

接下来在刚创建的通用构建打包配置文件 `webpack.common.js` 中输入以下代码：

```javascript
const path = require("path");

module.exports = {
  entry: {
    app: path.resolve(__dirname, "../../src/app.js"),
  },
  output: {
    filename: "js/[name].[hash:8].js",
    path: path.resolve(__dirname, "../../dist"),
  },
};
```

> Webpack 构建打包配置文件是标准的 Node.js 的 CommonJS 模块，通过 `require` 来引入其他模块，通过 `module.exports` 来导出模块，由 Webpack 根据对象定义的属性进行解析。

- `entry` 属性定义了入口文件路径，其值支持字符串、数组、对象类型，对象值类型支持定义多入口。而上面以对象类型作为其值，且属性名 `app` 可用于出口文件名字
- `output` 属性定义了构建打包之后的出口文件名及其所在路径

这段代码的意思就是告诉 Webpack，入口文件是项目根目录下的 `src` 文件夹里的 `app.js` 代码文件。构建打包产出的文件位置为项目根目录下的 `dist` 文件夹，其中 `filename` 属性值为 `js/[name].[hash:8].js` 就表示会在 `dist` 文件夹内创建一个新的 `js` 文件夹，并把产出的文件以入口属性名以及带有八位的 hash 值作为文件名输出到 `js` 文件夹中。

然后我们在根目录创建 `src` 文件夹，并创建 `app.js` 代码文件，其内容为：

```javascript
const root = document.querySelector("#app");
root.innerHTML = "hello world!";
```

现在我们到项目配置文件 `package.json` 中的 `scripts` 属性，添加一条 Webpack 的打包命令：

```json
{
  "scripts": {
    // ...
    "build": "webpack --config ./scripts/config/webpack.common.js"
  }
}
```

然后我们尝试执行一下刚刚所添加的打包命令是否有效，输入以下命令执行 Webapck 打包命令：

```shell
npm run build
```

大概一两秒后，就会发现命令行中有结果反馈，并且项目根目录下会多出一个 `dist` 文件夹，里面的文件和我们在 Webpack 构建打包配置文件中，所配置的预期是一致的：

![构建打包结果反馈](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201129205834.png)

到这里，我们已经初步使用 Webpack 进行了一次简单的构建打包，接下来我们逐步开始拓展其他的配置和进行相应的优化吧！

### 3. 公共变量文件

在上面简单的 Webpack 配置中，我们发现有两个表示路径的代码语句：

```javascript
path.resolve(__dirname, "../../src/app.js");
path.resolve(__dirname, "../../dist");
```

- `path.resolve` 是 Node.js 路径处理的 api，可以将路径或者路径片段解析成绝对路径
- `___dirname` 是 Node.js 提供的一个全局变量，其值总是指向被执行 js 文件的绝对路径。比如我们在 `webpack.common.js` 配置文件中的代码里使用到了 `__dirname`，那么他的值就是 `webpack.common.js` 配置文件的绝对路径，在我电脑上就是：

```text
H:\Projects\Front\webpack-typescript-react-practice2\scripts\config\webpack.common.js
```

相信大家也看出来了，这种写法需要不断的 `../../`，这在文件层级比较深时，很容易出错且有点不优雅。那我们可以换个思路，都从项目根目录开始找所需要的文件路径不就很简单了吗？相当于省略了 `../../`。

我们在 `scripts` 文件夹下创建 `constants.js` 代码文件，用于存放我们的公共常量，在里面定义我们的常量：

```javascript
const path = require("path");
const { ModuleResolutionKind } = require("typescript");

const PROJECT_PATH = path.resolve(__dirname, "../");
const PROJECT_DIRNAME = path.parse(PROJECT_PATH).name;

module.exports = {
  PROJECT_DIRNAME,
  PROJECT_PATH,
};
```

- `PROJECT_PATH` 表示项目的根目录
- `PROJECT_DIRNAME` 表示项目目录名称

然后我们修改 `webpack.common.js` 配置文件，修改完后的内容如下：

```javascript
const path = require("path");
const { PROJECT_PATH } = require("../constants");

module.exports = {
  entry: {
    app: path.resolve(PROJECT_PATH, "./src/app.js"),
  },
  output: {
    filename: "js/[name].[hash:8].js",
    path: path.resolve(PROJECT_PATH, "./dist"),
  },
};
```

好啦，现在看起来清爽多了，此时可以执行命令 `npm run build` 验证一下刚刚做的修改是否可用。

### 4. 区分开发和生产构建环境

在 Webpack 中针对开发构建环境和生产的构建环境需要分别配置，这样才能适应不同的环境需求。比如，我们在生产构建环境中并不需要启用 dev server 的功能或者构建打包出代码的 `.map` 文件。又或者说在开发构建环境中，我们并不需要太过苛刻的代码或者文件压缩，此时就需要为两个环境做相应配置。

虽然需要分别配置，但是其实又有挺多基础配置是开发和生产都需要的，那我们不可能写两次关于基础的配置吧？这样就会造成冗余，所以我们把基础的配置写在 `webpack.common.js` 配置文件中，然后合并配置的问题就交给 `webpack-merge` 依赖包解决。

执行以下命令安装 `webpack-merge` 依赖包：

```shell
npm i -D webpack-merge
```

然后在 `scripts/config` 文件夹下创建配置文件 `webpack.dev.js` 作为开发构建的配置文件，且内容为：

```javascript
const { merge } = require("webpack-merge");
const common = require("./webpack.common");

module.exports = merge(common, {
  mode: "development",
});
```

同样地，在 `scripts/config` 文件夹创建配置文件 `webpack.prod.js` 作为生产配置文件，且内容为：

```javascript
const { merge } = require("webpack-merge");
const common = require("./webpack.common");

module.exports = merge(common, {
  mode: "production",
});
```

> 在使用 `require('webpack-merge')` 时，eslint 报了如下错误：
> 'webpack-merge' should be listed in the project's denpendencies, not devDependencies.
> 此时，我们只需要在 `.eslintrc.js` 配置文件中的 `rules` 属性里添加以下规则即可解决：
> `'import/no-extraneous-dependencies': [ERROR, { devDependencies: true }]`

虽然已经分开配置，但是在对于公共配置中，还是可能会出现某些配置的某个选项在开发和生产构建环境中需要采用不同的配置，这时候我们就有两种选择：

1. 分别在 `webpack.dev.js` 和 `webpack.prod.js` 配置文件中各写一遍，`webpack.common.js` 就不写了
2. 设置一个环境变量，根据这个变量进行判断不同的构建环境，然后把配置写在 `webpack.common.js` 中

显而易见，为了让配置的代码看起来较为优雅，我们还是采用第二种方案。但是非常不幸的是，由于不同操作系统设置环境变量的方式都各不相同，所以这就造成了一些麻烦。比如，

- Mac 中需要通过 `export NODE_ENV=development` 来设置环境变量
- Windows 中需要通过 `set NODE_ENV=development` 来设置环境变量

而 [cross-env](https://www.npmjs.com/package/cross-env) 是一个可跨平台设置和使用环境变量的 Node.js 命令行依赖包工具，所以有了这个利器，我们就无需考虑操作系统的差异性，统一使用他提供的 api 来进行环境变量的设置啦！

执行以下命令，安装 cross-env 依赖包：

```shell
npm i -D cross-env
```

然后到 `package.json` 配置文件中的 `scripts` 属性里添加以下代码：

```diff
{
  "scripts": {
+   "start": "cross-env NODE_ENV=development webpack --config ./scripts/config/webpack.dev.js",
+   "build": "cross-env NODE_ENV=production webpack --config ./scripts/config/webpack.prod.js"
-   "build": "webpack --config ./scripts/config/webpack.common.js"
  }
}
```

修改 `scripts/constants.js` 文件，增加一个用于环境判断的布尔变量 `ISDEV`：

```javascript
const ISDEV = process.env.NODE_ENV !== "production";

module.exports = {
  // ...
  ISDEV,
};
```

现在有了这个环境的判断变量，我们可以用他来做点事情啦！

还记得先前在公共配置中，我们给出口脚本文件的名字生成规则中配置了 `[name].[hash:8].js`。那为什么要配置上 `[hash:8]` 呢？我们可以想一下，如果不这么配置，当用户在第一次访问页面时，浏览器根据缓存策略，缓存下了名字为 `app.js` 的出口脚本文件。然后我们进行了代码修改后，再次使用 Webpack 构建打包，并且发布部署。此时，用户再次访问页面时，浏览器发现本地存在 `app.js` 脚本文件的缓存，并且该缓存还在有效期内，就直接使用了本地缓存的 `app.js` 脚本文件。这样就会造成用户无法及时获得脚本文件的更新，最终可能导致用户页面出现异常。

然而加上了`[hash:8]`之后就不同了，当用户在第一次访问页面时，浏览器根据缓存策略，缓存下了名字为 `app.1a2b3c4d.js` 的出口脚本文件。然后当我们进行了代码修改后，再次使用 Webpack 构建打包，并且发布部署。新的出口脚本文件名就会根据 hash 运算（内容摘要）后就进行更新，如 `app.5e6f7g8h.js`。那么用户再次访问页面时，由于其浏览器只缓存过 `app.1a2b3c4d.js` 并没有缓存过新的 `app.5e6f7g8h.js` 脚本出口文件，所以浏览器就会向服务器获取该新的出口脚本文件并再次缓存。

不过，这个 hash 值在开发构建环境中并不需要，所以我们修改 `webpack.common.js` 配置文件：

```diff
- const { PROJECT_PATH } = require('../constants');
+ const { PROJECT_PATH, ISDEV } = require('../constants');

module.exports = {
  output: {
-   filename: 'js/[name].[hash:8].js',
+   filename: `js/[name]${ISDEV ? '' : '.[hash:8]'}.js`,
    path: path.resolve(PROJECT_PATH, './dist'),
  },
};
```

> 关于 HTTP 文件缓存，欢迎阅读我另外一篇文章 [HTTP/前端文件缓存](/2019/08/01/http-cache/)

### 5. mode

在我们没有在 Webpack 配置文件里设置 `mode` 属性时，Webpack 默认地为我们设置了 `mode: production`，所以我们之前打包后的 js 代码文件里的内容都无法直视。因为在 `production` 模式下，Webpack 会使用 production 默认的 Webapck 配置去丑化、压缩代码等等。

所以我们要了解，不同模式下 Webpack 其实会为我们开启不同的默认配置，进行着不同的优化，详情可见阅读 Webpack 的官方文档中的 [webpack.mode](https://webpack.js.org/configuration/mode/#root) 章节。

然后接下来可以分别执行以下命令，看看分别打包有什么区别，主要感知我们上面所做的是否有效：

```shell
npm run start

npm run build
```

### 6. 本地服务实时查看页面

说了那么多，我们到现在连个页面都看不到，使用过各种脚手架的朋友一定很熟悉 `npm run start`，他直接开启一个本地服务，然后就弹出浏览器显示出页面。而我们现在执行这个命令却只能简单的打个包，那这可不行，别人有的我们也得有呀！ 别急，我们借助 [webpack-dev-server]() 和 [html-webpack-plugin]() 这两个依赖包就能实现，执行以下命令安装：

```shell
# 限定安装大版本为3的Webapck Dev Server与先前安装的Webpack CLI保持一致
npm i -D webpack-dev-server@3 html-webpack-plugin
```

简单介绍一下两个工具的作用：

- `webpack-dev-server` 可以在本地开启一个 http 服务，可以指定端口和开启热更新功能。通过简单的配置可以让他与我们的 Webpack 开发构建环境搭配使用
- `html-webpack-plugin` 每一个页面一定是要有 html 文件的，而这个插件可以帮助我们把构建打包产出的出口脚本文件自动的引入 html 模板文件中，并把经过处理的 html 模板文件输出到出口文件夹中（毕竟我们不可能每次构建打包都自己把出口脚本文件手动引入 html 模板文件中）

现在，我们现在项目根目录创建一个 `public` 文件夹，里面是用于存放一些公共的静态资源文件，现在我们在里面创建一个 `index.html` html 模板文件，内容如下：

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Webapck TypeScript React Practice</title>
  </head>
  <body>
    <div id="app"></div>
  </body>
</html>
```

因为 `html-webpack-plugin` 在开发和生产环境我们都需要配置，所以我们打开 `webpack.common.js` 配置文件，增加以下内容：

```javascript
// ...
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  // ...
  plugins: [
    new HtmlWebpackPlugin({
      template: path.resolve(PROJECT_PATH, "./public/index.html"),
      filename: "index.html",
      cache: false, // 防止之后使用v6版本的copy-webpack-plugin时，代码修改一刷新页面为空的问题发生
      minify: ISDEV
        ? false
        : {
            removeAttributeQuotes: true,
            collapseWhitespace: true,
            removeComments: true,
            collapseBooleanAttributes: true,
            collapseInlineTagWhitespace: true,
            removeRedundantAttributes: true,
            removeScriptTypeAttributes: true,
            removeStyleLinkTypeAttributes: true,
            minifyCSS: true,
            minifyJS: true,
            minifyURLs: true,
            useShortDoctype: true,
          },
    }),
  ],
};
```

可以看到配置中，我们以 `public/index.html` 作为我们的 html 模板文件，并且针对生产构建环境，还对该 html 文件进行了代码压缩、去除注释、去除空格等配置。

> Plugin 是 Webpack 的核心功能之一，他丰富了 Webpack 本身，针对的是 Loader 处理结束后，Webpack 打包的整个过程，他并不直接操作文件，而是基于事件机制工作。他会监听 Webpack 打包过程中的某些节点，执行较为宏观的任务。

随后，我们到 `webpack.dev.js` 配置文件中增加本地服务的配置, 如下：

```diff
...
+const { SERVER_HOST, SERVER_PORT } = require("../constants");

module.exports = merge(common, {
  ...
+ devServer: {
+   host: SERVER_HOST, // 指定host，不设置的话默认为localhost
+   port: SERVER_PORT, // 指定端口，不设置的话默认为8080
+   stats: "errors-only", // 重点仅打印error
+   compress: true, // 是否启用gzip压缩
+   open: true, // 打开默认浏览器
+   hot: true, // 热更新
+ },
});
```

我们在上面使用到了 `scripts/constants.js` 中的两个常量 `SERVER_HOST` 和 `SERVER_PORT`，所以我们需要在 `constants.js` 里定义他们：

```javascript
// ...
const SERVER_HOST = "127.0.0.1";
const SERVER_PORT = 3000;

module.exports = {
  // ...
  SERVER_HOST,
  SERVER_PORT,
};
```

其中提高开发幸福度的配置项为：

- `hot` 这个配置开启后，在搭配后面章节中的其他配置，可以开启开发时的热更新
- `stats` 当设置为 `error_only` 时，命令行中只会打印打错记录，这个配置我个人觉得相当有用。在日常开发中不会被一堆的 warn 记录塞满，比如一些 eslint 的规则提示、编译信息等等

现在配置好了关于本地服务的相关配置，我们需要到 `package.json` 配置文件中修改 `start` 命令：

```diff
{
  "scripts": {
+   "start": "cross-env NODE_ENV=development webpack-dev-server --config ./scripts/config/webpack.dev.js",
-   "start": "cross-env NODE_ENV=development webpack --config ./scripts/config/webpack.dev.js",
  }
}
```

然后确认一下，我们先前编写的 `src/app.js` 中的代码如下：

```javascript
const root = document.querySelector("#app");
root.innerHTML = "hello world!";
```

代码很简单，就是把 html 模板中 id 为 app 的 div 标签内的内容替换为 hello world! 字符串。我们执行以下命令，预览一下：

```shell
#npm run start的缩写形式
npm start
```

你会发现会自动打开浏览器，并且浏览器还打开了一个页面，而这个页面就是我们期待的那个页面。屏幕中出现了 hello world!，我们查看控制台，发现 html 文件真的就自动引入了我们使用 Webpack 构建打包后的出口文件 `app.js`。

![控制台界面](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201130145235.png)

到这里，我们就已经能利用 webpack-dev-server 开启的本地服务实时的进行页面开发了！当然，这远远还是不够的，我们还是会在后面一步一步继续优化。

### 7. devtool

devtool 中的一些设置，可以帮我们将构建打包（编译）后的代码映射回原始的源代码，即我们经常所听到的 sourcemap。如：Webpack, TypeScript, babel, powser-assert 等转换代码的工具都有提供 sourcemap 的功能，否则源代码被压缩、混淆、polyfill 后，就根本就没办法调试定位问题了。

所以 sourcemap 对于开发时调式起到了极其重要的作用，而不同类型的 sourcemap 会明显的影响到构建和重新构建的速度。所以根据环境选择一个合适的配置是非常重要的，可以查看官方文档 [devtool](https://webpack.js.org/configuration/devtool/) 章节，了解更多。

| devtool                        | 构建速度 | 重新构建速度 | 生产环境 | 品质（quality）        |
| ------------------------------ | -------- | ------------ | -------- | ---------------------- |
| (none)                         | +++      | +++          | yes      | 打包后的代码           |
| eval                           | +++      | +++          | no       | 生成后的代码           |
| cheap-eval-source-map          | +        | ++           | no       | 转换过的代码（仅限行） |
| cheap-module-eval-source-map   | o        | ++           | no       | 原始源代码（仅限行）   |
| eval-source-map                | -        | +            | no       | 原始源代码             |
| cheap-source-map               | +        | o            | yes      | 转换过的代码（仅限行） |
| cheap-module-source-map        | o        | -            | yes      | 原始源代码（仅限行）   |
| inline-cheap-source-map        | +        | o            | no       | 转换过的代码（仅限行） |
| inline-cheap-module-source-map | o        | -            | no       | 原始源代码（仅限行）   |
| source-map                     | -        | -            | yes      | 原始源代码             |
| inline-source-map              | -        | -            | no       | 原始源代码             |
| hidden-source-map              | -        | -            | yes      | 原始源代码             |
| nosources-source-map           | -        | -            | ye       | 无源代码内容           |

> `+++` 非常快速，`++` 快速，`+` 比较快，`o` 中等，`-` 比较慢，`--` 慢

考虑到编译速度、调式友好性，我在开发构建环境一般会先泽 `cheap-module-eval-source-map`，而在生产构建环境则会选择 `cheap-module-source-map`。**大家也可以故意的写错一些代码，然后使用以上的每个设置看看自己比较能接受哪一种 sourcemap 的类型，再做实际调整。**

然后到 `webpack.dev.js` 配置文件中添加以下代码：

```diff
module.exports = merge(common, {
  mode: 'development',
+ devtool: 'cheap-module-eval-source-map',
  devServer: {
    host: SERVER_HOST, // 指定host，不设置的话默认为localhost
    port: SERVER_PORT, // 指定端口，不设置的话默认为8080
    stats: 'errors-only', // 重点仅打印error
    compress: true, // 是否启用gzip压缩
    open: true, // 打开默认浏览器
    hot: true, // 热更新
  },
});
```

到 `webpack.prod.js` 配置文件中添加以下代码：

```diff
module.exports = merge(common, {
  mode: 'production',
+ devtool: 'cheap-module-source-map',
});
```

通过上面的配置后，我们在本地进行开发时，如果代码出现了错误，那么 Console 界面的错误提示就会精确的告诉我们错误的文件、位置等信息。比如我们在 `src/app.js` 中的第 5 行故意把代码写错：

```javascript
const root = document.querySelector("#app");
root.innerHTML = "hello world!";

const a = 1;
a = 2;
```

Console 界面里的错误提示我们，在 `app.js` 代码文件中的第 5 行代码出错了，具体的错误为 `Uncaught TypeError: Assignment to constant variable.`，赶紧修复吧！

![Console界面报错](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201130161300.png)

### 8. 构建打包前清理 dist 文件夹

好像一切看起来都挺完美了，但是真的完美了吗？如果你已经执行了多次 `npm run build` 后，就会发现事情并没有那么简单，请看下图：

![冗余的dist文件夹](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201130161920.png)

嗯？怎么 `dist\js` 文件夹下多出了那么多的 `app.xxxxxxxx.js` 的出口脚本文件，这貌似是因为每次执行 `npm run build` 后，Webpack 都是直接把产出的东西往里面扔就了事了呀。为了让我们最终构建打包时清除前一次的产出物，我们得想个办法解决这个问题。

既然发现了这个问题，那我们在每次构建打包前，都勤快的手动去清理一下 `dist` 文件夹内的上一次产出的文件不就好了？当然可以！但是这种勤快是毫无意义的。

我们可以借助 [clean-webpack-plugin](https://github.com/johnagan/clean-webpack-plugin) 帮助我们在每次构建打包前处理掉之前的 `dist` 文件夹，以保证其文件夹内的文件都是最新的产出物。执行以下命令安装依赖包：

```shell
npm i -D clean-webpack-plugin
```

然后到 `webpack.prod.js` 配置文件，增加一下代码：

```diff
...
+const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = merge(common, {
  ...
+ plugins: [new CleanWebpackPlugin()],
});
```

他不需要你去指定要删除的文件夹位置，他会自动的找到 `output` 属性中的 `path` 的值进行清除。现在再执行一下 `npm run build` 命令，看一下现在 `dist` 文件夹是不是已经干净了许多？并且还多了我们先前配置的 `devtool` 的 `.map` 文件。

### 9. 样式文件处理

如果现在我们在 `src/` 文件夹下创建一个 `app.css` 样式文件，给选择器 `#app` 随便添加一个样式，`app.js` 代码文件中通过 `import './app.css'`，再进行生产构建或者开发构建，Webpack 就会直接报错。因为 Webpack 只认识 `.js` 的代码模块文件，他不支持直接处理 `.css` `.less` `.scss` 等文件，所以我们需要借助 Webpack 另一个核心的东西，他的名字叫 Loader。

> Loader 用于对模块的源代码进行转换，Loader 可以使你在 `import` 模块文件时，处理文件内容。因此，Loader 类似于其他构件工具中的“任务（Task）”，并提供了处理前端构建步骤的强大方法。Loader 可以将文件从不同的语言，如 TypeScript 转换为 JavaScript，或将内联图像文件转换为 dataURL。Loader 甚至可以让你在 JavaScript 模块中 `import` CSS 样式文件，把 CSS 样式文件当做 JavaScript 模块使用。

#### 1. CSS 样式文件

处理 `.css` 样式文件，我们需要安装 [style-loader](https://github.com/webpack-contrib/style-loader) 和 [css-loader](https://github.com/webpack-contrib/css-loader) 两个 Webpack Loader 依赖包：

```shell
npm i -D style-loader css-loader
```

> 在 Webpack 构建打包时，当解析到 js 模块中有 `import` 后缀为 `.css` 的样式文件时，Webpack 会用 css-loader 去解析这个样式文件，解析过程中若在文件内出现了 `@import` 等语句就将相应的样式文件引入（所以如果没有 css-loader 的话，Webpack 就没办法处理 `import` 的 css 样式文件），然后 css-loader 再把整个 css 样式文件内容生成为代码字符串，接着让 style-loader 把生成的代码字符串内容以 style 标签的形式插入到 html 模板的 head 标签里。

安装完后，我们到 `webpack.common.js` 配置文件中，加入以下代码：

```javascript
module.exports = {
  entry: { ... },
  ouput: { ... },
  module:{
    rules: [
      {
        test: /\.css$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              sourceMap: ISDEV, // 开启后与devtool设置一致
              importLoaders: 0 // 指定在css-loader处理前使用的loader数量
            }
          }
        ]
      }
    ]
  },
  plugins: [ ... ]
};
```

简单的对以上配置做下介绍：

- `test` 字段是匹配文件后缀类型正则表达式，针对符合规则的文件进行所配置的 Loader 处理
- `use` 属性的值有几种写法
  - 字符串：例如我们只使用 style-loader 的话，那就可以写成 `use: 'style-loader'`
  - 数组：例如我们不对 css-loader 做 `options` 参数配置，那就可以写成 `use: ['style-loader', 'css-loader']`。若需要对某个 Loader 做参数配置可以参考上面的配置
  - 对象：例如只使用 css-loader 的话且需要进行 `options` 参数配置，那就可以写成 `use: { loader: 'css-loader', options: { importLoaders: 0 } }`

> Loader 是有顺序的，Webpack 肯定是先将 css 模块依赖解析完得到 css 代码字符串，才能把 css 代码字符串内容以 style 标签的形式插入到 html 模板的 head 标签中。
> 所以在上面的配置中 style-loader 放在了 css-loader 的前面，也就说明了**Webpack Loader 的执行顺序是从右到左，从下到上**的。

#### 2. less 样式文件

处理 `.less` 样式文件，我们还需要另外安装 [less](https://github.com/less/less.js) 和 [less-loader](https://github.com/webpack-contrib/less-loader) 两个依赖包：

```shell
# less-loader依赖less，less-loader用于Webpack解析less样式文件，less用于解析less语法
npm i -D less less-loader
```

> 如同 css 一样，当 Webpack 构建打包时解析到 js 模块中有 `import` 后缀为 `.less` 的样式文件时，Webpack 会用 less-loader 去解析这个样式文件，并把样式文件代码转换为 css 语法，文件转为 css 样式文件，然后再搭配 css-loader 和 style-loader 做接下来的处理。

安装完后，我们到 `webpack.common.js` 配置文件中，加入以下代码：

```javascript
module.exports = {
  entry: { ... },
  ouput: { ... },
  module:{
    rules: [
      ...
      {
        test: /\.less$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              sourceMap: ISDEV, // 开启后与devtool设置一致
              importLoaders: 1, // 需要先被less-loader处理，所以这里设置为1
            },
          },
          {
            loader: 'less-loader',
            options: {
              sourceMap: ISDEV, // 开启后与devtool设置一致
            },
          },
        ],
      }
    ]
  },
  plugins: [ ... ]
};
```

#### 3. SASS 样式文件

处理 `.sass` 样式文件，我们还需要另外安装 [node-sass](https://github.com/sass/node-sass) 和 [sass-loader](https://github.com/webpack-contrib/sass-loader) 两个依赖包：

```shell
# sass-loader依赖node-sass，sass-loader用于Webpack解析sass样式文件，sass用于解析sass语法
npm i -D node-sass sass-loader
```

> 如同 css 一样，当 Webpack 构建打包时解析到 js 模块中有 `import` 后缀为 `.sass` 的样式文件时，Webpack 会用 sass-loader 去解析这个样式文件，并把样式文件代码转换为 css 语法，文件转为 css 样式文件，然后再搭配 css-loader 和 style-loader 做接下来的处理。

继续在 `webpack.common.js` 配置文件中，加入以下代码：

```javascript
module.exports = {
  entry: { ... },
  ouput: { ... },
  module:{
    rules: [
      ...
      {
        test: /\.scss$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              sourceMap: ISDEV, // 开启后与devtool设置一致
              importLoaders: 1, // 需要先被less-loader处理，所以这里设置为1
            },
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: ISDEV, // 开启后与devtool设置一致
            },
          },
        ],
      },
    ]
  },
  plugins: [ ... ]
};
```

现在，通过上面的配置之后，我们再把 `src/app.css` 改为 `app.less` 或 `app.scss`，执行命令 `npm run start`，就会发现我们写的样式已经可以正常加载出来了。

#### 4. PostCSS 处理浏览器兼容问题

记得以前在写网页样式的时候，在涉及到 CSS3 的相关的样式语法时，都需要在前面加上浏览器的前缀做兼容性处理，当时就对 css 产生一种不好的印象，太麻烦了！而 PostCSS 就是来帮我们根据实际情况自动加上浏览器前缀的工具，大大减少了我们在编写样式时的顾虑。

> PostCSS 是 css 后处理器工具，因为有了 css，PostCSS 才能去处理他，所以叫后处理器
> less/sass 是 css 预处理器工具，因为他们需要把 `.less` 和 `.scss` 处理成 `.css`，所以叫预处理器

在这里我们主要用到以下几个 PostCSS 的插件依赖包：

- [postcss-flexbugs-fixes](https://github.com/luisrudge/postcss-flexbugs-fixes) 用于修复一些和 flex 布局相关的 bug
- [postcss-preset-env](https://github.com/csstools/postcss-preset-env) 将最新的 css 语法转换为目标浏览器环境能够理解的 css 语法，目的是使开发者在编写样式代码时不用考虑浏览器的兼容性问题
- [autoprefixer](https://github.com/postcss/autoprefixer) 用于自动添加浏览器前缀，处理样式语法兼容问题
- [postcss-normalize](https://github.com/csstools/postcss-normalize) 从 browserslist 中自动导入所需要的 normalize.css 内容

执行以下命令，安装相关依赖包：

```shell
npm i -D postcss postcss-loader postcss-flexbugs-fixes postcss-preset-env autoprefixer postcss-normalize
```

安装完后，再到 `webpack.common.js` 配置文件中，把 `postcss-loader` 的配置放在刚刚上面置完的 `css` `less` `scss` 里的 `css-loader` 后面，配置如下：

```javascript
{
  loader: 'postcss-loader',
  options: {
    // 这里要注意配置是包裹在postcssOptions属性中
    postcssOptions: {
      ident: 'postcss',
      plugins: [
        // 修复一些和flex布局相关的bug
        require('postcss-flexbugs-fixes'),
        // 参考browserslist的浏览器兼容表自动对那些还不支持的css语法做转换
        require('postcss-preset-env')({
          // 自动添加浏览器前缀
          autoprefixer: {
            // will add prefixes only for final and IE versions of specification
            flexbox: 'no-2009',
          },
          stage: 3,
        }),
        // 根据browserslist自动导入需要的normalize.css内容
        require('postcss-normalize'),
      ],
    },
    // 开启后与devtool设置一致
    sourceMap: ISDEV,
  },
}
```

但是，如果我们要为每一个之前所配置的样式 Loader 中都加一段这个代码的话，整个 `webpack.common.js` 配置文件会显得非常冗余，并且如果需要做修改的话，三个地方都得同步修改。所以我们可以把这里的公共部分的配置抽成一个函数，与 CRA 一致，命名为 `getCssLoaders`，因为新增了 `postcss-loader`，所以我们还需要修改 `css-loader` 的 `importLoaders` 参数的值，于是我们的 `webpack.common.js` 就变成如下这样：

```javascript
const getCssLoaders = (importLoaders) => [
  'style-loader',
  {
    loader: 'css-loader',
    options: {
      sourceMap: ISDEV, // 开启后与devtool设置一致
      importLoaders, // 指定在css-loader处理前使用的laoder数量
    },
  },
  {
    loader: 'postcss-loader',
    options: {
      // 这里要注意配置是包裹在postcssOptions属性中
      postcssOptions: {
        ident: 'postcss',
        plugins: [
          // 修复一些和flex布局相关的bug
          require('postcss-flexbugs-fixes'),
          // 参考browserslist的浏览器兼容表自动对那些还不支持的css语法做转换
          require('postcss-preset-env')({
            // 自动添加浏览器前缀
            autoprefixer: {
              // will add prefixes only for final and IE versions of specification
              flexbox: 'no-2009',
            },
            stage: 3,
          }),
          // 根据browserslist自动导入需要的normalize.css内容
          require('postcss-normalize'),
        ],
      },
      // 开启后与devtool设置一致
      sourceMap: ISDEV,
    },
  }
];

module.exports = {
  entry: { ... },
  output: { ... },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: getCssLoaders(1),
      },
      {
        test: /\.less$/,
        use: [
          ...getCssLoaders(2),
          {
            loader: 'less-loader',
            options: {
              sourceMap: ISDEV,
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        use: [
          ...getCssLoaders(2),
          {
            loader: 'sass-loader',
            options: {
              sourceMap: ISDEV,
            },
          },
        ],
      },
    ],
  },
  plugins: [ ... ]
}
```

最后，我们还要回到 `package.json` 配置文件中添加 `browserslist` 属性（指定项目针对的目标浏览器范围）：

```json
{
  "browserslist": [">0.2%", "not dead", "ie >= 9", "not op_mini all"]
}
```

现在，如果我们在入口文件 `app.js` 中，随便引入一个写了 `display: flex` 语法的样式文件，然后再执行命令 `npm start` 看看 PostCSS 是不是为我们自动加了浏览器前缀了？

### 10. 图片和字体文件处理

我们使用 file-loader 和 url-loader 来处理本地资源文件，比如：图片、字体文件等。而 url-loader 是对 file-loader 的封装，具有 file-loader 的所有功能，并且还提供了将低于阈值体积的图片装换成 base64 嵌入到页面中。但是，url-loader 并不依赖于 file-loader，所以一般我们只安装 url-loader 即可！

> 我忽然想起以前面试官问过的一个问题：使用 base64 有什么好处？我就觉得把图片转为 base64 嵌入到页面中的好处就是不用二次请求，而坏处很明显就是转为 base64 后的体积会变大。所以对于大小较小的图片可以选择通过 url-loader 转为 base64 嵌入到页面中，较大的则就保持独立文件单独请求。

执行以下命令，安装相关依赖包：

```shell
npm i -D url-loader
```

安装完后，我们到 `webpack.common.js` 中继续在 `modules.rules` 中添加以下代码：

```javascript
module.exports = {
  entry: { ... },
  ouput: { ... },
  module: {
    rules: [
      ...
      {
        test: [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/],
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 10 * 1024, // 图片低于10k会被转换成base64格式的dataUrl
              name: '[name].[contenthash:8].[ext]', // [hash]占位符和[contenthash]是相同的含义，都是表示文件内容的摘要值，默认是使用md5 hash算法
              outputPath: 'assets/imgaes', // 构建打包输出到出口文件夹的assets/images文件夹下
            },
          },
        ],
      },
      {
        test: /\.(ttf|woff|woff2|eot|otf)$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              name: '[name].[contenthash:8].[ext]',
              outputPath: 'assets/fonts',
            },
          },
        ],
      },
    ]
  },
 plugins: [ ... ]
}
```

简单对以上配置做下解释：

- `name` 属性的值表示输出的文件名为 `原来文件名.8位文件内容摘要.文件拓展名`，有了这个 8 位的文件内容摘要，可以防止图片更新后导致的缓存问题
- `limit` 属性的值表示，如果图片文件小于 `1024b`，即 `10kb`，那就使用 url-loader 把图片转为 base64 嵌入到网页中，否则就转而使用 file-loader 让图片保持独立文件
- `outputPath` 属性的值是以 `output.path` 的值为基准，既我们这里是以 `dist` 文件夹为基准，把图片或者字体文件通过构建打包流程后输出到 `dist/assets/images` 和 `dist/assets/fonts` 文件夹下

接下来，可以随便把本地一张图片放入项目的 `src` 文件夹中，并创建一个文件 `demo.tsx` 然后在其中通过 `import` 引入该图片。

不幸的是会出现以下错误：

![tsx引入图片错误](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201130223738.png)

可幸的是，可以通过在 `src` 下创建 TypeScript 类型定义文件 `typings/file.d.ts`，即可解决问题！其内容为：

```javascript
declare module '*.svg' {
  const path: string;
  export default path;
}

declare module '*.bmp' {
  const path: string;
  export default path;
}

declare module '*.gif' {
  const path: string;
  export default path;
}

declare module '*.jpg' {
  const path: string;
  export default path;
}

declare module '*.jpeg' {
  const path: string;
  export default path;
}

declare module '*.png' {
  const path: string;
  export default path;
}
```

到这里，我们已经度过了重重难关，相信大家已经收获了不少新的知识。不过上面也只不过是 Webpack 的基本配置，目前我们的环境已经具备了 Webpack 的基本功能，接下下来我们还要让其达到完全支持 TypeScrtpt, React 以及关于开发构建环境和生产构建环境的优化，继续秉承着关关难过关关过的斗志向前进吧！

![加油](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201130230647.png)

## 支持 React

终于来到了关键的环节了，我们先通过以下命令安装 react 和 react-dom 依赖包：

```shell
# npm i -S是npm install --save的缩写
npm i -S react react-dom
```

其实当我们安装成功这两个依赖包后，就已经开始可以使用 jsx 语法了，我们在 `src` 文件夹下创建 `index.js` 代码文件，且内容改为如下代码：

```javascript
import React from "react";
import ReactDOM from "react-dom";
import App from "./app";

ReactDOM.render(<App />, document.querySelector("#app"));
```

把 `src/app.js` 中的内容修改为以下代码：

```javascript
import React from "react";

function App() {
  return <div className="app-content">Hello World!</div>;
}

export default App;
```

然后再把 `webpack.common.js` 配置文件中 `entry` 属性里的入口文件修改为 `index.js`：

```diff
module.exports = {
  entry: {
+   app: path.resolve(PROJECT_PATH, './src/index.js'),
-   app: path.resolve(PROJECT_PATH, './src/app.js')
  }
}
```

不过这时候，如果你尝试执行命令 `npm start` 或 `npm run build` 的话，都会报错：

![构建报错](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201130232621.png)

头上一万个问号，为什么呢？我们不是已经安装了 React 了吗？其实是因为 Webpack 根本不认识 jsx 语法，Webpack 需要 [babel-loader](https://github.com/babel/babel-loader) 这位“翻译官”进行预处理。

既然已经提到了 Babel，那么我非常建议看到这里的你先阅读一篇关于 Babel 的文章：[不容错过的 Babel7 知识](https://juejin.im/post/5ddff3abe51d4502d56bd143)，文章里为我们进行 Babel 的全方位介绍，看完再回来继续实践，我保证你一定会收获满满！虽然，我知道在认真阅读一篇文章时，再跳去阅读其他文章的方式很令人抗拒，但是由于该科普文章的确是会让我们对 Babel 的认识更上一层楼，所以强烈推荐！

到这里，我们应该执行以下命令安装有关 Babel 的依赖包：

```shell
npm i -D babel-loader @babel/core @babel/preset-react
```

[babel-loader](https://github.com/babel/babel-loader) 使用 Babel 解析代码文件，[@babel/core](https://babeljs.io/docs/en/next/babel-core.html) 是 Babel 的核心依赖，[@babel/preset-react](https://babeljs.io/docs/en/next/babel-preset-react) 是转译 jsx 语法的预设集合（Babel 插件的预设集合）。

我们在项目根目录创建 `.babelrc` 配置文件，并输入以下代码：

```json
{
  "presets": ["@babel/preset-react"]
}
```

[presets](https://babeljs.io/docs/en/presets) 是 Babel 的一些预设插件集合，比如 @babel/preset-react 一般会包含 @babel/plugin-syntax-jsx, @babel/plugin-transform-react-jsx, @babel/plugin-transform-react-display-name 这几个 Babel 插件。

接下来，我们到 `webpack.common.js` 配置文件，增加一下代码：

```javascript
module.exports = {
  entry: { ... },
  ouput: { ... },
  module: {
    rules: [
      ...
      {
        test: /\.(tsx?|js)$/,
        loader: 'babel-loader',
        options: { cacheDirectory: true },
        exclude: /node_modules/,
      },
    ]
  },
 plugins: [ ... ]
}
```

可以注意到，我们匹配的代码文件后缀只有 `.ts` `.tsx` `.js`，把 `.jsx` 的后缀排除在外了。那是因为，我们不可能在 ts 环境下再使用 `.jsx` 代码文件来写代码了，实在要用 jsx 语法的时候，直接用 `.js` 不香吗？

babel-loader 在执行的时候，可能会产生一些运行时的公共文件，造成代码体积冗余，同时也会降低构建打包的效率，所以我们在 `options` 属性内配置了 Babel 的 `cacheDirectory: true` 参数，让 Babel 在运行时把这些公共文件缓存起来，下次编译的时候就会快很多。另外建议给 Loader 指定 `include` 或 `exclude`，指定其中一个即可，这样同样可以提升构建打包时的效率。

现在，我们可以通过执行命令 `npm start` 看看效果了！**Babel 还有其他一些重要的配置，不过我们先把 TypeScript 给解决了再来继续回来倒腾 Babel。**

## 支持 TypeScript

Webpack 的模块系统只能识别 js 代码文件及其语法，遇到 jsx 语法、tsx 语法、图片、字体等文件就需要相应的 Loader 对其进行预处理，像图片、字体我们在上文中已经配置过了。为了支持 React，我们使用了 babel-loader 以及对应的 Babel 预设集合，如果现在要支持 TypeScript 我们也需要对应的 Babel 预设集合。

### 1. 安装对应 Babel 预设集合

@babel/preset-typescript 是 Babel 的一个 preset，他编译 TypeScript 时的过程比较粗暴，直接去掉其 ts 类型声明，然后再用其他 Babel 插件进行编译，所以他的速度很快。

废话少说，执行以下命令安装相关依赖包：

```shell
npm i -D @babel/preset-typescript
```

> 注意：由于先前我们在配置 eslint 的时候，先安装了 TypeScript，所以这里就不用再安装了。

然后到 `.babelrc` 配置文件，进行以下修改：

```json
{
  "presets": ["@babel/preset-react", "@babel/preset-typescript"]
}
```

Babel 配置文件里的 presets 的执行顺序与 Webpack 配置文件里的 Loader 是一样的，都是从右往左，从下往上的执行，但 Babel 的 plugins 就与其相反。

### 2. tsx 语法测试

我们在 `src` 文件夹下创建一下两个 `.tsx` 文件，内容分别如下：

`index.tsx`

```javascript
import React from "react";
import ReactDOM from "react-dom";
import App from "./app";

ReactDOM.render(<App name="aaron" age={18} />, document.querySelector("#app"));
```

```typescript
import React from "react";

interface IProps {
  name: string;
  age: number;
}

function App(props: IProps) {
  const { name, age } = props;

  return (
    <div className="app-content">
      <span>{`Hello my name is ${name}, ${age} years old.`}</span>
    </div>
  );
}

export default App;
```

很简单的代码，在 `<App />` 组件中传 props 时，因为有了 ts 所以有了良好的智能提示。比如不输入 `name` 或 `age`，那么就会报错，因为在 `<App />` 组件中，这两个 prop 是必传的值。

但是，这个时候如果我们执行命令 `npm run start`，是会报错的。我们应该还得到 `webpack.common.js` 配置文件，做如下修改：

```javascript
module.exports = {
  entry: {
    app: path.resolve(PROJECT_PATH, './src/index.tsx'),
  },
  ...
  resolve: {
    extensions: ['.tsx', '.ts', '.js', '.json'], // 经常被import的文件后缀放在前面
  }
}
```

主要做了以下两点修改：

1. 修改了 `entry` 属性中的入口代码文件后缀，改为了 `.tsx`
2. 新增了 `resolve` 属性，并在 `resolve.extensions` 中定义好了文件后缀名，这样当我们在 import 某个代码文件的时候，就可以省略后缀名了

> Webpack 会按照 `resolve.extensions` 中所定义的后缀名顺序依次查找代码文件，比如我们定义了 `['.tsx', '.ts', '.js', '.json']`，那么 Webpack 会先把 `import` 的代码文件名尝试加上 `.tsx` 后缀在文件夹下查找，若找不到就会依次尝试查找。所以我们在配置时应该尽可能的把常用的后缀放在前面，这样可以缩短 Webpack 的查找时间，提升构建打包的效率

这个时候，我们再执行命令 `npm start`，就能正常显示页面啦！

不过既然都用上了 TypeScript，那 React 的 ts 类型声明自然就不能少，执行以下命令安装相关依赖包：

```shell
npm i -D @types/react @types/react-dom
```

### 3. tsconfig.json 详解

每个 TypeScript 项目都需要有一个 `tsconfig.json` 配置文件，其作用简单的解释就是：

- 编译指定的文件
- 定义了编译选项

一般都会把 `tsconfig.json` 配置文件放在项目根目录下，我们执行以下命令来生成该配置文件：

```shell
npx tsc --init
```

打开生成的 `tsconfig.json` 配置文件，可以看到里面有很多注释和几个配置，有点乱。可以将内容替换为以下内容：

```json
{
  "compilerOptions": {
    /* Visit https://aka.ms/tsconfig.json to read more about this file */

    /* Basic Options */
    "target": "es5", // 编译成哪个版本的ES
    "module": "ESNext", // 指定生成哪个模块系统的代码
    "lib": ["dom", "dom.iterable", "esnext"], // 编译过程中需要引入的库文件列表
    "allowJs": true, // 允许编译js文件
    "jsx": "react", // 在.tsx代码文件里支持jsx
    "isolatedModules": true,

    /* Strict Type-Checking Options */
    "strict": true, // 启用所有严格类型检查选项

    /* Module Resolution Options */
    "moduleResolution": "node", // 指定模块解析策略
    "baseUrl": "./", // 根路径
    "paths": {
      "Src/*": ["src/*"],
      "Components/*": ["src/components/*"],
      "Utils/*": ["src/utils/*"]
    }, // 路径解析
    "esModuleInterop": true, // 支持CommonJS和ES模块之间的互操作性

    /* Experimental Options */
    "experimentalDecorators": true, // 启用实验性的ES装饰器
    "emitDecoratorMetadata": true, // 给源码里的装饰器声明加上设计类型元数据

    /* Advanced Options */
    "skipLibCheck": true, // 忽略所有的声明文件（*.d.ts）的类型检查
    "forceConsistentCasingInFileNames": true // 禁止对同一个文件的不一致的引用
  },
  "exclude": ["node_modules"]
}
```

介绍一下以上配置中的几个配置属性：

- `complierOptions` 是用来配置 TypeScript 编译选项的，他的完整的可配置属性可以到 TypeScript 中文网[编译选项章节](https://www.tslang.cn/docs/handbook/compiler-options.html)中查询到
- `type` 和 `module` 这两个属性其实在我们这里并没有什么用，他们要通过在命令行中执行 `tsc` 命令进行 ts 编译时才有用。但是实际上我们已经使用 Babel 去编译我们的 ts 语法了，根本不会使用 `tsc` 命令，所以他们在这里的作用就是让编译器提供错误提示
- `isolatedModules` 可以提供额外的一些语法检查

  - 比如不能重复 `export`

    ```javascript
    import { add } from "./utils";

    add();

    export { add }; // 会报错
    ```

  - 比如每个文件必须是独立的模块

    ```typescript
    // a.ts
    const print = (content: string) => {
      console.log(content);
    }; // 会报错，没有模块导出

    // b.ts
    export print = (content: string) => {
      console.log(content)
    } // 必须要有export
    ```

- `esModuleInterop` 允许我们导入符合 es6 模块规范的 CommonJS 模块，下面做简单演示：

  比如某个包 `test`：

  ```javascript
  // node_moduls/test/index.js
  exports = test;
  ```

  在我们项目中的 `app.tsx` 代码文件中使用此包：

  ```javascript
  import * as test from "test";

  test();
  ```

  开启 `esModuleInterop` 后，我们可以直接以下面这种方式使用此包：

  ```javascript
  import test from "test";

  test();
  ```

- `strict` 属性的值我们这里设置为 true ，就表示启用所有严格类型检查选项，既然上了 TypeScript 的船，就用最严格的类型检查，拒绝 AnyScript
- `exclude` 指定了不需要编译的文件，我们这里设置了只要是 `node_modules` 下的代码文件，我们都不进行编译。当然，也可以使用 `include` 去指定需要编译的代码文件，一般两个之中用一个就可以了

接下来我们单独的讲一下 `baseUrl` 和 `paths` 这两个配置属性，这两配置属性可是提升开发效率的利器呀！他们的作用就是快速定位某个文件，防止在我们 `import` 时，出现多层 `../../../` 的这种写法。

比如现在我的 `src` 文件夹下有这么几个代码文件：

![文件目录](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201021328.png)

我在 `app.tsx` 中要引入 `src/compoments` 下的 `Header` 组件的话，以往的方式应该为：

```javascript
import Header from "./components/Header";
```

此时可能大家都觉得，好像还可以，没啥毛病。但这是因为 `app.tsx` 和 `components` 是同级，试想一下如果在某个层级很深的文件里要用到 `components` 文件夹里的组件时，那 `import` 语句就是疯狂的 `../../../..` 了，所以我们要善用 `baseUrl` 和 `paths` 这两个配置属性，并结合 Webpack 配置文件里的 `resolve.alias` 搭配使用，这样才能提升写代码的幸福指数呀！

但是想用好他们，还是有点麻烦的，首先 `baseUrl` 属性的值一定要设置正确，我们的 `tsconfig.json` 配置文件是放在项目根目录的，那么 `baseUrl` 属性的值就应该设置为 `./` ，表示为项目的根目录。于是，`paths` 属性中的每一项路径映射，比如 `["src/*"]` 其实就是相对于 `baseUrl` 属性的值来定位，也就是相对于项目根目录。

如果大家像上面一样进行了配置，并自己尝试以一下方式进行模块的引入：

```javascript
import Header from "Components/Header";
```

就会发现报错了，并且是 eslint 报的错：

![eslint报错](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201022815.png)

这个时候就需要修改 `.eslintrc.js` 配置文件了，首先我们先执行以下命令安装依赖包：

```shell
npm i -D eslint-import-resolver-typescript
```

然后到 `.eslintrc.js` 配置文件的 `settings` 属性，进行以下修改：

```javascript
{
  settings: {
    'import/resolver': {
      node: {
        // 指定eslint-plugin-import解析的后缀名，出现频率高的文件类型放在前面
        extensions: ['.ts', '.tsx', '.js', '.json'],
      },
      // 配合eslint-import-resolver-typescript解决ts的import时的路径映射问题
      typescript: {},
    },
  },
}
```

没错，只需要在 `settings['import/resolver']` 中添加 `typescript: {}` 就可以了，这时候再回去看，是不是已经没有报错了！

但是上面的工作仅仅是解决编译器中 eslint 识别路径映射时的报错问题，我们还需要在 `webpack.common.js` 配置文件中的 `resolve.alias` 属性配置相同的映射规则，来解决 Webpack 在构建打包时的路径映射识别。

```javascript
module.exports = {
  ...
  resolve: {
    ...
    alias: {
      Src: path.resolve(PROJECT_PATH, './src'),
      Components: path.resolve(PROJECT_PATH, './src/Components'),
      Utils: path.resolve(PROJECT_PATH, './src/utils'),
    }, // 配置import时的路径映射
  },
  ...
}
```

到此，`tsconfig.json` 和 `webpack.common.js` 配置文件中关于路径映射的配置就保持一致了，那么就可以正常的进行开发啦！可能到这里，有的小伙伴会产生疑惑，我只配置 `webpack.common.js` 中的 `resolve.alias` 属性不就好了？虽然，开发的时候会有报错提示，但并不影响到代码的正确性，毕竟在开发构建打包和生产构建打包的过程中 Webpack 都会进行路径映射的替换。是的，的确是这样，但是在 `tsconfig.json` 中进行路径映射的配置，会给我们增加智能提示。比如我们在 `import` 输入路径时，我们输入到 `import Header form 'Com'` 编辑器就会给我们提示补全正确的路径 `import Header from 'Components'`，而且其文件夹下的文件还会继续提示。

**如果参与过较为庞大的项目，存在文件层级很深的情况时，就会明白编辑器的智能提示到底有多香了！**

## 更多 Babel 配置

我们先前已经使用 Babel 去解析 React 和 TypeScript 的语法了，但是目前我们所做的也就如此而已。我们在项目中编写的 ES6+ 语法，在 Webpack 构建打包后还是会被原样输出，然而并不是所有的浏览器环境都支持 ES6+ 语法，这时候就需要 Babel 的 [@babel/preset-env](https://babeljs.io/docs/en/next/babel-preset-env.html) 预设集合来帮我们做高级语法转译的这个苦力活了。他会根据设置的目标浏览器环境，也就是我们上面在 `package.json` 配置文件里设置过的 `browserslist` 属性里的配置信息，根据这个配置信息找出所需要的插件去转译 ES6+ 语法，比如 `const` 或 `let` 转译为 `var`。

但是，遇到 `Promise` 或者 `Array.prototype.map` 这类新的 api 时，是没有办法用直接转译来解决的。除非我们用低版本的代码实现此类新的 api ，然后再把实现的 api 代码注入到构建打包后的代码文件中填充所缺失的 api。虽然 @babel/preset-env 可以做这项工作，但是他在做这项工作时会直接在原生对象上挂载实现的代码，这样就会造成原生对象污染的问题发生。还好 Babel 还有一个宝藏插件 [@babel/plugin-transform-runtime](https://www.babeljs.cn/docs/babel-plugin-transform-runtime) ，他和 @babel/preset-env 预设集合一样都能提供新 api 的垫片，都可以实现按需加载，但前者不会污染原型链。

另外，Babel 在编译每一个模块在需要的时候他会插入一些辅助函数，例如 `_extend`。每一个需要的模块都会插入这么一些辅助函数，这就很明显的造成了代码的冗余了，而 Babel 的 @babel/plugin-transform-runtime 插件会将所有的辅助函数都从 @babel/runtime 中导入（我们下面使用 @babel/runtime-corejs3），从而减少此类代码的冗余，可见这个插件的确是一个好同志！

执行以下代码，安装他们的依赖包：

```shell
npm i -D @babel/preset-env @babel/plugin-transform-runtime
npm i -S @babel/runtime-corejs3
```

> 需要注意的是 @babel/runtime-corejs3 为生成依赖包

修改 `.babelrc` 配置文件，如下：

```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "modules": false // 防止Babel将任何模块都转译成CommonJS类型，导致Webpack的tree-shaking失效
      }
    ],
    "@babel/preset-react",
    "@babel/preset-typescript"
  ],
  "plugins": [
    [
      "@babel/plugin-transform-runtime",
      {
        "corejs": {
          "version": 3,
          "proposals": true
        },
        "useESModules": true
      }
    ]
  ]
}
```

截至目前，我们 TypeScript + React 的项目开发环境已经可以用于正常的项目开发了，但是如果想要得到更好的使用体验，我们还要针对开发构建环境和生产构建环境做优化，让我们继续往下看吧！

## Webpack 公共构建环境优化

小伙伴们能跟着我走到这一步，非常不容易！而这一部分所做的是无论开发构建环境还是生产构建环境中都需要做的公共配置优化工作。

### 1. 拷贝公共静态资源

不知道大家有没有注意到，到目前为止，我们的开发页面还是没有自己的 icon，就是下图的这个东西：

![网页icon](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201144831.png)

与 CRA 一样，我们将 `favicon.ico` 文件放到 `public` 文件夹下，我们可以复制 CRA 中 `favicon.ico` 文件，我已经为你们准备好了一个[点击我](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20210218155414.ico)，然后在我们的 `index.html` 模板文件中加入以下标签：

```diff
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
+   <link rel="shortcut icon" href="/favicon.ico" type="images/x-icon" />
    <title>Webapck TypeScript React Practice</title>
  </head>
  <body>
    <div id="app"></div>
  </body>
</html>

```

这时候，如果我们执行命令 `npm run build`，可以看到 `dist` 文件夹下是没有 `favicon.ico` 文件的，那么 html 文件中的引入肯定也就没办法生效了。于是我们就希望有一个手段，能够在我们构建打包时把 `public` 文件夹下的静态资源通通都复制到我们出口文件夹 `dist` 中，反正我不会考虑手动去复制，所以我们还是使用 Webpack 的 [copy-webpack-plugin](https://github.com/webpack-contrib/copy-webpack-plugin) 插件吧。

执行以下命令，安装他的依赖包：

```shell
npm i -D copy-webpack-plugin
```

安装完后，我们到 `webpack.common.js` 配置文件中，增加以下代码：

```javascript
module.exports = {
  ...
  plugins: [
    ...
    new CopyWebpackPlugin({
      patterns: [
        {
          context: path.resolve(PROJECT_PATH, './public'),
          from: '*',
          to: path.resolve(PROJECT_PATH, './dist'),
          toType: 'dir',
        },
      ],
    }),
  ]
  ...
}
```

然后我们再次执行命令 `npm run build`，就会发现出口文件夹 `dist` 下就多了一个 `favicon.ico` 文件啦！然后也执行一下 `npm start`，不出意外浏览器也会显示出我们的小图标。同样地，其他的静态资源文件，大家只要往 `public` 文件夹下丢，Webpack 构建打包之后都会自动复制到 `dist` 出口文件夹下。

> 特别注意，我们在 Webpack 基础配置时，在配置 html-webpack-plugin 时，配置信息中有一项 `cache: false`。如果不加这一项的话，那么修改代码之后刷新页面，html 模板文件不会引入任何打包出来的 js 代码文件，自然也就没有执行任何 js 代码。这个问题 copy-webpack-plugin 官方 issue 里有提到过。

### 2. 显示构建打包进度

如果我们现在执行 `npm start` 和 `npm run build` 命令，控制台是没有任何信息能提示我们现在的进度到底怎么样。而一般来说构建打包的速度往往都需要一些时间，如果不是很熟悉项目的人，基本都会认为是不是卡住了，从而大大地提升了焦虑感。所以，显示进度是比较重要的，这是对开发者积极的正向反馈。

我们可以使用 [webpackbar](https://github.com/nuxt/webpackbar) 来显示进度，执行以下命令来安装他的依赖包：

```shell
npm i -D webpackbar
```

到 `webpack.common.js` 配置文件中，增加以下代码：

```javascript
module.exports = {
  ...
  plugins: [
    ...
    new Webpackbar({
      name: ISDEV ? '正在启动' : '正在构建打包',
    }),
  ]
  ...
}
```

现在我们再重新执行以下命令，就会发现有进度条提示了，特别令人安心。

### 3. 编译时的 TypeScript 类型检查

我们之前在配置 Babel 的时候提过，为了编译效率，Babel 在编译 TypeScript 时会直接将 ts 类型去掉，并不会对 ts 类型做检查。来看一个例子，来到我们之前创建的 `src/app.tsx` 文件，我故意解构出一个事先没有声明的属性 `wrong`，如下：

![编辑器中ts类型检查报错](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201153600.png)

可以看到，我尝试解构出的 `wrong` 是没有在 `interface IProps` 中声明的属性，在编辑器中肯定会被检测到并报错。但是，此时如果你执行命令 `npm start` 或 `npm run build` 的话，是可以正常的构建打包的。所以，可能在某一时刻某一个开发人员犯了这样的错误，但没有去处理这个问题，直到别人接手这个项目后，也不知道有这么一个问题，然后在执行构建打包命令时，就把这样的问题代码也一同给构建打包出来了！这样就完全丧失了 TypeScript 类型声明所带来的优势。

所以，我们需要借助 Webpack 的 fork-ts-checker-webpack-plugin 插件力量，他无论是在开发还是生产的构建打包时都会给我们进行 ts 类型的检查，并在检查到错误的时候给出准确的错误提示。

执行以下命令，安装相关依赖包：

```shell
npm i -D fork-ts-checker-webpack-plugin
```

安装完后，到 `webpack.common.js` 配置文件中，增加以下代码：

```javascript
module.exports = {
  ...
  plugins: [
    ...
    new ForkTsCheckerWebpackPlugin({
      typescript: {
        configFile: path.resolve(PROJECT_PATH, './tsconfig.json'),
      },
    }),
  ]
  ...
}
```

至此，我们再执行 `npm start` 或 `npm run build` 命令时，就会在命令行中出现错误提示了，如下：

![命令行中ts类型检查报错](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201155216.png)

### 4. 加速二次构建打包速度

我们这里所提到的”二次“指的是**首次构建打包后的每一次**。

有一个 Webpack 的神器插件就能大大滴提高二次构建打包的速度，他为程序中的模块（如：loadash）提供了一个中间缓存，并且把缓存放在了项目的 `node_modules/.cache/hard-source` 文件夹下，而这个神器插件就是 `hard-source-webpack-plugin`。在使用这个插件后，首次构建打包时可能耗时会比原来多一点，因为他要进行一些缓存工作，但在首次构建打包缓存后，之后的每次一构建打包都会变得快很多。

我们执行以下命令，来安装插件依赖包：

```
npm i -D hard-source-webpack-plugin
```

安装好后，我们到 `webpack.common.js` 配置文件，增加以下代码：

```javascript
module.exports = {
  ...
  plugins: [
    ...
    new HardSourceWebpackPlugin(),
  ]
  ...
}
```

这时候我们执行两次 `npm start` 或 `npm run build` 命令，看看所花费的时间对比图：

![构建打包时间对比图](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201161446.png)

当然，随着项目的变大，这个时间差距会更加明显！

### 5. externals 减少打包体积

到现在，我们无论是开发还是生产的构建打包，Webpack 都要先将 react, react-dom 等这些库代码打进我们最终的代码文件中。试想一下，当这种第三包变得越来越多的时候，最后构建打包出来的代码文件将会变得无比的大，用户在每次访问页面的时候，都需要下载一个那么大的文件，带来的就是首屏白屏时间变长，会严重影响用户体验。所以，我们将这种第三方依赖包剥离出构建打包的流程，采用 CDN 的形式引入。

到 `webpack.common.js` 配置文件中，增加一下代码：

```javascript
module.exports = {
  ...
  externals: {
    react: 'React',
    'react-dom': 'ReactDOM',
  },
  ...
}
```

在代码编写时，我们是这样使用 `react` 和 `react-dom` 的：

```javascript
import React from "react";
import ReactDOM from "react-dom";
```

那么，我们已经在 `webpack.common.js` 配置文件中配置了 `externals` 属性，让 Webpack 把 `react` 和 `react-dom` 剥离出构建打包的流程了，所以最终构建打包出的代码文件中肯定也就没有这两个库的代码了。那肯定要有另外的方式将他们的代码引入到页面中，不然程序就没办法正常运行了。

于是我们打开 `public/index.html` 模板文件，用 `script` 标签引入这两个库：

```diff
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="shortcut icon" href="/favicon.ico" type="images/x-icon" />
    <title>Webapck TypeScript React Practice</title>
  </head>
  <body>
    <div id="app"></div>
+   <script crossorigin src="https://unpkg.com/react@16.13.1/umd/react.production.min.js"></script>
+   <script crossorigin src="https://unpkg.com/react-dom@16.13.1/umd/react-dom.production.min.js"></script>
  </body>
</html>

```

> 库的版本可以到 `package.json` 中进行确认

然后，可以对比一下配置了 `externals` 属性前后的构建打包体积，会发现相差许多。

这个时候聪明的小伙伴就会疑惑了，我们好像无论配不配置 `externals`，最终需要下载的代码文件大小其实也是没有改变的呀。只不过一个是合在一个文件里一起下载，另一个是分开下载三个文件，大小都没有改变。其实并不是如此，这样做其实还有下面几个优势：

- http 缓存：当用户第一次下载后，之后每次进入页面，浏览器根据缓存策略，都不需要再次下载 `react` 和 `react-dom` 的代码文件
- 代码拆分：可以想象我们还没配置 `externals` 之前，`react` 和 `react-dom` 的代码最终都是会被 Webpack 与我们的业务代码一同构建打包到一起的，以至于我们业务代码哪怕做一丁点修改，那么构建打包时 `react` 与 `react-dom` 的代码也会一同再次参与打包。**而且 `react` 和 `react-dom` 的代码一般都不会改变，除非我们手动升级**
- Webpack 构建打包效率提升：由于不需要再构建打包 `react` 和 `react-dom` 的代码，所以 Webpack 的构建打包效率也会随之提升

> 其实还有另外两个方案也可以达到以上提到的这几个优势：
>
> 1. Webapck Dll：这个方案对 Webpack 的配置会相对复杂一些，需要使用到两个 Webpack 的内置插件 DllPlugin 和 DllReferencePlugin，并且该方案的侧重使用场景是用于提升开发环境的构建速度的
> 2. 配置 Webpack 的 `splitChunk` 属性：这个方案的话对 Webpakc 的配置就没有前一个那么复杂，但是该方案的侧重使用场景是把被多次引用的公共依赖单独拆分为一个独立的 chunk，以至于能够优化最后打包输出的 bundle 文件大小
>
> 仔细看这几个方案其实都各有各的使用侧重场景，如果我们要使用的话，还得根据实际场景来选择使用。另外，这两个方案在后面可能会提到。如果大家对 Webpack Dll 和 externals 之间的差异感兴趣，可以阅读这篇文章：[webpack dll VS external](https://blog.csdn.net/neoveee/article/details/80577216)。也可以可以查看这个问答了解 Webpack Dll 和 spilitChunks 的侧重使用场景：[webpack dllPlugin 是不是只用于开发环境？](https://segmentfault.com/q/1010000009492666)。

### 6. 抽离公共代码

#### 1. 动态 import 例子

在讲抽离公共代码前，我们先讲一下 ES6 中的懒加载在 Webpack 中的实现。懒加载是优化单页面应用（SPA）首屏加载的利器，下面我们来演示一个例子，让大家明白有什么好处。

一般情况下，我们在代码中引入某个工具函数是这样写的：

```javascript
import { add } from "./math.js";
```

但是如果这样直接引入的话，在 Webapck 打包之后 `math.js` 这个文件中的代码就会直接被打进最终的代码文件里，即使 `add` 这个方法不一定在首屏时就使用。那么带来的坏处也显而易见，我既然都在首屏时不需要用到他，却还要承担下载这个目前还用不到且多余的代码，最终造成首屏的加载速度变慢。

但是，如果我们现在以下面这种方式进行引入的话：

```javascript
import("./math.js").then((math) => {
  console.log(math.add(1, 2));
});
```

Webpack 就会自动解析这个语法，然后进行代码分割，构建打包出来后，`math.js` 代码文件中的代码就会被自动打成一个独立的 bundle 文件，只有我们在页面进行交互时调用到了这个方法，页面才会去下载这个 bundle 文件，并执行方法。

#### 2. React 组件懒加载

同样地，我们也可以对 React 组件进行这样的懒加载，我们使用 React 官方提供的懒加载方案的 `React.lazy` 方法和 `React.Suspense` 组件即可实现。下面做个简单演示：

我们到 `src/app.tsx` 代码文件，进行如下修改：

```typescript
import React, { Suspense, useState } from "react";

const ComputedOne = React.lazy(() => import("Component/ComputedOne"));
const ComputedTwo = React.lazy(() => import("Component/ComputedTwo"));

function App() {
  const [showTwo, setShowTwo] = useState<boolean>(false);

  return (
    <div className="app-content">
      <Suspense fallback={<div>loading...</div>}>
        <ComputedOne a={1} b={2} />
        {showTwo && <ComputedTwo a={3} b={4} />}
        <button type="button" onClick={() => setShowTwo(!showTwo)}>
          显示Two
        </button>
      </Suspense>
    </div>
  );
}

export default App;
```

创建 `src/components/ComputedOne/index.tsx` 代码文件，内容如下：

```typescript
import React from "react";
import { add } from "Utils/math";

interface IProps {
  a: number;
  b: number;
}

function ComputedOne(props: IProps): JSX.Element {
  const { a, b } = props;
  const sum = add(a, b);

  return <div>{`Hi, I'm computed one, my sum is ${sum}.`}</div>;
}

export default ComputedOne;
```

创建 `src/components/ComputedTwo/index.tsx` 代码文件，内容如下：

```typescript
import React from "react";
import { add } from "Utils/math";

interface IProps {
  a: number;
  b: number;
}

function ComputedTwo(props: IProps): JSX.Element {
  const { a, b } = props;
  const sum = add(a, b);

  return <div>{`Hi, I'm computed one, my sum is ${sum}.`}</div>;
}

export default ComputedTwo;
```

创建 `src/utils/math.ts` 代码文件，内容如下：

```typescript
function add(a: number, b: number): number {
  return a + b;
}

export { add };
```

接下来，我们执行命令 `npm run start` 并打开浏览器的控制台中的 Network 界面，会发现当我们点击”显示 Two“按钮时，页面会动态的去请求 `ComputedTwo` 组件的 bundle 文件并加载，如下：

![按需加载](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201182839.gif)

上面就是 React 组件懒加载的实现方式和效果展示，执行命令 `npm run build` 可以看到构建打包出以下文件：

![打包文件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201183213.png)

可以看到 Webapck 为我们的 `ComputedOne` 和 `ComputedTwo` 组件都分别构建打包出两个 bundle 文件 `1.9948ce68.js` 和 `2.9948ce68.js`，而这样带来的好处很明显：

- 通过懒加载引入的组件，若该组件代码不变，构建打包出的 bundle 名也就不会改变。当文件部署到生产环境后，由于浏览器的缓存策略，用户不需要再次下载该 bundle 文件，提高页面性能，降低服务器压力
- 可以防止把所有代码都打进主 bundle 里，降低主 bundle 的体积，减少页面首屏加载时间

#### 3. 配置 Webpack 的 splitChunks

从上文看来懒加载所带来的优势不容小觑，我们试着沿着这个思维向外延伸思考，如果我们能把一些引用的第三方依赖包也构建打包成单独的 bundle，是不是也会有类似的优势呢？

答案是肯定的，因为一般第三方依赖包只要版本锁定，代码就不会有太大的变化，就如我们刚刚配置 `externals` 时的两个库 `react` 和 `react-dom` 也是如此。那么我们每一次进行项目代码迭代时，都不会影响到第三方依赖包 bundle 文件的文件名，那么也就具有以上优势。

其实 webpack4 默认就有这个功能并且还默认开启了，但是我们要将第三方依赖包也打出独立的 bundle 的话，就需要到 `webpack.common.js` 配置文件中增加一下代码：

```javascript
module.exports = {
  ...
  optimization: {
    splitChunks: {
      chunks: 'all',
      name: true
    }
  }
  ...
}
```

> 这里我们临时来科普一下 Webpack 概念性的知识，在 Webpack 中主要有三个概念：
>
> 1. module：就是 js 模块化，Webpack 支持 CommonJS、ES6 等模块化规范，简单来说就是我们通过 `import` 引入的代码文件
>
> 2. chunk：chunk 是 webpack 根据功能拆分出来的东西，主要包含三种情况：Webpack 配置中的项目入口、通过 `import()` 动态引入的代码、通过 `spilitChunks` 拆分出来的代码。chunk 包含着 module ，他们可能是一对一也可能是一对多的关系
>
> 3. bundle：bundle 是 Webpack 打包后的各个文件，一般与 chunk 是一对一的关系，bundle 就是 chunk 经过 Webpack 编译压缩打包处理之后的产出物

这个时候，我们执行命令 `npm run build`，就会发现又多了一个前缀名为 `vendors` 的 bundle 文件，如下：

![打包文件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201190404.png)

这个 bundle 文件里放了一些我们没有通过配置 `externals` 剔除的第三方依赖包代码，**如果大家不想通过 CDN 形式引入 `react` 和 `react-dom` 的话，也可以不配置 `externals` 转而配置 `splitChunks` 将他们单独抽离出来。**另外，如果项目构建的是多页面应用，还需要加以配置 `splitChunks` 属性把公共模块也抽离出来，不过我们是搭建单页面应用开发环境，所以在这里就不演示了。

> 如果大家对 `splitChunks` 的配置感兴趣可以阅读这篇文章：[理解 webpack4.splitChunks](https://www.cnblogs.com/kwzm/p/10314438.html)

## Webpack 开发构建环境优化

这部分主要是针对开发构建环境使用体验的优化

### 1. 热更新

如果开发时忍受过稍微改一下代码，就要自己手动刷新页面，又或者稍微改一下代码，页面就自动重新刷新的痛苦，那么热更新一定得学会了！可能小项目会觉得没什么大不了，但是大项目里每一次修改刷新都是痛呀。

所谓热更新，其实就是页面只会对我们改动过的地方进行“局部更新”，不过这个说法可能也不太严谨，但是我们不用太抠细节，反正就是这么个意思。

而我们只要两个步骤就能开启热更新了，首先到 `webpack.dev.js` 配置文件中进行以下配置：

```diff
+const webpack = require('webpack');
const { merge } = require('webpack-merge');
const common = require('./webpack.common');
const { SERVER_HOST, SERVER_PORT } = require('../constants');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'cheap-module-eval',
+ plugins: [new webpack.HotModuleReplacementPlugin()],
  devServer: {
    host: SERVER_HOST, // 指定host，不设置的话默认为localhost
    port: SERVER_PORT, // 指定端口，不设置的话默认为8080
    stats: 'errors-only', // 重点仅打印error
    compress: true, // 是否启用gzip压缩
    open: true, // 打开默认浏览器
+   hot: true, // 热更新
  },
});

```

这个时候，我们执行命令 `npm start` 并尝试修改组件代码，保存后发现整个页面还是会刷新。如果我们希望达到上面所说的“局部更新”，还需要在项目入口文件 `src/index.tsx` 中进行以下修改：

```diff
import React from "react";
import ReactDOM from "react-dom";
import App from "./app";

+if (module && module.hot) {
+ module.hot.accept();
+}

ReactDOM.render(<App />, document.querySelector("#app"));
```

这时因为 ts 的原因，编辑器上会有报错提示，如下：

![ts报错提示](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201194541.png)

此时，我们只需要安装 @types/webpack-env 依赖包即可解决这个问题，执行以下命令安装依赖包：

```shell
npm i -D @types/webpack-env
```

现在，我们重新执行命令 `npm start`，再随便改个组件的代码看看，是不是不会整个页面刷新了？赞！此时，如果你修改了某个组件引入的样式的话就会发现有同样的效果，这是因为 Webpack 的 style-loader 实现了 Webpack HMR 的接口，所以当我们修改样式代码时，style-loader 就会收到 HRM 的修改通知，然后 style-loader 就会把处理好的样式代码交给 HMR，然后 HMR 就把代码更新到页面上。

### 2. React 保留状态热更新

我们在上一小节成功的配置了热更新，并且我们还知道了修改样式代码也会有局部热更新的效果的原因是因为 style-loader 实现了 Webpack HMR 的接口。如果仔细的小伙伴就会发现，我们目前的热更新是没办法保留住 React 组件状态的，也就是说当我们在页面组件的某一个状态进行组件代码修改的话，那么热更新将会把当前组件的状态丢失，如下：

![热更新React组件状态丢失](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201223618.gif)

在我们点击“显示 Two”后，`ComputedTwo` 组件就显示出来了，随后我们又修改了 `ComputedTwo` 组件的代码，然后就触发了热更新同时页面的组件状态也丢失了。

不过小伙伴们也不用太慌张，因为有一个 Webpack 的 Loader 能解决这个问题，而他就是 [react-hot-loader](https://github.com/gaearon/react-hot-loader)，但他并不是通过什么魔法手段来实现这个功能，只是他同样的也实现了上述的 Webpack HMR 接口，以至于他能够跟 style-loader 一样有类似的能力。

废话少说，就让我们执行以下命令，安装插件依赖包：

```shell
npm i -S react-hot-loader
npm i -D @hot-loader/react-dom
```

> 需要注意，react-hot-loader 要以生产依赖包的形式来安装，不用担心的是他在生产环境下不会被执行并且他会确保自己以最小的体积呈现。而 @hot-loader/react-dom 官方文档说是用来替换默认的 react-dom 来添加额外的热更新特性，用以支持 react hooks 热更新用的。

我们到 `.babelrc` 配置文件中添加 react-hot-loader 在 Babel 中的插件，如下：

```diff
{
  ...
  "plugins": [
    ...
+   "react-hot-loader/babel"
  ]
}
```

到 `webpack.common.js` 配置文件中的 `entry` 属性里的入口前加入 react-hot-loader 的热更新补丁，如下：

```diff
module.exports = {
  entry: {
+   app: ['react-hot-loader/patch', path.resolve(PROJECT_PATH, './src/index.tsx')],
-   app: path.resolve(PROJECT_PATH, './src/index.tsx'),
  },
  ...
}
```

到 `webpack.dev.js` 配置文件中添加 `resolve` 属性，并在其内配置 `alias[react-dom] = '@hot-loader/react-dom'` 使 @hot-loader/react-dom 在开发构建环境时代替 react-dom，如下：

```diff
...

module.exports = merge(common, {
  ...
+ resolve: {
+   alias: {
+     'react-dom': '@hot-loader/react-dom',
+   },
+ },
  ...
});
```

到 `src/index.tsx` 代码文件中添加 react-hot-loader 接管根组件代码，**hot 函数就是一个 hoc** 嘛，如下：

```diff
import React from 'react';
import ReactDOM from 'react-dom';
+import { hot } from 'react-hot-loader/root';
import App from './app';

if (module && module.hot) {
  module.hot.accept();
}

+ReactDOM.render(hot(<App />), document.querySelector('#app'));
-ReactDOM.render(<App />, document.querySelector('#app'));
```

好啦！我们现在可以再次执行命令 `npm start` 并重复上面验证热更新丢失状态的动作，会发现现在热更新已经不会丢失我们的 React 组件状态了，如下：

![热更新保留React组件状态](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201201231609.gif)

大功告成！

### 3. 后端接口代理

有时候我们在做开发时，可能所使用的后端接口并不受自己控制也不支持跨域请求，这时候就很苦逼的需要花时间来搭建一个接口代理。不过巧的是 webpack-dev-server 刚好提供了这个功能，而我们可以在 `webpack.dev.js` 配置文件中的 `devServer.proxy` 属性里配置接口代理实现跨域请求。但是，为了使构建环境的代码与业务代码分离，我们需要将配置文件独立出来。

在 `src` 文件夹下新建一个 `setApiProxy.js`，内容如下：

```javascript
const proxySettings = {
  "/api/": {
    target: "http://192.168.1.1:8080",
    changeOrigin: true,
  },
  "/api2/": {
    target: "http://182.168.1.2:8080",
    changeOrigin: true,
    pathRewrite: {
      "^/api2": "",
    },
  },
};

module.exports = proxySettings;
```

配置完成后，我们在 `webpack.dev.js` 配置文件中引入，并配置 `devServer.proxy` 属性，修改如下：

```diff
...
+const proxySetting = require('../../src/setApiProxy');

module.exports = merge(common, {
  ...
  devServer: {
    ...
+   proxy: { ...proxySetting }, // 配置接口代理
  },
});
```

这样就配置完成啦！大家可以自行测试一下是否可以正常使用。

## Webpack 生产构建环境优化

这部分主要是针对生活构建环境使用体验的优化

### 1. CSS 拆分

其实不瞒大家，现在我们所写的所有样式在 Webpack 的构建打包后都会存在于 js bundle 文件中。如果就这样放任下去，随时样式代码的增多，打包出来的 js bundle 文件就会越来越大，从而影响我们页面的性能。所以从 js bundle 中拆分出 css 势在必行！我们可以使用 Webpack 的 [mini-css-extract-plugin](https://github.com/webpack-contrib/mini-css-extract-plugin) 来执行这项任务。

执行以下命令，安装插件依赖包：

```shell
npm i -D mini-css-extract-plugin
```

安装完成后，在 `webpack.common.js` 配置文件中，增加和修改以下代码：

```diff
...
+const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const getCssLoaders = (importLoaders) => [
+  ISDEV ? 'style-loader' : MiniCssExtractPlugin.loader,
- 'style-loader'
  ...
];

module.exports = {
  ...
  plugins: [
    ...
+   !ISDEV &&
+     new MiniCssExtractPlugin({
+       filename: 'css/[name].[contenthash:8].css',
+       chunkFilename: 'css/[name].[contenthash:8].css',
+     }), // 判断生产环境下才使用mini-css-exract-plugin
+ ].filter(Boolean),
- ],
  ...
};
```

> 注意，**mini-css-extract-plugin 需要搭配他自己所提供的 Loader 一起使用，并且该 Loader 与 style-loader 互斥**，但是只有 style-loader 实现了 Webpack HMR 的热更新接口，另外开发环境中对于拆分 CSS 的也没有特别大的需求，所以我们就**需要判断只在生产环境中使用 mini-css-extract-plugin**。

此时，我们随便写点样式，然后执行命令 `npm run build`，就能发现 `dist` 目录下多了样式文件，如下：

![样式文件](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201202030814.png)

### 2. 去除无用样式代码

如果我们现在在写样式时，写了一些没有用到的样式代码时，Webpack 在构建打包时也会一起把这些没有用到的样式代码一起打进产出的 bundle 中，这显然是可以优化的地方呀。所以，这下又要用上另一个 Webpack 的神器插件 [purgecss-webpack-plugin](https://github.com/FullHuman/purgecss/tree/master/packages/purgecss-webpack-plugin)，不过使用他时还需要依赖一个路径查找利器 [node-glob](https://github.com/isaacs/node-glob)。

执行以下命令，安装相关依赖包：

```shell
npm i -D purgecss-webpack-plugin glob
```

安装完后，在 `webpack.prod.js` 中，增加以下代码：

```diff
...
+const path = require('path');
+const glob = require('glob');
+const PurgecssWebpackPlugin = require('purgecss-webpack-plugin');
+const { PROJECT_PATH } = require('../constants');

module.exports = merge(common, {
  ...
  plugins: [
    ...
+   new PurgecssWebpackPlugin({
+     paths: glob.sync(`${path.resolve(PROJECT_PATH, './src')}/**/*.{tsx,less,scss,css}`, +{ nodir: true }),
+   }),
  ],
});
```

简单解释一下上面的配置，`glob` 是用来查找文件路径的，我们使用 `glob.sync()` 方法以同步的方式找到 `src` 文件夹下后缀为 `.tsx` `.less` `.scss` `.css` 的文件路径并且以数组的形式赋值给 `paths` 属性。然后 purgecss-webpack-plugin 就会解析每一个路径对应的文件，将无用的样式去除，而 `nodir` 属性就是去除文件夹的路径，加快处理的速度。为了直观给大家看下 `glob` 获取的路径数组，打印出来长这个样子：

```json
[
  "H:/Projects/Front/webpack-typescript-react-practice2/src/app.scss",
  "H:/Projects/Front/webpack-typescript-react-practice2/src/app.tsx",
  "H:/Projects/Front/webpack-typescript-react-practice2/src/components/ComputedOne/index.tsx",
  "H:/Projects/Front/webpack-typescript-react-practice2/src/components/ComputedTwo/index.less",
  "H:/Projects/Front/webpack-typescript-react-practice2/src/components/ComputedTwo/index.tsx",
  "H:/Projects/Front/webpack-typescript-react-practice2/src/demo.tsx",
  "H:/Projects/Front/webpack-typescript-react-practice2/src/index.tsx"
]
```

> 要注意，一定要把引入样式的 `.tsx` 组件文件后缀配置到 `glob.sync()` 方法的参数中，不然 purgecss-webpack-plugin 没办法解析到底哪个样式有给是用到，自然也就无法正确的剔除没有用到的样式代码了。

此时，可以写一些没有被用到的样式代码，然后执行命令 `npm run build` ，看一下是不是没有了多余的代码！

### 3. 代码压缩

在生产构建打包环境中，压缩代码时必须要做的工作，毕竟这样做能够把产出的 bundle 文件体积减少一大半，何乐而不为？

#### 1. JavaScript 代码压缩

Webpack 4 中的 js 代码压缩神器 [terser-webpack-plugin](https://github.com/webpack-contrib/terser-webpack-plugin) 插件应该是无人不知了把？虽然网上很多教程都还在讲 Webpack 压缩代码的时候要使用 [uglifyjs-webpack-plugin](https://github.com/webpack-contrib/uglifyjs-webpack-plugin)，但是他早就被放弃维护了，而且他还不支持 ES6 语法，Webpack 的核心开发者 [evilebottnawi](https://github.com/evilebottnawi) 也都已经转向维护 terser-webpack-plugin 了。

虽然，在 Webpack 中 `mode` 为 `production` 时默认开启，没错！Webpack 4 完全内置 terser-webpack-plugin，不过为了能够对他进行一些额外配置，我们还是得安装他。

执行以下命令，安装插件依赖包：

```shell
# 由于我们使用的是Webpack 4，所以插件版本也要对应上
npm i -D terser-webpack-plugin@4
```

安装完后，到 `webpack.common.js` 文件中的 `optimization` 属性中，增加做增加以下配置：

```diff
...
+const TerserWebpackPlugin = require('terser-webpack-plugin');
...

module.exports = {
  ...
  optimization: {
+   minimize: !ISDEV,
+   minimizer: [
+     !ISDEV &&
+       new TerserWebpackPlugin({
+         extractComments: false,
+         terserOptions: {
+           compress: { pure_funcs: ['console.log'] },
+         },
+       }),
+   ].filter(Boolean),
    ...
  },
  ...
};
```

首先，我们在配置中增加了 `minimize` 属性，可以设置开启或关闭压缩。如果我们设置为 `true`，Webpack 就会默认使用 terser-webpack-plugin，反之就表示不压缩代码。接下来的 `minimizer` 属性就是用来指定压缩器的。

然后再简单介绍一下我们在 terser-webpack-plugin 中所做的配置：

- `extractComments` 设置为 `fasle` 意味着去除所有注释，除了带有特殊标记的注释，例如 `@preserve` 标识，后面我们用的一个插件就会用到这个标识
- `pure_funcs` 可以设置我们想要去除的函数，我们这里就设置把代码中的 `console.log` 函数给去除掉

#### 2. CSS 代码压缩

同样也是耳熟能详的 Webpack 插件 optimize-css-assets-webpack-plugin，执行命令直接安装：

```shell
npm i -D optimize-css-assets-webpack-plugin
```

然后同样到 `webpack.common.js` 配置文件的 `minimizer` 属性新增以下代码：

```diff
...
+const OptimizeCssAssetsWebpackPlugin = require('optimize-css-assets-webpack-plugin');
...

module.exports = {
  ...
  optimization: {
    minimize: !ISDEV,
    minimizer: [
      ...
+     !ISDEV && new OptimizeCssAssetsWebpackPlugin(),
    ].filter(Boolean),
    ...
  },
  ...
};
```

### 4. 添加版权声明

上面我们在配置 JavaScript 代码压缩的小章节中说过，打包时 terser-webpack-plugin 会把除含有特殊标识的其他所有注释都去除，而所谓的特殊标识就例如 `@preserve` 这种。我们希望自己的代码里可以有一些声明注释，就像 React 的包中就有类似的这些声明注释，我们可以使用 Webpack 内置的 BannerPlugin 插件来实现。

无需安装依赖包，直接到 `webpack.prod.js` 配置文件中，加入以下代码：

```diff
...
+const webpack = require('webpack');

module.exports = merge(common, {
  ...+
  plugins: [
    ...
+   new webpack.BannerPlugin({
+     raw: true,
+     banner:
+       '/** @preserve Powered by webpack-typescript-react-practice2 (https://github.com/aaronlam/webpack-typescript-react-practice2) */',
+   }),
  ],
});
```

这时候，执行命令 `npm run build` 构建打包，再看下输出的 bundle 代码文件，是不是就有注释啦！

### 5. tree-shaking

![摇树](https://cdn.jsdelivr.net/gh/aaronlam/imghosting@master/20201202153915.gif)

tree-shaking 的意思，通过上图应该就可以说明其意思了。而我们这里所说的 tree-shaking 可以理解为通过工具“摇”我们的 JS 代码文件，将其中用不到的代码“摇”下来。具体来说，Webpack 入口文件就相当于一棵树的主干，入口文件有很多依赖的模块相当于树枝，实际代码中可能依赖了某个模块，但是只使用了其中的某些功能，通过 Webpack 内置的 tree-shaking 就能把这些没有使用的代码摇掉，来到达删除无用代码的目的。而当 `mode` 属性的值为 `production` 时，也就是生产构建环境下，**Webpack 会根据 ES6 的模块语**法执行这项摇树任务。

举个例子，我们在 `src/utils/math.ts` 代码文件中，做以下修改：

```diff
...
+function minus(a: number, b: number): number {
+  return a - b;
+}

+export { add, minus };
-export { add };
```

回到我们的 `src/components/ComputedOne/index.tsx` 组件代码文件中，做以下修改：

```diff
...
+import { add, minus } from 'Utils/math';
-import { add } from 'Utils/math';
...
```

可以看到，我们在组件代码文件中同时引入了 `add` 和 `minus` 两个方法，但是实际上只使用了 `add` 方法，这时我们执行命令 `npm run build`，可以搜索一下 `ComputedOne` 组件的 bundle 文件中，是没办法找到关于 `minus` 的代码的，但是却能搜到关于 `add` 的代码，这就意味着 `minus` 因为没有被使用，而被 Webpack 通过 tree-shaking 去除了。

另外在我们开发项目的时候，如果能确保项目中所写的模块没有副作用，那么可以在 `package.json` 配置文件中设置 `sideEffects: false` 属性，那么当别人引用我们项目的时候 Webpack 就能够毫不留情的进行 tree-shaking。关于 `sideEffects` 属性的说明可以阅读 Webapck 官方文档的 [Tree Shaking 章节](https://webpack.js.org/guides/tree-shaking/)。

然后我们可以尝试回忆一下，先前在配置 `.babelrc` 配置文件的 @babel/preset-env 预设集合时，在其参数部分配置了 `modules: false`，目的就是让 Babel 不要把我们所写的 ES 模块转换成 CommonJS 模块。因为只有 ES 模块才能进行 tree-shaking，其原因主要是以下几个：

1. `import` 导入语句只能在模块顶层作用域中使用
2. `import` 的模块名只能是字符串常量
3. `import` 的 binding 为 immutable
4. ES 模块作用域中默认是严格模式，不会产生副作用

有了以上几个特点后，ES 模块就支持静态分析，以至于能够进行 tree-shaking 操作。

### 6. bundle 分析

有时候，我们想知道我们项目所构建打包的依赖包都有哪些、体积有多大、打包后的 bundle 是否合理，根据这些信息来进行进一步的项目优化。而这时我们就可以使用 Webpack 的 webpack-bundle-analyzer 插件来达前面提到的想法。

执行以下命令，安装其依赖包：

```shell
npm i -D webpack-bundle-analyzer
```

到 `scripts\constants.js` 文件，增加一下代码：

```diff
...
+const ISANALYZE = process.env.npm_config_report === 'true';
...

module.exports = {
  ..
+ ISANALYZE,
  ...
};

```

到 `webpack.prod.js` 配置文件，增加以下代码：

```diff
...
+const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');
+const { PROJECT_PATH, ISANALYZE } = require('../constants');
-const { PROJECT_PATH } = require('../constants');

module.exports = merge(common, {
  ...
  plugins: [
    ...
+   ISANALYZE &&
+     new BundleAnalyzerPlugin({
+       analyzerMode: 'server', // 开启一个本地服务查看分析报告
+       analyzerHost: '127.0.0.1', // 指定本地服务的host
+       analyzerPort: 2000, // 指定本地服务的端口
+     }),
+ ].filter(Boolean),
- ],
});
```

最后再回到 `package.json` 配置文件中的 `scripts` 属性中添加以下代配置信息：

```diff
{
  ...
  "scripts": {
+   "build-analyzer": "cross-env NODE_ENV=production npm_config_report=true webpack --config ./scripts/config/webpack.prod.js",
    ...
  }
  ...
}
```

最后，我们执行命令 `npm run build-analyzer` 就会自动打开浏览器并显示 bundle 分析页面，尽情享用吧！

## 总结

到此我们的路途也就结束了。虽然我知道估计应该没几个人会看到这里，不过还是想用记录来帮助自己加深学习。

其实我觉得整个搭建流程走下来还是挺流畅的，真正的做到了从 0 到 1 搭建属于自己的一个开发环境，当然也可以说是脚手架。在整篇文章中我都希望能够把每一个章节的细节都阐述清楚，把为什么要这么做的历史原因讲述给大家听，以至于在编写整篇文章时大部分时间都花在了查阅资料上。

我知道可能对于一些刚接触前端工程化的小伙伴来说可能会带来很大的压力，这是很正常的一件事，因为我刚开始接触时也是这样，而且当时还找不到比较体系化的资料来学习。不过我觉得如果能咬咬牙坚持看完做完，尽管第一遍下来可能很多地方都可能似懂非懂，但是我能保证一定能够帮助你构建一个宏观的概念，然后可以把这篇当做一本字典来使用。更重要的是我希望大家都能够从实践中领悟到探索精神，可怕不代表不可能，实践才能出真知！

这篇文章中的很多配置其实并非都是强耦合的，比如 TypeScript + React 就可以替换成 TypeScript + Vue，也可能有一些插件可以替换成更优秀的，这个就需要根据大家的实际情况去做调整了。
