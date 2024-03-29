---
title: "統計情報"
---

## 統計情報とは？

- クエリプランナー（クエリ最適化器）がクエリの実行計画を選択する際に使用する情報
- データベース内のテーブルや列のデータ分布に関する情報を提供する
- 統計情報は SQL のアクセスパスを決める最大の要因
- DBMS は、SQL を受け取ると、どのような経路（パス）でデータを探しに行くのが最も効率的かを判断する
- SQL には「こんなデータが欲しい」という条件は記述されているが、「こうやってデータを取りに行け」とは書いてない
- **アクセスパスは DBMS が自動で決める**

![](https://storage.googleapis.com/zenn-user-upload/e763f1b90ac6-20231022.png)s

## オプティマイザと実行計画

DBMS が SQL 文を受け取ると、テーブルにアクセスするまでに以下の流れをたどる。

![](https://storage.googleapis.com/zenn-user-upload/b322fe5e80a3-20231024.png)

### 1. ユーザから SQL 文が DBMS へ発行される

- 発行された SQL を最初に受け取るのは DBMS 内の「**パーサー**」と呼ばれるモジュール
- パーサーは、SQL 文が適法な構文であるかどうかをチェックする
- 文法的に間違っている SQL 文はエラーとしてユーザに突き返す

### 2. パーサーによる解析結果をオプティマイザへ送る

- 「オプティマイザ」は DBMS の頭脳
- SQL のアクセスパス（実行計画）を決める役割を担う
- アクセスパスを決める際、必要になるのが統計情報

### 3~4. カタログマネージャーから統計情報を取得する

- 「カタログマネージャー」は、統計情報を管理するモジュール
- 統計情報を取得すると、オプティマイザは多くの経路の中から最短経路を選択し、SQL を手続きに変換する
- このとき得られた手続きの手順が、実行計画（「実行プラン」「アクセスプラン」）になる

### 5. 実データがあるテーブルへアクセスする

- SQL を変換して得られた実行計画に従い、テーブルへアクセスする

## 統計情報の設計指針

- 一般的に、エンジニアが SQL の実行計画立案に直接関与することはない
- しかし、統計情報を通した間接的な関与を行う
- **統計情報はなるべく最新の状態に保つ**
- **統計情報の収集をどのように行うか？を考える**
  - 統計情報収集のタイミング
  - 統計情報収集の対象（範囲）

### 統計情報収集のタイミング

:::message
**データが大きく更新された後、なるべく早く行う。**
**ただし、アクセスが激しくない時間帯を狙う。**
:::

- INSERT / UPDATE/ DELETE のいずれも該当する
- レコード件数の増減やデータ値の分布・偏りの変動が、アクセスパスの選定に影響する
- 更新によりテーブルのデータが大きく変われば、古い統計情報と最新のテーブルの状態に齟齬が生じる
- 更新量が少ない場合は、統計情報を収集する意味はない
- 統計情報の収集は、それなりにリソースの消費をする、長時間かかる処理
- 重い処理をアクセスが激しい時間帯に実施することによるリスクも考慮すべき
- DBMS によっては、統計情報収集はデフォルトの設定で定期的に実施されることもある

### 統計情報収集の対象（範囲）

:::message
**大きな更新のあったテーブル（およびインデックス）が対象。**
:::

- 統計情報収集は不可の高い処理
- よって、データ変更のないテーブルまで再収集の対象に含めるのは良くない
- 本当に必要なテーブルだけに限定する

### 統計情報を凍結するべきケース

- 基本的には、**統計情報はなるべく最新の状態に保つ（凍結させない）**
- しかし、**現状のものから実行計画を変化させたくない**場合は凍結させる
  - 現在使われている経路が、将来にわたっても最適ルートである場合
  - システムのサービス終了時のデータを想定した状態での統計情報が存在する場合
- データ量の増加に伴い、実行計画が変化し、パフォーマンスが劣化することは良くある
- オプティマイザが最適な経路を選択するとは限らない

![](https://storage.googleapis.com/zenn-user-upload/9e756d338f21-20231024.png)

- 統計情報の凍結は、オプティマイザの仕事を完全には信じない、**悲観的**な考えに基づいた選択
- 統計情報の凍結は、統計情報の読み取りをストップすること
- 凍結する際は、サービス終了時のデータを想定する必要があるので、難しい
