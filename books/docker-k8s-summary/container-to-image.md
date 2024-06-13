---
title: "コンテナのイメージ化"
---

![](https://storage.googleapis.com/zenn-user-upload/40e132118784-20240613.png)
コンテナのイメージ化により、コンテナ環境の共有やコンテナの移動が可能になる。
![](https://storage.googleapis.com/zenn-user-upload/2159efced2ca-20240613.png)

## イメージ化の手法

手法は 2 つある。

### `commit` でイメージを書き出す

![](https://storage.googleapis.com/zenn-user-upload/dc9b58c4b4bd-20240613.png)

コンテナを用意し、そこからコマンドでイメージを生成する。

- **メリット**
  - `commit` コマンド一発でイメージの生成が可能
  - 手軽
- **デメリット**
  - コンテナを作り込む必要がある
- **ユースケース**
  - 既に存在するコンテナを複製したい場合
  - 既に存在するコンテナを移動したい場合

```shell
docker commit <コンテナ名> <作成するイメージ名>
```

### Dockerfile でイメージを作成する

- `Dockerfile` という名前のファイルを用意し、それを build することでイメージを生成する
- **Dockerfile はイメージを作成することしかできない**
