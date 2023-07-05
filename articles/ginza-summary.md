---
title: "GiNZAまとめ"
emoji: "🎉"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [python, ginza, spacy]
published: false
---

## GiNZA とは

- GiNZA は自然言語処理ライブラリ
- 欧米で使用されている自然言語処理ライブラリ「spaCy」を日本語に対応させたもの
- 形態素解析、係り受け解析が可能
- `pip install` で簡単にインストールできる
- GiNZA は自然言語処理ライブラリの「spaCy」と形態素解析器である「SudachiPy」の 2 つで構成されている

## 解析速度について

形態素・係り受け解析ライブラリの Chabocha と比べると結構遅くなる。
他のライブラリとの速度比較の詳細は下記リンクを参照。
https://qiita.com/suzuki_sh/items/69fd5b9bb0b8b7c7f720#%E3%81%BE%E3%81%A8%E3%82%81

## GiNZA でできること

- 文境界解析
- 形態素解析
- 係り受け解析
- 固有表現抽出
- 文節抽出
- 類似度算出

## ライブラリをインストール

```shell
pip install -U ginza ja_ginza_electra
```

## モデルをロードする

```py
import spacy

nlp = spacy.load("ja_ginza_electra")
```

まず、上記のように `spaCy`をインポートし、`spacy.load()`で GiNZA のモデルをロードする。
慣例として、ロードしたモデルは`nlp`という変数名で保持する。

## 文章を解析する

文章の解析は、`nlp`に解析したいテキストを渡すだけ。
`doc`には、解析済みの`Doc`オブジェクトが返る。
この時点で、トークン化、品詞のタギング、依存関係のラベリング、固有表現抽出などの処理が完了している。

```py
doc = nlp('spaCy はオープンソースの自然言語処理ライブラリです。学習済みの統計モデルと単語ベクトルが付属しています。')
```

## `Doc`オブジェクト

`Doc`オブジェクトには便利なメソッドが定義されており、解析したテキストを文単位に分割したり

```py
doc =nlp('spaCy はオープンソースの自然言語処理ライブラリです。学習済みの統計モデルと単語ベクトルが付属しています。')
for s in doc.sents:
    print(s)

# spaCy はオープンソースの自然言語処理ライブラリです。
# 学習済みの統計モデルと単語ベクトルが付属しています。
```

名詞句のみ抽出したり

```py
for np in doc.noun_chunks:
    print(np)

# spaCy
# オープンソース
# 自然言語処理ライブラリ
# 学習済み
# 統計モデル
# 単語ベクトル
```

形態素に分割したりできる。
`Doc`は分割した`Token`を保持するイテレータになっている。

```py
for token in doc:
  print(token.text)

# spaCy
# は
# オープン
# ソース
# の
# 自然
# 言語
# 処理
# ライブラリ
# です
# 。
# 学習
# 済み
# の
# 統計
# モデル
# と
# 単語
# ベクトル
# が
# 付属
# し
# て
# い
# ます
# 。
```

`Doc`オブジェクトの詳しい情報は下記のドキュメントを参照。
https://spacy.io/api/doc

## `Token`オブジェクト

`Token`オブジェクトは、形態素解析されたテキストの各トークンや品詞タグ、依存関係ラベリングを格納する。
`Token`オブジェクトには、以下のような属性がある。

- `i` : トークンのインデックス番号
- `orth_` : トークンの表層形
- `lemma_` : トークンの基本形（原型）
- `pos` : トークンの品詞タグ
- `tag_` : トークンの詳細な品詞情報
- `dep_` : トークンの係り受け関係を示すラベル
- `head` : トークンの係先となるトークンの`Token`オブジェクト
- `is_stop` : トークンがストップワードかどうかを示す真偽値

これらの属性を使用することで、各トークンのテキストや形態素解析によって得られた情報にアクセスすることができる。

```py
import spacy

nlp = spacy.load("ja_ginza_electra")
doc = nlp("私はりんごが好きです")
for sent in doc.sents:
    for token in sent:
        print(
            token.i,
            token.orth_,
            token.lemma_,
            token.pos_,
            token.tag_,
            token.dep_,
            token.head.i,
            token.is_stop,
        )
        print("EOS")

# 0 私 私 PRON 代名詞 dislocated 4 False
# EOS
# 1 は は ADP 助詞-係助詞 case 0 True
# EOS
# 2 りんご りんご NOUN 名詞-普通名詞-一般 nsubj 4 False
# EOS
# 3 が が ADP 助詞-格助詞 case 2 True
# EOS
# 4 好き 好き ADJ 形状詞-一般 ROOT 4 False
# EOS
# 5 です です AUX 助動詞 aux 4 True
# EOS
```

`Token`オブジェクトの詳細は下記のドキュメントを参照。
https://spacy.io/api/token

`pos_`属性、`dep_`属性の詳細は下記を参照。
https://qiita.com/kei_0324/items/400f639b2f185b39a0cf

`tag_`属性の詳細は下記を参照。
https://qiita.com/sakamoto_mi/items/c1787973dd1a591c9957#%E5%93%81%E8%A9%9E%E4%BD%93%E7%B3%BB

## トークンの依存関係をグラフで可視化する

`spacy`の`display`を使用することで、トークンの依存関係を Web 上で簡単に可視化することができる。

```py
import spacy
from spacy import displacy

nlp = spacy.load("ja_ginza_electra")
doc = nlp("私はりんごが好きです")

displacy.serve(doc, style="dep", options={"compact": True}, port=5001)
```

`port`オプションでポート番号を指定できる。
実行後、`Serving on http://0.0.0.0:5001 ...`と表示されるので、アクセスするとグラフが表示される。
![](https://storage.googleapis.com/zenn-user-upload/48b980f68d59-20230705.png)

## 参考リンク

https://megagonlabs.github.io/ginza/

https://qiita.com/cove_ht/items/63ffdd8ff237d4845566

https://megagonlabs.github.io/ginza/bunsetu_api.html

https://megagonlabs.github.io/ginza/command_line_tool.html

https://yu-nix.com/archives/spacy-obj/

https://www.ogis-ri.co.jp/otc/hiroba/technical/similar-document-search/part4.html

https://www.forcia.com/blog/002384.html

https://resanaplaza.com/2022/09/11/%E3%80%90%E5%AE%9F%E8%B7%B5%E3%80%91python%E3%81%A8ginza%E3%81%A7%E4%BF%82%E3%82%8A%E5%8F%97%E3%81%91%E8%A7%A3%E6%9E%90%E3%81%97%E3%82%88%E3%81%86%E3%81%8B%EF%BC%81/

https://resanaplaza.com/2022/10/01/%E3%80%90%E8%B6%85%E4%BE%BF%E5%88%A9%E3%80%91windows%E3%81%AEpython%E3%81%A8ginza%E3%81%A7%E5%BD%A2%E6%85%8B%E7%B4%A0%E8%A7%A3%E6%9E%90%E3%81%A0%EF%BC%81%E8%BE%9E%E6%9B%B8%E7%99%BB%E9%8C%B2%E3%81%A8me/

https://chantastu.hatenablog.com/entry/2023/01/20/210757

https://zenn.dev/mizuiro__sakura/articles/b9de1291fb816d

https://github.com/poyo46/ginza-examples
