---
title: "コメント文"
---

## 単一行コメント

```java
// これは単一行コメントです
int number = 10; // この行の末尾にコメントを追加
```

## 複数行コメント

```java
/* このコメントは
複数行にわたります */
int x = 5;
int y = 10;
/* int z = 15; コメントアウトされたコード */
```

## JavaDoc

```java
/**
 * クラスの説明: このクラスは数学的操作を行うメソッドを含む。
 */
public class MathOperations {

    /**
     * 二つの整数の和を計算する。
     *
     * @param a 最初の整数
     * @param b 二番目の整数
     * @return 二つの整数の和
     */
    public int add(int a, int b) {
        return a + b;
    }
}
```
