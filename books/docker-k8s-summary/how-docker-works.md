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
