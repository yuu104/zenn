---
title: "HTTPとは"
---

## HTTP とは

- HTTP（Hypertext Transfer Protocol）は Web システムで利用される**アプリケーションプロトコル**
- Web クライアントと Web サーバ間の通信に利用される
- TCP の**3 ウェイハンドシェイク**で接続が確立した後、HTTP 通信が開始する

![](https://storage.googleapis.com/zenn-user-upload/8557f0ed8ce0-20230811.png)

## HTTP/1.1 はテキストベースプロトコル

アプリケーションプロトコルはリクエストとレスポンスの形式によって以下の 2 種類に分けることができる。

- **テキストベースプロトコル**
  - 自然言語に近く、半角の英字（a〜z、A〜Z）やアラビア数字（0〜9）、記号、空白文字などの ASCII 文字列を用いる
- バイナリーベースプロトコル
  - コンピュータ処理に最適化されたバイナリーメッセージを使用する

HTTP はテキストベースプロトコルの一つ。
![](https://storage.googleapis.com/zenn-user-upload/49649e93aef4-20230811.png)
