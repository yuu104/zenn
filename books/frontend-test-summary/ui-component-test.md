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

```ts
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

## クエリー（要素取得 API の優先順位）
