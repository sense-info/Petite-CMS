# Check

## 目前狀態
- Current stage: `plan` → `check`
- 本輪目標：以 spec 角度檢查 RepoSplit 的交付準備度，確認是否已具備正式開始實作的條件。
- 目前已完成 Stage 1（盤點與對照）與 Stage 2（入口與 bootstrap 最小切分），尚未進入 Stage 3 module require 路徑改寫。

## 已確認事項
1. 指定 spec 已明確為 `document/spec/RepoSplit`。
2. `history.md` 已記錄目前狀態與 drift。
3. `plan.md` 已拆成明確的 migration stages 與驗收點。
4. 目標設計已收斂為：
   - `core/` 存放核心系統
   - `www/` 存放站點系統
   - `www/demo` 作為示範站
   - `www/infra/*.conf` 放 nginx 站點設定
   - `CORE_DIR` / `SITE_DIR` 取代舊相對路徑
5. 目前的 repo 狀態仍是 pre-split monolith，與目標設計存在可確認的結構 drift，且該 drift 已經在 `history.md` 中記錄。

## 需要確認的實作前提
1. 舊路徑 `../f3cms` / `../config/<site>` 是否已被全面清查。（已完成第一輪清查，結果見「Stage 1 執行結果」）
2. 是否存在尚未列出的僅在站點中使用的共用資源，需一併納入 `core/` 或 `www/demo/modules/`。
3. 是否需要在重構前建立備份 tag 或分支，以便出現問題時可回滾。
4. 是否有額外的 CLI / worker / cron 路徑依賴，需一併納入 entrypoint 轉移。
5. 是否有 nginx include 設定會影響其他站點，需確認主設定保留的共用設定不被覆蓋。

## Stage 1 執行結果（盤點與對照）
1. 目標映射所需來源目錄皆存在：
   - `www/f3cms/`
   - `www/theme/`
   - `www/tmpls/`
   - `www/loc.f3cms.com/`
   - `www/config/loc.f3cms.com/`
   - `www/loc.f3cms.com/modules/`（`Post`、`Press`）
2. 實際發現的舊依賴（需在 Stage 2/3 修正）：
   - `www/loc.f3cms.com/index.php`：載入 `$rootDir .'f3cms/bootstrap.php'`
   - `www/loc.f3cms.com/cli.php`：載入 `$rootDir .'f3cms/cli_bootstrap.php'`
   - `www/f3cms/bootstrap.php`：載入 `$rootDir .'config/routes.ini'` 與 site config 舊路徑
   - `www/f3cms/cli_bootstrap.php`：載入 `$rootDir .'config/config.php'` 與 UI 舊路徑
   - `www/loc.f3cms.com/modules/Post/outfit.php`：`require_once '../f3cms/modules/...';`
   - `www/loc.f3cms.com/modules/Press/reaction.php`：`require_once '../f3cms/modules/...';`
3. 發現一項文件漂移（non-blocking）：
   - `document/spec/.current-spec.md` 的 stage 描述仍為 idea-only，與目前 spec 實際進度不一致。

## Stage 2 執行結果（入口與啟動檔重構）
1. 已新增新入口：
   - `www/demo/public/index.php`
   - `www/demo/cli.php`
2. 已新增 core 啟動檔：
   - `core/bootstrap.php`
   - `core/cli_bootstrap.php`
3. 路徑策略：
   - 主路徑改為 `CORE_DIR` + `SITE_DIR`。
   - 在 split 過渡期間保留 legacy fallback（`www/f3cms` 與既有 `www/config/loc.f3cms.com`），降低一次性切換風險。
4. 驗證結果：
   - Docker `php-fpm` lint：`/var/www/demo/public/index.php`、`/var/www/demo/cli.php` 通過。
   - `core/*.php` 透過 stdin 在容器內 lint 通過（因目前 volume 尚未直接掛載 root-level `core/`）。
5. 新增 non-blocking drift：
   - 目前 `conf/docker/.env` 的 `WWW_PATH` 僅掛載 `www/`，未覆蓋 root-level `core/`，後續需在容器路徑策略中完成對齊。

## Stage 3 執行結果（核心搬移與 module 路徑修正）
1. `www/f3cms` 已整體搬移到 `core/`，`www/f3cms` 目錄已移除。
2. 入口改寫完成：
   - `www/loc.f3cms.com/index.php` / `cli.php` 改為 `CORE_DIR` 載入。
