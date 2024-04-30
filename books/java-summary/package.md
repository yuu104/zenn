---
title: "パッケージ"
---

## 概念

- **複数のクラスをグループ化したもの**
- これにより、クラスの管理が容易になり、クラス名の衝突を避けることができる
- **全ての Java プログラムは必ずパッケージに属している**
- パッケージで管理されていないファイルは Java のコードとして認められない
- 1 つのクラスが所属できるパッケージは 1 つのみ
- **パッケージは必ずパッケージ名と同じ名前のディレクトリで管理する**

## パッケージの作成

`myapp` というパッケージを作成する場合、プロジェクトディレクトリ直下に `myapp` という名前のディレクトリを作成する。
`MyClass.java` は、`myapp` パッケージに属するファイル。

```
src/
└── myapp/
    └── MyClass.java
```

パッケージは階層化させることが可能。
下記の場合、`MyClass.java` は、`com.example.myapp` という名のパッケージに属する。

```
src/
└── com/
    └── example/
        └── myapp/
            └── MyClass.java
```

## パッケージの宣言

Java ファイルの最初（すべてのインポート文の前）に `package` キーワードを使用して宣言する。

```java: src/com/example/myapp/MyClass.java
package com.example.myapp;

public class MyClass {
    // クラスの定義
}
```

これにより、`MyClass` は `com.example.myapp` パッケージの一部として扱われる。

## パッケージの読み込み

### 同一パッケージ内のクラスを読み込む

同一パッケージ内のクラス同士は、インポートせずに直接参照することができる。

```java: mypackage/ClassA.java
package mypackage;

public class ClassA {
  public void display() {
    System.out.println("Class A method");
  }
}
```

```java: mypackage/ClassB.java
package mypackage;

public class ClassB {
  public void test() {
    ClassA a = new ClassA();
    a.display();
  }
}
```

### `import` 文を使用して別パッケージのクラスを読み込む

```java: mypackage/ClassA.java
package mypackage;

public class ClassA {
  public void display() {
    System.out.println("Class A method");
  }
}
```

```java: somepackage/ClassB.java
package somepackage;

import mypackage.ClassA;

public class ClassB {
  public void test() {
    ClassA a = new ClassA();
    a.display();
  }
}
```

パッケージ配下の全てのクラスを使用できるようにしたい場合はワイルドカード（`*`）を使用する。

```java
import パッケージ名.*;
```

### 完全修飾名を使用して別パッケージのクラスを読み込む

- インポートせずに、クラス名の前にパッケージ名を付けることで、どのパッケージのクラスであるかを指定することができる
- 特に名前の衝突がある場合に役立つ

```java: mypackage/ClassA.java
package mypackage;

public class ClassA {
  public void display() {
    System.out.println("Class A method");
  }
}
```

```java: somepackage/ClassB.java
package somepackage;

public class ClassB {
  public void test() {
    ClassA a = new mypackage.ClassA();
    a.display();
  }
}
```

## `java.lang` パッケージはインポート不要

- Java SE の `lang` パッケージは以下のような頻繁に使用するクラスが多いため、直接使用可能
  - `Object`
  - `String`
  - `Math`
  - `System`

## パッケージの命名

1. **全て小文字**
2. **複数単語を含む場合は単語間に `_` や `-` を使用せず、単語を連結する**
   - 正しい例 : `databasemanagement`
   - 誤った例 : `databaseManagement`, `database_management`
3. **ドメイン名を逆にする**
   - 企業や組織では、自身のインターネットドメイン名を逆にしてパッケージ名の基本とするのが一般的
   - `example.com` がドメインの場合、パッケージ名は `com.example` から始まる

## 無名パッケージ（デフォルトパッケージ）

- Java でパッケージ宣言を含まないクラスが自動的に属する特別なパッケージ
- クラスファイルの最初の行で package キーワードを使って具体的なパッケージ名を指定しない場合、そのクラスは無名のパッケージに属する

### 無名パッケージの特徴と使用

1. **アクセス性**
   - 無名パッケージに属するクラスは、他の名前付きパッケージからはアクセスできない
2. **スコープと可視性**
   - 無名パッケージ内のクラスは、同じ無名パッケージ内の他のクラスからのみアクセス可能
3. **使用場面**
   - 小規模なテストやプロトタイピングで使われることがある
   - 本格的なアプリケーション開発や公開されるライブラリでの使用は推奨されない

## 任意のパッケージに属するクラスファイルを実行する

パッケージに属するクラスファイルを実行する際には、クラスの完全修飾名（パッケージ名を含むクラス名）を指定する必要がある。

`com.example` というパッケージに `MyProgram` というクラスがある場合、このクラスを実行するためには以下のようにコマンドラインから指定する。

```shell
java com.example.MyProgram
```
