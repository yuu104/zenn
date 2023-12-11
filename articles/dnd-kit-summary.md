---
title: "dnd kit まとめ"
emoji: "👻"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: []
published: false
---

## dnd kit とは？

React 用の高度なドラッグ＆ドロップツールキット。
dnd kit には複数のパッケージが含まれている。

1. **`@dnd-kit/core`**
   - dnd kit の核となるパッケージ
   - D&D の基本機能を提供する
   - ドラッグ可能な要素とドロップ可能なエリアを定義するための API を提供し、D&D イベントのハンドリングをサポートする
2. **`@dnd-kit/sortable`**
   - リストやグリッド内の要素を並べ替えるための機能を提供する
3. **`@dnd-kit/modifiers`**
   - ドラッグ操作中に特定の制約や挙動を追加するためのモディファイアを提供する
   - 以下のような用途に使用する
     - 単一軸に沿った動きを制限する
     - ドラッグ可能なノードコンテナの境界矩形内での動きを制限する
     - ドラッグ可能なノードのスクロールコンテナの境界矩形内での動きを制限する
     - 移動に抵抗を加えたり、移動を制限（クランプ）する
4. **`@dnd-kit/accessibility`**
   - ドラッグアンドドロップの操作をアクセシブル（障害を持つユーザーにも使いやすい）にするための機能を提供する
   - キーボード操作のサポートやスクリーンリーダーの対応などが含まれる

## クイックスタート

### インストール

```shell
yarn add @dnd-kit/core
```

### コンテキストプロバイダ

D&D 機能を実装するために、まず `DndContext` をセットアップする。
これは、D＆D イベントの管理や状態の保持を行う。
各種操作対象はこの `DndContext` の配下にある必要がある。

```tsx
App.jsx;
import React from "react";
import { DndContext } from "@dnd-kit/core";

function App() {
  return <DndContext>{/* ドラッグ＆ドロップ要素をここに配置 */}</DndContext>;
}
```

### ドラッグ可能な要素の作成

ドラッグ可能な要素を作成するには、`useDraggable` フックを使用する。

```tsx
import { useDraggable } from "@dnd-kit/core";

function DraggableItem({ id, children }) {
  const { attributes, listeners, setNodeRef } = useDraggable({ id });

  return (
    <div ref={setNodeRef} {...listeners} {...attributes}>
      {children}
    </div>
  );
}
```

#### `id`

- ドラッグ可能な要素を一意に識別するもの
- 従って、`useDraggable()` ごとに異なる `id` を指定する必要がある

#### `attributes`

- ドラッグ可能な要素に割り当てるべき HTML 属性を含むオブジェクト
- アクセシビリティ（アクセスしやすさ）や HTML 標準に準拠した属性が含まれる
- 例えば、`role` や `aria-*` 属性など

#### `listeners`

- ドラッグ可能な要素に対する様々なイベントリスナーを含むオブジェクト
- マウスやタッチイベントに反応するためのハンドラが含まれる
- 例えば、`onMouseDown`, `onTouchStart` など

#### `setNodeRef`

- DOM ノードへの参照を dnd-kit に提供するための関数
- dnd-kit がドラッグ操作中の要素の位置やサイズを正確に計算するために必要
- ref 属性を用いて要素にこの関数を割り当てることで、dnd-kit が必要な DOM 情報を取得できるようになる

### ドロップ可能なエリアの作成
