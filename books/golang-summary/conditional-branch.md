---
title: "条件分岐"
---

## if 文

```go
i := 0

if i < 0 {
  fmt.Println("iは0未満")
} else {
  fmt.Println("iは0以上")
}
```

- `if` は、条件式の前に簡単なステートメントを記述できる
- ステートメントは、`if` のスコープ内だけで有効（`else` ブロック内でも使用可能）

```go
if v:= 0; v < 0 {
  fmt.Println("iは0未満")
} else {
  fmt.Println("iは0以上")
}
```

## switch 文

Go の`switch`ステートメントは、異なる条件に基づいてプログラムの制御フローを切り替えるために使用されるコントロールフローステートメントです。`switch`ステートメントは他のプログラミング言語で見られる`switch`ステートメントと似ていますが、Go の`switch`にはいくつかの独自の特徴があります。

基本的な`switch`の構文は次の通りです:

```go
switch expression {
case value1:
    // expressionがvalue1と等しい場合の処理
case value2:
    // expressionがvalue2と等しい場合の処理
case value3:
    // expressionがvalue3と等しい場合の処理
default:
    // どのケースにも一致しない場合の処理
}
```

`expression`は比較対象の式で、`value1`、`value2`、`value3`などのケースは、`expression`と比較されます。最初に一致したケースの中のコードブロックが実行されます。`default`節はどのケースにも一致しない場合に実行されますが、省略することもできます。

以下はいくつかの`switch`の特徴です:

1. **Fallthrough (フォールスルー)**:

   - Go の`switch`ステートメントは通常、一致したケースのコードを実行し、それ以降のケースは評価しません
   - ただし、`fallthrough`キーワードを使用することで、次のケースに進むことができます
   - これは通常の振る舞いから外れた場合にのみ使用すべきです

   ```go
   switch value {
   case 1:
       fmt.Println("One")
       fallthrough
   case 2:
       fmt.Println("Two")
   }
   ```

2. **複数の条件の一致**:

   - Go の`switch`ステートメントは、複数の値を一度に比較することができます

   ```go
   switch value {
   case 1, 2, 3:
       fmt.Println("One, Two, or Three")
   }
   ```

3. **型アサーション**:

   - `switch`ステートメントは型アサーションと組み合わせて、インターフェース型の値を特定の具体的な型にキャストできます

   ```go
   switch v := someInterface.(type) {
   case int:
       fmt.Println("It's an int:", v)
   case string:
       fmt.Println("It's a string:", v)
   default:
       fmt.Println("It's something else")
   }
   ```

4. **式を持たない`switch`**:

   - `switch`ステートメントは式を持たない形式もサポートしており、これは`if-else if-else`構造と同様に使用できます。

   ```go
   switch {
   case condition1:
       // 条件1が真の場合の処理
   case condition2:
       // 条件2が真の場合の処理
   default:
       // どの条件にも一致しない場合の処理
   }
   ```
