---
title: "ループ処理"
---

## for 文

```go
sum := 0

for i := 0; i < 10; i++ {
  sum += 1
}
```

```go
sum := 1

for ; sum < 1000; {
  sum += sum
}
```

## while 文を表現する

- Go には `while` が存在しない
- `for` により表現する

```go
sum := 1

for sum < 1000 {
  sum += sum
}
```

## 無限ループ

- ループ条件を省略する

```go
for {
}
```
