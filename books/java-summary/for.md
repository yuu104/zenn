---
title: "for"
---

### 1. 従来の`for`文

**構文**:

```java
for (初期化; 継続条件; 更新) {
    // 繰り返し実行されるコードブロック
}
```

**例**:

```java
for (int i = 0; i < 10; i++) {
    System.out.println("iの値: " + i);
}
```

### 2. 拡張`for`文（foreach 文）

- 拡張`for`文は、配列やコレクションを反復処理するために Java 5 で導入された
- この形式は、コレクション内の各要素に対して一連の操作を簡潔に実行するために使用される
- ただし、**要素のインデックスを扱うことはできない**

**構文**:

```java
for (宣言 : 式) {
    // 繰り返し実行されるコードブロック
}
```

**例**:

```java
int[] numbers = {1, 2, 3, 4, 5};
for (int number : numbers) {
    System.out.println("数値: " + number);
}
```

この例では、`numbers` 配列の各要素が順番に `number` に代入され、それぞれの数値が出力されます。

### 3. 無限ループ

`for`文は条件式を空にすることで無限ループを作成することが可能。

**構文**:

```java
for (;;) {
    // 繰り返し実行されるコードブロック
}
```

**例**:

```java
for (;;) {
    // 無限ループ内の処理
    if (終了条件) {
        break;  // ループを抜ける
    }
}
```

### 4. ループの制御文

- `for` 文内では、`break` 文や `continue` 文を使用してループの流れを制御することができる
- `break` 文はループから完全に抜け出す
- `continue` 文は次の反復にスキップする

**例**（`continue`と`break`を使用）:

```java
for (int i = 0; i < 10; i++) {
    if (i == 5) {
        continue;  // iが5の時、以下の処理をスキップする
    }
    if (i == 8) {
        break;  // iが8の時、ループを抜ける
    }
    System.out.println(i);
}
```

## ネストした for 文を抜ける

- ラベルを使用することで、任意スコープの `for` 文から抜けることができる
- ラベルはループの前に配置され、その後コロン（`:`）が続く
- ラベルを使用することで、`break` や `continue` をにより特定の外側ループへ直接ジャンプできる

```java
outer: // ラベル
for (int i = 0; i < 5; i++) {
  for (int j = 0; j < 5; j++) {
    if (i * j > 6) {
      System.out.println("Breaking at i=" + i + ", j=" + j);
      break outer; // ラベル付きbreak
    }
    System.out.println(i + ", " + j);
  }
}
System.out.println("Completed.");
```

```java
outer: // ラベル
for (int i = 0; i < 5; i++) {
  for (int j = 0; j < 5; j++) {
    if (j == 2) continue outer; // ラベル付きcontinue
    System.out.println("i=" + i + ", j=" + j);
  }
}

```
