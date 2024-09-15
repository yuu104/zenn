---
title: "悪しき構造の弊害を知覚する"
---

良い構造へ改善するには、まず悪しき構造の弊害を知ることが必須。
設計の重要さを知覚するには、設計をないがしろにするとどのような弊害が発生するのかを知ることが第一歩。

「弊害」とは？

- コードを読み解くのに時間がかかる
- バグを埋め込みやすくしてしまう
- 悪しき構造がさらに悪しき構造を誘発する

## 意味不明な命名

以下のコードは何を意味するものか？

```java
class MemoryStateManager {
    void changeIntValue01(int changeValue) {
        intValue01 -= changeValue;

        if (intValue01 < 0) {
            intValue01 = 0;
            updateState02Flag();
        }
    }

    ...
}
```

全くわからない...

プログラミング用語やコンピュータ用語にもとづいた命名がされている。

- `Int`
- `Memory`
- `Flag`

このような技術ベースでの命名を「**技術駆動命名**」と呼ぶ。

下記はどうだろうか？

```java
class Class001 {
    void method001();

    void method002();

    void method003();

    ...
}
```

上記のように、クラスやメソッドに対し番号付けで命名するのを「**連番命名**」と呼ぶ。

このような技術駆動命名や連番命名は、意図がまったく読み取れないため、悪しき手法であり、以下のような弊害を生む。

- コードは理解が難しくなる
- 読み解くのに時間がかかる
- 理解が不十分な状態で変更するとバグになる

## 理解を困難にする条件分岐のネスト

下記は RPG における、魔法発動までの条件を実装したもの。

```java
// 生存しているか判定
if (0 < member.hitPoint) {
    // 行動可能かを判定
    if (member.canAct()) {
        // 魔法力が残存しているかを判定
        if (magic.costMagicPoint <= member.magicPoint) {
            member.consumeMagicPoint(magic.costMagicPoint);
            member.chant(magic);
        }
    }
}
```

上記のように、if 文が「**ネスト**」している。

ネストは以下のような弊害を生む。

- コードの見通しが悪くなる
- どこからどこまでが if 文の処理ブロックなのか読み解くのが難しくなる
- 理解困難になるとデバッグに時間がかかる
- 仕様変更に時間がかかる
- 分岐ロジックを正確に理解できず、バグの原因となる

## 様々な弊害を招きやすいデータクラス

データクラスとは、設計が不十分なソフトウェアで頻繁に登場するクラス構造。単純な構造でありながら、様々な悪魔を招きやすく、開発者を苦しめる。

業務契約を扱うサービスを例にする。

```java
// 契約金額
public class ContractAmount {
    public int amountIncludingTax; // 税込み金額

    public BigDecimal salesTaxRate; // 消費税率
}
```

- 税込金額と消費税率を public なインスタンス変数として持っている
- 故に、自由にデータの出し入れが可能

このように、データを保持するだけのクラスを「**データクラス**」と呼ぶ。

業務契約を扱うには、税込金額を計算するロジックも必要になる。
この場合、計算ロジックはデータクラスと分離されることが多い。

```java
// 契約を管理するクラス
public class ContractManager {
    public ContractAmount contractAmount;

    // 税込み金額を計算する。
    public int calculateAmountIncludingTax(int amountExcludingTax, BigDecimal salesTaxRate) {
        BigDecimal multiplier = salesTaxRate.add(new BigDecimal("1.0"));
        BigDecimal amountIncludingTax = multiplier.multiply(new BigDecimal(amountExcludingTax));
        return amountIncludingTax.intValue();
    }

    // 契約締結する。
    public void conclude() {
        // 省略

        int amountIncludingTax = calculateAmountIncludingTax(amountExcludingTax, salesTaxRate);

        contractAmount = new ContractAmount();
        contractAmount.amountIncludingTax = amountIncludingTax;
        contractAmount.salesTaxRate = salesTaxRate;

        // 省略
    }
}
```

小規模なアプリであれば、特に問題はない。
しかし、大規模になるにつれ、この構造は様々な弊害を呼び寄せる。

### 仕様変更時に発生する弊害

消費税率ロジックが変更されたケースを考える。
下記のように税込金額を計算するロジックが複数存在したらどうなるか？
![](https://storage.googleapis.com/zenn-user-upload/943f3255aa20-20240915.png)
以下の問題が発生する。

- 変更箇所が多くなる
- 変更できていない箇所が存在し、バグになる

何故このようになるのか？
これは、データを保持するクラスと、データを使用して計算するロジックが離れているときに頻発する。
離れているが故に、計算ロジックが複数実装されても、認知が難しい。

このように、関連するデータやロジックが分散している状態を「**低擬集**」と呼ぶ。

### 低擬集によって発生する弊害

1. **重複コード**
   - 関連するコードが離れていると、把握が困難になる
   - 把握が困難になると、すでに実装済みの機能に気づかず、同じようなロジックを複数実装してしまう
2. **修正漏れ**
   - 重複コードが多く実装されると、仕様変更時にすべての重複コードを変更する必要がある
   - しかし、重複コードをすべて把握しないと修正漏れによりバグが生まれる
3. **可読性低下**
   - 「可読性」は、コードの意図や関係する処理の流れを、どれだけ素早く正確に読み解けるか？を表す指標
   - 関連するコードが分散すると、重複コードも含め、探し出すのに膨大な時間が必要
4. **未初期化状態（生焼けオブジェクト）**
   ```java
   ContractAmount amount = new ContractAmount();
   System.out.println(amount.salesTaxRate.toString());
   ```
   - 上記を実行すると、`NullPointerException` が発生する
   - `salesTaxRate` は初期化しない限り `null`
   - `ContractAmount` が初期化の必要なクラスであることを利用側が知らないとバグが生じる、不完全なクラス
   - このように、未初期化状態が発生するクラスはアンチパターンであり、「**生焼けオブジェクト**」と呼ぶ
5. **不正値の混入**
   「不正」とは、以下のような仕様として正しくない状態を指す。
   - 注文数がマイナス
   - ゲームにおいて、ヒットポイントの値が最大値を超えている
     データクラスは不正値を与えることが容易にできる。
   ```java
   ContractAmount amount = new ContractAmount();
   amount.salesTaxRate = new BigDecimal("-0.1");
   ```
   対策として、データクラスの利用側でバリデーションを実装することは良くある。
   しかし、このロジックも重複コードになる可能性がある。（バリデーションロジックの仕様変更もある...）

:::message
データクラスによる低擬集は多くの弊害を生み、**開発生産性が低下する**。
:::

## 弊害を招かないために

このような弊害を防ぐためにはどうすれば良いか？
それは、

- 悪しき構造の弊害を知ること
  - 知っていると、「何か対処しなければ」という意思が生まれる
- オブジェクト指向の基本であるクラスを適切に設計すること
