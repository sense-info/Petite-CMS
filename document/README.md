# Petite CMS 文件首頁

本頁是 `document/` 的入口，提供目前 RepoSplit 架構下的環境啟動、目錄對照與常用文件索引。

## 版本資訊
| 元件 | 版本/說明 |
| --- | --- |
| Nginx | Alpine（容器：`nginx_pcms`） |
| PHP | 8.3 FPM（容器：`php-fpm_pcms`） |
| MariaDB | 10.x（容器：`mariadb_pcms`） |

## 目前目錄結構（重點）
```text
core/        # 核心程式（config/libs/modules/vendor/theme/tmpls）
www/         # 站點層
  demo/      # 範例站（public/config/modules/tmp/cache）
  modules/   # 多子站共用自定義 modules
  theme/     # 多子站共用自定義 themes
  _infra/    # Nginx 站點設定（*.conf）
  _pma/      # phpMyAdmin 目錄
  _upload/   # 站點上傳共用根目錄
  docu/      # Docsify 內容入口
conf/        # Docker / Nginx / PHP / MySQL 設定
database/    # MariaDB data
log/         # 服務 log
document/    # 說明文件
```

## 啟動前準備
1. 設定 hosts（至少包含 `loc.f3cms.com`）：
   ```sh
   sudo sh -c 'echo "0.0.0.0 loc.f3cms.com" >> /etc/hosts'
   ```
2. 於 repo 根目錄建立/確認 `.env`（目前使用變數）：
   - `WWW_PATH`
   - `CORE_PATH`
   - `DOCU_PATH`
   - `HOST_HTTP_PORT`
   - `HOST_HTTPS_PORT`
   - `MYSQL_*`
3. 如需 SSL 本機測試，於 `conf/nginx/letsencrypt` 產生對應憑證。

## 容器操作（以專案腳本為主）
```sh
./bin/build   # build images
./bin/up      # 啟動服務
./bin/down    # 關閉服務
./bin/clear   # 清理 images/容器資源
```

必要時可直接查看容器：
```sh
docker exec -it nginx_pcms /bin/sh
docker exec -it php-fpm_pcms bash
docker logs nginx_pcms
docker exec nginx_pcms tail -f /var/log/nginx/error.log
```

## 驗證路徑
- 站台首頁：[https://loc.f3cms.com:4433/](https://loc.f3cms.com:4433/)
- phpMyAdmin：[https://loc.f3cms.com:4433/pma/](https://loc.f3cms.com:4433/pma/)
- 文件入口：[https://loc.f3cms.com:4433/docu/index.html](https://loc.f3cms.com:4433/docu/index.html)

## 初始化資料庫（選用）
```sh
mysql -uroot -p --port=3366 -h loc.f3cms.com target_db < ./conf/mysql/init.sql
```

## 子站自定義 theme / tmpls
- 每個子站可在 `www/<site>/theme` 與 `www/<site>/tmpls` 放置站點專屬檔案。
- Theme 載入規則：
  - 若存在 `www/<site>/theme/<theme名稱>/`，系統優先使用子站 theme。
  - 若不存在，且 `www/theme/<theme名稱>/` 存在，使用共用 theme。
  - 若不存在，則 fallback 到 `core/theme/<theme名稱>/`。
- `tmpls` 對外路徑（`/tmpls/...`）由 `www/<site>/public/tmpls` 決定：
  - 共用 core：`public/tmpls -> ../../../core/tmpls`
  - 子站專用：`public/tmpls -> ../../tmpls`

## 多子站共用自定義 modules / theme
- 共用 module 位置：`www/modules/`
  - 會加入 AUTOLOAD，所有子站可直接引用。
- 共用 theme 位置：`www/theme/<theme名稱>/`
  - 當子站沒有同名 `www/<site>/theme/<theme名稱>/` 時，會自動使用這層共用 theme。
- Namespace 與 module 載入順序：
  - `PCMS`：`www/<site>/modules` → `www/modules` → `core/modules`
  - `F3CMS`：`core/modules`（core 專用）

## 延伸文件
- [guides/index.md](./guides/index.md)：指南總覽與閱讀順序
- [guides/new_engineer_30min.md](./guides/new_engineer_30min.md)：新進工程師 30 分鐘上手
- [guides/setup.md](./guides/setup.md)：備份與排程腳本（43/11 主機）
- [info.md](./info.md)：本地開發與日常操作筆記
