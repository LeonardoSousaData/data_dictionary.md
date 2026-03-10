USE microsoft_water_finance;

-- 1) Contagem de linhas (sanidade)
SELECT 'dim_fiscal_year' AS table_name, COUNT(*) AS rows_count FROM dim_fiscal_year
UNION ALL
SELECT 'fact_water', COUNT(*) FROM fact_water
UNION ALL
SELECT 'fact_financials', COUNT(*) FROM fact_financials
UNION ALL
SELECT 'fact_datacenter_efficiency', COUNT(*) FROM fact_datacenter_efficiency;

-- 2) Regra de qualidade: consumo <= retirada (deve retornar 0 linhas)
SELECT *
FROM fact_water
WHERE water_consumed_m3 > water_withdrawn_m3;

-- 3) Série comparável (FY20–FY23)
SELECT *
FROM vw_water_finance_kpis
WHERE method_flag = 'pre_FY24'
ORDER BY fiscal_year;

-- 4) FY24 separado (método atualizado)
SELECT *
FROM vw_water_finance_kpis
WHERE method_flag = 'FY24_updated_method';

-- 5) Tendência de água
SELECT fiscal_year, water_withdrawn_m3, water_consumed_m3
FROM vw_water_finance_kpis
ORDER BY fiscal_year;

-- 6) Intensidade hídrica (m³ por US$ 1B)
SELECT fiscal_year, withdrawn_m3_per_usd_billion, consumed_m3_per_usd_billion
FROM vw_water_finance_kpis
ORDER BY fiscal_year;

-- 7) YoY comparativo (água vs receita)
SELECT fiscal_year, yoy_revenue_growth, yoy_withdrawn_growth, yoy_consumed_growth
FROM vw_water_finance_kpis
ORDER BY fiscal_year;

-- 8) Cycle rate (consumo/retirada)
SELECT fiscal_year, cycle_consumption_rate
FROM vw_water_finance_kpis
ORDER BY fiscal_year;

-- 9) Drivers operacionais (WUE)
SELECT fiscal_year, wue_l_per_kwh, cycle_consumption_rate
FROM vw_water_finance_dc_kpis
ORDER BY fiscal_year;