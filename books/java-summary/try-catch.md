---
title: "例外処理（try~catch）"
---

## エラーの種類

### 文法エラー（Syntax Errors）

**定義:**

- プログラムが Java の文法規則に従っていない場合に発生する
- コーディングミスによるもので、例えばセミコロンの欠落、括弧の不一致、誤ったキーワードの使用などが原因

**特徴:**

1. **コンパイル時に発生**
   - 文法エラーはコンパイル時に検出される
2. **エラーメッセージ**
   - コンパイラは通常、文法エラーの種類と発生位置（行番号）を指摘するエラーメッセージを提供する
3. **対処法**
   - エディタのシンタックスハイライト機能やコンパイラのエラーメッセージを参考に、コードを見直し修正する

### 論理エラー（Logic Errors）

**定義:**

- プログラムが文法的には正しいものの、期待される結果を生成しない場合に発生する
- アルゴリズムの誤りや誤った変数の使用など、プログラムの設計に問題があることに起因する

**特徴:**

1. **実行時にのみ発見可能**
   - 論理エラーはプログラムが実際に動作する際にのみ確認できる
2. **デバッグが困難**
   - エラーメッセージが表示されないため、プログラムの出力結果と期待される結果を比較して原因を特定する必要がある
3. **対処法**
   - デバッグツールを使用してステップバイステップでコードを追跡したり、ユニットテストを書いて問題のある部分を特定する

### 例外（Exceptions）

**定義:**

- プログラムの実行中に発生する予期せぬ状況を指す
- ファイルが見つからない、ネットワークエラー、不正な入力データ、メモリオーバーフローなど

**特徴:**

1. **実行時に発生**
   - プログラムが実行中に発生し、それによりプログラムの実行が中断される
2. **キャッチとハンドリング**
   - Java では例外を捕捉（キャッチ）し、適切に処理（ハンドリング）することが可能
   - これにより、プログラムが異常終了することを防ぐ
3. **チェック例外と非チェック例外**
   - チェック例外（コンパイル時にその処理を強制される例外）と非チェック例外（ランタイム例外）の二つのカテゴリがある

## 例外処理

- 例外を細く（catch）し、処理（handle）する仕組み
- 例外処理を適切に実装することで、エラーが発生してもプログラムが中断されることなく、制御された方法で問題に対処できる

### 基本構文

`try-catch` ブロックを使用する。

```java
try {
  // 例外が発生する可能性のあるコード
} catch (ExceptionType1 e) {
  // ExceptionType1が発生した場合の処理
} catch (ExceptionType2 e) {
  // ExceptionType2が発生した場合の処理
} finally {
  // 例外の有無に関わらず実行されるコード（オプショナル）
}
```

- `try-catch` で例外を検知した場合は強制終了とならず、**`try` ブロックを抜けた先から処理が再開する**
- `finally` ブロックでは、例外の有無にかかわらず実行される処理を記述する

## 例外の種類

1. **チェック例外（Checked Exceptions）**
   - コンパイラがその取り扱いを強制する例外
   - 通常、プログラマが予見できる状況で発生する
   - 例：ファイルが見つからない、ネットワークエラー
   - プログラマはこれらの例外を捕捉して処理するか、または `throws` キーワードを使用して、その例外をメソッドの呼び出し元に伝播させる必要がある
2. **ランタイム例外（Runtime Exceptions）**
   - コンパイラがその取り扱いを強制しない例外
   - 通常、プログラムのバグが原因で発生するエラー
   - 例：配列の範囲外アクセス、null への参照
   - ランタイム例外は、プログラムのロジックを改善することで防ぐことが可能なため、通常は明示的に処理する必要はない

:::details つまりどういうこと？

チェック例外が発生する可能性のあるメソッドやコンストラクタを使用する際、その例外を処理するために以下 2 つの方法のいずれかで対応する必要がある。

- `try-catch` で例外を捕捉する
- `throw` キーワードを使用し、例外を伝播させる

