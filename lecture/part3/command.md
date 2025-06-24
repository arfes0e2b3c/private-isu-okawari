# アプリケーションのパフォーマンスをチューニングしよう

## 準備

```bash
# 今までのアクセスログを移動
sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.old
# nginxのreload
sudo systemctl reload nginx
```

## アプリケーションのログを集計してみる

```bash
# ベンチマーカーを走らせるための、スコア計測用コマンド
/home/isucon/private_isu/benchmarker/bin/benchmarker -u /home/isucon/private_isu/benchmarker/userdata -t http://localhost
```

```bash
# 集計用のコマンド
sudo cat /var/log/nginx/access.log | alp ltsv -m '/image/[0-9]+,posts/[0-9]+,/@\w+' -o method,uri,avg,count,sum --sort sum
```

## 静的ファイルを nginx 経由で返却する

```bash
# nginxの設定ファイルを開く
sudo vi /etc/nginx/sites-available/isucon.conf
```

:%d と入力して enter を押し、現在の内容を全部削除する

[isucon.conf の設定ファイル](/lecture/part3/static_file.conf)をコピペして貼り付ける

```bash
# nginxのreload
sudo systemctl reload nginx
```

# 結果の確認

「準備、アプリケーションのログを集計してみる」でやったことをもう一度行って、スコアが上がっていること、css や js の返却時間が 0 になっていることを確認する

```bash
# 今までのアクセスログを移動
sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.old
# nginxのreload
sudo systemctl reload nginx
```

```bash
# ベンチマーカーを走らせるための、スコア計測用コマンド
/home/isucon/private_isu/benchmarker/bin/benchmarker -u /home/isucon/private_isu/benchmarker/userdata -t http://localhost
```

```bash
# 集計用のコマンド
sudo cat /var/log/nginx/access.log | alp ltsv -m '/image/[0-9]+,posts/[0-9]+,/@\w+' -o method,uri,avg,count,sum --sort sum
```
