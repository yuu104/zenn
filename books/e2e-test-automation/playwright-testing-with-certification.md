---
title: "【Playwright】認証を伴うテスト"
---

Web アプリケーションのテストにおいて、認証が必要なページのテストは特別な配慮が必要です。
この種のテストには独特の課題があり、効率的に実施するためのいくつかの戦略があります。

## 認証テストの課題

1. **頻繁な認証の必要性**:
   正攻法では各テストケースで認証を行う必要がありますが、これにはいくつかの問題があります：

   - テストケースごとに Cookie などがリセットされる
   - 毎回ログイン処理を行うと、テストの実行時間が大幅に増加する

2. **セキュリティ上の配慮**:

   - 認証サービスは、ブルートフォース攻撃対策として、失敗時にウェイトを設けたり、一定時間内の認証回数を制限したりすることがあります。
   - これらの対策により、正当なテストでも認証に時間がかかる場合があります。

3. **実際のユーザー体験との乖離**:
   - 通常のユーザーは 1 日に一度程度しか認証を行わないのに対し、テストでは頻繁に認証を行うことになります。

## 効率的なテスト方法

これらの課題に対処するため、以下のようなアプローチが考えられます：

1. **テストケースの集約**:

   - 一度ログインしたら、複数のテストを連続して実行する
   - ただし、テストケースは可能な限り独立性を保つべきです

2. **フェイク認証の利用**:

   - 外部の認証機構の代替を作成し、テストのポータビリティを向上させる

3. **セッション情報の再利用**:

   - Cookie などのセッション情報を保存し、複数のテストで再利用する
   - これは正攻法のパターンとして認識されています

4. **認証回避モードの実装**:
   - 開発時によく使われる方法ですが、フレームワークによって実装方法が異なります

## セッション情報を再利用する

Playwright のセッション情報再利用の仕組みは以下の流れで動作します：

1. 初回のログイン処理を実行し、その結果（Cookie、ローカルストレージなど）を JSON ファイルに保存
2. 以降のテストでは、保存した JSON ファイルを読み込んでブラウザのセッション情報を復元
3. 認証済みの状態からテストを開始

この方法により、1 回のログインで複数のテストケースを実行できるようになります。

手順としては下記の通りです :

1. **セットアッププロジェクトの作成**

   まず、`playwright.config.ts`ファイルで認証用のセットアッププロジェクトを定義します：

   ```typescript
   import { defineConfig, devices } from "@playwright/test";

   export default defineConfig({
     projects: [
       { name: "setup", testMatch: /.*\.setup\.ts/ },
       {
         name: "chromium",
         use: {
           ...devices["Desktop Chrome"],
           storageState: "playwright/.auth/user.json",
         },
         dependencies: ["setup"],
       },
       // 他のブラウザ設定も同様に
     ],
   });
   ```

   この設定の重要なポイント：

   - `setup`プロジェクトは`.setup.ts`で終わるファイルをテストとして実行
   - `chromium`プロジェクトは`storageState`オプションで認証情報の JSON ファイルを指定
   - `dependencies: ['setup']`により、`setup`プロジェクト実行後に`chromium`プロジェクトが実行される

2. **認証処理の実装**

   次に、`auth.setup.ts`ファイルで実際の認証処理を実装します：

   ```typescript
   import { test as setup, expect } from "@playwright/test";

   const authFile = "playwright/.auth/user.json";

   setup("authenticate", async ({ page }) => {
     // 1. ログインページにアクセス
     await page.goto("http://localhost:8888");

     // 2. ログイン情報を入力
     await page
       .getByPlaceholder("Email Address / Username")
       .fill("admin@example.com");
     await page.getByPlaceholder("Password").fill("very-strong-password");

     // 3. ログインボタンをクリック
     await page.getByRole("button", { name: "Login" }).click();

     // 4. ログイン後のページ遷移を待機
     await page.waitForURL("http://localhost:8888/browser/");

     // 5. ログイン成功の確認
     await expect(page.getByText(/Object Explorer/)).toBeVisible();

     // 6. セッション情報をJSONファイルに保存
     await page.context().storageState({ path: authFile });
   });
   ```

   このスクリプトの動作：

   1. 指定された URL にアクセス
   2. ユーザー名とパスワードを入力
   3. ログインボタンをクリック
   4. ログイン後のページ遷移を待機
   5. ログイン成功を確認（この例では "Object Explorer" テキストの存在を確認）
   6. 現在のセッション情報（Cookie、ローカルストレージなど）を JSON ファイルに保存

3. **認証済み状態でのテスト実行**

   セッション情報が正しく設定されていれば、以降のテストではログイン処理を省略できます：

   ```typescript
   import { test, expect } from "@playwright/test";

   test("open About dialog", async ({ page }) => {
     // 1. 既にログイン済みの状態でページにアクセス
     await page.goto("http://localhost:8888/browser/");

     // 2. ヘルプボタンをクリック
     await page.getByRole("button", { name: /Help/ }).click();

     // 3. "About pgAdmin 4" をクリック
     await page.getByText(/About pgAdmin 4/).click();

     // 4. ダイアログが表示されたことを確認
     await expect(page.getByText(/Application Mode/)).toBeVisible();
   });
   ```

   このテストは、ログイン処理なしで直接目的のページにアクセスし、操作を行います。

4. **セッション情報の中身**
   `playwright/.auth/user.json`ファイルには以下のような情報が保存されます：

   ```json
   {
     "cookies": [
       {
         "name": "pga4_session",
         "value": "d759c0f9-7f4b-4bce-ba62-73c11428c947f6+JXaTEFUVhGc/yWmky2DB2nY0F0CRRN3v/dQqJRUe8=",
         "domain": "localhost",
         "path": "/",
         "expires": 1703889357.696225,
         "httpOnly": true,
         "secure": false,
         "sameSite": "Lax"
       }
     ],
     "origins": [
       {
         "origin": "http://localhost:8888",
         "localStorage": [
           {
             "name": "__test__",
             "value": "ud800"
           }
         ]
       }
     ]
   }
   ```

   この JSON ファイルには：

   - Cookie の情報（名前、値、ドメイン、パス、有効期限など）
   - ローカルストレージの情報
   - オリジン（接続先の URL）

   が含まれています。

:::message

**注意点とベストプラクティス**

1. **セキュリティ**
   `user.json`ファイルには機密情報が含まれる可能性があるため、`.gitignore`に追加してバージョン管理から除外することが重要です。

2. **有効期限**
   セッション情報は一定期間後に無効になる可能性があるため、テスト実行前に定期的に再生成する仕組みを検討してください。

3. **環境依存**
   テスト環境と本番環境で異なるセッション管理方式が使用されている場合、この方法が適用できない可能性があります。環境間の差異に注意してください。

4. **並列実行**
   Playwright はデフォルトでテストを並列実行します。
   セッション情報の共有方法によっては、テスト間で競合が発生する可能性があるため、適切な設計が必要です。

5. **メンテナンス**
   ログインプロセスが変更された場合、`auth.setup.ts`ファイルの更新が必要になります。
   定期的なメンテナンスを忘れずに行ってください。

:::
