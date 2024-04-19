---
title: "while"
---

## while

**構文:**

```java
while (条件) {
  // 繰り返し実行されるコードブロック
}
```

**例:**

```java
int i = 0;
while (i < 5) {
  System.out.println("iの値: " + i);
  i++;
}
```

## do-while

- `while` とほぼ同じ
- しかし、最低一回はコードブロックを実行する
- ループの条件はコードブロックの実行後に評価される

**構文:**

```java
do {
  // 繰り返し実行されるコードブロック
} while (条件);
```

**例:**

```java
int i = 0;
do {
  System.out.println("iの値: " + i);
  i++;
} while (i < 5);

// 1
// 2
// 3
// 4
// 5
```
