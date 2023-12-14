---
title: "dnd kit"
emoji: "👻"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, nextjs, typescript]
published: false
---

## dnd kit とは？

React 用の高度な D＆D ツールキット。
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

D&D によりメンバーが各グループ間を移動できるような UI を実装する。
![](https://storage.googleapis.com/zenn-user-upload/83cab4ed1cfa-20231214.gif)

### グループデータの用意

複数のグループが存在し、各グループには複数のメンバーが含まれている。

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

  // 省略
};
```

### D&D のためのパッケージをインストール

```shell
yarn add @dnd-kit/core
```

### DnDContext

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
   - オブジェクト形式は `{x: number, y: number, scaleX: number, scaleY: number}`
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
      {...attributes}
      {...listeners}
      style={style}
      className={styles.member}
    >
      {member.name}
    </div>
  );
};
```

### ドロップ可能なエリアの作成

`useDropable` を使用する。
このフックの返り値を使用することで、任意の要素をドロップ可能なエリアにする。
引数には `useDraggable` と同様、ユニークな `id` を指定する。
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

`onDragEnd` はユーザがドラッグした要素を離したときに呼び出される。
ドラッグ操作の最終的な結果を処理するために使用され、ドラッグされた要素の新しい位置や状態の更新などを行う。
`onDragEnd` に渡されるイベントオブジェクトには、ドラッグ操作に関する以下の情報が含まれている。

1. **`active`**
   - ドラッグされていた要素に関する情報
   - `active.id` は `useDraggable` で指定した `id`
2. **`over`**
   - ドロップされた要素に関する情報
   - `over.id` は `useDroppable` で指定した `id`
   - ドロップ可能領域でない場合、`over` は `null` になる

```diff tsx
+  import { DragEndEvent } from "@dnd-kit/core";

   export const DndKit = () => {
     // 省略

+    const handleDragEnd = (e: DragEndEvent) => {
+      const { active, over } = e;
+      if (!over) return;
+
+      const draggedId = active.id as string;
+      const droppedId = over.id as string;
+
+      setGroups((prev) => {
+        return prev.map((group) => {
+          const isDroppedSameGroup =
+            group.members.some((member) => member.name === draggedId) &&
+            droppedId === group.id;
+          if (isDroppedSameGroup) return group;
+
+          const newMembers = group.members.filter(
+            (member) => member.name !== draggedId
+          );
+
+          if (droppedId === group.id) newMembers.push({ name: draggedId });
+
+          return { ...group, members: newMembers };
+        });
+      });
+    };

    return (
      // 省略
    );
  };
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

![](https://storage.googleapis.com/zenn-user-upload/cda34286e53f-20231214.gif)

### 並び替えのためのパッケージをインストール

並び替えを行うには `@dnd-kit/core` に加えて `@dnd-kit/sortable` をインストールする。

```shell
yarn add @dnd-kit/sortable
```

### SortableContext

`DndContext` に加えて、`SortableContext` をセットアップする。
`SortableContext` は並び替え可能なアイテムの状態を管理し、ドラッグ操作に応じてアイテムの順序を更新するために使用する。
`SortableContext` は `DndContext` 内に設置する。

props は以下の通り。

1. **`items`**
   - 並び替えるアイテムの ID 配列を与える
   - 型は `string[] | { id: string }[]`
   - `string[]` の場合は各要素が 識別子となり、`{ id: string }[]` の場合は各要素の `id` プロパティが識別子となる
   - `items` に指定する識別子は後に使用する `useSortable` の引数に指定する `id` と一致させる必要がある
2. **`strategy`**（Optional）
   - アイテムを並び替える時のレイアウトと動作を定義する
   - D&D 操作におけるアイテムの移動方法を決定する
   - `rectSortingStrategy`: デフォルトの戦略。一般的なリストやグリッドに適している。仮想化リストには非対応。
   - `verticalListSortingStrategy`: 垂直リストに最適化。仮想化リストに対応。
   - `horizontalListSortingStrategy`: 水平リストに最適化。仮想化リストに対応。
   - `rectSwappingStrategy`: アイテムの位置を直接交換（スワップ）。特定のケースに適している。
3. **`id`**（Optional）
   - `id` の指定がない場合は自動生成される
   - この prop は高度なユースケースのためのもの

```tsx
+  import {
+    SortableContext,
+    horizontalListSortingStrategy,
+  } from "@dnd-kit/sortable";

   export const DndKit = () => {
     // 省略

     return (
       <DndContext onDragEnd={handleDragEnd}>
+        <SortableContext items={groups} strategy={horizontalListSortingStrategy}>
           <div className={styles.groupContainer}>
             {groups.map((group) => (
               <GroupItem key={group.id} group={group} />
             ))}
           </div>
+        </SortableContext>
       </DndContext>
     );
   };
