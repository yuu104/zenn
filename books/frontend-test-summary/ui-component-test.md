---
title: "UIコンポーネントテスト"
---

## 環境構築

React における UI コンポーネントテストに必要なライブラリは以下の通り。

- `jest-enviroment-jsdom`
- `@testing-library/react`
- `@testing-library/jest-dom`
- `@testing-library/user-event`

UI コンポーネントのテストは、表示された UI を操作し、その作用から発生した結果を検証することが基本。
UI を表示して操作するには DOM API が必要になるが、Jest 実行環境の Node.js には DOM API が標準で用意されていないため、`jsdom` をセットアップする必要がある。
デフォルトのテスト環境は`jest.config.js`の`testEnvironment`に指定する。
旧バージョンでは`jsdom`を指定していたが、最新バージョンの Jest では改善された`jest-environment-jsdom`を別途インストールして指定する必要がある。

```js:config.js
module.exports = {
  testEnvironment: "jest-environment-jsdom",
};
```

Next.js のようにサーバーサイド/クライアントサイドのコードが混在しているプロジェクトの場合、テストファイル冒頭で以下のようなコメントを記述することで、テストファイルごとにテスト環境を切り替えることもできる。

```js
/**
 * @jest-environment jest-environment-jsdom
 * /
```

### Testing Library

Testing Library は UI コンポーネントのテスト用ライブラリであり、主な役割は以下の 3 つ。

- UI コンポーネントをレンダリングする
- レンダリングした要素から、任意の子要素を取得する
- レンダリングした要素に、インタラクションを与える

Testing Library は基本原則として **テストがソフトウェアの使用方法に似ている** ことを推奨している。
つまり、クリック/マウスオーバー/キーボード入力など、Web アプリケーションを操作するのと同じようなテストを書くべきだと推奨している。

React アプリの場合、`@testing-library/react`を使用する。
Testing Library は他にも様々な UI コンポーネントライブラリ（Vue, Angular など）に向けて提供されているが、中核となる API は`@testing-library/dom`を使用しているため、ライブラリが異なっていても同じようなテストコードになる。

### UI コンポーネントテスト用のマッチャー拡張

UI コンポーネントテストにも、Jest のアサーションやマッチャーを使用できる。
しかし、DOM の状態を検証するためには Jest 標準のマッチャーだけでは不十分であるため、`@test-library/jest-dom`をインストールする。
これは、「カスタムマッチャー」という、Jest の拡張機能を使用したライブラリであり、UI コンポーネントテストに便利なマッチャーが多数ある。

### ユーザ操作をシュミレートするライブラリ

Testing Library には入力要素に文字入力などを行うために`fireEvent`という API が提供されている。
しかし、この API は DOM イベントを発火させるだけのものなので、実際のユーザ操作では不可能なこともできてしまう。
そこで、実際のユーザ操作に近いシュミレートが可能な`@testing-library/user-event`を追加する。

## 基本的なテスト

まずは、基本的な UI コンポーネントテストについて解説する。
以下はアカウント情報登録ページに使用されるコンポーネントである。
`編集する`ボタンを押すと、対象アカウントの編集画面へ遷移する。

```tsx:Form.tsx
type Props = {
  name: string;
  onSubmit?: (event: React.FormEvent<HTMLFormElement>) => void;
};

export const Form = ({ name, onSubmit }: Props) => {
  return (
    <form
      onSubmit={(event) => {
        event.preventDefault();
        onSubmit?.(event);
      }}
    >
      <h2>アカウント情報</h2>
      <p>{name}</p>
      <div>
        <button>編集する</button>
      </div>
    </form>
  );
};
```

![](/images/frontend-test-summary/basic-component-test-form.png)

以下のテストでは、props の`name`に`taro`を渡してレンダリングした`Form`コンポーネント内に`taro`が表示されていることを検証している。

```tsx:Form.test.tsx
import { fireEvent, logRoles, render, screen } from "@testing-library/react";
import { Form } from "./Form";

test("名前の表示", () => {
  render(<Form name="taro" />);
  expect(screen.getByText("taro")).toBeInTheDocument();
});
```

### コンポーネントをレンダリングする

コンポーネントをテストするにはレンダリングさせる必要がある。
そのため、`render`関数を使用し、引数にレンダリングさせたいコンポーネントを指定する。

### 特定の DOM 要素を取得する

