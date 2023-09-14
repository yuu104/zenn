---
title: "ER図"
---

- テーブル同士の関係を記述したもの
- ER 図の書き方は複数存在する
- 代表的なフォーマット
  - IE
  - IDEFIX
- IE が一般的？

![](https://storage.googleapis.com/zenn-user-upload/81c8c68fab7e-20230914.png)

上記のように各エンティティを線で繋ぎ、リレーションを特殊な表記で表す。

## テーブル（エンティティ）の表記方法

- テーブル（エンティティ）の表現方法は IDEFIX も IE も同じ

![](https://storage.googleapis.com/zenn-user-upload/e8c573dd3016-20230914.png)

- PK : 主キー
- FK : 外部キー

[draw.io](https://tgg.jugani-japan.com/tsujike/2021/02/er4/) などのツールを用いて ER 図を記述する。

## ER 図のリレーション表記法一覧

![](https://storage.googleapis.com/zenn-user-upload/7f338a9dcc05-20230914.png =500x)

`-`, `○`, `⩚` は相手のエンティティと対応するレコード数を指す。
これを「**カーディナリティ**」と呼ぶ。

## 1 対 多

![](https://storage.googleapis.com/zenn-user-upload/d6e2d3d428d1-20230914.png)

上記では

- 会社と社員の関係が「1 対多（ただし 0 も含む）」
- 部署と社員が「1 対多（ただし 0 も含む）」

関係を表している。

## 多対多

![](https://storage.googleapis.com/zenn-user-upload/0c4478a619a3-20230914.png)

- 一人の学生は、複数の講義に出席することができる
- 一つの講義には、複数の学生が参加できる
- つまり、`学生` と `講義` の関係は多対多

### 多対多の問題点

- RDB では 1 つのセルに 1 つの値までしか入れることはできない
- つまり、下記のように 1 つのセルが `講義コード` を複数持つことはできない

![](https://storage.googleapis.com/zenn-user-upload/4c2bf293f4e3-20230914.png)

### 中間テーブルの利用

![](https://storage.googleapis.com/zenn-user-upload/c6817285f708-20230914.png)

中間テーブル `学生_講義` テーブルは、多対多の関係にある 2 つのテーブルの主キー

- `学生コード`
- `講義コード`

を持っている。
