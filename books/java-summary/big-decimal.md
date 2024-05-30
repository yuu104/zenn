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

## 主要メソッド

:::details add ~ 足し算を行う

`BigDecimal`同士の足し算を行います。計算の精度を保ちながら、2 つの数値を加算します。

#### シグネチャ:

```java
public BigDecimal add(BigDecimal augend)
```

- **引数**:

  - `augend`: 加える値

- **戻り値**:
  - `BigDecimal`: 加算結果

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
BigDecimal b = new BigDecimal("2.3");
BigDecimal result = a.add(b); // 結果は 12.8
```

:::

:::details subtract ~ 引き算を行う

`BigDecimal`同士の引き算を行います。計算の精度を保ちながら、2 つの数値を減算します。

#### シグネチャ:

```java
public BigDecimal subtract(BigDecimal subtrahend)
```

- **引数**:

  - `subtrahend`: 引く値

- **戻り値**:
  - `BigDecimal`: 減算結果

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
BigDecimal b = new BigDecimal("2.3");
BigDecimal result = a.subtract(b); // 結果は 8.2
```

:::

:::details multiply ~ 掛け算を行う

`BigDecimal`同士の掛け算を行います。計算の精度を保ちながら、2 つの数値を乗算します。

#### シグネチャ:

```java
public BigDecimal multiply(BigDecimal multiplicand)
```

- **引数**:

  - `multiplicand`: 掛ける値

- **戻り値**:
  - `BigDecimal`: 乗算結果

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
BigDecimal b = new BigDecimal("2.3");
BigDecimal result = a.multiply(b); // 結果は 24.15
```

:::

:::details divide ~ 割り算を行う

`BigDecimal`同士の割り算を行います。割り算の結果が無限小数になる場合、指定した精度で丸めることができます。

#### シグネチャ:

```java
public BigDecimal divide(BigDecimal divisor, int scale, RoundingMode roundingMode)
```

- **引数**:

  - `divisor`: 割る値
  - `scale`: 小数点以下の桁数
  - `roundingMode`: 丸め方

- **戻り値**:
  - `BigDecimal`: 割り算結果

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
BigDecimal b = new BigDecimal("2.3");
BigDecimal result = a.divide(b, 2, RoundingMode.HALF_UP); // 結果は 4.57
```

:::

:::details setScale ~ 小数点以下の桁数を設定する

`BigDecimal`の値を指定した小数点以下の桁数に丸めます。丸め方も指定できます。

#### シグネチャ:

```java
public BigDecimal setScale(int newScale, RoundingMode roundingMode)
```

- **引数**:

  - `newScale`: 小数点以下の桁数
  - `roundingMode`: 丸め方

- **戻り値**:
  - `BigDecimal`: 指定されたスケールで丸められた結果

**例**:

```java
BigDecimal a = new BigDecimal("10.5678");
BigDecimal result = a.setScale(2, RoundingMode.HALF_UP); // 結果は 10.57
```

:::

:::details compareTo ~ 比較を行う

`BigDecimal`同士を比較します。結果は`-1`（小さい）、`0`（等しい）、`1`（大きい）のいずれかです。

#### シグネチャ:

```java
public int compareTo(BigDecimal val)
```

- **引数**:

  - `val`: 比較対象の値

- **戻り値**:
  - `int`: 比較結果（-1, 0, 1）

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
BigDecimal b = new BigDecimal("2.3");
int result = a.compareTo(b); // 結果は 1（a は b より大きい）
```

:::

:::details abs ~ 絶対値を取得する

`BigDecimal`の絶対値を取得します。負の数を正の数に変換します。

#### シグネチャ:

```java
public BigDecimal abs()
```

- **戻り値**:
  - `BigDecimal`: 絶対値

**例**:

```java
BigDecimal a = new BigDecimal("-10.5");
BigDecimal result = a.abs(); // 結果は 10.5
```

:::

:::details negate ~ 符号を反転する

`BigDecimal`の符号を反転します。正の数を負の数に、負の数を正の数に変換します。

#### シグネチャ:

```java
public BigDecimal negate()
```

- **戻り値**:
  - `BigDecimal`: 符号を反転した値

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
BigDecimal result = a.negate(); // 結果は -10.5
```

