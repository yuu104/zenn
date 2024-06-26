---
title: "CASE式"
---

- SQL で `if~else` のような条件分岐を行いたいときに使用する
- **単純 CASE 式**と**検索 CASE 式**の 2 種類がある

## 単純 CASE 式

カラムの値が指定した値と等価であるかを判定し、処理の分岐を行う。

### 基本構文

```sql
CASE カラム
    WHEN 値1 THEN 結果1
    WHEN 値2 THEN 結果2
    ・
    ELSE 結果3
END
```

- `CASE` と書いた後に対象となるカラムを指定する
- `WHEN` 句から `ELSE` 句でカラムの値に基づき処理を分岐する
- `WHEN` 句で値を指定し、その値が `カラム` の値と等価である場合に返す結果を、`THEN` の後に記述する
- 上述した `WHEN` 句の値と等価でない場合に行う別の処理を、次の `WHEN` 句に記述する
- どの `WHEN` 句にも一致しない場合に返す値を、`ELSE` 句に記述する
- 最後に `END` を記述し、`CASE` 式を終了する

### 使用例

| 品名 | 型番番号 | 数字 |
| ---- | -------- | ---- |
| 高橋 | a001     | 1    |
| 伊藤 | a002     | 2    |
| 金木 | a003     | 3    |
| 佐藤 | a004     | 4    |

- 数学の点数に基づいて成績を割り振ってみる
- 数学の点数が、`1` であれば `C`、`4` であれば `A`、それ以外であれば `B` とする

```sql
SELECT * ,
    CASE 数学
        WHEN 1 THEN 'C'
        WHEN 4 THEN 'A'
        ELSE 'B'
    END 成績
FROM test01;
```

- 上記は `SELECT` で全てのカラムと `CASE` により新たに生成したカラムを取得している
- `CASE` で取得するカラムに別名をつけたい場合は、`END` のあとに記述する

結果は以下の通り。

| 品名 | 型番番号 | 数字 | 評価 |
| ---- | -------- | ---- | ---- |
| 高橋 | a001     | 1    | C    |
| 伊藤 | a002     | 2    | B    |
| 金木 | a003     | 3    | B    |
| 佐藤 | a004     | 4    | A    |

## 検索 CASE 式

単純 CASE 式よりも複雑な条件で処理を分岐させることが可能。

### 基本構文

```sql
CASE
    WHEN 条件式1 THEN 結果1
    WHEN 条件式2 THEN 結果2
    ・
    ELSE 結果3
END
```

- 構造は単純 CASE 式と似ている
- 単純 CASE 式との違いは
  - `CASE` の後に条件分岐の対象となるカラムを記述しない
  - `WHEN` 句で条件式を記述し、条件式が真の時に返す結果を `THEN` の後に書く
- 単純 CASE 式を検索 CASE 式で置き換えることもできる

### 使用例 ①

| 品名 | 型番番号 | 数字 |
| ---- | -------- | ---- |
| 高橋 | a001     | 1    |
| 伊藤 | a002     | 2    |
| 金木 | a003     | 3    |
| 佐藤 | a004     | 4    |

- 数学の点数に基づいて成績を割り振ってみる
- 数学の点数が、`1` であれば `C`、`4` であれば `A`、それ以外であれば `B` とする

```sql
SELECT * ,
    CASE
        WHEN 数学 = 1 THEN 'C'
        WHEN 数学 = 4 THEN 'A'
        ELSE 'B'
    END 成績
FROM test01;
```

| 品名 | 型番番号 | 数字 | 評価 |
| ---- | -------- | ---- | ---- |
| 高橋 | a001     | 1    | C    |
| 伊藤 | a002     | 2    | B    |
| 金木 | a003     | 3    | B    |
| 佐藤 | a004     | 4    | A    |

### 使用例 ②

