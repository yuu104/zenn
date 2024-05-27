---
title: "BufferReader/BufferWriterクラス"
---

## 目的

- 文字ストリームにバッファリングを追加して効率的な読み書きを提供する
- ファイル、ネットワーク接続、他の文字ストリームからのテキストデータの読み取りおよび書き込みを高速化するために使用される

## 基礎概念

### バッファリング

- **バッファ**: データの一時的な保管場所。データをまとめて一度に読み込みまたは書き込み、I/O 操作の回数を減らす役割を果たす。
- **バッファリングのメリット**:
  - **読み取りの場合**: データを一度に大量に読み込み、内部メモリに保持することで、ディスクやネットワークからの読み取り回数を減らす。これにより、I/O 操作のオーバーヘッドを削減し、全体的なパフォーマンスを向上させる。
  - **書き込みの場合**: データを一度に大量に書き込み、内部メモリに保持することで、ディスクやネットワークへの書き込み回数を減らす。これにより、I/O 操作のオーバーヘッドを削減し、全体的なパフォーマンスを向上させる。
- **バッファサイズの調整**: デフォルトのバッファサイズは 8192 文字だが、必要に応じてコンストラクタでカスタムサイズを指定できる。適切なバッファサイズを設定することで、特定のアプリケーションのパフォーマンスを最適化できる。

### ストリーム

- **ストリーム**: データの連続した流れ。データの読み書きの抽象化を提供し、ファイルやネットワークからデータを効率的に処理する方法。
- **文字ストリーム**: 文字単位でデータを読み書きするストリーム。例として `FileReader` や `FileWriter` がある。

## `BufferedReader` の基本的な機能

1. **バッファリング**

   - 読み取り操作をバッファリングし、ディスクやネットワークからの読み取り回数を減少させ、パフォーマンスを向上させる。

2. **行単位での読み取り**

   - `readLine()`: ファイルから 1 行ずつ読み取るメソッド。行の終わりに達すると `null` を返す。

3. **その他の読み取りメソッド**

   - `int read()`: 1 文字を読み取る。
   - `int read(char[] cbuf, int offset, int length)`: 文字の配列にデータを読み込む。
   - `boolean ready()`: ストリームが読み取りの準備ができているかどうかを確認する。
   - `long skip(long n)`: n 文字をスキップする。

4. **リソースの解放**
   - `void close()`: ストリームを閉じ、リソースを解放する。

## `BufferedWriter` の基本的な機能

1. **バッファリング**

   - 書き込み操作をバッファリングし、ディスクやネットワークへの書き込み回数を減少させ、パフォーマンスを向上させる。

2. **文字列や文字配列の書き込み**

   - `void write(String str)`: 文字列全体を書き込む。
   - `void write(char[] cbuf, int offset, int length)`: 文字の配列からデータを書き込む。
   - `void write(int c)`: 1 文字を書き込む。

3. **新しい行の書き込み**

   - `void newLine()`: システム依存の新しい行の区切り文字を書き込む。

4. **バッファのフラッシュとクローズ**
   - `void flush()`: バッファに蓄えられたデータを強制的に書き出す。
   - `void close()`: ストリームを閉じ、リソースを解放する。

## 使用例

### `BufferedReader` を使用したファイルから行単位での読み取り

1. **ファイルリーダーの作成**:

   - まず、読み取り対象のファイルを指定して `FileReader` オブジェクトを作成する。
   - この `FileReader` を `BufferedReader` に渡すことで、バッファリングが追加される。

2. **行単位の読み取り**:

   - `readLine()` メソッドを使って、ファイルから 1 行ずつ読み取る。
   - ファイルの終わりに達すると `readLine()` は `null` を返すので、ループを終了する。

3. **リソースのクリーンアップ**:

   - `try-with-resources` 構文を使用して、`BufferedReader` を閉じる。これにより、リソースリークを防ぐ。

   ```java
   try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"))) {
       String line;
       while ((line = reader.readLine()) != null) {
           System.out.println(line); // 1行ずつ読み取って出力
       }
   } catch (IOException e) {
       e.printStackTrace(); // エラーハンドリング
   }
   ```

### `BufferedWriter` を使用したファイルへの文字列書き込み

1. **ファイルライターの作成**:

   - まず、書き込み対象のファイルを指定して `FileWriter` オブジェクトを作成する。
   - この `FileWriter` を `BufferedWriter` に渡すことで、バッファリングが追加される。

2. **文字列の書き込み**:

   - `write()` メソッドを使って、文字列をバッファに書き込む。
   - `newLine()` メソッドを使って、新しい行を追加する。

3. **バッファのフラッシュとリソースのクリーンアップ**:
   - `flush()` メソッドでバッファに蓄えられたデータをディスクに書き出す。
   - `try-with-resources` 構文を使用して、`BufferedWriter` を閉じる。これにより、リソースリークを防ぐ。

