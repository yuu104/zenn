---
title: "Readerクラス"
---

## 概要

- **テキストデータ**を読み込むための抽象クラス
- `java.io` パッケージに属し、文字ストリームを扱う
- 文字単位でデータを読み込むため、テキストファイルや文字列データの処理に使用される

## 目的

- **テキストデータの読み込み**:
  ファイルやネットワークからのテキストデータを効率的に読み込む。
- **文字エンコーディングのサポート**:
  様々な文字エンコーディングに対応し、国際化されたテキスト処理を行う。

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
  try (Reader reader = new FileReader("example.txt")) {
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

  - 指定されたバッファに文字を読み込む
  - 読み込んだ文字数を返す

- **シグネチャ**:

  ```java
  int read(char[] cbuf, int offset, int length) throws IOException
  ```

- **例**:
  ```java
  try (Reader reader = new FileReader("example.txt")) {
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
  try (Reader reader = new FileReader("example.txt")) {
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
  try (Reader reader = new FileReader("example.txt")) {
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

:::details mark(int readAheadLimit) ~ マーク位置を設定

- **説明**:

  - マーク位置を設定し、`reset` メソッドで戻れるようにする

- **シグネチャ**:

  ```java
  void mark(int readAheadLimit) throws IOException
  ```

- **例**:
  ```java
  try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"))) {
      reader.mark(100); // 100文字先までリセット可能
      char[] buffer = new char[50];
      reader.read(buffer);
      System.out.print(buffer);
      reader.reset(); // マーク位置に戻る
      reader.read(buffer);
      System.out.print(buffer);
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details reset() ~ マーク位置にリセット

- **説明**:

  - マーク位置にリセットし、そこから再度読み込みを行う

- **シグネチャ**:

  ```java
  void reset() throws IOException
  ```

- **例**:
  ```java
  try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"))) {
      reader.mark(100); // 100文字先までリセット可能
      char[] buffer = new char[50];
      reader.read(buffer);
      System.out.print(buffer);
      reader.reset(); // マーク位置に戻る
      reader.read(buffer);
      System.out.print(buffer);
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details skip(long n) ~ 指定された文字数をスキップ

- **説明**:

  - 指定された文字数をスキップし、その分だけ読み込み位置を進める

- **シグネチャ**:

  ```java
  long skip(long n) throws IOException
  ```

- **例**:
  ```java
  try (Reader reader = new FileReader("example.txt")) {
      reader.skip(100); // 最初の100文字をスキップ
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

## 代表的な具象クラス

- **`FileReader`**

  - ファイルから文字データを読み込むためのクラス。

  ```java
  Reader reader = new FileReader("example.txt");
  ```

- **`BufferedReader`**

  - テキストの効率的な読み込みを行うためのクラス。内部バッファを使用して、読み込みパフォーマンスを向上させる。

  ```java
  BufferedReader bufferedReader = new BufferedReader(new FileReader("example.txt"));
  ```

- **`InputStreamReader`**
  - バイトストリームを文字ストリームに変換するためのクラス。特定の文字エンコーディングを使用してデータを読み込むことができる。
  ```java
  Reader reader = new InputStreamReader(new FileInputStream("example.txt"), StandardCharsets.UTF_8);
  ```

## 使用例

### ファイルからテキストデータを読み込む

```java
import java.io.*;

public class ReaderExample {
    public static void main(String[] args) {
        try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## バッファリングの利点

- **効率的な読み込み**:
  `BufferedReader` を使用すると、文字を 1 つずつ読み込むのではなく、バッファにデータをまとめて読み込むため、I/O 操作の回数が減り、パフォーマンスが向上する。
- **行単位の読み込み**:
  `readLine()` メソッドを使用することで、行単位でテキストデータを処理できる。

## まとめ

`Reader` クラスは、Java でのテキストデータの読み込みにおける基盤を提供する抽象クラス。ファイル、ネットワーク、バイトストリームなどから効率的にテキストデータを読み込むための多くの具象クラスが存在し、用途に応じて選択できる。特に、`BufferedReader` を使用することで大規模なデータの処理が効率的に行える。