:::

:::details toString ~ 文字列に変換する

`BigDecimal`を文字列に変換します。数値を文字列として表現するために使用します。

#### シグネチャ:

```java
public String toString()
```

- **戻り値**:
  - `String`: 文字列に変換された値

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
String result = a.toString(); // 結果は "10.5"
```

:::

:::details divideAndRemainder ~ 割り算と余りを同時に求める

割り算の商と余りを同時に求めるメソッドです。結果は 2 つの`BigDecimal`の配列として返されます。

#### シグネチャ:

```java
public BigDecimal[] divideAndRemainder(BigDecimal divisor)
```

- **引数**:

  - `divisor`: 割る数

- **戻り値**:
  - `BigDecimal[]`: 商と余りを含む 2 つの`BigDecimal`

**例**:

```java
BigDecimal a = new BigDecimal("10.5");
BigDecimal b = new BigDecimal("3");
BigDecimal[] result = a.divideAndRemainder(b); // 結果は [3, 1.5]
```

:::

:::details pow ~ 累乗計算を行う

指定した指数で累乗計算を行います。

#### シグネチャ:

```java
public BigDecimal pow(int n)
```

- **引数**:

  - `n`: 累乗の指数

- **戻り値**:
  - `BigDecimal`: 累乗結果

**例**:

```java
BigDecimal a = new BigDecimal("2");
BigDecimal result = a.pow(3); // 結果は 8
```

:::

:::details valueOf ~ 値を BigDecimal に変換する

`long`型や`double`型の値を`BigDecimal`に変換します。

#### シグネチャ:

```java
public static BigDecimal valueOf(long val)
public static BigDecimal valueOf(double val)
```

- **引数**:

  - `val`: 変換する値

- **戻り値**:
  - `BigDecimal`: 変換された値

**例**:

```java
BigDecimal a = BigDecimal.valueOf(10L); // longから変換
BigDecimal b = BigDecimal.valueOf(10.5); // doubleから変換
```

:::

:::details stripTrailingZeros ~ 末尾のゼロを除去する

数値の末尾にある不要なゼロを除去します。

#### シグネチャ:

```java
public BigDecimal stripTrailingZeros()
```

- **戻り値**:
  - `BigDecimal`: 末尾のゼロが除去された結果

**例**:

```java
BigDecimal a = new BigDecimal("10.5000");
BigDecimal result = a.stripTrailingZeros(); // 結果は 10.5
```

:::

:::details scale ~ 小数点以下の桁数を取得する

`BigDecimal`の小数点以下の桁数を返します。

#### シグネチャ:

```java
public int scale()
```

- **戻り値**:
  - `int`: 小数点以下の桁数

**例**:

```java
BigDecimal a = new BigDecimal("10.50");
int scale = a.scale(); // 結果は 2
```

:::

:::details unscaledValue ~ スケールが適用される前の整数部分を取得する

`BigDecimal`のスケールが適用される前の整数部分を返します。

#### シグネチャ:

```java
public BigInteger unscaledValue()
```

- **戻り値**:
  - `BigInteger`: スケールが適用される前の整数部分

**例**:

```java
BigDecimal a = new BigDecimal("123.45");
BigInteger unscaled = a.unscaledValue(); // 結果は 12345
```

:::

:::details toPlainString ~ 10 進表記の文字列に変換する

指数表記を使用せずに、10 進表記の文字列に変換します。

#### シグネチャ:

```java
public String toPlainString()
```

- **戻り値**:
  - `String`: 10 進表記の文字列

**例**:

```java
BigDecimal a = new BigDecimal("1.23E3");
String plainString = a.toPlainString(); // 結果は "1230"
```

:::