レンダリングした内容から特定の DOM 要素を取得するためには`screen.getByText`を使用する。
これは「一致した文字列を持つテキスト要素を 1 つ見つける」API であり、見つかった場合、その要素の参照が得られる。
要素が見つからなかった場合はエラーが発生し、テストは失敗する。

### アサーションを書く

アサーションは、`@testing-library/jest-dom`で拡張したカスタムマッチャーを使用する。
`toBeInTheDocument()`は「要素がドキュメントに存在すること」を検証するカスタムマッチャー。

### 特定の DOM 要素をロールで取得する

`screen.getByRole`を使用する。
`Form`コンポーネントには`<button>`が含まれているため、以下のテストは成功する。

```tsx:Form.test.tsx
test("ボタンの表示", () => {
  render(<Form name="taro" />);
  expect(screen.getByRole("button")).toBeInTheDocument();
});
```

この`<button>`は明示的に`button`ロールを指定していないが、`getByRole("button")`で取得できているのは「暗黙的なロール」の識別も Testing Library がサポートしているからである。

### イベントハンドラーの呼び出しテスト

UI コンポーネントでは props にイベントハンドラーを指定し「ボタンが押下された時に〜する」といったように、必要な処理を実装するケースが多い。
このようなイベントハンドラーの呼び出しは、関数の単体テストと同じようにモック関数を利用して検証する。

```tsx:Form.test.tsx
import { fireEvent, render, screen } from "@testing-library/react";

test("ボタンを押下すると、イベントハンドラーが呼ばれる", () => {
  const mockFn = jest.fn();
  render(<Form name="taro" onSubmit={mockFn} />);
  fireEvent.click(screen.getByRole("button"));
  expect(mockFn).toHaveBeenCalled();
});
```

## アイテム一覧 UI コンポーネントのテスト

次に、Props から受け取ったアイテムの一覧を表示するような UI コンポーネントのテストについて解説する。

### テスト対象の UI コンポーネント

```tsx
import { FC } from "react";

type ArticleListProps = {
  items: ItemProps[];
};

export const ArticleList: FC<ArticleListProps> = ({ items }) => {
  return (
    <div>
      <h2>記事一覧</h2>
      {items.length ? (
        <ul>
          {items.map((item) => (
            <ArticleListItem {...item} key={item.id} />
          ))}
        </ul>
      ) : (
        <p>投稿記事がありません</p>
      )}
    </div>
  );
};

type ArticleListItemProps = {
  id: string;
  title: string;
  body: string;
};

const ArticleListItem: FC<ArticleListItemProps> = ({ id, title, body }) => {
  return (
    <li>
      <h3>{title}</h3>
      <p>{body}</p>
      <a href={`/articles/${id}`}>もっと見る</a>
    </li>
  );
};
```

上記コンポーネントのテスト観点は以下の 2 つ。

- アイテムが存在する場合、一覧表示されること
- アイテムが存在しない場合、一覧表示されないこと

### 複数要素が存在する（一覧表示される）ことをテストする

```ts
export const items: ItemProps[] = [
  {
    id: "howto-testing-with-typescript",
    title: "TypeScript を使ったテストの書き方",
    body: "テストを書く時、TypeScript を使うことで、テストの保守性が向上します…",
  },
  {
    id: "nextjs-link-component",
    title: "Next.js の Link コンポーネント",
    body: "Next.js の画面遷移には、Link コンポーネントを使用します…",
  },
  {
    id: "react-component-testing-with-jest",
    title: "Jest ではじめる React のコンポーネントテスト",
    body: "Jest は単体テストとして、UIコンポーネントのテストが可能です…",
  },
];

test("items の数だけ一覧表示される", () => {
  render(<ArticleList items={items} />);
  expect(screen.getAllByRole("listitem")).toHaveLength(3);
});
```

`getAllByRole`は、該当要素を配列で取得する API で、`<li>`は暗黙のロールとして`listItem`を持つ。
そのため、`getAllByRole("listitem")`でコンポーネント内の全ての`<li>`を取得できる。
`toHaveLength`マッチャーは、**配列の要素数**を検証するマッチャー。

上記テストにより、`<li>`が 3 件表示されることを確認できたが、十分ではない。
テスト観点は「`<ul>`（一覧）が表示されていること」であるため「`<ul>`が存在しているか？」を検証するべきである。
`<ul>`は暗黙のロールとして`list`を持つため、`getByRole("list)`で要素を取得することができる。

```ts
test("一覧が表示される", () => {
  render(<ArticleList items={items} />);
  const list = screen.getByRole("list");
  expect(list).toBeInTheDocument();
});
```

