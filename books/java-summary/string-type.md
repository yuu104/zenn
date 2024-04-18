---
title: "String型の注意点"
---

## `String` は参照型である

`String` 型の変数を宣言を見ると、一見プリミティブ型のように感じる。

```java
String name = "Hiro";
```

しかし、`String` 型は**参照型**である。
そのため、以下のように宣言することも可能。

```java
String name = new String("Hiro");
```

- 文字列を扱う `String` 型はプリミティブかのように扱うシーンが非常に多い
- よって、プリミティブ型と同じような感覚で扱えるようになっている
- それゆえ、`String` は**擬似プリミティブ型**と呼ばれる

## `String` の正体

`String` 型は `char[]` 型の参照である。

![](https://storage.googleapis.com/zenn-user-upload/673a9e997f04-20240418.png)

## 宣言方法の違い

`String` 型の宣言方法には以下 2 つの方法があった。

- 文字列リテラルを使用する
- `new` キーワードを使用する

### 文字列リテラルを使用する

```java
String name = "Hiro";
```

- 文字列リテラルによる宣言は、コンパイル時に**文字列プール**とよばれる特別なメモリ領域に格納される
- 文字列プールは、**同じ文字列リテラルに対しては常に同じ参照を返す**
- そのため、メモリ使用効率が良くなる

よって、以下のような比較を行うことができる。

```java
String myName = "Hiro";
String hisName = "Hiro";

boolean isSameName = myName == hisName // 参照先アドレスを比較

System.out.println(isSameName); // true
```

### `new` キーワードを使用する

```java
String name = new String("Hiro");
```

- `new` キーワードにより、`String` オブジェクトを明示的に作成している
- この場合、文字列プールを無視して常に新しい `String` オブジェクトがヒープメモリ上に創られる

よって、文字リテラルによる宣言とは異なり、以下のような比較はできない。

```java
String myName = new String("Hiro");
String hisName = new String("Hiro");

boolean isSameName = myName == hisName // 参照先アドレスを比較

System.out.println(isSameName); // false
```

比較したい場合、`equals()` メソッドを使用する。

```java
String myName = new String("Hiro");
String hisName = new String("Hiro");

boolean isSameName = myName.equals(hisName); // 参照先アドレスを比較

System.out.println(isSameName); // false
```

### 文字列比較のベストプラクティス

宣言方法の違いにより、文字列が同じでも `==` では同じと判断される時と異なると判断される時がある。
よって、Java で文字列の比較を行うときは **`equals()` メソッドを使う**。
