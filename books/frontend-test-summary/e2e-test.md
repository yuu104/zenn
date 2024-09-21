---
title: "E2Eテスト"
---

## E2E テスト とは？

ユーザーの実際の使用シナリオに基づいて、アプリケーションの開始から終了までの全プロセスをテストする手法。

Web アプリケーションは、以下にある様々なモジュールを組み合わせて実装する。

1. ライブラリが提供する関数
2. ロジックを担う関数
3. UI を表現する関数
4. Web API クライアント
5. API サーバー
6. DB サーバー

E2E テストは、1〜6 までを「ヘッドレスブラウザ」+「UI オートメーション」の組み合わせを中心に構成されたテスティングフレームワークで実施する。
そのため、ブラウザ固有の API を使用したり、画面をまたぐ機能テストに向いている。

![](https://storage.googleapis.com/zenn-user-upload/3f883d46c242-20240919.png)

**「何をテストするのか？」という目的を明確にすることが重要。**（他のテストでもそうだが...）

## どういうケースに E2E テストが必要か？

### ブラウザ固有の機能連携を含むテストがしたい

以下のようなブラウザを使用した忠実性の高いテストは、UI コンポーネントテストで使用される Jset + jsdom 等では不十分である。

- 複数画面をまたぐ機能
- 画面サイズから算出するロジック
- CSS メディアクエリーによる、表示要素切り替え
- スクロール位置によるイベント発火
- Cookie やローカルストレージなどへの保存

このような場合、E2E テスティングフレームワークを使用して一連の機能連携を検証する。
![](https://storage.googleapis.com/zenn-user-upload/c000f97033ff-20240919.png)

ブラウザ固有の機能&インタラクション」に着眼できればよ良い場合、API サーバーやサブシステムはモックサーバーを使用する。

このテストは、「フィーチャーテスト」とも呼ばれる。

### DB やサブシステム連携を含むテストがしたい

下記のような、**本物に近い環境**を再現してテストしたい場合があるだろう。

- DB サーバーと連携し、データを読み書きする
- 外部ストレージサービスと連携し、メディアをアップロードする
- Redis と連携し、セッション管理する

E2E テスティングフレームワークは、対象のアプリケーションをブラウザ越しに操作可能なため、上記のテストケースに対応できる。

Web フロントエンド層、Web アプリケーション層、永続層が連携することを検証するため、忠実性が高い自動テストが可能。
![](https://storage.googleapis.com/zenn-user-upload/f7ecb842f8a6-20240919.png)

## トレードオフ

E2E テストは多くのシステムと連携する。「DB やサブシステム連携を含むテスト」は特にそう。
よって以下のデメリットがある。

- 実行時間が長い
- 不安定で稀に失敗する
- 実装コストが高い

![](/images/frontend-test-summary/relationship-between-test-coverage-and-cost.png)

## Playwright 基礎

Playwright は、Microsoft から公開されている E2E テストフレームワーク。
クロスブラウザ対応しており、デバッガー／レポーター／トレースビューワー／テストコードジェネレーター機能など、多くの機能を備えている。

### インストールと設定

```shell
npm init playwright@latest
```