# data_dictionary.md
Relação Agua-Hardware Microsoft
1) Visão geral

Este projeto analisa a evolução do uso de água da Microsoft e sua intensidade hídrica normalizada por receita, considerando a expansão de infraestrutura digital (cloud/IA). Os dados de água são reportados em ano fiscal (FY) e foram extraídos de relatório público de sustentabilidade.

Observação metodológica: a partir de FY24, a empresa informa que os valores incorporam um método atualizado para estimar locais de datacenter sem dados reais disponíveis; por isso, FY20–FY23 é a série principal de comparação e FY24 deve ser interpretado com cautela. 

2025-Microsoft-Environmental-Su…

2) Glossário de termos

FY (Fiscal Year / Ano Fiscal): ano fiscal da Microsoft (encerrado em 30 de junho). Ex.: FY23 refere-se ao ano fiscal encerrado em 30/06/2023.

Retirada de água (Water withdrawal): volume total de água retirado de fontes para uso nas operações (inclui água potável e outras fontes).

Consumo de água (Water consumption): parte da água retirada que não retorna ao mesmo sistema hídrico (conceito usado em reportes ambientais; pode ser menor que a retirada).

Intensidade hídrica: métrica normalizada que relaciona água utilizada e valor gerado (ex.: m³ por receita). Quanto menor, maior eficiência (no contexto deste projeto).

3) Fonte dos dados (rastreabilidade)

Dados de água: extraídos do relatório Microsoft Environmental Sustainability Report 2025, seção Water, “Water Table 5 – Total water consumption and withdrawal (Water m³)” (página 37). 

2025-Microsoft-Environmental-Su…


Dados financeiros (receita): extraídos de documentos oficiais (10-K/Annual Report), registrados em source_doc e source_locator.

4) Modelo de dados (tabelas)
4.1 dim_fiscal_year

Tabela de dimensão para garantir consistência do período analisado.

Coluna	Tipo	Descrição	Exemplo
fiscal_year	VARCHAR(4)	Identificador do ano fiscal	FY23
year_end_date	DATE	Data de encerramento do ano fiscal (opcional)	2023-06-30
notes	VARCHAR(255)	Observações de contexto	“FY ends June 30”
4.2 fact_water

Tabela de fatos ambientais (água), com rastreabilidade de fonte e indicador de metodologia.

Coluna	Tipo	Descrição	Exemplo
fiscal_year	VARCHAR(4)	Ano fiscal (chave)	FY22
water_withdrawn_m3	DECIMAL	Retirada total de água em m³	10706000
water_consumed_m3	DECIMAL	Consumo total de água em m³	6399000
method_flag	ENUM	Flag de comparabilidade metodológica	pre_FY24
source_doc	VARCHAR	Documento de origem	“ESR 2025”
source_locator	VARCHAR	Local no documento (tabela/página)	“Water Table 5, p.37”
extraction_date	DATE	Data em que o dado foi extraído	2026-02-27

Regra de qualidade esperada: water_consumed_m3 ≤ water_withdrawn_m3.

method_flag:

pre_FY24 → anos comparáveis historicamente (FY20–FY23)

FY24_updated_method → FY24, com método atualizado de estimativa (comparar com cautela) 

2025-Microsoft-Environmental-Su…

4.3 fact_financials

Tabela de fatos financeiros (receita).

Coluna	Tipo	Descrição	Exemplo
fiscal_year	VARCHAR(4)	Ano fiscal (chave)	FY23
revenue_usd	DECIMAL	Receita total anual em USD	211915000000
source_doc	VARCHAR	Documento de origem	“10-K FY24”
source_locator	VARCHAR	Local no documento (seção/tabela)	“Statements of Operations”
extraction_date	DATE	Data de extração	2026-02-27
5) KPIs calculados (VIEW vw_water_finance_kpis)

Esta view consolida água + receita e calcula indicadores.

KPI	Fórmula	Interpretação
withdrawn_per_revenue	withdrawn_m3 / revenue_usd	Retirada por dólar (menor = melhor)
consumed_per_revenue	consumed_m3 / revenue_usd	Consumo por dólar (menor = melhor)
withdrawn_m3_per_usd_billion	(withdrawn_m3 / revenue_usd) * 1e9	m³ por US$ 1 bilhão (executivo)
consumed_m3_per_usd_billion	(consumed_m3 / revenue_usd) * 1e9	m³ por US$ 1 bilhão (executivo)
yoy_revenue_growth	(rev - prev_rev) / prev_rev	Crescimento anual da receita
yoy_withdrawn_growth	(with - prev_with) / prev_with	Crescimento anual da retirada
yoy_consumed_growth	(cons - prev_cons) / prev_cons	Crescimento anual do consumo

Nota: KPIs YoY são calculados apenas quando há ano anterior disponível.

6) Convenções e apresentação

Sempre indicar que FY é ano fiscal.

Análises principais devem usar FY20–FY23.

FY24 deve aparecer com nota/flag de metodologia (comparação com cautela).
