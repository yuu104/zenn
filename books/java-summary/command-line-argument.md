---
title: "コマンドライン引数"
---

コマンドラインからプログラムを実行する際、引数を使用して事前に情報を追加することが可能。
この引数は、エントリーポイントである `main` 関数の引数から使用できる。

コマンドライン引数は、下記のようにスペース区切りで複数指定可能。

```shell
java Sample おはよう こんにちは こんばんは
```

指定した引数は配列として受け取る。

```java
public static void main(String[] args) {
  System.out.println("第一引数: " + args[0]);  // "firstArg"
  System.out.println("第二引数: " + args[1]);  // "secondArg"
  System.out.println("第三引数: " + args[2]);  // "thirdArg"
}
```
