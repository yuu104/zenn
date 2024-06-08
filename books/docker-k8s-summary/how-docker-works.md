---
title: "Dockerが動く仕組み"
---

## Docker のざっくりした構成

![](https://storage.googleapis.com/zenn-user-upload/5c1c04f32d3e-20240605.png)

ざっくりまとめると、Docker は以下の要素で構成されている。

1. 物理的なマシン（サーバー）
2. Linux OS
3. Docker Engine
4. コンテナ

## コンテナの中にも OS がある

**コンテナには「Linux OS っぽいもの」が入っている。**
完全な OS ではないため、「OS っぽいもの」という表現をしている。

![](https://storage.googleapis.com/zenn-user-upload/0751ec48d902-20240605.png)

### そもそも OS って何だっけ？

:::details OS はプログラムとハードウェアの仲介人

- **責務**

  - プログラムによる命令をハードウェアに伝える

- **プログラムから直接ハードウェアに命令すれば良くね？**
  - ハードウェア視点だと、プログラムの命令は雑すぎる。
  - ハードウェアは細かく指示しないと動けない無能。

![](https://storage.googleapis.com/zenn-user-upload/b21eecf7caf5-20240605.png)

:::

:::details OS のざっくり構成

![](https://storage.googleapis.com/zenn-user-upload/316625d8998c-20240605.png)
_「カーネル」と呼ばれるメインの部分と、その他「周辺の部分」で構成されている。_

![](https://storage.googleapis.com/zenn-user-upload/01ddfe0551f4-20240605.png)
_プログラム → 　周辺部分 → 　カーネル → 　ハードウェア の順に命令が伝わる_

:::

### コンテナの中には OS の「周辺部分」がある

コンテナ内には「Linux OS っぽいもの」があると表現していた。
この「っぽいもの」の正体は、Linux OS の構成要素である「周辺部分」に該当する。
**コンテナ内にカーネルは入っていない。**

![](https://storage.googleapis.com/zenn-user-upload/f4a4300cfc2c-20240605.png)

プログラムを受け取る OS の「周辺部分」のみをそれぞれ用意し、核となる「カーネル」を他のコンテナと共有することで、Docker の特徴である「**軽さ**」を実現している。

## Docker は Linux OS 上で動く

Docker は Linux OS を利用する前提の仕組み。
**Linux OS でないと動かない。**

コンテナの中に入れる OS も Linux である必要がある。
そのため、**コンテナ内のソフトウェア（プログラム）も、Linux 用のソフトウェアを用意する。**
Windows や Mac 用のソフトウェアを入れても動かない。
![](https://storage.googleapis.com/zenn-user-upload/a55dcd14d1ae-20240605.png)

:::message
Docker と聞くと、サーバーを前提にして語られることが多い。
これは、「機能としてのサーバー」には Linux OS が使用されることが多いから。
:::

:::details OS のディストリビューションは統一しないとダメ？

**統一しなくていい。**
コンテナ内の OS（っぽいもの）は基本意識せずに「Latest（最新版）」を選択すれば良い。

:::

## Docker と VM の違い

両者「独立した環境を提供する」という観点では同じ。
しかし、以下の違いがある。

![](https://storage.googleapis.com/zenn-user-upload/f3df9fd35338-20240606.png)

1. **土台となる OS**
   - **Docker** : Linux OS 限定
   - **VM** : 自由
2. **独立環境下の OS**
   - **Docker** : Linux の「周辺部分」だけ
   - **VM** : フル OS で自由。土台 OS と異なっていても良い

Docker は軽量で効率的だが、ホスト OS と同じカーネルを共有する制約があり、VM は完全な OS を提供するため柔軟だが、リソース消費が大きい。

## Docker を Windows や Mac で動かす

**Docker は Linux 上でないと動かない。**
しかし、以下 2 つどちらかの方法により Wndows や Mac でも Docker を動かせる。

- VM を使用して Linux をインストールし、その上で Docker を動かす
- Docker の実行に必要な Linux を含むパッケージをインストールする
  - Docker Desktop for Windows
  - Docker Desktop for Mac

![](https://storage.googleapis.com/zenn-user-upload/d10beb33ee76-20240607.png)

## イメージ

**コンテナの「素」となるもの。設計図。**
イメージからコンテナが生成される。

イメージ → 　設計図
コンテナ → 　実態

![](https://storage.googleapis.com/zenn-user-upload/83e99f273395-20240607.png)

![](https://storage.googleapis.com/zenn-user-upload/6a03b9a4d8cf-20240607.png)

## コンテナからイメージを作成できる

![](https://storage.googleapis.com/zenn-user-upload/bed486e16bc4-20240607.png)

![](https://storage.googleapis.com/zenn-user-upload/e2ced0fda925-20240607.png)

## Docker から Dokecr へ移動できる

コンテナ ⇄ イメージの変換が可能なため、「Docker 上である」という条件を満たせば構築した環境を簡単に別のマシンへ移動可能。
![](https://storage.googleapis.com/zenn-user-upload/84c2eea4446e-20240607.png)

## Docker Hub

イメージは 1 から作る必要はない。
「Docker Hub」から取得することが可能。
Docker Hub は公式が出している Docker レジストリ（Docker イメージの配布場所）。
Git Hub みたいな感じ。
![](https://storage.googleapis.com/zenn-user-upload/03fbc119349b-20240607.png)
![](https://storage.googleapis.com/zenn-user-upload/2d872b8cba89-20240607.png)

### どんなイメージが入っている？

本当に様々ある。
![](https://storage.googleapis.com/zenn-user-upload/2d872b8cba89-20240607.png)
![](https://storage.googleapis.com/zenn-user-upload/1ddfd49465c0-20240607.png)

複数のソフトウェア・プログラムを含んだイメージもあり、組み合わも多数。
![](https://storage.googleapis.com/zenn-user-upload/809c9a51dc9b-20240607.png)

### 安全なイメージの選択方法

1. **公式が提供しているものを使う**
   - Docker 公式
   - ソフトウェアを開発している企業・団体
2. **必要最低限のものを選び、自分でカスタムする**
   - コンテナ ⇄ 　イメージへの変換が可能
   - 最低限のイメージを取得して、コンテナを生成し、そのコンテナをカスタムしてイメージを再生成すれば良い
   - OS（っぽいもの）を自作するのはお勧めしない

## コンテナの単位

コンテナの単位に制限はない。
![](https://storage.googleapis.com/zenn-user-upload/56c3df7fb92a-20240607.png)
セキュリティ面やメンテンス性の観点から、「1 コンテナ = 1 アプリ」が主流？

## コンテナのライフサイクル

![](https://storage.googleapis.com/zenn-user-upload/4dec7a028089-20240608.png)

### コンテナは「作っては捨てる」

ソフトウェア入りのコンテナは簡単に作れるため、1 つのコンテナを**アップデートするのではなく、次から次へと乗り換える**のが主流。
![](https://storage.googleapis.com/zenn-user-upload/cc09b83e8d9c-20240608.png)

なぜか？
それは、コンテナを使用する状況として、**複数のコンテナを同時稼働すること想定している**ため。
コンテナを一つ一つアップデートするのは大変。
**コンテナの構築が簡単である**という特徴を活かし、乗り換えによる運用をする。

## データの保存

「作っては捨てる」という運用をする場合、コンテナ内のデータはどうなるのか？
コンテナを破棄すれば中のデータも消える...

そのため、**データは物理マシンのディスクにマウント（繋げて書き込めるようにした状態）し、保存する。**
物理マシンの HDD や SSD と接続して、データを書き込める。

![](https://storage.googleapis.com/zenn-user-upload/649defd20fa9-20240608.png)

コンテナの外でデータを管理することで、他のコンテナとも共有できる。
![](https://storage.googleapis.com/zenn-user-upload/ba98f919a995-20240608.png)
設定ファイルなどの重要なデータは外部で保持しておき、機能的な部分を担うソフトウェアは頻繁に入れ替える。

## Docker のメリット

![](https://storage.googleapis.com/zenn-user-upload/3ef6498ce412-20240608.png)

根幹は「**隔離できる**」こと。
この特性故に、以下のようなメリットが存在する。

1. **独立していること**
   - 独立しているため、複数のコンテナを載せられるようになる
   - 故に「同じアプリを入れられる」
   - 一部だけを差し替えることも可能
2. **「イメージ化」が可能**
   - Docker Hub からの配布が可能となり、一から自分で作る必要がない
   - 構築のしやすさは「変更用意性」をもたらす
   - そして、「持ち運べる」という特徴にもつながる
3. **コンテナにカーネルを含める必要がない**
   - VM と比べて圧倒的に軽い
   - Linux という制限はあるが、コンテナごとにディストリビューションを自由に選択可能
4. **サーバー管理がしやすい**
   - コンテナによりそれぞれの環境を隔離できるため、影響範囲が狭く管理しやすい
   - 「作っては捨てる」ため、アップデートが簡単で常に新しい状態を保ちやすい
5. **サーバーに詳しくなくても扱いやすい**
   - サーバーの構築をコマンド１つで行える
   - コマンドさえ理解できればサーバー構築可能

## Docker のデメリット

1. **Linux OS という縛り**
   - Docker は Linux OS 上でしか動かない
   - そのため、コンテナに入れる環境も Linux 用のものしか対応していない
2. **複数環境を一つの物理マシンで管理することの弊害**
   - 通常、1 つの物理マシンにたくさんのコンテナを載せる
   - そのため、土台である物理マシンが駄目になったら全てのコンテナに影響する
   - 可用性を考慮した設計をするべき
3. **1 つのコンテナしか長期間運用する場合**
   - Docker は複数コンテナを使用することが前提
   - そのため、このケースは Docker の恩恵を受けにくい
   - Docker を使用するためには Docker Engine を載せる必要があり、コンテナ 1 つだけなら余計なものがあるだけになる
   - ただ、他のメンバーと簡単にコンテナ環境を共有できるので、そこはトレードオフ

## Docker の使い道

1. **開発環境で、全員に同じ環境を簡単に提供する**
   - 複数プロジェクトに関わっていたとしても、コンテナであれば環境汚染を防げる
   - 本番環境と同じものを作成できるため、開発環境と本番環境にズレがない
2. **新規のバージョンを実験的に使用する**
   - 物理マシンとの相性を考慮せずに使用できる
3. **複数の同じサーバーが必要な場面**
   - コンテナであれば、1 つの物理マシンに同じサーバーを何個でも作れる
   - そしてコマンド 1 つで必要なサーバーを立ち上げ可能
