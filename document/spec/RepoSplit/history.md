# History

## 第 1 輪討論結果
1. 本輪依 `FDD Sprint` 的要求，先確認目前 spec 解析結果為 `document/spec/RepoSplit`，並判斷目前處於 `idea` stage。
2. 承接盤點結果顯示此 spec 尚未建立 `history.md`、`plan.md`、`check.md`，因此仍屬需求收斂與設計定義階段，而非實作階段。
3. 目前 repo 仍為既有單體架構，目標設計要求將核心程式移到 `core/`，站點資料放在 `www/`，範例站為 `www/demo`，Nginx 站點設定集中於 `www/infra/*.conf`。
4. 這代表在實際改碼前，需先處理「repo 結構與目標 layout 的 drift」確認，避免直接依賴舊路徑 `../f3cms` 與 `../config/<site>`。

## 第 2 輪討論結果
1. 本輪依 `FDD Sprint` 進行後續承接，補寫 `history.md`，確認本輪對 spec 的理解與後續最小下一步。
2. 因此前置假設需要明確記錄：`core/` 為核心系統，`www/demo` 為示範站，`www/infra` 為站點 Nginx 設定，並將 bootstrap 改為 `CORE_DIR` / `SITE_DIR` 的讀取方式。
3. 本輪沒有擴張到修改任何實作程式碼，仍維持在 spec / drift 紀錄與下一步規劃階段。
4. 後續最小下一步為建立 `plan.md`，將 repo split 工作拆成可執行的 migration stage 與 validation checkpoints，再開始實作。
5. 若後續進入驗證，將優先使用 Docker 環境，且資料庫驗證依 `.env` 提供之設定為準。

## 第 3 輪討論結果
1. 本輪依 `FDD Sprint` gate 規則，確認 `history.md`、`plan.md`、`check.md` 已存在，且 `check.md` 已判定可進入實作，因此開始執行 `plan.md` 的 Stage 1（盤點與對照）。
2. Stage 1 實際盤點結果：
   - `www/f3cms/` 存在，可對應到目標 `core/`。
   - `www/theme/`、`www/tmpls/` 存在，可對應到 `core/theme/`、`core/tmpls/`。
   - `www/loc.f3cms.com/` 存在，可對應到 `www/demo/public/`。
   - `www/config/loc.f3cms.com/` 存在，可對應到 `www/demo/config/`。
   - `www/loc.f3cms.com/modules/` 存在（`Post`、`Press`），可對應到 `www/demo/modules/`。
3. 舊路徑依賴盤點結果：
   - entrypoint 仍使用 `$rootDir .'f3cms/bootstrap.php'` 與 `$rootDir .'f3cms/cli_bootstrap.php'`。
   - `www/f3cms/bootstrap.php`、`www/f3cms/cli_bootstrap.php` 仍依賴 `$rootDir .'config/'` 舊結構。
   - site module 仍存在 `require_once '../f3cms/modules/...';`。
4. 本輪發現一項文件漂移：`document/spec/.current-spec.md` 的 stage 描述仍顯示 idea-only 狀態，與目前已存在 `history.md`、`plan.md`、`check.md` 的實際狀態不一致；此漂移不阻塞 Stage 2 實作，但需在後續文件流程中校正。
5. 下一步為進入 Stage 2：重構 `www/demo/public/index.php`、`www/demo/cli.php` 與 `core/bootstrap` 啟動路徑（先以最小可行切分完成 `CORE_DIR` / `SITE_DIR` 導入）。

## 第 4 輪討論結果
1. 本輪依 `plan.md` 進入 Stage 2，已建立新入口：
   - `www/demo/public/index.php`
   - `www/demo/cli.php`
   兩者都已導入 `SITE_DIR` 與 `CORE_DIR`，並先保留 legacy fallback（當 `core/` 尚未完整掛載時回退到既有 `www/f3cms`）。
2. 已新增：
   - `core/bootstrap.php`
   - `core/cli_bootstrap.php`
   兩者已改為以 `CORE_DIR` / `SITE_DIR` 作為主路徑，並提供舊路徑 fallback，避免在 split 過程中立即中斷現有 runtime。
3. Docker 驗證結果：
   - 以 `php-fpm` 容器完成新入口 lint（`/var/www/demo/public/index.php`, `/var/www/demo/cli.php`）皆通過。
   - `core/*.php` 因目前 compose mount 只掛載 `www/`，改以 stdin 方式在容器內做 lint，語法通過。
