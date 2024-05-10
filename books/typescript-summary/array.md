---
title: "配列"
---

## 先頭に要素を追加する

TypeScript で配列の先頭に要素を追加するには、`unshift` メソッドを使う。例えば、配列 `numbers` に新しい要素`0` を追加する場合、以下のように書く。

```typescript
let numbers = [1, 2, 3];
numbers.unshift(0);
```

このコードを実行すると、`numbers` 配列は `[0, 1, 2, 3]` になる。

## 先頭の要素を削除する

TypeScript で配列の先頭の要素を削除するには、`shift`メソッドを使用する。例として配列`numbers`から先頭の要素を削除するコードは次のようになる。

```typescript
let numbers = [1, 2, 3];
numbers.shift();
```

この操作後、`numbers`配列は`[2, 3]`になる。

メソッドの戻り値は削除された要素。
配列が空の場合、 `undefined` を返す。

## 末尾の要素を削除する

末尾の要素を削除するには、`pop`メソッドを使用する。このメソッドは配列から最後の要素を削除し、その要素を返す。配列が空の場合、`pop`は`undefined`を返す。この操作は配列自体を変更する。

### 特徴

- **変更性**: `pop`は元の配列を変更する。
- **計算量**: O(1)の時間計算量を持つ。これは末尾の要素を削除するのに他の要素を移動する必要がないため。
- **返り値**: 削除された最後の要素、または配列が空の場合は`undefined`。

### 使用例

配列が複数の要素を含む場合:

```typescript
let numbers = [10, 20, 30, 40];
let lastNumber = numbers.pop(); // lastNumberは40, numbersは[10, 20, 30]
```

配列が空の場合:

```typescript
let numbers = [];
let result = numbers.pop(); // resultはundefined, numbersは依然として空のまま
```

`pop`メソッドは特にデータが後入れ先出し（LIFO）の順序で処理されるスタックの実装に適しており、配列の末尾から要素を順に取り出す場合に有用です。

## `splice` メソッド

- 配列を操作するための強力なツール
- 指定した位置から任意の数の要素を削除し、必要に応じて新しい要素を追加できる
- このメソッドは元の配列を変更する

### 基本構文

```typescript
array.splice(start, deleteCount, ...itemsToAdd);
```

- **start**: 要素を削除または追加する開始位置。
- **deleteCount**: 削除する要素の数。0 の場合、要素は削除されず新しい要素が挿入される。
- **itemsToAdd**: 配列に追加する新しい要素。省略可能。

### 特徴

- **多機能性**: 要素の削除、追加、置換が一度に行える。
- **返り値**: 削除された要素の配列を返す。何も削除されない場合は空の配列を返す。
- **変更性**: `splice`は元の配列自体を変更する。

### 使用例

1. **要素の削除**

   ```typescript
   let numbers = [1, 2, 3, 4, 5];
   let removed = numbers.splice(1, 2); // [2, 3]が削除され、numbersは[1, 4, 5]
   ```

2. **要素の追加**

   ```typescript
   let numbers = [1, 2, 3, 4, 5];
   numbers.splice(2, 0, 99, 100); // 位置2に99と100を追加、numbersは[1, 2, 99, 100, 3, 4, 5]
   ```

3. **要素の置換**
   ```typescript
   let numbers = [1, 2, 3, 4, 5];
   numbers.splice(1, 3, 8, 9); // 位置1から3要素を削除し、8と9を追加、numbersは[1, 8, 9, 4, 5]
   ```

`splice`メソッドは配列内の要素を柔軟に操作する必要がある場合に非常に便利です。

## 指定した要素を指定した数だけ含む配列を生成する

`Array` コンストラクタと `fill` メソッドを使って簡単に実現できる。

```typescript
function createArray(element, count) {
  // 指定された長さで新しい配列を作成し、指定された要素で全て埋める
  return Array(count).fill(element);
}

// 使用例
let repeatedArray = createArray("a", 5); // 結果: ['a', 'a', 'a', 'a', 'a']
```

### `Array` コンストラクタ

新しい配列オブジェクトを作成するために使用され、様々な方法で配列を初期化できる。

1. **引数なし**
   空の配列を作成する。

   ```ts
   let emptyArray = new Array();
   ```

2. **数値を 1 つ指定**
   指定された長さの配列を作成する。

   ```ts
   let arrayWithSize = new Array(5); // 長さ5の空配列
   ```

3. **複数の要素を指定**
   指定された要素で配列を初期化する。

   ```ts
   let arrayWithElements = new Array("a", "b", "c");
   ```

**`new` キーワードは省略できる。**

### `fill` メソッド

- 配列のすべての要素を、静的な値で一括して上書きするために使用される
- 元の配列をす更し、変更後の配列への参照を返す

`fill(value)` は配列すべての要素を `value` で埋める。

```ts
let numbers = [1, 2, 3];
numbers.fill(0); // [0, 0, 0]
```

`fill(value, start, end)` は `start` インデックスから `end` インデックスまでの範囲を `value` で埋める。