3. site module 依賴改寫完成（第一批）：
   - `modules/Post/outfit.php`
   - `modules/Press/reaction.php`
   已從 `core/modules` 載入（含 legacy fallback）。
4. `www/config/config.php` 的 `AUTOLOAD` 已改為優先 `core/`，fallback `f3cms/`。
5. Docker 路徑對齊已補上：
   - `conf/docker/docker-compose.yml` 為 `web-server` / `php-fpm` 新增 `./../../core:/var/core`。
6. 驗證結果：
   - Docker lint 全數通過（入口、module、config、core bootstrap）。
   - Docker CLI smoke 通過（`loc.f3cms.com/cli.php`）。
7. 待確認項目：
   - HTTP `/`、`/home` 目前回應 404（F3 route 層），需在下一輪釐清是否為既有行為或新 drift。

## Stage 3 補充驗證結果（404 缺口關閉）
1. 404 根因確認：
   - route 已載入，但 `core/bootstrap.php` 對 legacy site 固定使用 `SITE_DIR/public/`，造成 web root 與 module path 偏移。
   - 修正 web root 判斷後，暴露次一層問題：`core/theme` 尚未就位，導致 500。
2. 修正內容：
   - `core/bootstrap.php` 改為「有 `public/` 用 `public/`，無 `public/` 用 `SITE_DIR/`」。
   - 實體搬移 `www/theme` → `core/theme`、`www/tmpls` → `core/tmpls`。
3. 驗證結果：
   - Docker web smoke：`Host: loc.f3cms.com` 下 `/` 與 `/home` 皆為 200。
   - Docker CLI smoke：`loc.f3cms.com/cli.php`、`demo/cli.php` 皆可執行。
4. 結論：
   - Stage 3 的 runtime 驗收缺口已關閉，可進入 Stage 4（nginx include 佈局切換）。

## Stage 4 執行結果（nginx include 佈局切換）
1. `conf/nginx/sites/default.conf` 已改為共用設定 + `include /var/www/infra/*.conf;`。
2. 已新增 `www/infra/10-loc.conf`，先承接現行 `loc.f3cms.com` 站點路由與 SSL 設定。
3. 為避免 `/` regressions，站點檔 `location /` 已使用：
   - `try_files $uri $uri/ /index.php?$query_string;`
4. 驗證結果（Docker）：
   - `nginx -t` 通過。
   - `nginx -s reload` 成功。
   - `Host: loc.f3cms.com` 下 `/`、`/home` 皆為 200。
5. 與原 plan 的可控 drift：
   - 目前先使用 `10-loc.conf` 而非 `10-demo.conf`，以維持現行 runtime。
   - 待 `www/demo` 的 config/modules 對齊後，再補 `10-demo.conf` 與 demo root 切換驗證。

## Stage 4.1 執行結果（demo 站對齊）
1. 已新增並啟用 `www/infra/10-demo.conf`（`server_name demo.f3cms.com`、`root /var/www/demo/public`）。
2. `www/demo` 已補齊可執行所需資源：
   - config: `config.php`、`config.develop.php`、`site.config.php`、`routes.ini`、`routes.site.ini`、`themeSetting.json`
   - module: `modules/Post`、`modules/Press`
   - 支援檔：`api-project-653166915507-e307beb30f10.json`
3. 為確保 site route `\PCMS\oPost->do_home` 可解析，`www/demo/public/index.php` 已補 site module 載入。
4. 驗證結果（Docker）：
   - `nginx -t` / reload 通過。
   - `Host: demo.f3cms.com` 下 `/`、`/home` 皆為 200。
   - `Host: loc.f3cms.com` 下 `/` 仍為 200。
   - `demo/cli.php` 與 `loc.f3cms.com/cli.php` smoke 皆可執行。
5. 結論：
   - Stage 4 的 demo 切換驗證缺口已關閉，可進入 Stage 5（gitignore 與新站建立流程）。

## Stage 5 執行結果（ignore 與文件同步）
1. `.gitignore` 已切換為 RepoSplit 策略：
   - 預設忽略 `www/*`
   - 保留 `www/demo/**`
   - 保留 `www/infra/**`
   - 保留 `www/gitignore.sample`
2. 已新增 `www/gitignore.sample`，提供本機忽略範本（`demo/`）。
3. 文件同步完成：
   - `README.md` 補上 Repo Split 結構摘要。
   - `INFO.md` 更新為 `core/` + `www/demo` + `www/infra` 結構，並校正 vendor / composer 路徑。