4. 本輪新增一項非阻塞 drift：既有 Docker volume 對映仍是 `WWW_PATH=./../../www`，尚未覆蓋 root-level `core/`，因此 `core/` 真正 runtime 路徑切換需配合後續容器掛載調整。
5. 下一步維持最小步驟：進入 Stage 3，修正 site modules 內 `../f3cms/modules/...` 依賴為 `CORE_DIR` 導向載入策略。

## 第 5 輪討論結果
1. 依使用者要求，已把 `www/f3cms` 剩餘內容實際搬移到 `core/`（`libs/`, `modules/`, `vendor/`, `composer.json`, `composer.lock`, `README.md`, `LICENSE`），並移除 `www/f3cms/` 目錄。
2. 已同步修正主要入口與模組依賴：
   - `www/loc.f3cms.com/index.php`、`www/loc.f3cms.com/cli.php` 改用 `CORE_DIR` 載入 `core/bootstrap.php` / `core/cli_bootstrap.php`。
   - `www/loc.f3cms.com/modules/Post/outfit.php`、`www/loc.f3cms.com/modules/Press/reaction.php` 改為從 `core/modules` 載入（保留 legacy fallback）。
   - `www/config/config.php` 的 `AUTOLOAD` 改成優先指向 `core/`（保留 `f3cms/` fallback）。
3. 因 root-level `core/` 不在原本 Docker volume 內，已在 `conf/docker/docker-compose.yml` 為 `web-server` 與 `php-fpm` 新增 `./../../core:/var/core` 掛載，讓容器可讀取核心程式。
4. 驗證結果：
   - Docker PHP lint：新入口、site modules、config、core bootstrap 皆通過。
   - Docker CLI smoke（`loc.f3cms.com/cli.php`）可執行，`/var/www/f3cms` 缺失錯誤已排除。
5. 目前仍有一項待續查項目：HTTP `/` 與 `/home` 回應 404（由 F3 route 層回傳），需在下一輪確認是既有行為、路由載入落差，或資料/環境前提未滿足。

## 第 6 輪討論結果
1. 本輪針對 web 404 驗收缺口做最小修復，先確認 route 已載入，再定位 runtime 問題來源。
2. 問題定位結果：
   - 404 並非 route 缺失，而是 bootstrap 以固定 `SITE_DIR/public/` 作為 web root，導致 legacy site（`www/loc.f3cms.com` 無 `public/`）路徑判斷錯位。
   - 修正後轉為 500，進一步定位為 theme 實體尚未搬移到 `core/theme`。
3. 已完成修正：
   - `core/bootstrap.php` 改為：若存在 `public/` 才使用，否則回退 `SITE_DIR/` 作為 web root。
   - 完成 `www/theme` → `core/theme` 與 `www/tmpls` → `core/tmpls` 實體搬移。
4. 驗證結果（Docker）：
   - `Host: loc.f3cms.com` 下 `/` 與 `/home` 皆恢復 200。
   - `loc.f3cms.com/cli.php` 與 `demo/cli.php` smoke 均可執行。
5. 本輪關閉了「HTTP `/`、`/home` 回應 404」驗收缺口；下一步可按 plan 進入 Stage 4（nginx include 佈局切換）。

## 第 7 輪討論結果
1. 本輪執行 Stage 4（nginx include 佈局切換）：
   - `conf/nginx/sites/default.conf` 已改為保留共用設定並 `include /var/www/infra/*.conf;`。
   - 新增站點檔 `www/infra/10-loc.conf`，先承接現行 `loc.f3cms.com` runtime。
2. 為避免 route fallback regressions，`10-loc.conf` 的 `location /` 已調整為 `try_files $uri $uri/ /index.php?$query_string;`，避免 `/` 請求被改寫成舊 `q` 參數風格造成 404。
3. 驗證結果（Docker）：
   - `nginx -t` 通過且 reload 成功。
   - `Host: loc.f3cms.com` 下 `/`、`/home` 皆為 200。
4. Stage 4 與 plan 的「`10-demo.conf`」存在一項可控 drift：
   - 目前先落地 `10-loc.conf` 是為了維持既有 runtime 可用。
   - 待 `www/demo` 的 config/modules 完整對齊後，再補 `10-demo.conf` 切換為正式 demo 站。

## 第 8 輪討論結果
1. 本輪執行 Stage 4.1：補齊 `www/demo` 的 site config/modules，讓 demo 站可在 `demo.f3cms.com` 獨立啟動。
2. 已補齊 `www/demo/config`：
   - `config.php`、`config.develop.php`
   - `site.config.php`
   - `routes.ini`、`routes.site.ini`
   - `themeSetting.json`
   - `api-project-653166915507-e307beb30f10.json`
