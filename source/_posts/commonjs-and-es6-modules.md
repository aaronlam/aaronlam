---
title: CommonJS Module和ES6 Modules之间的引用与转换
date: 2019-10-5 14:00:00
tags:
  - JacaScript
  - ESModules
  - CommonJS
categories:
  - 前端
---

平时在项目开发的过程中，因为 JavaScript 模块化的历史遗留问题，难免会存在在 CommonJS 的模块里头 `import` ES6 的模块，或者在 CommonJS 的模块里头 `require` ES6 的模块的情况发生。为了能够搞清楚他们之间的转换小秘密，所以就专门记录一下，方便日后回顾，顺便上来水一文。

> 因为这两种模块在网络上存在着各式各样的叫法，所以在文章开始前，为了能够和大家达成一致的共识。在后面我将会用 **CJS** 代指 CommonJS Module，用 **ESM** 代指 ES Modules。

# ESM 转 CJS

## 1. ESM export 转 CJS exports

举个栗子：

```javascript
// a.js
export var foo = "bar";
export function func() {}
export default 1;
```

`a.js` 中的 **ESM** 在经过 **babel** 转为 **CJS** 后，代码变为：

> 注：在 ESM 被转为 CJS 时，转译器会在其导出的对象中定义一个值为 `true` 的私有的变量 `__esModule`

```javascript
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });

exports.func = func;
var foo = (exports.foo = "bar");
function func() {}
exports.default = 1;
```

其实也就等价于：

```javascript
"use strict";
exports.__esModule = true; // 该属性实际上会通过Object.defineProperty API设置为不可枚举

exports.foo = "bar";
exports.func = function () {};
exports.default = 1;
```
<!--more-->

## 2. ESM import 转 CJS require

### 2.1 Default import

还是一个栗子，直接默认导入 `a.js` 中的模块：

```javascript
//  b.js
import a from "./a";

console.log(a);
```

`b.js` 在经过 **babel** 转为 **CJS** 后，代码变为：

```javascript
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });

var _a = require("./a");
var _a2 = _interopRequireDefault(_a);
function _interopRequireDefault(obj) {
  // 如果是ESM则直接返回obj，否则返回新对象
  return obj && obj.__esModule ? obj : { default: obj };
}
console.log(_a2.default);
```

### 2.2 Wildcard import

再一个栗子，名字空间导入 `a.js` 中的模块：

```javascript
// b.js
import * as a from "./a";

console.log(a);
```

`b.js` 在经过 **babel** 转为 **CJS** 后，代码变为：

```javascript
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });

var _a = require("./a");
var A = _interopRequireWildcard(_a);
function _interopRequireWildcard(obj) {
  // ESM直接返回obj
  if (obj && obj.__esModule) {
    return obj;
  } else {
    // CJS的话就创建一个新的空对象，并把obj内的所有自有属性都浅复制到新对象中，最后再把obj赋值给新对象的default属性
    var newObj = {};
    if (obj != null) {
      for (var key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
          newObj[key] = obj[key];
        }
      }
    }
    newObj.default = obj;

    return newObj;
  }
}
```

## 3. 总结

1. ESM 的 `export` 相当于往 CJS 的 `exports` 上添加属性
   1. `export var/let/const/function/class...` 会往 `exports` 上添加同名属性
   2. `export default` 会往 `exports` 上添加 default 属性
2. ESM 可以 **default import** 和 **wildcard import** CJS
   1. **default import** CJS 时，会创建一个新的空对象，并把 CJS 的导出对象 `exports` 赋值到新对象的 default 属性
   2. **wildcard import** CJS 时，会创建一个新的空对象，并把 CJS 的导出对象 `exports` 中的自有属性浅复制到新的空对象中，最后再把导出对象 `exports` 赋值到新对象的 default 属性

# ESM 中引用 CJS

根据上面得出的结论，ESM 中引用 CJS 有两种方式，栗子如下：

```javascript
// cjs.js
module.export = {
  default: "myDefault",
  foo: "bar",
};
```

```javascript
// esm.js
import cjs from "./cjs";
// const cjs = ({ default: exports }).default;

import * as cjs2 from "./cjs";
// const cjs2 = ({ default: exports, ...exports })

import { default as cjs3 } from "./cjs";
// const cjs3 = ({ default: exports }).default
```

# CJS 中引用 ESM

在 CJS 中引用 ESM 相当于直接引用 ESM 转成 CJS 的 `module.exports`，栗子如下：

```javascript
// es.js
export let foo = "bar";
export { foo as bar };
export function func() {}
export class cls {}
export default 1;
```

```javascript
// cjs.js
var es = require("./es");
/* es结构如下：
{
    foo,
    bar: foo,
    func,
    cls,
    default: 1
}
*/
```
