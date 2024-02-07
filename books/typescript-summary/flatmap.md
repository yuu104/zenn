---
title: "flatMap"
---

## `flatMap()` とは？

- 配列に対して使用するメソッド
- 配列の各要素に関数を適用し、その結果を新しい配列に平坦化（フラット化）して返す
- つまり、`map()` と `flat()` の組み合わせ

## 動作の仕組み

1. **マッピング**
   - まず、`map()` のように、配列の各要素に対して関数を適用し、処理を行う
2. **平坦化**
   - その後、関数の結果を一つの配列に平坦化する
   - これにより、配列の配列が単一の配列になる

`flat()` の使用例としてはこんな感じ。

```ts
const arr1 = [0, 1, 2, [3, 4]];

console.log(arr1.flat());
// expected output: [0, 1, 2, 3, 4]
```

## 構文

```ts
array.flatMap(callback);
```

- **`array`** : 変換する元の配列
- **`callback`** : 各要素に適用する関数

## 例

```ts
let arrays = [
  [1, 2, 3],
  [4, 5, 6],
];

// 各配列に1を足して平坦化
let flatMapped = arrays.flatMap((arr) => arr.map((x) => x + 1));

console.log(flatMapped); // 出力: [2, 3, 4, 5, 6, 7]
```

## 使い所

### 条件を満たした要素のみ抽出して処理する。

https://zenn.dev/tsucchiiinoko/articles/9448ea5f50c3b3#%E8%A6%81%E7%B4%A0%E3%81%AE%E6%8A%BD%E5%87%BA

以下は、`string | number` 型の配列から、`number` 型の値のみ抽出し、処理する場合。

```ts
const array = ["aaa", "bbb", 1, 2];

// `map()`の場合
const mapResult = hoge.map((v) => (typeof v === "number" ? v * 2 : [])); // [[], [], 2, 4]

// `flatMap()`の場合
const flatMapResult = hoge.flatMap((v) => (typeof v === "number" ? v * 2 : [])); // [2, 4]
```

オブジェクトの場合は下記の通り。

```ts
const hoge: HogeType = { a: "aaa", b: "bbb", c: 1, d: 2 };

// `map()`の場合
const mapResult = Object.values(hoge).map((v) =>
  typeof v === "number" ? v * 2 : []
); // [[], [], 2, 4]

// `flatMap()`の場合
const flatMapResut = Object.values(hoge).flatMap((v) =>
  typeof v === "number" ? v * 2 : []
); // [2, 4]
```

- ポイントとして、条件に当てはまらない（元配列から除外したい）場合は `[]` を返すこと
- これにより、`map()` で `[[], [], 2, 4]` となっていたものが、
  `flatMap()` で空配列が除去され、`[2, 4]` が抽出される

### 配列のフィルタリング時に、型もフィルタリングする

https://zenn.dev/spacemarket/articles/51613197db688d

配列のフィルタリングを行う際は `filter()` を使うと思う。

```ts
const nullableArray: Array<string | null> = ["hoge", null, "fuga"];

const array = nullableArray.filter((data) => {
  return !!data;
}); // ["hoge", "fuga"]
```

ただ、この場合だと型定義としては `null` が排除されたことを認知できず、変数 `array` の型は引き続き `Array<string | null>` と認識されてしまう。

フィルタリング後に生成される配列の型を `Array<string>` にしたい場合、以下の 2 通りがある。

- `is` を使って絞り込む
- `flatMap` を使う

#### `is` を使って絞り込む

```ts
const nullableArray: Array<string | null> = ["hoge", null, "fuga"];

// isを使ってdataに型を当てる
const array = nullableArray.filter((data): data is string => {
  return !!data;
});

// `array`の型は`Array<string>`となる
```

しかし、`is` で型を当てはめた場合は、絞り込みの処理に関わらず強制的にその型が当たる。

```ts
const nullableArray: Array<string | null> = ["hoge", null, "fuga"];

const array = nullableArray.filter((data): data is string => {
  return !data; // 誤った処理をしてしまう
});
console.log(array); // => 型定義は `Array<string>` だが実際のデータでは `[null]` となってしまう
```

#### `flatMap` を使う

```ts
const nullableArray: Array<string | null> = ["hoge", null, "fuga"];

const array = nullableArray.flatMap((data) => {
  return data ?? [];
});
```

上記のように、`data` が `nullable` な値だった場合に空配列を `return` するようにすれば新たに生成する配列からは排除され、変数 `array` は型定義も実際のデータも `Array<string>` にすることができる。

もし仮に、以下のように実際の処理を間違えたとしても

```ts
const nullableArray: Array<string | null> = ['hoge', null, 'fuga']

const array = nullableArray.flatMap((data) => {
  return !data ?? : [] // => 間違った記述をしてしまう
})
```

これだとそもそも array の型定義が `Array<string>` にはならないため、記述のミスに気づくことができる。
また、加えて変数定義時に const `array: Array<string> = ...` と期待値を明記しておくとより記述ミスに気付きやすい。

## `flatMap` 内で非同期処理を行う

```ts
type User = {
  id: string;
  name: string;
};

const getUserInfo = async (ownUserId: string): Promise<User[]> => {
  const userInfo = await Promise.all(
    userIds
      .flatMap(async (userId) => {
        if (userId === ownUserId) return [];
        const userInfo = await fetchUserInfo(userId);
        return userInfo;
      })
      .flat() // 最後に`flat()`する必要がある
  );
};

const userInfo = await getUserInfo("id-1");

// `flat()`しないと、`userInfo`の型は`{id: string; name: string:}[][]`
// `flat()`すると、`userInfo`の型は`{id: string; name: string:}[]`
```
