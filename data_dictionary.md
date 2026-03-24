# Dicionário de Dados

## Visão geral
Este projeto utiliza uma dimensão temporal e três tabelas fato para analisar a evolução do uso de água da Microsoft entre FY20 e FY24, combinando dados ambientais, financeiros e um indicador operacional complementar de data center.

---

## Tabela: dim_fiscal_year

### fiscal_year
- Tipo: VARCHAR(4)
- Descrição: identificador do ano fiscal
- Exemplo: FY20, FY21, FY22

### year_end_date
- Tipo: DATE
- Descrição: data de encerramento do ano fiscal

### notes
- Tipo: VARCHAR(255)
- Descrição: observações sobre o ano fiscal

---

## Tabela: fact_water

### fiscal_year
- Tipo: VARCHAR(4)
- Descrição: chave do ano fiscal
- Relacionamento: FK com dim_fiscal_year

### water_withdrawn_m3
- Tipo: DECIMAL(15,2)
- Descrição: volume total de água retirada no ano fiscal
- Unidade: m³

### water_consumed_m3
- Tipo: DECIMAL(15,2)
- Descrição: volume total de água consumida no ano fiscal
- Unidade: m³

### method_flag
- Tipo: ENUM
- Descrição: indicador de metodologia usada no dado
- Valores esperados: pre_FY24, FY24_updated_method

### source_doc
- Tipo: VARCHAR(200)
- Descrição: documento-fonte do dado

### source_locator
- Tipo: VARCHAR(200)
- Descrição: local de referência no documento-fonte

### extraction_date
- Tipo: DATE
- Descrição: data de extração do dado

---

## Tabela: fact_financials

### fiscal_year
- Tipo: VARCHAR(4)
- Descrição: chave do ano fiscal
- Relacionamento: FK com dim_fiscal_year

### revenue_usd
- Tipo: DECIMAL(18,2)
- Descrição: receita anual consolidada
- Unidade: USD

### source_doc
- Tipo: VARCHAR(200)
- Descrição: documento-fonte do dado

### source_locator
- Tipo: VARCHAR(200)
- Descrição: local de referência no documento-fonte

### extraction_date
- Tipo: DATE
- Descrição: data de extração do dado

---

## Tabela: fact_datacenter_efficiency

### fiscal_year
- Tipo: VARCHAR(4)
- Descrição: chave do ano fiscal
- Relacionamento: FK com dim_fiscal_year

### wue_l_per_kwh
- Tipo: DECIMAL(10,4)
- Descrição: indicador WUE de eficiência hídrica em data centers
- Unidade: L/kWh

### source_doc
- Tipo: VARCHAR(200)
- Descrição: documento-fonte do dado

### source_locator
- Tipo: VARCHAR(200)
- Descrição: local de referência no documento-fonte

### extraction_date
- Tipo: DATE
- Descrição: data de extração do dado

---

## View: vw_water_finance_kpis

### withdrawn_per_revenue
- Descrição: intensidade de retirada por dólar de receita
- Unidade: m³/USD

### consumed_per_revenue
- Descrição: intensidade de consumo por dólar de receita
- Unidade: m³/USD

### withdrawn_m3_per_usd_billion
- Descrição: intensidade de retirada por US$ 1 bilhão
- Unidade: m³ por US$ 1 bilhão

### consumed_m3_per_usd_billion
- Descrição: intensidade de consumo por US$ 1 bilhão
- Unidade: m³ por US$ 1 bilhão

### cycle_consumption_rate
- Descrição: proporção entre água consumida e água retirada
- Unidade: razão

### yoy_revenue_growth
- Descrição: crescimento anual da receita
- Unidade: razão

### yoy_withdrawn_growth
- Descrição: crescimento anual da água retirada
- Unidade: razão

### yoy_consumed_growth
- Descrição: crescimento anual da água consumida
- Unidade: razão

---

## View: vw_water_finance_dc_kpis

### wue_l_per_kwh
- Descrição: indicador operacional complementar de eficiência hídrica em data centers
- Unidade: L/kWh