## 指定した要素のインデックスを取得する

### `indexOf` メソッド

- 先頭から検索し、最初に該当するインデックスを取得する
- 要素が見つからない場合は `-1` を返す
- 第二引数として検索開始位置を指定することができる

### `lastIndexOf` メソッド

`indexOf` の逆。

```ts
let array = ["apple", "banana", "cherry", "banana"];
let lastIndex = array.lastIndexOf("banana"); // 3
```

## `join` メソッド ~ 配列を文字列に変換する

配列の要素を指定した文字列で連結し、一つの文字列として返す。

```ts
let elements = ["Fire", "Air", "Water", "Earth"];
let result = elements.join(); // "Fire,Air,Water,Earth"
let resultWithDash = elements.join(" - "); // "Fire - Air - Water - Earth"
```

## `slice` メソッド ~ 配列の一部を切り出す

- 配列の一部を**浅く**コピーし、新たな配列を生成する
- 元の配列に影響を与えない

```ts
array.slice(start, end);
```

- `start` : 切り出す要素の開始位置
- `end` : 切り出す要素の最後の位置 + 1。省略された場合は末尾まで選択される。
- それぞれ、負の値を指定すると、末尾からの位置になる

## `sort` メソッド ~ 配列をソートする

- 元の配列を変更する
- ソートされた配列の参照を返す

### 基本構文

```ts
array.sort(compareFunction);
```

- `compareFunction` はオプショナルな比較関数
- 指定しない場合は要素を文字列とみなし、Unicode 順にソートする
- 比較関数は二つの引数を取り、それぞれを比較して以下のルールに従って値を返す
  - **負の値** : 最初の引数が前に来る
  - **ゼロ** : 両者の順序は変わらない
  - **正の値** : 第二引数が前に来る

### 数値のソート

数値が文字列として評価されるため、比較関数を使用する。

```ts
let numbers = [10, 5, 40, 25, 1000];
numbers.sort((a, b) => a - b); // 昇順にソート
```

### 文字列のソート

文字列をソートする際は、比較関数なしでそのまま使用することが多いが、大文字小文字を区別せずにソートしたい場合は、比較関数内で文字列を同一のケース（大文字または小文字）に変換する必要がある。

```ts
let words = ["banana", "Apple", "cherry"];
words.sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
```

### オブジェクトのソート

```ts
let people = [
  { name: "John", age: 25 },
  { name: "Jane", age: 21 },
];
people.sort((a, b) => a.age - b.age);
```

## `findIndex` メソッド ~ 条件を満たす最初のインデックスを返す

`findIndex`メソッドは配列内の要素が指定したテスト関数を満たす最初のインデックスを返す。条件を満たす要素がない場合は-1 を返す。このメソッドは配列の要素を先頭から順に評価し、条件を満たす最初の要素のインデックスを見つけると検索を停止する。

#### 基本構文:

```typescript
array.findIndex(callback(element, index, array), thisArg);
```

- **callback**: 各要素に対して実行される関数。この関数が真と評価する値を返したとき、その要素のインデックスが`findIndex`によって返される。
  - **element**: 配列内の現在処理されている要素。
  - **index**: 処理されている要素のインデックス。
  - **array**: `findIndex`が呼び出された配列。
- **thisArg**: `callback`関数内で使用される`this`の値。

#### 使用例:

```typescript
let numbers = [5, 12, 8, 130, 44];
let index = numbers.findIndex((element) => element > 13); // 3
```

この例では、`13`より大きい最初の要素のインデックス（130 があるインデックス）を検索している。130 は配列の中で 4 番目の位置にあるため、インデックス`3`が返される。

## `every` メソッド ~ 全ての要素が条件を満たすかチェックする

`every` メソッドは配列のすべての要素が指定されたテスト関数を満たすかどうかを確認する。全ての要素が条件を満たす場合は `true` を返し、一つでも満たさない要素があれば `false` を返す。このメソッドは配列の要素を先頭から順に評価し、条件を満たさない要素を見つけると直ちに検索を停止して `false` を返す。

### 基本構文:

```typescript
array.every(callback(element, index, array), thisArg);
```

- **callback**: 各要素に対して実行されるテスト関数。
  - **element**: 配列内の現在処理されている要素。
  - **index**: 処理されている要素のインデックス。
  - **array**: `every` が呼び出された配列。
- **thisArg**: `callback` 関数内で使用される `this` の値。

### 使用例:

```typescript
let numbers = [2, 4, 6, 8, 10];
let allEven = numbers.every((num) => num % 2 === 0); // true
```

この例では、配列内のすべての数が偶数であるかどうかをチェックしている。全ての数が偶数であるため、結果は `true` となる。

### 特徴と利用シナリオ:

- **全体の検証**: `every` は配列の全ての要素が一定の条件を満たすかを確認するのに適している。
- **即時終了**: 条件を満たさない要素が見つかった時点で検索が停止し、`false` が返される。
- **非破壊的**: このメソッドは元の配列を変更せず、テストの結果のみを返す。
