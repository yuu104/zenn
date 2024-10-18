---
title: "E2E自動テストを理解したい"
emoji: "😽"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [test, playwright, e2e, typescript]
published: false
---

## E2E テストとは？

ユーザーの使用シナリオに基づいて、アプリケーションの開始から終了までの全プロセスをテストする手法です。

:::details 全プロセスをテストする？？

Web アプリケーションは、以下にある様々なモジュールを組み合わせて実装されています。

1. ライブラリが提供する関数
2. ロジックを担う関数
3. UI を表現する関数
4. Web API クライアント
5. API サーバー
6. DB サーバー
7. Web ブラウザ

E2E 自動テストは、1〜7 までを「ヘッドレスブラウザ」+「UI オートメーション」の組み合わせを中心に構成されたテスティングフレームワークを用いて、検証します。

:::

:::message alert

E2E テストの定義は人や組織、文脈によってバラバラです。
そのため、上記の説明が明確な定義ではない可能性があることをご了承ください 🙇‍♂️

:::

## 特徴

1. **使用するインターフェースはユーザーインターフェース**
   - システムとしてユーザーに提供するものをテストするため
   - Web ブラウザやモバイルデバイスなどが対象になる
2. **テストケースはユーザーストーリーが基になる**

   - ユーザーがその機能を用いて達成したいことをテストする
   - 技術的制約によってユーザーストーリー以外のものをテストすることもある

3. **テスト対象は完全に統合されたシステム全体**
   - 単体テスト・結合テストよりも高レベルなテスト
   - マイクロサービスアーキテクチャの場合、全てのサービスが揃った完全な状態での動作を確認する
4. **想定されるバグは、「ユーザーストーリーそのものの失敗」**
   - 「ログイン出来ない」
   - 「商品がカートに入らない」
   - 「画面遷移ができない」etc.

## メリット

ここでは、E2E テストを行うことによる利点を説明します。

### ① ユーザーストーリーそのものをテストできる

E2E テストの大きな特徴は、ユーザーストーリーをそのままテストできる点です。
これは他のテストレベルではほぼ不可能な、E2E テスト独自の強みです。

ユーザーインターフェースを通じて実際のユーザー操作を再現することで、ソフトウェアが本当にユーザーの期待通りに動作するかを確認できます。
これにより、「**ユーザーストーリーの失敗**」という最も深刻なバグを発見することができます。

E2E テストを適切に実施することで、プロダクト上のクリティカルな欠陥を避け、ユーザーの満足度を高めることができるのです。

### ② 幅広い用途に利用できる

単体テストや結合テストでは難しい、以下の検証を行うことができます。

1. **互換性の確認**
   E2E テストを使えば、様々なブラウザ、OS、デバイスでソフトウェアが正しく動作するかを効率的に確認できます。
   これを手動テストでやろうとすると、大きなコストが必要になります...
2. **「生きたドキュメント」として**
   E2E テストは、ソフトウェアの使い方や機能を示す「生きたドキュメント」として活用できます。テストコードを読むことで、システムの動作を理解できるのです。
   詳細な仕様書がない古いシステムや、急速に開発が進んでいるプロジェクトでは、E2E テストにより現在の仕様を可視化できます。
   さらに、ソフトウェアが変更されると自動的にテストが失敗するので、ドキュメントの更新忘れを防げます。
3. **システムの監視ツールとして**
   実際のユーザー操作を模したテストを定期的に実行することで、システムの健全性を常にチェックできます。
   新しい機能をリリースした直後など、システムの基本的な機能が正常に動作しているかを素早く確認したい場合にも有効です。

## デメリット

E2E テストはいいことばかりではありません。
ネガティブな面やリスクについても説明しておきます。

### ① 自動化の難度と複雑性が高い

E2E テストの大きなデメリットの一つは、自動化そのものに必要な作業が複雑で、思わぬ落とし穴にはまりやすいことです。

#### E2E テスト自動化に必要な要素

そもそも、E2E テストを自動実行するには、最低でも以下の要素が必要になります。

1. **テスト対象のシステム**
   - システム全体が統合された状態
   - 実ユーザーが利用するのと同等の環境が必要
2. **クライアント**
   - ブラウザやモバイルデバイスなど
   - 場合によってはリアルデバイスではなく、エミュレーターなどで代替することも
3. **オートメーションツール**
   - ユーザーインターフェースを自動操作するためのツール
   - ブラウザなどのクライアントソフトウェア自身が提供している場合や、サードパーティのツールを利用する場合がある

テストのために多くの要素が必要となり、単体テストや結合テストと比べてもかなり複雑です...

#### 自動化する上での課題

複数の要素を連携してテストするため、様々なことを考慮する必要があります。

1. **ツールのバグによる影響**
   - クライアントやオートメーションツールのバグに遭遇する可能性がある
   - 例：Google Chrome を自動操作するための ChromeDriver
2. **多様な環境への対応**
   - 新しいブラウザや多種多様なブラウザをテストしたいという要求がある
   - これらの環境自体が抱える問題により、自動テストがうまく動かないケースが発生する
3. **エミュレーターやシミュレーターの利用**
   - クライアントやモバイルデバイスのエミュレーター/シミュレーターを利用する場合、これらがトラブルを引き起こす可能性がある
4. **システム外部への依存**
   - E2E テストはシステムを外から利用してテストする
   - 他のテストレベルとは異なり、システムの外に大きく依存するテスト
   - 実装における考慮事項が非常に多くなる
5. **セキュリティ設定などの考慮**
   - 開発中のシステム特有のセキュリティ設定など、特別な考慮事項が存在する可能性がある

:::message
E2E テストは他のテストレベルとは異なり、**システムの外に大きく依存する**テストです。
そのため、実装における考慮事項は多くなります。
:::

### ② テスタビリティへの配慮が難しい

E2E テストは、システム全体の「振る舞い」を検証する強力なツールですが、同時にテスタビリティに関して特有の課題を抱えています。

#### 内部状態の取得の難しさ

E2E テストは主にシステム全体の外部から観察可能な振る舞いに焦点を当てますが、特定の条件下での動作を検証するために、やむを得ずシステム内部の状態を取得する必要が生じる場合があります。
しかし、E2E テストにおいてこのような内部状態の取得を実装することは以下の懸念点があります。

- システムの内部構造に深く依存するテストコードを書く必要があり、保守性が低下する
- テスト用の特別なインターフェースや機能を追加する必要があり、本番環境との乖離が生じる可能性がある
- 内部状態の取得自体がシステムの挙動に影響を与え、テスト結果の信頼性を損なう可能性がある

この問題により、複雑な条件や状態遷移を伴うテストシナリオの実装は難しいのです...

#### モックとスタブの利用制限

単体テストや統合テストでは、モックやスタブを使用してテスト対象を分離し、特定の条件下での動作を検証することが一般的です。
しかし、E2E テストではこれらの技法の使用には以下の懸念点があります。

- 実際の環境での動作を検証するという E2E テストの本質的な目的と相反する
- システム全体の統合状態を正確に反映できなくなる可能性がある

外部のサードパーティ API を利用する場合を例にすると以下のようなトレードオフを考慮する必要があります。

