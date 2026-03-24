/* =========================================================
   PROJETO: Eficiência hídrica e governança ESG em data centers
   EMPRESA: Microsoft
   PERÍODO: FY20–FY24
   SGBD: MySQL / MariaDB
   ========================================================= */

/* =========================================================
   1) DATABASE
   ========================================================= */
DROP DATABASE IF EXISTS microsoft_water_finance;
CREATE DATABASE microsoft_water_finance;
USE microsoft_water_finance;


/* =========================================================
   2) DIMENSÃO: dim_fiscal_year
   ========================================================= */
DROP TABLE IF EXISTS dim_fiscal_year;
CREATE TABLE dim_fiscal_year (
  fiscal_year VARCHAR(4) PRIMARY KEY,
  year_end_date DATE NULL,
  notes VARCHAR(255) NULL
);


/* =========================================================
   3) FATO ESG (ÁGUA): fact_water
   ========================================================= */
DROP TABLE IF EXISTS fact_water;
CREATE TABLE fact_water (
  fiscal_year VARCHAR(4) PRIMARY KEY,
  water_withdrawn_m3 DECIMAL(15,2) NOT NULL,
  water_consumed_m3  DECIMAL(15,2) NOT NULL,

  method_flag ENUM('pre_FY24','FY24_updated_method') NOT NULL,

  source_doc VARCHAR(200) NOT NULL,
  source_locator VARCHAR(200) NOT NULL,
  extraction_date DATE NOT NULL,

  CONSTRAINT fk_water_year
    FOREIGN KEY (fiscal_year) REFERENCES dim_fiscal_year(fiscal_year),

  CONSTRAINT chk_consumed_le_withdrawn
    CHECK (water_consumed_m3 <= water_withdrawn_m3)
);


/* =========================================================
   4) FATO FINANCEIRO (RECEITA): fact_financials
   ========================================================= */
DROP TABLE IF EXISTS fact_financials;
CREATE TABLE fact_financials (
  fiscal_year VARCHAR(4) PRIMARY KEY,
  revenue_usd DECIMAL(18,2) NOT NULL,

  source_doc VARCHAR(200) NOT NULL,
  source_locator VARCHAR(200) NOT NULL,
  extraction_date DATE NOT NULL,

  CONSTRAINT fk_fin_year
    FOREIGN KEY (fiscal_year) REFERENCES dim_fiscal_year(fiscal_year),

  CONSTRAINT chk_revenue_positive
    CHECK (revenue_usd > 0)
);


/* =========================================================
   5) FATO OPERACIONAL (DATA CENTER): fact_datacenter_efficiency
   ========================================================= */
DROP TABLE IF EXISTS fact_datacenter_efficiency;
CREATE TABLE fact_datacenter_efficiency (
  fiscal_year VARCHAR(4) PRIMARY KEY,
  wue_l_per_kwh DECIMAL(10,4) NOT NULL,

  source_doc VARCHAR(200) NOT NULL,
  source_locator VARCHAR(200) NOT NULL,
  extraction_date DATE NOT NULL,

  CONSTRAINT fk_dc_year
    FOREIGN KEY (fiscal_year) REFERENCES dim_fiscal_year(fiscal_year),

  CONSTRAINT chk_wue_positive
    CHECK (wue_l_per_kwh > 0)
);


/* =========================================================
   6) CARGA INICIAL DA DIMENSÃO
   ========================================================= */
INSERT INTO dim_fiscal_year (fiscal_year, year_end_date, notes) VALUES
('FY20', '2020-06-30', 'Fiscal year ends June 30'),
('FY21', '2021-06-30', 'Fiscal year ends June 30'),
('FY22', '2022-06-30', 'Fiscal year ends June 30'),
('FY23', '2023-06-30', 'Fiscal year ends June 30'),
('FY24', '2024-06-30', 'Fiscal year ends June 30');


/* =========================================================
   7) VIEW ESG: vw_water_finance_kpis
   ========================================================= */
DROP VIEW IF EXISTS vw_water_finance_kpis;

CREATE VIEW vw_water_finance_kpis AS
WITH base AS (
  SELECT
    y.fiscal_year,
    f.revenue_usd,
    w.water_withdrawn_m3,
    w.water_consumed_m3,
    w.method_flag
  FROM dim_fiscal_year y
  LEFT JOIN fact_financials f
    ON f.fiscal_year = y.fiscal_year
  LEFT JOIN fact_water w
    ON w.fiscal_year = y.fiscal_year
),
kpi AS (
  SELECT
    fiscal_year,
    revenue_usd,
    water_withdrawn_m3,
    water_consumed_m3,
    method_flag,

    (water_withdrawn_m3 / NULLIF(revenue_usd, 0)) AS withdrawn_per_revenue,
    (water_consumed_m3  / NULLIF(revenue_usd, 0)) AS consumed_per_revenue,

    (water_withdrawn_m3 / NULLIF(revenue_usd, 0)) * 1000000000 AS withdrawn_m3_per_usd_billion,
    (water_consumed_m3  / NULLIF(revenue_usd, 0)) * 1000000000 AS consumed_m3_per_usd_billion,

    (water_consumed_m3 / NULLIF(water_withdrawn_m3, 0)) AS cycle_consumption_rate
  FROM base
)
SELECT
  k.*,

  (revenue_usd - LAG(revenue_usd) OVER (ORDER BY fiscal_year))
    / NULLIF(LAG(revenue_usd) OVER (ORDER BY fiscal_year), 0) AS yoy_revenue_growth,

  (water_withdrawn_m3 - LAG(water_withdrawn_m3) OVER (ORDER BY fiscal_year))
    / NULLIF(LAG(water_withdrawn_m3) OVER (ORDER BY fiscal_year), 0) AS yoy_withdrawn_growth,

  (water_consumed_m3 - LAG(water_consumed_m3) OVER (ORDER BY fiscal_year))
    / NULLIF(LAG(water_consumed_m3) OVER (ORDER BY fiscal_year), 0) AS yoy_consumed_growth

FROM kpi k;


/* =========================================================
   8) VIEW DRIVERS: vw_water_finance_dc_kpis
   ========================================================= */
DROP VIEW IF EXISTS vw_water_finance_dc_kpis;

CREATE VIEW vw_water_finance_dc_kpis AS
SELECT
  k.*,
  d.wue_l_per_kwh
FROM vw_water_finance_kpis k
LEFT JOIN fact_datacenter_efficiency d
  ON d.fiscal_year = k.fiscal_year;