---
title: "React Hook Formとバリデーション"
emoji: "📘"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, reacthookform, typescript, zod, yup]
published: false
---

## React Hook Form とは？

- React でのフォーム実装を行うための、高性能で柔軟かつ拡張可能な使いやすいライブラリ
- フォーム入力値の状態管理を自前で行う必要がないので楽
  - 通常は `useState` や `useRef` を使用して入力値の値を管理する
  - React Hook Form では、`ref` による入力を裏側でやってくれる
- 入力値のバリデーションは React Hook Form 自身も備えているが、zod や yup などのバリデーションライブラリを用いることが多い

以下のログインフォームの実装を例に解説する。

![](https://storage.googleapis.com/zenn-user-upload/5302f8dce410-20231115.png)

## React Hook Form を使用しない場合

React Hook Form などのフォームバリデーションライブラリを使用しない場合、`useState()` や `useRef()` を使用して入力値の管理を行う。

### `useState()` を使用した場合

```tsx
import { useState } from "react";
import styles from "@/styles/App.module.scss";

function App() {
  const [email, setEmail] = useState<string>("");
  const [password, setPassword] = useState<string>("");

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    console.log({
      email,
      password,
    });
  };

  const handleChangeEmail = (e: React.ChangeEvent<HTMLInputElement>) => {
    setEmail(e.target.value);
  };
  const handleChangePassword = (e: React.ChangeEvent<HTMLInputElement>) => {
    setPassword(e.target.value);
  };
  return (
    <div className="App">
      <h1>ログイン</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="email">Email</label>
          <input
            id="email"
            name="email"
            value={email}
            onChange={handleChangeEmail}
          />
        </div>
        <div>
          <label htmlFor="password">パスワード</label>
          <input
            id="password"
            name="password"
            value={password}
            onChange={handleChangePassword}
            type="password"
          />
        </div>
        <div>
          <button type="submit">ログイン</button>
        </div>
      </form>
    </div>
  );
}

export default App;
```

- `useState()` で メールアドレス と パスワードの入力値 を管理している
- `<input />` に文字を入力するたびに、`handleChange()` が実行されて、ステートの更新が発生する
- ステートの更新が発生するため、入力するたびに再レンダリングが発生する

### `useRef()` を使用した場合

```tsx
import { useRef } from "react";
import styles from "@/styles/App.module.scss";

function App() {
  const emailRef = useRef<HTMLInputElement>(null);
  const passwordRef = useRef<HTMLInputElement>(null);

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    console.log({
      emai: emailRef.current?.value,
      password: passwordRef.current?.value,
    });
  };

  return (
    <div className="App">
      <h1>ログイン</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="email">Email</label>
          <input id="email" name="email" ref={emailRef} />
        </div>
        <div>
          <label htmlFor="password">パスワード</label>
          <input
            id="password"
            name="password"
            ref={passwordRef}
            type="password"
          />
        </div>

        <div>
          <button type="submit">ログイン</button>
        </div>
      </form>
    </div>
  );
}

export default App;
```

- `useState()` で入力値を管理していた部分を `useRef()` に置き換える
- `useRef()` では、DOM 要素への直接的な参照を保持する
- これにより、コンポーネントの再レンダリングを引き起こさず、変更された DOM 要素の現在の値を保持する

## ライブラリのインストール

```shell
yarn add react-hook-form
```

## React Hook Form で実装する

```tsx
import styles from "@/styles/App.module.scss";
import { useForm } from "react-hook-form";

type FormData = {
  email: string;
  password: string;
};

function App() {
  const { register, handleSubmit } = useForm<FormData>();

  const onSubmit: SubmitHandker = (data) => console.log(data);

  return (
    <div className="App">
      <h1>ログイン</h1>
      <form onSubmit={handleSubmit(onSubmit)}>
        <div>
          <label htmlFor="email">Email</label>
          <input id="email" {...register("email")} />
        </div>
        <div>
          <label htmlFor="password">Password</label>
          <input id="password" {...register("password")} type="password" />
        </div>
        <button type="submit">ログイン</button>
      </form>
    </div>
  );
}

export default App;
```

:::details type FormData

- フォームのデータ構造を定義する型
- 上記例では、`email` と `password` の文字列フィールドが含まれている

:::

:::details useForm

- React Hook Form から提供されているカスタムフック
- このフックを使用して、フォームの値を管理する

:::

:::details register

- フォームのフィールドを React Hook Form に登録するための関数
- 引数には `name` 属性を指定する
- 各フォーム要素は、`name` 属性に基づいて React Hook Form により識別される
- この `name` を通じて、フィールドの値の追跡、バリデーションの管理、そして最終的なデータの収集が行われる
- `register` 関数は、`input` or `select` 要素に `ref` を割り当て、内部的にフォーム値を収集するためのイベントリスナーを設定する
- 戻り値として `name`, `onChange`, `onBlur`, `ref` を受け取る
  したがって、以下のコード

  ```ts
  <input id="email" {...register("email")} />
  ```

  は次のように置き換えることができる

  ```ts
  const { name, ref, onChange, onBlur } = register("email");

  <input
    id="email"
    name={name}
    onChange={onChange}
    onBlur={onBlur}
    ref={ref}
  />;
  ```

:::

:::details handleSubmit

- フォームを送信するためのハンドラー関数
- この関数を呼び出すと、フォームに入力された値が自動的に検証される
- 全てのバリデーションが通過したら、引数に指定したコールバック関数が呼び出される

```ts
const onSubmit: SubmitHandler<FormData> = (data) => {
  console.log(data);
  // {
  //   email: "sample@gmail.com",
  //   password: "password"
  // }
};
```

- 引数として渡す関数には `SubmitHandler<フィールドの型>` による型宣言を行う
- これにより、`data` の型がフィールドの型（上記だと `FormData`）として認識される。
- `data` の中身は、`name` 属性をキーとしたオブジェクト

:::

## フォーム初期値の設定

`useForm()` の引数オブジェクトで `defaultValues` を使用することでフォームの各要素に初期値を設定することができる。

```tsx
const defaultValues: FormData = { email: "john@test.com", password: "pass" };

const {
  register,
  handleSubmit,
  formState: { errors },
} = useForm<FormData>({
  defaultValues,
});
```

## バリデーションの実装

- バリデーションは入力した値のチェックを行う機能

  - メールアドレス形式どうかチェックする
  - パスワードに文字数制限を入れる

  ...など

- バリデーションを利用することで、入力内容が条件を満たしていない場合はサーバへ送信する前にユーザに対しエラーメッセージとして伝えることができる
- つまり、`handleSubmit()` の引数に指定した関数が実行されない
- バリデーションの実装には、zod や yup などの外部ライブラリを使用することが多い
- しかし、React Hook Form だけでもバリデーションの実装が可能

## バリデーションの実装（React Hook Form）

- React Hook Form によるバリデーションは `register()` 関数で設定できる
- `register()` の第二引数にはオプションを設定することができ、複数のバリデーション設定を行うことができる
- バリデーションには HTML5 が持つフォーム制御の機能を利用することができる

### サポートされているバリデーションのルール

:::details required

```tsx
register("fieldName", { required: true });
```

- フィールドが必須かを指定する
- フィールドが空だとエラーが出る

- エラーメッセージも設定可能

```tsx
register("fieldName", { required: "このフィールドは必須です" });
```

:::

:::details min

- 数値や日付フィールドに最小値を設定する
- 指定値未満だとエラーが出る

```tsx
register("age", { min: 18 });
```

- 18 歳未満だとエラー

:::

:::details max

- 数値や日付フィールドに最大値を設定する
- 指定値を超えるとエラーが出る

```tsx
register("age", { max: 100 });
```

- 100 歳を超えるとエラー

:::

:::details minLength

- 文字列フィールドに最大文字数を設定する
- 指定文字数を超えるとエラーが出る

```tsx
register("password", { maxLength: 12 });
```

- 12 文字を超えるとエラー

:::

:::details pattern

- 文字列フィールドに正規表現パターンを設定する
- パターンに一致しないとエラーが出る

```tsx
register("email", { pattern: /^\S+@\S+\.\S+$/ });
```

- メールアドレス形式じゃないとエラー

:::

:::details validate

- カスタムバリデーション関数を設定できる
- 真偽値を返すかエラーメッセージを返す
- 偽やエラーメッセージが返るとエラーが出る

```tsx
register("username", {
  validate: (value) => value === "admin" || "管理者ではありません",
});
```

- ユーザー名が `admin` じゃないとエラー

:::

## バリデーションエラーの表示

- バリデーションのエラーを表示するには `useForm()` から取得できる `formState` を利用する
- `formState` はフォームの現在の状態に関する情報を持つオブジェクト
- オブジェクトにはエラーの状態を持つ `errors` がある

```tsx
const {
  register,
  handleSubmit,
  formState: { errors },
} = useForm();
```

`email` に関するエラーが発生した場合には `errors.email` オブジェクトに `type`, `message`, `ref` が保存される。

```tsx
<input id="email" {...register("email", { required: "入力必須です。" })} />;

console.log(errors.email);
// {
//   type: "reqyired",
//   message: "入力必須です",
//   ref: input#email
// }
```

ブラウザ上に表示させたい場合には、以下のように設定する。

```tsx
<input
  id="email"
  {...register("email", {
    required: {
      value: true,
      message: "入力が必須の項目です。",
    },
  })}
/>;
{
  errors.email?.message && <div>{errors.email.message}</div>;
}
```

## 1 つのフィールドに対し複数のバリデーションを実装する

### バリデーションルールの設定

```tsx
<input
  id="password"
  {...register("password", {
    required: { value: true, message: "入力必須です" },
    pattern: {
      value: /^[A-Za-z]+$/,
      message: "アルファベットのみ入力してください。",
    },
    minLength: {
      value: 9,
      message: "9文字以上入力してください。",
    },
  })}
  type="password"
/>
```

### `criteriaMode` の設定

- デフォルトの設定では、`formState.errors` は 1 つのフィールドに対して 1 つのエラー情報しか持たない
- 複数のバリデーションエラーを取得するためには、`useForm` の引数で `criteriaMode` の設定を行う必要がある
- デフォルトだと `criteriaMode: "firstError"` で一つのエラー情報しか持たないので、`criteriaMode: "all"` で複数のエラー情報を持つように設定する

```tsx
const {
  register,
  handleSubmit,
  formState: { errors },
} = useForm({
  criteriaMode: "all",
});
```

`all` を設定すると、`errors` オブジェクトに対し新たに `types` プロパティが追加され複数のバリデーションエラーが保持される。

![](https://storage.googleapis.com/zenn-user-upload/9d5d3853b337-20231118.png)

エラーメッセージの表示は以下のように記述する。

```tsx
{
  errors.password?.types?.required && (
    <div className={styles.error}>{errors.password.types.required}</div>
  );
}
{
  errors.password?.types?.pattern && (
    <div className={styles.error}>{errors.password.types.pattern}</div>
  );
}
{
  errors.password?.types?.minLength && (
    <div className={styles.error}>{errors.password.types.minLength}</div>
  );
}
```

![](https://storage.googleapis.com/zenn-user-upload/81bfa58c92da-20231118.png)

## バリデーション設定（Zod）

- Zod はバリデーションライブラリ（React Hook Form 専用ではない）
- スキーマを定義し、バリデーションの設定を行うことができる
- 定義したスキーマから TypeScript の型を生成できる

先ほどのフォームに対し、バリデーションを実装してみる。
仕様は以下の通り。

- 「Email」はメールアドレス形式で、入力必須
- 「Password」は英大文字 or 英小文字 or 数字を使って 8 文字以上 20 文字以下で、入力必須

まずは、Zod を使用してバリデーションのスキーマを定義する。
「スキーマ」とは、フォームデータのバリデーションルールを定義するためのオブジェクトのこと。
スキーマはデータの構造や制約を定義し、そのデータが特定の条件を満たしているかどうかを確認する役割を持つ。

```ts
import { z } from "zod";

export const Schema = z.object({
  email: z
    .string()
    .email()
    .min(8, "8文字以上入力してください。")
    .max(20, "20文字以下で入力してください。"),
  password: z
    .string()
    .string()
    .min(8, "8文字以上入力してください。")
    .max(20, "20文字以下で入力してください。")
    .regex(/^[a-zA-Z0-9]+$/, {
      message: "英大文字、英小文字、数字で入力してください",
    }),
});

export type SchemaType = z.infer<typeof Schema>;
```

- `z.object({})` でスキーマを定義する
- 各プロパティは `register`の第一引数で設定した名前と対応させる
- `z.string()` は文字列であること、`z.min(8)`は 8 文字以上であることを定義できる
- `z.string().min(1)`といったように、関数をつなぐことでバリデーションルールを設定できる
- `z.infer<typeof スキーマ名>` とすることで、スキーマから型を生成できる

## バリデーションの設定（Yup）

### ライブラリをインストール

```shell
yarn add @hookform/resolvers yup
```

### スキーマ定義

```ts
import * as yup from "yup";

const schema = yup.object({
  email: yup
    .string()
    .email("メールアドレスの形式ではありません。")
    .required("入力必須の項目です。"),
  password: yup
    .string()
    .min(8, "8文字以上入力してください。")
    .max(32, "32文字以下を入力してください。"),
});
```

### React Hook Form に反映

```ts
import { yupResolver } from "@hookform/resolvers/yup";

const {
  register,
  handleSubmit,
  formState: { errors },
} = useForm<Field>({
  resolver: yupResolver(schema),
});
```

```ts
return (
  <div className="App">
    <h1>ログイン</h1>
    <form onSubmit={handleSubmit(onSubmit)}>
      <div>
        <label htmlFor="email">Email</label>
        <input id="email" {...register("email")} />
        <p>{errors.email?.message}</p>
      </div>
      <div>
        <label htmlFor="password">Password</label>
        <input id="password" {...register("password")} type="password" />
        <p>{errors.password?.message}</p>
      </div>
      <button type="submit">ログイン</button>
    </form>
  </div>
);
```

## バリデーションのタイミング

- デフォルトの設定では `onSubmit` でバリデーションが行われる
- 最初のバリデーション後は文字を入力する度にバリデーションが実行される
- バリデーションのタイミングは `useForm` の `mode`, `reValidateMode` によって制御できる
- 手動でバリデーションを行う方法もある

### `mode` の設定

```ts
const {
  register,
  handleSubmit,
  formState: { errors },
} = useForm<Field>({
  mode: "onChange",
  resolver: yupResolver(schema),
});
```

- バリデーションが最初にいつトリガーされるかを指定する
- デフォルト値は `onSubmit`
- `onBlur`, `onChange`, `onTouched`, `all` に変更可能
- 再レンダリングが行われるタイミングはバリデーションメッセージの表示・非表示が切り替わる瞬間

### reValidateMode の設定

- 2 回目からのバリデーションタイミングを設定する
- デフォルトでは `onChange`
- `onBlur`、`onSubmit`に変更可能

### 手動でのバリデーション

`useForm()` から戻されるオブジェクトである `trigger` を利用することで、バリデーションを手動で行える。

```ts
const {
  register,
  handleSubmit,
  formState: { errors },
  trigger
} = useForm<Field>({
  resolver: yupResolver(schema),
});

//略

<button type="submit">ログイン</button>
<button type="button" onClick={() => trigger()}>
  バリデーション
</button>
```

- 「バリデーション」ボタンをクリックするとバリデーションが実行される
- 引数に何も指定しない場合、すべてのフィールドに対してバリデーションが実行される
- 引数にフィールドの `name` を指定すると、そのフィールドに対してのみバリデーションが実行される

## 可変長の入力フィールドを作成する

以下のように、商品情報を入力するフィールドを実装する。
同じタイプな可変長のフィールドを実装するには `useFieldArray()` を使用する。

![](https://storage.googleapis.com/zenn-user-upload/b68c76551f58-20231118.png)

- `useFieldArray()` は可変長のフィールド（フォーム内の動的なフィールドセット）を扱うためのフック
- `useFieldArray()` から取得できるオブジェクトのプロパティを使用することで、フィールドの配列を効率的に追加、削除、更新することができる

```tsx
import { SubmitHandler, useFieldArray, useForm } from "react-hook-form";
import styles from "@/styles/App.module.scss";

type FormData = {
  items: { name: string; price: number }[];
};

const defaultValues: FormData = {
  items: [{ name: "", price: 0 }],
};

function Items() {
  const { register, handleSubmit, control } = useForm<FormData>({
    criteriaMode: "all",
    defaultValues,
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: "items",
  });

  const onSubmit: SubmitHandler<FormData> = (data) => {
    console.log(data);
  };

  return (
    <div className={styles.container}>
      <h1>商品登録</h1>
      <form onSubmit={handleSubmit(onSubmit)}>
        {fields.map((field, index) => (
          <div key={field.id} className={styles.itemField}>
            <div>
              <label htmlFor={`items.${index}.name`}>商品名</label>
              <input type="text" {...register(`items.${index}.name`)} />
            </div>
            <div>
              <label htmlFor={`items.${index}.price`}>単価</label>
              <input type="text" {...register(`items.${index}.price`)} />
            </div>
            <button type="button" onClick={() => remove(index)}>
              削除
            </button>
          </div>
        ))}
        <button type="button" onClick={() => append({ name: "", price: 0 })}>
          追加
        </button>
        <button type="submit">登録</button>
      </form>
    </div>
  );
}

export default Items;
```

#### `FormData`

商品情報フィールドは商品名を表す `name` と 単価を表す `price` のフィールドを持っている。
`name` と　`price`の 2 つで 1 つのフィールドでありかつ可変長であるため、オブジェクト配列で定義する。

#### `control`

- `useForm` フックから返される `control` オブジェクト
- フィールド配列の状態管理と更新を担う
- `useFieldArray()` のオブジェクト引数に `control` を指定することで、フィールド配列の管理が `useForm()` の管理下に統合される

#### `name`

- フィールド配列の名前
- この名前は `useForm()` で定義されるフィールドの名前と一致する必要がある

#### `fields`

- 現在のフィールド配列の状態を表す
- 配列の各要素には、フィールド固有の識別子（`id`）やフィールド値が格納されている

```tsx
console.log(fields);
// [
//   {
//     id: "142b52e3-4d4a-4f56-a6c6-632a765c97be",
//     name: "",
//     price: 0,
//   },
// ]
```

- `map()` 関数を使用して各フィールド要素をレンダリングする
- **`map()` でレンダリングする際の `key` は `id` を使用する**

#### `register`

#### `append`

- 新しいフィールドを配列の末尾に追加する
- 追加する際は引数に初期値を指定する

#### `remove`

- 指定したインデックスのフィールドを配列から削除する
- 引数には削除するフィールドのインデックスを指定する

## その他 `useForm()` の戻り値一覧

:::details unregister
:::

:::details watch

- 引数に渡した名前のフールド値を監視してその値を返す
- watch を使う場合、引数に渡した値が更新されると再レンダリングする

```ts
const emailField = watch("email");

<input {...register("email")} />;
```

:::

:::details resetFeild
:::

:::details setError
:::

:::details clearErrors
:::

:::details setValue

- 登録したフィールド値を動的に設定できる関数
- `setValue` で設定しても再レンダリングされない

:::

:::details setFocus
:::

:::details getValues
:::

:::details trigger
:::

:::details control
:::

:::details Form
:::

## 参考リンク

https://tech-o-proch.com/programing/react/579#index_id0

https://qiita.com/y-suzu/items/952d417f0853341a97df

https://reffect.co.jp/react/react-hook-form-ts/
