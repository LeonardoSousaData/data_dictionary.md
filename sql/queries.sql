/* =========================================================
   PROJETO: Eficiência hídrica e governança ESG em data centers
   ARQUIVO: queries.sql
   OBJETIVO: validação, exploração e consulta analítica
   ========================================================= */

USE microsoft_water_finance;


/* =========================================================
   1) CHECK GERAL DE ESTRUTURA
   ========================================================= */
SHOW TABLES;
SHOW FULL TABLES;


/* =========================================================
   2) CONTAGEM DE REGISTROS
   ========================================================= */
SELECT COUNT(*) AS qtd_dim FROM dim_fiscal_year;
SELECT COUNT(*) AS qtd_water FROM fact_water;
SELECT COUNT(*) AS qtd_financials FROM fact_financials;
SELECT COUNT(*) AS qtd_dc FROM fact_datacenter_efficiency;


/* =========================================================
   3) VISUALIZAÇÃO DAS TABELAS BASE
   ========================================================= */
SELECT * FROM dim_fiscal_year ORDER BY fiscal_year;
SELECT * FROM fact_water ORDER BY fiscal_year;
SELECT * FROM fact_financials ORDER BY fiscal_year;
SELECT * FROM fact_datacenter_efficiency ORDER BY fiscal_year;


/* =========================================================
   4) DISTINTOS DE ANO FISCAL
   ========================================================= */
SELECT DISTINCT fiscal_year FROM dim_fiscal_year ORDER BY fiscal_year;
SELECT DISTINCT fiscal_year FROM fact_water ORDER BY fiscal_year;
SELECT DISTINCT fiscal_year FROM fact_financials ORDER BY fiscal_year;
SELECT DISTINCT fiscal_year FROM fact_datacenter_efficiency ORDER BY fiscal_year;


/* =========================================================
   5) VALIDAÇÃO DE JOIN ENTRE DIMENSÃO E FATOS
   ========================================================= */
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
ORDER BY y.fiscal_year;


/* =========================================================
   6) VISUALIZAÇÃO DAS VIEWS
   ========================================================= */
SELECT * FROM vw_water_finance_kpis ORDER BY fiscal_year;
SELECT * FROM vw_water_finance_dc_kpis ORDER BY fiscal_year;


/* =========================================================
   7) QUERY ANALÍTICA PRINCIPAL
   ========================================================= */
SELECT
    fiscal_year,
    revenue_usd,
    water_withdrawn_m3,
    water_consumed_m3,
    method_flag,
    withdrawn_per_revenue,
    consumed_per_revenue,
    withdrawn_m3_per_usd_billion,
    consumed_m3_per_usd_billion,
    cycle_consumption_rate,
    yoy_revenue_growth,
    yoy_withdrawn_growth,
    yoy_consumed_growth,
    wue_l_per_kwh
FROM vw_water_finance_dc_kpis
ORDER BY fiscal_year;


/* =========================================================
   8) CHECAGEM DE CONSISTÊNCIA DE ÁGUA
   ========================================================= */
SELECT *
FROM fact_water
WHERE water_consumed_m3 > water_withdrawn_m3;


/* =========================================================
   9) CHECAGEM DE RECEITA POSITIVA
   ========================================================= */
SELECT *
FROM fact_financials
WHERE revenue_usd <= 0;


/* =========================================================
   10) ANÁLISE EXECUTIVA - INTENSIDADE HÍDRICA
   ========================================================= */
SELECT
    fiscal_year,
    withdrawn_m3_per_usd_billion,
    consumed_m3_per_usd_billion
FROM vw_water_finance_kpis
ORDER BY fiscal_year;


/* =========================================================
   11) ANÁLISE EXECUTIVA - CRESCIMENTO YOY
   ========================================================= */
SELECT
    fiscal_year,
    yoy_revenue_growth,
    yoy_withdrawn_growth,
    yoy_consumed_growth
FROM vw_water_finance_kpis
ORDER BY fiscal_year;


/* =========================================================
   12) ANÁLISE EXECUTIVA - TAXA DE CONSUMO DO CICLO
   ========================================================= */
SELECT
    fiscal_year,
    cycle_consumption_rate
FROM vw_water_finance_kpis
ORDER BY fiscal_year;


/* =========================================================
   13) ANÁLISE EXECUTIVA - WUE
   ========================================================= */
SELECT
    fiscal_year,
    wue_l_per_kwh
FROM vw_water_finance_dc_kpis
ORDER BY fiscal_year;


/* =========================================================
   14) CONSULTA RESUMIDA PARA EXPORTAÇÃO / PYTHON / BI
   ========================================================= */
SELECT
    fiscal_year,
    revenue_usd,
    water_withdrawn_m3,
    water_consumed_m3,
    withdrawn_m3_per_usd_billion,
    consumed_m3_per_usd_billion,
    cycle_consumption_rate,
    yoy_revenue_growth,
    yoy_withdrawn_growth,
    yoy_consumed_growth,
    wue_l_per_kwh
FROM vw_water_finance_dc_kpis
ORDER BY fiscal_year;