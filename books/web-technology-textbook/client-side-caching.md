---
title: "クライアントサイドキャッシング"
---

## クライアントサイドキャッシングとは

- クライアント側でキャッシュを蓄える方式
- クライアントサイドでキャッシュすることにより、**Web サーバへの問い合わせ回数**や**データ転送量**を減らすことができ、Web サーバやネットワークの負荷を軽減できる
- キャッシングの主な手段としては以下の方法がある
  1. ブラウザのキャッシュ機能を使用する
  2. クライアント側のネットワークにプロキシサーバを用意して、キャッシュさせる

![](https://storage.googleapis.com/zenn-user-upload/edcf042f78dd-20230728.png)

- プロキシサーバを使って多人数で利用するキャッシュを**共有型キャッシュ**と呼ぶ
- ブラウザのように特定のユーザのみ利用するキャッシュを**非共有型キャッシュ**と呼ぶ

![](https://storage.googleapis.com/zenn-user-upload/8f527a517646-20230728.png)

## Web サーバ側でのクライアントキャッシングの制御

- クライアントサイドキャッシングの設定は、ウェブブラウザや Web ページ内のメタデータで行う
- しかし、Web サーバ側でクライアントサイドキャッシングの設定を制御することができる
- サーバ側で制御をするには、**HTTP レスポンスのヘッダー情報**にキャッシュ制御情報を埋め込む
  - キャッシュの有効化・無効化や、キャッシュの有効期限などの情報を埋め込む
- ブラウザやプロキシサーバは、ヘッダーに埋め込まれた情報をもとにキャッシュを制御する

### 具体的な制御方法

- HTTP レスポンスの**Cache-Control ヘッダー**と**ETag ヘッダー**を使用する
  - HTTP/1.0 では、Ecpires ヘッダーと Pragma ヘッダーを使用するため、互換性を考慮しなければならない場合はこれらのヘッダーを併用する

![](https://storage.googleapis.com/zenn-user-upload/5fe98631ef73-20230729.png)

#### ETag ヘッダー

- コンテンツが更新されたかどうかを確認するために使用する
- 更新がなければ ETag ヘッダーの値は前回の値と同じになり、更新されると値が変化する
- バージョンのように使用できるため、コンテンツが更新されていなければキャッシュを再利用できる
