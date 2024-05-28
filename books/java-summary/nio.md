---
title: "java.nio ~ モダンJavaのファイルI/O"
---

## 概要

- Java7 で Java NIO.2 と呼ばれる API が導入された
- これにより、ファイル操作で使用するクラス群が刷新された
- これらは `java.nio.file` パッケージに属する

## 主要なクラス・インターフェース

1. **`java.nio.file.Path`**
   - インターフェース
   - ファイルシステム内のファイル・ディレクトリを表す
2. **`java.nio.file.Paths`**
   - クラス
   - `Path` を実装したオプジェクトを生成するためのファクトリークラス
3. **`java.nio.file.Files`**
   - クラス
   - ファイルを操作するためのクラス

## `Path` インターフェース

`Path` は「インターフェース」であり、直接 `new` でオブジェクトを生成できない。
そのため、ファクトリークラスである `Paths` を使用して、`Path` オブジェクトを生成する。

### 目的

- ファイルシステム内のファイルやディレクトリのパスを表現すること
- パスに対する以下の操作などを提供する
  - パスの結合
  - 相対パスの計算
  - 正規化

### 主要メソッド

:::details getFileName() ~ パスのファイル名取得

- **説明**:
  `getFileName()` メソッドは、パスの最後の要素（ファイル名またはディレクトリ名）を取得します。

- **例**:
  ```java
  Path path = Paths.get("example", "file.txt");
  System.out.println(path.getFileName()); // file.txt
  ```

:::

:::details getParent() ~ 親ディレクトリのパスを取得

- **説明**:
  `getParent()` メソッドは、親ディレクトリのパスを取得します。親ディレクトリが存在しない場合（ルートディレクトリなど）は `null` を返します。

- **例**:
  ```java
  Path path = Paths.get("example", "file.txt");
  System.out.println(path.getParent()); // example
  ```

:::

:::details toAbsolutePath() ~ 絶対パスの取得

- **説明**:
  `toAbsolutePath()` メソッドは、相対パスを絶対パスに変換します。相対パスが渡された場合、このメソッドは現在の作業ディレクトリを基に絶対パスを生成します。

- **例**:
  ```java
  Path path = Paths.get("example/file.txt");
  System.out.println(path.toAbsolutePath());
  ```

:::

:::details resolve() ~ パスの結合

- **説明**:
  `resolve(Path other)` メソッドは、現在のパスに指定されたパスを結合します。`other` が絶対パスの場合は、そのまま `other` を返します。

- **例**:
  ```java
  Path path1 = Paths.get("example");
  Path path2 = path1.resolve("file.txt");
  System.out.println(path2); // example/file.txt
  ```

:::

## `Paths` クラス

### 目的

- `Path` オブジェクトを簡単に作成するためのファクトリメソッドを提供すること
- 文字列や URI から `Path` オブジェクトを生成しやすくする

### 主要メソッド

:::details get(String first, String... more) ~ パスの作成

- **説明**:
  `Paths.get(String first, String... more)` メソッドは、指定されたパス文字列から `Path` オブジェクトを作成します。複数のパスセグメントを結合するための可変長引数 `more` を持ちます。

- **シグネチャ**:

  ```java
  static Path get(String first, String... more)
  ```

- **例**:

  ```java
  // 単一のパスセグメントを使用
  Path path1 = Paths.get("example/file.txt");
  System.out.println(path1); // example/file.txt

  // 複数のパスセグメントを結合
  Path path2 = Paths.get("example", "subdir", "file.txt");
  System.out.println(path2); // example/subdir/file.txt
  ```

:::

:::details get(URI uri) ~ URI からパスの作成

- **説明**:
  `Paths.get(URI uri)` メソッドは、指定された `URI` から `Path` オブジェクトを作成します。

- **シグネチャ**:

  ```java
  static Path get(URI uri)
  ```

- **例**:
  ```java
  URI uri = new URI("file:///example/file.txt");
  Path path = Paths.get(uri);
  System.out.println(path); // /example/file.txt
  ```

:::

## `Files` クラス

### 目的

- ファイル・ディレクトリに対する高レベルの操作を提供すること
  - ファイルのコピー
  - 移動
  - 削除
  - 読み書き
  - 属性操作 etc...

### 主要メソッド

:::message
すべてスタティックメソッド
:::

大きく、以下の 3 つに分類される。

1. 指定されたパスの属性を取得するユーティリティ
2. 指定されたパスに対する何らかの操作を行うユーティリティ
3. 指定されたファイルへの読み込みや書き込みを行うためのオブジェクトを生成するファクトリメソッド

それぞれの詳細は以下の通り。

