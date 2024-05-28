---
title: "InputStreamReaderクラス"
---

## 概要

- **バイナリデータをテキストデータに変換して読み込み処理を行えるようにするクラス**
- `java.io` パッケージに属し、`Reader` クラスを継承している
- バイトストリームから文字単位でデータを読み込むため、文字エンコーディングを指定してデータを処理する際に使用される

## 目的

- **バイトストリームの文字ストリームへの変換**:
  バイトデータを文字データに変換し、特定の文字エンコーディングで処理するためのクラスを提供。
- **文字エンコーディングのサポート**:
  様々な文字エンコーディングに対応し、バイトストリームから文字データを効率的に読み込む。

## コンストラクタ

### `InputStreamReader(InputStream in)`

デフォルトの文字エンコーディングを使用して、指定された `InputStream` からデータを読み込む `InputStreamReader` を作成する。

```java
InputStream in = new FileInputStream("example.txt");
InputStreamReader reader = new InputStreamReader(in);
```

### `InputStreamReader(InputStream in, String charsetName)`

指定された文字エンコーディングを使用して、指定された `InputStream` からデータを読み込む `InputStreamReader` を作成する。

```java
InputStream in = new FileInputStream("example.txt");
InputStreamReader reader = new InputStreamReader(in, "UTF-8");
```

### `InputStreamReader(InputStream in, Charset charset)`

指定された `Charset` オブジェクトを使用して、`InputStream` からデータを読み込む `InputStreamReader` を作成する。

```java
InputStream in = new FileInputStream("example.txt");
InputStreamReader reader = new InputStreamReader(in, StandardCharsets.UTF_8);
```

## 主要メソッド

:::details read() ~ 1 文字を読み込む

- **説明**:

  - 1 文字を読み込み、その文字の値を返す
  - ストリームの終わりに達した場合は `-1` を返す

- **シグネチャ**:

  ```java
  int read() throws IOException
  ```

- **例**:
  ```java
  try (InputStreamReader reader = new InputStreamReader(new FileInputStream("example.txt"), StandardCharsets.UTF_8)) {
      int data = reader.read();
      while (data != -1) {
          char character = (char) data;
          System.out.print(character);
          data = reader.read();
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details read(char[] cbuf, int offset, int length) ~ 文字バッファへの読み込み

- **説明**:

  - 指定されたバッファに文字を読み込み、読み込んだ文字数を返す

- **シグネチャ**:

  ```java
  int read(char[] cbuf, int offset, int length) throws IOException
  ```

- **例**:
  ```java
  try (InputStreamReader reader = new InputStreamReader(new FileInputStream("example.txt"), StandardCharsets.UTF_8)) {
      char[] buffer = new char[1024];
      int numCharsRead = reader.read(buffer, 0, buffer.length);
      while (numCharsRead != -1) {
          System.out.print(new String(buffer, 0, numCharsRead));
          numCharsRead = reader.read(buffer, 0, buffer.length);
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details close() ~ リーダーのクローズ

- **説明**:

  - リーダーを閉じ、リーダーに関連するすべてのシステムリソースを解放する

- **シグネチャ**:

  ```java
  void close() throws IOException
  ```

- **例**:
  ```java
  try (InputStreamReader reader = new InputStreamReader(new FileInputStream("example.txt"), StandardCharsets.UTF_8)) {
      // ファイルの読み込み処理
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details read(char[] cbuf) ~ 文字バッファへの読み込み

- **説明**:

  - 指定されたバッファに文字を読み込み、読み込んだ文字数を返す

- **シグネチャ**:

  ```java
  int read(char[] cbuf) throws IOException
  ```

- **例**:
  ```java
  try (InputStreamReader reader = new InputStreamReader(new FileInputStream("example.txt"), StandardCharsets.UTF_8)) {
      char[] buffer = new char[1024];
      int numCharsRead = reader.read(buffer);
      while (numCharsRead != -1) {
          System.out.print(new String(buffer, 0, numCharsRead));
          numCharsRead = reader.read(buffer);
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

## 使用例

### バイトストリームからテキストデータを読み込む

以下は、`InputStreamReader` クラスを使用してバイトストリームからテキストデータを読み込む簡単な例です。この例では、`InputStreamReader` を用いてバイトストリームを文字ストリームに変換し、文字列を読み込みます。

```java
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.io.BufferedReader;

public class InputStreamReaderExample {
    public static void main(String[] args) {
        // try-with-resources構文を使用してInputStreamReaderを作成し、リソースの自動解放を行う
        try (InputStreamReader reader = new InputStreamReader(new FileInputStream("example.txt"), StandardCharsets.UTF_8);
             BufferedReader bufferedReader = new BufferedReader(reader)) {

            // バイトストリームから行単位でデータを読み込み、コンソールに出力する
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            // 例外が発生した場合、スタックトレースを出力
            e.printStackTrace();
        }
    }
}
```

#### 詳細解説

1. **`InputStreamReader` の作成**:

   - `InputStreamReader reader = new InputStreamReader(new FileInputStream("example.txt"), StandardCharsets.UTF_8)` により、`example.txt` という名前のファイルからバイトストリームを読み込み、UTF-8 エンコーディングで文字ストリームに変換するための `InputStreamReader` オブジェクトを作成します。

2. **`try-with-resources` 構文の使用**:

   - `try-with-resources` 構文を使用することで、`InputStreamReader` が自動的にクローズされ、リソースリークを防ぎます。

3. **`BufferedReader` の使用**:

   - `BufferedReader bufferedReader = new BufferedReader(reader)` により、`BufferedReader` を使用してバイトストリームから効率的にデータを読み込みます。`BufferedReader` は内部バッファを使用するため、I/O 操作の回数が減り、パフォーマンスが向上します。

4. **テキストデータの読み込み**:

   - `String line;` で変数 `line` を定義し、`while ((line = bufferedReader.readLine()) != null)` ループ内で `bufferedReader.readLine()` を使用してバイトストリームから行単位でデータを読み込みます。読み込んだ行が `null` でない限り、コンソールに出力します。

5. **例外処理**:
   - 読み込み操作中に `IOException` が発生した場合、`catch (IOException e)` ブロックで例外がキャッチされ、`e.printStackTrace()` によりスタックトレースが出力されます。

このように `InputStreamReader` クラスを使用することで、バイトストリームを簡単に文字ストリームに変換し、特定の文字エンコーディングで文字データを読み込むことができます。

## まとめ

`InputStreamReader` クラスは、Java でバイトストリームを文字ストリームに変換するためのシンプルで使いやすいクラス。特定の文字エンコーディングでバイトデータを文字データに変換し、効率的に読み込みを行うための主要なメソッドを提供し、ネットワークやファイルからのデータ読み込みに適している。
