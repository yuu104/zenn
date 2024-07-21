---
title: "Node.jsのバックエンドプロジェクトをコンテナ環境で作成する"
---

Express, TypeScript, PostgreSQL を使用したバックエンド開発をコンテナ環境で実現し、チーム開発を行う手順についてまとめる。

## プロジェクトのセットアップ

### 1. フォルダ構成

プロジェクトの基本的なフォルダ構成は以下の通り。

```
my-backend-api/
├── src/
│   └── index.ts
├── package.json
├── package.lock.json
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── tsconfig.json
├── Makefile
├── .env
└── README.md
```

### 2. 必要なファイルの作成

**`src/index.ts`**

```ts
import express from "express";

const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello, World!");
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
```

**`package.json`**

```json
{
  "name": "my-backend-api",
  "version": "1.0.0",
  "scripts": {
    "start": "node dist/index.js",
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.17.1",
    "pg": "^8.6.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.11",
    "nodemon": "^2.0.7",
    "ts-node": "^10.9.2",
    "typescript": "^4.2.4"
  }
}
```

**`.dockerignore`**

```.dockerignore
# すべてを無視する
**

# ただし、以下は許可する
!src/**
!package.*json
```

**`Dockerfile`**

マルチステージビルドを採用。
以下のステージに分かれている。

- `base` :
  - すべてのベースとなるイメージ
  - dev 環境ではこちらを利用する
  - 今回は全てのファイルをバインドマウントするため、ビルド時には何も入れない
- `build` :
  - ビルド用（イメージの「ビルド」ではない）のイメージ
- `prod` :
  - 本番環境用のイメージ
  - `build` イメージのビルドで生成されたファイルを利用する
  - これにより、ts ファイルなどの余計なファイルが取り除くことができ、イメージサイズを削減できる

```Dockerfile
###############
#    base     #
###############
FROM node:14 as base

WORKDIR /usr/src/app


###############
#    build    #
###############
FROM base as build

COPY . .

RUN npm install

RUN npm run build

###############
#    prod     #
###############
FROM node:14 as prod

COPY --from=build /usr/src/app/dist .

ENTRYPOINT [ "node", "index.js" ]
```

**`docker-compose.yml`**

```yaml
version: "3"

services:
  app:
    build:
      context: .
      target: base
    volumes:
      - type: bind
        source: .
        target: /usr/src/app
    ports:
      - "3000:3000"
    env_file:
      - .env
    depends_on:
      - db
    command: npm run dev

  app-build:
    build:
      context: .
      target: build

  db:
    image: postgres:13
    volumes:
      - type: volume
        source: db-data
        target: /var/lib/postgresql/data
    env_file:
      - .env
volumes:
  db-data:
```

**`.env`**

```env
NODE_ENV=development
DB_HOST=db
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=mydatabase

POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=mydatabase
```

**`Makefile`**

```Makefile
init:
	make clean
	docker-compose run --rm app npm install
	docker-compose down

clean:
	docker-compose down --rmi all

dev:
	docker-compose up db -d --build
	docker-compose up app --build

bash-app:
	docker-compose exec app /bin/bash

bash-db:
	docker-compose exec db /bin/bash

build:
	docker build --target build -t app-builder .

prod:
	docker build --target prod -t app-prod .
```

:::details init

初期化用のコマンド。
`node_modules` を更新したい場合にも使用する。

- `make clean`
  - 一度コンテナ・イメージを削除して綺麗にする
- `docker-compose run --rm app npm install`
  - ホスト側に `node_modules` を生成するためのコマンド
  - コンテナを起動し、コンテナ側に `node_modules` を生成する
  - コンテナ側で `node_modules` が生成されると、バインドマウントによりホスト側にも生成される
  - `--rm` により実行後はコンテナを削除する
  - これにより、後でコンテナを立ち上げた際にバインドマウントでコンテナ側に `node_modules` が入る
- `docker-compose down`
  - `db` サービスのコンテナを停止 → 削除するためのコマンド
  - `docker-compose run --rm app npm install` により、`db` サービスのコンテナも起動する
  - `--rm` で `app` のコンテナは削除されるが、`db` は起動したままになる

:::

:::details dev

**なぜビルドする必要があるのか？**

初回は `--build` を指定しなくても、Dockerfile からイメージがビルドされ、コンテナの作成・起動が行われる。
しかし、次回以降はイメージの再ビルドがされない。

リモートリポジトリからソースコードの変更があった際にパッケージの依存関係が変更されている可能性を考慮すると、毎回 `--build` をつけて再ビルドするようにしておいた方が良い。

:::

## 初期設定とリポジトリの共有

1. **リポジトリの初期化とプッシュ**

   ```sh
   git init
   git add .
   git commit -m "Initial commit with Docker setup"
   git remote add origin <your-repository-url>
   git push -u origin master
   ```

2. **リモートリポジトリからのクローンと環境設定**
   チームメンバーは以下の手順でリポジトリをクローンし、環境をセットアップする。

   ```sh
   git clone <your-repository-url>
   cd my-backend-api
   cp .env.example .env
   ```

## Docker コンテナ環境の初期化と起動

1. **コンテナ環境の初期化**
   ホスト側に `node_modules` を生成する。

   ```sh
   make init
   ```

   コンテナを生成・起動する

   ```sh
   make dev
   ```

2. **開発中のコード変更の反映**
   ホストマシンのエディタでコードを変更し、バインドマウントにより変更をリアルタイムでコンテナに反映させる。

## パッケージの追加

1. **コンテナ環境でシェルを開く**

   ```sh
   make bash-app
   ```

2. **新しいパッケージのインストール**

   ```sh
   npm install <パッケージ名>
   ```

3. **変更のコミットとプッシュ**
   コンテナ環境外で行う。

   ```sh
   git add package.json package-lock.json
   git commit -m "Add new package"
   git push origin master
   ```

## ローカルリポジトリの更新

1. **リモートリポジトリをプル**
   ```sh
   git pull origin master
   ```
2. **コンテナ環境を初期化**
   Docker の設定や `node_modules` を更新する。
   ```sh
   make init
   ```

## デプロイ

1. **ビルド用イメージの生成**

   ```sh
   make build
   ```

   コンテナを起動し、`dist/` フォルダが生成されているかを確認する。

   ```sh
   # コンテナを起動し、シェルに入る
   $ docker-compose run --rm app-build /bin/bash

   # `/dist` が存在するかどうかを確認する
   $ ls
   dist  node_modules  package-lock.json  package.json  src  tsconfig.json
   ```

2. **本番環境用イメージを生成とレジストリへのプッシュ**

   ```sh
   $ make prod
   $ docker tag app-prod <your-repository-url>/app-prod:latest
   $ docker push <your-repository-url>/app-prod:latest
   ```

3. **デプロイ先への展開**
   AWS ECS や他のクラウドサービスに展開する。
   具体的な手順はデプロイ先のドキュメントに従う。
