---
title: "配列と参照型"
---

## 宣言方法

```java
// 最初に要素数を宣言する場合
型名[] 配列変数名 = new 型名[要素数]
char[] singou = new char[3];
singou[0] = '赤';
singou[1] = '青';
singou[2] = '黄';

// 宣言 ＋ 初期化の場合
型名[] 配列変数名 = new 型名[]{要素1, 要素2, ...};
char[] singou = new char[]{'赤', '青', '黄'};

// もっと短縮できる
型名[] 配列変数名 = {要素1, 要素2, ...};
char[] singou = {'赤', '青', '黄'};
```

上記のような宣言方法では、**配列のサイズは不変となる**。

## 要素数取得

```java
// 配列名.length;
int count = singou.length;
```

## 配列は参照型

- 配列は参照型
- 配列の変数は実際のデータが格納されているメモリ領域を指す参照（アドレス）を保持する

```java
// 配列の初期化
int[] originalArray = new int[3];
originalArray[0] = 10;
originalArray[1] = 20;
originalArray[2] = 30;

// originalArrayの参照をnewArrayに割り当てる
int[] newArray = originalArray;

// newArrayを通じて配列の内容を変更する
newArray[1] = 50;

// originalArrayの内容を表示する
System.out.println("originalArray[1]: " + originalArray[1]); // 出力: originalArray[1]: 50

// newArrayの内容を表示する
System.out.println("newArray[1]: " + newArray[1]); // 出力: newArray[1]: 50
```

配列自体を出力しようとすると、メモリのアドレスが出力される。

```java
int[] array = {1, 2, 3};
System.out.println(array); // [I@4926097b
```

## 多次元配列

### 静的初期化

配列を作成する際に、その内容を直接指定する方法。

```java
int[][] matrix = {
    {1, 2, 3}, // 第1行
    {4, 5, 6}, // 第2行
    {7, 8, 9}  // 第3行
};
```

### 動的初期化

配列のサイズのみを指定し、後から値を入れる方法。

```java
int[][] matrix = new int[3][3]; // 3x3の2次元配列
matrix[0][0] = 1;
matrix[0][1] = 2;
matrix[0][2] = 3;
matrix[1][0] = 4;
matrix[1][1] = 5;
matrix[1][2] = 6;
matrix[2][0] = 7;
matrix[2][1] = 8;
matrix[2][2] = 9;
```

### 多次元配列の操作

```java
int element = matrix[1][2]; // 値6を取得
matrix[2][1] = 10; // 第3行第2列を10に更新
```

```java
for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
        System.out.print(matrix[i][j] + " ");
    }
    System.out.println(); // 新しい行で改行
}
```

## 要素の存在チェック

Java 8 以降では、ストリーム API の `anyMatch` メソッド使ってチェックできる。

```java
import java.util.Arrays;

int[] numbers = {1, 2, 3, 4, 5}; // 例として整数配列を用意
int valueToFind = 3; // 探したい値

boolean found = Arrays.stream(numbers).anyMatch(n -> n == valueToFind);
```
