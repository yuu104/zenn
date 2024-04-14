---
title: "コンパイル・実行"
---

以下の `Sample.java` をコンパイルし、実行する。

```java: Sample.java
public class Sample {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

## コンパイル

まず、`javac` コマンドを実行してコンパイルする。

```shell
javac Sample.java
```

コンパイルが成功すると、`Sample.class` というファイルが生成される。

- `.class` ファイルは Java のソースコードがコンパイルされた後に生成されるバイナリファイル
- JVM が解釈し、実行するための形式
- 一度コンパイルされた Java の `.class` ファイルは JVM がインストールされていれば、どこでも実行可能

## 実行

コンパイルされたプログラム（`Sample.class`）を Java インタプリンタで実行する。

```shell
java Sample
```

すると、以下の出力結果となる。

```shell
Hello, World!
```
