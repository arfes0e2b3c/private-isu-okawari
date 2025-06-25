# 事前準備

```bash
# Makefileを開く
vi Makefile
```

このリポジトリにある Makefile をコピぺして:wq で保存

```bash
# これを叩いて何も表示されなければOK
make help
```

# 計測の準備

```bash
# ログを移動させるコマンド
make prepare
```

# ベンチマーカーを実行して CPU の使用量を見る

```bash
# ベンチマーカーの実行
make benchmark
# CPUの使用率をモニタリング
top
```

# アクセスログ解析 with alp

```bash
# どのエンドポイントにどれくらいアクセスがあるかを分析する
# 中身はalpのコマンド
make analyze-access-log
```

# スロークエリログ解析 with pt-query-digest

```bash
# どのクエリがどれくらい叩かれているかを分析する
# 中身はpt-query-digestのコマンド
make analyze-query
```
