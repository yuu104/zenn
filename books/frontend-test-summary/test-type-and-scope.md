---
title: "フロントエンドテストの種類と範囲"
---

Web アプリケーションコードは、以下にある様々なモジュールを組み合わせて実装する。

1. ライブラリが提供する関数
2. ロジックを担う関数
3. UI を表現する関数
4. Web API クライアント
5. API サーバー
6. DB サーバー

フロントエンドテストの自動テストを書くとき、1〜6 のうち「どこからどこまでの範囲をカバーしたテストであるか」を意識する必要がある。
Web フロントエンドにおけるテストの範囲は以下の 4 つに分類される。

## 静的解析

- TypeScript や ESLint による静的解析
- バグの早期発見には欠かせない
- 単一のモジュール内部検証だけでなく、2 と 3 の間、3 と 4 の間など**隣接するモジュール間連携の不整合**に対して検証する

## 単体テスト

- 2 のみ、3 のみ、といったように**モジュール単体が提供する機能**に着目したテスト
- テスト対象モジュールが、定められた入力値から期待する出力値が得られるかをテストする
- 独立した検証が行えるため、滅多に発生しないケース（コーナーケース）の検証に向いている

## 結合テスト

- 1〜4 まで、2〜3 までというように**モジュールをつなげることで提供できる機能**に着目したテスト
- 範囲が広いほどテスト対象を効率よくカバーすることができる
- 相対的にざっくりとした検証になる傾向がある

## E2E テスト

- 1〜6 を通し、ヘッドレスブラウザ+UI オートメーションで実施するテスト
- ユーザーがシステムを使用する場面を想定し、実際にシステムを操作してテストを行う
- システム全体を対象に行われるテストであるため、複数のコンポーネントやシステム間の相互作用を含む複雑なテストケースを扱うことができる
- そのため、より本物のアプリケーションに近いテストが可能