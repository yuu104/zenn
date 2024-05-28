---
title: "BufferedOutputStreamクラス"
---

## 概要

- **バイナリデータ**を効率的に書き込むためのクラス
- `java.io` パッケージに属し、`FilterOutputStream` クラスを継承している
- データを一度にまとめて書き込むことで、I/O 操作の回数を減らし、パフォーマンスを向上させる

## 目的

- **効率的なバイナリデータの書き込み**:
  内部バッファを使用して、ファイルやネットワークへのバイト単位の書き込みを効率化する。
- **I/O 操作の最適化**:
  I/O 操作の回数を減らし、パフォーマンスを向上させる。

## コンストラクタの解説

### `BufferedOutputStream(OutputStream out)`

- **説明**:
  - 指定された出力ストリームをバッファリングする `BufferedOutputStream` を作成します。デフォルトのバッファサイズ（8KB）を使用します。
- **使用例**:
  ```java
  FileOutputStream fos = new FileOutputStream("example.bin");
  BufferedOutputStream bos = new BufferedOutputStream(fos);
  ```

### `BufferedOutputStream(OutputStream out, int size)`

- **説明**:
  - 指定された出力ストリームをバッファリングする `BufferedOutputStream` を作成します。指定されたバッファサイズを使用します。
- **使用例**:
  ```java
  FileOutputStream fos = new FileOutputStream("example.bin");
  BufferedOutputStream bos = new BufferedOutputStream(fos, 16384); // 16KBのバッファ
  ```

## 主要メソッド

:::details write(int b) ~ 1 バイトを書き込む

- **説明**:

  - 1 バイトを書き込み、そのバイトの値をバッファに格納する。バッファが満杯になった場合、バッファの内容を出力ストリームに書き出します。

- **シグネチャ**:

  ```java
  public synchronized void write(int b) throws IOException
  ```

- **例**:
  ```java
  try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("example.bin"))) {
      bos.write(0x41); // 'A' のバイト値をバッファに書き込む
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details write(byte[] b, int off, int len) ~ バイトバッファの書き込み

- **説明**:

  - 指定されたバッファのバイトデータをバッファに格納する。バッファが満杯になった場合、バッファの内容を出力ストリームに書き出します。

- **シグネチャ**:

  ```java
  public synchronized void write(byte[] b, int off, int len) throws IOException
  ```

- **例**:
  ```java
  try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("example.bin"))) {
      byte[] buffer = {0x41, 0x42, 0x43}; // 'A', 'B', 'C' のバイト値
      bos.write(buffer, 0, buffer.length);
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details flush() ~ バッファの内容を強制的に書き込む

- **説明**:

  - バッファの内容を強制的に出力ストリームに書き出します。

- **シグネチャ**:

  ```java
  public synchronized void flush() throws IOException
  ```

- **例**:
  ```java
  try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("example.bin"))) {
      byte[] buffer = {0x41, 0x42, 0x43}; // 'A', 'B', 'C' のバイト値
      bos.write(buffer);
      bos.flush(); // バッファの内容を強制的に書き込む
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details close() ~ ストリームのクローズ

- **説明**:

  - ストリームを閉じ、ストリームに関連するすべてのシステムリソースを解放します。ストリームを閉じる前にバッファの内容が書き出されます。

- **シグネチャ**:

  ```java
  public void close() throws IOException
  ```

- **例**:
  ```java
  try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("example.bin"))) {
      byte[] buffer = {0x41, 0x42, 0x43}; // 'A', 'B', 'C' のバイト値
      bos.write(buffer);
      // リソースの解放とバッファの内容の書き出しはtry-with-resourcesによって自動的に行われる
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

## 使用例

### バイナリデータを効率的にファイルに書き込む

以下は、`BufferedOutputStream` クラスを使用してバイナリデータを効率的にファイルに書き込む簡単な例です。この例では、`BufferedOutputStream` を用いてデータをバッファリングしながら書き込みます。

```java
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class BufferedOutputStreamExample {
    public static void main(String[] args) {
        // try-with-resources構文を使用してBufferedOutputStreamを作成し、リソースの自動解放を行う
        try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("example.bin"))) {
            // バイナリデータを書き込む
            byte[] buffer = {0x41, 0x42, 0x43}; // 'A', 'B', 'C' のバイト値
            bos.write(buffer);
            // バッファの内容を強制的に書き込む
            bos.flush();
        } catch (IOException e) {
            // 例外が発生した場合、スタックトレースを出力
            e.printStackTrace();
        }
    }
}
```

### 詳細解説

1. **`BufferedOutputStream` の作成**:

   - `BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("example.bin"))` により、`example.bin` という名前のファイルにデータを効率的に書き込むための `BufferedOutputStream` オブジェクトを作成します。

2. **バイナリデータの書き込み**:

   - `byte[] buffer = {0x41, 0x42, 0x43}` により、書き込むバイナリデータを準備します。
   - `bos.write(buffer)` により、バッファの内容をファイルに書き込みます。

3. **バッファのフラッシュ**:

   - `bos.flush()` により、バッファに残っているデータを強制的にファイルに書き込みます。これにより、バッファ内のすべてのデータが確実に書き出されます。

4. **例外処理**:
   - 書き込み操作中に `IOException` が発生した場合、`catch (IOException e)` ブロックで例外がキャッチされ、`e.printStackTrace()` によりスタックトレースが出力されます。

このように、`BufferedOutputStream` クラスを使用することで、バイナリデータを効率的に書き込むことができます。

## まとめ

`BufferedOutputStream` クラスは、Java でバイナリデータを効率的に書き込むためのシンプルで使いやすいクラス。内部バッファを使用してデータを一度にまとめて書き込むことで、I/O 操作の回数を減らし、パフォーマンスを向上させるための主要なメソッドを提供し、バイナリファイルの書き込みに適しています。
