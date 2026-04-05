# 10-Minute Voice-over Screencast Plan (MongoDB)

## Scenario Context (from Assignment 1)
**Scenario:** Tony's Toy Emporium (TTE) Ltd.  
Core areas in relational model: bank, customer, product, store, warehouse, stock, purchase, purchase_item, stock_transfer, transfer_item.

---

## A. 10-Minute Timeline (what to show + what to say)

### 0:00 – 1:30 | ER Diagram + Assignment 1 Feedback Changes
Show:
- Final ER diagram (same scenario from Assignment 1)
- Slide with 2–5 teacher feedback points
- Slide with Before → After mapping

Say:
- “Yo same scenario ho from Assignment 1: Tony’s Toy Emporium.”
- “Assignment 1 feedback anusar maile key changes gare: relationship clarity, cardinality correction, and redundancy reduction.”
- “These improvements ensured stronger consistency before moving to MongoDB.”

---

### 1:30 – 3:30 | Rationale for MongoDB Conversion
Show:
- Slide: relational entities to MongoDB collections mapping
- Brief schema diagram of collections/documents

Say:
- “MongoDB choose gare because scenario ma transactional + catalog + inventory data cha with mixed read/write patterns.”
- “Collections selected to match business boundaries and query needs.”
- “Embedding vs referencing decision performance, duplication risk, and update frequency ko आधारमा gareko ho.”

Suggested mapping to explain:
- `products`
- `stores`
- `warehouses`
- `customers`
- `inventory` (store/warehouse wise stock)
- `purchases` (with embedded line items array)
- `stockTransfers` (with embedded transfer items array)

Document features to justify:
- **Referenced collections**: keep master data (`customers`, `products`, `stores`, `warehouses`) separate to avoid heavy duplication
- **Arrays for line items**: represent multi-item transactions in purchase/transfer records
- **Aggregation pipelines**: generate reporting outputs (top-selling products, revenue by store, transfer summaries)
- **Date-based filtering**: query purchases/transfers by date ranges for period-wise reporting

Suggested slide content (Slide 3 — NoSQL Features Implemented):
- Referenced collections for core master data
- Arrays for line-item modeling
- Aggregation pipelines for analytics/reporting
- Date-based querying and temporal filtering

Speaker script (3:00–3:30):
“The implementation demonstrates practical NoSQL capabilities: referenced collections for stable master data, arrays for transaction line items, and aggregation pipelines for reporting.
Date-based filters are also used for period-wise analysis.
Together, these features make MongoDB suitable for transaction-plus-reporting workloads in this scenario.”

---

### 3:30 – 5:30 | Demonstration: MongoDB Commands to Create DB
Show live terminal/mongosh (record every command):
1. `use tte_nosql`
2. `db.createCollection(...)` for each collection
3. Index creation commands (e.g., product_id, customer_id, purchase_date)
4. `insertMany(...)` for sample data

Say:
- “I now demonstrate full command sequence to create collections and sample records.”
- “Indexes were added for query efficiency on frequently filtered fields.”
- “Any issue encountered is shown immediately with fix.”

Issues section (if happened):
- field type mismatch
- duplicate key/index collision
- wrong reference IDs
- date parsing issue

For each issue, mention:
- error message
- cause
- fix applied

---

### 5:30 – 8:30 | Demonstration: 5 Queries (Code + Full Output)
For **each query** show:
1. Query code screenshot
2. Complete output screenshot
3. 20–30 sec explanation: purpose + functionality + issue/fix (if any)

Recommended query set for this scenario:
1. **Customer purchase history** by customer ID and date range
2. **Top-selling products** (aggregate purchase items)
3. **Low stock alert** across stores/warehouses
4. **Transfer history** between locations with item details
5. **Revenue by store** within a period

Say pattern per query:
- “Yo query ko objective ...”
- “Code le ... filter/group/project gariracha.”
- “Output le ... insight dincha.”
- “Issue ayo bhane, maile ... गरेर resolve gare.”

---

### 8:30 – 10:00 | Reflection: Relational vs NoSQL + Literature
Show:
- Comparison table (Relational vs MongoDB for this scenario)
- 2–3 papers/articles used
- Key highlighted lines/sections from those papers

Say:
- “Relational design ensures strict integrity and normalization.”
- “MongoDB gives flexible document modeling and efficient nested retrieval for purchase/transfer structures.”
- “For this scenario, [your final judgment] is more suitable because [consistency vs flexibility, transaction scope, query patterns].”
- “Comparison supported by literature; here are the exact key sections referenced.”

---

## B. Required Evidence Checklist (must appear in screencast)
- [ ] Final ER diagram (same Assignment 1 scenario)
- [ ] Explicit feedback changes (Before → After)
- [ ] MongoDB schema rationale (collection-by-collection)
- [ ] Why nested documents/arrays were used
- [ ] Full DB creation commands executed live
- [ ] Issues encountered + fixes explained
- [ ] All 5 queries: code + complete output + explanation
- [ ] Brief relational vs NoSQL reflection
- [ ] Papers/articles shown with key discussed sections

---

## C. Slide Deck Suggestion (compact)
1. Title + scenario
2. Final ER diagram
3. Assignment 1 feedback summary
4. Before → After changes
5. Relational-to-MongoDB mapping
6. MongoDB collections + embedding/reference decisions
7. DB creation command flow + issues/fixes
8. Query 1–2 evidence
9. Query 3–5 evidence
10. Reflection + literature-backed conclusion

---

## D. Short Speaking Formula (Nepali)
- “Yo mero Assignment 1 ko same scenario ho.”
- “Feedback anusar maile yo key changes gare.”
- “Tespachi maile yeslai MongoDB schema ma convert gare ra yo collections choose gare.”
- “Yo commands le database create gare, yo issues aaye, yo fix gare.”
- “Yo 5 queries le scenario ko main requirements validate garcha.”
- “Finally, relational vs NoSQL compare गर्दा, mero scenario ko lagi [final choice] justified cha.”
