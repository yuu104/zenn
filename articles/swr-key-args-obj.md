---
title: "SWRのkeyパラメータにオブジェクト型の値を渡すとどのように処理されるのか？"
emoji: "🐙"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, typescript, swr, vercel]
published: false
---

SWR は、リアルタイムのデータ取得とキャッシュの管理を簡潔に行うことができる React のデータフェッチライブラリです。
https://swr.vercel.app/ja

SWR の基本的な使い方としては、以下の通りです。

```ts
import useSWR from "swr";

function Profile() {
  const { data, error } = useSWR("/api/users", fetcher);

  if (error) return <div>failed to load</div>;
  if (!data) return <div>loading...</div>;

  return <div>hello {data.name}!</div>;
}
```

`useSWR()`フックの第一引数には`key`と呼ばれるものを指定します。
`key`は第二引数にあるフェッチ関数に渡すパラメータであり、取得データのキャッシュを識別するためのキーとしも使用されます。
「取得データのキャッシュを識別する」ため、`key`にはユニークな識別子を渡す必要があります。
`key`には API のエンドポイントなど、取得するデータごとにユニークな文字列を指定することが一般的です。

```ts
// ユーザ一覧を取得する
useSWR("/api/users", fetcher);

// 特定のユーザを取得する
useSWR(`/api/users/${id}`);
```

しかし、`key`には配列や関数、オブジェクトなども指定できるそうです。

```ts
// 配列を key パラメーターとして使用することで、複数の引数を`fetcher`に渡せる
const { data: user } = useSWR(["/api/user", token], ([url, token]) =>
  fetchWithToken(url, token)
);

// オブジェクトを key として渡す
const { data: orders } = useSWR({ url: "/api/orders", args: user }, fetcher);

// 関数を key として渡す
const { data } = useSWR(() => (shouldFetch ? "/api/data" : null), fetcher);
```

上記で挙げたオブジェクト型の値を`key`パラメータに指定した場合、キャッシュキーはどのようになるのでしょうか？
SWR の公式ドキュメントには以下のような記載がありました。

配列の場合

> キャッシュキーもまた key の引数全てと関連づけられます。上記の例では url と token の組み合わせがキャッシュキーとなります。

オブジェクトの場合

> SWR 1.1.0 からは、オブジェクトのようなキーは内部で自動的にシリアライズされます。

どうやら、オブジェクト型の値を`key`パラメータに指定した場合、SWR が内部で値の構造を基にシリアライズし、文字列に変換してキャッシュキーを生成しているようです。

公式ドキュメントでは上記のように記載されていますが、より具体的な処理内容が気になります...
そもそも本当にオブジェクト型を指定してもキャッシュキーとして管理してくれるのだろうか？
`Date`型とか指定しても大丈夫？？
そこで、`key`にオブジェクト型の値が指定されたときの処理内容を SWR のソースコードを読んで確認してみました。

https://github.com/vercel/swr

:::message
2023/7/23 の `main` ブランチにおける最新コードを参照しています。
:::

## `useSWR()`フックの中身

まずは、`useSWR()`フックの中身を見てみます。
フック内のコードが長かったので、一部分だけ切り取って表示しています。

```ts
export const useSWRHandler = <Data = any, Error = any>(
  _key: Key,
  fetcher: Fetcher<Data> | null,
  config: FullConfiguration & SWRConfiguration<Data, Error>
) => {
  const {
    cache,
    compare,
    suspense,
    fallbackData,
    revalidateOnMount,
    revalidateIfStale,
    refreshInterval,
    refreshWhenHidden,
    refreshWhenOffline,
    keepPreviousData
  } = config

  const [EVENT_REVALIDATORS, MUTATION, FETCH, PRELOAD] = SWRGlobalState.get(
    cache
  ) as GlobalState

  // `key` is the identifier of the SWR internal state,
  // `fnArg` is the argument/arguments parsed from the key, which will be passed
  // to the fetcher.
  // All of them are derived from `_key`.
  const [key, fnArg] = serialize(_key)

  // If it's the initial render of this hook.
  const initialMountedRef = useRef(false)

  // If the hook is unmounted already. This will be used to prevent some effects
  // to be called after unmounting.
  const unmountedRef = useRef(false)

  // Refs to keep the key and config.
  const keyRef = useRef(key)
  const fetcherRef = useRef(fetcher)
  const configRef = useRef(config)
  const getConfig = () => configRef.current
  const isActive = () => getConfig().isVisible() && getConfig().isOnline()


// 長いので省略
```

`useSWRHandler()`の引数に各パラメータの定義があります。
今回注目する`key`は`_key`になりますね。