### テスト対象の要素を絞り込む

前述のテストでは、コンポーネント内に存在する全ての`listitem`ロールの要素に対して検証を行っていた。
この場合、テスト対象ではない`listitem`要素も`getAllByRole`により取得されてしまう可能性がある。
そのため、`<ul>`内の`<li>`に絞り込んで要素を取得し、テストを行う必要がある。
このように、対象を絞り込んで要素取得を行いたい場合、`within`関数を使用する。
`within`の返り値には、`screeen`と同じ要素取得 API が含まれる。

```ts
test("items の数だけ一覧表示される", () => {
  render(<ArticleList items={items} />);
  const list = screen.getByRole("list");
  expect(list).toBeInTheDocument();
  expect(within(list).getAllByRole("listitem")).toHaveLength(3);
});
```

### 一覧表示されないことをテストする

`items`Props が空の場合、一覧が表示されず、「投稿記事がありません」というテキストが表示される。

`getByRole`や`getByLabelText`は、存在しない要素取得を試みた場合、エラーが発生する。
そのため、「存在しないこと」を確認したいときは、`queryBy`接頭辞をもつ API を使用する。
`queryBy`接頭辞を持つ API を使用すると、取得できなかった場合`null`が返るため、`not.toBeInTheDocument`または`toBeNull`マッチャーで検証ができる。

```ts
test("一覧アイテムが空のとき「投稿記事がありません」が表示される", () => {
  render(<ArticleList items={[]} />);
  const list = screen.queryByRole("list");
  expect(list).not.toBeInTheDocument();
  expect(list).toBeNull();
  expect(screen.getByText("投稿記事がありません")).toBeInTheDocument();
});
```

### `<a>`要素の`href`属性の値をテストする

`ArticleListItem`コンポーネントでは、Props で受け取った`id`から`もっと見る`のリンク先 URL を算出している。

```ts
const item: ItemProps = {
  id: "howto-testing-with-typescript",
  title: "TypeScript を使ったテストの書き方",
  body: "テストを書く時、TypeScript を使うことで、テストの保守性が向上します…",
};

test("ID に紐づいたリンクが表示される", () => {
  render(<ArticleListItem {...item} />);
  expect(screen.getByRole("link", { name: "もっと見る" })).toHaveAttribute(
    "href",
    "/articles/howto-testing-with-typescript"
  );
});
```

## インタラクティブな UI コンポーネントテスト

フォーム UI の操作・状態チェックのテストケースについて解説する。

### テスト対象の UI コンポーネント

新規アカウント登録を行う UI コンポーネント。
メールアドレスとパスワードを入力し、利用規約の同意にチェックを付けてサインアップを行う。

```tsx
import { useId, useState } from "react";

export const Form = () => {
  const [checked, setChecked] = useState(false);
  const headingId = useId();
  return (
    <form aria-labelledby={headingId}>
      <h2 id={headingId}>新規アカウント登録</h2>
      <InputAccount />
      <Agreement
        onChange={(event) => {
          setChecked(event.currentTarget.checked);
        }}
      />
      <div>
        <button disabled={!checked}>サインアップ</button>
      </div>
    </form>
  );
};

const InputAccount = () => {
  return (
    <fieldset>
      <legend>アカウント情報の入力</legend>
      <div>
        <label>
          メールアドレス
          <input type="text" placeholder="example@test.com" />
        </label>
      </div>
      <div>
        <label>
          パスワード
          <input type="password" placeholder="8文字以上で入力" />
        </label>
      </div>
    </fieldset>
  );
};

type AgreementProps = {
  onChange?: React.ChangeEventHandler<HTMLInputElement>;
};

export const Agreement: FC<AgreementProps> = ({ onChange }) => {
  return (
    <fieldset>
      <legend>利用規約の同意</legend>
      <label>
        <input type="checkbox" onChange={onChange} />
        当サービスの<a href="/terms">利用規約</a>を確認し、これに同意します
      </label>
    </fieldset>
  );
};
```

サインアップボタンの活性・非活性は、利用規約同意のチェクボックスにより切り替わる。

