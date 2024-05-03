---
title: "Next.jsプロジェクトの始め方"
---

## create-next-app

以下のコマンドを実行し、プロジェクトの雛形を作成する。

```shell
npx create-next-app
```

すると、対話式のコンソールで、「どのようなプロジェクト構成にするか？」について複数質問される。

![](https://storage.googleapis.com/zenn-user-upload/c52171060963-20240503.png)

### 「プロジェクト名は何ですか？」

```shell
? What is your project named? > my-app
```

上記では `my-app` というプロジェクト名を指定している。

### 「TypeScript を使用しますか？」

```shell
? Would you like to use TypeScript with this project? > No / Yes
```

### 「ESLint を使用しますか？」

```shell
? Would you like to use ESLint with this project? > No / Yes
```

`Yes` を選択すると、`eslint-config-next` がインストールされる。
これは、Next.js が提供する API やコンポーネントを正しく使用できるようサポートするもので、おすすめの設定があらかじめ施されている。

### 「Tailwind CSS を使用しますか？」

```shell
? Would you like to use Tailwind CSS with this project? > No / Yes
```

### 「src ディレクトリを使用しますか？」

```shell
? Would you like to use src/directory with this project? > No / Yes
```

- `src` は青売りケーションコードの置き場所
- `Yes` にすると、`app` ディレクトリは `src/app` となる

### 「App Router を使用しますか？」

```shell
? Would you like to use App Router? (recomended) > No / Yes
```

「Pages Router」か「App Router」のどちらにするかという質問。

### 「デフォルトの import alias をカスタマイズしますか？」

```shell
? Would you like to customize the default import alias? (recomended) > No / Yes
```

- Next.js では、「`../`」で参照する相対パスだけでなく、Absokute パス（プロジェクトルートから見たパス）を「`@/*`」というパターンで import できる
- この「`@/*`」パターンを適用するか？という質問

```tsx
// before
import { Button } from "../../../components/button";

// after
import { Button } from "@/components/button";
```

## `nex dev` で開発モードのアプリケーションを起動する

```shell
npm run dev
```

- 「開発モード」の Next.js
- コードの変更が即座に反映される

## `next build` でアプリケーションをビルドする

```shell
npm run build
```

HTML、CSS、JS が最適化され、`.next` フォルダに出力される。

## `next start` でプロダクションモードのアプリケーションを起動する

```shell
npm run start
```

- ビルドしたアプリケーション（`.next` フォルダ）を起動する
- `next dev` と `next start` は別物
- プロダクションモードの場合、**修正内容は即座に反映されない**
- **プロダクションモードでなければ確認できない機能がある**

## `next lint` でコーディング規約への違反をチェックする

```shell
npm run lint
```

ESLint を実行する。