4. 驗證判定：
   - 本輪為文檔與 ignore 規則變更，未觸及服務行為；沿用 Stage 4.1 的 Docker runtime 驗收結果。

## Stage 5.1 執行結果（移除過渡站點）
1. 已移除 `www/infra/10-loc.conf`，不再保留 loc 過渡站點設定。
2. 目前 nginx include 下僅保留 `www/infra/10-demo.conf`。
3. 驗證結果（Docker）：
   - `nginx -t` / reload 通過。
   - `Host: demo.f3cms.com` 下 `/`、`/home` 皆為 200。
   - `demo/cli.php` smoke 通過。
4. 行為說明：
   - `Host: loc.f3cms.com` 目前會命中 demo default server（HTTP 200），不再代表獨立 loc 站點。

## 驗收項目（已完成）
1. `core/` 已存在，並包含主程式與共享的 theme / tmpl。
2. `www/demo/public` 可作為站點根目錄。
3. `www/demo/config` 可承載 site config。
4. `www/demo/modules` 可承載站點覆寫模組。
5. `www/infra/10-demo.conf` 可被 nginx 主設定 include。
6. `core/bootstrap.php` / `core/cli_bootstrap.php` 可依 `CORE_DIR` / `SITE_DIR` 正常讀取設定。
7. `www/demo/public/index.php` / `www/demo/cli.php` 已改為新啟動方式。
8. PHP lint / bootstrap 載入檢查通過。
9. nginx reload 後 demo 站可訪問。
10. CLI 路徑可正常執行，且不直接暴露為 web entrypoint。

## 目前阻塞 / 未決事項
- Stage 1~5 主流程與 demo-only 切換已完成；目前無阻塞性實作缺口。
- 若以後實作過程中發現更大範圍的依賴殘留，需要回寫 `history.md` 並修正 `plan.md`。
- 目前未發現需立即回退的設計錯誤，但依然需要以最小 step 進行 migration，避免擴張 scope。
- 補充：最終 smoke 過程曾出現 `php-fpm` 服務暫時未就緒造成 nginx upstream 檢查失敗；已重啟服務並驗證通過，不構成持續阻塞。

## 檢查結論
- 目前 `plan.md` Stage 1~5 的主要實作與驗收已完成。
- 目前狀態適合轉入 retrospective / Optimization 收尾，而非再擴張實作範圍。
- 若實作結果與此檢查內容不一致，需回到 `history.md` / `plan.md` 修正，而不是直接擴大改動。
- 以目前 Docker 狀態看，驗收結論成立；僅需在收尾文件中註明服務啟動順序注意事項。

## 建議下一步
1. 進入 retrospective / Optimization：整理最終 SOP、遷移注意事項與回滾策略。
2. 補齊最終驗收摘要與完成標記（可作為封存前的最後檢查單）。
3. 若後續仍需保留遷移緩衝策略，需明確記錄在 `history.md`，避免口頭規則遺漏。

## 最終驗收摘要（封存前）
1. Repo 結構切分已完成：`www/f3cms` 已搬移至 `core/`，共享 `theme/tmpls` 已移至 `core/`。
2. 入口與 bootstrap 切分已完成：`CORE_DIR` / `SITE_DIR` 路徑已接管，舊相對路徑依賴已降到可控範圍。
3. Nginx include 佈局已完成：主檔以 `include /var/www/infra/*.conf;` 管理站點配置。
4. demo 站點已可獨立啟動：`www/demo` + `www/infra/10-demo.conf` 在 Docker 驗證通過。
5. 過渡站點策略已結束：`10-loc.conf` 已移除，採 demo-only 站點策略。
6. Docker 最終驗證通過：`nginx -t`、demo `/`、`/home`、`demo/cli.php` smoke 均正常。

## 回滾策略（最小可行）
1. 若站點層回歸，先恢復 `www/infra/10-loc.conf`（或等價 loc 站設定）並 reload nginx，先止血路由流量。
2. 若 core 路徑切換回歸，優先檢查 compose volume（`/var/core`）與 `CORE_DIR` 解析，再決定是否回退入口檔。
3. 若僅為環境啟動問題（如 `php-fpm` 未就緒），先用既有 compose 流程重啟服務，不直接判定為程式回歸。
4. 任一回滾動作都需回寫 `history.md`，標示觸發條件、回滾範圍與後續修復步驟。

