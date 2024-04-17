---
title: "型変換"
---

## 代入における自動型変換

代入処理において以下の条件を満たしている場合、**内部的に自動型変換が行われる**。

- 代入元と代入先が共に整数型（`byte`, `short`, `int`, `long`）又は少数点数型（`double`, `float`）
- 変数の大きさが「代入先の型（左辺）> 代入元の型（右辺）」を満たす

代入における自動型変換は以下の順序で行われる。

1. 代入先の型と同じ型の変数を作成し、代入元のデータを詰め替える（**自動変換**）
2. 詰め替えた変数を代入元の変数に入れる

![](https://storage.googleapis.com/zenn-user-upload/6813fd422dd3-20240417.png)

メモリサイズの小さな変数に大きなサイズの型のデータを代入すると、**桁あふれ（オーバーフロー）** が発生し、エラーとなる。

![](https://storage.googleapis.com/zenn-user-upload/50332d8af12f-20240417.png)

## 算術演算子における自動型変換

算術演算子で使用される変数の型が異なっていても、多くの場合**内部的に自動型変換が行われる**。

**演算時の自動変換ルール**

- 整数同士の場合、サイズの大きな型に揃えて演算される
- `double` 型が含まれる場合、`double` に揃えて演算される

```java
public class DoubleConversionExample {
  public static void main(String[] args) {
    int a = 10;
    double b = 20.5;
    // int と double の演算; 結果は double 型になる
    double result = a + b;
    System.out.println("Result of int + double: " + result); // "30.5" が出力され、double 型である

    long c = 5L;
    float d = 2.5f;
    // long と float の演算が double 型が関与しているわけではないが、イメージのために示す
    // long と float の演算; 結果は float 型になる
    float result2 = c + d;
    System.out.println("Result of long + float: " + result2); // "7.5" が出力され、float 型である

    // float と double の演算; 結果は double 型になる
    double result3 = result2 + b;
    System.out.println("Result of float + double: " + result3); // "38.0" が出力され、double 型である
  }
}
```

### 文字列（`String`）との演算

文字列（`String`）と他のデータ型を組み合わせた演算の場合、文字列型に自動変換される。

````java
int num = 10;
String text = "Number: ";
String result = text + num; // "Number: 10"
```

```java
double pi = 3.14159;
String announce = "Value of Pi: ";
String output = announce + pi; // "Value of Pi: 3.14159"
````

### 文字（`char`）との演算

以下の場合、`char` 型の変数は演算時に整数型（`int`）に自動型変換される。

- `char` と 整数
- `char` と 浮動小数点数
- `char` と `char`

これは、`char` 型が実質的に Unicode の整数値を持っているため。

```java
char c = 'A'; // Unicode for 'A' is 65
int num = 1;
int result = c + num; // 66
```

```java
char c = 'A'; // Unicode for 'A' is 65
double d = 0.5;
double result = c + d; // 65.5
```

```java
char a = 'A'; // Unicode for 'A' is 65
char b = 'B';
double result = c + d; // 65.5
```

## 明示的な型変換

### 数値型同士の型変換

キャスト演算子を使用する。

- 整数型間の変換
- 浮動小数点型から整数型への変換
- 整数型から浮動小数点型への変換

```java
double d = 9.99;
float f = (float) d;  // doubleからfloatへ明示的にキャスト
long l = (long) f;    // floatからlongへ明示的にキャスト、ここで小数点以下切り捨て
int i = (int) l;      // longからintへ明示的にキャスト
short s = (short) i;  // intからshortへ明示的にキャスト
byte b = (byte) s;    // shortからbyteへ明示的にキャスト
```

注意点として、以下がある。

- **データ損失:**
  - 変換先の型の範囲に合わない場合、データ損失が発生する可能性がある
  - 特に整数型から浮動小数点型、またはその逆の変換において注意が必要
- **オーバーフローとアンダーフロー**:
  - 換先の型に値が収まらない場合、オーバーフローやアンダーフローが起こりうる
- **精度の問題:**
  - 動小数点数から整数へのキャストでは、小数点以下が切り捨てられる
  - 大きな数値を小さな型にキャストする際には、正確な値が失われる可能性がある

### 文字 ⇄ 整数の型変換

**文字列 → 　整数:**

```java
String x = "10";
int y = Integer.parseInt(x);
```

**整数 → 　文字列:**

```java
int x = 10;
String y = String.valueOf(x);
```
