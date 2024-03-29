---
title: "Pandasまとめ"
emoji: "📌"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [pandas, python]
published: false
---

## Pandas のインストール

```shell
poetry add pandas
```

## データフレームの作成

### 二次元配列からデータフレームを作成

```py
import pandas as pd

sample_list = [
  [1, 21, 31],
  [2, 22, 32],
  [3, 23, 33]
]

columns = ['Col1', 'Col2', 'Col3']

df = pd.DaraFrame(data=sample_list, columns=columns)
```

### 辞書リストからデータフレームを作成

```py
import pandas as pd

data = [
    {'名前': 'Alice', '年齢': 25, '都市': '東京'},
    {'名前': 'Bob', '年齢': 30, '都市': '大阪'},
    {'名前': 'Charlie', '年齢': 35, '都市': '名古屋'}
]

df = pd.DataFrame(data)
print(df)
```

```shell
       名前  年齢   都市
0    Alice  25   東京
1      Bob  30   大阪
2  Charlie  35  名古屋
```

## 作成したデータフレームの操作

### データフレームの値を多次元配列で取得

`values` 属性を使用すると、データフレームのすべての値を含む NumPy 配列を取得できる。

```py
import pandas as pd

# DataFrameの作成
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6], 'C': [7, 8, 9]})

# 各行のデータ配列を格納する2次元配列を取得
array_2d = df.values
print(array_2d)
```

出力結果

```shell
array([[1, 4, 7],
       [2, 5, 8],
       [3, 6, 9]])
```

### データフレームから特定の行・列を抽出

#### 先頭から行数指定で抽出

```py
head_df = df.head(3)
```

`head()`メソッドの引数に取得したい行数を指定する。
何も指定しないと 5 行取得する。

#### 最後から行数指定で抽出

```py
tail_df = df.tail()
```

#### 行・列番号を指定して抽出

`iloc()`メソッドを使用する。

```py
import pandas as pd

# DataFrameを作成
df = pd.DataFrame({
    'A': [1, 2, 3, 4],
    'B': ['a', 'b', 'c', 'd'],
    'C': [0.1, 0.2, 0.3, 0.4]
})

# 1行目、1列目の要素を選択
print(df.iloc[0, 0]) # 1

# 2行目から3行目、2列目から3列目の要素を選択
print(df.iloc[1:3, 1:3])
#    B    C
# 1  b  0.2
# 2  c  0.3

# 特定の行と列を選択
print(df.iloc[[0,2], [1,2]])
#    B    C
# 0  a  0.1
# 2  c  0.3

# 特定の行と列を選択 (ブールインデックスを使用)
print(df.iloc[[True, False, True, False], [True, False, True]])
#    A    C
# 0  1  0.1
# 2  3  0.3
```

#### 行名・列名を指定して抽出

`loc()`メソッドを使用する

```py
import pandas as pd

# DataFrameを作成
df = pd.DataFrame({
    'A': [1, 2, 3, 4],
    'B': ['a', 'b', 'c', 'd'],
    'C': [0.1, 0.2, 0.3, 0.4]
}, index=['row1', 'row2', 'row3', 'row4'])

# 'row1'、'row2'、'row3'の'A'列と'C'列を選択
print(df.loc[['row1', 'row2', 'row3'], ['A', 'C']])
#       A    C
# row1  1  0.1
# row2  2  0.2
# row3  3  0.3

# 'row4'の'A'列を10に変更
df.loc['row4', 'A'] = 10
print(df)
#       A  B    C
# row1  1  a  0.1
# row2  2  b  0.2
# row3  3  c  0.3
# row4  10 d  0.4

# 'C'列の値が0.3より大きい行を選択
print(df.loc[df['C'] > 0.3])
#       A  B    C
# row4  10 d  0.4
```

### データフレームにカラムを追加

先頭カラムに `category` を追加する。

```py
category_list = ['カテゴリ1', 'カテゴリ2', 'カテゴリ3']

df.insert(0, 'category', category_list)
```

第一引数 : 追加場所
第二引数 : カラム名
第三引数 : 各行の値

### データフレームから特定のカラムを削除

`drop()` メソッドを使用する。

```py
import pandas as pd

# データフレームを作成する
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6], 'C': [7, 8, 9]})

# B列を除いたデータフレームを作成する
df_without_b = df.drop('B', axis=1)

print(df_without_b)
```

`axis=1` は、「列」を意味する。
特定の行を削除したい場合は `axis=0`

### データフレームのインデックスを新たに割り当てる

`reset_index`メソッドを使用することで、インデックスを割り当てることができる。
このメソッドを呼び出すと、現在のインデックスは通常の列として追加され、新しい連番の整数インデックスが割り当てられる。

```py
import pandas as pd

# サンプルのデータフレームを作成します
data = {'A': [1, 2, 3], 'B': [4, 5, 6]}
df = pd.DataFrame(data, index=['x', 'y', 'z'])

# データフレームのインデックスを振り直します
df_reset = df.reset_index()

print(df_reset)

```

```shell
  index  A  B
0     x  1  4
1     y  2  5
2     z  3  6

```

### データフレームの要素内に関数を適用する

- `apply()` メソッドを使用する
- 要素ごとに関数を適用して新しいシリーズやデータフレームを生成できる
- データの変換、処理、計算、フィルタリングなど、様々なデータ操作に使用できる

#### 任意の列の値を 2 倍にする

```py
import pandas as pd

# サンプルのデータを作成
data = {'A': [1, 2, 3, 4], 'B': [5, 6, 7, 8]}
df = pd.DataFrame(data)

# 関数を定義
def double(x):
    return x * 2

# シリーズに関数を適用
df['A'] = df['A'].apply(double)

print(df)

```

