---
title: "BufferedInputStreamクラス"
---

## 概要

- **バイナリデータ**を効率的に読み込むためのクラス
- `java.io` パッケージに属し、`FilterInputStream` クラスを継承している
- データを一度にまとめて読み込むことで、I/O 操作の回数を減らし、パフォーマンスを向上させる

## 目的

- **効率的なバイナリデータの読み込み**:
  内部バッファを使用して、ファイルやネットワークからのバイト単位の読み込みを効率化する。
- **I/O 操作の最適化**:
  I/O 操作の回数を減らし、パフォーマンスを向上させる。

## コンストラクタの解説

### `BufferedInputStream(InputStream in)`

- **説明**:
  - 指定された入力ストリームをバッファリングする `BufferedInputStream` を作成します。デフォルトのバッファサイズ（8KB）を使用します。
- **使用例**:
  ```java
  FileInputStream fis = new FileInputStream("example.bin");
  BufferedInputStream bis = new BufferedInputStream(fis);
  ```

### `BufferedInputStream(InputStream in, int size)`

- **説明**:
  - 指定された入力ストリームをバッファリングする `BufferedInputStream` を作成します。指定されたバッファサイズを使用します。
- **使用例**:
  ```java
  FileInputStream fis = new FileInputStream("example.bin");
  BufferedInputStream bis = new BufferedInputStream(fis, 16384); // 16KBのバッファ
  ```

## 主要メソッド

:::details read() ~ 1 バイトを読み込む

- **説明**:

  - 1 バイトを読み込み、そのバイトの値を返す。ストリームの終わりに達した場合は `-1` を返す。

- **シグネチャ**:

  ```java
  public int read() throws IOException
  ```

- **例**:
  ```java
  try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))) {
      int data = bis.read();
      while (data != -1) {
          System.out.print((char) data);
          data = bis.read();
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details read(byte[] b, int off, int len) ~ バイトバッファへの読み込み

- **説明**:

  - 指定されたバッファにバイトデータを読み込み、読み込んだバイト数を返す。

- **シグネチャ**:

  ```java
  public int read(byte[] b, int off, int len) throws IOException
  ```

- **例**:
  ```java
  try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))) {
      byte[] buffer = new byte[1024];
      int bytesRead = bis.read(buffer, 0, buffer.length);
      while (bytesRead != -1) {
          for (int i = 0; i < bytesRead; i++) {
              System.out.print((char) buffer[i]);
          }
          bytesRead = bis.read(buffer, 0, buffer.length);
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details close() ~ ストリームのクローズ

- **説明**:

  - ストリームを閉じ、ストリームに関連するすべてのシステムリソースを解放する。

- **シグネチャ**:

  ```java
  public void close() throws IOException
  ```

- **例**:
  ```java
  try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))) {
      // ファイルの読み込み処理
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details mark(int readlimit) ~ マーク位置の設定

- **説明**:

  - ストリームの現在位置にマークを設定し、`reset` メソッドでマークした位置に戻れるようにする。

- **シグネチャ**:

  ```java
  public synchronized void mark(int readlimit)
  ```

- **例**:
  ```java
  try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))) {
      bis.mark(100); // 100バイトまでリセット可能
      byte[] buffer = new byte[50];
      bis.read(buffer);
      System.out.print(new String(buffer));
      bis.reset(); // マーク位置にリセット
      bis.read(buffer);
      System.out.print(new String(buffer));
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details reset() ~ マーク位置にリセット

- **説明**:

  - ストリームのマークされた位置にリセットし、そこから再度読み込みを行う。

- **シグネチャ**:

  ```java
  public synchronized void reset() throws IOException
  ```

- **例**:
  ```java
  try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))) {
      bis.mark(100); // 100バイトまでリセット可能
      byte[] buffer = new byte[50];
      bis.read(buffer);
      System.out.print(new String(buffer));
      bis.reset(); // マーク位置にリセット
      bis.read(buffer);
      System.out.print(new String(buffer));
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details skip(long n) ~ 指定されたバイト数をスキップ

- **説明**:

  - 指定されたバイト数をスキップし、その分だけ読み込み位置を進める。

- **シグネチャ**:

  ```java
  public long skip(long n) throws IOException
  ```

- **例**:
  ```java
  try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))) {
      bis.skip(100); // 最初の100バイトをスキップ
      int data = bis.read();
      while (data != -1) {
          System.out.print((char) data);
          data = bis.read();
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

## 使用例

### バイナリファイルから効率的にデータを読み込む

以下は、`BufferedInputStream` クラスを使用してバイナリファイルからデータを効率的に読み込む簡単な例です。この例では、`BufferedInputStream` を用いてデータをバッファリングしながら読み込みます。

```java
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;

public class BufferedInputStreamExample {
    public static void main(String[] args) {
        // try-with-resources構文を使用してBufferedInputStreamを作成し、リソースの自動解放を行う
        try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))) {
            // バイナリデータを読み込む
            byte[] buffer = new byte[1024];
            int bytesRead = bis.read(buffer);
            while (bytesRead != -1) {
                for (int i = 0; i < bytesRead; i++) {
                    System.out.print((char) buffer[i]); // バイナリデータを文字として出力（適宜変換が必要）
                }
                bytesRead = bis.read(buffer);
            }
        } catch (IOException e) {
            // 例外が発生した場合、スタックトレースを出力
            e.printStackTrace();
        }
    }
}
```

### 詳細解説

1. **`BufferedInputStream` の作成**:

   - `BufferedInputStream bis = new BufferedInputStream(new FileInputStream("example.bin"))` により、`example.bin` という名前のファイルからデータを効率的に読み込むための `BufferedInputStream` オブジェクトを作成します。

2. **バイナリデータの読み込み**:

   - `byte[] buffer = new byte[1024]` により、読み込んだデータを格納するバッファを作成します。
   - `int bytesRead = bis.read(buffer)` により、ファイルからバッファにバイトデータを読み込みます。
   - `while (bytesRead != -1)` ループ内で、バッファから読み込んだバイトデータを処理し、ファイルの終わりに達するまで読み込みを繰り返します。

3. **例外処理**:
   - 読み込み操作中に `IOException` が発生した場合、`catch (IOException e)` ブロックで例外がキャッチされ、`e

.printStackTrace()` によりスタックトレースが出力されます。

このように、`BufferedInputStream` クラスを使用することで、バイナリデータを効率的に読み込むことができます。

## まとめ

`BufferedInputStream` クラスは、Java でバイナリデータを効率的に読み込むためのシンプルで使いやすいクラス。内部バッファを使用してデータを一度にまとめて読み込むことで、I/O 操作の回数を減らし、パフォーマンスを向上させるための主要なメソッドを提供し、バイナリファイルの読み込みに適しています。
