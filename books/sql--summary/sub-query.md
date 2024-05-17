---
title: "サブクエリ"
---

- クエリの中に含まれるクエリ
- メインクエリの一部として動作し、その結果をメインクエリに渡す

## 基本構造

サブクエリは通常、括弧で囲まれ、SELECT 文の中に含まれる。

```sql
SELECT column1
FROM table1
WHERE column2 = (SELECT column3 FROM table2 WHERE condition);
```

## サブクエリの種類

### スカラサブクエリ

- 単一のスカラー値を返す
- 主に条件式の中で使用される

```sql
SELECT employee_name
FROM employees
WHERE employee_id = (SELECT manager_id FROM departments WHERE department_name = 'Sales');
```