**上記の対応がなければ、コンパイルエラーとなる。**

```java
import java.io.*;

public class FileOperation {
  // FileNotFoundExceptionを捕捉する例
  public void readFile(String fileName) {
    try {
      FileInputStream file = new FileInputStream(fileName);
      // ファイルの読み取り処理
    } catch (FileNotFoundException e) {
      System.out.println("ファイルが見つかりません: " + e.getMessage());
    }
  }
}
```

上記の場合、

- `FileInputStream` コンストラクタはチェック例外（`FileNotFoundException`）を発生させる可能性がある
- よって、`try-catch`により例外を捕捉する必要がある
- `try-catch` の記述がなければ、コンパイルエラーとなる

:::

## 例外クラス

- Java で発生する様々な種類のエラーを表すために使われるクラス
- れらはすべて `Throwable` クラスから派生しており、Java のエラーと例外の基底クラスとなっている

:::details Throwable クラスの構造

```java
public class Throwable {
    // Throwableクラスの主要メソッド
    public Throwable() {}
    public Throwable(String message) {}
    public Throwable(String message, Throwable cause) {}
    public Throwable(Throwable cause) {}

    public String getMessage() {}
    public Throwable getCause() {}
    public Throwable initCause(Throwable cause) {}
    public void printStackTrace() {}
}
```

:::

### 例外クラスの分類

1. **`Exception` クラス**

   - アプリケーションレベルで処理すべき例外を表すクラス
   - **開発者が例外処理として対処すべき例外**
   - 「チェック例外」と「ランタイム例外」の 2 つに分けられる
   - ランタイム例外は、`Exception` のサブクラスである `RuntimeException` クラスを継承している

   :::details Exception クラスの構造

   ```java
   public class Exception extends Throwable {
     public Exception() {}
     public Exception(String message) {}
     public Exception(String message, Throwable cause) {}
     public Exception(Throwable cause) {}
   }

   ```

   :::

   :::details Runtime Exception クラスの構造

   ```java
   public class RuntimeException extends Exception {
   public RuntimeException() {}
   public RuntimeException(String message) {}
   public RuntimeException(String message, Throwable cause) {}
   public RuntimeException(Throwable cause) {}
   }
   ```

   :::

1. **`Error` クラス**

   - ステムレベルのエラーを表す
   - 通常はアプリケーションコードで捕捉または処理されることは期待されない
   - **開発者が直接対処すべきではない例外**
   - 例：`OutOfMemoryError`, `StackOverflowError`

   :::details Error クラスの構造

   ```java
   public class Error extends Throwable {
      public Error() {}
      public Error(String message) {}
      public Error(String message, Throwable cause) {}
      public Error(Throwable cause) {}
   }
   ```

   :::

### 階層構造で表すとこんな感じ

```php
java.lang.Throwable
    ├── java.lang.Error
    │    └── VirtualMachineError
    │         ├── OutOfMemoryError
    │         └── StackOverflowError
    └── java.lang.Exception
         ├── java.lang.RuntimeException
         │    ├── NullPointerException
         │    ├── ArrayIndexOutOfBoundsException
         │    └── IllegalArgumentException
         ├── IOException
         └── SQLException
```

### `Exception` を継承するクラス一覧

