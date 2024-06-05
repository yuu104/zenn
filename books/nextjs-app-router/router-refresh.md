---
title: "router.refresh() が何をしているのか理解する"
---

## 公式によると...

https://arc.net/l/quote/jxtudbaj

> `router.refresh()`: 現在のルートを更新します。サーバーに新しいリクエストを行い、データリクエストを再取得し、Server Component を再レンダリングします。クライアントは、更新された React Server Component のペイロードを、影響を受けないクライアント側の React（useState など）やブラウザの状態（スクロール位置など）を保持したままマージします。

上記内容を箇条書きでまとめると以下の通りになります。

- 現在のルートを更新する
- サーバーに新しいリクエストを行う
- Server Component を再レンダリングする
- クライアントは、サーバーから受け取った新たな RSC ペイロードを、クライアント側の React（useState など）やブラウザの状態（スクロール位置など）を保持したままマージする

## どういうこと？

箇条書きでまとめた項目を一つずつ見ていきます。

### 現在のルートを更新する

`router.refresh()` を実行した Root Segment（ページ）を更新するという意味です。
しかし後述によると、「更新」と言ってもページ全体を 0 から再構築しているわけではいようです。
つまり、単純にページをリロードしている（`window.location.reload()` を実行している）わけではないということです。
それではこの「更新」とは一体何をしているのでしょうか？

### サーバーに新しいリクエストを行う

「新たにサーバーリクエストする」という観点だと `window.location.reload()` と同じですね。
`router.refresh()` は何をリクエストしているのでしょうか？

### Server Component を再レンダリングする

どうやら Server Component を再レンダリングし、RSC ペイロードを生成しているようです。
「Server Component を**再レンダリング**する」とありますが、これはサーバー側で再度 RSC ペイロードを生成し直しているだけです。

### クライアントは、サーバーから受け取った新たな RSC ペイロードを、クライアント側の React（useState など）やブラウザの状態（スクロール位置など）を保持したままマージする

こちらはどういうことでしょうか？
再生成した RSC を用いてクライアント側で再描画することは分かります。しかし、「クライアント側の React やブラウザの状態を保持したままマージする」というのは本当なのでしょうか？
こちらを確認するために、ToDo アプリを作成して検証してみます。

## ToDo アプリを実装して `router.refresh()` の理解を深める

以下のような Client Component（CC）と Server Component（SC）が混在する画面を実装します。