1. **実際の API を使用する場合**
   - テストの信頼性が向上する
   - しかし、API の動作や可用性に依存してテストが不安定になる可能性がある
   - コストやレート制限の問題が発生する可能性がある
2. **API をモック化する場合**
   - テストの安定性と再現性が向上する
   - しかし、「完全に統合された状態のシステムのテスト」という E2E テストの本来の価値が損なわれる
   - 実際の環境で発生する可能性のある問題を見逃す危険性がある

### ③ 高コスト

E2E テストの実施にはコストがかかります。

1. **時間的なコスト**
   - 本物のブラウザやモバイルデバイスなどを利用するため、起動やページロードも含め、実行時間が長くなる
   - ログインが必要なシステムでは、テストケースの度にログイン処理が必要になり、実行時間が長くなる可能性がある
2. **金銭的なコスト**
   - 環境やデバイスの数に比例して金銭的コストが増加する
   - 完全に統合された状態でシステムを起動する必要があるため、場合によっては本番環境と同等の環境を準備する必要がある

## E2E テストの導入戦略

E2E テストによる恩恵は大きい一方で、導入ハードルはとても高いということが分かりました。
では、どのようなことを考慮して E2E テストを導入していけばよいのでしょうか？

### ① 現状のテスト状況を把握する

テストには「単体テスト」「結合テスト」「E2E テスト」「手動テスト」等、複数のレベルが存在します。まずは、これらテストレベルのコスト配分が現状どのようになっているのかを把握する必要があります。

例えば、よく知られているベストプラクティスとして**テストピラミッド**があります。
これは、下層のテストが多くなるモデルで、安定した費用対効果の高いテスト戦略と言われています。

一方、真逆のバッドプラクティスとして**アイスクリームコーン**というものもよく知られています。
これは、極めて少ない量の自動テストと、大量の手動テストに依存した状態です。

