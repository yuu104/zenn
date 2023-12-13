---
title: "【dnd kit】"
emoji: "👻"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, nextjs, typescript]
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

## D&D を実装してみる

まずは、以下のようにメンバーを D&D により各グループ間を移動できるような UI を実装してみる。

### グループデータの用意

今回の例では、複数のグループが存在し、各グループには複数のメンバーが含まれている。

```tsx
type Group = {
  id: string;
  members: Member[];
};

type Member = {
  name: string;
};

export const DndKit = () => {
  const [groups, setGroups] = useState<Group[]>([
    { id: "group_1", members: [{ name: "member_1" }, { name: "member_2" }] },
    { id: "group_2", members: [{ name: "member_3" }] },
    { id: "group_3", members: [{ name: "member_4" }, { name: "member_5" }] },
  ]);

  // その他のコード...
};
```

### D&D のためのパッケージをインストール

```shell
yarn add @dnd-kit/core
```

### `DnDContext`

D&D 機能を実装するために、まず `DndContext` をセットアップする。
これは、D＆D イベントの管理や状態の保持を行う。
この中にドラッグ可能およびドロップ可能な要素を配置することで、D＆D のインタラクションが有効になる。

```tsx
import { DndContext } from "@dnd-kit/core";

function DndKit() {
  return <DndContext>{/* ドラッグ＆ドロップ要素をここに配置 */}</DndContext>;
}
```

### ドラッグ可能な要素の作成

`useDraggable` フックを使用する。
このフックの返り値を使用することで、任意の要素をドラッグ可能にする。
引数にはドロップ可能なエリアをユニークに識別するための `id`（`number` or `strign`）を渡す。

主要な返り値は以下の通り。

1. **`setNodeRef`**
   - ドラッグアイテムの DOM ノードへの参照を設定するための関数
   - ドラッグさせたい要素の `ref` に指定する
2. **`listeners`**
   - ドラッグ操作を開始、進行、終了するためのイベントリスナーを含むオブジェクト
3. **`attributes`**
   - ドラッグ可能な要素に適用される HTML 属性を含むオブジェクト
4. **`transform`**
   - ドラッグ操作中の要素の位置変化を表すオブジェクト
   - アイテムがドラッグされ始めると、アイテムを画面上で移動させるために必要な座標が入力される
   - `transform` オブジェクト形式は `{x: number, y: number, scaleX: number, scaleY: number}`
   - `transform` を使用することにより、ドラッグ中の要素のスタイルを動的に更新する
5. **`isDragging`**
   - アイテムがドラッグ中であるかのフラグ
   - ドラッグ中であれば `true`、そうでなければ `false`

```tsx
type MemberItemProps = {
  member: Member;
};

const MemberItem = ({ member }: MemberItemProps) => {
  const { attributes, listeners, setNodeRef, transform, isDragging } =
    useDraggable({
      id: member.name,
    });

  const style: CSSProperties = {
    // `@dnd-kit/utilities`の`CSS`を使用すると、より簡潔に記述できる
    // transform: CSS.Translate.toString(transform),
    transform: transform
      ? `translate3d(${transform.x}px, ${transform.y}px, 0)`
      : undefined,
    cursor: isDragging ? "grabbing" : "grab",
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      className={styles.member}
      {...attributes}
      {...listeners}
    >
      {member.name}
    </div>
  );
};
```

### ドロップ可能なエリアの作成

`useDropable` を使用する。
このフックの返り値を使用することで、任意の要素をドロップ可能なエリアにする。
引数には、`useDraggable` と同様、ユニークな `id` を指定する。
返り値で `setNodeRef` を受け取り、ドロップ可能要素の `ref` に指定する。

```tsx
type GroupItemProps = {
  group: Group;
};

const GroupItem = ({ group }: GroupItemProps) => {
  const { setNodeRef } = useDroppable({
    id: group.id,
  });

  return (
    <div className={styles.groupItem}>
      <div className={styles.groupHead}>{group.id}</div>
      <div ref={setNodeRef} className={styles.groupBody}>
        {group.members.map((member) => (
          <MemberItem key={member.name} member={member} />
        ))}
      </div>
    </div>
  );
};
```

### ドラッグ終了時のイベントハンドラを設定する

`onDragEnd` はユーザがユーザーがドラッグした要素を離したときに呼び出される。
ドラッグ操作の最終的な結果を処理するために使用され、ドラッグされた要素の新しい位置や状態の更新などを行う。
`onDragEnd` に渡されるイベントオブジェクトには、ドラッグ操作に関する以下の情報が含まれている。

1. **`active`**
   - ドラッグされていた要素に関する情報
   - `active.id` は `useDraggable` で指定したもの
2. **`over`**
   - ドロップされた要素に関する情報
   - `over.id` は `useDroppable` で指定したもの
   - ドロップ可能領域でない場合、`over` は `null` になる