![](https://storage.googleapis.com/zenn-user-upload/bd08e50c2904-20230702.png)

### アクセシブルネームのテスト

:::details アクセシブルネームとは？
「アクセシブルネーム（accessible name）」は、ウェブアクセシビリティのコンテキストで使用される用語です。アクセシブルネームは、特定の要素（通常はインタラクティブな要素）に対して、その要素の目的や役割を説明するテキストのことを指します。これにより、アシスト技術を使用するユーザーが要素の目的や機能を理解しやすくなります。

具体的な例として、リンク(`<a>`要素)を考えてみましょう。リンクのアクセシブルネームは、そのリンクがリンク先のコンテンツを表すテキストです。通常はリンクのテキスト自体がアクセシブルネームになります。しかし、リンクのテキストだけではリンク先の目的を十分に説明できない場合、`<a>`要素に aria-label や aria-labelledby 属性を追加してアクセシブルネームを提供することができます。

アクセシブルネームは、スクリーンリーダーやブラウザのアクセシビリティ機能など、アシスト技術によって使用されます。これにより、視覚障害や認知障害を持つユーザーがウェブコンテンツをより理解しやすくなり、適切に操作することができます。

アクセシブルネームの提供は、ウェブアクセシビリティの重要な側面であり、WCAG（Web Content Accessibility Guidelines）などのアクセシビリティ基準で推奨されています。
:::

:::details `<fieldset>`と`<legend>`について
`<fieldset>`と`<legend>`は、HTML フォームの作成やグループ化に使用される要素です。

`<fieldset>`要素は、関連するフォームの要素をグループ化するために使用されます。`<fieldset>`タグ内に他のフォーム要素（`<input>`、`<select>`、`<textarea>`など）を配置することができます。グループ化により、関連するフォームコントロールが視覚的に関連付けられ、ユーザーにとって理解しやすくなります。

`<fieldset>`要素は、通常、`<form>`要素内に配置されますが、必須ではありません。以下に例を示します。

```html
<form>
  <fieldset>
    <legend>連絡先情報</legend>
    <label for="name">名前:</label>
    <input type="text" id="name" name="name" required />
    <br />
    <label for="email">メールアドレス:</label>
    <input type="email" id="email" name="email" required />
  </fieldset>
</form>
```

`<legend>`要素は、`<fieldset>`のタイトルまたは説明を提供するために使用されます。`<legend>`要素は`<fieldset>`の最初の子要素として配置され、`<fieldset>`の枠内に表示されます。

上記の例では、`<legend>`要素の内容である「連絡先情報」が`<fieldset>`のタイトルとして表示されます。

`<fieldset>`と`<legend>`の組み合わせにより、関連するフォーム要素を視覚的にまとめることができます。これにより、フォームの利用者が情報の入力や理解を容易にすることができます。
:::

`<fieldset>`は、暗黙のロールとして`group`を持つ。
以下のテストは、`Agreement`コンポーネントの`<legend>`に表示されている文字列が、`<fieldset>`のアクセシブルネームとして引用されていることを検証するテスト。
`<legend>`があることで、暗黙的にこのグループのアクセシブルネームが決まっていることが検証できる。

```ts
test("fieldset のアクセシブルネームは、legend を引用している", () => {
  render(<Agreement />);
  expect(
    screen.getByRole("group", { name: "利用規約の同意" })
  ).toBeInTheDocument();
});
```

`getByRole`の`name`オプションを使用してアクセシブルネームを指定する。

以下のコンポーネントは同じ見た目であっても、適切ではない。
なぜなら、`div`はロールを持たないため、アクセシビリティツリー上ではひとまとまりのグループとして識別できない。

```tsx
export const Agreement: FC<AgreementProps> = ({ onChange }) => {
  return (
    <div>
      <h3>利用規約の同意</h3>
      <label>
        <input type="checkbox" onChange={onChange} />
        当サービスの<a href="/terms">利用規約</a>を確認し、これに同意します
      </label>
    </div>
  );
};
```

つまり、テストを書く時にも、`Agreement`コンポーネントをひとまとまりのグループとして特定することが困難になる。
このように、UI コンポーネントのテストを書くことで、アクセシビリティへ配慮する機会が増える。

### アカウント情報入力のインタラクションをテストする。

`InputAccount`コンポーネントは、メールアドレスとパスワードを入力する UI コンポーネント。
それぞれの`input`要素にメールアドレスとパスワードを入力するテストを書く。

#### `userEvent`で文字を入力する

文字入力の再現は`fireEvent`でも可能だが、よりユーザ操作に近い再現をするには`@testing-library/user-event`の`userEvent`を使用する。
`userEvent`を使用した文字入力操作方法は以下の通り。

1. `userEvent.setup()`で API を呼び出すインスタンスを作成
2. `screen.getByRole`で入力欄の要素を取得
3. 取得した入力欄に対し、`type`メソッドで入力操作を行う

`userEvent`を使用したインタラクションは全て、非同期処理なので`await`で入力完了を待つ必要がある。

以下に、メールアドレスの入力をテストを書く。

```ts
import userEvent from "@testing-library/user-event";

const user = userEvent.setup();

test("メールアドレス入力欄", async () => {
  render(<InputAccount />);
  const textbox = screen.getByRole("textbox", { name: "メールアドレス" });
  const value = "taro.tanaka@example.com";
  await user.type(textbox, value);
  expect(screen.getByDisplayValue(value)).toBeInTheDocument();
});
```

メールアドレスと同様に、パスワードの入力もテストする。
`<input type="password" />`は**ロールを持たない**ため、`getByRole`による要素取得ができない。
そのため、今回は`getByPlaceholderText`で入力欄を取得する。

```ts
test("パスワード入力欄", async () => {
  render(<InputAccount />);
  const password = screen.getByPlaceholderText("8文字以上で入力");
  const value = "abcd1234";
  await user.type(password, value);
  expect(screen.getByDisplayValue(value)).toBeInTheDocument();
});
```

### チェックボックス・サインアップボタンのインタラクションをテストする

はじめに、チェックボックス・サインアップボタンの初期状態を検証する。
初期状態では、チェックボックスにはチェックが入っておらず、サインアップボタンは非活性になっている。
チェックボックスの状態は`toBeChecked`マッチャーで検証できる。
ボタンの非活性は`toBeDisabled`マッチャーで検証できる。

```ts
test("チェックボックスはチェックが入っていない", () => {
  render(<Form />);
  expect(screen.getByRole("checkbox")).not.toBeChecked();
});

test("「サインアップ」ボタンは非活性", () => {
  render(<Form />);
  expect(screen.getByRole("button", { name: "サインアップ" })).toBeDisabled();
});
```

次に、チェックボックスにチェックを入れた後のチェックボックス・サインアップボタンの状態を検証する。
ボタンの活性は`toBeEnabled`マッチャーで検証できる。
チェックボタンのクリックは、`userEvent`の`click(対象要素)`メソッドで操作できる。

```ts
test("チェックボックスを押下すると、チェックが入る", () => {
  render(<Form />);
  const checkbox = screen.getByRole("checkbox");
  await user.click(checkbox);
  expect(checkbox).toBeChecked();
});

test("「利用規約の同意」チェックボックスを押下すると「サインアップ」ボタンは活性化", async () => {
  render(<Form />);
  await user.click(screen.getByRole("checkbox"));
  expect(screen.getByRole("button", { name: "サインアップ" })).toBeEnabled();
});
```

## 非同期処理を含む UI コンポーネントテスト

UI コンポーネント上で API 送信を行うテストケースを考える。

### テスト対象のコンポーネント

以下は、お届け先情報の入力フォームを表すコンポーネント。
ログインユーザが買い物をする際の、商品のお届け先を指定する。
ユーザは連絡先情報とお届け先情報を入力する。

```tsx: RegisterAddress.tsx
import { FC, useState } from "react";
import { postMyAddress } from "./fetchers";

export const RegisterAddress = () => {
  const [postResult, setPostResult] = useState("");
  return (
    <div>
      <Form
        onSubmit={handleSubmit((values) => {
          try {
            checkPhoneNumber(values.phoneNumber);
            postMyAddress(values)
              .then(() => {
                setPostResult("登録しました");
              })
              .catch(() => {
                setPostResult("登録に失敗しました");
              });
          } catch (err) {
            if (err instanceof ValidationError) {
              setPostResult("不正な入力値が含まれています");
              return;
            }
            setPostResult("不明なエラーが発生しました");
          }
        })}
      />
      {postResult && <p>{postResult}</p>}
    </div>
  );
};

export type FormProps = {
  onSubmit?: (event: React.FormEvent<HTMLFormElement>) => void;
};

const Form: FC<FormProps> = ({ onSubmit }) => {
  return (
    <form onSubmit={onSubmit}>
      <h2>お届け先情報の入力</h2>
      <ContactNumber />
      <DeliveryAddress />
      <hr />
      <div>
        <button>注文内容の確認へ進む</button>
      </div>
    </form>
  );
};

const ContactNumber = () => {
  return (
    <fieldset>
      <legend>連絡先</legend>
      <div>
        <label>
          電話番号
          <input type="text" name="phoneNumber" />
        </label>
      </div>
      <div>
        <label>
          お名前
          <input type="text" name="name" />
        </label>
      </div>
    </fieldset>
  );
};

type DeliveryAddressProps = {
  title?: string;
};

const DeliveryAddress: FC<DeliveryAddressProps> = ({ title = "お届け先" }) => {
  return (
    <fieldset>
      <legend>{title}</legend>
      <div>
        <label>
          郵便番号
          <input type="text" name="postalCode" placeholder="167-0051" />
        </label>
      </div>
      <div>
        <label>
          都道府県
          <input type="text" name="prefectures" placeholder="東京都" />
        </label>
      </div>
      <div>
        <label>
          市区町村
          <input type="text" name="municipalities" placeholder="杉並区荻窪1" />
        </label>
      </div>
      <div>
        <label>
          番地番号
          <input type="text" name="streetNumber" placeholder="00-00" />
        </label>
      </div>
    </fieldset>
  );
};

function handleSubmit(callback: (values: any) => Promise<void> | void) {
  return (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    const values: { [k: string]: unknown } = {};
    formData.forEach((value, key) => (values[key] = value));
    return callback(values);
  };
}

class ValidationError extends Error {}

function checkPhoneNumber(value: any) {
  if (!value.match(/^[0-9\-]+$/)) {
    throw new ValidationError();
  }
}

```

上記コンポーネントにより以下の UI が構築される。
![](https://storage.googleapis.com/zenn-user-upload/f6a227048ed5-20230702.png)

以下は、API クライアントのコード。
HTTP ステータスが 300 台以上の場合、例外をスローする。

```ts:fetchers/index.ts
const headers = {
  Accept: "application/json",
  "Content-Type": "application/json",
};

export function postMyAddress(values: unknown): Promise<{result: string}> {
  return fetch(host("https://myapi.testing.com/my/address"), {
    method: "POST",
    body: JSON.stringify(values),
    headers,
  }).then((res) => {
    const data = await res.json();
    if (!res.ok) {
      throw data;
    }
    return data;
  });
}
```

このコンポーネントでは、`Form`コンポーネントの「注文内容の確認へ進む」ボタンをクリックした時に API を呼び出して POST 処理を行い、レスポンスに応じて`RegisterAddress`コンポーネントの`postResult`の表示が変わる。
`Form`コンポーネントの`onSubmit`イベントが発生したとき、次の処理が行われる。

1. `handleSubmit`関数 : `<form>`で送信される値をオブジェクト`values`に整形
2. `checkPhoneNumber`関数 : 送信される電話番号の値のバリデーションを実施
3. `postMyAdress`関数 : Web API クライアント呼び出し

### テストケース

お届け先情報の入力フォームコンポーネントのテスト観点は、入力内容と API レスポンスによって出し分けられる、4 パターンのメッセージの表示検証になる。具体的には以下の 4 パターンをテストする。

- POST 処理が成功し、「登録しました」が表示される
- POST 処理が失敗し、「登録に失敗しました」が表示される
- 電話番号のバリデーションエラーで失敗し、「不正な入力値が含まれています」が表示される
- 不明なエラーが発生し、「不明なエラーが発生しました」と表示される

### Web API クライアントのモック関数を用意する

```ts
import * as Fetchers from ".";

export function mockPostMyAddress(status = 201) {
  if (status > 299) {
    return jest.spyOn(Fetchers, "postMyAddress").mockRejectedValueOnce({
      err: { message: "internal server error" },
    });
  }
  return jest
    .spyOn(Fetchers, "postMyAddress")
    .mockResolvedValueOnce({ result: "ok" });
}
```

### 連絡先情報・お届け先情報の入力を行うユーティリティ関数を用意する

4 つのテストケースを書く上で、連絡先情報・お届け先情報の入力を行うコードは共通している。
そのため、各テストケース毎に同じコードを書かなくて済むように、ユーティリティ関数を用意する。
この関数は、入力値のオブジェクト`inputValues`を返す。

```ts
import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

// 連絡先情報の入力を行う関数
export async function inputContactNumber(
  inputValues = {
    name: "田中 太郎",
    phoneNumber: "000-0000-0000",
  }
) {
  await user.type(
    screen.getByRole("textbox", { name: "電話番号" }),
    inputValues.phoneNumber
  );
  await user.type(
    screen.getByRole("textbox", { name: "お名前" }),
    inputValues.name
  );
  return inputValues;
}

// お届け先情報の入力を行う関数
export async function inputDeliveryAddress(
  inputValues = {
    postalCode: "167-0051",
    prefectures: "東京都",
    municipalities: "杉並区荻窪1",
    streetNumber: "00-00",
  }
) {
  await user.type(
    screen.getByRole("textbox", { name: "郵便番号" }),
    inputValues.postalCode
  );
  await user.type(
    screen.getByRole("textbox", { name: "都道府県" }),
    inputValues.prefectures
  );
  await user.type(
    screen.getByRole("textbox", { name: "市区町村" }),
    inputValues.municipalities
  );
  await user.type(
    screen.getByRole("textbox", { name: "番地番号" }),
    inputValues.streetNumber
  );
  return inputValues;
}
```

### テストを書く

`fillValuesAndSubmit()`, `fillInvalidValuesAndSubmit()`は、連絡先・お届け先を入力し、「注文内容の確認へ進む」ボタンをクリックして POST 処理を呼び出すまでの処理をまとめた関数。
`fillInvalidValuesAndSubmit()`は電話番号がバリデーションエラーになるようにしている。

モックモジュールを使用するテストであるため、テストファイル冒頭で`jest.mock(モジュールパス)`を記述する。

また、各テストケースでモックをリセットするために、`jest.resetAllMocks()`を記述する。

```ts
import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { RegisterAddress } from "./RegisterAddress";
import { inputContactNumber, inputDeliveryAddress } from "./testingUtils";

jest.mock("./fetchers");

const user = userEvent.setup();

async function fillValuesAndSubmit() {
  const contactNumber = await inputContactNumber();
  const deliveryAddress = await inputDeliveryAddress();
  const submitValues = { ...contactNumber, ...deliveryAddress };
  await user.click(
    screen.getByRole("button", { name: "注文内容の確認へ進む" })
  );
  return submitValues;
}

async function fillInvalidValuesAndSubmit() {
  const contactNumber = await inputContactNumber({
    name: "田中 太郎",
    phoneNumber: "abc-defg-hijkl",
  });
  const deliveryAddress = await inputDeliveryAddress();
  const submitValues = { ...contactNumber, ...deliveryAddress };
  await user.click(
    screen.getByRole("button", { name: "注文内容の確認へ進む" })
  );
  return submitValues;
}

beforeEach(() => {
  jest.resetAllMocks();
});
```

### POST 処理が成功したときのテスト

`mockPostMyAddress()`を使用することで、Web API クライアントのレスポンスが置き換わる。

```ts
test("成功時「登録しました」が表示される", async () => {
  const mockFn = mockPostMyAddress();
  render(<RegisterAddress />);
  const submitValues = await fillValuesAndSubmit();
  expect(mockFn).toHaveBeenCalledWith(expect.objectContaining(submitValues));
  expect(screen.getByText("登録しました")).toBeInTheDocument();
});
```

### POST 処理が失敗したときのテスト

API レスポンスの reject を再現するため、モック関数の引数に 500 を設定する。

```ts
test("失敗時「登録に失敗しました」が表示される", async () => {
  const mockFn = mockPostMyAddress(500);
  render(<RegisterAddress />);
  const submitValues = await fillValuesAndSubmit();
  expect(mockFn).toHaveBeenCalledWith(expect.objectContaining(submitValues));
  expect(screen.getByText("登録に失敗しました")).toBeInTheDocument();
});
```

### バリデーションエラー時のテスト

```ts
test("バリデーションエラー時「不正な入力値が含まれています」が表示される", async () => {
  render(<RegisterAddress />);
  await fillInvalidValuesAndSubmit();
  expect(screen.getByText("不正な入力値が含まれています")).toBeInTheDocument();
});
```

### 不明なエラー時のテスト

モック関数が実行されていないテストでは、API リクエストを処理することができない。
そのため、これをそのまま不明なエラーの発生状況の再現として使用する。

```ts
test("不明なエラー時「不明なエラーが発生しました」が表示される", async () => {
  render(<RegisterAddress />);
  await fillValuesAndSubmit();
  expect(screen.getByText("不明なエラーが発生しました")).toBeInTheDocument();
});
```

## スナップショットテスト

UI コンポーネントに予期せずリグレッションが発生していないかの検証として、スナップショットテストが活用できる。
:::details リグレッションとは？
あるソフトウェアの新しい機能追加やバグ修正が行われた際に、以前正常に動作していた機能が予期しない不具合を発生する現象のこと。
:::
スナップショットテストの基本的な考え方は、最初のテスト実行時にコンポーネントの出力をキャプチャし、その結果をテストの「スナップショット」として保存する。次回以降のテスト実行時には、コンポーネントの出力と保存されたスナップショットを比較し、一致しない場合にはテストが失敗するようになる。

スナップショットテストは、テストが自動化されているため、UI コンポーネントが予期せずに変更された場合に早期に検出できる。
また、UI のレイアウトやスタイルの変更など、視覚的な変更も検知することができる。

### スナップショットテストの流れ

具体的な手順としては以下のようになる。

1. テスト対象の UI コンポーネントをレンダリングする
2. コンポーネントの出力をスナップショットとしてキャプチャする
3. 初回実行時の場合は、スナップショットを保存する
4. 2 回目以降の実行時には、キャプチャしたスナップショットと保存されたスナップショットを比較する
   - 一致する場合はテストをパスする
   - 不一致の場合はテストが失敗する。必要に応じてスナップショットを確認し、スナップショットの更新を行う

### スナップショットテストを実装する

React には、スナップショットテストをサポートするいくつかのツールがある。
その中でも最も一般的なのは Jest の`toMatchSnapshot`メソッドで、これを使用すると、コンポーネントの出力をスナップショットとしてキャプチャし、比較することができる。

以下は`toMatchSnapshot`を使用したスナップショットテストの例になる。

```tsx
import React from "react";

export const Button = ({ label }: { label: string }) => {
  return <button>{label}</button>;
};
```

```tsx
test("ボタンに「Clock me」が表示される", () => {
  const { container } = render(<Button label="Click me" />);

  expect(container).toMatchSnapshot();
});
```

このテストでは、`Button`コンポーネントの出力をスナップショットとしてキャプチャし、次回のテスト実行時に保存されたスナップショットと比較する。
初回実行時はテストファイルと同階層に`__snapshots__`が作成され、テストファイルと同じ名称の`.snap`ファイルが出力される。
ファイルは以下のような内容となっており、HTML 文字列化された UI コンポーネントが確認できる。

```snap
// Jest Snapshot v1, https://goo.gl/fbAQLP

exports[`ボタンに「Clock me」が表示される 1`] = `
<div>
  <button>
    Click me
  </button>
</div>
`;
```

この`.snap`ファイルは自動出力されるファイルだが、git 管理対象としてコミットする。
2 回目以降のスナップショットテストは、初回実装時に作成されたスナップショットと現在のコンポーネントの出力とを比較する。
比較が成功すると、テストは成功し、次のテストに進む。

### リグレッションを発生させてみる

2 回目以降のテストで、対象ファイルのコミット済み`.snap`ファイルと、現時点のスナップショットを比較し、差分がある場合にテストを失敗させることがスナップショットテストの基本である。
前述のテストが失敗するよう、`Button`コンポーネントに渡す Props の`label`を`Click`に変更してみる。

```tsx
test("ボタンに「Clock me」が表示される", () => {
  const { container } = render(<Button label="Click" />);

  expect(container).toMatchSnapshot();
});
```

テストを実行すると、変更を加えた箇所に差分が発生し、テストが失敗する。

```shell

$ jest src/sample/Button.test.tsx
 FAIL  src/sample/Button.test.tsx
  ✕ ボタンに「Click me」が表示される (14 ms)

  ● ボタンに「Click me」が表示される

    expect(received).toMatchSnapshot()

    Snapshot name: `ボタンに「Click me」が表示される 1`

    - Snapshot  - 1
    + Received  + 1

      <div>
        <button>
    -     Click me
    +     Click
        </button>
      </div>

      5 |   const { container } = render(<Button label="Click" />);
      6 |
    > 7 |   expect(container).toMatchSnapshot();
        |                     ^
      8 | });
      9 |

      at Object.<anonymous> (src/sample/Button.test.tsx:7:21)

 › 1 snapshot failed.
📦 report is created on: /Users/toyoshimayusei/practice-programing/unittest/__reports__/jest.html
Snapshot Summary
 › 1 snapshot failed from 1 test suite. Inspect your code changes or run `yarn test -u` to update them.
```

### スナップショットを更新する

失敗したテストを成功させるためには、コミット済みのスナップショットを更新する。
テスト実行時に`--updateSnapshot`または`-u`オプションを付与することで、スナップショットは新しい内容に書き変わる。

スナップショットを記録した後も、機能追加や変更により、UI コンポーネントの HTML 出力内容は変わり続けるものである。
発生した差分が意図通りの場合は「変更を許可したもの」として、スナップショットの新しい内容をコミットする。

## クエリー（要素取得 API の優先順位）
