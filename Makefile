.PHONY: init
init: webapp/sql/dump.sql.bz2 benchmarker/userdata/img

webapp/sql/dump.sql.bz2:
	cd webapp/sql && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/dump.sql.bz2

benchmarker/userdata/img.zip:
	cd benchmarker/userdata && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/img.zip

benchmarker/userdata/img: benchmarker/userdata/img.zip
	cd benchmarker/userdata && \
	unzip -qq -o img.zip

# Makefile for ISUCON lecture command shortcuts

# goからpythonに変更
change-to-python:
	sudo systemctl stop isu-go
	sudo systemctl disable isu-go
	sudo systemctl start isu-python
	sudo systemctl enable isu-python

# 基本ベンチマーク
benchmark:
	/home/isucon/private_isu/benchmarker/bin/benchmarker \
		-u /home/isucon/private_isu/benchmarker/userdata \
		-t http://localhost

# MySQL slow log のローテートと再起動
rotate-slowlog:
	sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow-$(shell date +%Y%m%d%H%M).log
	sudo systemctl restart mysql

# MySQL クエリ集計
analyze-slowquery-log:
	sudo pt-query-digest --limit 5 --explain \
		h=localhost,u=isuconp,p=isuconp,D=isuconp \
		/var/log/mysql/mysql-slow.log

# アプリビルド＋再起動
build-app:
	cd private_isu/webapp/golang && go build -o app
	sudo systemctl restart isu-go
	cd

# アクセスログローテートとリロード
rotate-access-log:
	sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.old
	sudo systemctl reload nginx

# alp でログ集計
analyze-access-log:
	sudo cat /var/log/nginx/access.log | alp ltsv \
		-m '/image/[0-9]+,posts/[0-9]+,/@\w+' \
		-o method,uri,avg,count,sum --sort sum

# 初期設定セット（MySQLログ、nginxログなど一括）
prepare:
	make rotate-slowlog
	make rotate-access-log

# ベンチ → クエリ集計 まで一括
bench-analyze:
	make benchmark
	make analyze-slowquery-log

# コード変更時のルーチン（app.go → build → 再起動）
deploy-app-go:
	make build-app

# Python アプリのデプロイルーチン
deploy-app-python:
	sudo systemctl restart isu-python

# 静的ファイル設定変更後のNginx再起動
reload-nginx:
	sudo systemctl reload nginx

# ベンチマーク + ALP ログ集計
bench-alp:
	make benchmark
	make analyze-access-log

# N+1 改善後の確認ルーチン
check-n1:
	make rotate-access-log
	make reload-nginx
	make benchmark
	make analyze-access-log
