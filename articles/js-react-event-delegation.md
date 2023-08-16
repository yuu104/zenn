---
title: "React・JavaScriptのEvent Delegationについて今更ながらに理解したのでまとめる"
emoji: "😸"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [javascript, react, dom]
published: false
---

## これは何？

React でポップアップの UI 実装を行った際、event delegation の理解が足りておらず、苦戦しました。
これを機に、改めて React・JavaScript の event delegation について学習したので、備忘録としてまとめます。

## ポップアップ UI の実装デモ

ポップアップ UI の仕様は以下の通りです。

- `open` ボタンをクリックすると、ポップアップが開く
- 開いている状態でポップアップの範囲外（`open` ボタンを含む）をクリックすると、ポップアップが閉じる
- ポップアップ内の `close` ボタンをクリックすると、ポップアップが閉じる

@[codesandbox](https://codesandbox.io/embed/react-v17wei-man-niokeruibentoderigesiyonnojian-zheng-q93pw8?fontsize=14&hidenavigation=1&theme=dark)

実装コードについて解説します。
まずは `App` コンポーネントです。

```tsx
export const App = () => {
  const [isOpen, setIsOpen] = useState(false);

  const handleOpenModal = () => {
    setIsOpen(true);
  };

  const handleCloseModal = useCallback(() => {
    setIsOpen(false);
  }, []);

  return (
    <div className="App">
      <h1>Hello</h1>
      <button onClick={handleOpenModal}>open</button>

      {isOpen && <Popup handleCloseModal={handleCloseModal} />}
    </div>
  );
};
```

ポップアップの表示・非表示の状態を `useState` で管理しています。
また、ステートを更新するハンドラー関数もここで定義しています。

次に、`Popuup` コンポーネントです。

```tsx
type PopupProps = {
  handleCloseModal: () => void;
};

const Popup = ({ handleCloseModal }: PopupProps) => {
  const modalContentsRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickDocument = (e: MouseEvent) => {
      e.preventDefault();
      if (!modalContentsRef.current?.contains(e.target as any)) {
        handleCloseModal();
      }
    };

    document.addEventListener("click", handleClickDocument);

    return () => document.removeEventListener("click", handleClickDocument);
  }, [handleCloseModal]);

  return (
    <div className="contents" ref={modalContentsRef}>
      <button onClick={handleCloseModal}>閉じる</button>
    </div>
  );
};
```

このコンポーネントは、Props として ポップアップを非表示にする関数を受け取ります。
`modalContentsRef` にポップアップを表示する DOM への参照を保存しています。
`useEffect` 内で `document` にポップアップを閉じるためのイベントリスナーを設定しています。

上記の実装では、**React17 未満**だと正常に動作します。
しかし、**React17 以降**だと正常に動作しません。

その原因は、React17 未満と以降で event delegation（イベント移譲）の変更が行われたことにあります。

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

Event Delegation を理解する前に、イベント伝播について知る必要があるので解説します。

イベント伝播とは、任意の要素でイベントが発生すると、イベントがその要素自身だけでなく、祖先要素や子孫要素にも伝わっていく仕組みのことです。

イベント伝播によって、任意のボタンをクリックしたときに、そのボタンが含まれる要素やさらに上位の要素もクリックされたことと同様の処理をすることができます。
これには、イベントが発生することで複数の要素を一度に制御することができるというメリットがあります。

例えば、下記の `<li>` タグ全てに対しクリックイベントを検知したい場合、全てにイベントリスナを設定するのは大変です。

```tsx
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

### イベント伝播の流れ

イベント伝播には 3 つのフェーズが存在し、以下の順を辿ります。

1. キャプチャリングフェーズ
2. ターゲットフェーズ
3. バブリングフェーズ