1. **チェック例外 (Checked Exceptions)**

   :::details IOException ~ 入出力操作に関する例外

   - **説明**: ファイル操作やネットワーク通信などの入出力操作中に発生する一般的な例外。
   - **ユースケース**: ファイルの読み書き、ネットワーク通信、シリアライゼーション操作中に発生する例外。

   :::

   :::details FileNotFoundException ~ ファイルが見つからない場合の例外

   - **説明**: 指定されたファイルが存在しない場合にスローされる例外。
   - **ユースケース**: ファイルを開こうとしたが、指定されたパスにファイルが存在しない場合に発生。

   :::

   :::details EOFException ~ ファイルの終わりに達した場合の例外

   - **説明**: 入力操作中にファイルの終わりに達した場合にスローされる例外。
   - **ユースケース**: データ入力ストリームを読み込む際に、予期せずファイルの終わりに達した場合に発生。

   :::

   :::details SQLException ~ データベースアクセスエラーに関する例外

   - **説明**: データベースへのアクセス中に発生する例外。
   - **ユースケース**: データベースクエリの実行、接続の確立、トランザクション処理中に発生するエラー。

   :::

   :::details ClassNotFoundException ~ クラスが見つからない場合の例外

   - **説明**: 指定されたクラスが見つからない場合にスローされる例外。
   - **ユースケース**: リフレクションを使用してクラスをロードしようとしたが、クラスがクラスパスに存在しない場合に発生。

   :::

   :::details InstantiationException ~ インスタンス化できない場合の例外

   - **説明**: クラスのインスタンス化ができない場合にスローされる例外。
   - **ユースケース**: 抽象クラスやインターフェースをインスタンス化しようとした場合に発生。

   :::

   :::details IllegalAccessException ~ アクセスできない場合の例外

   - **説明**: クラスやメンバにアクセスできない場合にスローされる例外。
   - **ユースケース**: リフレクションを使用して非公開のフィールドやメソッドにアクセスしようとした場合に発生。

   :::

   :::details InterruptedException ~ スレッドが割り込まれた場合の例外

   - **説明**: スレッドが実行を中断されることを示す例外。
   - **ユースケース**: スレッドが待機、スリープ、または他のブロッキング操作を実行している間に割り込みが発生した場合にスローされる。

   :::

   :::details NoSuchMethodException ~ メソッドが見つからない場合の例外

   - **説明**: 指定されたメソッドが見つからない場合にスローされる例外。
   - **ユースケース**: リフレクションを使用してメソッドを呼び出そうとしたが、指定されたメソッドがクラスに存在しない場合に発生。

   :::

   :::details InvocationTargetException ~ メソッド呼び出し中に発生した例外をラップする例外

   - **説明**: リフレクションを使用してメソッドを呼び出した際に、そのメソッドの内部で例外がスローされた場合にスローされる例外。
   - **ユースケース**: リフレクションを使用してメソッドを呼び出した際、そのメソッドの内部でチェック例外や実行時例外が発生した場合に発生。

   :::

2. **実行時例外 (Runtime Exceptions)**
   :::details NullPointerException ~ `null`オブジェクトにアクセスした場合の例外

   - **説明**: `null`参照にアクセスしようとした場合にスローされる例外。
   - **ユースケース**: `null`オブジェクトのメソッドを呼び出したり、`null`配列の要素にアクセスしたりする場合に発生。

   :::

   :::details ArrayIndexOutOfBoundsException ~ 配列の範囲外アクセスの場合の例外

   - **説明**: 配列の範囲外のインデックスにアクセスした場合にスローされる例外。
   - **ユースケース**: 配列の不正なインデックスにアクセスしようとした場合に発生。

   :::

   :::details IllegalArgumentException ~ メソッドに無効な引数が渡された場合の例外

   - **説明**: メソッドに無効な引数が渡された場合にスローされる例外。
   - **ユースケース**: メソッドに適切な範囲外の値や形式の引数が渡された場合に発生。

   :::

   :::details NumberFormatException ~ 文字列を数値に変換できない場合の例外

   - **説明**: 数値に変換できない文字列が渡された場合にスローされる例外。
   - **ユースケース**: `Integer.parseInt`や`Double.parseDouble`メソッドに不適切な文字列が渡された場合に発生。

   :::

   :::details IllegalStateException ~ オブジェクトが無効な状態にある場合の例外

   - **説明**: オブジェクトが無効な状態でメソッドを呼び出そうとした場合にスローされる例外。
   - **ユースケース**:
     - オブジェクトが適切に初期化されていない状態で操作を試みた場合に発生
     - あり得ない状態になった時に throw する（例：`switch` 文の `default` で throw する）

   :::

   :::details ArithmeticException ~ 算術演算が失敗した場合の例外

   - **説明**: 算術演算が失敗した場合にスローされる例外。
   - **ユースケース**: 0 で除算しようとした場合に発生。

   :::

   :::details ClassCastException ~ オブジェクトのキャストが失敗した場合の例外

   - **説明**: オブジェクトを不適切な型にキャストしようとした場合にスローされる例外。
   - **ユースケース**: キャスト操作が不正な場合に発生。

   :::

   :::details IndexOutOfBoundsException ~ インデックスが範囲外の場合の例外

   - **説明**: インデックスが有効な範囲外にある場合にスローされる例外。
   - **ユースケース**: リストや文字列の不正なインデックスにアクセスしようとした場合に発生。

   :::

   :::details StringIndexOutOfBoundsException ~ 文字列の範囲外アクセスの場合の例外

   - **説明**: 文字列の範囲外のインデックスにアクセスしようとした場合にスローされる例外。
   - **ユースケース**: 文字列の不正なインデックスにアクセスしようとした場合に発生。

   :::

   :::details UnsupportedOperationException ~ サポートされていない操作を行った場合の例外

   - **説明**: 実行しようとした操作がサポートされていない場合にスローされる例外。
   - **ユースケース**: 不変コレクションに対して変更操作を試みた場合に発生。

   :::

   :::details ConcurrentModificationException ~ 同時変更が検出された場合の例外

   - **説明**: コレクションの反復中に不正な変更が検出された場合にスローされる例外。
   - **ユースケース**: イテレータを使用している間にコレクションを変更しようとした場合に発生。

   :::

