---
title: "Poetryまとめ"
emoji: "⛳"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [python, poetry]
published: false
---

## Poetry とは？

- `npm`の python 版みたいなもの
- パッケージ管理がメイン
- 仮想環境の管理もできる
- 仮想環境の管理には pyenv との組み合わせが前提のため、pyenv を入れる必要がある

## Poetry のインストール

https://cocoatomo.github.io/poetry-ja/

### 初期設定（グローバル設定）

プロジェクト毎に仮想環境が構築されるようにするには以下のコマンド

```shell
poetry config virtualenvs.create true
poetry config virtualenvs.in-project true
```

## 新規プロジェクトの作成

- `src`フォルダを作成する場合

  ```shell
  poetry new --src <プロジェクト名>
  ```

  :::details ディレクトリ構成

  ```
  .
  ├── pyproject.toml
  ├── README.rst
  ├── src
  │   └── <ブロジェクト名>
  │       └── init.py
  └── tests
  ├── init.py
  └── test_python_test.py
  ```

  :::
  `pyproject.toml`がパッケージ管理ファイルで、 node.js でいう`package.json`

- `src`フォルダを作成しない場合

  ```shell
  poetry new <プロジェクト名>
  ```

  :::details ディレクトリ構成

  ```
  .
  ├── pyproject.toml
  ├── python_test
  │   └── __init__.py
  ├── README.rst
  └── tests
  ├── __init__.py
  └── test_python_test.py
  ```

  :::

## 既存プロジェクトに poetry を導入する

```shell
poetry init
```

- あくまで `pyproject.toml` を作成してパッケージ管理するだけ
- `test` ディレクトリやプロジェクトディレクトリなどは作成されない

## パッケージ管理

```shell
# 追加
peotry add <package-name>

# 削除
poetry remove <package-name>

# pyproject.tomlに書いてあるものをインストール(yarn installと同じ)
poetry install
```

## 依存パッケージのバージョンを変更する

1. `pyproject.toml` をに記載されているバージョンを直接編集する
2. `poetry update <パッケージ名>`

## 仮想環境に使う python バージョンの指定

```shell
poetry env use <version>

# 例
poetry env use 3.9.0
```

- python のバージョンは `pyproject.toml` に記載される
  ```toml
  [tool.poetry.dependencies]
  python = "^3.9"
  ```

:::details 注意点

1. 自動で`pyproject.toml`に書いてある python のバージョンを使ってはくれない
2. **使いたい python の version は pyenv とかからインストールしないといけない**

:::

## 仮想環境の作成・有効化

poetry には大きく分けて 2 つの仮想環境の有効化方法がある
:::details 新規シェルで有効化

```shell
poetry shell
```

- poetry 独自の方法
- 新しいシェルを作成し、そこで仮想環境を有効化している
- 仮想環境の無効化は以下のコマンド
  ```shell
  exit
  ```

:::

:::details 現在のシェルで有効化

```shell
source ./.venv/bin/activate
```

- venv などで取られている方法で、既存のシェルで仮想環境を読み込む
- 仮想環境の無効化は以下のコマンド
  ```shell
  deactivate
  ```
- poetry は新規プロジェクト作成時に仮想環境の作成まではしてくれない
  - **必ず最初は  `poetry shell`  をしないといけない**

:::

## Python のバージョンを変更する

1. `pyenv local` で仮想環境内でのみ別のバージョンの python を適応させる

```shell
pyenv local 3.8.3
```

2. `pyproject.toml` の Python のバージョンの欄を、 `pyenv local` で設定したバージョンに書き換える
3. `poetry env` コマンドで `toml` を参照して `venv` ファイルを作成する

```shell
poetry env use python
```

`.venv` フォルダ内の Python バージョンが変わらない場合、以下を試す。

```shell
poetry env use <バージョン（3.9.5など）>
```
