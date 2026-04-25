-- use sys;
-- select * from events Limit 5;

-- calcluation of total transaction percentage
-- Select (Count(*)*100/(select count(*) from events)) as percentage
--  from events where transactionid is not null;

--  count of unique uers on every event
-- SELECT COUNT(DISTINCT(visitorid)) AS Number_of_users,
--   Count(Distinct(CASE WHEN event = 'view' THEN visitorid  END)) AS Number_of_Unique_View,   
--   Count(Distinct(CASE WHEN event = 'addtocart' THEN visitorid END)) AS Number_of_Unique_AddtoCart,   
--   Count(Distinct(CASE WHEN event = 'transaction' THEN visitorid END)) AS Number_of_Unique_Transaction
-- FROM events;

-- with c as (SELECT count(t.visitorid) as count
-- FROM events t
-- Left join events v on 
-- t.visitorid=v.visitorid 
-- and
-- v.event='addtocart'
-- where v.visitorid is Null and t.event='transaction')

-- SELECT (c.count * 100) / (Select count(transactionid) from events where transactionid is Not Null) as total_percent
-- from c;

-- Select count(transactionid) from events where transactionid is Not Null--22457

-- SELECT COUNT(Distinct(visitorid)) FROM events WHERE event = 'transaction';

-- SELECT 
--   MAX(FROM_UNIXTIME(timestamp / 1000)),
--   MIN(FROM_UNIXTIME(timestamp / 1000))
-- FROM events;

-- CREATE VIEW events_clean AS
-- SELECT 
--   *,
--   MONTH(FROM_UNIXTIME(timestamp / 1000)) AS event_month
-- FROM events;

 SELECT event_month, COUNT(DISTINCT(visitorid)) AS Number_of_Unique_users,
 Count(Distinct(CASE WHEN event = 'view' THEN visitorid  END)) AS Number_of_Unique_View,   
   Count(Distinct(CASE WHEN event = 'addtocart' THEN visitorid END)) AS Number_of_Unique_AddtoCart,   
   Count(Distinct(CASE WHEN event = 'transaction' THEN visitorid END)) AS Number_of_Unique_Transaction
 FROM events_clean
 GROUP BY event_month;



