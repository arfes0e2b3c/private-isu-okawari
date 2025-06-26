# データベースのパフォーマンスをチューニングしよう

## explain で実行計画を見る

```bash
EXPLAIN SELECT * FROM comments WHERE post_id = 12345;
```

## インデックスを追加しよう

```bash
mysql -u isuconp -p isuconp
# パスワードもisuconp
```

```bash
alter table comments add index post_id_idx(post_id);
```

## 結果の確認

```bash
# 今回のベンチマーカーで叩かれたクエリだけを見たいので古いものを別ファイルに移動
make rotate-slowlog
```

その後、ベンチマーカーを再実行：

```bash
make benchmark
```

ベンチマーカーが終わったらクエリ集計：

```bash
make analyze-query
```

## 結果を確認する

このファイルでやったことをもう一度全部やって、CPU の使用率、ベンチマーカーのスコア、クエリの集計結果を見比べてみる

まずログファイル消す

```bash
# 今回のベンチマーカーで叩かれたクエリだけを見たいので古いものを別ファイルに移動
make rotate-slowlog
# ベンチマーカーの実行
make benchmark
# CPU使用率のモニタリング
top
# 叩かれたクエリのうち、合計時間が長い順に５つを分析して出力するコマンド(ちょっと時間かかるかも)

make analyze-query
```

全削除 `:%d` → [part2 の app.go](/lecture/part2/app.go) を貼り付け
保存して閉じる `:wq`

その後、コードのビルドとアプリ再起動：

```bash
# Go
make deploy-app-go
# Python
make deploy-app-go
```
