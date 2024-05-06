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
   - ディタのシンタックスハイライト機能やコンパイラのエラーメッセージを参考に、コードを見直し修正する

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

### 例外クラスの分類

1. **`Exception` クラス**

- アプリケーションレベルで処理すべき例外を表すクラス
- 「チェック例外」と「ランタイム例外」の 2 つに分けられる
- ランタイム例外は、`Exception` のサブクラスである `RuntimeException` クラスを継承している

2. **`Error` クラス**
   - ステムレベルのエラーを表す
   - 通常はアプリケーションコードで捕捉または処理されることは期待されない
   - 例：`OutOfMemoryError`, `StackOverflowError`

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
   - の部分で、例外に対する具体的な対処（ログの記録、エラーメッセージの表示、リソースのクリーンアップ、再試行のロジックなど）が行われる
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