1. **指定されたパスの属性を取得するユーティリティ**

   :::details isDirectory() ~ ディレクトリかどうかの確認

   - **説明**:

     - 指定されたパスがディレクトリであるかどうかを確認する
     - ディレクトリである場合は `true` を返し、そうでない場合は `false` を返す
     - シンボリックリンクをフォローするかどうかは `LinkOption` で指定できる

   - **シグネチャ**:

     ```java
     static boolean isDirectory(Path path, LinkOption... options)
     ```

   - **例**:
     ```java
     Path path = Paths.get("exampleDir");
     if (Files.isDirectory(path)) {
         System.out.println(path + " is a directory.");
     } else {
         System.out.println(path + " is not a directory.");
     }
     ```

   :::

   :::details isReadable() ~ 読み取り可能かどうかの確認

   - **説明**:

     - 指定されたパスが読み取り可能であるかどうかを確認する
     - 読み取り可能である場合は `true` を返し、そうでない場合は `false` を返す
     - ファイルやディレクトリの読み取り権限があるかどうかを確認するために使用する

   - **シグネチャ**:

     ```java
     static boolean isReadable(Path path)
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     if (Files.isReadable(path)) {
         System.out.println(path + " is readable.");
     } else {
         System.out.println(path + " is not readable.");
     }
     ```

   :::

   :::details isWritable() ~ 書き込み可能かどうかの確認

   - **説明**:

     - 指定されたパスが書き込み可能であるかどうかを確認する
     - 書き込み可能である場合は `true` を返し、そうでない場合は `false` を返す
     - このメソッドは、ファイルやディレクトリに書き込み権限があるかどうかを確認するために使用する

   - **シグネチャ**:

     ```java
     static boolean isWritable(Path path)
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     if (Files.isWritable(path)) {
         System.out.println(path + " is writable.");
     } else {
         System.out.println(path + " is not writable.");
     }
     ```

   :::

   :::details isExecutable() ~ 実行可能かどうかの確認

   - **説明**:

     - 指定されたパスが実行可能であるかどうかを確認する
     - 実行可能である場合は `true` を返し、そうでない場合は `false` を返す
     - ファイルが実行可能かどうかを確認するために使用する

   - **シグネチャ**:

     ```java
     static boolean isExecutable(Path path)
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.sh");
     if (Files.isExecutable(path)) {
         System.out.println(path + " is executable.");
     } else {
         System.out.println(path + " is not executable.");
     }
     ```

   :::