3. 已補齊 `www/demo/modules`：
   - `Post/`
   - `Press/`
   並在 `www/demo/public/index.php` 額外載入 site module 入口，確保 `\PCMS\oPost` 路由可解析。
4. 已新增 `www/infra/10-demo.conf`（`server_name demo.f3cms.com`、`root /var/www/demo/public`），與既有 `10-loc.conf` 並行。
5. Docker 驗證結果：
   - `nginx -t`、reload 皆通過。
   - `Host: demo.f3cms.com` 下 `/`、`/home` 皆為 200。
   - `Host: loc.f3cms.com` 下 `/` 仍為 200（舊站未回歸）。
   - `demo/cli.php` 與 `loc.f3cms.com/cli.php` smoke 皆可執行。

## 第 9 輪討論結果
1. 本輪執行 Stage 5（ignore 策略與文件同步）：
   - `.gitignore` 已改為「預設忽略 `www/*`，僅保留 `www/demo/**`、`www/infra/**`、`www/gitignore.sample`」。
   - 新增 `www/gitignore.sample`（內容：`demo/`），供本機複製為 `www/.gitignore` 使用。
2. 文件同步：
   - `README.md` 新增 Repo Split 結構摘要（`core/`, `www/demo`, `www/infra`）。
   - `INFO.md` 已更新資料夾結構、`VND_PATH`（改為 `core/vendor`）與 Docker composer 指令路徑（改為 `/var/core`）。
3. 本輪主要為文件與版控策略更新，無變更 runtime 行為；Stage 4.1 的 Docker 驗證結果保持有效。

## 第 10 輪討論結果
1. 依使用者決策「不保留過渡站點」，已移除 `www/infra/10-loc.conf`，改為 demo-only 站點策略。
2. 目前 `www/infra` 僅保留 `10-demo.conf`，由 include 佈局接管。
3. Docker 驗證結果：
   - `nginx -t` 通過且 reload 成功。
   - `Host: demo.f3cms.com` 下 `/`、`/home` 皆為 200。
   - `demo/cli.php` smoke 可執行。
4. 補充觀察：
   - 在僅有 `10-demo.conf` 時，`Host: loc.f3cms.com` 仍回 200（落入 default server），但內容由 demo 站承接，符合「不保留 loc 過渡站點」決策。

## 第 11 輪討論結果
1. 本輪執行文件對齊收尾：校正 `document/spec/.current-spec.md` 的 stage 描述，移除「idea-only」舊狀態。
2. 校正後 `.current-spec.md` 與實際進度一致（目前為 check stage，且 `history.md` / `plan.md` / `check.md` 已完整存在）。

## 第 12 輪討論結果
1. 本輪進一步收斂 `check.md` 的驗收狀態，將「驗收項目（預計）」更新為「驗收項目（已完成）」。
2. 同步校正檢查結論與下一步：確認 Stage 1~5 主流程與 demo-only 切換已完成，下一步應轉入 retrospective / Optimization，而非擴張實作範圍。

## 第 13 輪討論結果
1. 本輪執行最終 Docker smoke 驗證時，先遇到短暫 blocking drift：`php-fpm` 服務未在 compose 網路中可解析，導致 nginx upstream `php-fpm:9000` 檢查失敗。
2. 已即時以既有 compose 流程啟動 `php-fpm`，服務恢復後重新驗證：
   - `nginx -t` 通過。
   - `Host: demo.f3cms.com` 下 `/`、`/home` 皆為 200。
   - `demo/cli.php` smoke 可執行。
3. 本輪確認此 blocking drift 為環境服務狀態問題，非 RepoSplit 程式或配置回歸；目前驗收狀態維持可進 retrospective / Optimization。

## 第 14 輪討論結果
1. 本輪執行 Optimization 收尾文件化：補齊 `check.md` 的「最終驗收摘要（封存前）」與「回滾策略（最小可行）」。
2. `.current-spec.md` 已由 check stage 推進為 Optimization stage，並註明 Stage 1~5 + final smoke 已完成，後續聚焦封存前整理。

## 第 15 輪討論結果
1. 使用者回報 `https://loc.f3cms.com:4433/` 無法連線；本輪判定為 nginx 站點在 `www/infra/10-demo.conf` 僅監聽 `80`，未提供 `443 ssl` listener。
2. 以最小改動補上 `loc.f3cms.com` 的 HTTPS server block（沿用 demo root，憑證使用 `conf/nginx/letsencrypt/loc.f3cms.com+1.pem`）。
3. Docker 驗證結果：
   - `nginx -t` 通過並 reload 成功。
   - `https://loc.f3cms.com:4433/` 與 `/home` 回應皆為 200。
