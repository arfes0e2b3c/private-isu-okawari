# 画像を静的ファイルとしてキャッシュしよう

## 問題となるエンドポイントの特定

```bash
# 集計用のコマンド
sudo cat /var/log/nginx/access.log | alp ltsv -m '/image/[0-9]+,posts/[0-9]+,/@\w+' -o method,uri,avg,count,sum --sort sum
```

## 画像を静的ファイルから返す設定

```bash
# nginxの設定ファイルを開く
sudo vi /etc/nginx/sites-available/isucon.conf
```

:%d と入力して enter を押し、現在の内容を全部削除する

[isucon.conf](/lecture/part4/isucon.conf)の内容をコピーをコピペして貼り付ける

```bash
# nginxのreload
sudo systemctl reload nginx
```

## 結果の確認

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

画像がほぼ 0 秒で返るようになっていれば成功！
