---
title: "ナビゲーション"
---

## ナビゲーションの種類

### ハードナビゲーション

ブラウザが画面を際読み込みする画面遷移。

![](https://storage.googleapis.com/zenn-user-upload/9ccc9145edd0-20240503.png)

### ソフトナビゲーション

ブラウザが画面を際読み込みしない画面遷移。

![](https://storage.googleapis.com/zenn-user-upload/9741f97f5e05-20240503.png)

- Next.js が提供するのはこっち
- ブラウザは画面を際読み込みせず、必要な箇所だけを再レンダリングする
- ナビゲーション体験は高速で快適
- App Router では、変更された Route Segment のみが再レンダリングされる

## App Router におけるナビゲーションの優位性

- 一度ブラウザに確保した値を、画面がリロードされるまで保持する
  - ブラウザキャッシュってやつ
- データだけでなく、一度レンダリングした画面もキャッシュ可能

## `Link` コンポーネントによるナビゲーション

- `next/link` から import する
- `href` 属性にナビゲーション先の URL を指定する
- コンポーネントを使用すると、DOM 上では `<a>` が展開される
- クリックすると、ソフトナビゲーションが発生する

```tsx
import Link from "next/link";
import styles from "./style.module.css";

export function Nav() {
  return (
    <nav className={styles.nav}>
      <ul>
        <li>
          <Link href="/">トップ</Link>
        </li>
        <li>
          <Link href="/categories">カテゴリー一覧</Link>
        </li>
      </ul>
    </nav>
  );
}
```

## `useRouter` を使用したナビゲーション

- `<Link>` コンポーネントを使用せずにナビゲーションできる
