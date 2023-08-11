---
title: "CDN"
---

## CDN とは

- 世界中のネットワークに Web サーバを分散配置して、どこからアクセスしても、Web コンテンツを効率的かつ迅速に配信できるようにした**ネットワーク**
- CDN で配信するには、CDN 事業者と契約する必要がある
- CDN 事業者は世界中に CDN 網を張り巡らしている
- サービスに申し込むことで、Web コンテンツのコピーを世界中のサーバに配置することができる

![](https://storage.googleapis.com/zenn-user-upload/58d92833c48a-20230802.png)

## なぜ CDN を利用するのか？

- Web サーバとクライアント間の通信にかかる時間は、物理的な距離にほぼ比例する
- ロードバランサーやプロキシサーバの導入や Web システムの増強をしても、クライアントとの物理的な距離を縮めることはできない
- CDN によりクライアントに近い場所に Web サーバを配置することで、物理的な距離を縮めることができる
- Web アクセスが 1 カ所に集中するのを防ぐことができるため、負荷分散にも貢献する

## CDN 事業者

- 有名所は、CloudFront、Cloudflare、Akamai
- これらの企業では CDN サービスだけでなく、以下の機能も提供している
  - SSL/TLS 暗号通信のアクセラレーション
  - ネットワークやアプリケーションの最適化
  - コンテンツの圧縮転送
  - DDoS や DoS などの攻撃に対する防御
  - アプリケーションレベルでのファイアーウォール
  - 地理的に離れたデータセンター間の広域負荷分散

## CDN の仕組み

CDN を実現するために必要な仕組みは以下の 2 つ

- 同一の URL に対して自動的に最寄りの Web サーバに選択してアクセスする
- 世界中に配置された Web サーバに同じコンテンツをコピーする

### 同一の URL に対して自動的に最寄りの Web サーバに選択してアクセスする

- DNS を用いる
- DNS サーバは、１つのホスト名に対して複数の IP アドレスを返答できる
- このとき、クライアントから一番近い Web サーバの IP アドレスを返す仕組みを利用する

:::message
IP アドレスによる距離を判定する機能が必要になるが、一般的な DNS にはそんな機能は無い
:::

- そのため、CDN 事業者専用の DNS を使用する必要がある
- 専用の DNS は、クライアントの IP アドレスがどの ISP のものかを調べ、事前に用意したフローチャートと照らし合わせて最寄りの Web サーバの IP アドレスを返す

:::details ISP とは？

- インターネット接続サービスを提供する企業や組織のこと
- ISP は、一般家庭や企業、学校などがインターネットに接続する手段を提供する
- ISP はユーザーに対して IP アドレスを割り当てたり、インターネットへのアクセスを可能にしたり、通信の品質や速度を維持するためのインフラを提供したりする

:::

![](https://storage.googleapis.com/zenn-user-upload/14f528094ffe-20230802.png)

### 世界中に配置された Web サーバに同じコンテンツをコピーする

- 世界中に張り巡らされた CDN 網は、各所に**キャッシュサーバ**を配置している
- CDN を実現するには、オリジンサーバとキャッシュサーバ間で常に同期を取る必要がある
- 上手く同期を取るために、同期タイミングやキャッシュの保持期間を調整するなどの設定が必要
- また、キャッシュする対象コンテンツを正しく選択するのも大事（個人情報はキャッシュ対象外にするなど）