## 例外オブジェクト

- プログラム実行中に特定のエラーが発生した際に生成されるオブジェクト
- 該当する例外クラスのインスタンスとして作成され、エラーに関する詳細情報を保持する

例外オブジェクトは以下の情報を提供する

- **メッセージ**
  - エラーの原因や詳細を説明するテキストメッセージ
- **スタックトレース**
  - エラーが発生した時点のプログラムの実行パスを示す情報
  - どのメソッドがどの順番で呼び出されたかを示
  - デバッグ時に非常に役立つ
- **原因**
  - 別の例外がこの例外の原因となった場合、その原因となった例外オブジェクトへの参照を含むことがある

以下は、ファイルを開く際に発生する `FileNotFoundException` を捕捉する例。

```java
import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class FileExample {
  public static void main(String[] args) {
    try {
      FileInputStream fileInputStream = new FileInputStream("nonexistentfile.txt");
    } catch (FileNotFoundException e) {
      System.out.println("エラーメッセージ: " + e.getMessage());
      e.printStackTrace();
    }
  }
}
```

- 上記では、ファイルが存在しないため、`FileNotFoundException` が発生し、例外オブジェクト `e` が生成される
- 生成されたオブジェクトの `getMessage()` メソッドを使用してエラーメッセージを取得し、`printSrackTrace()` メソッドでエラーが発生した場所を出力している

### `printStackTrace()` メソッド

- `Throwable` クラスに定義されているため、すべての例外とエラーのオブジェクトがこのメソッドを持っている
- 例外が発生した時点でのコールスタックの情報を出力することで、デバッグプロセスを助ける

:::details 機能

1. **詳細なエラー情報の提供**
   - 例外が発生した正確な場所とプログラムの呼び出し順序を出力する
   - これにより、開発者はエラーの原因となったコードの位置を特定しやすくなる
2. **スタックトレースの出力**
   - エラーが発生した時点のメソッド呼び出し履歴を示すスタックトレースを標準エラー出力（通常はコンソール）に表示する
   - スタックトレースには、エラーが発生したメソッドと行番号が含まれていることが多く、エラー解析に不可欠

:::

:::details 出力例

```less
java.lang.NullPointerException
    at com.example.MyClass.myMethod(MyClass.java:10)
    at com.example.MyClassCaller.anotherMethod(MyClassCaller.java:22)
    at com.example.Application.main(Application.java:15)
```

