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
