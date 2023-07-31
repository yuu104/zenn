---
title: "React Hook Formとバリデーション"
emoji: "📘"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, reacthookform, typescript, zod, yup]
published: false
---

## React Hook Form とは？

- React 用のフォームバイデーションライブラリ
- フォーム入力値の状態管理を自前で行う必要がないので楽
  - 通常は `useState` や `useRef` を使用して入力値の値を管理する
  - React Hook Form では、ref による入力を裏側でやってくれる

## ライブラリのインストール

```shell
yarn add react-hook-form
```

## 簡単なデモとソースコード

ログイン入力フォームを作成する。
![](https://storage.googleapis.com/zenn-user-upload/6256d406ac82-20230731.png)

```ts
import "./styles.css";
import { useForm, SubmitHandler } from "react-hook-form";

type Field = {
  email: string;
  password: string;
};

export default function App() {
  const { register, handleSubmit } = useForm<Field>();

  const onSubmit: SubmitHandler<FormData> = (data) => {
    console.log(data);
  };

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
```

:::details type Field

- React Hook Form から提供されているカスタムフック
- このフックを使用して、フォームの値を管理する
  :::

:::details register

- フォームのフィールドを React Hook Form に登録するための関数
- 引数には `name` 属性を指定する
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
  const onSubmit: SubmitHandler<Field> = (data) => {
    console.log(data);
  };
  ```
  引数として渡す関数には `SubmitHandler<フィールドの型>` による型宣言を行う。
  これにより、`data` の型がフィールドの型（上記だと `Field`）として認識される。

:::

## バリデーション設定（Zod）

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
} = useForm<Field>({
  resolver: yupResolver(schema),
});

//略

<button type="submit">ログイン</button>
<button type="button" onClick={() => trigger()}>
  バリデーション
</button>
```

- バリデーションボタンをクリックするとバリデーションが実行される
- 引数に何も指定しない場合、すべてのフィールドに対してバリデーションが実行される
- 引数にフィールドの `name` を指定すると、そのフィールドに対してのみバリデーションが実行される

## `useForm()`の戻り値一覧

:::details register
:::

:::details unregister
:::

:::details formState
:::

:::details watch

- 引数に渡した名前のフールド値を監視してその値を返す
- watch を使う場合、引数に渡した値が更新されると再レンダリングする

```ts
const emailField = watch("email");

<input {...register("email")} />;
```

:::

:::details handleSubmit
:::

:::details reset
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