## Optimization 補丁驗收（loc HTTPS 可用性）
1. 已在 `www/infra/10-demo.conf` 補上 `loc.f3cms.com` 的 `443 ssl` server block。
2. 憑證檔使用既有 `conf/nginx/letsencrypt/loc.f3cms.com+1.pem` 與 key，未新增新憑證依賴。
3. Docker 驗證通過：
   - `nginx -t` 成功。
   - `https://loc.f3cms.com:4433/`、`https://loc.f3cms.com:4433/home` 皆為 200。

## Optimization 補丁驗收（assets 靜態資源）
1. 已補齊 `www/demo/public/assets/`，使 demo root 可直接提供靜態資源。
2. Docker 驗證通過：
   - `https://loc.f3cms.com:4433/assets/styles/app.css` 為 200。
   - `https://demo.f3cms.com:4433/assets/styles/app.css` 為 200。
3. 補充說明：
   - `https://loc.f3cms.com:4433/assets/` 目前為 403（資料夾無 index），但不影響具體靜態檔案路徑提供。

## Optimization 補丁驗收（目錄清理與 pma/upload 對齊）
1. 已移除舊資料夾：
   - `www/assets`
   - `www/config`
   - `www/loc.f3cms.com`
2. 共用 config 已改由 `core/config/config.php` 載入，`www/demo/config` 僅保留站點層設定。
3. upload 與 tmp 已對齊：
   - `www/upload/loc` → `www/upload/demo`
   - `www/demo/public/upload` 已改為指向 `../../upload/demo`
   - 站點 tmp 使用 `www/demo/tmp`
4. Docker 驗證通過：
   - `https://loc.f3cms.com:4433/pma/` 為 200。
   - `https://loc.f3cms.com:4433/upload/img/2025/06/35d23df4b5034bf.jpg` 為 200。

## Optimization 補丁驗收（Nginx server block 去重）
1. 已將 `www/infra/10-demo.conf` 的共用站點規則抽到 `www/infra/_demo-site-common.inc`。
2. `10-demo.conf` 僅保留 `listen/server_name/ssl` 與共用 include，減少雙 server block 的維護風險。
3. Docker 驗證通過：
   - `nginx -t` 成功。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## Optimization 補丁驗收（tmp/cache 站點化與版控規則）
1. `www/demo/tmp` 與 `www/demo/cache` 已收斂為「只追蹤 `.gitkeep`」策略，其他內容由 `.gitignore` 忽略。
2. 舊 `www/cache` 已搬移為站點層 `www/demo/cache`。
3. `FCHelper` 已改為使用 `cache_root`，並由 `core/config/config.php` 設為 `www/demo/cache`。
4. 驗證通過：
   - bootstrap 讀值 `cache_root=/var/www/demo/cache`。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## Optimization 補丁驗收（共用預設設定 core 化）
1. 已將共用預設設定移至 `core/config/`：
   - `core/config/routes.ini`
   - `core/config/themeSetting.json`
2. bootstrap 與設定讀取已對齊：
   - 路由載入優先使用 `core/config/routes.ini`
   - `FSHelper::loadConfig()` 可 fallback 讀取 `core_configpath`
3. 站點層 `www/demo/config` 已僅保留 site-specific 設定（`site.config.php` / `routes.site.ini` / env config）。
4. 驗證通過：
   - PHP lint（`core/bootstrap.php`、`core/cli_bootstrap.php`、`core/libs/FSHelper.php`）成功。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## Optimization 補丁驗收（LEGACY 命名收斂）
1. 啟動流程的 `LEGACY` 命名已收斂為 core/site 語意：
   - `LEGACY_SITE_CONFIG_DIR` → `SITE_CONFIG_DIR`
   - bootstrap/cli_bootstrap 內部 `legacy*` 命名已移除。
2. 驗證通過：
   - PHP lint（`core/bootstrap.php`、`core/cli_bootstrap.php`、`www/demo/public/index.php`、`www/demo/cli.php`）成功。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## Optimization 補丁驗收（移除 index 手動 require）
1. `PCMS` namespace autoload 已對齊站點模組位置（`SITE_DIR/modules`）。
2. `www/demo/public/index.php` 已移除手動 `require_once` 站點 modules。
3. 驗證通過：
   - `class_exists('PCMS\\oPost', true)` 為 `true`（autoload 正常）。
   - `https://loc.f3cms.com:4433/`、`/home`、`/pma/` 皆為 200。

