---
title: "FileWriter クラス"
---

## 目的

- テキストファイルに文字データを書き込む
- `Writer` クラスを拡張し、文字ストリームを扱う

## 基本的な機能

1. **ファイルへの文字書き込み**

   - `write(int c)`: 単一の文字を書き込む
   - `write(char[] cbuf)`: 文字の配列を書き込む
   - `write(char[] cbuf, int off, int len)`: 指定された範囲内で文字の配列を書き込む
   - `write(String str)`: 文字列を書き込む
   - `write(String str, int off, int len)`: 文字列の一部を書き込む

2. **ファイルの追記と上書き**

   - `FileWriter(String fileName, boolean append)`: 第二引数に `true` を指定することで追記モードでファイルを開く。デフォルトは上書きモード。

3. **リソース管理**
   - `flush()`: バッファ内のデータを強制的に書き込む
   - `close()`: ファイルライターを閉じ、リソースを解放する

## 使用例

### ファイルへの文字書き込み

```java
FileWriter writer = null;
try {
    writer = new FileWriter("example.txt");
    writer.write("Hello, World!"); // 文字列を書き込む
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (writer != null) {
        try {
            writer.close(); // ファイルライターを閉じる
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### ファイルへの追記

```java
FileWriter writer = null;
try {
    writer = new FileWriter("example.txt", true); // 追記モードで開く
    writer.write("This is an appended line.\n"); // 文字列を書き込む
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (writer != null) {
        try {
            writer.close(); // ファイルライターを閉じる
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## 解決したい技術的課題

1. **効率的なテキスト書き込み**:

   - `FileWriter` を使用することで、テキストデータを効率的にファイルに書き込むことができる。例えば、ログファイルや設定ファイルの書き込み。

2. **追記と上書きの制御**:

   - ファイルにデータを追記したい場合と上書きしたい場合を簡単に制御できる。デフォルトでは上書き、第二引数に `true` を指定すると追記モードになる。

3. **リソース管理**:
   - `close()` メソッドを使用して、ファイルライターを適切に閉じることで、リソースリークを防止する。ファイル操作の後処理が容易になる。

## 比較と理由

- **`BufferedWriter` と比較**:

  - `FileWriter` は基本的な文字書き込みを提供するが、大量のデータを効率的に書き込む場合は `BufferedWriter` と組み合わせて使用するのが一般的。`BufferedWriter` はバッファリングを行い、大量のデータを効率的に書き込む。

- **`PrintWriter` と比較**:
  - `PrintWriter` はフォーマットされた出力を提供し、`print` や `println` メソッドを使用して簡単にデータを書き込むことができる。`FileWriter` は低レベルな文字書き込みを提供。

## まとめ

`FileWriter` クラスは、テキストファイルに文字データを書き込むための基本的なツール。小規模なテキストファイルの書き込みや簡単なファイル操作には適しているが、大量のデータを扱う場合や効率を重視する場合は、`BufferedWriter` との併用が推奨される。リソース管理とエラーハンドリングを適切に行うことで、ファイル操作の信頼性と効率性を向上させる。
