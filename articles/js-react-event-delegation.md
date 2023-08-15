---
title: "React・JavaScriptのevent delegationについて今更ながらに理解したのでまとめる"
emoji: "😸"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [javascript, react, dom]
published: false
---

## これは何？

React でポップアップの UI 実装を行った際、event delegation の理解が足りておらず、苦戦しました。
これを機に、改めて React・JavaScript の event delegation について学習したので、備忘録としてまとめます。

## ポップアップ UI の実装

![](https://storage.googleapis.com/zenn-user-upload/c37bd65587e2-20230815.gif)

```tsx
import React, { useCallback, useEffect, useRef, useState } from "react";
import "./styles.css";

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

export const App = () => {
  const [isOpen, setIsOpen] = useState(false);

  const handleOpenModal = (
    e: React.MouseEvent<HTMLButtonElement, MouseEvent>
  ) => {
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

## ざっくり用語解説

### イベントハンドラ

特定のイベントが発生した際に実行される関数。
ユーザーのアクション（クリック、キーボード入力、マウスの移動など）や、データの変更などのトリガーに対して、処理を実行するために使用する。

### イベントリスナ

イベントリスナとほぼ同じ。
::: details 違い

- イベントリスナは同じイベントに対して複数登録できる
- イベント
  :::

### イベントハンドリング

イベントが発生した際に対応する。