- `NullPointerException` が `MyClass` のファイル `MyClass.java` の 10 行目で発生したことを示している
- その後、呼び出し履歴が `Application` クラスの `main` メソッドに戻るまで表示される

:::

:::details 使用方法

例外オブジェクトの `printStackTrace()` メソッドを呼び出す。

```java
try {
  int[] myArray = new int[5];
  System.out.println(myArray[10]);  // このアクセスはArrayIndexOutOfBoundsExceptionを引き起こす
} catch (Exception e) {
  e.printStackTrace();  // 例外とスタックトレースを出力
}
```

:::

:::details 注意点

1. **パフォーマンスの影響**
   - `printStackTrace()` メソッドはデバッグ目的で便利だが、ロダクション環境での過剰な使用はパフォーマンスに影響を与えることがある
2. **セキュリティの観点**
   - 機密情報が含まれる環境では使用を控えるべき
3. **ログ記録**
   - 番環境では、printStackTrace()の代わりにログ記録フレームワークを使用してエラー情報を適切に記録することが推奨される

:::

## 例外処理の流れ

1. **例外の発生**
   - `try` ブロック内のコードが実行されている際に、何らかの理由で例外（エラー）が発生する
   - 例：存在しないファイルにアクセスした、配列の範囲外のインデックスにアクセスしようとした
2. **例外オブジェクトの生成**
   - 発生した例外に応じて、Java ランタイムは対応する例外クラスのインスタンス（例外オブジェクト）を生成する
   - 例外オブジェクトには、例外の種類、エラーメッセージ、スタックトレース（例外が発生した時の呼び出し履歴）などの情報が含まれる
3. **適切な `catch` ブロックの検索**
   - 例外オブジェクトが生成された後、Java ランタイムは `try` ブロックに対応する `catch` ブロックを順に調べ、例外オブジェクトの型と一致する `catch` ブロックを探す
   - `catch` ブロックは、特定の例外タイプを指定して例外を捕捉する
4. **例外のハンドリング**
   - 適切な `catch` ブロックが見つかると、そのブロック内のコードが実行される
   - 例外に対する具体的な対処（ログの記録、エラーメッセージの表示、リソースのクリーンアップ、再試行のロジックなど）が行われる
5. **`finally` ブロックの実行**
   - `try-catch` 構文に `finally` ブロックが含まれている場合、`finally` ブロックは例外の発生の有無に関わらず必ず実行される
   - 開いたファイルのクローズや、ネットワーク接続の切断など、プログラムの終了時に必ず行うべきクリーンアップ処理を記述するのに適している
6. **プログラムの続行**
   - `finally` ブロックが終了すると、プログラムは `try-catch-finally` 構造の次の部分へと進む
   - これにより、例外がプログラム全体の実行を中断することなく、適切に処理された後に処理を続けることが可能になる

```java
try {
  int[] numbers = {1, 2, 3};
  System.out.println(numbers[5]); // 配列の範囲外アクセス
} catch (ArrayIndexOutOfBoundsException e) {
  System.out.println("配列の範囲外アクセスが発生しました: " + e.getMessage());
} finally {
  System.out.println("このコードは例外の発生に関わらず実行されます。");
}
```

上記では、配列の範囲外アクセスが発生し、対応する `catch` ブロックが例外を捕捉してエラーメッセージを表示する。
その後、`finally` ブロックが実行され、プログラムは正常に続行される。

### 各ブロック内で `return` した場合

```java
public static int test() {
  try {
    // 何らかの処理
    return 1;
  } catch (Exception e) {
    return 2;
  } finally {
    return 3;
  }
}
```

上記の場合、必ず `finally` ブロックが実行されるため、`3` が返る。

## `throws` 節を用いてどのような例外が発生するかを知らせる

