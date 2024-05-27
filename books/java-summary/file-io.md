---
title: "ファイルI/O"
---

## 概要

- プログラムがファイルシステムとやり取りするための機能
- Java には、ファイルの読み書きを効率的に行うための豊富なライブラリが提供されている
- 主なクラスには、`File`、`FileReader`、`FileWriter`、`BufferedReader`、`BufferedWriter`、`Files`、`Paths`などがある

## 目的

- データの永続化や外部データの読み込み
- これにより、プログラムは実行中のデータを保存し、後で再利用したり、外部のデータソースから情報を取得したりすることができる

## 解決したい技術的課題

**問題点**:

- データの永続化が必要な場合、メモリ上のデータはプログラム終了時に失われる
- 大量のデータを一度に処理する必要がある場合、メモリの効率的な使用が求められる
- 外部データソースからのデータの読み込みや保存が必要

**解決策**:

- ファイル I/O を利用してデータをファイルに保存し、プログラムの再起動後もデータを保持できるようにする
- バッファリングを使用して大規模なデータを効率的に読み書きする
- 標準ライブラリを使用して簡潔かつ効率的にファイル操作を行う

## 主なクラスと使用例

1. **`File` クラス**

   - ファイルやディレクトリの抽象表現を提供する
   - ファイルの存在確認、作成、削除などの基本操作を行う

   ```java
   import java.io.File;

   public class FileExample {
       public static void main(String[] args) {
           File file = new File("example.txt");

           // ファイルの存在確認
           if (file.exists()) {
               System.out.println("File exists");
           } else {
               // ファイルの作成
               try {
                   if (file.createNewFile()) {
                       System.out.println("File created");
                   }
               } catch (IOException e) {
                   e.printStackTrace();
               }
           }
       }
   }
   ```

2. **`FileReader` と `FileWriter`**

   `FileReader` と `FileWriter` は、テキストファイルの読み書きを行うためのクラス。

   ```java
   import java.io.FileReader;
   import java.io.FileWriter;
   import java.io.IOException;

   public class FileReaderWriterExample {
       public static void main(String[] args) {
           // ファイルへの書き込み
           try (FileWriter writer = new FileWriter("example.txt")) {
               writer.write("Hello, world!");
           } catch (IOException e) {
               e.printStackTrace();
           }

           // ファイルの読み込み
           try (FileReader reader = new FileReader("example.txt")) {
               int ch;
               while ((ch = reader.read()) != -1) {
                   System.out.print((char) ch);
               }
           } catch (IOException e) {
               e.printStackTrace();
           }
       }
   }
   ```

3. **`BufferedReader` と `BufferedWriter`**

   バッファリングを通じて効率的にテキストファイルの読み書きを行う。

   ```java
   import java.io.BufferedReader;
   import java.io.BufferedWriter;
   import java.io.FileReader;
   import java.io.FileWriter;
   import java.io.IOException;

   public class BufferedReaderWriterExample {
       public static void main(String[] args) {
           // ファイルへの書き込み
           try (BufferedWriter writer = new BufferedWriter(new FileWriter("example.txt"))) {
               writer.write("Hello, world!");
               writer.newLine();
               writer.write("This is a BufferedWriter example.");
           } catch (IOException e) {
               e.printStackTrace();
           }

           // ファイルの読み込み
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

4. **`Files` と `Paths`**

   NIO（New I/O）API を使用して、ファイル操作を簡潔に行うためのユーティリティメソッドを提供する。

   ```java
   import java.io.IOException;
   import java.nio.file.Files;
   import java.nio.file.Path;
   import java.nio.file.Paths;

   public class FilesExample {
       public static void main(String[] args) {
           Path path = Paths.get("example.txt");

           // ファイルの書き込み
           try {
               Files.write(path, "Hello, world!\nThis is a NIO example.".getBytes());
           } catch (IOException e) {
               e.printStackTrace();
           }

           // ファイルの読み込み
           try {
               byte[] bytes = Files.readAllBytes(path);
               String content = new String(bytes);
               System.out.println(content);
           } catch (IOException e) {
               e.printStackTrace();
           }
       }
   }
   ```

### まとめ

- **目的**: データの永続化や外部データの読み込みを効率的に行う
- **使用方法**:
  - `File`クラス: 基本的なファイル操作（存在確認、作成、削除）
  - `FileReader`と`FileWriter`: テキストファイルの読み書き
  - `BufferedReader`と`BufferedWriter`: バッファリングを使用した効率的な読み書き
  - `Files`と`Paths`: NIO を使用した簡潔なファイル操作
- **利点**:
  - データを永続化することで、プログラムの再起動後もデータを保持
  - 大規模なデータを効率的に処理
  - 標準ライブラリを使用することで、コードが簡潔で保守しやすくなる

ファイル I/O を正しく利用することで、データ管理が容易になり、プログラムの信頼性と保守性が向上する。
