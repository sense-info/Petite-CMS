# History

## 第 1 輪：從 RepoSplit 分離

1. 已確認 RepoSplit 第 48–56 輪內容與 repo split 無直接關係，主題為內容詞彙匯出、翻譯匯入與 Press relation 自動綁定。
2. 建立 `ContentTermBinding` 作為獨立 spec，整理以下既有成果：
   - Draft SEO glossary 的 `term,count` CSV 匯出。
   - 四語系 Dictionary CSV 匯入。
   - Dictionary / Tag 對 Published / Changed Press 的自動關聯。
3. 已確認主要責任邊界：
   - Feed 擁有查詢、寫入、transaction 與 entity 規則。
   - Kit 僅處理 CSV 讀寫。
   - Lab Reaction 僅提供管理員手動執行與結果輸出。
   - Belong 僅處理 relation 存在檢查與新增。
4. 目前 stage 為 `check`：程式與 lint 已完成，待以管理員 Lab 入口驗證實際 CSV、Dictionary / Press relation 與 Tag counter。

## 已知修正歷程

1. glossary JSON 不可猜測欄位；實際 term 來源為 `glossaries[].text`。
2. Kit 不可直接使用 `mh()`；資料操作已回歸 Feed。
3. Medoo `action()` 回傳 `void`，不能以其回傳值判斷 transaction 成功；以 closure 參考變數保存結果。
4. `addRelated()` 已改為 relation 已存在時略過，避免重複 insert。
5. 自動綁定由 Dictionary / Tag 各自作為 source-term owner，不由 Press 承擔規則。
6. Tag counter 僅適用 Press target。

## 下一步

依 `check.md` 逐項以 Lab 管理員入口執行人工驗收；若資料量超過既有 `lots()` 限制或 SQL `LIKE` 成為瓶頸，再另立效能 spec。