- `throws` 節はメソッドやコンストラクタのシグネチャの一部として使用される
- メソッドまたはコンストラクタが実行中に特定の例外を発生させる可能性があることを示す
- `throws` 節を使用することで、例外をメソッドの呼び出し元に伝播させ、そのメソッドを使用するコードが例外を適切に処理する責任を持つことを要求する
- **`throws` 節のついたメソッドを呼び出す場合、呼び出す側は例外処理を記述する必要があり、記述がなければコンパイルエラーとなる**
  - ※ チェック例外のみ例外処理が必要

:::details 基本構文

```java
public void someMethod() throws IOException, SQLException {
    // メソッドの実装
}
```

上記では、`someMethod` が `IOException` と `SQLException` の 2 つのチェック例外を throw する可能性があることを示している。

:::

:::details 使用目的

1. **明示的な例外宣言**
   - `throws` 節を使用することで、メソッドが特定の例外を投げる可能性があることを明確に示すことができる
   - これにより、メソッドの使用者は必要な例外処理を予め準備することができる
2. **コードの可読性とメンテナンス性の向上**
   - `throws` 節を通じて、どのような例外がメソッドから発生する可能性があるかを明確にすることで、コードの可読性とメンテナンス性が向上する

:::

:::details 使用例

```java
public class FileReader {
  public String readFile(String path) throws IOException {
    BufferedReader reader = new BufferedReader(new FileReader(path));
    try {
      return reader.readLine();
    } finally {
      reader.close();
    }
  }
}
```

`readFile()` メソッドは、ファイルを読み込む際に `IOException` を発生させる可能性があるため、その例外を throws 節で宣言している。

このメソッドを使用する際は、以下のように呼び出し元で例外処理を行う必要がある。

```java
public static void main(String[] args) {
  FileReader fileReader = new FileReader();
  try {
    String content = fileReader.readFile("somefile.txt");
    System.out.println(content);
  } catch (IOException e) {
    System.out.println("ファイルの読み込み中にエラーが発生しました: " + e.getMessage());
  }
}
```

:::

## try-with-resources

### 概要

- Java SE 7 で導入されたリソース管理のための構文
- この構文を使用すると、リソースを明示的にクローズする必要がなくなり、リソースリークのリスクを減らせる
- 主に、`java.lang.AutoCloseable`インターフェースを実装しているリソース（例：ファイル、データベース接続、ソケットなど）で使用される

### 目的

リソースの確実な解放を保証し、リソースリークによるメモリ問題や他のリソース関連の問題を防ぐこと。

### 解決したい技術的課題

:::details リソースリークの防止

**問題点**:
リソース（例：ファイル、データベース接続）を使用した後に適切にクローズしないと、リソースリークが発生し、メモリ不足やリソース枯渇を引き起こす可能性がある。

**解決策**:
`try-with-resources`構文を使用すると、`try`ブロックを抜けるときに自動的にリソースがクローズされるため、リソースリークを防げる。

:::

### 使用方法

:::details 基本的な構文

```java
try (ResourceType resource = new ResourceType()) {
    // リソースを使用するコード
} catch (ExceptionType e) {
    // 例外処理
}
```

:::

:::details 例: ファイルの読み込み