![](https://storage.googleapis.com/zenn-user-upload/08b39516d96e-20240603.png)

### 実装概要

- Next.js サーバー：`localhost:3000`
- API サーバ：`localhost:3001`

:::details ルートコンポーネント

```tsx: page.tsx
import { AddTaskForm } from "@/components/AddTaskForm";
import { TaskList } from "@/components/TaskList";

export default function Home() {
  return (
    <div className="flex flex-col h-screen bg-gray-100 dark:bg-gray-900">
      <header className="bg-white dark:bg-gray-800 shadow py-4 px-6">
        <h1 className="text-2xl font-bold text-gray-800 dark:text-gray-200">
          TODO App
        </h1>
      </header>
      <div className="flex-1 p-6 space-y-4">
        <AddTaskForm />
        <div className="bg-white dark:bg-gray-800 rounded-md shadow p-4 space-y-2">
          <TaskList />
        </div>
      </div>
    </div>
  );
}

```

:::

:::details タスク追加フォーム（AddTaskForm）

`<form>` を使用していますが、今回は `router.refresh()` の検証を行いたいので、データ追加処理に Server Actions は利用しません。

```tsx: AddTaskForm.tsx
"use client";

import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { useState } from "react";
import { Task } from "@/types/task";
import { v4 as uuidV4 } from "uuid";

export function AddTaskForm() {
  const [title, setTitle] = useState("");

  const handleSubmit = async () => {
    const body: Task = { id: uuidV4(), title, isCompleted: false };
    await fetch("http://localhost:3001/tasks", {
      method: "POST",
      body: JSON.stringify(body),
    });
  };

  return (
    <form className="flex items-center space-x-4" onSubmit={handleSubmit}>
      <Input
        type="text"
        placeholder="Add a new task..."
        className="flex-1 bg-white dark:bg-gray-800 dark:text-gray-200 rounded-md py-2 px-4 focus:outline-none focus:ring-2 focus:ring-blue-500"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
      />
      <Button
        type="submit"
        className="bg-blue-500 hover:bg-blue-600 text-white rounded-md py-2 px-4"
      >
        Add
      </Button>
    </form>
  );
}
```

:::

:::details タスク一覧（TaskList）

今回は `router.refresh()` の動作検証に集中したいので Data Cash と Full Route Cache はオプトアウトしています。

```tsx: TaskList.tsx
import { Task } from "@/types/task";
import { TaskItem } from "./TaskItem";

const getTodos = async (): Promise<Task[]> => {
  const res = await fetch("http://localhost:3001/tasks", {
    cache: "no-store",
  });
  const data = await res.json();
  return data;
};

export async function TaskList() {
  const tasks = await getTodos();

  return (
    <div>
      {tasks.map((task) => (
        <TaskItem key={task.id} task={task} />
      ))}
    </div>
  );
}
```

:::

:::details タスクアイテム（TaskItem）

```tsx: TaskItem.tsx
"use client";

import { useState } from "react";
import { Task } from "@/types/task";
import { Input } from "@/components/ui/input";
import { Checkbox } from "@/components/ui/checkbox";
import { EditButton } from "@/components/EditButton";
import { DeleteButton } from "@/components/DeleteButton";
import { SaveButton } from "@/components/SaveButton";

type Props = {
  task: Task;
};

export function TaskItem({ task }: Props) {
  const [isEditingTitle, setIsEditingTitle] = useState(false);
  const [editedTitle, setEditedTitle] = useState(task.title);

  const handleDoneTask = async () => {
    const body: Task = { ...task, isCompleted: !task.isCompleted };
    fetch(`http://localhost:3001/tasks/${task.id}`, {
      method: "PUT",
      body: JSON.stringify(body),
    });
  };

  const handleEditButtonClock = () => {
    setIsEditingTitle(true);
  };

  const handleSaveTitle = async () => {
    setIsEditingTitle(false);
    if (task.title === editedTitle) return;
    const body: Task = { ...task, title: editedTitle };
    await fetch(`http://localhost:3001/tasks/${task.id}`, {
      method: "PUT",
      body: JSON.stringify(body),
    });
  };

  const handleDeleteTask = async () => {
    await fetch(`http://localhost:3001/tasks/${task.id}`, {
      method: "DELETE",
    });
  };

  return (
    <div className="flex items-center space-x-4">
      <Checkbox
        id={`task-${task.id}`}
        checked={task.isCompleted}
        onChange={handleDoneTask}
      />
      {isEditingTitle ? (
        <Input
          type="text"
          className="flex-1 bg-white dark:bg-gray-800 dark:text-gray-200 rounded-md py-2 px-4 focus:outline-none focus:ring-2 focus:ring-blue-500"
          value={editedTitle}
          onChange={(e) => setEditedTitle(e.target.value)}
        />
      ) : (
        <label
          htmlFor={`task-${task.id}`}
          className={`flex-1 text-gray-800 dark:text-gray-200 ${
            task.isCompleted ? "line-through" : ""
          }`}
        >
          {task.title}
        </label>
      )}
      {isEditingTitle ? (
        <SaveButton handleClick={handleSaveTitle} />
      ) : (
        <EditButton handleClick={handleEditButtonClock} />
      )}
      <DeleteButton handleClick={handleDeleteTask} />
    </div>
  );
}

```

:::

タスクの追加・編集・削除操作を行い、`router.refresh()` がどのように動作するのかを確認します。

### `router.refresh()` しないとどうなるのか？

上記の実装には `router.refresh()` を記述していません。
この場合どのような動作になるのか確認してみます。

:::details タスクを追加する

```tsx: AddTaskForm.tsx

// 省略

const [title, setTitle] = useState("");

const handleSubmit = async (e: FormEvent) => {
  e.preventDefault();
  const body: Task = { id: uuidV4(), title, isCompleted: false };
  await fetch("http://localhost:3001/tasks", {
    method: "POST",
    body: JSON.stringify(body),
  });
  setTitle("");
};


// 省略
```

![](https://storage.googleapis.com/zenn-user-upload/0ff4e48a7a69-20240603.gif)

追加したデータが画面に反映されていません。

:::

:::details タスクを完了/未完了にする

```tsx: TaskItem.tsx
// 省略

const handleToggleDoneTask = async () => {
  const body: Task = { ...task, isCompleted: !task.isCompleted };
  await fetch(`http://localhost:3001/tasks/${task.id}`, {
    method: "PUT",
    body: JSON.stringify(body),
  });
};