| index | 販売日   | 社員 ID | 商品分類 | 商品名       | 単価  | 数量 | 販売金額 |
| ----- | -------- | ------- | -------- | ------------ | ----- | ---- | -------- |
| 1     | 2020/1/4 | a023    | ボトムス | ロングパンツ | 7000  | 8    | 56000    |
| 2     | 2020/1/5 | a003    | ジーンズ | ジーンズ     | 6000  | 10   | 60000    |
| 3     | 2020/1/5 | a052    | アウター | ジャケット   | 10000 | 7    | 70000    |
| 4     | 2020/1/6 | a003    | ボトムス | ロングパンツ | 7000  | 10   | 70000    |

- 売上金額に応じてキャッシュバックが行われると仮定する
- キャッシュバック金額は以下の通り

| 販売金額                     | キャッシュバック |
| ---------------------------- | ---------------- |
| 100,000 円以上               | 10,000 円        |
| 50,000 円以上 100,000 円未満 | 3,000 円         |
| 50,000 円未満                | 1,000 円         |

- キャッシュバックの金額を示すカラムを追加で抽出する
- 「売上金額が何円以上何円以下の範囲内にあるか」という条件に基づき処理を分岐させる

```sql
SELECT * ,
    CASE
        WHEN 売上金額 >= 100000 THEN 10000
        WHEN 売上金額 >= 50000 THEN 3000
        ELSE 1000
    END キャッシュバック
FROM test_table;
```

| index | 販売日   | 社員 ID | 商品分類 | 商品名       | 単価  | 数量 | 販売金額 | キャッシュバック |
| ----- | -------- | ------- | -------- | ------------ | ----- | ---- | -------- | ---------------- |
| 1     | 2020/1/4 | a023    | ボトムス | ロングパンツ | 7000  | 8    | 56000    | 3000             |
| 2     | 2020/1/5 | a003    | ジーンズ | ジーンズ     | 6000  | 10   | 60000    | 3000             |
| 3     | 2020/1/5 | a052    | アウター | ジャケット   | 10000 | 7    | 70000    | 3000             |
| 4     | 2020/1/6 | a003    | ボトムス | ロングパンツ | 7000  | 10   | 70000    | 3000             |
| 5     | 2020/1/7 | a036    | ボトムス | ロングパンツ | 7000  | 2    | 14000    | 1000             |

### 使用例 ③（CASE 式を入れ子にして使用する）

- 使用例 ② のキャッシュバックが 1 月限定のキャンペーンであると仮定する
- 売上日が 1 月中であるレコードに対してのみ、キャッシュバックの金額を求める
- 1 月でないレコードには `0` を入れる

```sql
SELECT * ,
    CASE
        WHEN 売上日 BETWEEN '2020-01-01' AND '2020-01-31' THEN
            CASE
                WHEN 売上金額 >= 100000 THEN 10000
                WHEN 売上金額 >= 50000 THEN 3000
                ELSE 1000
            END
        ELSE 0
    END キャッシュバック
FROM test_table;
```

| index | 販売日   | 社員 ID | 商品分類 | 商品名       | 単価  | 数量 | 販売金額 | キャッシュバック |
| ----- | -------- | ------- | -------- | ------------ | ----- | ---- | -------- | ---------------- |
| 1     | 2020/1/4 | a023    | ボトムス | ロングパンツ | 7000  | 8    | 56000    | 3000             |
| 2     | 2020/1/5 | a003    | ジーンズ | ジーンズ     | 6000  | 10   | 60000    | 3000             |
| 3     | 2020/1/5 | a052    | アウター | ジャケット   | 10000 | 7    | 70000    | 3000             |
| 4     | 2020/1/6 | a003    | ボトムス | ロングパンツ | 7000  | 10   | 70000    | 3000             |
| 5     | 2020/1/7 | a036    | ボトムス | ロングパンツ | 7000  | 2    | 14000    | 1000             |
| 20    | 2020/2/2 | a003    | ボトムス | ロングパンツ | 7000  | 4    | 28000    | 0                |
| 21    | 2020/2/3 | a036    | トップス | シャツ       | 4000  | 5    | 20000    | 0                |
| 22    | 2020/2/3 | a047    | アウター | ジャケット   | 18000 | 8    | 144000   | 0                |