以下の例では、`BufferedReader`を使用してファイルを読み込みます。`BufferedReader`は`AutoCloseable`インターフェースを実装しているため、`try-with-resources`構文で使用できます。

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class TryWithResourcesExample {
    public static void main(String[] args) {
        try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

:::

:::details 複数のリソースを使用する

`try-with-resources`構文では、複数のリソースを宣言して使用できます。それぞれのリソースはセミコロンで区切ります。

```java
try (BufferedReader br = new BufferedReader(new FileReader("file1.txt"));
     BufferedWriter bw = new BufferedWriter(new FileWriter("file2.txt"))) {
    // brとbwを使用するコード
} catch (IOException e) {
    e.printStackTrace();
}
```

:::

### 内部動作

`try-with-resources`構文は、リソースを確実にクローズするために以下のように動作する。

1. `try`ブロック内のコードが実行される
2. `try`ブロック内で例外が発生した場合、リソースは`catch`ブロックに入る前にクローズされる
3. すべてのリソースがクローズされた後に、例外が再スローされる
4. 例外が発生しない場合でも、`try`ブロックを抜けるときにリソースがクローズされる

### まとめ

- **目的**: リソースリークを防止し、リソースの確実な解放を保証する。
- **使用方法**: `try`ブロック内でリソースを宣言し、`AutoCloseable`インターフェースを実装しているリソースを自動的にクローズする。
- **利点**: 明示的にリソースをクローズする必要がなくなり、コードが簡潔で安全になる。
- **適用範囲**: ファイル操作、データベース接続、ネットワークソケットなど。

## カスタム例外クラス

### 概要

Java では、特定の状況に応じた例外を扱うために、独自のカスタム例外クラスを作成することができる。カスタム例外クラスを作成することで、エラーハンドリングをより明確かつ特定の用途に適したものにすることが可能。

### 目的

- 特定のエラー条件を明示的に表現し、エラーハンドリングをより詳細に制御すること
- これにより、エラーメッセージがより理解しやすくなり、デバッグや保守が容易になる

### 解決したい技術的課題

**問題点**:

- 標準の例外クラスでは、特定の状況に対応するエラーメッセージや処理を適切に表現できない場合がある
- カスタム例外を使用しないと、エラーハンドリングが一般化しすぎて、具体的な問題の特定や対処が困難になる

**解決策**:

- カスタム例外クラスを作成し、特定のエラー条件に対して適切なエラーメッセージとハンドリングを提供する。

### カスタム例外クラスの作成手順

1. `Exception` or `Runtime Exception` クラスを継承する
2. コンストラクタを定義する
3. 必要に応じて追加のメソッドを定義する

### 具体例

1. **基本的なカスタム例外クラス**

   ```java
   public class MyCustomException extends Exception {
       // デフォルトコンストラクタ
       public MyCustomException() {
           super();
       }

       // エラーメッセージを受け取るコンストラクタ
       public MyCustomException(String message) {
           super(message);
       }

       // エラーメッセージと原因を受け取るコンストラクタ
       public MyCustomException(String message, Throwable cause) {
           super(message, cause);
       }

       // 原因を受け取るコンストラクタ
       public MyCustomException(Throwable cause) {
           super(cause);
       }
   }
   ```

2. **カスタム実行時例外クラス**

   ```java
   public class MyCustomRuntimeException extends RuntimeException {
       public MyCustomRuntimeException() {
           super();
       }

       public MyCustomRuntimeException(String message) {
           super(message);
       }

       public MyCustomRuntimeException(String message, Throwable cause) {
           super(message, cause);
       }

       public MyCustomRuntimeException(Throwable cause) {
           super(cause);
       }
   }
   ```

### 使用例

1. **チェック例外の使用例**

   ```java
   public class Example {
       public static void main(String[] args) {
           try {
               checkCondition(false);
           } catch (MyCustomException e) {
               e.printStackTrace();
           }
       }

       public static void checkCondition(boolean condition) throws MyCustomException {
           if (!condition) {
               throw new MyCustomException("Condition failed");
           }
       }
   }
   ```

2. **実行時例外の使用例**

   ```java
   public class Example {
       public static void main(String[] args) {
           try {
               validateInput(null);
           } catch (MyCustomRuntimeException e) {
               e.printStackTrace();
           }
       }

       public static void validateInput(String input) {
           if (input == null) {
               throw new MyCustomRuntimeException("Input must not be null");
           }
       }
   }
   ```

### まとめ

- **目的**: 特定のエラー条件を明示的に表現し、エラーハンドリングを詳細に制御するため。
- **使用方法**: `Exception`または`RuntimeException`クラスを継承し、適切なコンストラクタを定義する。
- **利点**:
  - エラーメッセージが明確になり、デバッグが容易になる。
  - エラーハンドリングを特定の状況に適したものにできる。
- **ユースケース**:
  - チェック例外として使用し、特定の条件が満たされない場合にスローする。
  - 実行時例外として使用し、無効な入力や状態に対するエラーチェックを行う。