2. **指定されたパスに対する何らかの操作を行うユーティリティ**
   どのメソッドも `java.io.IOException`（チェック例外）が発生するため、例外処理が必要。

   :::details size() ~ ファイルサイズの取得

   - **説明**:

     - 指定されたファイルのサイズをバイト単位で取得する
     - ファイルのサイズを `long` で返す

   - **シグネチャ**:

     ```java
     static long size(Path path) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try {
         long size = Files.size(path);
         System.out.println("File size: " + size + " bytes");
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details getLastModifiedTime() ~ 最終変更日時の取得

   - **説明**:

     - 指定されたファイルまたはディレクトリの最終変更日時を取得する
     - 返されるのは `FileTime` オブジェクト
     - シンボリックリンクのフォローを制御するオプションも提供されている

   - **シグネチャ**:

     ```java
     static FileTime getLastModifiedTime(Path path, LinkOption... options) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try {
         FileTime lastModifiedTime = Files.getLastModifiedTime(path);
         System.out.println("Last modified time: " + lastModifiedTime);
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details getOwner() ~ ファイル所有者の取得

   - **説明**:

     - 指定されたファイルまたはディレクトリの所有者を取得する
     - 返されるのは `UserPrincipal` オブジェクトで
     - シンボリックリンクのフォローを制御するオプションも提供されている

   - **シグネチャ**:

     ```java
     static UserPrincipal getOwner(Path path, LinkOption... options) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try {
         UserPrincipal owner = Files.getOwner(path);
         System.out.println("Owner: " + owner.getName());
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details copy() ~ ファイルのコピー

   - **説明**:

     - 指定されたソースファイルをターゲットファイルにコピーする
     - オプションを指定することで、コピーの挙動を制御できる（例: 上書き、コピー属性の維持など）。

   - **シグネチャ**:

     ```java
     static Path copy(Path source, Path target, CopyOption... options) throws IOException
     ```

   - **例**:
     ```java
     Path source = Paths.get("source.txt");
     Path target = Paths.get("target.txt");
     try {
         Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
         System.out.println("File copied from " + source + " to " + target);
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details move() ~ ファイルの移動

   - **説明**:

     - 指定されたソースファイルをターゲットファイルに移動する
     - オプションを指定することで、移動の挙動を制御できる（例: 上書き、移動属性の維持など）。

   - **シグネチャ**:

     ```java
     static Path move(Path source, Path target, CopyOption... options) throws IOException
     ```

   - **例**:
     ```java
     Path source = Paths.get("source.txt");
     Path target = Paths.get("target.txt");
     try {
         Files.move(source, target, StandardCopyOption.REPLACE_EXISTING);
         System.out.println("File moved from " + source + " to " + target);
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details delete() ~ ファイルやディレクトリの削除

   - **説明**:

     - 指定されたファイルまたはディレクトリを削除する
     - ファイルまたはディレクトリが存在しない場合は `NoSuchFileException` をスローする

   - **シグネチャ**:

     ```java
     static void delete(Path path) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try {
         Files.delete(path);
         System.out.println("File deleted: " + path);
     } catch (IOException e) {
         e.printStackTrace();
     } catch (NoSuchFileException e) {
         System.out.println("ファイルが存在しません");
     }
     ```

   :::

   :::details deleteIfExists() ~ ファイルやディレクトリが存在する場合に削除

   - **説明**:

     - 指定されたファイルまたはディレクトリが存在する場合に削除する
     - 存在しない場合でも例外はスローされない

   - **シグネチャ**:

     ```java
     static boolean deleteIfExists(Path path) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try {
         boolean deleted = Files.deleteIfExists(path);
         if (deleted) {
             System.out.println("File deleted: " + path);
         } else {
             System.out.println("File did not exist: " + path);
         }
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details list() ~ 指定したディレクトリ内のファイルとディレクトリの一覧を取得する

   - **説明**:

     - 指定されたディレクトリ内のファイルとディレクトリの一覧を取得する

   - **シグネチャ**:

     ```java
     public static Stream<Path> list(Path dir) throws IOException
     ```

   - **例**:

     ```java
     import java.nio.file.*;
     import java.io.IOException;
     import java.util.stream.Stream;

     public class ListFilesExample {
         public static void main(String[] args) {
             try {
                 Path dir = Paths.get("path/to/directory");

                 try (Stream<Path> files = Files.list(dir)) {
                     files.forEach(System.out::println);
                 }
             } catch (IOException e) {
                 e.printStackTrace();
             }
         }
     }
     ```

   :::

3. **指定されたファイルへの読み込みや書き込みを行うためのオブジェクトを生成するファクトリメソッド**
   どのメソッドも `java.io.IOException`（チェック例外）が発生するため、例外処理が必要。

   :::details newBufferedReader() ~ バッファ付きリーダーの作成

   - **説明**:

     - 指定されたパスから `BufferedReader` を作成する
     - 指定された文字セット（`Charset`）を使用してファイルを読み取る

   - **シグネチャ**:

     ```java
     static BufferedReader newBufferedReader(Path path, Charset cs) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
         String line;
         while ((line = reader.readLine()) != null) {
             System.out.println(line);
         }
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details newBufferedWriter() ~ バッファ付きライターの作成

   - **説明**:

     - 指定されたパスに `BufferedWriter` を作成する
     - 指定された文字セット（`Charset`）を使用してファイルに書き込む
     - オプションを指定することで、書き込みの挙動を制御できる（例: 上書き、追加書き込みなど）

   - **シグネチャ**:

     ```java
     static BufferedWriter newBufferedWriter(Path path, Charset cs, OpenOption... options) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try (BufferedWriter writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8, StandardOpenOption.CREATE, StandardOpenOption.APPEND)) {
         writer.write("Hello, World!");
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details newInputStream() ~ 入力ストリームの作成

   - **説明**:

     - 指定されたパスから `InputStream` を作成する
     - オプションを指定することで、入力ストリームの挙動を制御できる（例: 読み込みモード、シンボリックリンクのフォローなど）

   - **シグネチャ**:

     ```java
     static InputStream newInputStream(Path path, OpenOption... options) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try (InputStream inputStream = Files.newInputStream(path)) {
         byte[] buffer = new byte[1024];
         int bytesRead;
         while ((bytesRead = inputStream.read(buffer)) != -1) {
             System.out.write(buffer, 0, bytesRead);
         }
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

   :::details newOutputStream() ~ 出力ストリームの作成

   - **説明**:

     - 指定されたパスに `OutputStream` を作成する
     - オプションを指定することで、出力ストリームの挙動を制御できる（例: 上書き、追加書き込みなど）

   - **シグネチャ**:

     ```java
     static OutputStream newOutputStream(Path path, OpenOption... options) throws IOException
     ```

   - **例**:
     ```java
     Path path = Paths.get("example.txt");
     try (OutputStream outputStream = Files.newOutputStream(path, StandardOpenOption.CREATE, StandardOpenOption.APPEND)) {
         byte[] data = "Hello, World!".getBytes();
         outputStream.write(data);
     } catch (IOException e) {
         e.printStackTrace();
     }
     ```

   :::

## テキストファイルの書き込みと読み込み

### 読み込み処理

- ファイルの読み込みではほとんどの場合、具象クラスの `java.io.BufferedReader` クラスが使われる
- `BufferedReader` は、文字を一文字ずつ読み込むのではなく一行単位にバッファリングして読み込むため効率的に処理することができる

```java
Path path = Paths.get("hoge/fuga/foo.txt"); //【1】
try (BufferedReader br = Files.newBufferedReader(path,
        StandardCharsets.UTF_8)) { //【2】
    String line;
    while ((line = br.readLine()) != null) { //【3】
        System.out.println(line);
    }
} catch (IOException ioe) {
    throw new RuntimeException(ioe);
}
```

1. 読み込み対象ファイルの `Path` オブジェクトを生成
   - `Paths` クラスの `get()` により生成している
2. `BufferedReader` オブジェクトを生成
   - `Files` クラスの `newBufferedReader()` により生成している
   - 第一引数に対象のパスを指定
   - 第二引数に文字コードを指定
   - 第二引数は省略可能で、その場合は OS デフォルトの文字コードが自動的に選択される
   - `BufferedReader` による読み込みでは、入出力がエラーがあると `IOException`（チェック例外）が発生するため、例外処理が必要
3. ファイルから一行毎にテキストを読み込む
   - `readLine()` を使用する
   - `readLine()` で読み込んだデータは、指定された文字コードに従って文字列に変換され、`String` 型として取り出される
   - このメソッドは、ファイルの最終行にたどり着くと `null` を返す

![](https://storage.googleapis.com/zenn-user-upload/8df1ca3a9318-20240528.png)

:::details Files クラスによる読み込み

```java
Path path = Paths.get("hoge/fuga/foo.txt");
try {
    List<String> fileContents = Files.readAllLines(path, StandardCharsets.UTF_8);
    for (String line : fileContents) {
        System.out.println(line);
    }
} catch (IOException ioe) {
    throw new RuntimeException(ioe);
}
```

- `Files.readAllLines()` による読み込みは `BufferedReader` と比べて簡易的に実装できる
- `BufferedReader` では「一行ごと」に読み込まれる
- `Files.readAllLines()` では「一度にすべての行」が読み込まれる
- 従って、**メモリリソースを大きく消費することになるため、控えた方が良い**

:::

### 書き込み処理

- テキストデータを書き込むための汎用的なインタフェースを持つクラスが、`java.io.Writer`
- `Writer` は抽象クラス
- ファイルの書き込みではほとんどの場合、具象クラスの `BufferWriter` クラスが使われる
- `BufferWriter` は、文字を一文字ずつ書き込むのではなく一行単位にバッファリングして書き込むため、効率的に処理できる

```java
Path src = Paths.get("hoge/fuga/foo.txt"); //【1】
Path dest = Paths.get("hoge/fuga/foo2.txt"); //【2】
try (BufferedReader br = Files.newBufferedReader(src);
        BufferedWriter bw = Files.newBufferedWriter(dest)) { //【3】
    String line;
    while ((line = br.readLine()) != null) {
        bw.write(line + System.lineSeparator()); //【4】
    }
} catch (IOException ioe) {
    throw new RuntimeException(ioe);
}
```

1. 書き込み対象ファイルの `Path` オブジェクトを生成
   - `Paths` クラスの `get()` により生成している
2. `BufferedWriter` オブジェクトを生成
   - `Files` クラスの `newBufferedWriter()` により生成している
   - 第一引数に対象のパスを指定
   - 第二引数に文字コードを指定
   - 第二引数は省略可能で、その場合は OS デフォルトの文字コードが自動的に選択される
   - `BufferedWriter` による読み込みでは、入出力がエラーがあると `IOException`（チェック例外）が発生するため、例外処理が必要
3. 一行ずつ書き込む
   - `write()` を使用する

## バイナリファイルからの読み込み

- `BufferedInputStream` を使用する
- データを一バイトずつ読み込むのではなく、一定サイズ分をバッファリングして読み込むため、効率的に処理することができる

```java
Path path = Paths.get("java_logo1.jpg"); //【1】
try (InputStream is = Files.newInputStream(path)) { //【2】
    BufferedInputStream bis = new BufferedInputStream(is); //【3】
    byte[] buf = new byte[10]; //【4】
    while (bis.read(buf) != -1) { //【5】
        for (byte b : buf) {
            System.out.println("読み込んだバイトデータ => " + b);
        }
    }
} catch (IOException ioe) {
    throw new RuntimeException(ioe);
}
```

上記は `java_logo1.jpg` を読み込み、そのバイトデータをコンソールに表示している。

1. 読み込み対象ファイルの `Path` オブジェクトを生成
2.