![](https://storage.googleapis.com/zenn-user-upload/34579ee95405-20240926.png =600x)
_左: テストピラミッド、右: アイスクリームコーン
引用: https://codezine.jp/article/detail/19909_

\
他にも形態はありますが、大事なのは、**現状を把握する**ということです。

現状を知らなければ、何から始めれば良いのか？も分かりません。
闇雲に進めて...結局問題が解決しない...という事態に陥ってしまいます。

### ② 短期的な戦略と長期的な戦略を分けて考える

現状を把握した結果、テスト状況がアイスクリームコーンであったとしましょう。（テストに悩む多くの現場は、このケースが多いらしい...）
開発プロセスが大量の手動テストに依存してしまっているため、何とか改善したいです...
できればテストピラミッドの状態にしたいです。
![](https://storage.googleapis.com/zenn-user-upload/09f16ae92610-20240925.png)
_現状を変えたい....!_

\
しかし、いきなり変えるのは流石に難しいです...
ではどうするか？？

短期的な戦略と長期的な戦略を分け、以下のように段階的に進めていくのが得策です。
![](https://storage.googleapis.com/zenn-user-upload/b1ed508b2b46-20240925.png)
_少しずつ着実に改善する
引用: https://codezine.jp/article/detail/19909_

#### 短期的な戦略

まずは「手動テストが多い」という状況から脱却することを目指します。
そのための手段として、E2E テストを導入して自動化します。

手動テストは通常、実際のユーザーの行動を模倣して検証を行います。
E2E テストも同様に、ユーザーの視点からシステム全体の動作を確認するため、手動テストのシナリオを変換しやすいです。

![](https://storage.googleapis.com/zenn-user-upload/a1b05c441c41-20240927.png =400x)
_手動テストを自動化する
引用: https://codezine.jp/article/detail/19909_

\
これで、手動テストが多い現状から脱却し、開発プロセスが多少は改善するでしょう。

:::details そもそも自動テストが存在しない場合は？

テストを書いてこなかったプロジェクトに対して、E2E テストから始めるのは良い手段です。
\
アプリを実装したあと、ログインをしてみたり、画面のボタンをクリックしてみたり、フォームに入力して内容が反映されているか確認したり...といった、動作確認を行っていると思います。
その動作確認として行った操作をそのまま E2E テストとして、実装するのです。
**「自動テストが存在する」という状態を作ることが一番重要です。**
\
どれからテストすれば良いか迷った場合は、「この機能が動かないとシステムとして成り立たない」といったクリティカルなケースを対象にしましょう。

:::

しかし、E2E テストの比重が大きい状態が長く続くと問題になります。
何故問題か？
E2E テストのデメリットを思い出してください。

- 自動化の難度と複雑性が高い
- テスタビリティへの配慮が難しい
- 高コスト

E2E テストの数が多くなればなるほど、テスト実行時間が長くなり、メンテナンスが難しくなり、不安定な状態に陥ります。
プロダクトの品質は向上するかもしれませんが、開発生産性は減少してしまいます...
（やがて pass しないテストが出てきて、メンテナンスを維持できなくなり、品質を保てなくなるケースも...）

そのため、短期的な施策としては良いですが、どこかのタイミングでテストピラミッドに近づけるための施策を打つ必要があります。

:::details 何故、E2E テストの比重が大きくなってしまうのか？

よくある原因は、**開発チームと QA チームのサイロ化**です。
開発チームと QA チームの距離が遠い組織は多いのではないでしょうか？
\
分断されていると、**開発チームが単体テストの設計・実装を担当し、QA チームが E2E テストの設計・実装を行う**ケースが多いです。
何故なら、手動テストをしていたのは QA なので、自動化も QA がやる流れになります。
\
QA は自分たちの責務に対しベストを尽くそうとするため、結果として E2E テストの比重が多くなってしまうのです。

:::

#### 長期的な戦略

では、どのようにしてピラミッドにしていくのか？

それは、現状の E2E テストに対し「**結合テストや単体テストで代替できるものを見つける**」ことです。
上位層にあったテストを少しずつ下位層へと分解していくのです。
![](https://storage.googleapis.com/zenn-user-upload/31f228df4a10-20240927.png)
_引用: https://codezine.jp/article/detail/19909_

\
例えば、E2E テストから結合テストへの分解は、モックやスタブを利用することで可能になるかもしれません。

また、フォーム入力を含むシナリオをテストする場合、入力のバリデーションロジックは単体テストに任せ、E2E テストではより包括的なシナリオに焦点を当てるべきです。
例えば：

- 単体テスト：
  各入力フィールドの個別のバリデーションルール（文字数制限、形式チェックなど）を詳細にテストします。
- E2E テスト：
  フォーム全体の動作を確認するため、有効なデータセットと無効なデータセットの代表的な例を使用してテストします。これにより、フォームの送信プロセス全体が正しく機能しているかを確認できます。

このアプローチにより、単体テストでは細かなロジックを網羅的にカバーし、E2E テストではユーザーの実際の利用シナリオに近い形でシステム全体の挙動を確認することができます。

分解を考える際に重要なのが、**目的と技術的な制約を混同しない**ことです。
「内部構造の変化が多く、単体テストに不向き」「単体テストに習熟したメンバーがいない」などの理由で、仕方なく E2E テストになっているものと、「これは E2E で検証すべきだ」というものを区別して考えることで、分解がしやすくなるでしょう。

具体的にどう分解していくか？は[こちらの記事](https://logmi.jp/tech/articles/330973#s4)が参考になります。

## 自動化に向けて知っておきたい「継続的テスト」

ここでは、「自動化」に焦点を当てて解説します。

### 自動テストの目的

そもそも、何のために自動化するのでしょうか？
目的は時と場合によって様々かと思いますが、私は次の 2 点に魅力を感じました。

1. **安全にリリースできる状態を持続可能なコストにキープし続ける**
   基本的に、開発が進み機能が追加される程にテストの数も多くなります。
   そして、どこかを変える度に、全てのテストケースを実施する必要があります。
   \
    これを手動テストで行うとどうなるでしょうか？
   ビジネスが発展し、機能が増え、システムが複雑になる程、テストに必要なコストは爆発的に高まります。
   ![](https://storage.googleapis.com/zenn-user-upload/ac402b898229-20241016.png)

   既存機能のテストが手動テストに依存していると、開発とテストの労力は常に不均衡になります。

   ```
   開発コスト < テストの実施コスト
   ```

   そのため、**すべてを手動テストするのが不可能なタイミングが訪れます**。
   そして、開発者は**検証されないままさらに追加の機能を開発しなければならない状態が続きます**。
   \
   この問題を解決するのが、自動テストです。
   自動テストの場合、機能を追加・修正した際にかかるテストに対するコストは、前回との差分のみです。
   機能の追加・修正に関係ない部分に関するテストは、既存のものを自動で実行するだけなので、手動テストの場合と比べて労力を削減できます。
   ![](https://storage.googleapis.com/zenn-user-upload/6ba9b4699ffc-20241017.png)
   よって、開発コストとの不均衡を解消することができます。

2. **開発者がテストによるフィードバックを素早く受けられるようにする**
   自動テストは「**これまで作ってきたものが、今でも正常に動作している**」ということをいつでも素早く教えてくれます。自分で手動テストしたり、テスターにテストしてもらうのを待つ必要はありません。
   \
   開発者がテスト結果をいつでも素早く知ることができると、何が嬉しいのでしょうか？
   \
   開発者は**自信を持って、躊躇なくコードを変更できる**ようになります。自動テストが安全網として機能するため、変更が既存機能を壊していないかを即座に確認でき、必要に応じて迅速に修正することができます。
   これにより、開発者は「**素早く躊躇なく変化し続ける力**」を得ることができ、ソフトウェア開発において重要な「**変化**」に効果的に対応できるようになるのです。

### 手動テストに出来て自動テストには出来ないこと

手動テストは自動テストの完全な下位互換なのでしょうか？

いいえ、そんなことはありません。
[テスト自動化研究会](https://sites.google.com/site/testautomationresearch/home)が作成した、[テスト自動化の 8 原則](https://sites.google.com/site/testautomationresearch/test_automation_principle)の中に、以下の 2 つがあります。

- **自動テストは書いたことしかテストしない**
- **自動テストで新種のバグが見つかることは稀である**

これらの原則が示唆するように、手動テストには自動テストにはない強みがあります。
その中でも特筆すべきは、手動テストでは「**曖昧な変化**」に気づく能力です。

人間のテスターは、以下のような微妙な変化や違和感を察知することができます。

- ちょっとした画面レイアウトの崩れ
- 使い勝手の変化
- その他気になる挙動の変化
- バグの兆候

テストの主な責務は「バグを見つける」ことですが、このプロセスには実際に 2 つの重要なアクティビティが含まれています。

1. システムが想定通りに動くかの**確認**
2. 仕様に書かれていなかったり、想定していなかった動作がないかの**探索**

手動テストでは、この「確認」と「探索」を暗黙的に、そして同時に行うことができます。
テスターは事前に定義された手順を実行しながらも、常に周囲の状況を観察し、予期せぬ動作や違和感を察知する能力を発揮します。

一方、自動テストは極めて正確ですが、同時に融通が利かない面もあります。
自動テストは、プログラムされた通りにしか動作しない「**一番頭の固いテスター**」と言えるでしょう。
そのため、自動テストでは、手動テストが暗黙的に行なっていた**探索**的な要素を再現することは困難です。

つまり、手動テストは自動テストにはない良さがあり、完全なる下位互換ではないということです。

### 手動テストを自動化しただけはアンチパターン

ここまでの説明で、手動テストと自動テストがそれぞれ異なる強みを持っていることをお分かりいただけたかと思います。
それを踏まえたうえで、自動テストを導入していきます。

この時に、**ただ単純に手動テストを自動化しただけだと、両者の強みを打ち消してしまいます**。
具体的には、

- 手動テストの「柔軟で探索的な検証」
- 自動テストの「開発者がテストによるフィードバックを素早く受けられる」

の 2 つを失ってしまいます。

何故でしょうか？

それは、**テストを実施するタイミングが変わらない**からです。
手動テストを行う際によくある開発の流れは以下のような感じかと思います。

1. ローカルで開発
2. Pull Request を出す
3. main ブランチにマージ
4. ステージング環境にデプロイ
5. **手動テスト**
6. リリース

![](https://storage.googleapis.com/zenn-user-upload/6e6103f7951c-20241018.png)
_引用: https://speakerdeck.com/autifyhq/tesutozi-dong-hua-kara-kai-fa-wozhi-eruji-sok-de-tesutohe?slide=22_

### 自動テストは開発サイクルの中で行う

### 自動テストの導入は「CI/CD パイプラインの構築」から始める

## E2E テストコードを書くまでのステップ

E2E テストが何者か？はある程度理解できました。
しかしまだ、E2E テストに対して疑問点があります。

「**どうやってテストコード書いていけば良いんだ？？？？**」

このままでは、先輩に「E2E テストのコードを書いといて！」と言われても、何から始めれば良いのか分かりません。困ります...
何故なのでしょうか？

それは、「**何をどのようにテストすれば良いか？**」を定めていないかです。
具体的には以下の手順で進めます。

### ① ユーザーストーリーを定義する

ユーザーストーリーとは、ソフトウェアの機能や要件を**ユーザーの視点**から簡潔に記述したものです。

E2E テストにおいて、テストケースの基となるのはユーザーストーリーです。
そのため、まずはユーザーストーリーの定義から始めるのです。

:::details EC サイトの例
「既存ユーザーが商品を検索して購入する」
:::

### ② ユーザーストーリーをテストするための手順を定義する

ユーザーが実際にアプリケーションを使用する際の操作を順序立てて記述します。
「**テストシナリオ**」と読んだりもします。

:::details EC サイトの例

1. ログインページにアクセスする
2. ユーザー名とパスワードを入力する
3. ログインボタンをクリックする
4. ホームページが表示されることを確認する
5. 検索バーに商品名を入力する
6. 検索ボタンをクリックする
7. 検索結果ページが表示されることを確認する
8. 目的の商品をクリックする
9. 商品詳細ページが表示されることを確認する
10. 「カートに追加」ボタンをクリックする
11. カートページに遷移することを確認する
12. 「購入手続きへ」ボタンをクリックする
13. 配送先情報を入力する
14. 支払い方法を選択する
15. 「注文確定」ボタンをクリックする
16. 注文完了ページが表示されることを確認する

:::

### ③ テストシナリオに具体性を持たせる

② の時点で、もうテストコードを書き始められそうですが、まだ必要なことがあります。

例えば「ユーザー名とパスワードを入力する」とありますが、具体値は定めていません。
「商品名」や「目的の商品」などもそうです。

これではテスト可能な状態ではないので、より具体性を持たせます。

:::details EC サイトの例

1. ログインページにアクセスする
2. ユーザー名（`user@example.com`）とパスワード（`password123`）を入力する
3. ログインボタンをクリックする
4. ホームページが表示されることを確認する
5. 検索バーに商品名（`ワイヤレスイヤホン`）を入力する
6. 検索ボタンをクリックする
7. 検索結果ページが表示されることを確認する
8. 目的の商品（`Sony WF-1000XM4`）をクリックする
9. 商品詳細ページが表示されることを確認する
10. 「カートに追加」ボタンをクリックする
11. カートページに遷移することを確認する
12. 「購入手続きへ」ボタンをクリックする
13. 配送先情報（`東京都渋谷区テスト町 1-1-1`）を入力する
14. 支払い方法（`クレジットカード`、番号: `4111111111111111`、有効期限: `12/25`、セキュリティコード: `123`）を選択する
15. 「注文確定」ボタンをクリックする
16. 注文完了ページが表示されることを確認する

:::

### ④ テストコードを書く

さあ、これで準備は整いました！！
あとはテスティングフレームワークの使い方さえ分かれば、コードを書くのはそんなに難しくないはずです。

前述の EC サイトを例に、Playright でコードを記述してみます。

:::details テストコードはこちら

```ts
const { test, expect } = require("@playwright/test");

test("既存ユーザーが商品を検索して購入する", async ({ page }) => {
  // 1. ログインページにアクセスする
  await page.goto("https://example-ec-site.com/login");

  // 2. ユーザー名とパスワードを入力する
  await page.fill("#email", "user@example.com");
  await page.fill("#password", "password123");

  // 3. ログインボタンをクリックする
  await page.click("#login-button");

  // 4. ホームページが表示されることを確認する
  await expect(page).toHaveURL("https://example-ec-site.com/home");
  await expect(page.locator(".user-greeting")).toContainText(
    "Welcome, user@example.com"
  );

  // 5. 検索バーに商品名を入力する
  await page.fill("#search-input", "ワイヤレスイヤホン");

  // 6. 検索ボタンをクリックする
  await page.click("#search-button");

  // 7. 検索結果ページが表示されることを確認する
  await expect(page).toHaveURL(
    "https://example-ec-site.com/search?q=ワイヤレスイヤホン"
  );
  await expect(page.locator(".search-results")).toBeVisible();

  // 8. 目的の商品をクリックする
  await page.click("text=Sony WF-1000XM4");

  // 9. 商品詳細ページが表示されることを確認する
  await expect(page).toHaveURL(/\/product\/sony-wf-1000xm4/);
  await expect(page.locator("h1")).toContainText("Sony WF-1000XM4");

  // 10. 「カートに追加」ボタンをクリックする
  await page.click("#add-to-cart-button");

  // 11. カートページに遷移することを確認する
  await expect(page).toHaveURL("https://example-ec-site.com/cart");
  await expect(page.locator(".cart-items")).toContainText("Sony WF-1000XM4");

  // 12. 「購入手続きへ」ボタンをクリックする
  await page.click("#proceed-to-checkout");

  // 13. 配送先情報を入力する
  await page.fill("#shipping-address", "東京都渋谷区テスト町 1-1-1");

  // 14. 支払い方法を選択する
  await page.selectOption("#payment-method", "credit-card");
  await page.fill("#card-number", "4111111111111111");
  await page.fill("#card-expiry", "12/25");
  await page.fill("#card-cvc", "123");

  // 15. 「注文確定」ボタンをクリックする
  await page.click("#place-order-button");

  // 16. 注文完了ページが表示されることを確認する
  await expect(page).toHaveURL(
    "https://example-ec-site.com/order-confirmation"
  );
  await expect(page.locator(".order-confirmation")).toContainText(
    "ご注文ありがとうございます"
  );
  await expect(page.locator(".order-details")).toContainText("Sony WF-1000XM4");
});
```

:::

:::message

テストコードを書く際のポイントとして、**アサーションをテストコードの要所要所で利用することをお勧めします**。
\
例えば、未ログインユーザーでも商品の購入が可能である場合、ログインに失敗しても後続の振る舞いを行うことができてしまいます。
そのため、ログインに成功したことを確認するアサーションが存在しなければ、ログインに失敗してもこのテスト自体は成功します。
\
このように、「バグが存在するにもかかわらず、テストで見つけられない」という事態を防ぐためにも、適切な位置でアサーションを配置することが重要です。
\
今回の例だと、ログイン後のホームページにユーザー情報が表示されていることを検証しています。

```ts
// 4. ホームページが表示されることを確認する
await expect(page).toHaveURL("https://example-ec-site.com/home");
await expect(page.locator(".user-greeting")).toContainText(
  "Welcome, user@example.com"
);
```

:::

## 壊れにくいテストを作る

E2E に限らず、**自動テストにおいて信頼性の高い実行結果を保つことは重要です**。
「信頼性が高い実行結果」とは、「**アプリケーションの振る舞いが変わらない限り、テストの結果は変わらない**」ということです。

信頼性が高ければ、開発者は自動テストの結果を信じることができます。（当然ですね）
自動テストの結果を信じることができれば、自身の書いたプロダクトコードに対し、

- テスト成功 → リリースやデプロイ OK
- テスト失敗 → コードに直すべき場所がある

を開発工程で素早く判断することができます。

このような状態を作ってくれるのが自動テストの良さであるため、テストの結果を安定させ、信頼性を高めるようなテストを設計することは非常に重要なのです。

:::message

実行結果が不安定であり、信頼性が低いテストのことを「**Flaky Test**」と呼びます。
この用語は様々な記事や書籍で登場するので覚えておいたほうが良いでしょう。

:::

では、壊れにくく、信頼性を保ち続けられるような E2E テストを作るにはどうすれば良いのでしょうか？
主要な取り組みとして、以下が挙げられます。

- アクセシビリティ属性に基づいた要素特定を行う
- テストごとにデータを用意する
- テストをリトライする

### アクセシビリティ属性に基づいた要素特定を行う

アクセシビリティ属性を利用して要素を特定することは、壊れにくい E2E テストを作成する上で非常に重要な手法です。

アクセシビリティ属性には、ボタン、リンク、テキストボックスなどがあり、これらの要素は、HTML のタグが持つ役割（Role）によって定義されます。
例えば、`<button>` タグには自動的に `button` というロールが割り当てられます。

HTML タグや `class`、`id` など、DOM の具体的な構造に強く依存したテストコードを記述していると、些細な内部実装の変化ですぐにテストが失敗するようになります。

```diff html
- <input id="user-email" type="email" />
+ <input type="email" />
```

```ts
// `id=user-email`が変化したらテストは失敗する
await page.fill("#user-email", "test@example.com");
```

そのため、DOM の構造ではなく役割（Role）に依存したテストコードを記述するようにしましょう。

Playwright では、`getByRole()`、`getByLabel()` メソッドを提供しており、これらを使用すると明示的にアクセシビリティに基づいた要素特定ができます。

先ほどの EC サイトを例にしたテストコードは、DOM の構造に強く依存していたため、改善します。

:::details 改善後のテストコード

```diff ts
const { test, expect } = require("@playwright/test");

 test("既存ユーザーが EC サイトにログインし、商品を検索して購入する", async ({
   page,
 }) => {
   // 1. ログインページにアクセスする
   await page.goto("https://example-ec-site.com/login");

   // 2. ユーザー名とパスワードを入力する
-  await page.fill("#email", "user@example.com");
-  await page.fill("#password", "password123");
+  await page.getByLabel('メールアドレス').fill("user@example.com");
+  await page.getByLabel('パスワード').fill("password123");

   // 3. ログインボタンをクリックする
-  await page.click("#login-button");
+  await page.getByRole('button', { name: 'ログイン' }).click();

   // 4. ホームページが表示されることを確認する
   await expect(page).toHaveURL("https://example-ec-site.com/home");
-  await expect(page.locator(".user-greeting")).toContainText(
-    "Welcome, user@example.com"
-  );
+  await expect(page.getByText("Welcome, user@example.com")).toBeVisible();

   // 5. 検索バーに商品名を入力する
-  await page.fill("#search-input", "ワイヤレスイヤホン");
+  await page.getByPlaceholder('商品を検索').fill("ワイヤレスイヤホン");

   // 6. 検索ボタンをクリックする
-  await page.click("#search-button");
+  await page.getByRole('button', { name: '検索' }).click();

   // 7. 検索結果ページが表示されることを確認する
   await expect(page).toHaveURL(
     "https://example-ec-site.com/search?q=ワイヤレスイヤホン"
   );
-  await expect(page.locator(".search-results")).toBeVisible();
+  await expect(page.getByRole('region', { name: '検索結果' })).toBeVisible();

   // 8. 目的の商品をクリックする
-  await page.click("text=Sony WF-1000XM4");
+  await page.getByRole('link', { name: 'Sony WF-1000XM4' }).click();

   // 9. 商品詳細ページが表示されることを確認する
   await expect(page).toHaveURL(/\/product\/sony-wf-1000xm4/);
-  await expect(page.locator("h1")).toContainText("Sony WF-1000XM4");
+  await expect(page.getByRole('heading', { name: 'Sony WF-1000XM4', level: 1 })).toBeVisible();

   // 10. 「カートに追加」ボタンをクリックする
-  await page.click("#add-to-cart-button");
+  await page.getByRole('button', { name: 'カートに追加' }).click();

   // 11. カートページに遷移することを確認する
   await expect(page).toHaveURL("https://example-ec-site.com/cart");
-  await expect(page.locator(".cart-items")).toContainText("Sony WF-1000XM4");
+  await expect(page.getByRole('region', { name: 'カート' })).toContainText("Sony WF-1000XM4");

   // 12. 「購入手続きへ」ボタンをクリックする
-  await page.click("#proceed-to-checkout");
+  await page.getByRole('button', { name: '購入手続きへ' }).click();

   // 13. 配送先情報を入力する
-  await page.fill("#shipping-address", "東京都渋谷区テスト町 1-1-1");
+  await page.getByLabel('配送先住所').fill("東京都渋谷区テスト町 1-1-1");

   // 14. 支払い方法を選択する
-  await page.selectOption("#payment-method", "credit-card");
-  await page.fill("#card-number", "4111111111111111");
-  await page.fill("#card-expiry", "12/25");
-  await page.fill("#card-cvc", "123");
+  await page.getByLabel('支払い方法').selectOption('credit-card');
+  await page.getByLabel('カード番号').fill("4111111111111111");
+  await page.getByLabel('有効期限').fill("12/25");
+  await page.getByLabel('セキュリティコード').fill("123");

   // 15. 「注文確定」ボタンをクリックする
-  await page.click("#place-order-button");
+  await page.getByRole('button', { name: '注文確定' }).click();

   // 16. 注文完了ページが表示されることを確認する
   await expect(page).toHaveURL(
     "https://example-ec-site.com/order-confirmation"
   );
-  await expect(page.locator(".order-confirmation")).toContainText(
-    "ご注文ありがとうございます"
-  );
-  await expect(page.locator(".order-details")).toContainText("Sony WF-1000XM4");
+  await expect(page.getByRole('heading', { name: 'ご注文ありがとうございます' })).toBeVisible();
+  await expect(page.getByRole('region', { name: '注文詳細' })).toContainText("Sony WF-1000XM4");
 });
```

:::

:::message
**アクセシビリティ属性に基づいた要素特定ができない場合**

アクセシビリティ属性に基づいた要素特定が難しく、仕方なく DOM の具体的な構造に強く依存したテストコードを記述しなければならない場合もあると思います。
そんな時は、**アプリケーションコード自体のリファクタリングを検討することをお勧めします**。
\
適切なアクセシビリティ属性を持つ HTML を生成することで、以下のメリットがあります。

1. テストの安定性と保守性の向上
2. アプリケーションの全体的なアクセシビリティの改善

テスタビリティの高いアプリケーションコードを書くことは、長期的には開発効率と品質の向上につながります。

:::

### テストごとにテスト専用データを用意する

テストごとに専用データを用意することで、**テストの独立性を高めることができます**。
すでに存在するデータや、他のテストで準備したデータを利用すると、依存関係が生まれ、実行結果が不安定になる可能性があります。

そのため、**既存のデータを利用することを避け、新しいデータを作成する**ようにしましょう。

Playwright では、テストごとに前処理及び後処理を行えるメソッド `test.beforeEach()`、`test.afterAll()` が存在します。
こちらを使用して、テスト用データの作成やテスト完了後のデータ削除処理を行うと良いでしょう。

EC サイトを例にしたテストコードの改善を行います。

:::details 改善後のテストコード

```diff ts
const { test, expect } = require("@playwright/test");

+test.describe('ECサイトの購入フロー', () => {
+let productId;
+
+
+  test.beforeEach(async ({ request }) => {
+    // テストデータ作成用のAPIリクエスト
+    const response = await request.post('https://example-ec-site.com/api/products', {
+      data: {
+        name: "Sony WF-1000XM4",
+        price: 29980,
+        stock: 10
+      },
+      headers: {
+        'Content-Type': 'application/json',
+        'Authorization': 'Bearer test-api-key'
+      }
+    });
+    // レスポンスのステータスコードを確認
+    expect(response.ok()).toBeTruthy();
+    const responseBody = await response.json();
+    productId = responseBody.id;
+  });
+
+  test.afterEach(async ({ request }) => {
+    // テストデータのクリーンアップ
+    const response = await request.delete(`https://example-ec-site.com/api/products/${productId}`, {
+      headers: {
+        'Authorization': 'Bearer test-api-key'
+      }
+    });
+    expect(response.ok()).toBeTruthy();
+  });
+
   test("既存ユーザーが商品を検索して購入する", async ({
     page,
   }) => {
     // 1. ログインページにアクセスする
     await page.goto("https://example-ec-site.com/login");

     // 2. ユーザー名とパスワードを入力する
     await page.getByLabel('メールアドレス').fill("user@example.com");
     await page.getByLabel('パスワード').fill("password123");

     // 3. ログインボタンをクリックする
     await page.getByRole('button', { name: 'ログイン' }).click();

     // 4. ホームページが表示されることを確認する
     await expect(page).toHaveURL("https://example-ec-site.com/home");
     await expect(page.getByText("Welcome, user@example.com")).toBeVisible();

     // 5. 検索バーに商品名を入力する
     await page.getByPlaceholder('商品を検索').fill("ワイヤレスイヤホン");

     // 6. 検索ボタンをクリックする
     await page.getByRole('button', { name: '検索' }).click();

     // 7. 検索結果ページが表示されることを確認する
     await expect(page).toHaveURL(
       "https://example-ec-site.com/search?q=ワイヤレスイヤホン"
     );
     await expect(page.getByRole('region', { name: '検索結果' })).toBeVisible();

     // 8. 目的の商品をクリックする
     await page.getByRole('link', { name: 'Sony WF-1000XM4' }).click();

     // 9. 商品詳細ページが表示されることを確認する
     await expect(page).toHaveURL(/\/product\/sony-wf-1000xm4/);
     await expect(page.getByRole('heading', { name: 'Sony WF-1000XM4', level: 1 })).toBeVisible();

     // 10. 「カートに追加」ボタンをクリックする
     await page.getByRole('button', { name: 'カートに追加' }).click();

     // 11. カートページに遷移することを確認する
     await expect(page).toHaveURL("https://example-ec-site.com/cart");
     await expect(page.getByRole('region', { name: 'カート' })).toContainText("Sony WF-1000XM4");

     // 12. 「購入手続きへ」ボタンをクリックする
     await page.getByRole('button', { name: '購入手続きへ' }).click();

     // 13. 配送先情報を入力する
     await page.getByLabel('配送先住所').fill("東京都渋谷区テスト町 1-1-1");

     // 14. 支払い方法を選択する
     await page.getByLabel('支払い方法').selectOption('credit-card');
     await page.getByLabel('カード番号').fill("4111111111111111");
     await page.getByLabel('有効期限').fill("12/25");
     await page.getByLabel('セキュリティコード').fill("123");

     // 15. 「注文確定」ボタンをクリックする
     await page.getByRole('button', { name: '注文確定' }).click();

     // 16. 注文完了ページが表示されることを確認する
     await expect(page).toHaveURL(
       "https://example-ec-site.com/order-confirmation"
     );
     await expect(page.getByRole('heading', { name: 'ご注文ありがとうございます' })).toBeVisible();
     await expect(page.getByRole('region', { name: '注文詳細' })).toContainText("Sony WF-1000XM4");
   });
+});
```

:::

### テストをリトライする

E2E テストは、多層のシステムコンポーネントと外部要因が複雑に相互作用する状況でテストを行なっています。
それ故に、ネットワークの遅延、非同期処理、UI の描画遅延など、様々な要因でどうしても実行結果がランダムに失敗することもあります。
そのため、1 回の失敗で「信頼性のないテスト」とみなすのは現実的ではないテストも存在するでしょう。

そのような場合に、テストのリトライを行うことは有効な手段です。
「3 回の施行で 1 回でも正解すればテスト成功とみなす」といったルールを設定しておけば、不安定な E2E テストを削減できるでしょう。

[Playwright](https://playwright.dev/docs/test-retries#retries) では、以下のように様々な形式でリトライを設定することが可能です。

:::details テスト実行時にリトライ回数を設定する

```shell
# Give failing tests 3 retry attempts
npx playwright test --retries=3
```

:::

:::details Playwright の config ファイルでリトライ回数を設定する

```ts: playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  // Give failing tests 3 retry attempts
  retries: 3,
});
```

:::

:::details テストグループ単位でリトライを設定する

```ts
import { test, expect } from "@playwright/test";

test.describe(() => {
  // All tests in this describe group will get 2 retry attempts.
  test.describe.configure({ retries: 2 });

  test("test 1", async ({ page }) => {
    // ...
  });

  test("test 2", async ({ page }) => {
    // ...
  });
});
```

:::

:::message

Playwright では、テスト結果をカテゴライズしてくれます。（便利！！）

- `passed` : 1 回目のテストで成功したことを示す
- `flaky` : リトライにより成功したことを示す
- `failed` : リトライしても失敗したことを示す

```shell
Running 3 tests using 1 worker

  ✓ example.spec.ts:4:2 › first passes (438ms)
  x example.spec.ts:5:2 › second flaky (691ms)
  ✓ example.spec.ts:5:2 › second flaky (522ms)
  ✓ example.spec.ts:6:2 › third passes (932ms)

  1 flaky
    example.spec.ts:5:2 › second flaky
  2 passed (4s)
```

:::

## テストコードの可読性を高める

次は、先ほどの EC サイトの例を続きに、テストコードの**可読性**を高める方法についていくつか解説していきます。

:::details 改善するテストコードはこちら

```ts
const { test, expect } = require("@playwright/test");

test.describe("ECサイトの購入フロー", () => {
  {
    /* 専用データの事前・事後処理は省略 */
  }

  test("既存ユーザーが商品を検索して購入する", async ({ page }) => {
    // 1. ログインページにアクセスする
    await page.goto("https://example-ec-site.com/login");

    // 2. ユーザー名とパスワードを入力する
    await page.getByLabel("メールアドレス").fill("user@example.com");
    await page.getByLabel("パスワード").fill("password123");

    // 3. ログインボタンをクリックする
    await page.getByRole("button", { name: "ログイン" }).click();

    // 4. ホームページが表示されることを確認する
    await expect(page).toHaveURL("https://example-ec-site.com/home");
    await expect(page.getByText("Welcome, user@example.com")).toBeVisible();

    // 5. 検索バーに商品名を入力する
    await page.getByPlaceholder("商品を検索").fill("ワイヤレスイヤホン");

    // 6. 検索ボタンをクリックする
    await page.getByRole("button", { name: "検索" }).click();

    // 7. 検索結果ページが表示されることを確認する
    await expect(page).toHaveURL(
      "https://example-ec-site.com/search?q=ワイヤレスイヤホン"
    );
    await expect(page.getByRole("region", { name: "検索結果" })).toBeVisible();

    // 8. 目的の商品をクリックする
    await page.getByRole("link", { name: "Sony WF-1000XM4" }).click();

    // 9. 商品詳細ページが表示されることを確認する
    await expect(page).toHaveURL(/\/product\/sony-wf-1000xm4/);
    await expect(
      page.getByRole("heading", { name: "Sony WF-1000XM4", level: 1 })
    ).toBeVisible();

    // 10. 「カートに追加」ボタンをクリックする
    await page.getByRole("button", { name: "カートに追加" }).click();

    // 11. カートページに遷移することを確認する
    await expect(page).toHaveURL("https://example-ec-site.com/cart");
    await expect(page.getByRole("region", { name: "カート" })).toContainText(
      "Sony WF-1000XM4"
    );

    // 12. 「購入手続きへ」ボタンをクリックする
    await page.getByRole("button", { name: "購入手続きへ" }).click();

    // 13. 配送先情報を入力する
    await page.getByLabel("配送先住所").fill("東京都渋谷区テスト町 1-1-1");

    // 14. 支払い方法を選択する
    await page.getByLabel("支払い方法").selectOption("credit-card");
    await page.getByLabel("カード番号").fill("4111111111111111");
    await page.getByLabel("有効期限").fill("12/25");
    await page.getByLabel("セキュリティコード").fill("123");

    // 15. 「注文確定」ボタンをクリックする
    await page.getByRole("button", { name: "注文確定" }).click();

    // 16. 注文完了ページが表示されることを確認する
    await expect(page).toHaveURL(
      "https://example-ec-site.com/order-confirmation"
    );
    await expect(
      page.getByRole("heading", { name: "ご注文ありがとうございます" })
    ).toBeVisible();
    await expect(page.getByRole("region", { name: "注文詳細" })).toContainText(
      "Sony WF-1000XM4"
    );
  });
});
```

:::

### テストケースの意図を記述する

`test()` や `test.describe()` 関数の第一引数にはテストケース名・テストグループ（テストスイート）名を指定します。
どんな文言を指定するか悩みますよね...

基本的な方針として、「**目的を具体的に書く**」ことを意識しましょう。
何を確認するためのテストなのかを一目で判断できる状態に保つことが重要です。

今回の例だと、`test("購入テスト")`　ではなく、`test("既存ユーザーが商品を検索して購入する")` といった感じです。
「購入テスト」だけではユーザーシナリオが伝わりづらいですよね...

E2E テストでは、どんなシナリオを確認するのかを明確にすると良いです。

### 「目的のためのコード」と「事前・事後処理」を分離する

テストの本質的な部分（目的のためのコード）とそれを実行するための準備や後片付け（事前・事後処理）を明確に分離することで、可読性が向上します。

Playwright の場合、`beforeEach()` や `beforeAll()`、`afterEach()`、`afterAll()` を活用することで、事前・事後処理として必要なコードを `test()` 関数から切り離すことができます。

今回の例だと、テストの目的は「既存ユーザーが商品を検索して購入する」というシナリオを検証することです。
そのため、ログイン処理やテスト専用データの準備・後片付けを行うためのコードは `test()` 関数から切り離します。

:::details 改善後のテストコード

```diff ts
  const { test, expect } = require("@playwright/test");

  test.describe("ECサイトの購入フロー", () => {
    {
      /* 専用データの事前・事後処理は省略 */
    }

+   beforeEach(() => {
+     // 1. ログインページにアクセスする
+     await page.goto("https://example-ec-site.com/login");
+
+     // 2. ユーザー名とパスワードを入力する
+     await page.getByLabel("メールアドレス").fill("user@example.com");
+     await page.getByLabel("パスワード").fill("password123");
+
+     // 3. ログインボタンをクリックする
+     await page.getByRole("button", { name: "ログイン" }).click();
+
+     // 4. ホームページが表示されることを確認する
+     await expect(page).toHaveURL("https://example-ec-site.com/home");
+     await expect(page.getByText("Welcome, user@example.com")).toBeVisible();
+   });

    test("既存ユーザーが商品を検索して購入する", async ({ page }) => {
-     // 1. ログインページにアクセスする
-     await page.goto("https://example-ec-site.com/login");
-
-     // 2. ユーザー名とパスワードを入力する
-     await page.getByLabel("メールアドレス").fill("user@example.com");
-     await page.getByLabel("パスワード").fill("password123");
-
-     // 3. ログインボタンをクリックする
-     await page.getByRole("button", { name: "ログイン" }).click();

-     // 4. ホームページが表示されることを確認する
-     await expect(page).toHaveURL("https://example-ec-site.com/home");
-     await expect(page.getByText("Welcome, user@example.com")).toBeVisible();

      // 5. 検索バーに商品名を入力する
      await page.getByPlaceholder("商品を検索").fill("ワイヤレスイヤホン");

      // 6. 検索ボタンをクリックする
      await page.getByRole("button", { name: "検索" }).click();

      // 7. 検索結果ページが表示されることを確認する
      await expect(page).toHaveURL(
        "https://example-ec-site.com/search?q=ワイヤレスイヤホン"
      );
      await expect(page.getByRole("region", { name: "検索結果" })).toBeVisible();

      // 8. 目的の商品をクリックする
      await page.getByRole("link", { name: "Sony WF-1000XM4" }).click();

      // 9. 商品詳細ページが表示されることを確認する
      await expect(page).toHaveURL(/\/product\/sony-wf-1000xm4/);
      await expect(
        page.getByRole("heading", { name: "Sony WF-1000XM4", level: 1 })
      ).toBeVisible();

      // 10. 「カートに追加」ボタンをクリックする
      await page.getByRole("button", { name: "カートに追加" }).click();

      // 11. カートページに遷移することを確認する
      await expect(page).toHaveURL("https://example-ec-site.com/cart");
      await expect(page.getByRole("region", { name: "カート" })).toContainText(
        "Sony WF-1000XM4"
      );

      // 12. 「購入手続きへ」ボタンをクリックする
      await page.getByRole("button", { name: "購入手続きへ" }).click();

      // 13. 配送先情報を入力する
      await page.getByLabel("配送先住所").fill("東京都渋谷区テスト町 1-1-1");

      // 14. 支払い方法を選択する
      await page.getByLabel("支払い方法").selectOption("credit-card");
      await page.getByLabel("カード番号").fill("4111111111111111");
      await page.getByLabel("有効期限").fill("12/25");
      await page.getByLabel("セキュリティコード").fill("123");

      // 15. 「注文確定」ボタンをクリックする
      await page.getByRole("button", { name: "注文確定" }).click();

      // 16. 注文完了ページが表示されることを確認する
      await expect(page).toHaveURL(
        "https://example-ec-site.com/order-confirmation"
      );
      await expect(
        page.getByRole("heading", { name: "ご注文ありがとうございます" })
      ).toBeVisible();
      await expect(page.getByRole("region", { name: "注文詳細" })).toContainText(
        "Sony WF-1000XM4"
      );
    });
  });
```

:::

### 1 つのテストケースに複数のシナリオを詰め込まない

基本的に、1 つのテストケースには 1 つシナリオを検証するようにしましょう。

同じ画面にあるからと、あれこれチェックしたりするのはアンチパターンです。
（商品の購入とレビューの投稿を一緒にするなど）

何を確認するためのテストなのかが分かりにくくなりますし、失敗したときの原因も特定しづらくなります。

### コメントを付ける

ユーザーの振る舞いが把握しにくいコードが存在する場合、コメントを付与は可読性を高めるための有効な手段です。
要素特定を行う上で内部実装が原因でやむおえず複雑なコードになってしまう場合などです。

```ts
const complexSelector = await page.locator(
  "div.product-container > div.product-list > div.product-row:nth-child(3) > div.product-cell:nth-child(2) > div.product-info > div.product-actions > button.view-details"
);
```

E2E テストコードは、ソフトウェアの使い方や機能を示す「生きたドキュメント」としての役割も果たします。
そのため、理解を補助するという意味でも、コメントは重要です。

### ページ単位で構造化する

テストコードの再利用性と可読性を向上させるためのデザインパターンとして、**Page Object Models（POM）** というものがあります。
POM は、各ページをオブジェクトとして表現し、そのページの要素をプロパティ、操作をメソッドとして定義します。

ログインページを例にすると以下のようになります。

```ts: LoginPage.ts
class LoginPage {
  readonly page: Page;
  readonly mailInput: Locator;
  readonly passwordInput: Locator;
  readonly loginButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.mailInput = page.getByLabel("メールアドレス");
    this.passwordInput = page.getByLabel("パスワード");
    this.loginButton = page.getByRole("button", { name: "ログイン" });
  }

  async navigateTo() {
    await this.page.goto("/login");
  }

  async login(username: string, password: string) {
    await this.mailInput.fill("user@example.com");
    await this.passwordInput.fill("password123");
    await this.loginButton.click();
  }
}
```

```ts
test("ユーザーが正常にログインできる", async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.navigateTo();
  await loginPage.login("testuser", "password123");

  await expect(page).toHaveURL("/dashboard");
});
```

ページ単位で要素特定を隠蔽し、操作を抽象化することで、UI の変更が発生しても、テストコードそのものには影響せず、ページオブジェクトをの方を修正すれば良いため、可読性とメンテナンス性が向上するという考え方です。

また、抽象化によって一度記述した操作をのページでも再利用できるため、コード量を減らすことも可能です。

:::message

POM はテストコードの一部を抽象化してくれる便利なデザインパターンです。
\
しかし、E2E テストの場合、**そこまで再利用性が求められることも少なく、アプリケーションコードほど DRY に書く必要はありません**。
むしろ、手続き型でゴリゴリ書いたほうが読みやすいことのほうが多いという意見もあります。
\
過度に抽象化すると、個々のテストケースの意図や検証内容が分かりにくくなってしまう場合もあります。
テストは「生きたドキュメント」としての役割もあるため、**単独でコードを読んでも処理の流れが把握できることが大切です**。
そのため、POM を使用する際はテストの可読性と理解容易性を損なわない程度の抽象化になっているか？を考慮しましょう。

:::

## 参考資料

https://www.amazon.co.jp/%E3%83%86%E3%82%B9%E3%83%88%E8%87%AA%E5%8B%95%E5%8C%96%E5%AE%9F%E8%B7%B5%E3%82%AC%E3%82%A4%E3%83%89-%E7%B6%99%E7%B6%9A%E7%9A%84%E3%81%ABWeb%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E6%94%B9%E5%96%84%E3%81%99%E3%82%8B%E3%81%9F%E3%82%81%E3%81%AE%E7%9F%A5%E8%AD%98%E3%81%A8%E6%8A%80%E6%B3%95-%E6%9C%AB%E6%9D%91-%E6%8B%93%E4%B9%9F/dp/4798172359/ref=pd_bxgy_d_sccl_2/357-8901376-1742148?pd_rd_w=suLbK&content-id=amzn1.sym.cfa071a0-99a8-492e-b5ae-71db9847f457&pf_rd_p=cfa071a0-99a8-492e-b5ae-71db9847f457&pf_rd_r=2W2HKWC0XVNPN8RRK7YM&pd_rd_wg=bbqx8&pd_rd_r=bc64d66c-6976-4289-94f8-faacf1d8d414&pd_rd_i=4798172359&psc=1

https://www.amazon.co.jp/%EF%BC%BB%E5%85%A5%E9%96%80%EF%BC%BDWeb%E3%83%95%E3%83%AD%E3%83%B3%E3%83%88%E3%82%A8%E3%83%B3%E3%83%89-E2E-%E3%83%86%E3%82%B9%E3%83%88%E2%80%95%E2%80%95Playwright%E3%81%AB%E3%82%88%E3%82%8BWeb%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AE%E8%87%AA%E5%8B%95%E3%83%86%E3%82%B9%E3%83%88%E3%81%8B%E3%82%89%E8%89%AF%E3%81%84%E3%83%86%E3%82%B9%E3%83%88%E3%81%AE%E6%9B%B8%E3%81%8D%E6%96%B9%E3%81%BE%E3%81%A7-%E3%82%A8%E3%83%B3%E3%82%B8%E3%83%8B%E3%82%A2%E9%81%B8%E6%9B%B8-%E3%82%88%E3%81%97%E3%81%8D-ebook/dp/B0D5XPX4HR/ref=sr_1_1?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&crid=2F1IG534MNUI&dib=eyJ2IjoiMSJ9.5laI9K7qF0MuLof-97NSVjMuAa-ie4dqwv1ZuRxKikgsMlhCusTl_M8LsBg4ck9fzGHrkFVgNKtlqLWtbLVGjPQwh1inVq-l2AoSYxx3APujqQC9Pm_t-5--OeO_MOPjLcJOS-dhadH2bxbqZDAYHYo0u0C6J0S4tePJK_WAGNfOEPSIVKT_N2224p2pejEtVQBOn0gK70MYv_OYT4doalblgY329xw646nPfCL5bIs.nJiC2Jd-hxNZ_7je7J4CSqwuMfH6GK3enOweJgrDjPw&dib_tag=se&keywords=Playwright&qid=1728483020&s=books&sprefix=playwright,stripbooks,191&sr=1-1

https://www.amazon.co.jp/%E3%83%95%E3%83%AD%E3%83%B3%E3%83%88%E3%82%A8%E3%83%B3%E3%83%89%E9%96%8B%E7%99%BA%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E5%85%A5%E9%96%80-%E4%BB%8A%E3%81%8B%E3%82%89%E3%81%A7%E3%82%82%E7%9F%A5%E3%81%A3%E3%81%A6%E3%81%8A%E3%81%8D%E3%81%9F%E3%81%84%E8%87%AA%E5%8B%95%E3%83%86%E3%82%B9%E3%83%88%E6%88%A6%E7%95%A5%E3%81%AE%E5%BF%85%E9%A0%88%E7%9F%A5%E8%AD%98-%E5%90%89%E4%BA%95-%E5%81%A5%E6%96%87/dp/4798178187

https://speakerdeck.com/autifyhq/tesutozi-dong-hua-kara-kai-fa-wozhi-eruji-sok-de-tesutohe

https://speakerdeck.com/tsuemura/tesutowozi-dong-hua-surufalsewoyame-zi-dong-tesutowozuo-rou

https://levtech.jp/media/article/column/detail_496/#ttl_2

https://qiita.com/tsuemura/items/c6703efc107314b66d7b

https://tech.smarthr.jp/entry/2024/06/18/140311

https://speakerdeck.com/rhumie/introduction-to-e2e-testing-with-playwright