// 省略
```

![](https://storage.googleapis.com/zenn-user-upload/95252324dfb5-20240603.gif)

完了/未完了の更新処理が画面に反映されていません。

:::

:::details タスクのタイトルを更新する

```tsx: TaskItem:tsx
// 省略

const [isEditingTitle, setIsEditingTitle] = useState(false);
const [editedTitle, setEditedTitle] = useState(task.title);

const handleEditButtonClick = () => {
  setIsEditingTitle(true);
};

const handleSaveTitle = async () => {
  setIsEditingTitle(false);
  if (task.title === editedTitle) return;
  const body: Task = { ...task, title: editedTitle };
  await fetch(`http://localhost:3001/tasks/${task.id}`, {
    method: "PUT",
    body: JSON.stringify(body),
  });
};

// 省略
```

![](https://storage.googleapis.com/zenn-user-upload/a33843c9576f-20240603.gif)

タイトルの更新が画面に反映されていません。

:::

:::details タスクを削除する

```tsx: TaskItem.tsx
// 省略

const handleDeleteTask = async () => {
  await fetch(`http://localhost:3001/tasks/${task.id}`, {
    method: "DELETE",
  });
};

// 省略
```

![](https://storage.googleapis.com/zenn-user-upload/6849751de9d7-20240603.gif)

タスクの削除が画面に反映されていません。

:::

データの追加・更新処理が成功し、DB にも正しく登録されていますが、画面には反映されていません。
その理由はミューテーションを行っていないからです。更新系 API をクライアント側でコールした後、更新後のデータを再取得する必要があります。
ただ、タスクのデータを取得し `TaskItem` コンポーネントに props 経由で渡している `TaskList` コンポーネントは SC です。

:::details TaskList コンポーネントのコードを確認する

```tsx: TaskList.tsx
import { Task } from "@/types/task";
import { TaskItem } from "./TaskItem";

const getTodos = async (): Promise<Task[]> => {
  const res = await fetch("http://localhost:3001/tasks", {
    cache: "no-store",
  });
  const data = await res.json();
  return data;
};

export async function TaskList() {
  const tasks = await getTodos();

  return (
    <div>
      {tasks.map((task) => (
        <TaskItem key={task.id} task={task} />
      ))}
    </div>
  );
}
```

:::

よって、再度 `TaskList` コンポーネント上でデータを取得し、レンダリングをする必要があり、そのためには更新系 API をコールした後、新規の SC をリクエストしなければなりません。
それを可能にするのが `router.refresh()` です。

### `router.refresh()` で SC を再レンダリングする

公式による説明は以下でした。

- 現在のルートを更新する
- サーバーに新しいリクエストを行う
- Server Component を再レンダリングする
- クライアントは、サーバーから受け取った新たな RSC ペイロードを、クライアント側の React（useState など）やブラウザの状態（スクロール位置など）を保持したままマージする

更新系 API をコールした後に `router.refresh()` を実行することで、更新後のデータが反映された SC をサーバーにリクエストしてくれます。リクエストを受け取ったサーバーは SC を再レンダリングし、RSC ペイロードを生成してクライアントにレスポンスします。

では、先ほどの API コール後に `router.refresh()` を追記します。

:::details タスクを追加する

```diff tsx: AddTaskForm.tsx
+ import { useRouter } from "next/navigation";

  // 省略

+ const router = useRouter();
  const [title, setTitle] = useState("");

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    const body: Task = { id: uuidV4(), title, isCompleted: false };
    await fetch("http://localhost:3001/tasks", {
      method: "POST",
      body: JSON.stringify(body),
    });
    setTitle("");
+   router.refresh();
  };

  // 省略
```

![](https://storage.googleapis.com/zenn-user-upload/8589975c45b4-20240604.gif)

追加したデータが画面に反映されました！

:::

:::details タスクを完了/未完了にする

```diff tsx: TaskItem.tsx
+ import { useRouter } from "next/navigation";

  // 省略

+ const router = useRouter();

  const handleToggleDoneTask = async () => {
    const body: Task = { ...task, isCompleted: !task.isCompleted };
    fetch(`http://localhost:3001/tasks/${task.id}`, {
      method: "PUT",
      body: JSON.stringify(body),
    });
+   router.refresh();
  };

  // 省略
