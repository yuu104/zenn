---
title: "FileReaderクラス"
---

## 概要

- **テキストファイル**から文字データを読み込むためのクラス
- `java.io` パッケージに属し、`Reader` クラスを継承している
- ファイルから文字単位でデータを読み込むため、テキストファイルの処理に使用される

## 目的

- **テキストファイルからの読み込み**:
  簡単にテキストファイルから文字データを読み込むためのクラスを提供。
- **文字エンコーディング**:
  デフォルトの文字エンコーディングを使用してデータを読み込む。

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
  try (FileReader reader = new FileReader("example.txt")) {
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
  try (FileReader reader = new FileReader("example.txt")) {
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
  try (FileReader reader = new FileReader("example.txt")) {
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
  try (FileReader reader = new FileReader("example.txt")) {
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

### ファイルからテキストデータを読み込む

以下は、`FileReader` クラスを使用してファイルからテキストデータを読み込む簡単な例です。この例では、`FileReader` を用いてファイルから文字列を読み込みます。

```java
import java.io.FileReader;
import java.io.IOException;
import java.io.BufferedReader;

public class FileReaderExample {
    public static void main(String[] args) {
        // try-with-resources構文を使用してFileReaderを作成し、リソースの自動解放を行う
        try (FileReader reader = new FileReader("example.txt");
             BufferedReader bufferedReader = new BufferedReader(reader)) {

            // ファイルから行単位でデータを読み込み、コンソールに出力する
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

1. **`FileReader` の作成**:

   - `FileReader reader = new FileReader("example.txt")` により、`example.txt` という名前のファイルから読み込むための `FileReader` オブジェクトを作成します。

2. **`try-with-resources` 構文の使用**:

   - `try-with-resources` 構文を使用することで、`FileReader` が自動的にクローズされ、リソースリークを防ぎます。

3. **`BufferedReader` の使用**:

   - `BufferedReader bufferedReader = new BufferedReader(reader)` により、`BufferedReader` を使用してファイルから効率的にデータを読み込みます。`BufferedReader` は内部バッファを使用するため、I/O 操作の回数が減り、パフォーマンスが向上します。

4. **テキストデータの読み込み**:

   - `String line;` で変数 `line` を定義し、`while ((line = bufferedReader.readLine()) != null)` ループ内で `bufferedReader.readLine()` を使用してファイルから行単位でデータを読み込みます。読み込んだ行が `null` でない限り、コンソールに出力します。

5. **例外処理**:
   - 読み込み操作中に `IOException` が発生した場合、`catch (IOException e)` ブロックで例外がキャッチされ、`e.printStackTrace()` によりスタックトレースが出力されます。

このように `FileReader` クラスを使用することで、簡単にテキストファイルから文字データを読み込むことができます。効率的なデータ読み込みのために、`BufferedReader` と組み合わせて使用することが推奨されます。

## まとめ

`FileReader` クラスは、Java でテキストファイルから文字データを読み込むためのシンプルで使いやすいクラス。ファイルから文字データを効率的に読み込むための主要なメソッドを提供し、テキストファイルの読み込みや解析に適している。
