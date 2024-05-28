---
title: "FileInputStreamクラス"
---

## 概要

- **バイナリデータ**をファイルから読み込むためのクラス
- `java.io` パッケージに属し、`InputStream` クラスを継承している
- ファイルからバイト単位でデータを読み込むため、画像、音声、動画、実行ファイルなどのバイナリデータの処理に使用される

## 目的

- **ファイルからのバイナリデータの読み込み**:
  ファイルからバイト単位でデータを効率的に読み込むためのクラスを提供。
- **低レベルの I/O 操作**:
  低レベルのバイトストリーム操作を提供し、バイナリファイルの読み込みに適している。

## コンストラクタの解説

### `FileInputStream(String name)`

- **説明**:
  - 指定されたファイル名を持つファイルからデータを読み込むための `FileInputStream` を作成します。
- **使用例**:
  ```java
  FileInputStream fis = new FileInputStream("example.bin");
  ```

### `FileInputStream(File file)`

- **説明**:
  - 指定された `File` オブジェクトを持つファイルからデータを読み込むための `FileInputStream` を作成します。
- **使用例**:
  ```java
  File file = new File("example.bin");
  FileInputStream fis = new FileInputStream(file);
  ```

### `FileInputStream(FileDescriptor fdObj)`

- **説明**:
  - 指定されたファイル記述子を持つファイルからデータを読み込むための `FileInputStream` を作成します。
- **使用例**:
  ```java
  FileDescriptor fd = ...; // ファイル記述子の取得方法は環境による
  FileInputStream fis = new FileInputStream(fd);
  ```

## 主要メソッド

:::details read() ~ 1 バイトを読み込む

- **説明**:

  - 1 バイトを読み込み、そのバイトの値を返す
  - ストリームの終わりに達した場合は `-1` を返す

- **シグネチャ**:

  ```java
  public int read() throws IOException
  ```

- **例**:
  ```java
  try (FileInputStream fis = new FileInputStream("example.bin")) {
      int data = fis.read();
      while (data != -1) {
          System.out.print((char) data);
          data = fis.read();
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details read(byte[] b, int off, int len) ~ バイトバッファへの読み込み

- **説明**:

  - 指定されたバッファにバイトデータを読み込み、読み込んだバイト数を返す

- **シグネチャ**:

  ```java
  public int read(byte[] b, int off, int len) throws IOException
  ```

- **例**:
  ```java
  try (FileInputStream fis = new FileInputStream("example.bin")) {
      byte[] buffer = new byte[1024];
      int bytesRead = fis.read(buffer, 0, buffer.length);
      while (bytesRead != -1) {
          for (int i = 0; i < bytesRead; i++) {
              System.out.print((char) buffer[i]);
          }
          bytesRead = fis.read(buffer, 0, buffer.length);
      }
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details close() ~ ストリームのクローズ

- **説明**:

  - ストリームを閉じ、ストリームに関連するすべてのシステムリソースを解放する

- **シグネチャ**:

  ```java
  public void close() throws IOException
  ```

- **例**:
  ```java
  try (FileInputStream fis = new FileInputStream("example.bin")) {
      // ファイルの読み込み処理
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

:::details available() ~ 利用可能なバイト数を取得

- **説明**:

  - 入力ストリームからブロックせずに読み取ることができる利用可能なバイト数を返す

- **シグネチャ**:

  ```java
  public int available() throws IOException
  ```

- **例**:
  ```java
  try (FileInputStream fis = new FileInputStream("example.bin")) {
      int availableBytes = fis.available();
      System.out.println("Available bytes: " + availableBytes);
  } catch (IOException e) {
      e.printStackTrace();
  }
  ```

:::

## 使用例

### バイナリファイルからデータを読み込む

以下は、`FileInputStream` クラスを使用してバイナリファイルからデータを読み込む簡単な例です。この例では、`FileInputStream` を用いてバイナリデータを読み込み、コンソールに出力します。

```java
import java.io.FileInputStream;
import java.io.IOException;

public class FileInputStreamExample {
    public static void main(String[] args) {
        // try-with-resources構文を使用してFileInputStreamを作成し、リソースの自動解放を行う
        try (FileInputStream fis = new FileInputStream("example.bin")) {
            // バイナリデータを読み込む
            byte[] buffer = new byte[1024];
            int bytesRead = fis.read(buffer);
            while (bytesRead != -1) {
                for (int i = 0; i < bytesRead; i++) {
                    System.out.print((char) buffer[i]); // バイナリデータを文字として出力（適宜変換が必要）
                }
                bytesRead = fis.read(buffer);
            }
        } catch (IOException e) {
            // 例外が発生した場合、スタックトレースを出力
            e.printStackTrace();
        }
    }
}
```

### 詳細解説

1. **`FileInputStream` の作成**:

   - `FileInputStream fis = new FileInputStream("example.bin")` により、`example.bin` という名前のファイルからデータを読み込むための `FileInputStream` オブジェクトを作成します。

2. **バイナリデータの読み込み**:

   - `byte[] buffer = new byte[1024]` により、読み込んだデータを格納するバッファを作成します。
   - `int bytesRead = fis.read(buffer)` により、ファイルからバッファにバイトデータを読み込みます。
   - `while (bytesRead != -1)` ループ内で、バッファから読み込んだバイトデータを処理し、ファイルの終わりに達するまで読み込みを繰り返します。

3. **例外処理**:
   - 読み込み操作中に `IOException` が発生した場合、`catch (IOException e)` ブロックで例外がキャッチされ、`e.printStackTrace()` によりスタックトレースが出力されます。

このように、`FileInputStream` クラスを使用することで、バイナリファイルから効率的にデータを読み込むことができます。

## まとめ

`FileInputStream` クラスは、Java でバイナリデータをファイルから読み込むためのシンプルで使いやすいクラス。ファイルからバイト単位でデータを効率的に読み込むための主要なメソッドを提供し、バイナリファイルの読み込みに適しています。
