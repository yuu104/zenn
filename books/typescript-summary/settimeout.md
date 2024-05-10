---
title: "setTimeout"
---

## 第一引数に指定する関数に任意の引数を渡す方法

1. **アロー関数を使用する**: アロー関数を使って、必要な引数を関数内で直接使用する

   ```javascript
   setTimeout(() => {
     myFunction(arg1, arg2);
   }, 1000);
   ```

2. **匿名関数を使用する**: 似た方法で、匿名関数を使って関数を呼び出す

   ```javascript
   setTimeout(function () {
     myFunction(arg1, arg2);
   }, 1000);
   ```

3. **`setTimeout`の追加引数を使用する**: `setTimeout`は第三引数以降に任意の引数を取ることができ、これらは第一引数の関数に渡される
   ```javascript
   setTimeout(myFunction, 1000, arg1, arg2);
   ```

## タイマー ID と`clearTimeout`

JavaScript の`setTimeout`関数は指定された時間後に特定の関数を実行するために使われる。この関数は実行がスケジュールされた後、タイマー ID を返す。このタイマー ID はそのタイマーを識別するためのユニークな識別子であり、実行されるまでの間に`clearTimeout`関数を使ってタイマーをキャンセルする際に必要となる。

### `setTimeout`の実行開始

`setTimeout`を呼び出すと、指定した関数はすぐにスケジュールされ、指定時間後に自動的に実行される。タイマー ID を変数に格納することは、このプロセスを変えるものではなく、単に後でこのタイマーを参照またはキャンセルするための手段を提供するだけである。

```javascript
// 3秒後にメッセージを表示するタイマー
const messageTimer = setTimeout(() => {
  console.log("タイマーが完了しました。");
}, 3000);
```

### `clearTimeout`の使用シナリオ

`clearTimeout`の主な使用目的は、すでにスケジュールされているタイマーをキャンセルすることである。以下のシナリオで特に有用である。

1. **ユーザーアクションに基づくキャンセル**:
   ユーザーが何かしらのアクションを取った結果、予定されていた動作が不要になった場合、`clearTimeout`を使用してタイマーをキャンセルする。

   ```javascript
   // ユーザーがキャンセルボタンをクリックした場合にタイマーをキャンセル
   document.getElementById("cancelButton").addEventListener("click", () => {
     clearTimeout(messageTimer);
     console.log("タイマーがキャンセルされました。");
   });
   ```

2. **条件付きの実行キャンセル**:
   システムの状況が変わり、予定されていたタイマーがもはや必要ではなくなった場合、`clearTimeout`を使用して不要な処理を防ぐ。

   ```javascript
   // データのロードが完了したらタイマーをキャンセル
   fetchData()
     .then((data) => {
       clearTimeout(messageTimer);
       console.log(
         "データが正常にロードされたため、タイマーはキャンセルされました。"
       );
     })
     .catch((error) => {
       console.error("データのロードに失敗しました。");
     });
   ```

3. **パフォーマンス最適化**:
   不要なタイマーがシステムリソースを消費するのを防ぐため、`clearTimeout`で不要なタイマーをキャンセルする。

このように、`setTimeout`と`clearTimeout`はプログラムの流れを制御し、効率を向上させるために重要な役割を果たす。
