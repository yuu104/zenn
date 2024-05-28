---
title: "I/O処理の全体像"
---

## I/O の対象

- テキストデータ
- バイナリデータ

コンピュータの目線から見ると、どちらも何らかのバイト表現（複数個のバイトからなる列）であることに変わりない。

### テキストデータとは？

「あいう」といった文字が、**特定の文字コードによってバイト変換されたデータ**。

### バイナリデータとは？

テキストデータ以外のデータ。

## I/O 処理のクラス分け

### テキストデータの I/O

- **`Reader`** と **`Writer`** 抽象クラスが責務を持つ
  - **`Reader`**: テキストデータの読み込みを行う抽象クラス
  - **`Writer`**: テキストデータの書き込みを行う抽象クラス
    **具体的なクラス**:
    - `FileReader`
    - `BufferedReader`
    - `InputStreamReader`
    - `FileWriter`
    - `BufferedWriter`
    - `OutputStreamWriter`

### バイナリデータの I/O

- **`InputStream`** と **`OutputStream`** 抽象クラスが責務を持つ
  - **`InputStream`**: バイナリデータの読み込みを行う抽象クラス
  - **`OutputStream`**: バイナリデータの書き込みを行う抽象クラス
  - **具体的なクラス**:
    - `FileInputStream`
    - `BufferedInputStream`
    - `ByteArrayInputStream`
    - `FileOutputStream`
    - `BufferedOutputStream`
    - `ByteArrayOutputStream`

## ファイル I/O について

- **従来の方法 (`java.io.File`)**

  - `java.io.File` でファイルオブジェクトを生成し、`Reader` や `Writer` で I/O 処理を行う

  ```java
  File file = new File("example.txt");
  Reader reader = new FileReader(file);
  Writer writer = new FileWriter(file);

  ```

- **現在の方法 (`java.nio.*`)**

  - `java.nio.file.Path`、`java.nio.file.Paths`、`java.nio.file.Files` を使用し、ファイルオブジェクトを生成し、`Reader` や `Writer` で I/O 処理を行う
  - これらのクラスは、より豊富な機能と利便性を提供

  ```java
  Path path = Paths.get("example.txt");
  Reader reader = Files.newBufferedReader(path);
  Writer writer = Files.newBufferedWriter(path);

  ```

## テキストファイルとは？

**テキストデータが特定の文字コードによってバイト変換され、それがファイルシステム上に保存されたもの。**

- テキストファイルを読み込むためには、対象のテキストファイルがどのような文字コードでバイト変換されているのかを、指定する必要がある
- テキストファイルを書き込むためには、どのような文字コードでテキストをバイト表現に変換するのか、指定しなければならない

## 文字コードを表すクラス

- `java.nio.charset.Charset` は文字コードを抽象化したクラス
  - テキストファイルの読み込みや書き込みにおいて、文字コードを指定するために使用する
- `java.nio.charset.StandardCharsets` は様々な `Charset` オブジェクトを定数として保持するクラス