4. 本輪屬 Optimization 階段的連線可用性修補，未回退 RepoSplit 結構決策（仍維持不恢復 `10-loc.conf` 獨立站檔）。

## 第 16 輪討論結果
1. 使用者回報 `https://loc.f3cms.com:4433/assets/` 指向未完成；本輪定位為 demo root (`www/demo/public`) 缺少 `assets/` 靜態資源。
2. 以最小實作補齊 `www/demo/public/assets/`（由既有 `www/loc.f3cms.com/assets/` 同步），避免 runtime 再依賴已退役站點路徑。
3. 驗證結果（Docker）：
   - `https://loc.f3cms.com:4433/assets/styles/app.css` 回應 200。
   - `https://demo.f3cms.com:4433/assets/styles/app.css` 回應 200。
   - `https://loc.f3cms.com:4433/assets/` 目前回應 403（目錄無 index，屬 nginx 預設行為）。
4. 本輪屬 Optimization 階段的站點資源完整性修補，未變更 core 與 include 架構決策。

## 第 17 輪討論結果
1. 依使用者要求清理 `www` 舊資料夾並收斂目錄責任：
   - 移除 `www/assets`、`www/config`、`www/loc.f3cms.com`。
   - 共用 config 改由 `core/config/config.php` 載入；站點保留 `www/demo/config` 的 site/環境覆寫。
2. upload 與 tmp 重新對齊：
   - `www/upload/loc` 更名為 `www/upload/demo`。
   - 新增 `www/demo/public/upload -> ../../upload/demo` 捷徑。
   - runtime tmp 改為每站點目錄（`www/demo/tmp`）。
3. `pma` 路由修復：
   - 在 `www/infra/10-demo.conf` 補上 `/pma/` alias 與 php fastcgi 轉發。
   - 同步整理 server block，保留 `loc.f3cms.com:443` 測試入口。
4. Docker 驗證結果：
   - `https://loc.f3cms.com:4433/pma/` 回應 200。
   - `https://loc.f3cms.com:4433/upload/img/2025/06/35d23df4b5034bf.jpg` 回應 200。
   - `https://loc.f3cms.com:4433/assets/styles/app.css` 回應 200。

## 第 18 輪討論結果
1. 依使用者要求，將 `www/infra/10-demo.conf` 中 `80/443` 重複的站點邏輯抽為共用 include：
   - 新增 `www/infra/_demo-site-common.inc`
   - `10-demo.conf` 僅保留 listener、server_name、SSL 與 include。
2. 本輪未改變路由與站點行為，只做配置去重與可維護性改善。
3. Docker 驗證結果：
   - `nginx -t` 通過並 reload 成功。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## 第 19 輪討論結果
1. 依使用者要求調整 tmp/cache 目錄責任：
   - `www/demo/tmp` 僅保留 `.gitkeep`，其餘檔案改由 `.gitignore` 忽略。
   - `www/cache` 功能搬移到 `www/demo/cache`，目錄僅保留 `.gitkeep`，其餘檔案忽略。
2. 實作調整：
   - `core/config/config.php` 新增 `cache_root` 指向 `www/demo/cache`。
   - `core/libs/FCHelper.php` 改為優先使用 `cache_root`（未設定時才 fallback 到舊 `abspath + cache`）。
   - `.gitignore` 新增 `www/demo/tmp/**`、`www/demo/cache/**` 忽略規則，並保留 `.gitkeep`。
3. 驗證結果：
   - bootstrap 讀值確認 `cache_root = /var/www/demo/cache`。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## 第 20 輪討論結果
1. 依使用者要求，將共用(預設)設定從站點層移到 core：
   - `routes.ini` 移至 `core/config/routes.ini`
   - `themeSetting.json` 移至 `core/config/themeSetting.json`
2. 載入順序調整：
   - `core/bootstrap.php` 改為優先載入 `core/config/routes.ini`，再載入站點 `routes.site.ini` 作覆寫。
   - `core/bootstrap.php` / `core/cli_bootstrap.php` 新增 `core_configpath`。
   - `core/libs/FSHelper.php` 的 `loadConfig()` 新增 `core_configpath` fallback，供共用 JSON 設定讀取。
3. demo 站點 config 收斂：
   - 移除 `www/demo/config/routes.ini` 與 `www/demo/config/themeSetting.json`，保留站點層 `routes.site.ini` 與 `site.config.php`。
4. 驗證結果（Docker）：
   - PHP lint（bootstrap/cli_bootstrap/FSHelper）通過。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## 第 21 輪討論結果
