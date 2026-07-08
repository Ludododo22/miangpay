#!/usr/bin/env bash
set -e

git init
git add .
git commit -m "feat: initialize MiangPay monorepo"
git branch -M main
git remote add origin https://github.com/Ludododo22/miangpay.git
git push -u origin main
