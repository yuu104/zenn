---
title: "React・JavaScriptのイベント伝播について今更ながらに理解したのでまとめる"
emoji: "😸"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [javascript, typescript, react, フロントエンド]
published: false
---

## これは何？

React で UI ロジックの実装を行なっていた際、イベント伝播の理解が足りておらず苦戦しました。
これを機に、改めて React・JavaScript のイベント伝播や Event Delegation について学習したので備忘録としてまとめます。

## ざっくり用語解説

### イベント

マウスクリック、ボタン押下、キー入力など、システムの中で生じた動作や出来事。

### イベントハンドラ

特定のイベントの発生を受け取り、それに対する処理を行う関数のこと。
ユーザーのアクション（クリック、キーボード入力、マウスの移動など）や、データの変更などのトリガーに対して、処理を実行するために使用する。

### イベントリスナ

イベントハンドラとほぼ同じ。
イベントを監視し、イベントが発生した際に呼び出す関数のこと。
DOM 操作でよくやる `addEventListener()` のこと。

::: details イベントハンドラとの違い

- イベントリスナは同じイベントに対して複数登録できる
- イベントハンドラは複数登録出来ない

:::

### イベントハンドリング

イベントに対して、適切な処理や反応を提供するプロセスのこと。

## イベント伝播（Event Propagation）

イベント伝播は、イベント周りの制御を適切に行うための重要な概念です。

イベント伝播とは、任意の要素でイベントが発生すると、イベントがその要素自身だけでなく、祖先要素や子孫要素にも伝わっていく仕組みのことです。

イベント伝播によって、任意のボタンをクリックしたときに、そのボタンが含まれる要素やさらに上位の要素もクリックされたことと同様の処理をすることができます。

例えば、下記の `<li>` タグ全てに対しクリックイベントを検知したい場合、全てにイベントリスナを設定するのは大変です。

```html
<ul>
  <li>1つ目のliタグです。</li>
  <li>2つ目のliタグです。</li>
  <li>3つ目のliタグです。</li>
  <li>4つ目のliタグです。</li>
  <li>5つ目のliタグです。</li>
  <li>6つ目のliタグです。</li>
</ul>
```

ですが、イベント伝播を利用することにより、親要素の `<ul>` タグ一つにイベントリスナを追加するだけで、子要素である `<li>` タグのクリックイベントを検知することができます。
`<ul>` タグに対し、イベントリスナを設定し、クリックイベントを検知すると、

- クリックした要素（例えば 3 番目の `<li>` タグをクリックした場合）は `e.target`
- イベントリスナを設定した要素（`<ul>` タグ）は `e.currentTarget`

で取得することができます。

このように、複数の要素に同じイベントハンドラを設定せずに、共通の親要素に 1 つのイベントリスナ・イベントハンドラを設定し、子要素で発生するイベントを捕捉する方法を**Event Delegation**と呼びます。

### イベント伝播の流れ

イベント伝播には 3 つのフェーズが存在し、以下の順を辿ります。

1. キャプチャリングフェーズ
2. ターゲットフェーズ
3. バブリングフェーズ

これらのフェーズを、先ほどのリスト要素のコードを例に解説します。

### キャプチャリングフェーズ

キャプチャリングフェーズはイベント伝播の最初のフェーズです。
ルート要素から対象要素に向かってイベントが伝播し、それぞれの要素にイベントリスナ・イベントハンドラが登録されているかどうかを調べます。
そして、登録されているものがあれば関数を実行します。

```html
<ul>
  <li>1つ目のliタグです。</li>
  <li>2つ目のliタグです。</li>
  <li>3つ目のliタグです。</li>
  <li>4つ目のliタグです。</li>
  <li>5つ目のliタグです。</li>
  <li>6つ目のliタグです。</li>
</ul>
```