1. 依使用者回饋，將啟動流程中 `LEGACY` 命名收斂為 core/site 語意命名，避免與現行架構不符：
   - `LEGACY_SITE_CONFIG_DIR` 改為 `SITE_CONFIG_DIR`。
   - bootstrap/cli_bootstrap 內部 `legacy*` 變數改為 `projectRootDir`、`fallbackCoreDir`、`fallbackConfigRoot`、`siteConfigDir` 等名稱。
2. 本輪為命名與可讀性修正，不改變既有路徑 fallback 行為。
3. 驗證結果（Docker）：
   - PHP lint（`core/bootstrap.php`、`core/cli_bootstrap.php`、`www/demo/public/index.php`、`www/demo/cli.php`）通過。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## 第 22 輪討論結果
1. 針對使用者提出「`AUTOLOAD` 已設定，`index.php` 手動 require 是否必要」進行 root-cause 修正：
   - `core/libs/Autoload.php` 對 `PCMS` namespace 的模組路徑改為優先 `SITE_DIR/modules`（不再依賴 `webpath/modules`）。
   - `core/bootstrap.php` 的 `AUTOLOAD` 首段改為站點層 `SITE_DIR/modules`，並保留 `public/modules` 與 fallback 路徑作相容。
2. 在上述修正後，已移除 `www/demo/public/index.php` 的手動載入：
   - `modules/Post/outfit.php`
   - `modules/Press/reaction.php`
3. 驗證結果（Docker）：
   - `class_exists('PCMS\\oPost', true)` 回傳 `true`（無手動 require）。
   - `https://loc.f3cms.com:4433/`、`/home`、`/pma/` 皆為 200。

## 第 23 輪討論結果
1. 依使用者要求，將 core 共用目錄加上 `_` 前綴以區分站點內容：
   - `www/infra` → `www/_infra`
   - `www/pma` → `www/_pma`
   - `www/upload` → `www/_upload`
2. 路徑對齊調整：
   - `conf/nginx/sites/default.conf` include 改為 `/var/www/_infra/*.conf`
   - 站點檔 `10-demo.conf` 的 `/pma/` alias 改為 `/var/www/_pma/`
   - `www/demo/public/upload` 捷徑改為指向 `../../_upload/demo`
   - `core/config/config.php` 新增 `upload_root=_upload/`
   - `core/libs/Upload.php`、`core/libs/FSHelper.php` 改為使用 `upload_root` 建立檔案系統路徑
3. 相關文件/腳本同步：
   - `.gitignore` 保留規則改為 `www/_infra/**`
   - `README.md`、`INFO.md`、`document/README.md` 更新新目錄名稱
   - `bin/rsync-upload-sync.sh` 預設同步路徑改為 `/www/_upload/`
4. 驗證結果（Docker）：
   - `nginx -t` 通過並 reload 成功。
   - PHP lint（`core/config/config.php`、`core/libs/Upload.php`、`core/libs/FSHelper.php`）通過。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## 第 24 輪討論結果
1. 依使用者要求實作站點複製：
   - 已將 `www/demo` 複製為 `www/news`（本機目錄存在）。
2. ignore 規則驗證與修正：
   - `www/news/` 已被 root `.gitignore` 正確忽略（`git status --ignored` 顯示 `!! www/news/`）。
   - `www/gitignore.sample` 原先的 `_upload` 例外規則無法正確保留 `.gitkeep`，已修正為：
     - `_upload/*`
     - `!_upload/.gitkeep`
3. 驗證結果：
   - root `.gitignore`：`www/_upload/demo/...` 會被忽略、`www/_upload/.gitkeep` 不會被忽略。
   - `www/gitignore.sample`：在獨立測試 repo 中驗證 `_pma` 會忽略、`_upload/demo/*` 會忽略、`_upload/.gitkeep` 不會忽略。

## 第 25 輪討論結果
1. 依使用者澄清，「news」僅為測試名稱，不可寫死於 `www/gitignore.sample`，已改為通用規則：
   - `/_upload/**`
   - `!/_upload/**/`
   - `!/_upload/**/.gitkeep`
2. root `.gitignore` 也同步對齊 `_upload` 規則，補上 `!www/_upload/` 以解除父層忽略影響，並保留「僅 `.gitkeep` 可追蹤」。
3. 驗證結果：
   - `_upload/demo/b.jpg` ignored
   - `_upload/demo/.gitkeep` not-ignored
   - `_upload/news/b.jpg` ignored
   - `_upload/news/.gitkeep` not-ignored

## 第 26 輪討論結果
1. 依使用者要求，補齊「複製新站 SOP」中 upload 調整步驟，避免只複製目錄卻未切換站點上傳路徑。
2. 已更新 `plan.md` Stage 5 與 `INFO.md`：
   - 複製後需重建 `public/upload` 連結到 `../../_upload/<site>`
   - 建立 `www/_upload/<site>/.gitkeep`
   - `site.config.php` 的 `upload_dir` 改為 `<site>/`

