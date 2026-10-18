# Plan

## Current stage

`check` — 實作已完成，需保留 Lab 手動驗證與 relation 結果檢查。

## 已完成實作

1. Glossary CSV 匯出
   - `fDraft::glossaryTermCountRows()` 讀取實際 JSON schema 的 `glossaries[].text`。
   - `kExcel::dumpCsv()` 輸出 `/upload/doc/*.csv`。
   - Lab 入口：`?draftGlossaryTermCount=1`。

2. Dictionary CSV 匯入
   - `kExcel::loadCsv()` 讀取 CSV 與 UTF-8 BOM。
   - `fDictionary::importTranslations()` 驗證標題、略過既有中文詞彙、以英文 slug 建立四語系資料。
   - `fDictionary::add(..., $mh)`、`Feed::saveLang(..., $mh)`、`Feed::chkErr(..., $mh)` 可沿用 `mh()->action()` 的外部 handle。
   - Lab 入口：`?dictionaryImport=1&path=/upload/doc/example.csv`。

3. Press relation 自動綁定
   - `fDictionary::autoBindTerms('press')` 建立 `press_term`。
   - `fTag::autoBindTerms('press')` 建立 `press_tag`，並在新增 relation 時更新 Tag counter。
   - `Belong::addRelated()` 先查既有 relation，避免重複 insert。
   - Lab 入口：`?dictionaryPressBind=1`、`?tagPressBind=1`。

## 驗收步驟

1. 以管理員登入執行 glossary 匯出，確認 CSV 有 `term,count` 標題與資料列。
2. 對一份包含已存在與新中文詞彙的四語系 CSV 執行匯入，確認統計的 `inserted`、`skipped`、`invalid` 與資料庫一致。
3. 執行 Dictionary 綁定，確認僅 Published / Changed Press 產生新 `press_term`；重跑時不重複新增。
4. 執行 Tag 綁定，確認僅 Published / Changed Press 產生新 `press_tag`，且新增 relation 的 Tag counter 正確。
5. 檢查 Lab 結果的 `linked`、`existing`、`articles`、`terms` 統計。

## 風險與後續

- SQL `LIKE '%term%'` 不會有效使用一般 B-tree index；若資料量成長，另行評估 MySQL Fulltext / ngram。
- `lots()` 有預設回傳筆數限制；若 Dictionary 或命中的 Press 超過既有上限，需新增分頁式 batch 設計。
