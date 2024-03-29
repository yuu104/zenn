---
title: "クラウドサービス"
---

## クラウドサービス

**クラウド**と呼ばれるインターネット上のサービスを利用して、Web サーバを簡単に立ち上げるのが Web システム構築の主流になりつつある。
クラウドでは、サーバ・ストレージ・ネットワークなどのハードウェアリソースを抽象化することで、これらの詳細を知らなくても簡単に利用できるようになる。
クラウドサービスが登場する前は、例えばシステム開発を行う場合には自社に物理サーバーを置いて、そのコンピューティングリソースを使うことが一般的だった。
クラウドサービスの登場により、従来は必要な機能をそれぞれ物理的に個別に購入していたものを、全てインターネット経由で利用できるようになった。

### クラウドサービスの特徴

- 導入時の初期費用がかからない
- 必要な時に必要な分だけ使える（コストを最適化しやすい）

### クラウドサービスの形態

- **IassS（Infrastructure as a Service）** : ハードウェアやインフラを提供する
- **PaaS（Platform as a Service）** : アプリケーションのためのプラットフォームを提供する
- **SaaS（Software as a Service）** : サービスやアプリケーションを提供する

![](https://storage.googleapis.com/zenn-user-upload/a6aa27b8f711-20230804.png)

開発や運用の自由度は「IaSS > PaaS > SaaS」の順になる。
自由度が高いほど、開発・運用コストは高くなる。
例えば、自社で機器を用意して運用管理も全て主体的に行うオンプレミス環境上で動かしている Web アプリケーションをクラウドに移行する場合は、一般的に IaaS か PaaS を選択して移行作業を行う。

![](https://storage.googleapis.com/zenn-user-upload/780dccafe97a-20230803.png)

IaaS PaaS SaaS それぞれの違いについては下記参照
https://qiita.com/kznrluk/items/55a3ff527bd2b81a3d52

## サーバレスアーキテクチャ

- サーバ管理を開発者から切り離しアプリケーションコードに焦点を当てるアプローチ
- サーバレスでは、何らかのイベントが発生したときに初めて処理を実行する
- 例
  - ブラウザからアクセスが発生したときに形式を変換して保存する
  - ファイルがロードされたときに形式を変換して保存する
  - Web アプリケーションでボタンがクリックされたときにコードを実行する
- イベントが発生しない限り何も処理されない
- IaaS では、リクエストを待機している間も常時仮想マシンを稼働する必要があるが、サーバレスでは待機している間は何も稼働させておく必要がない
- 開発者はアプリケーションのコード（関数）を作成し、処理の実行条件となる**トリガー**を設定すれば、あとはプラットフォームに任せることができる
- サーバレスとは名前の通り、開発者が物理的なサーバの管理やスケーリングについて考えなくてよくなる
- トリガーが発生した場合のみコードが実行されるため、メモリや CPU などのリソースを効率的に使用できる

![](https://storage.googleapis.com/zenn-user-upload/f10cb14e4705-20230804.png)

### FaaS（Function as a Service）

- サーバレスといっても、実際には物理上で仮想マシンやコンテナ、アプリケーションが稼働している
- FaaS はユーザに代わって管理を代行し、サーバレスアーキテクチャを提供している
- 開発者は特定のイベントがトリガーされた際に実行される関数（コード）を作成し、それを FaaS プラットフォームにデプロイする
- トリガーと関数以外は FaaS 側ですべての責任を受け持つ

  - 仮想マシンが停止しないように監視する
  - アクセスが集中したときに仮想マシンを拡張する

  など

### 代表的な FaaS

- AWS Lambda
- Azure Functions
- GCP Cloud Functions