```

![](https://storage.googleapis.com/zenn-user-upload/10a6ac7d5963-20240604.gif)

完了/未完了の更新処理が画面に反映されました！

:::

:::details タスクのタイトルを更新する

```diff tsx: TaskItem:tsx
+ import { useRouter } from "next/navigation";

  // 省略

+ const router = useRouter();
  const [isEditingTitle, setIsEditingTitle] = useState(false);
  const [editedTitle, setEditedTitle] = useState(task.title);

  const handleEditButtonClick = () => {
    setIsEditingTitle(true);
  };

  const handleSaveTitle = async () => {
    setIsEditingTitle(false);
    if (task.title === editedTitle) return;
    const body: Task = { ...task, title: editedTitle };
    await fetch(`http://localhost:3001/tasks/${task.id}`, {
      method: "PUT",
      body: JSON.stringify(body),
    });
+   router.refresh();
  };

  // 省略
```

![](https://storage.googleapis.com/zenn-user-upload/beba8b1ae22e-20240604.gif)

タイトルの更新が画面に反映されました！

:::

:::details タスクを削除する

```diff tsx: TaskItem.tsx
+ import { useRouter } from "next/navigation";

  // 省略

+ const router = useRouter();

  const handleDeleteTask = async () => {
    await fetch(`http://localhost:3001/tasks/${task.id}`, {
      method: "DELETE",
    });
+   router.refresh();
  };

  // 省略
```

![](https://storage.googleapis.com/zenn-user-upload/71c20a7b522e-20240604.gif)

タスクの削除が画面に反映されました！

:::

`router.refresh()` により SC が再レンダリングし、更新後のデータを反映した RSC ペイロードがレスポンスされていることが確認できました。

### クライアントの状態（`useState`）が保持されていることを確認する

> クライアントは、更新された React Server Component のペイロードを、影響を受けないクライアント側の React（useState など）やブラウザの状態（スクロール位置など）を保持したままマージします。

こちらを検証します。

任意タスクのタイトルを編集中にした状態で、新たに別のタスクを作成します。

![](https://storage.googleapis.com/zenn-user-upload/b66efd4307c4-20240604.gif)

CC である `TaskItem` で定義した `isEditingTitle` の状態を `true` に変更しています。
その後、タスク追加の API コールを行い `router.refresh()` で SC をリクエストし、その結果を基にクライアント側で再描画しています。
再描画後の `isEditingTitle` は `true` のままです。ブラウザの状態が保持されたまま SC の変更がマージされています。

よって、`router.refresh()` は単に現在のルートをリロード（`window.location.reload`）しているわけではないことが確認できました。CC の状態を保持した状態で SC をリクエストし、その結果をマージしているのだと思います。

## `router.refresh()` は Router Cache をパージする

クライアント側でキャッシュされる[Router Cache](https://ja.next-community-docs.dev/docs/app-router/building-your-application/caching#router-cache)内のすべてのルートがパージされます。

https://ja.next-community-docs.dev/docs/app-router/building-your-application/caching/#%E3%82%AD%E3%83%A3%E3%83%83%E3%82%B7%E3%83%A5%E3%82%92%E7%84%A1%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B-1

## Server Actions を使う場合は `revalidatePath()`, `revalidateTag()` を使う

クライアント側で更新系 API をコールする場合は `router.refresh()` を使用すれば良いですが、Server Actions でデータ更新を行う場合は使用できません。何故なら、Server Actions の関数はサーバー側で実行されるためです。`router.refresh()` はクライアント側でのみ実行可能です。

:::details revalidatePath() でタスク追加処理を実装する

```diff tsx: actions/taskActions.tsx
+ "use server";
+
+ import { Task } from "@/types/task";
+ import { revalidatePath } from "next/cache";
+
+ export const addTask = async (body: Task) => {
+   "use server";
+
+   await fetch("http://localhost:3001/tasks", {
+     method: "POST",
+     body: JSON.stringify(body),
+   });
+
+   revalidatePath("/");
+ };
```

```diff tsx:TaskItem.tsx
  "use client";

  // 省略
- import { useRouter } from "next/navigation";
+ import { addTask } from "@/actions/taskActions";

  // 省略
- const router = useRouter();
const [title, setTitle] = useState("");

- const handleSubmit = async (e: FormEvent) => {
-   e.preventDefault();
-   const body: Task = { id: uuidV4(), title, isCompleted: false };
-   await fetch("http://localhost:3001/tasks", {
-     method: "POST",
-     body: JSON.stringify(body),
-   });
-   setTitle("");
-   router.refresh();
- };