## 第 27 輪討論結果
1. 依使用者要求更新 ignore 規則，將 demo 站點的敏感/站點化設定檔排除版控：
   - `www/demo/config/*.json`
   - `www/demo/config/config.*.php`
2. 驗證結果：
   - `www/demo/config/config.develop.php`、`www/demo/config/config.qa.php`、`www/demo/config/themeSetting.json` 皆命中 ignore。
   - `www/demo/config/site.config.php`、`www/demo/config/routes.site.ini` 不受影響。

## 第 28 輪討論結果
1. 依使用者要求，於 `www/demo/public` 建立 `tmpls` 捷徑，指向 `core/tmpls`：
   - `www/demo/public/tmpls -> ../../../core/tmpls`
2. 驗證結果（Docker/HTTPS）：
   - `https://loc.f3cms.com:4433/tmpls/app/default.html` 回應 200。

## 第 29 輪討論結果
1. 使用者回報 `https://loc.f3cms.com:4433/pma/` 會下載檔案而非開啟 phpMyAdmin。
2. 根因為 nginx `location ^~ /pma/` 使 regex PHP location 不再參與比對，導致 `index.php` 被當靜態檔回傳。
3. 已將 `www/_infra/10-demo.conf` 的 `/pma/` 區塊由 `^~` 改為一般 prefix `location /pma/`，恢復 PHP 轉發。
4. 驗證結果（Docker/HTTPS）：
   - `/pma/` 與 `/pma/index.php` 均為 `Content-Type: text/html; charset=utf-8`
   - 回應包含 `X-Powered-By: PHP/8.3.35`，確認已由 PHP-FPM 執行。

## 第 30 輪討論結果
1. 使用者回報 `https://loc.f3cms.com:4433/douc/index.html` 為 404。
2. 根因確認：`www/demo/public` 僅存在 `docu -> ../../docu`，不存在 `douc` 捷徑；`/douc/*` 會落到前端路由而回 404。
3. 已新增相容捷徑：
   - `www/demo/public/douc -> ../../docu`
4. 驗證結果（Docker/HTTPS）：
   - `https://loc.f3cms.com:4433/douc/index.html` 回應 200。
   - `https://loc.f3cms.com:4433/docu/index.html` 仍回應 200。

## 第 31 輪討論結果
1. 使用者確認正確拼寫為 `docu`，不需保留 `douc` 相容捷徑。
2. 已移除 `www/demo/public/douc`，恢復單一正確入口 `www/demo/public/docu`。
3. 驗證結果（Docker/HTTPS）：
   - `https://loc.f3cms.com:4433/docu/index.html` 回應 200。
   - `https://loc.f3cms.com:4433/douc/index.html` 回應 404。

## 第 32 輪討論結果
1. 依使用者要求將環境操作文件移入 `document/`：
   - `INFO.md` → `document/info.md`
2. 已更新文件導覽：
   - `document/_sidebar.md` 新增 `Environment Info`（`info.md`）。
   - 根目錄 `README.md` 連結改為 `document/info.md`。
3. 在 `document/info.md` 新增「新進工程師必讀」區塊，推薦 FDD 與架構核心文件。

## 第 33 輪討論結果
1. 使用者要求對 `document/guides/setup.md` 做「最小修正」並對齊現況。
2. 已修正文件格式錯誤：移除檔案前段殘留的舊片段與未閉合 code block，恢復正常 Markdown 結構。
3. 已將備份來源說明由舊路徑 `/www/site` 改為 RepoSplit 現況示例 `/www/Petite-CMS/www`，並同步更新：
   - 時程表描述
   - Step 1 標題
   - `backup_site.sh` 範例中的 `SOURCE_DIR`

## 第 34 輪討論結果
1. 使用者要求重寫 `document/README.md`，避免重複資訊。
2. 已整份改寫為單一結構版本，內容對齊目前 RepoSplit 現況：
   - 專案命名改為 `pcms`，容器名稱更新為 `nginx_pcms` / `php-fpm_pcms` / `mariadb_pcms`。
   - 目錄結構改為 `core/`、`www/demo`、`www/_infra`、`www/_pma`、`www/_upload`、`www/docu`。
   - `.env` 關鍵變數改為 `WWW_PATH` / `CORE_PATH` / `DOCU_PATH` / `HOST_*` / `MYSQL_*`。
