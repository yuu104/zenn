---
title: "FileWriterクラス"
---

## 概要

- **テキストファイル**に文字データを書き込むためのクラス
- `java.io` パッケージに属し、`Writer` クラスを継承している
- ファイルに文字単位でデータを書き込むため、テキストファイルの処理に使用される

## 目的

- **テキストファイルへの書き込み**:
  簡単にテキストファイルに文字データを書き込むためのクラスを提供。
- **文字エンコーディング**:
  デフォルトの文字エンコーディングを使用してデータを書き込む。

## 主要メソッド

:::details write(int c) ~ 1 文字を書き込む

- **説明**:

  - 1 文字を書き込む

- **シグネチャ**:

  ```java
  void write(int c) throws IOException
  ```

- **例**:
  ```java
  try (FileWriter writer = new FileWriter("example.txt")) {
      writer.write('A');
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details write(char[] cbuf, int offset, int length) ~ 文字バッファからの書き込み

- **説明**:

  - 指定されたバッファから文字を書き込む

- **シグネチャ**:

  ```java
  void write(char[] cbuf, int offset, int length) throws IOException
  ```

- **例**:
  ```java
  try (FileWriter writer = new FileWriter("example.txt")) {
      char[] buffer = "Hello, World!".toCharArray();
      writer.write(buffer, 0, buffer.length);
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details write(String str, int offset, int length) ~ 文字列からの書き込み

- **説明**:

  - 指定された文字列から文字を書き込む

- **シグネチャ**:

  ```java
  void write(String str, int offset, int length) throws IOException
  ```

- **例**:
  ```java
  try (FileWriter writer = new FileWriter("example.txt")) {
      writer.write("Hello, World!", 0, "Hello, World!".length());
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details append(CharSequence csq) ~ 文字列の追加

- **説明**:

  - 指定された文字列を末尾に追加する

- **シグネチャ**:

  ```java
  Writer append(CharSequence csq) throws IOException
  ```

- **例**:
  ```java
  try (FileWriter writer = new FileWriter("example.txt")) {
      writer.append("Hello");
      writer.append(", World!");
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details flush() ~ バッファの内容を強制的に書き込む

- **説明**:

  - バッファリングされたデータを強制的に書き込む

- **シグネチャ**:

  ```java
  void flush() throws IOException
  ```

- **例**:
  ```java
  try (FileWriter writer = new FileWriter("example.txt")) {
      writer.write("Hello, World!");
      writer.flush();
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details close() ~ ライターのクローズ

- **説明**:

  - ライターを閉じ、ライターに関連するすべてのシステムリソースを解放する

- **シグネチャ**:

  ```java
  void close() throws IOException
  ```

- **例**:
  ```java
  try (FileWriter writer = new FileWriter("example.txt")) {
      writer.write("Hello, World!");
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

## 使用例

### ファイルにテキストデータを書き込む

以下は、`FileWriter` クラスを使用してファイルにテキストデータを書き込む簡単な例です。この例では、`FileWriter` を用いて文字列をファイルに書き込みます。

```java
import java.io.FileWriter;
import java.io.IOException;

public class FileWriterExample {
    public static void main(String[] args) {
        // try-with-resources構文を使用してFileWriterを作成し、リソースの自動解放を行う
        try (FileWriter writer = new FileWriter("example.txt")) {
            // テキスト "Hello, World!" をファイルに書き込む
            writer.write("Hello, World!");
            // 改行を追加するためにシステム依存の改行文字を使用
            writer.write(System.lineSeparator());
            // 追加のテキスト "This is a text file." を書き込む
            writer.write("This is a text file.");
        } catch (IOException e) {
            // 例外が発生した場合、スタックトレースを出力
            e.printStackTrace();
        }
    }
}
```

#### 詳細解説

1. **`FileWriter` の作成**:

   - `FileWriter writer = new FileWriter("example.txt")` により、`example.txt` という名前のファイルに書き込むための `FileWriter` オブジェクトを作成します。ファイルが存在しない場合は新規作成され、存在する場合は上書きされます。

2. **`try-with-resources` 構文の使用**:

   - `try-with-resources` 構文を使用することで、`FileWriter` が自動的にクローズされ、リソースリークを防ぎます。

3. **テキストデータの書き込み**:

   - `writer.write("Hello, World!")` により、文字列 "Hello, World!" をファイルに書き込みます。
   - `writer.write(System.lineSeparator())` により、システム依存の改行文字をファイルに書き込みます。これにより、プラットフォームに依存せずに改行を追加できます。
   - `writer.write("This is a text file.")` により、追加の文字列 "This is a text file." をファイルに書き込みます。

4. **例外処理**:
   - 書き込み操作中に `IOException` が発生した場合、`catch (IOException e)` ブロックで例外がキャッチされ、`e.printStackTrace()` によりスタックトレースが出力されます。

このように `FileWriter` クラスを使用することで、簡単にテキストファイルに文字データを書き込むことができます。リソース管理を適切に行うために、`try-with-resources` 構文を使用することが推奨されます。

## まとめ

`FileWriter` クラスは、Java でテキストファイルに文字データを書き込むためのシンプルで使いやすいクラス。ファイルに文字データを効率的に書き込むための主要なメソッドを提供し、テキストファイルの作成や編集に適している。
