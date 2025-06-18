-------------------------------------------------------------
-- Inserting silver.crm_cust_info
-------------------------------------------------------------
INSERT INTO silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'married'
	ELSE 'n/a'
END AS cst_marital_status,
CASE
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_date
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL) t
WHERE flag_date = 1

---------------------------------------------------------------------
PRINT 'Inserting silver.crm_sales_detail'
---------------------------------------------------------------------
INSERT INTO silver.crm_sales_details
(sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price)
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE 
	WHEN sls_order_dt < 0 OR LEN(sls_order_dt) !=8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS NVARCHAR)AS DATE)
END AS sls_order_dt,
CASE 
	WHEN sls_ship_dt < 0 OR LEN(sls_ship_dt)!= 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt < 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE)
END AS sls_due_dt,
CASE
	WHEN sls_sales != sls_price * sls_quantity OR sls_sales IS NULL OR sls_sales <= 0
	THEN ABS(sls_price) * sls_quantity
	ELSE sls_sales
END sls_sales,
sls_quantity,
CASE
	WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END sls_price
FROM bronze.crm_sales_details;

 