3. 已移除過時與重複段落（舊 Apache 變數、舊 `f3cms`/`up.sh` 指令、重複版本資訊、手動 docu 軟連結流程）。

## 第 35 輪討論結果
1. 使用者要求將 `document/README.md` 中的路徑與網址改為可點擊連結。
2. 已完成調整：
   - 驗證路徑（首頁、`/pma/`、`/docu/index.html`）改為 Markdown 超連結。
   - 延伸文件（`guides/index.md`、`guides/new_engineer_30min.md`、`guides/setup.md`、`info.md`）改為相對路徑超連結。

## 第 36 輪討論結果
1. 使用者要求微調 `document/_sidebar.md` 導覽文案，讓其與新版 README 命名語意一致。
2. 已完成最小調整：
   - `Home` → `文件首頁`（對應 `document/README.md` 標題語意）
   - `Environment Info` → `開發環境與操作筆記`（對應 `document/info.md` 內容定位）

## 第 37 輪討論結果
1. 使用者要求子站可建立自定義 `theme` / `tmpls`，並補齊安裝文件說明。
2. 已完成目錄補齊：
   - 新增 `www/demo/theme/.gitkeep`
   - 新增 `www/demo/tmpls/.gitkeep`
3. 已補齊 runtime 行為（theme）：
   - `core/bootstrap.php` 與 `core/cli_bootstrap.php` 調整為：若存在 `www/<site>/theme/<theme名稱>/`，優先使用子站 theme；否則 fallback 至 `core/theme/<theme名稱>/`。
4. 文件更新：
   - `document/README.md` 新增「子站自定義 theme / tmpls」段落與 `public/tmpls` 連結切換說明。
   - `document/info.md` 新站複製 SOP 新增 theme/tmpls 建立步驟與 tmpls 連結改法。
5. 驗證：
   - Docker `php-fpm` 容器 lint：`/var/core/bootstrap.php`、`/var/core/cli_bootstrap.php` 皆通過。

## 第 38 輪討論結果
1. 使用者要求補上 `.gitignore` 規則，確保只有以下兩個檔案納入版控：
   - `www/demo/theme/.gitkeep`
   - `www/demo/tmpls/.gitkeep`
2. 已更新 `.gitignore`：
   - `www/demo/theme/**`
   - `!www/demo/theme/.gitkeep`
   - `www/demo/tmpls/**`
   - `!www/demo/tmpls/.gitkeep`
3. 驗證結果（`git check-ignore -v -n`）：
   - `www/demo/theme/.gitkeep`、`www/demo/tmpls/.gitkeep` 不被忽略。
   - `www/demo/theme/foo.txt`、`www/demo/tmpls/foo.html` 被忽略。

## 第 39 輪討論結果
1. 使用者要求支援多子站共用自定義 `modules` / `theme`，並補齊安裝文件。
2. 已新增共用目錄：
   - `www/modules/.gitkeep`
   - `www/theme/.gitkeep`
3. Runtime 調整：
   - `core/bootstrap.php`：AUTOLOAD 新增 `www/modules/`；theme 載入優先序調整為 `www/<site>/theme/<theme>` → `www/theme/<theme>` → `core/theme/<theme>`。
   - `core/cli_bootstrap.php`：同步新增 shared modules AUTOLOAD 與 shared theme fallback 規則。
4. `.gitignore` 已加入 `www/modules`、`www/theme` 的追蹤例外，允許共用程式碼與模板納入版控。
5. 文件更新：
   - `document/README.md`：新增共用 modules/theme 的目錄與使用規則。
   - `document/info.md`：新站 SOP 補充 shared theme fallback 與 shared modules/theme 說明。
6. 驗證：
   - Docker lint：`/var/core/bootstrap.php`、`/var/core/cli_bootstrap.php` 通過。
   - ignore 驗證：`www/modules/*`、`www/theme/*` 為可追蹤狀態。

## 第 40 輪討論結果
1. 使用者確認無舊站相容需求，要求移除 modules AUTOLOAD 的目錄存在判斷式。
2. 已調整 `core/bootstrap.php` 與 `core/cli_bootstrap.php`：
   - modules AUTOLOAD 改為固定路徑串接（不再使用 `is_dir` 條件）：
     - `www/<site>/modules`
     - `www/modules`
     - `core/modules`
     - `core/libs`
3. 驗證：
   - Docker lint：`/var/core/bootstrap.php`、`/var/core/cli_bootstrap.php` 皆通過。

## 第 41 輪討論結果
1. 使用者要求確認 autoload 載入順序：
   - `PCMS` namespace：子站 → 共用 → core
   - `F3CMS` namespace：直接 core
