---
title: "BigDecimal"
---

## 浮動小数点計算の誤差問題

以下のような `double` 型の計算をやってみる。

```java
public class Sample {
  public static void main(String[] args) {
    System.out.println("「1.5 - 6 * 0.1」の計算（double型）");
    System.out.println(1.5 - 6 * 0.1);
  }
}
```

期待する出力結果は `0.9` であるが、実際は以下になる。

```shell
「1.5 - 6 * 0.1」の計算（double型）
0.8999999999999999
```

なぜ期待しない計算結果となるのか？
それは、2 進数での表現における限界に起因している。

`0.1` を 2 進数に変換すると、`0.000110011001100110011...` となり、正確に表現することができない。
この無限循環小数を、浮動小数点数としての固定ビット数で表す際にはどこかで打ち切る必要がある。
この打ち切りによって微笑な誤差が生じ、その後の計算誤差が生まれる。

## BigDecimal とは

- Java SE の `java.math` パッケージに含まれるクラス
- 浮動小数点数では避けれれない誤差を解消するために使用される
- 任意の精度の数値計算をサポートし、金融や科学計算など、高い数値精度が求められるアプリケーションにおいて重宝される
- コンストラクタ引数に指定した値（文字列、整数、浮動小数点数）を 10 進数に変換して計算を行うことができる

## BigDecimal で計算してみる

```java
import java.math.BigDecimal;

public class Sample {
  public static void main(String[] args) {
    System.out.println("「1.5 - 6 * 0.1」の計算（double型）");
    BigDecimal b1 = new BigDecimal(1.5);
    BigDecimal b2 = new BigDecimal(-6);
    BigDecimal b3 = new BigDecimal("0.1");
    BigDecimal result = b1.add(b2.multiply(b3));
    System.out.println(result);
  }
}
```

- `new BigDecimal` のコンストラクタ引数に値を指定することで、10 進数に変換された `BigDecimal` 型が生成される
- 後はこれらの変数に対し、`add` メソッドや `multiply` メソッドを使用して計算を行う

出力結果は以下になる。

```shell
「1.5 - 6 * 0.1」の計算（double型）
0.9
```

## コンストラクタ引数には文字列を指定する

- プリミティブな浮動小数点型は、内部的に 2 進数で数値を表現し、10 進数の小数を正確に表現できない
- よって、浮動小数点数を `BigDecimal` に変換する際は、文字列型でコンストラクタ引数に渡すべき

```java
// 正しい使用例
BigDecimal correct = new BigDecimal("0.1");
System.out.println(correct); // 出力: 0.1

// 誤った使用例（doubleを使用）
BigDecimal incorrect = new BigDecimal(0.1);
System.out.println(incorrect); // 出力: 0.1000000000000000055511151231257827021181583404541015625
```
