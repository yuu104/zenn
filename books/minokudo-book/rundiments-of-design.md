---
title: "設計の初歩"
---

「設計」とは何をすることなのか？を理解する。

## 命名は省略しない

どんなロジックなんだろう...?

```java
int d = 0;
d = p1 + p2;
d = d - ((d1 + d2) / 2);
if (d < 0) {
    d = 0;
}
```

上記はゲームダメージ計算ロジック。（何もわからん...）

名前を省略すると、読み解くのが難しくなる。
実装中は素早く実装できるかもしれないが、トータルで見ると効率が悪い。

意図が伝わる変数名に改善する。

```java
int damageAmount = 0;

damageAmount = playerArmPower + playerWeaponPower; // ①

damageAmount = damageAmount - ((enemyBodyDefence + enemyArmorDefence) / 2); // ②

if (damageAmount < 0) {
    damageAmount = 0;
}
```

:::message
命名をしっかり行うことは、変更に強いコードに繋がる立派な設計行為。
:::

## 変数を使いまわさず、目的ごとに用意する

下記コードには課題が存在する。

```java
int damageAmount = 0;

damageAmount = playerArmPower + playerWeaponPower; // プレーヤーの総攻撃力

damageAmount = damageAmount - ((enemyBodyDefence + enemyArmorDefence) / 2); // 敵のダメージ量

if (damageAmount < 0) {
    damageAmount = 0;
}
```

`damageAmount` に何度も代入処理がなされている。

再代入はコードの途中で変数の用途が変わってしまう。
よって、読み手が混乱し、バグを埋め込んでしまう可能性がある。

そのため、再代入で変数を使い回さず、目的ごとの変数を用意しよう。

```java
int totalPlayerAttackPower = playerArmPower + playerWeaponPower; // プレーヤーの総攻撃力

int totalEnemyDefence = enemyBodyDefence + enemyArmorDefence; // 敵の総防御力

int damageAmount = totalPlayerAttackPower - (totalEnemyDefence / 2); // 敵のダメージ量

if (damageAmount < 0) {
    damageAmount = 0;
}
```

## ベタ書きせず、意味のある単位でメソッド化

下記コードにはまだ、課題が存在する。

```java
int totalPlayerAttackPower = playerArmPower + playerWeaponPower; // プレーヤーの総攻撃力

int totalEnemyDefence = enemyBodyDefence + enemyArmorDefence; // 敵の総防御力

int damageAmount = totalPlayerAttackPower - (totalEnemyDefence / 2); // 敵のダメージ量

if (damageAmount < 0) {
    damageAmount = 0;
}
```

一連の処理がベタ書きされている。
このようにダラダラ書かれると、どこからどこまでが何の処理なのか分からなくなる。

より良いコードにするには、意味のあるまとまりでロジックをまとめ、メソッド（関数）として実装しよう。

```java
// プレイヤーの攻撃力を合算する
int sumUpPlayerAttackPower(int playerArmPower, int playerWeaponPower) {
    return playerArmPower + playerWeaponPower;
}

// 敵の防御力を合算する
int sumUpEnemyDefence(int enemyBodyDefence, int enemyArmorDefence) {
    return enemyBodyDefence + enemyArmorDefence;
}

// ダメージ量を評価する
int estimateDamage(int totalPlayerAttackPower, int totalEnemyDefence) {
    int damageAmount = totalPlayerAttackPower - (totalEnemyDefence / 2);
    if (damageAmount < 0) {
        return 0;
    }
    return damageAmount;
}
```

:::message
前者に比べ、コード量は多くなっているが、**可読性**が向上している。
:::

## 関係するデータとロジックをクラスにまとめる

ゲームを例にする。
戦闘を伴うゲームには、主人公の生命力を表すヒットポイント（HP）が存在する。

HP がローカル変数で定義されているとする。

```java
int hitPoint;
```

ダメージを受けて HP が減少するロジックが必要になる。

```java
hitPoint = hitPoint - damageAmount;
if (hitPoint < 0) {
    hitPoint = 0;
}
```

「回復アイテムなどで回復する仕様を追加したい」となった場合。

```java
hitPoint = hitPoint + recoveryAmount;
if (999 < hitPoint) {
    hitPoint = 999;
}
```

このような変数や変数を操作するロジックは、分散されがち。
これらは一つのクラスにまとめよう。

```java
// ヒットポイント(HP)を表現するクラス
class HitPoint {
    private static final int MIN = 0;
    private static final int MAX = 999;
    final int value;

    HitPoint(final int value) {
        if (value < MIN) throw new IllegalArgumentException(MIN + " 以上を指定してください");
        if (MAX < value) throw new IllegalArgumentException(MAX + " 以下を指定してください");

        this.value = value;
    }

    // ダメージを受ける
    HitPoint damage(final int damageAmount) {
        final int damaged = value - damageAmount;
        final int corrected = damaged < MIN ? MIN : damaged;
        return new HitPoint(corrected);
    }

    // 回復する
    HitPoint recover(final int recoveryAmount) {
        final int recovered = value + recoveryAmount;
        final int corrected = MAX < recovered ? MAX : recovered;
        return new HitPoint(corrected);
    }
}
```
