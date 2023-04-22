---
title: "Pandasまとめ"
emoji: "📌"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [pandas, python]
published: false
---

# Pandas のインストール

```shell
poetry add pandas
```

# 二次元配列からデータフレームを作成

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

# 作成したデータフレームの操作

## データフレームから各行のデータを取得

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

## データフレームにカラムを追加

先頭カラムに `category` を追加する。

```py
category_list = ['カテゴリ1', 'カテゴリ2', 'カテゴリ3']

df.insert(0, 'category', category_list)
```

第一引数 : 追加場所
第二引数 : カラム名
第三引数 : 各行の値

## データフレームから特定のカラムを削除

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

# データフレームの入出力

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