```tsx
import { DragEndEvent } from "@dnd-kit/core";

const handleDragEnd = (e: DragEndEvent) => {
  const { active, over } = e;
  if (!over) return;

  const draggedId = active.id as string;
  const droppedId = over.id as string;

  setGroups((prev) => {
    return prev.map((group) => {
      const isDroppedSameGroup =
        group.members.some((member) => member.name === draggedId) &&
        droppedId === group.id;
      if (isDroppedSameGroup) return group;

      const newMembers = group.members.filter(
        (member) => member.name !== draggedId
      );

      if (droppedId === group.id) newMembers.push({ name: draggedId });

      return { ...group, members: newMembers };
    });
  });
};

return (
  <DndContext onDragEnd={handleDragEnd}>
    {/* ドラッグ＆ドロップ要素をここに配置 */}
  </DndContext>
);
```

### D&D まとめ

1. D&D する領域を `DnDContext` で囲む
2. ドラッグしたい要素をコンポーネント化し、`useDraggable` を使用する
3. ドロップしたい要素をコンポーネント化し、`useDroppable` を使用する

最終的なコードは以下の通り。

```tsx
import {
  DndContext,
  DragEndEvent,
  useDraggable,
  useDroppable,
} from "@dnd-kit/core";
import { CSSProperties, useState } from "react";
import styles from "@/styles/DndKit.module.scss";
import { CSS } from "@dnd-kit/utilities";

type Group = {
  id: string;
  members: Member[];
};

type Member = {
  name: string;
};

export const DndKit = () => {
  const [groups, setGroups] = useState<Group[]>([
    { id: "group_1", members: [{ name: "member_1" }, { name: "member_2" }] },
    { id: "group_2", members: [{ name: "member_3" }] },
    { id: "group_3", members: [{ name: "member_4" }, { name: "member_5" }] },
  ]);

  const handleDragEnd = (e: DragEndEvent) => {
    const { active, over } = e;
    if (!over) return;

    const draggedId = active.id as string;
    const droppedId = over.id as string;

    setGroups((prev) => {
      return prev.map((group) => {
        const isDroppedSameGroup =
          group.members.some((member) => member.name === draggedId) &&
          droppedId === group.id;
        if (isDroppedSameGroup) return group;

        const newMembers = group.members.filter(
          (member) => member.name !== draggedId
        );

        if (droppedId === group.id) newMembers.push({ name: draggedId });

        return { ...group, members: newMembers };
      });
    });
  };

  return (
    <DndContext onDragEnd={handleDragEnd}>
      <div className={styles.groupContainer}>
        {groups.map((group) => (
          <GroupItem key={group.id} group={group} />
        ))}
      </div>
    </DndContext>
  );
};

type GroupItemProps = {
  group: Group;
};

const GroupItem = ({ group }: GroupItemProps) => {
  const { setNodeRef } = useDroppable({
    id: group.id,
  });

  return (
    <div className={styles.groupItem}>
      <div className={styles.groupHead}>{group.id}</div>
      <div ref={setNodeRef} className={styles.groupBody}>
        {group.members.map((member) => (
          <MemberItem key={member.name} member={member} />
        ))}
      </div>
    </div>
  );
};

type MemberItemProps = {
  member: Member;
};

const MemberItem = ({ member }: MemberItemProps) => {
  const { attributes, listeners, setNodeRef, transform, isDragging } =
    useDraggable({
      id: member.name,
    });

  const style: CSSProperties = {
    transform: CSS.Translate.toString(transform),
    cursor: isDragging ? "grabbing" : "grab",
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      className={styles.member}
      {...attributes}
      {...listeners}
    >
      {member.name}
    </div>
  );
};
```

## グループを並び替えできるようにする

次はグループを D&D 操作で並び替えできるようにする。

### 並び替えのためのパッケージをインストール

並び替えを行うには `@dnd-kit/core` に加えて `@dnd-kit/sortable` をインストールする。

```shell
yarn add @dnd-kit/sortable
```

### `SortableContext`

`DndContext` に加えて、`SortableContext` をセットアップする。
`SortableContext` は並び替え可能なアイテムの状態を管理し、ドラッグ操作に応じてアイテムの順序を更新するために使用する。
`SortableContext` は `DndContext` 内に設置する。

`SortableContext` の Props は以下の通り。

1. **`items`**
   - 並び替えるアイテムの ID 配列を与える
   - 型は `string[] | { id: string }[]`
   - `string[]` の場合は各要素が 識別子となり、`{ id: string }[]` の場合は各要素の `id` プロパティが識別子となる
   - `items` に指定する識別子は後に使用する `useSortable` の引数に指定する `id` と一致させる必要がある
2. **`strategy`**（Optional）
   - アイテムを並び替える時のレイアウト戦略を定義する
3. **`id`**（Optional）

```tsx
export const DndKit = () => {
  // ロジック

  return (
    <DndContext onDragEnd={handleDragEnd}>
      <SortableContext items={groups} strategy={horizontalListSortingStrategy}>
        <div className={styles.groupContainer}>
          {groups.map((group) => (
            <GroupItem
              key={group.id}
              group={group}
              isGroupDragging={isGroupDragging}
            />
          ))}
        </div>
      </SortableContext>
    </DndContext>
  );
};
```