```

### `GroupItem` コンポーネントを並び替え可能な要素に設定する

`useSortable` フックを使用する。
このフックの返り値を使用することで、任意の要素を並び替え可能にする。

- `setActivatorNodeRef`: ドラッグする際のつまみ部分の ref に指定する
- `attributes`, `listeners` もつまみ部分の要素に指定する
- `setNodeRef` は移動対象となる DOM に指定する

```diff tsx
  const GroupItem = ({ group }: GroupItemProps) => {
+   const {
+     attributes,
+     listeners,
+     setNodeRef: setSortableNodeRef,
+     setActivatorNodeRef,
+     transform,
+     transition,
+     isDragging,
+   } = useSortable({ id: group.id });

+   const style: CSSProperties = {
+     transform: CSS.Translate.toString(transform),
+     transition,
+   };

    // 省略

    return (
+     <div ref={setSortableNodeRef} style={style} className={styles.groupItem}>
+       <div
+         ref={setActivatorNodeRef}
+         {...attributes}
+         {...listeners}
+         style={{ cursor: isDragging ? "grabbing" : "grab" }}
+         className={styles.groupHead}
+       >
          {group.id}
        </div>
+       <div ref={setDroppableNodeRef} className={styles.groupBody}>
          {group.members.map((member) => (
            <MemberItem key={member.name} member={member} />
          ))}
        </div>
      </div>
    );
  };
```

### ドラッグ終了時のイベントハンドラを設定する

- `DndContext` の `onDragEnd` にロジックを記述する
- `handleDragEnd()` に追記する
- 関数内で、ドラッグ操作がメンバーの移動 or グループの並び替えかによって処理を分岐させる必要がある
- そのため、`active.id` と `over.id` でドラッグ操作がメンバーの移動 or グループの並び替えかを判断できるように工夫する
- `active.id` と `over.id` が `member_` で始まれば、メンバーの移動
- `group_` で始まれば、グループの並び替えとなるようにする

下記コンポーネントの `useDropppable` はメンバーの移動に使用するものなので、`id` を `member_${group.id}` に変更する。

```diff tsx
  const GroupItem = ({ group, isGroupDragging }: GroupItemProps) => {
    // 省略

    const { setNodeRef: setDroppableNodeRef } = useDroppable({
+     id: `member_${group.id}`,
      disabled: isGroupDragging,
    });

    return (
      // 省略
    );
  };
```

`handleDragEnd` は以下の通り。

```diff tsx
 const handleDragEnd = (e: DragEndEvent) => {
   const { active, over } = e;

   if (!over) return;

   const draggedId = active.id as string;
   const droppedId = over.id as string;

+  if (draggedId.startsWith("member_") && droppedId.startsWith("member_")) {
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
+  } else if (draggedId.startsWith("group_") && droppedId.startsWith("group_")) {
+    setGroups((prev) => {
+      const prevIndex = prev.findIndex((group) => group.id === draggedId);
+      const newIndex = prev.findIndex((group) => group.id === droppedId);
+
+      return arrayMove(prev, prevIndex, newIndex);
+    });
+  }
 };
