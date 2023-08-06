---
title: "XML"
---

## XML とは

- マークアップ言語の一つ
- HTML が文書の構造や見た目をマークアップするのに対し、XML はデータ構造をマークアップする
- XML は自由にタグを設定し、使用することが可能

XML は以下のような特徴を持っている

### タグ

XML は開始タグ（`<tag>`）と終了タグ（`</tag>`）で囲まれた要素を使って情報を示す。
例えば、以下のような XML 要素がある。

```xml
<person>
<name>John Doe</name>
<age>30</age>
<email>john@example.com</email>
</person>
```

### 階層構造

XML では要素を入れ子にすることで、複雑な階層構造を表現している。
例えば、`person` 要素は `name`、`age`、`email`の３つの要素を持っている。

### 属性

要素には属性を持たせることもできる。
属性は要素の開始タグ内に記述され、要素自体の情報を補完するために使われる。

```xml
<book ISBN="123456789">
<title>XML for Beginners</title>
<author>Jane Smith</author>
</book>
```

### 拡張性

XML は任意の要素や属性を定義することができる。
この特性により、特定のアプリケーションやデータモデルに合わせて XML をカスタマイズできる。

### 読み取りやすさ

XML では**パーサー**と呼ばれる変換プログラムを使って、容易にデータを抽出できる。

以下に具体的な例を示す。

```xml
<books>
<book>
  <title>XML for Beginners</title>
  <author>Jane Smith</author>
  <price>25.99</price>
</book>
<book>
  <title>Advanced XML Techniques</title>
  <author>John Doe</author>
  <price>32.50</price>
</book>
</books>

```

この XML データは、複数の本の情報を含んでいる。パーサーを使用して、このデータから本のタイトル、著者、価格などの情報を抽出することができる。
Python の XML パーサーライブラリである `xml.etree.ElementTree`` を使って、この XML データから情報を抽出する例を示す。

```py
import xml.etree.ElementTree as ET

# XMLデータ
xml_data = '''
<books>
<book>
  <title>XML for Beginners</title>
  <author>Jane Smith</author>
  <price>25.99</price>
</book>
<book>
  <title>Advanced XML Techniques</title>
  <author>John Doe</author>
  <price>32.50</price>
</book>
</books>
'''

# XMLデータをパースする
root = ET.fromstring(xml_data)

# パースしたデータから情報を抽出する
for book in root.findall('book'):
  title = book.find('title').text
  author = book.find('author').text
  price = float(book.find('price').text)
  print(f"Title: {title}, Author: {author}, Price: {price}")

```

この例では、XML データをパースして title、author、price 要素の値を抽出し、それらの情報を出力している。

XML はパーサーによって簡単にデータを抽出できるため、XML はアプリケーション間のデータ連携に利用されやすく、インターネットを介したデータの共有に長けている。
また、HTML と同様にテキスト形式を採用しており、特定の環境に依存することなく、人の手でデータの加工を行うことができる。
