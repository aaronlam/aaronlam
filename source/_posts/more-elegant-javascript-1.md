---
title: 更优雅的JavaScript 1
date: 2019-12-13 23:45:00
tags:
  - JavaScript
  - 代码风格
categoires:
  - 前端
---

貌似，现在大家写代码都只是在追求其极致性能、精巧体积、华丽技巧，而忽视了最重要的 **code for hunmans** 。

我们知道在日常项目开发时，代码被人阅读的难度是远高于执行引擎的。所以要写出好的代码就需要尝试脱离自己的视角，以第三人的眼光重新审视、理解其上下文的含义。 这样创作出的代码结构、组合、技巧才会予人阅读的幸福感。我们致力于书写优秀的代码就意味着，代码不仅仅是一个工具，更是将其视作为用来传达精神、思想、理念的一座桥梁。这是一种对于书写者智慧的一种锤炼与分享。

<!--more-->

# 1. 优先使用 const

`const` 在 JS 中不仅可以用于命名常量，且因为其内存地址不可变的性质，所以也常用于声明数组与对象。在编程中多使用 `const` 代替 `let` 和 `var`，可以在风格上向 immutable 靠拢，在编程思维上开始摒弃副作用带来的影响。更多的使用 `const` 虽然可能会使声明项增多。但是对于开发者来说，少副作减少了心智负担的同时，让命名语义化将会使代码的质量大大提升。

而在 JS 中如果过多的使用 `let` 或者 `var` 声明变量，阅读者往往需要把注意力游离于代码上下文，反复阅读才能理解当前变量的值，并且变量还可能会被其他函数引用更改。所以，很显而易见地，使用变量越多其理解的成本也就越高，而且还很难跟踪其具体的值。以下代码统计数组中每个元素的总和，使用 `const` 命名一个常量后，你将无法在 `forEach` 的每一次循环时改动它。转而使用 `reduce`，我们减少了变量 `let count`，增加了常量 `const count`。这样，在随后的代码的引用中就无需担心变量的状态。因为，我们知道，此时的 `count` 是一个数值常量，一旦赋值就不会变化。

```javascript
// bad
let count = 0;
[1, 2, 3, 4, 5].forEach((item) => {
  count += item;
});

// good
const count = [1, 2, 3, 4, 5].reduce((pre, cur) => pre + cur, 0);
```

# 2. 使用函数表达式优于函数声明

我们配合上文所提到的 `const`，能够使用函数表达式来创建一个函数，更多的时候我们会与箭头函数搭配 `const func = () => {}`。 这种方式优于传统函数声明的地方在于：

- 语义化指名函数是不可变的
- 函数表达式可以被看作赋值语句，更加简单易懂，且无法覆盖。（常量不能被重新声明）
- 函数声明在代码解析阶段会被引擎提升，存在先使用后声明。高可读可预测的代码应该先声明再使用
- 搭配箭头函数使用减轻对 `this` 的思维依赖

```javascript
// bad
function addOne(value) {
  return value + 1;
}

// good
const addOne = (value) => value + 1;
```

# 3. 使用 return 减少分支

分支泛滥问题在 JS 代码中很是普遍，推荐在可能的代码块中使用 `return` 优先返回。这样可以有效的减少缩进，同时也能使代码逻辑更加的清晰可读，因为在同一时间能总是只能做一件事情。

我们还可以再必要时优先 `return` 较短的逻辑块，使代码更美观。

```javascript
// bad
const render = () => {
  if (isServer) {
    // server code
  } else {
    // client code
  }
};

// good
const render = () => {
  if (isServer) {
    // server code

    return;
  }

  // client code
};
```

# 4. 不要过度优化

如果你不是在编写类库、框架、底层代码等对性能要求极为苛刻的工程时，请务必过度以代码的可读性来换取代码的高效率。大多数的过度优化会让代码的可读性急剧下降，得不偿失！

1. 不必要的减少内存空间使用

```javascript
// bad
let fullname;
users.forEach((user) => {
  fullname = user.firstname + user.lastname;
  // ...
  register(fullname);
});

// good
users.forEach((user) => {
  const fullName = user.firstname + user.lastname;
  // ...
  register(fullname);
});
```

