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
- [Feedback 1]
- [Feedback 2]
- [Feedback 3]
- [Feedback 4]

**What to say:**
- Assignment 1 ma yesta main feedback points aayeko thiyo.
- Aba ma yesko basis ma gareko improvements dekhauchu.

---

## Slide 4: Feedback Improvements (Before → Feedback → After)
| Before (Initial Design) | Received Feedback | After (Improvement) |
|---|---|---|
| - Customer entity maa bank details direct राखेको थिएँ (sort code, account number). | - Sensitive/payment details lai alag entity/table/structure maa राख्दा design clean ra scalable हुन्छ। | - Bank details lai separate Bank collection/entity reference गरेँ; customer schema cleaner बन्यो। |
| - Purchase ra PurchaseItem relation unclear थियो। | - Line-items ko cardinality ra ownership clear देखाउनु। | - MongoDB maa `purchases` document bhitra `items` array embed गरेर 1-to-many relation स्पष्ट बनाएँ। |
| - Stock location modeling mixed थियो (store/warehouse clarity कम थियो)। | - Inventory location logic स्पष्ट गर, ambiguity हटाऊ। | - `inventory` structure maa location type (`store`/`warehouse`) explicit field राखेँ ra query सरल बनाएँ। |
| - Transfer details normalize गरिए पनि read गर्दा joins धेरै चाहिन्थ्यो। | - Read-heavy operation optimize गर। | - `stockTransfers` maa transfer items array embed गरें, ek query maa transfer detail आउँछ। |
| - Query support fields/index plan mention गरिएको थिएन। | - Query प्रदर्शनका लागि indexing rationale देखाऊ। | - `customer_id`, `product_id`, `purchase_date` maa indexes add गरेर performance justify गरें। |

**Closing line (speaker note):**  
“Yo before-feedback-after changes le model lai clear, practical, ra MongoDB document design ko lagi better बनायो.”

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
