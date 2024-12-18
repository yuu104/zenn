---
title: "【アンチパターン】テーブルの分割"
---

- テーブル分割は一般的にパフォーマンス向上を目的として実施することが多い
- テーブル分割手法は何種類か存在する
- 分割手法の中にはバットノウハウも存在するため、注意が必要

## 水平分割

![](https://storage.googleapis.com/zenn-user-upload/18b65edd39d2-20231028.png)

以下のテーブルを例に考える。

**売り上げテーブル**
| 年度 | 会社コード | 売り上げ（億円） |
| ---- | ------ | ---- |
| 2001 | C0001 | 50 |
| 2001 | C0002 | 52 |
| 2001 | C0003 | 55 |
| 2001 | C0004 | 46 |
| .... | .... | .... |
| 2001 | C0004 | 50 |
| 2002 | C0001 | 52 |
| 2002 | C0002 | 55 |
| 2002 | C0004 | 60 |
| 2002 | C0001 | 47 |
| .... | .... | .... |
| 2002 | C0004 | 54 |
| 2003 | C0001 | 46 |
| 2003 | C0002 | 52 |
| 2003 | C0003 | 44 |
| 2003 | C0004 | 60 |
| .... | .... | .... |
| 2003 | C0004 | 59 |

- このテーブルには数百万〜数十億という数のレコードが含まれる
- そのため、SQL のパフォーマンス悪化が懸念される
- **SQL のパフォーマンス悪化が起きる最大の原因は、ストレージ（ディスク）に対する I/O コストの増大**
- アクセスするデータ量を減らすことが、パフォーマンス改善の手段
- 改善案の一つは、SQL がアクセスするテーブルのサイズを小さくする

例えば、SQL が常に 1 年ごとにしか `売り上げ` テーブルにアクセスしない場合、以下のように年度ごとにテーブルを分割することでパフォーマンスを改善できる。

**売り上げ（2001）テーブル**
| 年度 | 会社コード | 売り上げ（億円） |
| ---- | ------ | ---- |
| 2001 | C0001 | 50 |
| 2001 | C0002 | 52 |
| 2001 | C0003 | 55 |
| 2001 | C0004 | 46 |
| .... | .... | .... |
| 2001 | C0004 | 50 |

**売り上げ（2002）テーブル**
| 年度 | 会社コード | 売り上げ（億円） |
| ---- | ------ | ---- |
| 2002 | C0001 | 52 |
| 2002 | C0002 | 55 |
| 2002 | C0004 | 60 |
| 2002 | C0001 | 47 |
| .... | .... | .... |
| 2002 | C0004 | 54 |

**売り上げ（2003）テーブル**
| 年度 | 会社コード | 売り上げ（億円） |
| ---- | ------ | ---- |
| 2003 | C0001 | 46 |
| 2003 | C0002 | 52 |
| 2003 | C0003 | 44 |
| 2003 | C0004 | 60 |
| .... | .... | .... |
| 2003 | C0004 | 59 |

しかし、この分割は以下のような重大なデメリットがあるため、RDB では原則禁止。

### 分割する意味的な理由がない

- 水平分割する理由は、正規化の理論からは存在しない
- 純粋にパフォーマンスという物理レベルの要請によるもの
- よって、安易に実施すべきでない

### 拡張性に乏しい

- 上記の例では、水平分割によりパフォーマンス改善に効果を発揮するのは、「前年度のデータを総なめで検索することはない」という前提が成立する場合のみ
- その前提が常に成立するかどうかは保証の限りではない
- また、この分割を採用する場合、2004 年以降のデータもテーブルを新たに用意する必要があるため、テーブル数が増えていく

### 他の代替手段がある

- 多くの DBMS が「パーティション」という機能を持つ
- パーティションを用いることで、テーブルを分割することなく、パーティションキー（`売り上げ` テーブルの場合は `年度`）を軸として物理的に格納領域を分離することが可能
- これにより、SQL がアクセスするデータ量を 1/n に減らせる（n はパーティションの数）

:::details パーティション vs インデックス

- パーティションはインデックスよりもカーディナリティが小さく、かつ値の変更が少ない列をキーにして利用する
- 「年」や「都道府県」など、カーディナリティが十~数十であるキーが対象
- インデックスは、もう少しカーディナリティが高くないと効果が得られない

:::

## 垂直分割

![](https://storage.googleapis.com/zenn-user-upload/2882cb5a15c6-20231028.png)

以下のテーブルを例に考える。
**社員テーブル**
| 会社コード | 社員 ID | 社員名 | 年齢 | 部署コード |
| ---- | ------ | ---- | -- | -- |
| C0001 | 000A | 加藤 | 40 | D01 |
| C0001 | 000B | 藤本 | 32 | D02 |
| C0001 | 001F | 三島 | 50 | D03 |
| C0002 | 000A | 斉藤 | 47 | D03 |
| C0002 | 009F | 田島 | 25 | D01 |
| C0002 | 010A | 渋谷 | 33 | D04 |

- 現在、このテーブルに対する検索 SQL に遅延が発生しており、改善の必要がある
- 検索で利用する列は、常に `会社コード`、`社員ID`、`年齢`
- このとき、以下のようにテーブルを分割することで SQL 文がアクセスするデータ量を減らせる

**社員 1 テーブル**
| 会社コード | 社員 ID | 年齢 |
| ---- | ------ | ---- |
| C0001 | 000A | 40 |
| C0001 | 000B | 32 |
| C0001 | 001F | 50 |
| C0002 | 000A | 47 |
| C0002 | 009F | 25 |
| C0002 | 010A | 33 |

**社員 2 テーブル**
| 会社コード | 社員 ID | 社員名 | 部署コード |
| ---- | ------ | ---- | -- |
| C0001 | 000A | 加藤 | D01 |
| C0001 | 000B | 藤本 | D02 |
| C0001 | 001F | 三島 | D03 |
| C0002 | 000A | 斉藤 | D03 |
| C0002 | 009F | 田島 | D01 |
| C0002 | 010A | 渋谷 | D04 |

- 検索に必要な列だけに絞った `社員1` テーブルを検索対象とすることで、SQL のパフォーマンス改善が可能になる
  - （ボトルネックがストレージの I/O コストだった場合）
- この分割は正規化ではない
- 無損失分解ではあるので、結合によって元の `社員` テーブルを復元できる
- しかし、垂直分割にも「**分割することが論理的な意味を持たない**」というデメリットがあるため、**原則利用するべきでない**
- 垂直分割は「**集約**」で代替することが可能

## 分割しない代替案

テーブルの分割は基本的には NG。
しかし、パフォーマンス上の課題を解決しなければならない...

どうするか？

テーブル分割せずにパフォーマンスを向上させるための代替案として次の 2 つが存在する。

- 列を絞り込んだ新規テーブルを用意する
- サマリテーブルを作成する

### 列を絞り込んだ新規テーブルを用意する

- 保持する列を絞ったテーブルを作成する
- 垂直分割に対する代替案に相当する
- 検索時、頻繁に参照される列だけを持った新たなテーブルを作成する
- オリジナルのテーブルは残すため、分割ではない

![](https://storage.googleapis.com/zenn-user-upload/7173d099f0fd-20231028.png)

- このようにして作成される小規模なテーブルを、**データマート（マート）** と呼ぶ
- マートはオリジナルのデータを破壊せずにパフォーマンスを向上させることができる
- 実際の開発にもよく利用される
- しかし、マートばかり作成されてしまい、ストレージの容量を圧迫するケースもある
- また、**データ同期**の問題もある
- 更新タイミングが早いほど、データ整合性の精度が高く、好ましいが、更新処理の負荷が上がる
- 多くの場合、マートの更新は 1 日 1 回〜数回程度の頻度でバッチ更新される
- 結局は、要件に合わせて意思決定するのが大事

### サマリテーブルを作成する

- 集約関数によってレコードを集約した状態で保持すること

![](https://storage.googleapis.com/zenn-user-upload/e80bbe3b3511-20231028.png)

- `社員平均年齢` テーブルのサイズは、行列ともに元の `社員` テーブルより小さくなる
- アクセスするときの I/O コストを大きく削減できる
- オリジナルのテーブルを変更することもない
- しかし、データ同期の問題はある