そして、下記の部分で`_key`を`serialize()`関数の引数に指定し、`useSWR()`で指定した値をシリアライズしているようです。
関数の戻り値は、コメントによると

- `key` : シリアライズされた SWR のキャッシュキー
- `fnArg` : フェッチャー関数に渡される値

とのことです。

```ts
// `key` is the identifier of the SWR internal state,
// `fnArg` is the argument/arguments parsed from the key, which will be passed
// to the fetcher.
// All of them are derived from `_key`.
const [key, fnArg] = serialize(_key);
```

## `serialize()`関数の中身

関数内の処理を一つずつ見ていきます。

```ts
import { stableHash } from "./hash";
import { isFunction } from "./shared";

import type { Key, Arguments } from "../types";

export const serialize = (key: Key): [string, Arguments] => {
  if (isFunction(key)) {
    try {
      key = key();
    } catch (err) {
      // dependencies not ready
      key = "";
    }
  }

  // Use the original key as the argument of fetcher. This can be a string or an
  // array of values.
  const args = key;

  // If key is not falsy, or not an empty array, hash it.
  key =
    typeof key == "string"
      ? key
      : (Array.isArray(key) ? key.length : key)
      ? stableHash(key)
      : "";

  return [key, args];
};
```

- `key` が関数の場合 : 関数を実行し、実行結果をキャッシュキーとしている
- `key` が `string` 型の場合 : `key` をそのままキャッシュキーとする
- それ以外の場合 : `stableHash()`関数を実行し、その戻り値をキャッシュキーとする

`stableHash`という名前にあるように、`key`が配列やオブジェクトの場合は、その値を基にハッシュ化を行い、文字列を生成しているようです。

## `stableHash`関数の中身

```ts
import { OBJECT, isUndefined } from "./shared";

// use WeakMap to store the object->key mapping
// so the objects can be garbage collected.
// WeakMap uses a hashtable under the hood, so the lookup
// complexity is almost O(1).
const table = new WeakMap<object, number | string>();

// counter of the key
let counter = 0;

// A stable hash implementation that supports:
// - Fast and ensures unique hash properties
// - Handles unserializable values
// - Handles object key ordering
// - Generates short results
//
// This is not a serialization function, and the result is not guaranteed to be
// parsable.
export const stableHash = (arg: any): string => {
  const type = typeof arg;
  const constructor = arg && arg.constructor;
  const isDate = constructor == Date;

  let result: any;
  let index: any;

  if (OBJECT(arg) === arg && !isDate && constructor != RegExp) {
    // Object/function, not null/date/regexp. Use WeakMap to store the id first.
    // If it's already hashed, directly return the result.
    result = table.get(arg);
    if (result) return result;

    // Store the hash first for circular reference detection before entering the
    // recursive `stableHash` calls.
    // For other objects like set and map, we use this id directly as the hash.
    result = ++counter + "~";
    table.set(arg, result);

    if (constructor == Array) {
      // Array.
      result = "@";
      for (index = 0; index < arg.length; index++) {
        result += stableHash(arg[index]) + ",";
      }
      table.set(arg, result);
    }
    if (constructor == OBJECT) {
      // Object, sort keys.
      result = "#";
      const keys = OBJECT.keys(arg).sort();
      while (!isUndefined((index = keys.pop() as string))) {
        if (!isUndefined(arg[index])) {
          result += index + ":" + stableHash(arg[index]) + ",";
        }
      }
      table.set(arg, result);
    }
  } else {
    result = isDate
      ? arg.toJSON()
      : type == "symbol"
      ? arg.toString()
      : type == "string"
      ? JSON.stringify(arg)
      : "" + arg;
  }

  return result;
};
```

こちらの関数では、引数として受け取った`arg`の構造を以下の分類によって処理を分けています。

- 配列
- オブジェクト
- それ以外の `Date`, `Symbol`, `string` など

配列やオブジェクトの場合は、各要素を再起的に走査し、ハッシュ値を生成して連結した文字列をキャッシュキーとしています。
このとき、`const table = new WeakMap<object, number | string>()` で定義した `WeakMap`オブジェクトに、オブジェクト・配列の値とそのハッシュ値のペアを格納しています。
これにより、同じ値のオブジェクトや配列が`useSWR()`の`key`に指定された場合でも、再度ハッシュ化の処理をしなくても済むようにしていますね。

それ以外の `Date`, `Symbol`, `string` などの場合は、値をそのまま文字列に変換し、キャッシュキーとしています。

### まとめ

SWR のソースコードを読むことで、以下のことを確認できました。

- `useSWR()`の`key`パラメータにオブジェクトや配列を指定した場合、その値を基に SWR 内部でキャッシュキーとなる文字列を生成してくれる
- `Date`型や`Symbol`型を指定することも可能