この例では、`double()` が各要素に適用され、`A` 列の値が 2 倍になる。

#### 既存列から新規の列を作成する

```py
import pandas as pd

# サンプルのデータを作成
data = {'A': [1, 2, 3, 4], 'B': [5, 6, 7, 8]}
df = pd.DataFrame(data)

# 関数を定義
def sum_row(row):
    return row['A'] + row['B']

# データフレームの各行に関数を適用
df['Sum'] = df.apply(sum_row, axis=1)

print(df)

```

この例では、`sum_row()` が各行に適用され、`A` 列と `B` 列の合計値が計算された `Sum` 列が生成される。

#### `axis`

- `axis` は、処理の対象となる軸方向を指定するためのパラメータ
- 2 種類のオプションがある

1. **`axis=0`**（デフォルト値）
   - 操作が列方向に適用される
   - つまり、各列に対して関数が適用される
2. **`axis=1`**
   - 操作が行方向に適用される
   - つまり、各行に対して関数が適用される

**具体例**

```py
import pandas as pd

# サンプルのデータを作成
data = {'A': [1, 2, 3, 4], 'B': [5, 6, 7, 8]}
df = pd.DataFrame(data)

# 関数を定義して各列に適用 (列ごとに2倍にする)
def double_column(column):
    return column * 2

result_column = df.apply(double_column, axis=0)

# 関数を定義して各行に適用 (行ごとに2倍にする)
def double_row(row):
    return row * 2

result_row = df.apply(double_row, axis=1)

print("列ごとに2倍:")
print(result_column)

print("行ごとに2倍:")
print(result_row)
```

```shell
列ごとに2倍:
   A   B
0  2  10
1  4  12
2  6  14
3  8  16

行ごとに2倍:
   A   B
0  2  10
1  4  12
2  6  14
3  8  16
```

`reset_index`メソッドは、オプションとして`drop`引数を受け取る。
デフォルトでは`drop=False`で、`drop=True`と設定すると、元のインデックスは削除され、新しい連番の整数インデックスが作成される。

## テキストファイルからデータフレームを作成

`pandas.read_csv()` を使用する。
ただし、ただし、`read_csv()` は CSV 形式のファイルを読み込むための関数であり、区切り文字が違う場合は引数で指定する必要がある。

タブ区切りのテキストファイルからデータフレームを作成する場合は、以下のようにする。

```py
import pandas as pd

df = pd.read_csv('text_file.txt', sep='\t', index_col=0)
```

`text_file.txt` は読み込みたいテキストファイルのファイル名であり、`sep='\t'` はタブを区切り文字として使用することを示している。区切り文字がカンマであれば、sep=','と指定する。
`index_col` でインデックスに使いたいカラムを指定する。

また、テキストファイルにヘッダーがなく、最初の行がデータの始まりである場合は、以下のように引数 `header=None` を追加する。

```py
df = pd.read_csv('text_file.txt', sep='\t', header=None)
```

### カラム名を指定してデータフレームを作成する

`read_csv`関数でテキストファイルからデータフレームを作成する場合、カラム名を指定する方法は複数あります。以下にいくつかの方法を示します。

**1. `header`引数を使用する方法**
`header`引数を使用して、カラム名を指定することができます。この方法は、テキストファイルの先頭行にカラム名が含まれている場合に有効です。例えば、以下のようなテキストファイル`data.csv`があるとします。

```shell
id,name,age
1,Alice,25
2,Bob,30
3,Charlie,35
```

この場合、以下のように read_csv 関数を呼び出して、カラム名を指定することができます。

```py
import pandas as pd

df = pd.read_csv('data2.csv', header=None, names=['id', 'name', 'age'])
```

**2. `names`引数を使用する方法**
`names`引数を使用して、カラム名を指定することができます。この方法は、テキストファイルの先頭行にカラム名が含まれていない場合に有効です。例えば、以下のようなテキストファイル`data2.csv`があるとします。

```shell
1,Alice,25
2,Bob,30
3,Charlie,35
```

この場合、以下のように`read_csv`関数を呼び出して、カラム名を指定することができます。

```py
import pandas as pd

df = pd.read_csv('data2.csv', header=None, names=['id', 'name', 'age'])
```

`header=None`で先頭行をカラム名として使用しないことを指定し、`names`でカラム名を指定します。

**3. `rename`メソッドを使用する方法**
`rename`メソッドを使用して、既存のデータフレームのカラム名を変更することができます。例えば、以下のようなデータフレーム`df`があるとします。

```py
import pandas as pd

data = {'id': [1, 2, 3], 'name': ['Alice', 'Bob', 'Charlie'], 'age': [25, 30, 35]}
df = pd.DataFrame(data)
```

この場合、以下のように`rename`メソッドを使用して、カラム名を変更することができます。

```py
df = df.rename(columns={'id': 'ID', 'name': 'Name', 'age': 'Age'})
```

上記のコードでは、`id`カラムを`ID`、`name`カラムを`Name`、`age`カラムを`Age`に変更しています。

## データフレームをテキストファイルに出力

`to_csv()` を使用する。

```py
df.to_csv('output_file.csv', index=False)
```

`output_file.csv` は出力するテキストファイルのファイル名であり、`index=False` は行のインデックスを出力しないことを示してい

データフレームをタブ区切りのテキストファイルに出力する場合は、`to_csv()` メソッドの `sep` 引数に `\t` を指定する。

```py
df.to_csv('output_file.txt', sep='\t', index=False)
```

## 参考リンク

https://ai-inter1.com/pandas-dataframe_basic/#st-toc-h-18
