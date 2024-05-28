---
title: "OutputStreamWeiter"
---

## 概要

- **テキストデータをバイナリデータに変換して書き込み処理を行えるようにするクラス**
- `java.io` パッケージに属し、`Writer` クラスを継承している
- 文字ストリームからバイト単位でデータを書き込むため、文字エンコーディングを指定してデータを処理する際に使用される

## 目的

- **文字ストリームのバイトストリームへの変換**:
  文字データをバイトデータに変換し、特定の文字エンコーディングで処理するためのクラスを提供。
- **文字エンコーディングのサポート**:
  様々な文字エンコーディングに対応し、文字ストリームからバイトデータを効率的に書き込む。

## コンストラクタ

### `OutputStreamWriter(OutputStream out)`

デフォルトの文字エンコーディングを使用して、指定された `OutputStream` にデータを書き込む `OutputStreamWriter` を作成する。

```java
OutputStream out = new FileOutputStream("example.txt");
OutputStreamWriter writer = new OutputStreamWriter(out);
```

### `OutputStreamWriter(OutputStream out, String charsetName)`

指定された文字エンコーディングを使用して、指定された `OutputStream` にデータを書き込む `OutputStreamWriter` を作成する。

```java
OutputStream out = new FileOutputStream("example.txt");
OutputStreamWriter writer = new OutputStreamWriter(out, "UTF-8");
```

### `OutputStreamWriter(OutputStream out, Charset charset)`

指定された `Charset` オブジェクトを使用して、指定された `OutputStream` にデータを書き込む `OutputStreamWriter` を作成する。

```java
OutputStream out = new FileOutputStream("example.txt");
OutputStreamWriter writer = new OutputStreamWriter(out, StandardCharsets.UTF_8);
```

## 主要メソッド

:::details write(int c) ~ 1 文字を書き込む

- **説明**:

  -

1 文字を書き込む

- **シグネチャ**:

  ```java
  void write(int c) throws IOException
  ```

- **例**:
  ```java
  try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)) {
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
  try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)) {
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
  try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)) {
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
  try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)) {
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
  try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)) {
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
  try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)) {
      writer.write("Hello, World!");
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

## 使用例

### 文字ストリームからテキストデータを書き込む

以下は、`OutputStreamWriter` クラスを使用して文字ストリームからテキストデータを書き込む簡単な例です。この例では、`OutputStreamWriter` を用いて文字ストリームをバイトストリームに変換し、文字列をファイルに書き込みます。

```java
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;

public class OutputStreamWriterExample {
    public static void main(String[] args) {
        // try-with-resources構文を使用してOutputStreamWriterを作成し、リソースの自動解放を行う
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)) {
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

1. **`OutputStreamWriter` の作成**:

   - `OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("example.txt"), StandardCharsets.UTF_8)` により、`example.txt` という名前のファイルに書き込むための `OutputStreamWriter` オブジェクトを作成します。文字データは UTF-8 エンコーディングでバイトストリームに変換されます。

2. **`try-with-resources` 構文の使用**:

   - `try-with-resources` 構文を使用することで、`OutputStreamWriter` が自動的にクローズされ、リソースリークを防ぎます。

3. **テキストデータの書き込み**:

   - `writer.write("Hello, World!")` により、文字列 "Hello, World!" をファイルに書き込みます。
   - `writer.write(System.lineSeparator())` により、システム依存の改行文字をファイルに書き込みます。これにより、プラットフォームに依存せずに改行を追加できます。
   - `writer.write("This is a text file.")` により、追加の文字列 "This is a text file." をファイルに書き込みます。

4. **例外処理**:
   - 書き込み操作中に `IOException` が発生した場合、`catch (IOException e)` ブロックで例外がキャッチされ、`e.printStackTrace()` によりスタックトレースが出力されます。

このように `OutputStreamWriter` クラスを使用することで、簡単に文字ストリームをバイトストリームに変換し、特定の文字エンコーディングで文字データを書き込むことができます。

## まとめ

`OutputStreamWriter` クラスは、Java で文字ストリームをバイトストリームに変換するためのシンプルで使いやすいクラス。特定の文字エンコーディングで文字データをバイトデータに変換し、効率的に書き込みを行うための主要なメソッドを提供し、ネットワークやファイルへのデータ書き込みに適している。
