---
title: "switch文"
---

## 基本構文

```java
switch (式) {
  case 値1:
    // 値1が式の結果と一致した場合の処理
    break;
  case 値2:
    // 値2が式の結果と一致した場合の処理
    break;
  default:
    // どのcaseにも一致しない場合の処理
}
```

## 使用できる型

Java 7 以降では、`switch`文で使用できる型には以下のものがある：

- **プリミティブデータ型**：`char`、`byte`、`short`、`int`
- **列挙型（Enum）**
- **文字列型（String）**
- **ラッパークラス**：`Character`、`Byte`、`Short`、`Integer`

### 例

以下は`switch`文の簡単な例です：

```java
int day = 3;
String dayName;
switch (day) {
    case 1:
        dayName = "Monday";
        break;
    case 2:
        dayName = "Tuesday";
        break;
    case 3:
        dayName = "Wednesday";
        break;
    case 4:
        dayName = "Thursday";
        break;
    case 5:
        dayName = "Friday";
        break;
    case 6:
        dayName = "Saturday";
        break;
    case 7:
        dayName = "Sunday";
        break;
    default:
        dayName = "Invalid day";
}
System.out.println("Day: " + dayName);
```

### フォールスルーの注意

- Java の`switch`文は、`break`文を省略すると次の`case`に制御が移る
- これを「フォールスルー」と呼ぶ

### `switch`式の導入（Java 12 以降）

- Java 12 からは、`switch`を式として使用でき、より簡潔に条件に基づいた値を返すコードを書くことが可能になった
- これにより、各`case`の後に`break`を使用する代わりに、直接値を返すことができる

例：

```java
int day = 3;
String dayName = switch (day) {
    case 1 -> "Monday";
    case 2 -> "Tuesday";
    case 3 -> "Wednesday";
    case 4 -> "Thursday";
    case 5 -> "Friday";
    case 6 -> "Saturday";
    case 7 -> "Sunday";
    default -> "Invalid day";
};
System.out.println("Day: " + dayName);
```
