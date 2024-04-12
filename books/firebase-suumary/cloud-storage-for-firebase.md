---
title: "Cloud Storage for Firebase"
---

## 全体像の理解

https://zenn.dev/maztak/articles/152c95647177b3

## Firebase Admin SDK からストレージにアクセスする

### セットアップ

https://firebase.google.com/docs/storage/admin/start?hl=ja

### API

https://firebase.google.com/docs/storage/admin/start

### 実装例

```ts
import admin from "firebase-admin";

import { getDownloadURL } from "firebase-admin/storage";

// Initialize Firebase Admin SDK
if (!admin.apps.length)
  admin.initializeApp({
    credential: admin.credential.cert({
      projectId: process.env.FIREBASE_PROJECT_ID,
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
      privateKey: process.env.FIREBASE_PRIVATE_KEY!.replace(/\\n/g, "\n"),
    }),
    databaseURL: process.env.FIREBASE_DATABASE_URL,
    storageBucket: process.env.CLOUD_STORAGE_BUCKET,
  });

export const bucket = admin.storage().bucket();

export const getAssetUrl = async (path: string): Promise<string> => {
  const regex = new RegExp("^" + `gs://${process.env.CLOUD_STORAGE_BUCKET}/`);
  const newPath = path.replace(regex, "");
  const imageFile = bucket.file(newPath);
  const downloadUrl = await getDownloadURL(imageFile);
  return downloadUrl;
};
```
