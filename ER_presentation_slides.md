# ER Diagram Presentation (Assignment 1 Scenario)

## Slide 1: Title
**Title:** ER Diagram + Changes from Assignment 1 Feedback  
**Subtitle:** Scenario: [Your Assignment 1 Scenario Name]

**What to say:**
- Namaste, yo presentation ma maile Assignment 1 ko same scenario ko ER diagram dekhauchu.
- Ani teacher feedback ko basis ma ke-kea change gare, teslai discuss garchu.

---

## Slide 2: Final ER Diagram
**Add:** Final/updated ER diagram image (clear and large).

**Show clearly:**
- Entities
- Attributes
- Relationships
- Cardinalities (1:1, 1:M, M:N)

**What to say:**
- Yo mero final ER diagram ho.
- Maile entities, relationships ra cardinalities lai feedback anusar refine gareko chu.

---

## Slide 3: Assignment 1 Feedback Summary
**Title:** Key Feedback from Assignment 1

**Add 2–5 bullets from teacher feedback:**
- Payment/bank details लाई customer structure बाट छुट्याएर normalized entity बनाउनू।
- Purchase header र line-items बीच cardinality/ownership अझ clear देखाउनू।
- Stock location rule (Store vs Warehouse) constraint level मा enforce गर्नू।
- Stock transfer source model लाई warehouse/store दुवै support हुने गरी clarify गर्नू।

**What to say:**
- Assignment 1 ma yesta main feedback points aayeko thiyo.
- Aba ma yesko basis ma gareko improvements dekhauchu.

---

## Slide 4: Feedback Improvements (Bullet Points Table)
**Title:** Before / Received Feedback / After

| Before (Initial Design) | Received Feedback | After (Improvement) |
|---|---|---|
| • Customer ra bank detail एउटै structure मा mix थियो। | • Payment/bank detail लाई normalized entity मा छुट्याउनू। | • `customer` मा `bank_sort_code` FK राखेर `bank(sort_code)` सँग reference बनाइयो। |
| • Purchase line-items को relation स्पष्ट थिएन। | • Purchase र item बीचको cardinality/ownership clear देखाउनू। | • `purchase` (header) र `purchase_item` (detail) अलग table बनाएर 1:M relation स्पष्ट गरियो। |
| • Stock कहाँ राखिएको छ भन्ने logic ambiguous थियो। | • Store vs Warehouse location rule enforce हुने design चाहियो। | • `stock` table मा `store_id`/`warehouse_id` मध्ये exactly one मात्र रहने constraint राखियो। |
| • Transfer source modeling rigid/unclear थियो। | • Transfer source warehouse वा store दुवै support हुने model चाहियो। | • `stock_transfer` मा `source_warehouse_id` र `source_store_id` राखेर conditional CHECK constraints define गरियो। |
| • Product movement detail linkage complete थिएन। | • Transfer header र transferred items बीच strong relation देखाउनू। | • `transfer_item(transfer_id, product_id)` junction table + FKs राखेर transfer details fully normalized गरियो। |

**Closing line (speaker note):**  
“Yo before-feedback-after changes le ER model lai clear, normalized, ra implementation ko lagi practical बनायो.”

---

## Slide 5: Why These Changes Improve the Model
**Title:** Improvement Impact

**Points:**
- Better data consistency
- Less redundancy
- Easier querying and implementation
- Better real-world representation

**What to say:**
- Yo changes le database design lai ajhai robust banayo.
- Data anomalies kam huncha, query garna sajilo huncha, ra real-world process sanga better match garcha.

---

## Short Speaking Formula (Memorize)
1. Yo mero final ER diagram ho.
2. Assignment 1 ma yesto feedback aayeko thiyo.
3. Maile feedback anusar yo-yo changes gare.
4. Yesle model quality improve garyo.

---

## Quick Submission Checklist
- [ ] Final ER diagram image added in slide 2
- [ ] Actual teacher feedback inserted in slide 3
- [ ] Before/After changes filled in slide 4
- [ ] Scenario name replaced in slide 1
- [ ] Practice done (2–4 minutes)
