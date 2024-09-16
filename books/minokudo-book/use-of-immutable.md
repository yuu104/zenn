---
title: "不変の活用"
---

**可変（ミュータブル）** : 「変数の値を変更する」など、状態変更できること
**不変（イミュータブル）** : 状態変更できないこと

可変と不変を適切に設計しないと、挙動の予測が困難になり、混乱する。
変更を最小限にする設計が重要であり、「不変」が大きな役割を果たす。

## 再代入

変数に再度値を代入すること。「**破壊的代入**」とも呼ぶ。
変数の意味が変化し、推測を困難にする。いつ変更されたのかを追うのが難しくなる。

以下はゲームのダメージ計算の例。

```java
int damage() {
    // メンバーの腕力と武器性能が基本攻撃力
    int tmp = member.power() + member.weaponAttack();

    // メンバーのスピードで攻撃力を補正
    tmp = (int)(tmp * (1f + member.speed() / 100f));

    // 攻撃力から敵の防御力を差し引いたのがダメージ
    tmp = tmp - (int)(enemy.defence() / 2);

    // ダメージ値が負数にならないよう補正
    tmp = Math.max(0, tmp);

    return tmp;
}
```

ローカル変数 `tmp` が使い回されている。
`tmp` は 基本攻撃力 → 補正値 → ダメージ値 ... と、代入される値の意味が変化している。

途中で変数の意味が変化すると読み手が混乱する。
よって、`tmp` はイミュータブルにし、再代入を避けるべき。
別の変数を用意することで再代入を防ぐ。

### イミュータブルにして再代入を防ぐ

変数に `final` を付ける。

```diff java
  int damage() {
      // メンバーの腕力と武器性能が基本攻撃力
-     int tmp = member.power() + member.weaponAttack();
+     final int basicAttackPower = member.power() + member.weaponAttack();

      // メンバーのスピードで攻撃力を補正
-     tmp = (int)(tmp * (1f + member.speed() / 100f));
+     final int finalAttackPower = (int)(basicAttackPower * (1f + member.speed() / 100f));

      // 攻撃力から敵の防御力を差し引いたのがダメージ
-     tmp = tmp - (int)(enemy.defence() / 2);
+     final int reduction = (int)(enemy.defence() / 2);

      // ダメージ値が負数にならないよう補正
-     tmp = Math.max(0, tmp);
+     final int damage = Math.max(0, finalAttackPower - reduction);

      return damage;
  }
```

各変数が何を表しているのかが明確になり、処理フローも追いやすくなった。

### 引数も不変にする

```java
void addPrice(int productPrice) {
    productPrice = totalPrice + productPrice;

    if (MAX_TOTAL_PRICE < productPrice) {
        throw new IllegalArgumentException("購入金額の上限を超えています。");
    }
}
```

引数がミュータブルだと、様々な弊害が発生する。

- 予期せぬ副作用
- デバッグの難しさ
- コードの理解困難

```diff java
- void addPrice(int productPrice) {
+ void addPrice(final int productPrice) {
-     productPrice = totalPrice + productPrice;
+     final int increasedTotalPrice = totalPrice + productPrice;

-     if (MAX_TOTAL_PRICE < productPrice) {
+     if (MAX_TOTAL_PRICE < increasedTotalPrice) {
          throw new IllegalArgumentException("購入金額の上限を超えています。");
      }
}
```

## ミュータブルがもたらす弊害

具体的にどのような弊害が生じるのか？

### 可変インスタンスの使い回し

ゲームを例に説明する。

`AttackPower` は武器の攻撃力を表す。
`value` には攻撃力の値が入る。

```java
class AttackPower {
    static final int MIN = 0;
    int value;  // final が付いてないので可変

    AttackPower(int value) {
        if (value < MIN) {
            throw new IllegalArgumentException();
        }

        this.value = value;
    }
}
```

`Weapon` は武器を表現し、 `AttackPower` をインスタンス変数として持つ。

```java
class Weapon {
  final AttackPower attackPower;

  Weapon(AttackPower attackPower) {
    this.attackPower = attackPower;
  }
}
```

最初の仕様は、武器ごとの攻撃力は固定。
攻撃力が同じ場合、AttackPower のインスタンスを使いまわしているケースがあった。

```java
AttackPower attackPower = new AttackPower(20);

Weapon weaponA = new Weapon(attackPower);
Weapon weaponB = new Weapon(attackPower);
```

上記では、`weaponeA` のみ攻撃力を変更することができない。

## 副作用のデメリット

「**副作用**」とは、関数が引数を受け取り、戻り値を返す以外に、外部の状態を変更すること。

関数（メソッド）には、主作用と副作用が存在する。

- **主作用** : 関数が引数を受け取り、値を返すこと
- **副作用** : 主作用以外に状態変更すること

「状態変更」とは、以下のような関数の外にある状態の変更。

- インスタンス変数の変更
- グローバル変数の変更
- 引数の変更
- ファイルの読み書きなどの I/O 操作

副作用を防ぐには、関数が与える影響を限定することが重要。
以下の項目を満たすように関数を設計する。

- **データ（状態）を引数で受け取る**
- **状態を変更しない**
- **値は関数の戻り値として返す**

`AttackPower` を例にすると、以下のようになる。

```java
class AttackPower {
    static final int MIN = 0;
    final int value; // final で不変にする

    AttackPower(final int value) {
        if (value < MIN) {
            throw new IllegalArgumentException();
        }
        this.value = value;
    }

    /**
     * 攻撃力を強化する
     * @param increment 攻撃力の増分
     * @return 強化された攻撃力
     */
    AttackPower reinForce(final AttackPower increment) {
        return new AttackPower(this.value + increment.value);
    }

    /**
     * 無力化する
     * @return 無力化された攻撃力
     */
    AttackPower disable() {
        return new AttackPower(MIN);
    }
}
```

`reinForce` と `disable` は攻撃力を変化させるメソッドであるが、副作用を防ぐための条件を満たして実装されている。

`Weapon` は以下のようになる。

```java
class Weapon {
    final AttackPower attackPower;

    Weapon(final AttackPower attackPower) {
        this.attackPower = attackPower;
    }

    /**
     * 武器を強化する
     * @param increment 攻撃力の増分
     * @return 強化した武器
     */
    Weapon reinForce(final AttackPower increment) {
        final AttackPower reinForced = attackPower.reinForce(increment);
        return new Weapon(reinForced);
    }
}
```

## 不変と可変の使い分け方針

### デフォルトは不変に

以下のメリットから、基本はイミュータブルにすべき。

- 変数の意味が変化しなくなり、混乱が抑えられる
- 挙動が安定し、結果を予想しやすくなる
- コードの影響範囲が限定的になり、保守が容易になる

### どんな時に可変にしてよいか？

1. **パフォーマンスに問題が生じるケース。**
   - 大量データの高速処理や画像処理、リソース制約の厳しい組み込みソフトウェアなどで可変が必要なことがある
   - イミュータブルの場合、値の変更にはインスタンスの生成が必要
   - 値の変更が膨大に発生する場合、やインスタンス生成に時間がかかる場合はパフォーマンス要件を満たせない場合がある
2. **スコープが局所的なケース**
   - ループカウンタなど
   - 狭いスコープでしか使用されないことが確実な変数であれば、許容される
