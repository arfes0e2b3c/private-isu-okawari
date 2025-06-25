## N+1 問題を解決しよう

```bash
# goのコードを開く
vim -n private_isu/webapp/golang/app.go
```

- `:%d` で全て削除
- [part5 の app.go](/lecture/part5/app.go) を貼り付け
- `:wq` で保存して終了

その後、アプリケーションをビルドして再起動

```bash
make deploy-app
```

次に、スコアが変わっているか検証：

```bash
# 今までのアクセスログを移動
make rotate-nginx-log
# nginxのreload
make reload-nginx
# ベンチマーカーを走らせるための、スコア計測用コマンド
make benchmark
# 集計用のコマンド
make analyze-nginx
```