```

:::details arrayMove

- 配列内の要素を新しい位置に移動するために使用されるユーティリティ関数

```ts
arrayMove(array: T[], from: number, to: number): T[]
```

- `array` : 並び替え対象の配列
- `from` : 対象アイテムアイテムのドラッグ開始時のインデックス
- `to` : 対象アイテムアイテムのドラッグ終了時のインデックス

:::

これで、グループの並び替えができるようになった。
と思いきや並び替え中にバグが...

## `useSortable` と `useDroppable` の競合

現状だと、グループのドラッグ中にバグが出る。

![](https://storage.googleapis.com/zenn-user-upload/33f8622e510e-20231214.gif)

`useSortable` が管理する要素のドラッグ操作中に、`useDroppable` で定義されたドロップ領域に入ると、バグが生じる。

### `useSortable` の仕組み

`useSortable` は、`useDraggable` と `useDroppable` を抽象化したフックで、これらを組み合わせて要素を並び替え可能にしている。

![](https://storage.googleapis.com/zenn-user-upload/a8255e54bfcc-20231214.webp)
_引用：https://docs.dndkit.com/presets/sortable_

### 原因

原因は、`GroupItem` コンポーネントにおいて、 `useSortable` と `useDroppable` のドロップ領域が競合していることにある。

```tsx
const GroupItem = ({ group }: GroupItemProps) => {
  const {
    attributes,
    listeners,
    setNodeRef: setSortableNodeRef,
    setActivatorNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: group.id });

  const { setNodeRef: setDroppableNodeRef } = useDroppable({
    id: `member_${group.id}`,
  });

  const style: CSSProperties = {
    transform: CSS.Translate.toString(transform),
    transition,
  };

  return (
    <div ref={setSortableNodeRef} style={style} className={styles.groupItem}>
      <div
        ref={setActivatorNodeRef}
        {...attributes}
        {...listeners}
        style={{ cursor: isDragging ? "grabbing" : "grab" }}
        className={styles.groupHead}
      >
        {group.id}
      </div>
      <div ref={setDroppableNodeRef} className={styles.groupBody}>
        {group.members.map((member) => (
          <MemberItem key={member.name} member={member} />
        ))}
      </div>
    </div>
  );
};
```

上記コードの場合、`GroupItem` コンポーネントは以下のようになっている。

![](https://storage.googleapis.com/zenn-user-upload/894fac85a585-20231214.png)

- `useSortable` が管理するドラッグ操作中に、`useDroppable({id: 'member_xxxx'})` で定義されたドロップ領域に入ると、衝突検出アルゴリズムが `useDroppable` の `{id: 'member_xxxx'}` を検出する
- `useDroppable({id: 'group_xxxx'})` と `useDroppable({id: 'member_xxxx'})` は領域が被る部分があるが、子要素である `id: 'member_xxxx'` が優先される
- これが、`useSortable` のドラッグ操作に影響を与える可能性がある
- `{id: 'member_xxxx'}` は `useSortable` で定義した `id` と一致するものが存在しないため、ソート処理を行えない

### 解決策

**グループの並び替え中は `useDroppable` を無効にする**

- `useDroppable` の引数には `disabled` が存在する
- `disabled` に `true` を指定することで、競合していたドロップ領域を無効にする

複数ある `useSortable` のどれかがドラッグ状態になったとき、全ての `useDroppable` を無効にしたいので、ステートによる管理を行う。

```diff tsx
  export const DndKit = () => {
    // 省略

+   const [isGroupDragging, setIsGroupDragging] = useState(false);

+   const handleDragStart = (e: DragStartEvent) => {
+     const { active } = e;
+     const draggedId = active.id as string;

+     if (draggedId.startsWith("group_")) setIsGroupDragging(true);
+   };

    const handleDragEnd = (e: DragEndEvent) => {
+     setIsGroupDragging(false);

      // 省略
    };

    return (
+     <DndContext onDragStart={handleDragStart} onDragEnd={handleDragEnd}>
        <SortableContext items={groups} strategy={horizontalListSortingStrategy}>
          <div className={styles.groupContainer}>
            {groups.map((group) => (
              <GroupItem
                key={group.id}
                group={group}
+               isGroupDragging={isGroupDragging}
              />
            ))}
          </div>
        </SortableContext>
      </DndContext>
    );
  };

　type GroupItemProps = {
　  group: Group;
+  isGroupDragging: boolean;
　};

+ const GroupItem = ({ group, isGroupDragging }: GroupItemProps) => {
　  // 省略

　  const { setNodeRef: setDroppableNodeRef } = useDroppable({
　    id: `member_${group.id}`,
+    disabled: isGroupDragging,
　  });

　  // 省略
　};
```

これでバグが消える。

![](https://storage.googleapis.com/zenn-user-upload/4669a01a7bab-20231214.gif)

## 参考リンク

https://docs.dndkit.com/

https://zenn.dev/castingone_dev/articles/dndkit20231031

https://zenn.dev/kodaishoituki/articles/0e1c6109ae838e#sortablecontext

https://zenn.dev/wintyo/articles/d39841c63cc9c9
