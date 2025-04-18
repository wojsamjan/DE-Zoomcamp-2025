-- Creating a partitioned table
CREATE OR REPLACE TABLE dez2025_tf_dataset.crimes_toronto_partitioned
PARTITION BY
  DATE_TRUNC(REPORT_DATE, MONTH) AS
SELECT * FROM dez2025_tf_dataset.crimes;

-- Impact of partition
-- Scanning 29.16MB of data
SELECT EVENT_UNIQUE_ID, REPORT_DATE, OCC_DATE, DIVISION, LOCATION_TYPE
FROM dez2025_tf_dataset.crimes
WHERE DATE(REPORT_DATE) BETWEEN '2015-01-01' AND '2015-12-31';

-- Scanning 2.27 MB of data
SELECT EVENT_UNIQUE_ID, REPORT_DATE, OCC_DATE, DIVISION, LOCATION_TYPE
FROM dez2025_tf_dataset.crimes_toronto_partitioned
WHERE DATE(REPORT_DATE) BETWEEN '2015-01-01' AND '2015-12-31';



-- Creating a partitioned and clustered table
CREATE OR REPLACE TABLE dez2025_tf_dataset.crimes_toronto_partitioned_clustered
PARTITION BY DATE_TRUNC(REPORT_DATE, MONTH)
CLUSTER BY PREMISES_TYPE AS
SELECT * FROM dez2025_tf_dataset.crimes;

-- Impact of partition and clustering
-- Scanning 32.53MB of data
SELECT EVENT_UNIQUE_ID, REPORT_DATE, OCC_DATE, DIVISION, LOCATION_TYPE
FROM dez2025_tf_dataset.crimes
WHERE DATE(REPORT_DATE) BETWEEN '2015-01-01' AND '2015-12-31'
AND PREMISES_TYPE='APARTMENT';

-- Scanning 2.54 MB of data
SELECT EVENT_UNIQUE_ID, REPORT_DATE, OCC_DATE, DIVISION, LOCATION_TYPE
FROM dez2025_tf_dataset.crimes_toronto_partitioned_clustered
WHERE DATE(REPORT_DATE) BETWEEN '2015-01-01' AND '2015-12-31'
AND PREMISES_TYPE='APARTMENT';
