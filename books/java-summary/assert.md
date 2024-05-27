---
title: "assert"
---

## 概要

- Java プログラムにおいて開発者が仮定や前提条件を明示的に検証するためのツール
- `assert`文を使用することで、プログラムの実行中に特定の条件が真であることを確認できる
- 条件が偽である場合、`AssertionError`がスローされ、問題のある箇所を特定できる

## 目的

- デバッグとテストの段階でプログラムの動作を検証すること
- 開発者は仮定が正しいことを確認するために`assert`文を使用し、予期しない動作やバグを早期に発見できる

## 解決したい技術的課題

**問題点**:

- 複雑なロジックや前提条件を含むプログラムでは、特定の条件が常に満たされることを保証するのが難しい。
- 手動で条件をチェックすることは煩雑であり、ミスが発生しやすい。

**解決策**:

- `assert`文を使用して、プログラムの重要な仮定や前提条件が満たされることを自動的にチェックする。
- 条件が満たされない場合に即座に`AssertionError`をスローすることで、問題の原因を特定しやすくする。

## 使用方法

#### 基本的な`assert`文

```java
public class AssertExample {
    public static void main(String[] args) {
        int x = -1;
        assert x >= 0 : "x must be non-negative";
        System.out.println("x is " + x);
    }
}
```

この例では、`x`が 0 以上であることを仮定しています。もし`x`が負の値である場合、`AssertionError`がスローされ、エラーメッセージ「x must be non-negative」が表示される。

#### `assert`の有効化

デフォルトでは、Java の`assert`文は無効になっている。
`assert`文を有効にするには、実行時に`-ea`（または`-enableassertions`）オプションを使用する。

```sh
java -ea AssertExample
```

## ユースケース

1. **前提条件の検証**

   メソッドの引数や状態の前提条件を検証するために使用する。例えば、メソッドの引数が`null`でないことを確認する場合：

   ```java
   public void processData(String data) {
       assert data != null : "data must not be null";
       // ここに処理コード
   }
   ```

2. **ループの不変条件の検証**

   ループの各反復で不変条件が維持されることを確認する場合に使用する。

   ```java
   public void processArray(int[] array) {
       for (int i = 0; i < array.length; i++) {
           assert array[i] >= 0 : "Array elements must be non-negative";
           // ここに処理コード
       }
   }
   ```

3. **ステートマシンの状態検証**

   ステートマシンの特定の状態が正しいことを確認する場合に使用する。

   ```java
   enum State { START, PROCESSING, END }

   public void processState(State state) {
       switch (state) {
           case START:
               // 開始状態の処理
               break;
           case PROCESSING:
               // 処理中状態の処理
               break;
           case END:
               // 終了状態の処理
               break;
           default:
               assert false : "Unknown state: " + state;
       }
   }
   ```

## まとめ

- **目的**: `assert`を使用して、プログラムの仮定や前提条件を検証し、デバッグやテストの段階で問題を早期に発見する。
- **使用方法**: `assert`文を使用して条件を検証し、`-ea`オプションを用いて実行時に`assert`を有効化する。
- **ユースケース**:
  - 前提条件の検証
  - ループの不変条件の検証
  - ステートマシンの状態検証
