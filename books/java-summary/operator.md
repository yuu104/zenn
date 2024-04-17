---
title: "演算子"
---

## 1. 算術演算子

- `+` (加算)
- `-` (減算)
- `*` (乗算)
- `/` (除算)
- `%` (剰余)
- `++` (インクリメント)
- `--` (デクリメント)

```java
class Sample {
	public static void main (String[] args) {

		int numberX = 8 ;
		int numberY = 4 ;
		int numberZ = 5 ;
		String stNumberX = "1";
		String stNumberY = "2";

		//『 + 』
		int answer1 = numberX + numberY ;
		System.out.println("answer1：" + answer1); // answer1：12

		//『 - 』
		int answer2 = numberX - numberY ;
		System.out.println("answer2：" + answer2); // answer2：4

		//『 * 』
		int answer3 = numberX * numberY ;
		System.out.println("answer3：" + answer3); // answer3：32

		//『 / 』
		int answer4 = numberX / numberY ;
		System.out.println("answer4：" + answer4); // answer4：2

		//『 / 』（割り切れない場合）
		int answer5 = numberX / numberZ ;
		System.out.println("answer5：" + answer5); // answer5：1

		//『 % 』
		int answer6 = numberX % numberZ ;
		System.out.println("answer6：" + answer6); // answer6：3

		// 符号反転
		int answer7 = -answer6 ;
		System.out.println("answer7：" + answer7); // answer7：-3

		//『 ○++ 』
		int answer8 = numberX++ ;
		System.out.println("answer8：" + answer8); // answer8：8
		System.out.println("（ numberX：" + numberX + " ）"); // （ numberX：9 ）

		//『 ++○ 』
		int answer9 = ++numberY ;
		System.out.println("answer9：" + answer9); // answer9：5
		System.out.println("（ numberY：" + numberY + " ）"); // （ numberY：5 ）

		//『 +1 』と『 ++ 』の使い分けの注意
		int answer10 = numberZ + 1 ;
		System.out.println("answer10：" + answer10); // answer10：6
		System.out.println("（ numberZ：" + numberZ + " ）"); // （ numberZ：5 ）

		//『 -- 』
		int answer11 = numberZ-- ;
		System.out.println("answer11：" + answer11); // answer11：5
		System.out.println("（ numberZ：" + numberZ + " ）"); // （ numberZ：4 ）

		//『 + 』（文字の結合）
		String answer12 = stNumberX + stNumberY ;
		System.out.println("answer12：" + answer12); // answer12：12

	}
}
```

### 除算

#### 整数除算

- 整数型の値（`int`、`long`など）で除算を行うと、結果は整数型となる
- このとき、小数点以下の部分は切り捨てられる
- 例えば、`7 / 3` は `2` となり、`-7 / 3` は `-2` となる

```java
int a = 7;
int b = 3;
int result = a / b;  // result は 2
System.out.println("7 / 3 = " + result);

int c = -7;
int d = 3;
int result2 = c / d;  // result2 は -2
System.out.println("-7 / 3 = " + result2);
```

#### 整数同士を除算して小数値を得たい場合

演算を行う前に分子または分母のどちらか一方を double 型にキャストする必要がある。

```java
int a = 55;
int b = 25;
double r = (double) a / b
// 答えは2.2
```

#### ゼロによる除算

- Java では、整数のゼロによる除算は例外を引き起こす（`ArithmeticException`）
- 一方で、浮動小数点数によるゼロ除算では例外は発生せず、結果は無限大（`Infinity`）または非数（`NaN`：Not a Number）になる

- 整数のゼロ除算の例：

```java
int e = 10;
int f = 0;
int result4 = e / f;  // ここで ArithmeticException が発生
```

- 浮動小数点数のゼロ除算の例：

```java
double m = 10.0;
double n = 0.0;
double result5 = m / n;  // result5 は Infinity
System.out.println("10.0 / 0.0 = " + result5);

double p = 0.0;
double q = 0.0;
double result6 = p / q;  // result6 は NaN
System.out.println("0.0 / 0.0 = " + result6);
```

### 2. 代入演算子

- `=` (基本代入)
- `+=` (加算代入)
- `-=` (減算代入)
- `*=` (乗算代入)
- `/=` (除算代入)
- `%=` (剰余代入)

### 3. 比較演算子

- `==` (等しい)
- `!=` (等しくない)
- `>` (より大きい)
- `<` (より小さい)
- `>=` (以上)
- `<=` (以下)

### 4. 論理演算子

- `&&` (AND)
- `||` (OR)
- `!` (NOT)

### 5. ビット演算子

- `&` (ビット AND)
- `|` (ビット OR)
- `^` (ビット XOR)
- `~` (ビット NOT)
- `<<` (左シフト)
- `>>` (右シフト)
- `>>>` (符号なし右シフト)

### 6. 条件演算子（三項演算子）

- `条件 ? 値1 : 値2` (条件が true の場合は値 1 を、false の場合は値 2 を返す)

### 7. 型演算子

- `instanceof` (オブジェクトが指定した型のインスタンスであるかどうかを評価)
