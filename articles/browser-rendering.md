---
title: "ブラウザレンダリングの仕組み"
emoji: "📘"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [javascript, web, nextjs, frontend]
published: false
---

ブラウザがリソースを取得後、それらを画面上に表示するための描画処理を行うことを**ブラウザレンダリング**と呼ぶ。
以下がブラウザレンダリングの大まかな流れ。

![](https://storage.googleapis.com/zenn-user-upload/6c4309b8403b-20230715.png)

## HTML のダウンロード

ブラウザははじめに、HTML ファイルをサーバから取得し、読み込む。

## HTML の解析

読み込んだ HTML から DOM ツリーを構築する。
HTML ファイルに対し、上の行から順に解析する。
![](https://storage.googleapis.com/zenn-user-upload/5605775489f7-20230715.png)

## 外部リソースのダウンロード

HTML の解析途中で CSS や JavaScript、画像などの外部のリソースを見つけると、それらを取得するために都度サーバに対して追加でリクエストを送信する。

## CSS ファイルの解析

HTML と同様に、CSS が読み込まれると、そのファイルは解析され、最終的には CSSOM と呼ばれるオブジェクトのツリーを構築する。
::::details CSSOM とは
CSSOM（CSS Object Model）は、ブラウザが CSS を扱うためのオブジェクトモデルです。HTML ドキュメントに適用された CSS スタイルシートを解析し、要素のスタイル情報を提供します。

CSSOM は、CSS ルール、スタイルプロパティ、メディアクエリ、疑似要素などの要素を表すオブジェクトで構成されています。これにより、ブラウザは要素のスタイル情報にアクセスし、スタイルの計算や適用、レンダリングを行うことができます。

例えば、ある要素の背景色を変更したい場合、ブラウザは CSSOM を使用してその要素のスタイル情報を取得し、背景色プロパティを変更します。その後、再描画が行われ、新しいスタイルが要素に適用されます。

CSSOM は、JavaScript からもアクセス可能であり、要素のスタイルの取得や変更、スタイルの計算などを行うための API を提供しています。これにより、動的なスタイルの操作やアニメーションの制御などが可能になります
::::
CSS ファイルの解析中であっても HTML の解析を停止せず、同時に処理される。

しかし、CSS の解析中はレンダリング（レンダーツリーの構築、レイアウト、ペインティング）をブロックする。
CSSOM は DOM と異なり、CSS のルールが詳細度により上書きされてしまう可能性があるため、CSSOM を段階的に構築することができない。すべての CSS が解析されて CSSOM が構築されるまでは、ブラウザは各要素がどのようにスタイルされ、配置されるか知ることができない。
CSS の解析がレンダリングをブロックするのはこれが原因。

![](https://storage.googleapis.com/zenn-user-upload/b3ec93c31616-20230715.png)

CSS は上書きされる可能性があるため、すべての CSS が解析されてから構築される。

## JavaScript の実行

JavaScript は字句解析、構文解析の後、コンパイルを経て実行可能コードとなり実行される。
これらの一連の流れはブラウザの**JavaScript エンジン**によって行われる。
JavaScript エンジンはブラウザによって異なるのでコンパイル方法も使用しているブラウザに依存する。

## Render Tree の構築

レンダーツリーとは、DOM と CSSOM の組み合わせで、ページにレンダリングされるすべてのものを表す。（レイアウトツリーとも呼ばれている）
レンダーツリーは**ページのレンダリングに必要なノードだけ**を構築する。
![](https://storage.googleapis.com/zenn-user-upload/3dd4a1ada2b5-20230715.png)

例えば、上記の CSSOM では`body > p > span`の要素に`display: none`というスタイルを適応している。
このスタイルは「画面上で非表示にする」というものなので、レンダーツリーの構築の際には除外される。
（`visibility: hidden`や`opacity: 0`も非表示だが、要素としては存在するのでレンダリングツリーに組み込まれる）

また、DOM に含まれている `<html>` と `<head>` も画面上では視覚化されないので、こちらもレンダーツリーからは除外される。

## Layout

レンダーツリーが構築された後、ブラウザはビューポート内でのノードの正確な位置やサイズを計算する。
このステップを`レイアウト`と呼ぶ。

::::details ビューポート（viewport）とは？

> ビューポート（viewport）とは、ウェブページが表示される領域や画面の一部を指します。具体的には、ユーザーがウェブページを閲覧する際に表示される可視領域のことを指します。
> つまり、「現在表示されている領域」のこと。

ビューポートのサイズは`<head>`内の`<meta name="viewport" ...>`での指定によって決まる。
::::

## Painting

レンダリングの結果をブラウザに描画する。
この段階で初めてピクセルが描画される。

## レンダリングブロックについて

ここでいう「レンダリング」とは、「Render Tree の構築」〜「Painting」のことを指す。
レンダリングはパース後に行われるが、HTML ファイルすべてがパースされるのを待っているわけではない。
ある程度の単位（8KB 等）でパースしたものを元に DOM/CSSOM ツリーを構築し、逐次レンダリングを行っている。
しかし、デフォルトでは以下のケースでレンダリングが停止する。

1. CSSOM の構築
2. JavaScript の読み込み・実行

### CSSOM の構築

こちらは前述した通り。

### JavaScript の読み込み・実行

JavaScript は`script`タグによって読み込まれる。
デフォルトの設定だと JavaScript を読み込んで実行するまで間は DOM の構築と、CSS の読み込み・解析もブロックされる。
その結果、レンダリングの開始が遅れてしまう。
:::message
厳密には、JavaScript の場合はレンダリングをブロックしているわけではなく、ダウンロード時間の分だけパースがブロックされ、その結果、レンダリングの開始が遅れる。
:::

![](https://storage.googleapis.com/zenn-user-upload/17ccdfd79ca9-20230715.png)

### JavaScript のレンダリング（パース）ブロック解消

JavaScript を実行中にパースが停止することは避けようがない。
しかし、**JavaScript ファイルのダウンロード中にパースが止まること**は緩和することができる。

#### JavaScript のインライン化

1 つ目の方法は、JavaScript のインライン化。
これは、外部参照（外部ファイル）にしているスクリプトを HTML ファイル内にふくめることを指す。

![](https://storage.googleapis.com/zenn-user-upload/ba1525bcec61-20230715.png)

#### JavaScript の非同期化

2 つ目の方法は、JavaScript の非同期化。
非同期化には`async`と`defer`の 2 つのやり方がある。
JavaScript を非同期 (async/defer) にした場合、外部参照の JavaScript ダウンロードと並行してパースを続けることができる。

`async` の場合、JavaScript ダウンロード直後にスクリプトを実行するが、`defer` の場合はパースが一番下まで終わった後にスクリプトを実行する。

![](https://storage.googleapis.com/zenn-user-upload/9bd4abc06d74-20230715.png)

`async`と`defer`のメリット・デメリットを具体例を交えて説明すると以下の通り。
![](https://storage.googleapis.com/zenn-user-upload/f7ebd0e1511b-20230715.webp)

## 参考リンク

https://zenn.dev/ak/articles/c28fa3a9ba7edb
https://zenn.dev/kamy112/articles/2651aa92cc33fd
https://coliss.com/articles/build-websites/operation/work/how-the-browser-renders-a-web-page.html
https://www.sunapro.com/browser-rendering/
https://milestone-of-se.nesuke.com/sv-basic/web-tech-basic/html-javascript-dom-parse-rendering/
