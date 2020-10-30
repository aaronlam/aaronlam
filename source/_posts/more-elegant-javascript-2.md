---
title: 更优雅的JavaScript 2
date: 2020-1-15 21:31:00
tags:
  - JavaScript
  - 代码风格
categories:
  - 前端
---

接着上一文，在[更优雅的 JavaScript 1](/2019/12/13/more-elegant-javascript-1/)中，我们聊到了基础的 JavaScript 编写的建议。包括如何可靠的声明变量、常量、函数、以及利用合适的函数构建合适的逻辑，现在我们思考改善代码的第一步，如何命名？

在我们开始阅读代码之前，编码风格与命名方式会比代码的抽象方式、设计技巧更令我们印象深刻。很多时候也会为项目的整体风格定下基调。如果你阅读过一些算法工程师写的代码，常常会看到*单字母变量*、*反复的声明*，*不知所以的赋值与拷贝*、*累赘的条件判断*等等。我们虽不能说这样有问题，因为他们的代码大多的确是可以正常的运作，甚至在运行的时间或空间效率上有一些优势。但这在工程，特别是大型工程中是不值得称道的，根据经验我们可以把这类代码归类为“屎山”，充其量是“堆”了一摊高性能的“屎山”。

而我们现在做的则是脱离“编程只不过是工具”的阶段，脱离“屎山男孩”，让机器面有喜色、富有人性，使阅读者在某个瞬间也能切实的感受到创作者的思维跳动与审美哲学。

<!--more-->

# 1. 富有准确性的命名

事实上，你完全可以使用 `doSomeThing` 来命名所有的函数，毕竟它们真的只是提供某些微不足道的功能。但当你有了多个，甚至是成百上千个函数时，这将是一场灾难。这是一个浅显易懂的道理，即便是毫无经验的开发人员也会意识到命名爆炸的问题，他们隐约明白了什么是好的编程风格。但最后，甚至是大多数都止步于 `doSomeThing` 到“优美”之间的某一个站上。然后他们心里就默念，这就够了。

1.  命名只需要有必要的词，除非有需求，否则不要堆砌

```javascript
// bad
const theBook = {};
const _book = {};
const bookObj = {};
const theNewBook = {};

// good
const book = {};
```

2. 可读的条件判断

```javascript
// bad
if (username && username.includes("prefix-")) {
}

// bad
const prefix = username && username.includes("prefix-");

// bad
const availableName = username && username.includes("prefix-");

// good
const hasPrefixName = username && username.includes("prefix-");
```

3. 可读的函数

当我们要从网络上获取用户信息时，`getUser` 就不是一个准确的表达，`get` 太过于宽泛，它该表示是从数据库获取还是从网络获取？是以用户名获取还是用 ID 获取？这都有区别，现在我们可以先从命名的层面上思考它们的区别：

```javascript
// bad
const getUser = (name) => {};

// good
const fetchUserByName = (name) => {};

// good
const findOneUserByID = (id) => {};

// good(any environment, any params)
const getUsers = (...params) => {};
```

4. 准确的表达

属性可以避免不必要的描述，言简意赅：

```javascript
// bad
const book = {
  bookname: "",
  length: "",
};

// good
const book = {
  title: "",
  pages: "",
};
```

注意单复数：

```javascript
// bad
const book = findBooks();

// good
const books = findBooks();
```

5. 不必要的约定

通常在示例或无意义的遍历中，我们会把每一个回调函数的参数写作 `item` `value` `element` 等等，这在一些场景中的确可以让阅读者忽略掉不必要的描述，从而专注于逻辑本身。但这并非总是合适，特别是我们需要表达状态的时候：

```javascript
// bad
const titles = books
  .map((item) => item.title)
  .filter((item) => item.length > 0);

// good
const titles = books
  .map((book) => book.title)
  .filter((title) => title.length > 0);
```

# 2. 观察与思考

观察是一个模糊的概念，可以尝试让同事朋友阅读你的代码，问问他们的感觉，哪些命名生硬，哪些词不达意，哪些又能让他们产生共鸣。一个可学习的方式就是在 `GitHub` 上阅读代码，你也能注意到开发者们的情绪波动，这里真的需要这些定义吗？这里有必要写的这么短小精悍吗？这里是不是写的太过于 `OC` 风了。试图从阅读代码理解开发者创作时的想法是很有趣的一件事件，这些情绪的波动还可能能让你明白他们大约处于编程、人生、情感的什么状态，有助于你深刻的理解接口与设计。

在一个项目中见到 `created` 时，便可以知道这调用发生在 `create` 之后，而非之前或者之中。以此类推便可以有 `destroyed` 或其他函数。如果项目是来自富有经验的开发者，这些细节会帮助你在代码中极快的理解作者的构思。

在阅读某些源码时，我们可能会注意到一些细节，就是一些旧有的功能被改变了，程序员只能被迫去修改这些已有的接口使之兼容。同时想要与原有的风格保持一些同步，有时也会衍生出一些新的接口，他们被置于一些结构体中，随着时间的推移可以推理，未来的一些接口也会被移入这些结构体 ———— 这就是我们对于命名的观察与思考。我曾经看见过有人说“狗是人类的朋友，taobao 的文档连狗都不如”，这就是他们观察的结果了，虽然好像令人不那么开心。

# 3. 巧妙与投机取巧

我们可以断定**巧妙**是优雅命名中最重要的一部分，比如 `rvm` 与其他的一些命令行工具中的 uninstall 功能，其命令为 `implode` 。这好像有点意思，是吧？但事实上我见到的绝大多数的巧妙不过是“投机取巧”，他们苦心孤诣的作品是一大段没有说明的八进制、二进制代码，一堆三元堆砌的单行逻辑，一些谐音名字，以及不合时宜的正则表达式等等，这并不漂亮，这是歧路。

1. 自作聪明的谐音

```javascript
// bad
const markdowm2html = (template) => {};

// good
const markdownToHmtl = (template) => {};
```

2. 可以语义化的正则

代码并非是越简短越好，虽然多数场景下，我们需要尽可能的避免长篇累牍。但在必要时，可以使用命名和语义化的代码块来试图说明逻辑：

```javascript
// bad
const isUser = /^name/.test(user.name) && /^http/.test(user.url);

// good
const isUserName = user.name.starstWith("name");
const isUrl = user.blog.startsWith("http");
const isUser = isUserName && isUrl;
```

3. 优美

```javascript
// bad
const hasDirOrCreateDir = (path) => {};

// good
const ensureDir = (path) => {};
```
