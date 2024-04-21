---
title: "クラス"
---

## 概要

- クラスはプログラム全体の**設計図**
- 基本的に、**1 つの Java ファイルには 1 つのクラス**
- **ファイル名とクラス名は同じ**ように定義する

Java では、`javac` コマンドによりコンパイルを行うと、`.class` ファイルが生成される。
これは、ファイル内に定義されたクラス単位で生成される。

```java: Main.java
public class Main {
    public static void main(String[] args) {
        System.out.println("This is the main method.");
        Auxiliary aux = new Auxiliary();
        aux.display();
    }
}

class Auxiliary {
    void display() {
        System.out.println("This is the display method of Auxiliary.");
    }
}
```

上記 `Mian.java` をコンパイルすると、以下 2 つのファイルが生成される。

- `Main.class`
- `Auxiliary.class`

ここで、`Auxiliary.class` はどの `.java` ファイルから生成されたのかが一見分かりにくい。
そのため、1 ファイル 1 クラスで記述した方が良い。

## クラス名の命名規則

- 先頭を大文字
- それ以外は小文字
- 言葉の区切りは大文字

## メソッド

## 構造

```java
修飾子 戻り値の型 メソッド名(仮引数) {
  return 戻り値
}
```

### メソッド名の命名規則

- 先頭を小文字
- 文字の区切りは大文字

### `main` メソッド

- プログラムのエントリーポイント
- 実行したクラス内に `main` メソッドが存在しなければ、エラーとなる
- `main` メソッド内の処理が全て完了したら、プログラムが終了となる
  - **`main` で始まり、`main` で終わる**
  - 戻り値を返す相手がいないので、**戻り値の型は `void`**

`main` メソッドの記述方法はあらかじめ定まっている。

```java
public static void main(String[] args) {}
```

## オーバーロード

### 概要

**「引数の型」や「引数の数」が異なれば、クラス内で同名のメソッドを複数定義できる**こと。
ルールは以下の通り。

1. **メソッド名が同じでなければならない**
2. **引数リストが異なる必要がある**
   - 引数の数が異なる
   - 引数の型が異なる
   - 引数の順番が異なる（型が異なる場合）
3. **戻り値の型やアクセス修飾子はオーバーロードの区別に影響しない**

```java
public class OverloadExample {

 // 整数の合計を計算するメソッド
 public int sum(int a, int b) {
    return a + b;
 }

 // 三つの整数の合計を計算するメソッド
 public int sum(int a, int b, int c) {
    return a + b + c;
 }

 // 浮動小数点数の合計を計算するメソッド
 public double sum(double a, double b) {
    return a + b;
 }
}
```

標準出力で使用する `System.out.Println` メソッドは様々なデータ型に対応するために、多数のオーバーロードされた形で定義されている。

- `println()`: 改行のみを出力します。
- `println(boolean x)`: ブール値を出力します。
- `println(char x)`: 単一の文字を出力します。
- `println(int x)`: 整数を出力します。
- `println(long x)`: 長整数を出力します。
- `println(float x)`: 浮動小数点数を出力します。
- `println(double x)`: 倍精度浮動小数点数を出力します。
- `println(char[] x)`: 文字配列を出力します。
- `println(String x)`: 文字列を出力します。
- `println(Object x)`: オブジェクトを出力します（オブジェクトの`toString()`メソッドの結果が出力されます）。

### なぜオーバーロードが便利か？

`println` メソッドのようにオーバーロードされたメソッドが豊富に提供されていると、開発者はデータの型を気にすることなく簡単に値を出力できるため、コーディングが簡単になる。
異なるデータ型に対応するためにメソッド名を変える必要がなくなる。