上記の `<li>` タグをクリックした場合、キャプチャリングフェーズでは以下の順でイベントが伝播します。
![](https://storage.googleapis.com/zenn-user-upload/5fc89260d1e9-20230817.png =150x)
キャプチャリングフェーズでの伝播時に実行する関数を登録するには、`addEventListener()` メソッドの第三引数に `true` （または `{capture: true}`）を指定します。
また、React を使用している場合はイベントハンドラの指定に `onClickCapture` や `onChangeCapture` のように、後ろに `Capture` を付けることで、キャプチャリングフェーズでの登録を行うことができます。

### ターゲットフェーズ

イベントが対象要素に到達したフェーズです。
ターゲットフェーズでは、対象要素自体に設定されたイベントリスナ・イベントハンドラが実行されます。
このフェーズでのベントの発生対象は、`event.target` を通じで取得できます。

先ほどの例で言うと、キャプチャリングフェーズによる伝播が `<li>` タグに伝わったときのことを指します。

キャプチャリングフェーズから発生源であるターゲットフェーズまでイベントが伝播すると、次はバブリングフェーズに移ります。

### バブリングフェーズ

イベントが対象要素からルート要素に向かって伝播するフェーズです。
キャプチャリングフェーズの説明と同様、`<li>` タグをクリックした場合、バブリングフェーズでは以下の順でイベントが伝播します。
![](https://storage.googleapis.com/zenn-user-upload/fcc2f7020cdf-20230817.png =150x)
`addEventListener()` や　 React の `onClick`, `onChange` などで設定するイベントリスナ・イベントハンドラは、バブリングフェーズで発火します。

イベント伝播は通常、キャプチャリングフェーズから始まり、ターゲットフェーズを経てバブリングフェーズへと進行します。

### コードを書いて検証してみる

イベント伝播の各フェーズの流れを把握するために、以下のコードでコンソール出力を確認してみます。

```html
<body>
  <ul id="ul">
    <li>1つ目のliタグです。</li>
    <li>2つ目のliタグです。</li>
    <li id="li">3つ目のliタグです。</li>
    <li>4つ目のliタグです。</li>
    <li>5つ目のliタグです。</li>
    <li>6つ目のliタグです。</li>
  </ul>

  <script type="text/javascript">
    const ul = document.getElementById("ul");
    const li = document.getElementById("li");

    ul.addEventListener("click", () => console.log("ul バブリング"));
    li.addEventListener("click", () => console.log("li バブリング"));

    ul.addEventListener(
      "click",
      () => console.log("ul キャプチャリング"),
      true
    );
    li.addEventListener(
      "click",
      () => console.log("li キャプチャリング"),
      true
    );
  </script>
</body>
```

出力結果からも分かる通り、キャプチャリングフェーズ -> ターゲットフェーズ -> バブリングフェーズ の順に登録したイベントリスナが発火しています。

```shell
ul キャプチャリング
li キャプチャリング
li バブリング
ul バブリング
```

React のコードでも確認してみます。

```tsx
export default function App() {
  return (
    <ul
      onClick={() => console.log("ul バブリング")}
      onClickCapture={() => console.log("ul キャプチャリング")}
    >
      <li>1つ目のliタグです。</li>
      <li>2つ目のliタグです。</li>
      <li
        onClick={() => console.log("li バブリング")}
        onClickCapture={() => console.log("li キャプチャリング")}
      >
        3つ目のliタグです。
      </li>
      <li>4つ目のliタグです。</li>
      <li>5つ目のliタグです。</li>
      <li>6つ目のliタグです。</li>
    </ul>
  );
}
```

```shell
ul キャプチャリング
li キャプチャリング
li バブリング
ul バブリング
```

## Event Delegation（イベント移譲）

イベント伝播のところでも書きましたが、改めて解説します。

Event Delegation とは、複数の要素に同じイベントハンドラを設定せずに、共通の親要素に 1 つのイベントリスナ・イベントハンドラを設定し、子要素で発生するイベントを捕捉する方法のことです。
これはイベント伝播の仕組みを利用して実現することができます。

Event Delegation の何が嬉しいのでしょうか？
例えば、6 つの `<li>` タグのいずれかがクリックされたことを検知する場合、単純に実装したら以下のように一つずつ `onclick` 属性を付与します。

```html
<ul>
  <li onclick="console.log('item1')">1つ目のliタグです。</li>
  <li onclick="console.log('item2')">2つ目のliタグです。</li>
  <li onclick="console.log('item3')">3つ目のliタグです。</li>
  <li onclick="console.log('item4')">4つ目のliタグです。</li>
  <li onclick="console.log('item5')">5つ目のliタグです。</li>
  <li onclick="console.log('item6')">6つ目のliタグです。</li>
</ul>
```

しかし、まったく同じ処理を都度設定するのは手間です。
そこで、Event Delegation により全ての `<li>` タグに `onclick` 属性を割り当てるのではなく、`<ul>` でイベントをキャッチして関数を実行するように設定します。

```html
<body>
  <ul id="ul">
    <li id="item1">1つ目のliタグです。</li>
    <li id="item2">2つ目のliタグです。</li>
    <li id="item3">3つ目のliタグです。</li>
    <li id="item4">4つ目のliタグです。</li>
    <li id="item5">5つ目のliタグです。</li>
    <li id="item6">6つ目のliタグです。</li>
  </ul>

  <script type="text/javascript">
    document
      .getElementById("ul")
      .addEventListener("click", (e) => console.log(e.target.id));
  </script>
</body>
```

これにより、`<li>` タグに都度イベントハンドラを設定する必要がなくなりました。

## React におけるイベントハンドラ登録の仕組み

React では、`onClick` などで各要素に対してイベントリスナを設定することができますが、実際はその対象の要素にイベントハンドラを設定しているわけではありません。
対象要素ではなく別の場所にイベントハンドラを設定し、Event Delegation により イベントの発火を検知しています。

それではどこでイベントハンドラを設定しているのでしょうか？
それは React v17 未満と React v17 以降で異なります。
![](https://storage.googleapis.com/zenn-user-upload/2b3bb10ef9b2-20230818.png)
_公式ブログから引用_

上記の画像からも分かる通り、React v16 までは document オブジェクトで全てのイベントをハンドリングしていました。
しかし、React v17 からは `ReactDOM.render()` の第二引数で指定した要素上でイベントをハンドリングします。

React におけるイベント伝播・Event Delegation の詳しい挙動については、下記リンクがとても参考になります。
https://qiita.com/kyntk/items/b273760c6d27e08bf53a#%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88%E3%83%87%E3%83%AA%E3%82%B2%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6

## 参考リンク

https://ja.legacy.reactjs.org/blog/2020/10/20/react-v17.html
https://qiita.com/sho_U/items/b11916cece5658ddf2e9#%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88%E3%83%90%E3%83%96%E3%83%AA%E3%83%B3%E3%82%B0%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6
https://devsakaso.com/javascript-event-propagation/
