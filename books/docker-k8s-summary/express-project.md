---
title: "Node.jsのバックエンドプロジェクトをコンテナ環境で作成する"
---

Express, TypeScript, PostgreSQL を使用したバックエンド開発をコンテナ環境で実現し、チーム開発を行う手順について、これまでの内容を細かくまとめます。以下の内容は、コンテナ環境の構築、依存関係の管理、コード変更の反映、パッケージの追加、テストの実行、およびデプロイ手順を含みます。

## プロジェクトのセットアップ

### 1. フォルダ構成

プロジェクトの基本的なフォルダ構成は以下の通りです。

```
my-backend-api/
├── src/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   └── index.ts
├── Dockerfile
├── docker-compose.yml
├── package.json
├── tsconfig.json
├── .env.example
└── README.md
```

### 2. 必要なファイルの作成

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
    "@types/jest": "^26.0.23",
    "jest": "^26.6.3",
    "nodemon": "^2.0.7",
    "ts-jest": "^26.5.5",
    "ts-node-dev": "^1.1.1",
    "typescript": "^4.2.4"
  }
}
```

**`tsconfig.json`**

```json
{
  "compilerOptions": {
    "target": "ES6",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true
  },
  "exclude": ["node_modules", "dist"]
}
```

**`Dockerfile`**

```Dockerfile
FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
```

:::details 「COPY . .」は必要なのか？

今回、コンテナ作成時にプロジェクトのファイルをバインドマウントしている。（`docker-compose.yml` を参照）
そのため、イメージの中にプロジェクトのファイル必要ないように思える。
何故必要なのか？

それは、**デプロイ用の Docker イメージを構築するために必要**だからである。

開発時には、バインドマウントを使用してホストマシンのファイル変更をリアルタイムで反映させる設定を行う。これにより、ホストマシンのエディタでコードを編集しながら、すぐにその変更をコンテナ内でテストできる。

デプロイ時には、`COPY . .` を使用してすべてのソースコードや設定ファイルを Docker イメージにコピーする。これにより、どの環境にデプロイしても同じファイル構成が維持され、動作が保証される。

:::

**`docker-compose.yml`**

```yaml
version: "3"

services:
  app:
    build: .
    volumes:
      - .:/usr/src/app
      - /usr/src/app/node_modules
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DB_HOST=db
      - DB_PORT=5432
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - DB_NAME=mydatabase
    depends_on:
      - db

  db:
    image: postgres:13
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=mydatabase

volumes:
  db-data:
```

**`.env.example`**

```env
NODE_ENV=development
DB_HOST=db
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=mydatabase
```

## 初期設定とリポジトリの共有

### 1. リポジトリの初期化とプッシュ

```sh
git init
git add .
git commit -m "Initial commit with Docker setup"
git remote add origin <your-repository-url>
git push -u origin master
```

### 2. リモートリポジトリからのクローンと環境設定

チームメンバーは以下の手順でリポジトリをクローンし、環境をセットアップします。

```sh
git clone <your-repository-url>
cd my-backend-api
cp .env.example .env
```

## Docker コンテナのビルドと起動

### 1. ビルドと起動

```sh
docker-compose up --build
```

:::details なぜビルドする必要があるのか？

初回は `--build` を指定しなくても、Dockerfile からイメージがビルドされ、コンテナの作成・起動が行われる。
しかし、次回以降はイメージの再ビルドがされない。

リモートリポジトリからソースコードの変更があった際にパッケージの依存関係が変更されている可能性を考慮すると、毎回 `--build` をつけて再ビルドするようにしておいた方が良い。

:::

### 2. 開発中のコード変更の反映

ホストマシンのエディタでコードを変更し、バインドマウントにより変更をリアルタイムでコンテナに反映させます。

## パッケージの追加とテストの実

### 1. コンテナにシェルを開く

コンテナのベースイメージに応じて適切なシェルを使用します。

- **Debian 系、Node.js 公式イメージ**:

  ```sh
  docker-compose exec app /bin/bash
  ```

- **Alpine Linux**:
  ```sh
  docker-compose exec app /bin/sh
  ```

### 2. 新しいパッケージのインストール

```sh
npm install <パッケージ名>
```

### 3. テストの実行

```sh
npm run test
```

### 4. 変更のコミットとプッシュ

```sh
git add package.json package-lock.json
git commit -m "Add new package"
git push origin master
```

## デプロイ

### 1. Docker イメージのビルドとプッシュ

```sh
docker build -t my-backend-api .
docker tag my-backend-api:latest <your-repository-url>:latest
docker push <your-repository-url>:latest
```

### 2. デプロイ先への展開

AWS ECS や他のクラウドサービスに展開します。具体的な手順はデプロイ先のドキュメントに従います。

## まとめ

このガイドに従うことで、Express、TypeScript、PostgreSQL を使用したバックエンド開発をコンテナ環境で効率的に行うことができます。開発環境のセットアップから、パッケージの管理、コードの変更の反映、テストの実行、デプロイまで、一貫してコンテナを活用することで、チーム全体での開発効率を向上させることができます。