+ const handleSubmit = async () => {
+   const body: Task = { id: uuidV4(), title, isCompleted: false };
+   addTask(body);
+   setTitle("");
+ };

  return (
-   <form className="flex items-center space-x-4" onSubmit={handleSubmit}>
+   <form className="flex items-center space-x-4" action={handleSubmit}>
      // 省略
    </form>
  );
}


```

:::

:::details revalidateTag() でタスク追加処理を実装する

```diff tsx: TaskList.tsx
  // 省略

  const getTodos = async (): Promise<Task[]> => {
    const res = await fetch("http://localhost:3001/tasks", {
      cache: "no-store",
+     next: { tags: ["tasks"] },
    });
    const data = await res.json();
    return data;
  };

  // 省略
```

```diff tsx: actions/taskActions.tsx
+ "use server";
+
+ import { Task } from "@/types/task";
+ import { revalidateTag } from "next/cache";
+
+ export const addTask = async (body: Task) => {
+   "use server";
+
+   await fetch("http://localhost:3001/tasks", {
+     method: "POST",
+     body: JSON.stringify(body),
+   });
+
+   revalidateTag("tasks");
+ };
```

```diff tsx:TaskItem.tsx
  "use client";

  // 省略
- import { useRouter } from "next/navigation";
+ import { addTask } from "@/actions/taskActions";

  // 省略
- const router = useRouter();
const [title, setTitle] = useState("");

- const handleSubmit = async (e: FormEvent) => {
-   e.preventDefault();
-   const body: Task = { id: uuidV4(), title, isCompleted: false };
-   await fetch("http://localhost:3001/tasks", {
-     method: "POST",
-     body: JSON.stringify(body),
-   });
-   setTitle("");
-   router.refresh();
- };

+ const handleSubmit = async () => {
+   const body: Task = { id: uuidV4(), title, isCompleted: false };
+   addTask(body);
+   setTitle("");
+ };

  return (
-   <form className="flex items-center space-x-4" onSubmit={handleSubmit}>
+   <form className="flex items-center space-x-4" action={handleSubmit}>
      // 省略
    </form>
  );
}


```

:::

`revalidatePath()`、`revalidateTag()` は `router.refresh()` と同様、Router Cache をパージします。

## 疑問点

`router.refresh()`、`revalidatePath()`、`revalidateTag()` を使用することで CC の状態を保持しつつ SC を更新できることが確認できました。
しかし、ここで一つ疑問点があります。
それは、「**SC 再レンダリング中のローディング制御をどのようにすれば良いのか？**」です。

タスク一覧取得に時間がかかる場合を考えます。

:::details TaskList.tsx を変更

```diff tsx: TaskList.tsx
  import { Task } from "@/types/task";
  import { TaskItem } from "./TaskItem";

  const getTodos = async (): Promise<Task[]> => {
    const res = await fetch("http://localhost:3001/tasks", {
      cache: "no-store",
      next: { tags: ["tasks"] },
    });
    const data = await res.json();

+   await new Promise((resolve) => {
+     setTimeout(() => {
+       resolve(null);
+     }, 3000);
+   });

    return data;
  };

  export async function TaskList() {
    const tasks = await getTodos();

    return (
      <div>
        {tasks.map((task) => (
          <TaskItem key={task.id} task={task} />
        ))}
      </div>
    );
  }
```

:::

![](https://storage.googleapis.com/zenn-user-upload/5ce85b37f8e8-20240605.gif)

`TaskList` コンポーネントを `<Suspence>` で囲っているため、データ取得と SC のレンダリングが完了するまではローディング UI が表示されます。

では、この状態でタスクを追加してみます。

![](https://storage.googleapis.com/zenn-user-upload/3756646e301c-20240605.gif)

SC の再レンダリングに時間がかかるため、画面が更新されるまで時間がかかります。
この待機時間でローディング UI を表示したいのですが、その方法が不明です。

## 参考リンク

https://ja.next-community-docs.dev/docs/app-router/api-reference/functions/use-router

https://github.com/vercel/next.js/discussions/54075

https://www.reddit.com/r/nextjs/comments/1bsf1js/how_is_revalidatepath_and_routerrefresh_different/

https://github.com/vercel/next.js/discussions/58520
