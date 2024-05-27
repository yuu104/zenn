---
title: "FileReader クラス"
---

## 目的

`FileReader` クラスは、テキストファイルから文字単位でデータを読み取るためのクラス。`Reader` クラスを拡張し、文字ストリームを扱う。

## 基本的な機能

1. **ファイルからの文字読み取り**

   - `read()`: ファイルから単一の文字を読み取る
   - `read(char[] cbuf)`: ファイルから文字の配列にデータを読み取る
   - `read(char[] cbuf, int offset, int length)`: 指定された範囲内で文字の配列にデータを読み取る

2. **ファイルの終端確認**

   - `ready()`: ストリームが読み取りの準備ができているかどうかを確認する
   - `skip(long n)`: 指定された数の文字をスキップする
   - `mark(int readAheadLimit)`: ストリームの現在位置をマークし、後でリセット可能にする
   - `reset()`: ストリームのマークされた位置にリセットする

3. **リソース管理**
   - `close()`: ファイルリーダーを閉じ、リソースを解放する

## 使用例

### ファイルから単一文字の読み取り

```java
FileReader reader = null;
try {
    reader = new FileReader("example.txt");
    int character;
    while ((character = reader.read()) != -1) {
        System.out.print((char) character);
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (reader != null) {
        try {
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### ファイルから文字配列への読み取り

```java
FileReader reader = null;
try {
    reader = new FileReader("example.txt");
    char[] buffer = new char[100];
    int numCharsRead;
    while ((numCharsRead = reader.read(buffer)) != -1) {
        System.out.print(new String(buffer, 0, numCharsRead));
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (reader != null) {
        try {
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## 解決したい技術的課題

1. **効率的なテキスト読み取り**:

   - `FileReader` を使用することで、テキストファイルからの文字単位の効率的な読み取りが可能になる。例えば、設定ファイルやログファイルの読み込み。

2. **リソース管理**:

   - `close()` メソッドを使用して、ファイルリーダーを適切に閉じることで、リソースリークを防止する。ファイル操作の後処理が容易になる。

3. **エラーハンドリング**:
   - `IOException` を適切に処理することで、ファイルの読み取り時に発生する可能性のあるエラーに対処する。

## 比較と理由

- **`BufferedReader` と比較**:
  - `FileReader` は基本的な文字読み取りを提供するが、効率が重要な場合は `BufferedReader` と組み合わせて使用するのが一般的。`BufferedReader` はバッファリングを行い、大量のデータを効率的に読み取る。
- **`InputStreamReader` と比較**:
  - `InputStreamReader` はバイトストリームから文字ストリームへの変換を行うが、`FileReader` は直接ファイルから文字を読み取る。バイナリファイルを扱う場合は `InputStreamReader` を使用。

## まとめ

`FileReader` クラスは、テキストファイルから文字単位でデータを読み取るための基本的なツール。小規模なテキストファイルの読み取りや簡単なファイル操作には適しているが、大量のデータを扱う場合や効率を重視する場合は、`BufferedReader` との併用が推奨される。リソース管理とエラーハンドリングを適切に行うことで、ファイル操作の信頼性と効率性を向上させる。
