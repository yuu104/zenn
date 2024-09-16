---
title: "クラス設計"
---

- 保守や変更がしやすいコードには、関心の分離が重要
- オブジェクト指向は、ロジック整理の方針がわかりやすく、関心の分離が容易
- オブジェクト指向は、ソフトウェアの品質向上を目的とする考え方
- 「クラスベース」とは、データとロジックをクラスにひとまとめにし、プログラムの構造を定義していく手法

## クラス単位で正常に動作するよう設計する

まず重要なのが「**クラスが単体で正常動作するよう設計する**」こと。
まどろっこしい初期設定をせずともはじめから使える設計にする。
また、バグを生み出さないよう、正しく操作できるメソッドのみを外部に提供する。

### 頑固なクラスの構成要素

クラスの構成要素は以下の 2 つ。

- インスタンス変数
- メソッド

この構成を、弊害を招きづらいものにするには、メソッドの役割を明確化する必要がある。
それを踏まえた、良いクラスの構成要素は以下のようになる。

- インスタンス変数
- **インスタンス変数を不正状態から防御し、正常に操作するメソッド**

上記**両方**を備えたクラスが弊害を防ぐ武器になる。

:::details 良いクラスの構成

![](https://storage.googleapis.com/zenn-user-upload/e1a89da8a949-20240915.png)
メソッドは必ずインスタンス変数を使用する。

:::

:::details 良くないクラスの構成

![](https://storage.googleapis.com/zenn-user-upload/35454d074cf6-20240915.png)
メソッド、インスタンス変数のどちらが欠けても良くない。
ただし、目的によっては例外的に許容される場合がある。

:::

何故これらを守らなければならないのか？
それは、データクラスによる以下の弊害が発生するからである。

- 重複コード
- 修正漏れ
- 可読性低下
- 未初期化状態
- 不正値の混入

データクラスでは、インスタンスを生成した直後はインスタンス変数が不正状態だあり、初期化処理をしなければバグになる。
そして、初期化処理は別のクラスに実装されている。

また、どんな値でもインスタンス変数に出し入れ可能であったため、不正値が容易に混入する作りでもあった。
不正値から防御するためのバリデーションは別のクラスに実装されており、データクラス自身に自分を守るロジックは用意されていない。

:::message
このような状態では、「クラスが単体で正常動作するよう設計されている」と言えない。
データクラスは他のクラスがないと正常動作できない、未熟なクラスである。
:::

### すべてのクラスに自己防衛責務を持たせる

ソフトウェアはメソッド、クラス、モジュール、どの粒度でも、単体でバグがなく、いつでも安全に利用できる品質が求められる。
他のクラスに初期化やバリデーションをしてもらうクラスは未熟。

**自己防衛責務をすべてのクラスが備えることが品質を考える上で重要**。
構成部品であるクラス一つ一つが完結していることが、全体の品質を向上させる。

## 成熟したクラスへ成長させる設計術

以下は、金額を表す `Money` クラス。

```java
import java.util.Currency;

class Money {
    int amount;      // 金額値
    Currency currency; // 通貨単位
}
```

このクラスは、データクラスであり、未熟なため、改善していく。

### 1. コンストラクタで確実に正常値を設定する

**未初期化状態（生焼けオブジェクト）** を防ぐ。
そのためには、「インスタンス生成時に、インスタンス変数に正常値が確実に設定されている状態」にする。

```java
class Money {
    int amount;
    Currency currency;

    Money(int amount, Currency currency) {
        this.amount = amount;
        this.currency = currency;
    }
}
```

上記で、インスタンス変数を確実に初期化できる。
しかし、これでは不十分。
「不正値の混入」が発生する可能性がある。

```java
Money money = new Money(-100, null);
```

「不正値の混入」を防ぐために、コンストラクタ内にバリデーションを実装する。
不正値の場合、例外をスローする。

:::details 正常値のルール

- 金額 `amount` : 0 以上の整数
- 通過 `currency` : null 以外

:::

```java
class Money {
    // 省略（フィールドの定義など）

    Money(int amount, Currency currency) {
        if (amount < 0) {
            throw new IllegalArgumentException("金額には 0 以上を指定してください。");
        }

        if (currency == null) {
            throw new NullPointerException("通貨単位を指定してください。");
        }

        this.amount = amount;
        this.currency = currency;
    }
}
```

これで、「不正値の混入」を防ぐことができた。

上記コンストラクトのように、処理の対象外となる条件を先頭に定義する方法を「**ガード節**」と言う。
ガード節を用いると、不要な要素を先頭で排除できるので、後続のロジックがシンプルになる。

ガード節をコンストラクタに配置することで、常に正常なインスタンスのみを存在させることができる。

### 2. 計算ロジックをデータ保持側に寄せる

インスタンス変数を操作する計算ロジックは自身のクラスに持たせる。

以下は金額加算ロジックを自身のメソッドとして追加する例。

```java
class Money {
    // 省略
    void add(int other) {
        amount += other;
    }
}
```

これで `Money` はかなり成熟したクラスになった。
しかし、これはまだ完璧ではない。

### 3. インスタンス変数を不変にする

インスタンス変数の上書きは、理解を難しくする。

```java
money.amount = originalPrice;

// 中略

if (specialServiceAdded) {
    money.add(additionalServiceFee);
    // 中略
    if (seasonOffApplied) {
        money.amount = seasonPrice();
    }
}
```

変数の値が変わる前提だと、以下の弊害が生じる。

- いつ変更されたのか、今の値がどうなっているのかを常に気にする必要がある
- 仕様変更で処理が変わったとき、意図しない値に書き換わる可能性がある

対策として、変数を不変（イミュータブル）にする。

```java
class Money {
    final int amount;
    final Currency currency;

    Money(int amount, Currency currency) {
        // 省略
        this.amount = amount;
        this.currency = currency;
    }
}
```

これにより、再代入できなくなる。

```java
Currency yen = Currency.getInstance(Locale.JAPAN);
Money money = new Money(100, yen);
money.amount = -200; // コンパイルエラー
```

### 4. 変更したい場合は新規インスタンスを作成する

インスタンス変数をイミュータブルにした場合、どのように金額を変更すれば良いのか？
それは、新規インスタンスとして再生成することにより解決できる。

```java
class Money {
    // 省略

    Money add(int other) {
        int added = amount + other;
        return new Money(added, currency);
    }
}
```

### 5. メソッド引数やローカル変数も不変にする

メソッド引数はメソッド内で変更可能。

```java
void doSomething(int value) {
    value = 100;
```

値がミュータブルだと、利用者側で処理を把握しておく必要があり、バグの原因にもなる。
よって基本的に引数は変更するものではない。

```java
void doSomething(final int value) {
    value = 100; // コンパイルエラーになる
```

```diff java
  class Money {
      // 省略

-     Money add(int other) {
+     Money add(final int other) {
          int added = amount + other;
          return new Money(added, currency);
      }
  }
```

### 6. 「値の渡し間違い」を型で防止する

現状、`add` メソッドは引数に `int` 型の値を受け取る。
そのため、以下のようなこともできてしまう。

```java
final int ticketCount = 3; // チケット枚数
money.add(ticketCount);
```

引数には「金額」に該当する値を期待しているが、上記では「チケット枚数」の値を渡している。
これは、「`int` 型を渡す」という意味では同じだが、明らかにバグである。

対策として、`Money` 型を引数に受け取るよう変更する。

```diff java
  class Money {
      // 省略

-     Money add(final int other) {
+     Money add(final Money other) {
-         int added = amount + other;
+         int added = amount + other.amount;
          return new Money(added, currency);
      }
  }
```

プリミティブ型を使用すると、このようなミスに繋がりやすいので注意。

`Money` 型を渡すことで、通貨（`currency`）単位での加算を防止できる。

```diff java
  class Money {
      // 省略

    Money add(final Money other) {
+       if (!currency.equals(other.currency)) {
+         throw new IllegalArgumentException("通貨単位が違います。");
+       }
        int added = amount + other.amount;
        return new Money(added, currency);
    }
  }
```

### 7. 使わないメソッドは追加しない

以下のような金額の乗算メソッドは必要だろうか？

```diff java
  class Money {
      // 省略

+    Money multiply(Money other) {
+         if (!currency.equals(other.currency)) {
+             throw new IllegalArgumentException("通貨単位が違います。");
+         }
+
+         final int multiplied = amount * other.amount;
+         return new Money(multiplied, currency);
+     }
  }
```

会計サービスでは、金額の乗算を行うケースは存在しない。
「いつか必要になるかもしれないから実装しておこう」という考えて不要なメソッドを追加するのはやめよう。

## 成熟したクラスによってどのような改善があるか？

成熟した `Money` クラスは以下になる。

```java
import java.util.Currency;

class Money {
    final int amount;
    final Currency currency;

    Money(final int amount, final Currency currency) {
        if (amount < 0) {
            throw new IllegalArgumentException("金額には 0 以上を指定してください。");
        }
        if (currency == null) {
            throw new NullPointerException("通貨単位を指定してください。");
        }

        this.amount = amount;
        this.currency = currency;
    }

    Money add(final Money other) {
        if (!currency.equals(other.currency)) {
            throw new IllegalArgumentException("通貨単位が違います。");
        }

        final int added = amount + other.amount;
        return new Money(added, currency);
    }
}
```

![](https://storage.googleapis.com/zenn-user-upload/92f2f964cb26-20240916.png)

これらにより低擬集によって発生する弊害がどのように改善されたのだろうか？

| 悪魔               | どうなったか?                                                                                                                         |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| 重複コード         | 必要なロジックが `Money` クラスに集まっていたため、別のクラスに重複コードが書き散らされにくくなった。                                 |
| 修正漏れ           | 重複コード解消に伴い修正漏れも発生しにくくなった。                                                                                    |
| 可読性低下         | 必要なロジックは `Money` クラスに集まっていたため、デバッグ時や仕様変更時にあちこち関連ロジックを探し回らずに済み、可読性が向上した。 |
| 生焼けオブジェクト | コンストラクタでインスタンス変数の値を確定し、未初期化状態がなくなった。                                                              |
| 不正値の混入       | 不正値を弾くガード節を用意し、インスタンス変数を `final` 修飾子で不変にすることで、不正値が混入されないようになった。                 |
| 思わぬ副作用       | `final` 修飾子で不変にすることで副作用から解放された。                                                                                |
| 値の渡し間違い     | 引数を `Money` 型にすることで、異なる型の値をコンパイラで防止できるようになった。                                                     |

:::message
**クラス設計とは、インスタンス変数を不変状態に陥らせないための仕組み作り。**
:::

`Money` クラスのように、密接に関係し合うロジックが集まっている構造を「**高凝集**」と呼ぶ。
また、データとデータを操作するロジックを一つのクラスにまとめ、必要なメソッドのみを外部へ公開することを「**カプセル化**」と呼ぶ。

## 良い設計パターン

プログラム構造を改善する設計手法を「**設計パターン（デザインパターン）**」と呼ぶ。

| 設計パターン                 | 効果                                                               |
| ---------------------------- | ------------------------------------------------------------------ |
| 完全コンストラクタ           | 不正状態から防護する                                               |
| 値オブジェクト               | 特定の値に関するロジックを高凝集にする                             |
| ストラテジ                   | 条件分岐を削減し、ロジックを単純化する                             |
| ポリシー                     | 条件分岐を単純化したり、カスタマイズできるようにする               |
| ファーストクラスコレクション | 値オブジェクトの亜種で、コレクションに関するロジックを高凝集にする |
| スプラウトクラス             | 既存のロジックを変更せずに安全に新機能を追加する                   |

### 完全コンストラクタ

未初期化状態（生焼けオブジェクト）を防ぐ。

以下の特徴を持つ。

- インスタンス変数をすべて初期化できるだけの引数を持ったコンストラクタを用意する
- コンストラクタ内では、ガード節で不正値を弾く

さらに、インスタンス変数をイミュータブルにすることで、生成後の不正状態を防ぐ。

### 値オブジェクト

値をクラス（型）として表現する設計パターン。
以下のような値をクラスとして表現することで、各値それぞれのロジックを高凝集にする。

- 金額
- 日付
- 注文数
- 電話番号

単なるプリミティブ型として扱うよりも以下のようなメリットが存在する。

- 値の渡し間違いを防ぐ
- バリデーションロジックを含めることが可能

値オブジェクトとして設計可能な例は以下になる。

| アプリケーション | 値オブジェクトとなる値、概念                                                                                                                       |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| EC サイト        | 税別金額、税込み金額、商品名、注文数、電話番号、配送元、配送先、割引ポイント、割引料金、配送日時                                                   |
| タスク管理ツール | タスクタイトル、タスク説明、コメント、開始日、期日、優先度、進捗状態、担当者 ID、担当者名                                                          |
| 健康管理アプリ   | 年齢、性別、身長、体重、BMI、血圧、腹囲、体脂肪量、体脂肪率、基礎代謝量                                                                            |
| ゲーム           | 最大ヒットポイント、残りヒットポイント、ヒットポイント回復量、攻撃力、魔法力、消費魔法力、所持金、敵がドロップする金額、アイテムの売値、アイテム名 |

「値オブジェクト」と「完全コンストラクタ」はセットで用いられる。

:::message

**「値オブジェクト + 完全コンストラクタ」は、オブジェクト指向設計の最も基本形を体現している構造の一つ。**

:::