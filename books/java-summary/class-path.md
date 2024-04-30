---
title: "クラスパス"
---

## クラスパスとは

- **コンパイラやランタイムが**クラスファイルやライブラリ（`.jar` ファイルなど）を探すためのパスを指定する環境設定
- 実行中の Java プログラムがその依存するクラスやリソースを適切にロードするための基準パスとして機能する
- **実行する Java ファイル自体ではなく、そのファイルが依存するクラスやパッケージの場所を指定するために使われる**

## クラスパスが必要な理由

- プログラム実行時に処理内容が記述されたクラスファイルを検索するために必要だから
- プログラムが正しくコンパイル・実行されるには、依存しているクラスとパッケージが正確に指定され、アクセス可能でなければならない
- クラスパスは、これらのリソースの場所を Java コンパイラとランタイムに教える役割
- Java SE に含まれるクラス（コアクラス）は自動で読み込まれるため、クラスパスの指定が不要

## クラスパスのデフォルト値

- クラスパスが明示的に設定されていない場合、カレントディレクトリをクラスパスとして使用する
- カレントディレクトリとは、コマンドラインインターフェースでコマンドを実行する際にいるディレクトリ
- プログラムの実行ディレクトリに存在する.class ファイルやリソースが自動的にクラスパスに含まれる

## クラスパスの指定方法

指定方法は以下の 2 通り

- `classpath` オプションで指定する
- 環境変数を使用する

### `classpath` オプションで指定する

`java` と `javac` コマンドを実行する際に、`-cp` または `-classpath` オプションでクラスパスを直接指定する。

```shell
javac -cp クラスパス 実行するJavaファイル
```

```shell
java -cp クラスパス 実行するクラス名
```

複数のクラスパスを指定する場合、コロン（UNIX）またはセミコロン（Windows）を使用して区切る。

```shell
javac -cp クラスパス1:クラスパス2 実行するJavaファイル
```

```shell
javac -cp クラスパス1;クラスパス2 実行するJavaファイル
```

### 環境変数を使用する

クラスパスは環境変数として以下のように設定することも可能

```shell
export CLASSPATH=クラスパス1:クラスパス2
```

**環境変数に指定したクラスパスは、全てのアプリケーション共通で利用される。**

現在のクラスパス設定を確認したい場合は以下のコマンドを実行する。

```shell
env | grep CLASSPATH
```

設定されていない場合は何も表示されない。

```shell
env | grep CLASSPATH

```

設定したクラスパスを解除したい場合は以下のコマンド。

```shell
unset CLASSPATH
```

## 具体例

以下の構成を例にクラスパスの指定を解説する。

```
./project
├── Main.java
├── mypackage
│   └── Hello.java
└── sample
    ├── Sample.class
    └── Sample.java
```

```java: project/Main.java
import sample.Sample;

public class Main {
  public static void main(String[] args) {
    System.out.println("Mainクラスです");
    Sample.main(args);
  }
}
```

```java: project/sample/Sample.java
package sample;

public class Sample {
  public static void main(String[] args) {
    System.out.println("Sampleクラスです");
  }
}
```

```java: project/mypackage/Hello.java
package mypackage;

import sample.Sample;

public class Hello {
  public static void main(String[] args) {
    System.out.println("Helloクラスです");
    Sample.main(args);
  }
}
```

### `Main` クラスを実行する

#### `project/` からコンパイル・実行を行う

```shell
java Main.java
```

クラスパスの設定がなければ、上記コマンドはデフォルトでカレントディレクトリとなり、下記と同じ意味となる。

```shell
java -cp . Main.java
```

この時、クラスパスは `.`（`project/`）であり、`Main.java` が参照する `sample.Sample` は `project/` から見て `sample/Sample.java` に存在する。

#### `project/sample/` からコンパイル・実行を行う

```shell
java -cp .. ../Main.java
```

クラスパスは `..` を指定しており、`project/sample` から見ると、`project/` に相当する。
そして、`Main.java` が参照する `sample.Sample` は、クラスパスである `..`（`project/`）から見て `sample/Sample.java` に存在する。

### `Hello` クラスを実行する

#### `project/` からコンパイル・実行を行う

```shell
java mypackage/Hello.java
```

この時、クラスパスは `.`（`project/`）であり、`Hello.java` が参照する `sample.Sample` は `project/` から見て `sample/Sample.java` に存在する。

#### `project/mypackage` からコンパイル・実行を行う

```shell
java -cp .. Hello.java
```

クラスパスは `..` を指定しており、`project/mypackage` から見ると、`project/` に相当する。
そして、`Hello.java` が参照する `sample.Sample` は、クラスパスである `..`（`project/`）から見て `sample/Sample.java` に存在する。

### 勘違いしがちなクラスパス

`project/` から `Main.java` をコンパイル・実行する例を考える。

```java: project/Main.java
import sample.Sample;

public class Main {
  public static void main(String[] args) {
    System.out.println("Mainクラスです");
    Sample.main(args);
  }
}
```

`Main.java` は `sample/Sample.java` のみクラスを参照している。
そのため、クラスパスを `./sample` と限定しても良いように思える。

```shell
java -cp ./sample Main.java
```

しかし、これはコンパイルエラーとなる。

```shell
Main.java:1: エラー: パッケージsampleは存在しません
import sample.Sample;
             ^
Main.java:6: エラー: Sampleにアクセスできません
    Sample.main(args);
    ^
  クラス・ファイル./sample/Sample.classは不正です
    クラス・ファイルsample.Sampleに不正なクラスがあります
    削除するか、クラスパスの正しいサブディレクトリにあるかを確認してください。
エラー2個
エラー: コンパイルが失敗しました
```

- 上記の場合、コンパイラは `project/sample` を基準として、実行ファイルが参照するクラス（`Sample`）を検索する。
- そして、`Main.java` の `import` 文には `sample.Sample` とある
- そのため、コンパイラは `project/sample/sample` のパッケージから `Sample` クラスを検索することになる
- `project/sample/sample` は存在しないため、コンパイルエラーとなる
