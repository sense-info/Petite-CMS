# Petite CMS 核心與站點分離重構 SOP（Core + Multi-Site Repo）

## 一、目標與原則

### 目標
1. 核心系統獨立到 `core/`
2. 站點統一放在 `www/`（沿用既有命名）
3. `www/demo` 作為範例站
4. 使用者可在 `www/` 下複製 demo 建自己的站，且各站可獨立 git repo
5. Nginx 改為：
   - 主檔只做 include
   - 站點 server 設定放 `www/infra/*.conf`

### 最終結構
```text
/
├─ core/
├─ www/
│  ├─ demo/
│  │  ├─ public/
│  │  ├─ config/
│  │  └─ modules/
│  ├─ infra/
│  │  └─ 10-demo.conf
│  └─ gitignore.sample
├─ conf/
├─ bin/
├─ database/
├─ document/
└─ log/
```

## 二、重構前準備

1. 從目前專案建立重構分支
2. 先打備份 tag（可回滾）
3. 確認現有關鍵路徑：
   - 核心：`www/f3cms/`
   - 站點：`www/loc.f3cms.com/`
   - 站點設定：`www/config/loc.f3cms.com/`
   - 共用主題：`www/theme/`
   - 共用模板：`www/tmpls/`

## 三、一次性搬遷映射（必做）

1. `www/f3cms/*` → `core/`
2. `www/theme/*` → `core/theme/`
3. `www/tmpls/*` → `core/tmpls/`
4. `www/loc.f3cms.com/*` → `www/demo/public/`
5. `www/config/loc.f3cms.com/*` → `www/demo/config/`
6. 站點覆寫模組（若有）→ `www/demo/modules/`

## 四、程式碼調整（最小必要）

### 1) 站點入口檔
調整：
- `www/demo/public/index.php`
- `www/demo/cli.php`

做法：
- 定義 `CORE_DIR`（指向 `/var/www/core` 對應容器路徑）
- 定義 `SITE_DIR`（指向 `/var/www/www/demo`）
- 載入 `CORE_DIR/bootstrap.php` 或 `CORE_DIR/cli_bootstrap.php`

備註：
- `cli.php` 為 CLI 專用，不提供 web 存取，因此固定放在 site root（`www/demo/cli.php`）。

### 2) core 啟動檔
調整：
- `core/bootstrap.php`
- `core/cli_bootstrap.php`

做法：
- 以 `CORE_DIR` / `SITE_DIR` 載入設定，不再依賴舊的 `../f3cms`、`../config/<site>`
- 站點設定路徑統一為：
  - `SITE_DIR/config/config.php`
  - `SITE_DIR/config/config.{APP_ENV}.php`
  - `SITE_DIR/config/routes.ini`

### 3) 站點模組 require
凡是 `../f3cms/...` 改為 `CORE_DIR . '/...'`（避免路徑重構後再壞）

## 五、Nginx 佈局

### 1) 主檔只 include
編輯 `conf/nginx/sites/default.conf`：

```nginx
upstream php {
  server php-fpm:9000;
}

# 共用設定保留在這裡（cache zone、limit_req_zone、共用 header 等）

include /var/www/www/infra/*.conf;
```

### 2) 站點檔放 `www/infra/`
新增：
- `www/infra/10-demo.conf`

並將 demo 站 `root` 設為：

```nginx
root /var/www/www/demo/public;
```

後續多站可新增 `20-client-a.conf`, `30-client-b.conf`。

## 六、Git ignore 策略

### 1) monorepo 根 `.gitignore`
保持可追蹤 demo，其他 client 站可不追蹤（視策略微調）：

```gitignore
www/*

!www/demo/
!www/demo/**
!www/infra/
!www/infra/**
!www/gitignore.sample
```

### 2) `www/gitignore.sample`
給使用者本機啟用（copy 成 `www/.gitignore`）：

```gitignore
demo/
```

使用 `cp`，不要 `mv`。

## 七、新站建立流程（標準）

1. 啟用本機忽略規則

```bash
cp www/gitignore.sample www/.gitignore
```

2. 以 demo 複製新站

```bash
cp -a www/demo www/client-a
```

3. 初始化 client-a 自有 repo

```bash
cd www/client-a
git init
git add .
git commit -m "init client-a from demo"
```

4. 新增 Nginx 站點檔
- `www/infra/20-client-a.conf`
- `root /var/www/www/client-a/public;`

## 八、Composer / vendor 放置策略

`www/client-a` 可放：
- `composer.json`
- `composer.lock`

`vendor/` 建議策略：
1. 推薦：不版控 `vendor/`，部署時 `composer install`
2. 特殊情境（離線環境）才版控 `vendor/`

## 九、驗證清單（上線前必跑）

1. PHP lint（入口與 core bootstrap）
2. `composer install`（core + demo/client-a）
3. Web：首頁、後台、路由、上傳
4. CLI：`/Hourly/1` 任務可跑
5. Nginx reload 後，`demo` 與 `client-a` 都可訪問

## 十、文件同步更新

至少更新：
- `README.md`
- `INFO.md`
- `conf/nginx/sites/default.conf`

內容需反映：
- 新目錄結構
- 新建站流程（`cp -a www/demo ...`）
- Nginx include 模式
- 新 CLI 路徑
