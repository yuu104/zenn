---
title: "【Playwright】待機とリトライ"
---

## 待機

Playwright のマッチャーやアクションは、条件に合う要素が見つかるまで自動でリトライしてくれます。
デフォルトでは 5 秒間待機します。

Playwright ではリトライに関する様々な設定が可能です。

1. **個別設定**
   マッチャーやアクションはどれも `timeout` を付与することで待機時間を個別に設定できます。
   ```ts
   await page.goto("/start");
   await page.getByText("開始").click({ timeout: 10000 }); // 10秒待機
   ```
2. **テストケース単位で設定**

   ```ts
   import { test, expect } from "@playwright/test";

   test("遅いテスト", async ({ page }) => {
     test.slow(); // タイムアウト時間を3倍にする
   });

   test("3倍じゃ足りないテスト", async ({ page }) => {
     test.setTimeout(120000);
   });
   ```

3. **グローバル設定**
   ```ts
   export default defineConfig({
     expect: { timeout: 10 * 1000 }, // マッチャーのタイムアウト（10秒）
     timeout: 60 * 1000, // 個別テストのタイムアウト（1分）
     globalTimeout: 60 * 60 * 1000, // テスト全体のタイムアウト（1時間）
     use: {
       actionTimeout: 10 * 1000, // アクションのタイムアウト（10秒）
       navigationTimeout: 30 * 1000, // ナビゲーションのタイムアウト（30秒）
     },
   });
   ```

### 固定時間待機するコードは避ける

`page.waitForTimeout(ミリ秒)` のような固定時間を待つコードは、以下の理由から避けるべきです。

1. **フレーキーなテスト**
   環境やタイミングによってテストの成否が変わりやすくなります。
2. **実行時間の無駄**
   必要以上に長く待つ可能性があります。
3. **信頼性の低下**
   実際の状態変化を待つのではなく、単に時間経過を待つだけになります。

代わりに、特定のイベントが完了するまで効率よく待機するためのメソッドを利用します。
例えば、`waitForResponse()` や `waitForURL()` なんかがあります。

```ts
// 特定の API が呼ばれて帰ってくるまで待つ
const responsePromise = page.waitForResponse("https://example.com/resource");
await page.getByText("trigger response").click();
const response = await responsePromise;

// URL が特定のページになるまで待つ
await page.waitForURL("**/login");
```

他にも、以下のメソッドが存在します。

- `waitForLoadState()` : DOM ページのロードイベントを待つ
- `waitForRequest()` : リクエストの開始を待つ
- `waitForFunction()` : 渡された関数が `true` を返すのを待つ

## リトライ

E2E テストは、多層のシステムコンポーネントと外部要因が複雑に相互作用する状況でテストを行なっています。
それ故に、ネットワークの遅延、非同期処理、UI の描画遅延など、様々な要因でどうしても実行結果がランダムに失敗することもあります。
そのため、1 回の失敗で「信頼性のないテスト」とみなすのは現実的ではないテストも存在するでしょう。

そのような場合に、テストのリトライを行うことは有効な手段です。
「3 回の施行で 1 回でも正解すればテスト成功とみなす」といったルールを設定しておけば、不安定な E2E テストを削減できるでしょう。

[Playwright](https://playwright.dev/docs/test-retries#retries) では、以下のように様々な形式でリトライを設定することが可能です。

:::details テスト実行時にリトライ回数を設定する

```shell
# Give failing tests 3 retry attempts
npx playwright test --retries=3
```

:::

:::details Playwright の config ファイルでリトライ回数を設定する

```ts: playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  // Give failing tests 3 retry attempts
  retries: 3,
});
```

:::

:::details テストグループ単位でリトライを設定する

```ts
import { test, expect } from "@playwright/test";

test.describe(() => {
  // All tests in this describe group will get 2 retry attempts.
  test.describe.configure({ retries: 2 });

  test("test 1", async ({ page }) => {
    // ...
  });

  test("test 2", async ({ page }) => {
    // ...
  });
});
```

:::

:::message

Playwright では、テスト結果をカテゴライズしてくれます。（便利！！）

- `passed` : 1 回目のテストで成功したことを示す
- `flaky` : リトライにより成功したことを示す
- `failed` : リトライしても失敗したことを示す

```shell
Running 3 tests using 1 worker

  ✓ example.spec.ts:4:2 › first passes (438ms)
  x example.spec.ts:5:2 › second flaky (691ms)
  ✓ example.spec.ts:5:2 › second flaky (522ms)
  ✓ example.spec.ts:6:2 › third passes (932ms)

  1 flaky
    example.spec.ts:5:2 › second flaky
  2 passed (4s)
```

:::
