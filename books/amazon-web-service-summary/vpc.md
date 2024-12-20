---
title: "VPC"
---

## VPC とは？

- 「Virtual Private Cloud」の略
- 仮想的な自分専用クラウド

**AWS 上に構築された、自分専用の、隔離されたプライベートなネットワーク空間**

![](https://storage.googleapis.com/zenn-user-upload/2b4da96cf155-20240605.png)

このプライベートなネットワーク空間に EC2 などのサービスを構築していくようなイメージ。

## VPC の目的

**サーバーレスではないサービスを使用する時のサーバーの置き場として使用する。**
サーバーを置くためのネットワーク（土地）を用意するために VPC が必要。

**同じ VPC 内部のサービス同士は互いに通信することができる。**
別々の VPC にあるサーバー同士はデフォルトの状態では通信ができない。
（「VPC ピアリング」という機能を使うことで、別の VPC 同士で通信することが可能になる）

## VPC の料金

**無料！！！！！！**
しかし、NAT ゲートウェイなどの VPC オプションサービスには有料のものがある。

## デフォルトの VPC

AWS アカウントを作成した時点でデフォルトの VPC が作成されている。
デフォルトの VPC はインターネットにも接続可能になっているため、ここに EC2 を作成するとすぐにインターネットとやりとりが可能なサーバーを構築することが可能。

しかし、デフォルトの VPC はセキュリティ面が弱いため、本番環境では使用しない。

## VPC 関連サービス

代表的なものは以下。

- サブネット
- インターネットゲートウェイ
- NAT ゲートウェイ
- ルートテーブル

## サブネットとは?

**VPC の中に存在する小さなネットワークのこと。**
VPC だけではサーバーを作成することはできない。

VPC はリージョンに作成する。
サブネットはリージョン内のアベイラビリティゾーン（AZ）に作成する。

![](https://storage.googleapis.com/zenn-user-upload/be5127c4e551-20240605.png)

サブネットが別でも同じ VPC であれば通信が可能。

### パブリックサブネット・プライベートサブネット

![](https://storage.googleapis.com/zenn-user-upload/9d3a07b210e2-20240605.png)

**初めから public、private を設定するのではない。**
**インターネットと繋がっているサブネットを public、それ以外を private と識別しているだけ**

## インターネットゲートウェイ

public サブネットがインターネットと通信できるのは、インターネットゲートウェイが存在するから。

**public サブネットの通信は、インターネットゲートウェイという門を通ることで、外の世界と通信ができるようになる。**

private サブネットはインターネットゲートウェイを通ることができないため、インターネット通信できない。

![](https://storage.googleapis.com/zenn-user-upload/39560b391f72-20240605.png)

**「public であればインターネット通信できる」わけではない。**
**「インターネット通信できているのであれば、それは public」という認識。**

## NAT ゲートウェイ

private サブネットが public サブネットを通してインターネットと通信するための技術。

![](https://storage.googleapis.com/zenn-user-upload/9337146f829f-20240606.png)

### 結局、private と public 同じになるのでは？

NAT ゲートウェイには、内部からの通信は外に出すが、外部からの通信は「**内部からの通信に対する返信**」しか受け付けない。

![](https://storage.googleapis.com/zenn-user-upload/79674c7cdeb2-20240606.png)

## ルートテーブル

「**サブネット内にあるリソースから発生する通信をどこにむけて送るのか？**」のルールを、テーブル形式で表現したものです。

ルートテーブルは、**サブネット**単位で付与することができます。
1 つのサブネットに対して 1 つのルートテーブルが付与します。
ルートテーブルは、使いまわして他のサブネットにも付与できます。

![](https://storage.googleapis.com/zenn-user-upload/93424342668f-20240925.png)

ルートテーブルは「宛先」と「ターゲット」をカラムとして持っています。

- **宛先**: 通信の宛先となる IP アドレスの範囲を指定します
- **ターゲット**: 「宛先」からの通信をどこに送るか？を指定します

具体例で説明します。

![](https://storage.googleapis.com/zenn-user-upload/7cef55ad9277-20240925.png)

1. **宛先 : `10.0.0.0/16`, ターゲット: `local`**

   - サブネット内のリソースが、`10.0.0.0/16` に該当する IP アドレスに向けて通信を送った場合、すべて `local` に行き着きます
   - `local` は VPC 内のリソースを指します

   :::details EC2 インスタンス（10.0.0.5）から、IP 10.0.0.6 へ通信を送った場合

   IP `10.0.0.6` は `10.0.0.0/16` の範囲内であり、ターゲットは `local` なので、VPC 内のみに絞って送り先を探します。

   今回は、`10.0.0.6` に別の EC2 インスタンスが存在するため、その EC2 インスタンスに直接通信が転送されます。

   :::

   :::details EC2 インスタンス（10.0.0.5）から、IP 10.0.0.7 へ通信を送った場合

   IP `10.0.0.7` は `10.0.0.0/16` の範囲内であり、ターゲットは `local` なので、VPC 内のみに絞って送り先を探します。

   しかし、`10.0.0.7` にはどのリソースも割り当てられていません。
   そのため、この通信は失敗し、エラーとなります。
   :::

2. **宛先: `0.0.0.0/0`, ターゲット: `インターネットGW`**

   - サブネット内のリソースが、`0.0.0.0/0` に該当する IP アドレスに向けて通信を送った場合、すべてインターネット GW に転送されます
   - `0.0.0.0/0` はすべての IP アドレスを表します。つまり、他のより具体的なルート（今回の場合は `10.0.0.0/16`）に一致しないすべての通信がこのルートに該当します

   :::details EC2 インスタンス（10.0.0.5）から、IP 8.8.8.8 へ通信を送った場合

   IP `8.8.8.8` は `10.0.0.0/16` の範囲外であり、`0.0.0.0/0` に該当します。

   そのため、ターゲットである インターネット GW に通信が転送されます。

   この通信は、インターネットゲートウェイを経由してインターネットに送出され、最終的に `8.8.8.8` に到達します。

   :::

### メインルートテーブル・カスタムルートテーブル

実は、ルートテーブルには種類が存在します。
それが、「メインルートテーブル」と「カスタムルートテーブル」です。

#### メインルートテーブル

VPC 作成時に自動で作成されるルートテーブルです。
**明示的に他のルートテーブルが関連付けられていないサブネットに自動的に適用されます**。

デフォルトだと、テーブルの中身は以下のようになっています。

| 宛先                 | ターゲット |
| -------------------- | ---------- |
| VPC の CIDR ブロック | local      |

特にルートテーブルの設定をしていなくても、VPC 内で通信が出来ているのは、各サブネットに対してメインルートテーブルがデフォルトで存在しているからなんですね！

:::message

メインルートテーブルはルートの追加、削除、変更が可能です。
しかし、**メインルートテーブルを編集するのは非推奨です**。

これは、「メインルートテーブルがデフォルトのルートテーブルとして自動適用される」という特性があるからです。
編集したルートテーブルが、想定していないサブネットに関連付けられたら困りますよね？？

:::

#### カスタムルートテーブル

自身で作成し、設定するルートテーブルです。
明示的にサブネットに関連づけます。

VPC 作成と同時に作成・付与することもできます。