2. 已調整 `core/libs/Autoload.php` 的 module 偵測邏輯：
   - `PCMS` 候選路徑固定為：
     1) `www/<site>/modules`
     2) `www/modules`
     3) `core/modules`
   - `F3CMS` 候選路徑固定為：
     1) `core/modules`
3. 驗證：
   - Docker lint：`/var/core/libs/Autoload.php` 通過。

## 第 42 輪討論結果
1. 使用者要求將 namespace 與 autoload 順序補充至說明文件。
2. 已更新文件：
   - `document/README.md`：在「多子站共用自定義 modules / theme」段落補上 `PCMS`/`F3CMS` 載入規則。
   - `document/info.md`：在新站 SOP 補上 namespace 使用規則與 module 載入順序。

## 第 43 輪討論結果
1. 使用者新增臨時共用 module `www/modules/Inquiry`，要求檢查是否可運作，並要求該目錄不納入 core repo 版控。
2. 已修正 `Inquiry` namespace 繼承與依賴引用（避免 `PCMS\F3CMS\*` 錯誤）：
   - `www/modules/Inquiry/feed.php`
   - `www/modules/Inquiry/kit.php`
   - `www/modules/Inquiry/outfit.php`
   - `www/modules/Inquiry/reaction.php`
3. 已補 `demo` 測試路由：
   - `GET|HEAD /inquiry/xls=\PCMS\oInquiry->do_xls`
   - `POST /inquiry/add_new=\PCMS\rInquiry->do_add_new`
4. `.gitignore` 已加入 `www/modules/Inquiry/**`，避免臨時共用 module 被納入 repo。
5. 驗證：
   - Docker lint：`www/modules/Inquiry/*.php` 全數通過。
   - Autoload 測試：`\PCMS\fInquiry`、`\PCMS\kInquiry`、`\PCMS\oInquiry`、`\PCMS\rInquiry` 皆可 `class_exists(..., true)` 成功載入。
   - 路由檢查：`/inquiry/xls` 回應 302 導向 `/login`（符合該 action 的登入檢查邏輯，代表路由與 class 綁定成功）。

## 第 44 輪討論結果
1. 使用者明確要求 `www/modules` 子資料夾屬於 sites repo，不應納入 core repo。
2. 已調整 `.gitignore`：
   - 保留 `www/modules/` 根目錄
   - 忽略 `www/modules/**`
   - 僅保留 `www/modules/.gitkeep`
3. 已同步更新 `www/gitignore.sample`：
   - `/modules/**`
   - `!/modules/.gitkeep`
4. 驗證（`git check-ignore -v -n`）：
   - `www/modules/.gitkeep` 不被忽略。
   - `www/modules/Inquiry/reaction.php` 與其他子檔案會被忽略。

## 第 45 輪討論結果
1. 使用者要求「最小」改寫 `document/guides/create_new_module.md`，僅補可執行步驟並對齊最新規則。
2. 已以最小變更新增 `RepoSplit 可執行步驟（最小版）`，包含：
   - JSON → Entity 初始化
   - `PCMS` / `F3CMS` 模組落點
   - 四層檔案建立
   - route 接線與 Docker 驗證
   - autoload 固定順序
   - `www/modules/**` 版控政策
3. 已同步修正舊路徑描述：
   - `Step 3` 不再使用 `www/f3cms/modules`，改為 site/shared/core 三種現況路徑。

## 第 46 輪討論結果
1. 使用者回報 `MHelper::hasColumn()` 不存在。
2. 已在 `core/libs/MHelper.php` 補上 `hasColumn($table, $column)`：
   - 支援 `table(alias)` 輸入正規化
   - 驗證 table/column 名稱格式
   - 以 `INFORMATION_SCHEMA.COLUMNS` 查詢當前資料庫是否存在指定欄位
3. 既有 `Belong` trait 的 `mh()->hasColumn(...)` 呼叫可直接沿用，無需改動呼叫端。
4. 驗證：
   - Docker lint：`/var/core/libs/MHelper.php`、`/var/core/libs/Belong.php` 皆通過。

## 第 47 輪討論結果
1. 使用者要求 `hasColumn()` 不使用 `INFORMATION_SCHEMA.COLUMNS`，改為 `SHOW COLUMNS FROM <table> LIKE <column>`。
2. 已更新 `core/libs/MHelper.php` 的 `hasColumn()` 查詢方式為：
   - `SHOW COLUMNS FROM \`<table>\` LIKE :column`
3. 既有 table/column 名稱格式驗證保留，降低 SQL 注入風險。
4. 驗證：
   - Docker lint：`/var/core/libs/MHelper.php`、`/var/core/libs/Belong.php` 皆通過。