```java
try (BufferedWriter writer = new BufferedWriter(new FileWriter("example.txt"))) {
    writer.write("Hello, World!");
    writer.newLine();
    writer.write("This is a new line.");
    writer.flush(); // バッファをフラッシュ
} catch (IOException e) {
    e.printStackTrace(); // エラーハンドリング
}
```

### バッファサイズを指定する例

1. **カスタムバッファサイズの指定**:

   - `BufferedReader` および `BufferedWriter` のコンストラクタにバッファサイズを指定することで、デフォルトの 8192 文字よりも大きな（または小さな）バッファサイズを使用できる。

2. **ファイルの効率的な読み書き**:
   - 大きなデータを一度に読み書きする場合や、特定のパフォーマンス要件がある場合に、バッファサイズを調整することで効率を最適化する。

```java
// BufferedReader with custom buffer size
try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"), 16384)) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(line); // 1行ずつ読み取って出力
    }
} catch (IOException e) {
    e.printStackTrace(); // エラーハンドリング
}

// BufferedWriter with custom buffer size
try (BufferedWriter writer = new BufferedWriter(new FileWriter("example.txt"), 16384)) {
    writer.write("Hello, World!");
    writer.newLine();
    writer.write("This is a new line.");
    writer.flush(); // バッファをフラッシュ
} catch (IOException e) {
    e.printStackTrace(); // エラーハンドリング
}
```

## 解決したい技術的課題

1. **I/O 操作の効率化**
   `FileReader` や `FileWriter` は 1 文字ずつ読み書きするため、ディスクやネットワークからの I/O 操作が頻繁に発生し、パフォーマンスが低下することがある。`BufferedReader` および `BufferedWriter` はバッファリングを利用することで、一度に大きなデータをまとめて読み書きし、I/O 操作の回数を減らすことで効率化を図る。

2. **ディスクやネットワークの負荷軽減**
   直接ディスクやネットワークからデータを読み書きする回数を減らすことで、これらのリソースにかかる負荷を軽減し、全体的なシステムのパフォーマンスを向上させる。

3. **大規模データの処理**
   大量のデータを扱う場合、バッファリングによって読み書きが効率化されるため、大規模データの処理がスムーズに行える。

## 詳細な説明

1. **バッファリングの重要性**:
   直接ファイルやネットワークから読み書きする場合、各操作は高コストな I/O 操作を伴う。`BufferedReader` および `BufferedWriter` は、内部バッファを使用してこれらの操作を最小限に抑える。バッファサイズを適切に設定することで、パフォーマンスを最適化できる。

2. **文字列や行単位の読み書きの利便性**:
   `BufferedReader` の `readLine()` メソッドを使用して行単位でデータを読み取ることができ、`BufferedWriter` の `write()` や `newLine()` メソッドを使用して文字列や行を簡単に書き込める。

   :::details FileReader の場合

   - **逐次読み取り**: FileReader を使用して行単位で読み取ることは可能だが、各読み取り操作はディスクやネットワークから直接行われる。
   - **効率の問題**: 各文字を 1 つずつ読み取るため、I/O 操作の回数が増え、パフォーマンスが低下する可能性がある。

   ```java

   FileReader fileReader = new FileReader("example.txt");
   StringBuilder line = new StringBuilder();
   int character;
   while ((character = fileReader.read()) != -1) {
       if ((char) character == '\n') {
           System.out.println(line.toString());
           line.setLength(0); // StringBuilder をリセット
       } else {
           line.append((char) character);
       }
   }
   if (line.length() > 0) {
       System.out.println(line.toString()); // 最後の行を出力
   }
   fileReader.close();


   ```

   上記のコードは各 `read()` 呼び出しごとに 1 文字ずつ読み取るため、効率が悪い。

   :::

   :::details BufferedReader の場合

   - **バッファリングによる効率化**: `BufferedReader` は内部バッファを使用して、一度に大きなデータ塊を読み込み、メモリに保持することで、後続の読み取り操作を効率化する
   - **行単位の読み取り**: `readLine()` メソッドを使用することで、行単位の読み取りが簡単かつ効率的に行える

   ```java

   try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"))) {
      String line;
      while ((line = reader.readLine()) != null) {
          System.out.println(line);
      }
   } catch (IOException e) {
      e.printStackTrace();
   }


   ```

   :::

3. **エラー処理と例外管理**:
   I/O 操作中に発生する例外（`IOException`）に対して適切なエラーハンドリングを行うことが重要。例外処理を行うことで、プログラムの安定性と信頼性を向上させる。

## まとめ

- **`BufferedReader` と `BufferedWriter` の主な目的**:
  - 文字ストリームの効率的な読み書き
- **基本的な機能**:
  - バッファリング
  - 文字列や行単位の読み書き
  - バッファのフラッシュとクローズ
- **技術的課題の解決**:
  - I/O 操作の効率化
  - ディスクやネットワークの負荷軽減
  - 大規模データの処理
- **使用例とベストプラクティス**:
  - `try-with-resources` 構文を使用し、リソース管理を自動化
  - 適切なバッファサイズの設定でパフォーマンスを最適化
