# ContentTermBinding

## 需求目的

建立內容詞彙治理流程，將 Draft 產生的 glossary 匯出為 CSV、將人工完成的四語系翻譯匯入 Dictionary，並由 Dictionary / Tag 自動與已公開 Press 建立關聯。

## 範圍

### Glossary CSV 匯出

- 來源為 `draft.method = seohelper` 的 `content` JSON。
- glossary item 的詞彙欄位為 `text`。
- 匯出僅包含 `term,count`，輸出至 `/upload/doc/`，檔名為亂數 `.csv`。
- 管理員透過 Lab 手動執行。

### Dictionary 四語系 CSV 匯入

- CSV 標題固定為：`中文,英文,日文,韓文`。
- 中文詞彙已存在於 Dictionary 時略過，不覆寫既有翻譯。
- 新詞彙建立一筆 `dictionary` 與 tw/en/ja/ko 四筆 `dictionary_lang`。
- slug 以英文譯名套用既有 `_slugify()`。
- 每一筆主資料與四筆語系資料必須在同一 `mh()->action()` transaction。
- CSV 僅接受 `/upload/doc/` 下的 `.csv`，並支援 UTF-8 BOM 標題。

### Dictionary / Tag 自動關聯 Press

- Dictionary / Tag 為各自詞彙規則 owner，分別提供 `autoBindTerms('press')`。
- 僅取啟用來源詞彙的中文 title。
- 僅比對 Press 狀態 `Published`、`Changed` 的中文 `content`。
- 比對由 Feed 的 `lots()` 產生 SQL `LIKE`，不得將所有內容拉回 PHP 後巢狀比對。
- 命中時分別建立 `press_term` 或 `press_tag` relation。
- 關聯已存在時略過，不重複 insert。
- 僅 Tag target 為 Press 且新增 relation 時更新 `setPressCnt()`。
- 管理員透過 Lab 手動執行。

## 架構約束

- `mh()`、transaction 與資料表讀寫只能在 Feed。
- Kit 僅處理 CSV 讀取／輸出等非資料庫工作。
- Reaction 僅負責參數、權限、流程編排與結果呈現。
- `Belong::addRelated()` 僅提供 relation primitive：不存在才 insert；不可承擔 Dictionary / Tag 的比對規則。
- 跨 module 僅呼叫 Feed / Kit 穩定介面。

## 非目標

- 不新增 route；維持既有 `/api/lab/info` 管理員手動入口。
- 不覆寫已存在 Dictionary 的任何語系資料。
- 不對 Draft、Scheduled、Offlined Press 建立正式關聯。
- 本輪不導入 Fulltext / ngram 索引；大量資料時需另立效能改善需求。

## 主要情境

1. 管理員匯出 glossary CSV，取得待翻譯的 `term,count`。
2. 管理員完成四語系 CSV 後，指定 `/upload/doc/*.csv` 匯入；新中文詞彙建立四語系 Dictionary，既有詞彙略過。
3. 管理員手動執行 Dictionary 或 Tag 綁定；系統僅將命中已公開 Press 中文內容且不存在的 relation 新增。
