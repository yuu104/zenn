---
"Fetch API"
---

https://developer.mozilla.org/ja/docs/Web/API/Fetch_API/Using_Fetch#%E3%83%95%E3%82%A7%E3%83%83%E3%83%81%E3%81%8C%E6%88%90%E5%8A%9F%E3%81%97%E3%81%9F%E3%81%8B%E3%81%AE%E7%A2%BA%E8%AA%8D

## エラーハンドリング

### `response.ok` でエラーの確認を行う必要がある

fetch API は、ステータスコードが `4XX` や `5XX` の場合、reject しない。

```ts
const fetchSample = async () => {
  try {
    // ステータスコード404を返すリクエスト
    const response = await fetch("https://httpbin.org/status/404");
  } catch (err) {
    // 404ではエラーはスローされない
    console.log(err, "error");
  }
};
```

**ネットワークエラーや CORS エラーの場合のみ `TypeError` でスローされる。**

よって、`response.ok` でステータスコードが `2XX` かどうかを確認する必要がある。
