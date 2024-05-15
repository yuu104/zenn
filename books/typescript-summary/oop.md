---
title: "オブジェクト指向"
---

## `new.target`

- 関数やコンストラクタ内で使用される特殊なメタプロパティ
- 関数やクラスが `new` キーワードを使用してインスタンス化されたかどうかを検出するために使用される

### 利用シーン

- 通常の関数呼び出しとコンストラクタ呼び出しを区別するために使われる
- 関数やコンストラクタが `new` キーワードを使って呼び出された場合、`new.target` はそのコンストラクタを指す
- `new` キーワードなしで呼び出された場合、`new.target` は `undefined` になる

```ts
function Example() {
  if (!new.target) {
    console.log("関数として呼び出されました");
  } else {
    console.log("コンストラクタとして呼び出されました");
  }
}

Example(); // 関数として呼び出されました
new Example(); // コンストラクタとして呼び出されました
```

`new.target.name` を使用することで、関数やクラスの名前を取得できる。

```ts
class BaseClass {
  constructor() {
    console.log(new.target.name);
  }
}

class DerivedClass extends BaseClass {}

new BaseClass(); // "BaseClass" と表示される
new DerivedClass(); // "DerivedClass" と表示される
```
