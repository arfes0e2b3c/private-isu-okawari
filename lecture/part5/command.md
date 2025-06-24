## N+1 問題を解決しよう

```bash
# goのコードを開く
vim -n private_isu/webapp/golang/app.go
```

:%d で全消しして[part2 の app.go](/lecture/part5/app.go)を貼り付ける
:wq で保存&閉じる

```bash
# goのディレクトリに移動(pythonの人は書き換えてね)
cd private_isu/webapp/golang
# ビルド
go build -o app
# リスタート
sudo systemctl restart isu-go
```
