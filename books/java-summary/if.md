---
title: "if"
---

### 基本的な`if`文

**構文**:

```java
if (条件) {
    // 条件が真の場合に実行されるコードブロック
}
```

**例**:

```java
int x = 10;
if (x > 5) {
    System.out.println("xは5より大きいです");
}
```

### `if-else`文

**構文**:

```java
if (条件) {
    // 条件が真の場合に実行されるコードブロック
} else {
    // 条件が偽の場合に実行されるコードブロック
}
```

**例**:

```java
int x = 10;
if (x > 15) {
    System.out.println("xは15より大きいです");
} else {
    System.out.println("xは15以下です");
}
```

### `if-else if-else`文

**構文**:

```java
if (条件1) {
    // 条件1が真の場合に実行されるコードブロック
} else if (条件2) {
    // 条件2が真の場合に実行されるコードブロック
} else {
    // いずれの条件も真でない場合に実行されるコードブロック
}
```

**例**:

```java
int x = 10;
if (x > 15) {
    System.out.println("xは15より大きいです");
} else if (x < 5) {
    System.out.println("xは5より小さいです");
} else {
    System.out.println("xは5以上かつ15以下です");
}
```
