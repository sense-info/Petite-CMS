# Check

## 實作驗收

- [x] Draft glossary 匯出只使用實際 JSON schema `glossaries[].text`。
- [x] CSV 只輸出 `term,count` 至 `/upload/doc/`，採亂數檔名。
- [x] Kit 不直接呼叫 `mh()`；Feed 負責查詢、彙整與寫入。
- [x] Dictionary CSV 匯入驗證固定四欄標題，支援 UTF-8 BOM。
- [x] 已存在中文 Dictionary 詞彙略過。
- [x] 新 Dictionary 詞彙以英文譯名 slug 建立 tw/en/ja/ko。
- [x] Dictionary 寫入使用 `mh()->action()`，並以外部 `$mh` 傳入 `add()` / `saveLang()` / `chkErr()`。
- [x] `Belong::addRelated()` 已先查 relation，避免重複 insert。
- [x] Dictionary / Tag 綁定採 Feed `lots()` 的 SQL `LIKE`，非 PHP 全量巢狀比對。
- [x] Dictionary / Tag 綁定僅處理 Published / Changed Press 的 tw content。
- [x] Tag 僅在 target 為 Press 且新增 relation 時更新 counter。
- [x] Lab 提供四個手動入口。

## 已完成技術驗證

- [x] Docker PHP lint：`Draft/feed.php`、`Excel/kit.php`、`Dictionary/feed.php`、`Tag/feed.php`、`Press/feed.php`、`Lab/reaction.php`、`Belong.php`、`Feed.php`。
- [x] Dictionary CSV 匯入已由管理員實測成功寫入；Medoo `action()` 的 `void` 回傳誤判已修正。

## 待人工驗收

- [ ] glossary CSV 實際檔案包含預期 term 資料列。
- [ ] Dictionary 匯入的 inserted / skipped / invalid 統計與資料庫一致。
- [ ] Dictionary 綁定建立預期 `press_term`，重跑後不重複新增。
- [ ] Tag 綁定建立預期 `press_tag`，並驗證 counter。

## Convention review

- [x] 第一級：所有 `mh()` 與 transaction 只出現在 Feed。
- [x] Reaction 僅作 Lab 流程編排。
- [x] Kit 僅處理 CSV 讀寫。
- [x] Dictionary / Tag 保持各自 source-term owner，不將 entity 規則抽入 `Belong`。
