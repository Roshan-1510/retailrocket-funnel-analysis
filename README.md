# Retail Rocket Funnel Analysis

## **Headlines**

**2.68% Conversion rate between view to add to cart reveals that high view with 0 add to cart  points to product level issue scattered over 21 categories**

## **Business Context**

**Retail Rocket is an Retention Management Platform where they provide strategies for different Business. Having 1.4M users Dataset, currently only 2.68% of 1,404,179 viewer add product to there cart. A 1% improvement leads to addition of 13951 additional users.**

## **Approach**

**The Investigation began by Identifying the number of unique user on each event. The Analysis found that the conversion rate on each step was the lowest at view to add to cart. To Identify the cause we drilled down on identifying product with high view and near zero add to cart where 6,189 such product were identified. A Sample of 50 item were taken to identify Whether there is issue at the product level where it came out the 9 product do not have any meta data and remaining item are scattered among 21 categories indicating issue at product level.**

## **Findings**

- **Finding 1 - Total number of unique view -1,404,179 add to cart 37,722 and transaction 11,791**
- **Finding 2 - Conversion Rate between view to add to cart - 2.68% for add to cart to transaction it is 31.25%**
- **Finding 3- there are total 6,189 items with high view and near zero add to cart.**
- **Finding 4 - There are such 9 product with no meta data available.**

## **Recommendations**

**1) Based on Finding 4, conduct a metadata audit across the full 6,189 item shortlist to identify and fix missing product information that prevents users from making purchase decisions.**

**2)Based on Finding 3, conduct a product page audit across the 6,189 high-view, near-zero addtocart items to identify and resolve barriers preventing users from adding to cart.**

## **Technical Proof**

#### 

**Business Question:** How many unique users exist at each funnel stage?

sql

`SELECT COUNT(DISTINCT(visitorid)) AS Number_of_users,
  Count(Distinct(CASE WHEN event = 'view' THEN visitorid END)) AS Number_of_Unique_View,
  Count(Distinct(CASE WHEN event = 'addtocart' THEN visitorid END)) AS Number_of_Unique_AddtoCart,
  Count(Distinct(CASE WHEN event = 'transaction' THEN visitorid END)) AS Number_of_Unique_Transaction
FROM events;`

**Business Question:** What is the 95th percentile view threshold for identifying high-view products?

sql

`WITH view_per_item AS (
  SELECT itemid, COUNT(DISTINCT visitorid) AS count_view
  FROM Events WHERE event='view'
  GROUP BY itemid),
ranked AS (
  SELECT itemid, count_view,
  ROW_NUMBER() OVER(ORDER BY count_view) AS rn,
  COUNT(*) OVER() AS total
  FROM view_per_item)
SELECT count_view FROM ranked
WHERE rn = FLOOR(total * 0.95);`

---

**Business Question:** Which items have high views but near-zero addtocart, ranked by missed opportunity?

sql

`WITH view_per_item AS (
  SELECT itemid, COUNT(DISTINCT visitorid) AS count_view
  FROM Events WHERE event='view'
  GROUP BY itemid),
addtocart_per_item AS (
  SELECT itemid, COUNT(DISTINCT visitorid) AS count_addtocart
  FROM Events WHERE event='addtocart'
  GROUP BY itemid)
SELECT v.itemid, (v.count_view * 0.0268) - IFNULL(a.count_addtocart,0) AS miss_addtocart
FROM view_per_item v
LEFT JOIN addtocart_per_item a ON v.itemid = a.itemid
WHERE (IFNULL(a.count_addtocart,0)/v.count_view)*100 < 2.6
AND v.count_view > 36
ORDER BY miss_addtocart DESC, v.count_view DESC;`

---

**Business Question:** Which items in the top 50 shortlist are missing metadata entirely?

python

`result_ids = set(df_latest['itemid'])
input_ids = set(top_50_ids)
missing_ids = input_ids - result_ids
print(len(missing_ids), sorted(missing_ids))

# 9 items confirmed missing:
top_9_ids = [29100, 156173, 184998, 229204, 244924, 260650, 287664, 298196, 449571]`
