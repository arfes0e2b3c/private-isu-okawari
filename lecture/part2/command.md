# データベースのパフォーマンスをチューニングしよう

## ベンチマーカー走らせながら top してみる

ターミナル 1 つ目でこれを叩く

```bash
# ベンチマーカーを走らせるための、スコア計測用コマンド
/home/isucon/private_isu/benchmarker/bin/benchmarker -u /home/isucon/private_isu/benchmarker/userdata -t http://localhost
```

↑ が走ってる間にこれを叩く

```bash
# CPUの使用量をリアルタイムで表示するコマンド
top
```

## 結果を確認

ここから何が分かる？

PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND  
 45978 mysql 20 0 1804188 547692 38144 S **179.1** 14.1 8:43.55 mysqld  
 44591 isucon 20 0 1967332 80204 10240 S 10.0 2.1 0:17.51 app  
 56412 isucon 20 0 1602884 13620 7168 S 7.0 0.4 0:00.50 benchmark+
45961 www-data 20 0 13224 5168 3584 S 1.7 0.1 0:00.69 nginx  
 45962 www-data 20 0 13208 5428 3712 S 0.3 0.1 0:00.53 nginx

## mysql が重い原因を探る

```bash
# 今回のベンチマーカーで叩かれたクエリだけみたいので古いものを別ファイルに移動
sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow-$(date +%Y%m%d%H%M).log
# 変更を反映するためにmysqlを再起動する
sudo systemctl restart mysql
```

ベンチマーカーを実行

```bash
# ベンチマーカーを走らせるための、スコア計測用コマンド
/home/isucon/private_isu/benchmarker/bin/benchmarker -u /home/isucon/private_isu/benchmarker/userdata -t http://localhost
```

ベンチマーカーが実行し終わったら

```bash
# 叩かれたクエリのうち、合計時間が長い順に５つを分析して出力するコマンド(ちょっと時間かかるかも)
sudo pt-query-digest --limit 5 --explain h=localhost,u=isuconp,p=isuconp,D=isuconp /var/log/mysql/mysql-slow.log
```

## comments テーブルにインデックスを貼ろう

```bash
# mysqlに入るためのコマンド(パスワードを求められるけど、それもisuconp)
mysql -u isuconp -p isuconp
```

```bash
# commentsテーブルにあるindexを出力する
show index from comments;
```

```bash
# post_idをキーとするインデックスをcommentsテーブルに追加するクエリ
alter table comments add index post_id_idx(post_id);
```

```bash
# commentsテーブルにあるindexを出力する
show index from comments;
```

```bash
# mysqlから出る
exit;
```

## 結果を確認する

このファイルでやったことをもう一度全部やって、CPU の使用率、ベンチマーカーのスコア、クエリの集計結果を見比べてみる

まずログファイル消す

```bash
# 今回のベンチマーカーで叩かれたクエリだけみたいので古いものを別ファイルに移動
sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow-$(date +%Y%m%d%H%M).log
# 変更を反映するためにmysqlを再起動する
sudo systemctl restart mysql
```

ベンチマーカーを走らせる

```bash
# ベンチマーカーを走らせるための、スコア計測用コマンド
/home/isucon/private_isu/benchmarker/bin/benchmarker -u /home/isucon/private_isu/benchmarker/userdata -t http://localhost
```

その間に top コマンドで CPU の使用率を確認

```bash
# CPUの使用量をリアルタイムで表示するコマンド
top
```

クエリの集計

```bash
# 叩かれたクエリのうち、合計時間が長い順に５つを分析して出力するコマンド(ちょっと時間かかるかも)
sudo pt-query-digest --limit 5 --explain h=localhost,u=isuconp,p=isuconp,D=isuconp /var/log/mysql/mysql-slow.log
```

## +α

多分 ↑ で集計した結果でまだインデックスを使って改善できる場所が１箇所あります。
クエリの集計結果を眺めてみて、どれが改善できそうか話し合って実践してみましょう

## コードベースを編集して遅いクエリをマシにしよう

```bash
# goのコードを開く
vim -n private_isu/webapp/golang/app.go
```

:%d で全消しして[part2 の app.go](/lecture/part2/app.go)を貼り付ける
:wq で保存&閉じる

```bash
# goのディレクトリに移動(pythonの人は書き換えてね)
cd private_isu/webapp/golang
# ビルド
go build -o app
# リスタート
sudo systemctl restart isu-go
```