## Optimization 補丁驗收（core 共用目錄 `_` 前綴化）
1. 共用目錄已改名：
   - `www/_infra`
   - `www/_pma`
   - `www/_upload`
2. 路徑與程式已對齊：
   - nginx include 路徑改為 `/var/www/_infra/*.conf`
   - `/pma/` alias 改為 `/var/www/_pma/`
   - upload 檔案系統根改由 `upload_root=_upload/` 驅動
3. 驗證通過：
   - `nginx -t` + reload 成功。
   - `https://loc.f3cms.com:4433/`、`/pma/`、`/upload/img/2025/06/35d23df4b5034bf.jpg` 皆為 200。

## Optimization 補丁驗收（news 複製與 ignore 規則）
1. 已完成 `www/demo` → `www/news` 複製。
2. root `.gitignore` 驗證通過：
   - `www/news/**` 會被忽略（不進版控）。
   - `www/_upload/.gitkeep` 可保留追蹤，`www/_upload/demo/**` 仍會忽略。
3. `www/gitignore.sample` 已修正並驗證：
   - `_pma/` 會忽略。
   - `_upload/demo/**` 會忽略。
   - `_upload/.gitkeep` 不會忽略。

## Optimization 補丁驗收（_upload 通用 ignore 規則）
1. `www/gitignore.sample` 已改為通用 `_upload` 規則（不含站名硬編碼）。
2. root `.gitignore` 與 sample 規則一致滿足「僅保留每站 `.gitkeep`」。
3. 驗證通過：
   - `_upload/demo/b.jpg` ignored
   - `_upload/demo/.gitkeep` not-ignored
   - `_upload/news/b.jpg` ignored
   - `_upload/news/.gitkeep` not-ignored

## Optimization 補丁驗收（新站複製 SOP 補齊 upload）
1. 已在 SOP 補上新站 upload 調整步驟：
   - `public/upload` 需改連到 `../../_upload/<site>`
   - 建立 `www/_upload/<site>/.gitkeep`
   - `site.config.php` 設定 `upload_dir=<site>/`
2. 文件已同步：
   - `document/spec/RepoSplit/plan.md`
   - `INFO.md`

## Optimization 補丁驗收（demo config ignore 規則）
1. `.gitignore` 已加入：
   - `www/demo/config/*.json`
   - `www/demo/config/config.*.php`
2. 驗證通過：
   - `config.develop.php`、`config.qa.php`、`themeSetting.json` 會被忽略。
   - `site.config.php`、`routes.site.ini` 不會被忽略。

## Optimization 補丁驗收（tmpls 公開路徑捷徑）
1. 已新增 `www/demo/public/tmpls` 符號連結，指向 `../../../core/tmpls`。
2. 驗證通過：
   - `https://loc.f3cms.com:4433/tmpls/app/default.html` 為 200。

## Optimization 補丁驗收（pma PHP 轉發修復）
1. `www/_infra/10-demo.conf` 的 `/pma/` location 已由 `^~` 改為一般 prefix，以允許 `/pma/*.php` regex location 生效。
2. 驗證通過：
   - `https://loc.f3cms.com:4433/pma/` 與 `/pma/index.php` 回應 `Content-Type: text/html; charset=utf-8`
   - 響應頭包含 `X-Powered-By: PHP/8.3.35`（確認非靜態下載）。

## Optimization 補丁驗收（douc 文件路徑相容）
1. 已新增 `www/demo/public/douc` 符號連結至 `../../docu`，與既有 `docu` 並存。
2. 驗證通過：
   - `https://loc.f3cms.com:4433/douc/index.html` 為 200。
   - `https://loc.f3cms.com:4433/docu/index.html` 為 200。

## Optimization 補丁驗收（docu 正名）
1. 已移除 `www/demo/public/douc` 相容捷徑，保留正確拼寫 `docu`。
2. 驗證通過：
   - `https://loc.f3cms.com:4433/docu/index.html` 為 200。
   - `https://loc.f3cms.com:4433/douc/index.html` 為 404。

## Optimization 補丁驗收（文件導覽調整）
1. 已將環境說明文件移至 `document/info.md`（原 `INFO.md`）。
2. `document/_sidebar.md` 已新增 `Environment Info` 導覽項目。
3. `README.md` 已改為連到 `document/info.md`。
4. `document/info.md` 已新增「新進工程師必讀」推薦清單。
