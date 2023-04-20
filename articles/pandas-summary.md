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

# データフレームにカラムを追加

先頭カラムに `category` を追加する。

```py
category_list = ['カテゴリ1', 'カテゴリ2', 'カテゴリ3']

df.insert(0, 'category', category_list)
```

第一引数 : 追加場所
第二引数 : カラム名
第三引数 : 各行の値