2. 不必要的运算优化

```javascript
// bad
let len = users.length;
for(i = 0; i < len; i++>) {}

// good
users.forEach(user => {})
```

# 5.减少魔术字符

魔术字符串指的是，在代码之中多次出现，与代码形成强耦合的某一个具体的字符串或者数值。风格良好的代码，应该尽量消除这些魔术字符，改由清晰的变量代替。

而通常，我们还会把所有的字符或数字统一声明在一个常量的文件内，如 `host` `defaultSettings` `port` 等等，这将会有益于后期维护。

```javascript
// bad
const host = "https://api.example.com";
const url = `${host}/1/users`;

// good
const host = "https://api.example.com";
const apiVersion = 1;
const apis = {
  users: "users",
  goods: "goods",
};

const url = `${host}/${apiVersion}/${apis.users}`;
```

# 6. 函数不要有过多的参数

在不断变动的需求中，我们编写的函数可能会有越来越多的参数。但要注意一点，当一个函数有较多的参数时，就会给调用方带来困扰。我们并非需要把每一个函数都实现 **curry**，但减少函数参数、合并参数、拆分函数功能都会让代码的可读性与拓展性更上一个台阶。

在调用较多参数的函数时，我们不仅要记住每个参数的位置，若有参数空缺时还需对其进行补位（如传入 `null` `undefined`），这会导致声明与调用的代码中都被迫存在非常多的冗余判断。所以在函数个数出现增长时，就可以考虑将其中的一部分合成一个参数对象，或是将函数内的功能进行拆分，作为一个新的函数。

```javascript
// bad
const createUser = (id, name, telephone, email, address, createBy) => {};

// good
const createUser = (id, userOptions) => {};
```

# 7. 保持函数的专注

在一个函数里最好只做一件事，同时最好让函数的名字与这件事是相关的，尤为重要！在单个函数中累积逻辑，会给阅读者带来非常大的心智负担，如果我们尝试函数拆分、组合并合理化命名，将会使代码整体获得极大的美感。使代码井井有条，泾渭分明也是一门艺术。

```javascript
// bad
const getUser = id => {
    const header = // ...
    const options = // ...
    options.header = headers;
    const host = // ...
    const url = // ...
    if(id.length > 1) // ...
    return fetch(url, options);
}

// good
const makeOptions = () => { // ... };
const makeUrl = id => { // ... };

const getUser = id => {
    const options = makeOptions();
    const url = makeUrl(id);

    return fetch(url, options);
}
```

# 8. 使用语义化命名代替冗长的判断条件

过长的判断条件可能会在编写的当下烂熟于心，但常常会在一段时间回头再看觉得匪夷所思，很难理解其中的逻辑。所以，将其使用语义化的常量代替则可以向阅读者提示其含义，更是省下了不必要的注释，一举两得！

```javascript
// bad

// 判断是否为青少年
if (user.age < 19 && user.age > 13) {
  // ...
}

// good
const isTeenAgeMember = user.age > 13 && user.age < 19;
if (isTeenAgeMember) {
  // ...
}
```

# 9. 减少函数的副作用

减少函数副作用一直以来都是 JS 社区中的长青话题，特别是 React 社区，而减少副作用并非总是需要以纯函数来解决所有问题。所以无需紧张，我们知道副作用会使得状态变化难以捕捉，在编程中应当以较少的副作用函数为目标，使函数的预期与实际保持一致的同时又不会造成过多的噪音。虽然，这或许会在构思和声明阶段花费一些时间，但对于整体代码的质量来说，是一件以小换大的好事！

你可能会发现有些时候会不可避免的引用并改变了外部的状态，比如缓存某些值，为此你陷入了重构的苦恼。事实上不必过于忧虑，你想做的必然有其代理。这就是**编程中取舍**问题，学会在编程、架构、工程上有所取舍（并不是随心所欲）后构建出的产品，自然会带有一定的特色。

```javascript
// bad
const user = getUser();
const upload = () => {
  user.tempField = "temp content";
  // fetch user...
};

// good
const user = getUser();
const upload = (user) => {
  const tempUser = { ...user, tempField: "temp content" };
  // fetch user...
};
```
