# Plan

## 目前狀態
- Current stage: `idea` → `plan`
- 本輪目標：把 RepoSplit 的設計收斂成可執行 migration steps，並明確定義驗收條件。
- 本輪不進行大型重構實作，先完成 spec-level 的執行計畫與 drift 對齊。

## 計畫目標
1. 將核心系統與站點系統拆分為 `core/` 與 `www/`。
2. 以 `www/demo` 作為範例站，讓後續複製新站時不需要重做結構。
3. 將 nginx 設定改為主檔 `include`，站點設定集中到 `www/infra/*.conf`。
4. 更新 bootstrap / entrypoint，使其依賴 `CORE_DIR` 和 `SITE_DIR`，不再依賴舊 `../f3cms` / `../config/<site>` 路徑。
5. 明確驗證方式，確保重構後能正常啟動和訪問 demo 站。

## 執行階段

### Stage 1: 盤點與對照
- 確認目前 repo 內所有舊路徑與目標結構之對應關係。
- 明確列出需搬移的目錄：
  - `www/f3cms/*` → `core/`
  - `www/theme/*` → `core/theme/`
  - `www/tmpls/*` → `core/tmpls/`
  - `www/loc.f3cms.com/*` → `www/demo/public/`
  - `www/config/loc.f3cms.com/*` → `www/demo/config/`
  - 站點覆寫模組 → `www/demo/modules/`
- 驗證階段：比對各目錄是否都存在對應目標位置，且沒有舊路徑依賴漏網。

### Stage 2: 入口與啟動檔重構
- 更新 `www/demo/public/index.php` 與 `www/demo/cli.php`。
- 定義：
  - `CORE_DIR`：指向容器 / repo 中的 `core/`
  - `SITE_DIR`：指向 `www/demo`
- 讓入口檔統一載入 `CORE_DIR/bootstrap.php` 或 `CORE_DIR/cli_bootstrap.php`。
- 更新 `core/bootstrap.php` 與 `core/cli_bootstrap.php`，使設定讀取改為：
  - `SITE_DIR/config/config.php`
  - `SITE_DIR/config/config.{APP_ENV}.php`
  - `SITE_DIR/config/routes.ini`
- 驗證階段：PHP lint 檢查進入點與 core bootstrap 能正常解析。

### Stage 3: 站點內部 require 路徑修正
- 將所有 `../f3cms/...` 類型相對路徑改為 `CORE_DIR . '/...'`。
- 對所有內部 require / include 做一輪路徑檢查，避免重構後直接失效。
- 驗證階段：PHP lint + 啟動期間的 bootstrap/route 載入檢查。

### Stage 4: Nginx 配置切換
- 修改 `conf/nginx/sites/default.conf`，保留共用設定，並使用 `include /var/www/www/infra/*.conf;`。
- 新增 `www/infra/10-demo.conf`，將 demo 站 root 設為：
  - `root /var/www/www/demo/public;`
- 驗證階段：確認 nginx config 可載入且 demo 站可被請求。

### Stage 5: Git ignore 與多站建立流程
- 保留根目錄 `.gitignore` 可追蹤 `www/demo`，並允許 `www/_infra` 和 sample ignore 檔納入版控。
- 建立 `www/gitignore.sample`，提供：
  - `cp www/gitignore.sample www/.gitignore`
- 標明新站建立流程：
  - `cp -a www/demo www/client-a`
  - `www/client-a/public/upload` 連結改為 `../../_upload/client-a`
  - 建立 `www/_upload/client-a/.gitkeep`（僅保留 `.gitkeep`，其餘上傳檔依 ignore 規則不進版控）
  - `www/client-a/config/site.config.php` 的 `upload_dir` 改為 `client-a/`
  - 於 `www/_infra` 新增 `20-client-a.conf`
- 驗證階段：確認新站可從目錄複製並維持基本結構。

## 主要驗收點
1. `core/` 存在且包含核心程式與共享模板 / 主題。
2. `www/demo` 可作為範例站完整運作。
3. `www/_infra/*.conf` 可被 nginx 主設定 include。
4. bootstrap 與 entrypoint 不再依賴舊相對路徑設計。
5. demo站可以正常載入首頁與基本路由。
6. CLI 路徑 `www/demo/cli.php` 可被使用，且不暴露至 web access。

## 驗證策略
- 優先使用專案既有 Docker 環境。
- 以 `.env` 為資料庫驗證真實來源，不直接猜測帳密。
- 至少執行：
  - PHP lint / bootstrap parse check
  - Nginx reload / config validate
  - demo 站首頁訪問
  - CLI 基本可執行

## 風險與注意事項
- 若有舊路徑 `../f3cms` / `../config/<site>` 殘留，將導致重構後的啟動錯誤。
- 不應在此階段直接重構無關程式碼，避免擴張 scope。
- 若發現現有 repo 與 spec 不一致，先修正 spec drift，再改動實作。

## 本輪結論
- 本輪完成後，該 spec 即可進入 `done` 準備階段，並開始正式實作 migration。
- 若後續實作結果與計畫不一致，需回寫 `history.md` 或修正本 `plan.md`，再續行下一步。
