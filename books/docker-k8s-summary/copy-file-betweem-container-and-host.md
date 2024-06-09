---
title: "コンテナとホスト間でファイルをコピーする"
---

これをやりたい。

![](https://storage.googleapis.com/zenn-user-upload/d8456d8489c6-20240609.png)

`docker container cp` を使用して双方向のコピーが可能。

## 基本構文

`container` は省略可能。

```shell
docker cp コピー元 コピー先
```

## ホストにあるファイルをコンテナへコピーする

```shell
docker cp ホスト側パス コンテナ名:コンテナ側パス
```

![](https://storage.googleapis.com/zenn-user-upload/b418ff430c41-20240609.png)

## コンテナにあるファイルをホストへコピーする

```shell
docker cp コンテナ名:コンテナ側パス ホスト側パス
```

![](https://storage.googleapis.com/zenn-user-upload/1ac93b863114-20240609.png)

## Apache サーバーを立てて動作確認

ホストにある `index.html` をコンテナへコピーし、Apache サーバーの表示を変える。

1. **ホストに `index.html` を作成する**
   ```shell
   /hogehoge/index.html
   ```
   ```html: index.html
   <html>
      <meta charset="utf-8" />
      <body>
      <div>hello, world</div>
      </body>
   </html>
   ```
2. **Apache サーバーを起動する**
   ```shell
   docker run --name apa000ex19 -d -p 8089:80 httpd
   ```
3. **コピーする**
   Apache サーバーの `/usr/local/apache2/htdocs/` に `index.html` を配置することで初期表示が変わる。

   ```shell
   docker cp index.html apa000ex19:/usr/local/apache2/htdocs/
   ```

![](https://storage.googleapis.com/zenn-user-upload/1f6f430fbcf4-20240609.png)
