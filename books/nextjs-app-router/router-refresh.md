---
title: "router.refresh() の仕組み"
---

## 公式によると...

https://arc.net/l/quote/jxtudbaj

> `router.refresh()`: 現在のルートを更新します。サーバーに新しいリクエストを行い、データリクエストを再取得し、Server Component を再レンダリングします。クライアントは、更新された React Server Component のペイロードを、影響を受けないクライアント側の React（useState など）やブラウザの状態（スクロール位置など）を保持したままマージします。
