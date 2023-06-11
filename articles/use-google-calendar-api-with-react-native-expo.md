---
title: "React Native (Expo) でGoogle Calendar APIを使って予定を取得する"
emoji: "✨"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [reactnative, expo, googlecalendarapi]
published: false
---

## やること

1. Google OAth 認証によりアクセストークンを取得する
2. 取得したアクセストークンと共に Google Calendar API を叩く
3. 取得したイベント情報を表示する

## React Native (Expo)プロジェクトを作成する

Expo CLI をインストールしていない場合は以下のコマンドを実行する。

```shell
yarn global add expo-cli
```

`hello-react-native-expo`という名前でプロジェクトを作成する。

```shell
expo init hello-react-native-expo
```

## GCP プロジェクトの設定をする

Google OAuth 認証を行うには OAuth クライアント ID が必要になります。
そのため、GCP 上でプロジェクトを作成し、クライアント ID 取得のための設定を行います。

### Google Calendar API を有効にする

GCP プロジェクトを新規作成した後、「API ライブラリ」画面から Google Calendar API を検索し、有効にします。

### OAuth 同意画面の設定

メニューから「API とサービス」を選択し、「OAuth 同意画面」を開きます。
![](https://storage.googleapis.com/zenn-user-upload/cbe8253961ec-20230611.png =300x)

User Type は「外部」を選択し、作成します。
![](https://storage.googleapis.com/zenn-user-upload/1e5bd431125b-20230611.png =500x)

アプリ情報、デベロッパーの連絡先情報を入力し、次へ進みます。
![](https://storage.googleapis.com/zenn-user-upload/604194a9bde7-20230611.png =500x)

今回はカレンダー情報の取得のみを行うため、スコープに`https://www.googleapis.com/auth/calendar.events.readonly`を追加します。
![](https://storage.googleapis.com/zenn-user-upload/70d8b0449220-20230611.png =400x)

最後にテストユーザーを追加します。
![](https://storage.googleapis.com/zenn-user-upload/59d2575863f2-20230611.png =500x)

### 認証情報を作成

「認証情報の作成」から「OAuth クライアント ID」を選択します。
![](https://storage.googleapis.com/zenn-user-upload/d5f6a41f4a51-20230611.png =600x)

- 「アプリケーションの種類」は iOS を選択
- 「名前」は適当に入力
- 今回は Expo Go で実行するため、「バンドル ID」を`host.exp.exponent`に設定

![](https://storage.googleapis.com/zenn-user-upload/05ef30ccb413-20230611.png =400x)

入力を確定すると、クライアント ID が発行されます。

## Google OAuth 認証を実装する

[Expo 公式ドキュメント](https://docs.expo.dev/guides/google-authentication/#troubleshooting)を参考に実装します。

### ライブラリのインストール

```shell
npx expo install expo-auth-session expo-crypto expo-web-browser
```

### スキーマを追加する

OAuth 認証が完了し、ユーザを認証ページからアプリにリダイレクトするために`app.json`の`expo`に`scheme`を設定します。

```ts:app.json
{
  "expo": {
    "scheme": "ここにスキーマを設定"
  }
}
```

### import 文を追加する

`WebBrowser`API と`expo-auth-session`の`Google`プロバイダは、認証処理を行うために必須です。

```ts
import * as WebBrowser from "expo-web-browser";
import * as Google from "expo-auth-session/providers/google";
```

### Web ポップアップを解除するメソッドを追加する

> Expo の WebBrowser API では、認証セッションが正常に完了した場合にポップアップを解除する maybeCompleteAuthSession() メソッドを提供しています。このメソッドでは、プロバイダの許可リストに追加されたリダイレクト URL を使用します。
> このメソッドを、リダイレクトしたいアプリの画面に呼び出すには、以下のコードを追加してください。

と公式ドキュメントにありました。
何故必要か？追加しない場合はどうなるのか？がよく分かりませんでしたが、一応追加しておきます。

```ts:App.ts
WebBrowser.maybeCompleteAuthSession();
```

### クライアント ID をプロバイダに設定する

以下のコードをコンポーネント内で定義します。
先ほど GCP プロジェクトで発行したクライアント ID を`iosClientId`に指定します。

```ts:App.ts
const [request, response, promptAsync] = Google.useAuthRequest({
  iosClientId: 'ここにクライアントIDを指定する',
});
```

### 認証リクエストを送信する

`useAuthRequest()`フックには、Web ブラウザを開いてユーザに認証を促す`promptAsync()`関数が用意されています。

```ts:App.ts
<Button
  title="Sign in with Google"
  disabled={!request}
  onPress={() => {
    promptAsync();
  }}
/>
```

### 認証を行い、ユーザ情報を取得してみる

以下のコードは Google OAuth 認証を行い、アクセストークンを用いてしてユーザ情報を取得し、アプリ画面に表示しています。

```ts:App.ts
import { useEffect, useState } from "react";
import { StyleSheet, Text, View, Button } from "react-native";
import * as WebBrowser from "expo-web-browser";
import * as Google from "expo-auth-session/providers/google";

WebBrowser.maybeCompleteAuthSession();

export default function App() {
  const [token, setToken] = useState("");
  const [userInfo, setUserInfo] = useState<any>(null);

  const [request, response, promptAsync] = Google.useAuthRequest({
    iosClientId: "ここにiosClientIdを指定",
  });

  useEffect(() => {
    if (response?.type === "success" && response.authentication) {
      setToken(response.authentication.accessToken);
      getUserInfo();
    }
  }, [response, token]);

  const getUserInfo = async () => {
    try {
      const response = await fetch(
        "https://www.googleapis.com/userinfo/v2/me",
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );

      const user = await response.json();
      setUserInfo(user);
    } catch (error) {
      // Add your own error handler here
    }
  };

  return (
    <View style={styles.container}>
      {userInfo === null ? (
        <Button
          title="Sign in with Google"
          disabled={!request}
          onPress={() => {
            promptAsync();
          }}
        />
      ) : (
        <Text style={styles.text}>{userInfo.name}</Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
  text: {
    fontSize: 20,
    fontWeight: "bold",
  },
});
```

上記実装を Expo Go で動作確認してみます。
すると、以下のようにエラーが発生しました。
![](https://storage.googleapis.com/zenn-user-upload/256ca539f0b7-20230611.png =300x)
どうやら`useAuthRequest()`フックに`expoClientId`を指定しなければならないようです...
そのため、下記リンクを参考に`expoClientId`を発行します。
`expoClientId`の発行には Expo アカウント情報が必要なので、事前に用意してください。
https://stackoverflow.com/questions/75839524/what-is-expoclientid

1. GCP プロジェクトで新たに認証情報を作成し、「アプリケーションの種類」に「ウェブアプリケーション」を選択する
2. 「名前」は適当に入力
3. 「認証済みの JavaScript 生成元」に`https://auth.expo.io`を設定する
4. 「承認済みのリダイレクト URI」に`https://auth.expo.io/@{expoアカウントのユーザ名}/{expoのプロジェクト名}`を設定する

上記手順で認証情報を作成し、発行されたクライアント ID を`useAuthRequest()`の`expoClientId`に指定します。

```ts:App.ts
  const [request, response, promptAsync] = Google.useAuthRequest({
    iosClientId: "ここにクライアントIDを指定する",
    expoClientId:　"ここにクライアントIDを指定する",
  });
```

設定が完了したら、サーバーを立ち上げる前に Expo アカウントにログインする必要があるため、次のコマンドを実行してログインしてください。

```shell
expo login
```

ログイン済みの状態でサーバーを起動し、動作確認してみます。
![](https://storage.googleapis.com/zenn-user-upload/a20af93cb1ad-20230611.png =300x)
「Sign in with Google」を押すと OAuth 認証ページが開きます。
認証が完了し、Google アカウントのユーザ名が表示さたら成功です。

## Google Calendar API から指定月の予定を取得する

React Native (Expo)用の Google Calendar API のクライアントライブラリが見当たらなかったので、`Fetch API`を使用して直接 API を呼び出します。
API の詳細が下記リンクに記載されているので、こちらを参考に実装します。
https://developers.google.com/calendar/api/v3/reference/events/list?hl=ja&apix_params=%7B%22calendarId%22%3A%22primary%22%7D

以下が実装コードです。

```ts:App.ts
import { useState, useEffect } from "react";
import { Button, StyleSheet, Text, View } from "react-native";
import * as WebBrowser from "expo-web-browser";
import * as Google from "expo-auth-session/providers/google";

WebBrowser.maybeCompleteAuthSession();

export default function App() {
  const [request, response, promptAsync] = Google.useAuthRequest({
    expoClientId:
      "ここにクライアントIDを指定する",
    iosClientId:
      "ここにクライアントIDを指定する",
    scopes: ["https://www.googleapis.com/auth/calendar.events.readonly"],
  });

  const [token, setToken] = useState("");
  const [events, setEvents] = useState<any[]>([]);
  console.log(events);

  const getGoogleCalendarEvents = async () => {
    const month = 6;
    const timeMin = new Date(2023, month - 1, 1, 0, 0, 0).toISOString();
    const timeMax = new Date(2023, month, 0, 23, 59, 59).toISOString();

    try {
      const response = await fetch(
        `https://www.googleapis.com/calendar/v3/calendars/primary/events?timeMin=${timeMin}&timeMax=${timeMax}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
        }
      );
      const data = await response.json();
      setEvents(data.items);
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => {
    if (response?.type === "success" && response.authentication) {
      setToken(response.authentication.accessToken);
    }
  }, [response, token]);

  return (
    <View style={styles.container}>
      {!token ? (
        <Button
          title="Sign in with Google"
          disabled={!request}
          onPress={() => {
            promptAsync();
          }}
        />
      ) : (
        <View>
          <Button
            title="Googleカレンダーと連携する"
            onPress={getGoogleCalendarEvents}
          />
          {!!events.length &&
            events.map((item: any) => (
              <Text key={item.id} style={styles.text}>
                {item.summary}
              </Text>
            ))}
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
  text: {
    fontSize: 20,
    fontWeight: "bold",
  },
});
```

`useAuthRequest()`の第一引数に`scopes`を追加し、配列内には GCP プロジェクトで設定した Google Calendar API のスコープを指定します。
`getGoogleCalendarEvents()`関数では API を呼び出し、その結果を`events`ステートに格納しています。

```ts
const response = await fetch(
  `https://www.googleapis.com/calendar/v3/calendars/primary/events?timeMin=${timeMin}&timeMax=${timeMax}`,
  {
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
  }
);
```

- `https://www.googleapis.com/calendar/v3/calendars/primary/events`は Google Calendar API のエンドポイントであり、`primary`は認証ユーザのプライマリカレンダーを表しています
- `timeMin`と`timeMax`は取得したいイベントの期間を指定するクエリパラメータです。これらの値は、指定した月の最初の日時と最後の日時を表す ISO8601 形式の文字列です
- `Authorization` ヘッダーには、Google OAuth 認証で取得したアクセストークンを指定します

### 動作確認

画像にある 6 月の予定を取得します。
![](https://storage.googleapis.com/zenn-user-upload/97a9835cfd31-20230611.png =600x)
予定の詳細は以下の通りです。

- 6 月 6 日にある予定
- 6 月 7 日から毎週水曜日にある繰り返し予定（終了日なし）
- 6 月 8 日から 3 日ごとにある繰り返し予定（6 月 30 日まで）

サーバーを起動したら先ほどと同じように認証を行います。
認証が完了すると、「Google カレンダーと連携する」と表示されるので、そのボタンを押せば 6 月の予定が表示されます。
![](https://storage.googleapis.com/zenn-user-upload/454ab561a309-20230611.png =300x)
予定データは取得したデータの`items`プロパティにあります。
繰り返しイベントの場合、繰り返しの最初のイベントだけ取得し、`items[i].recurrence`に繰り返しの設定が定義されています。

## 参考リンク

https://docs.expo.dev/guides/google-authentication/#troubleshooting

https://stackoverflow.com/questions/75839524/what-is-expoclientid

https://stackoverflow.com/questions/61939083/issues-with-expo-auth-session-implementation

https://developers.google.com/calendar/api/v3/reference/events/list?hl=ja&apix_params=%7B%22calendarId%22%3A%22primary%22%7D

https://developers.google.com/calendar/api/v3/reference/events?hl=ja#resource
