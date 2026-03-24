    # Plano do Projeto

## Título
Eficiência hídrica e governança ESG em data centers: análise do uso de água da Microsoft (FY20–FY24)

---

## Objetivo
Avaliar a evolução do uso de água da Microsoft entre FY20 e FY24, medindo retirada, consumo, intensidade hídrica por receita e indicadores complementares de eficiência operacional.

---

## Problema de negócio
Verificar se o crescimento da receita foi acompanhado por melhora ou piora relativa na eficiência hídrica, considerando tanto a visão corporativa consolidada quanto uma métrica operacional complementar de data center (WUE).

---

## Escopo analítico
- período: FY20–FY24
- empresa: Microsoft
- foco: água, receita, intensidade hídrica, YoY, cycle rate e WUE

---

## Etapas do projeto

### 1. Definição do escopo
- escolha do tema
- definição da empresa
- escolha do período
- definição dos KPIs principais

### 2. Coleta e organização dos dados
- identificação das fontes públicas
- estruturação dos CSVs
- padronização de nomes e formatos

### 3. Modelagem relacional
- criação da dimensão temporal
- criação das tabelas fato
- criação das constraints
- criação das views analíticas

### 4. Validação analítica em Python
- leitura do banco
- conferência dos dados
- comparação de KPIs
- geração de gráficos exploratórios

### 5. Construção do dashboard
- página 1: ESG & Valor
- página 2: Drivers Operacionais & Leitura Complementar
- página 3: Conclusões & Recomendações

### 6. Documentação final
- README
- data_dictionary
- organização do repositório

---

## Principais métricas
- água retirada
- água consumida
- receita
- intensidade hídrica por receita
- crescimento YoY
- taxa de consumo do ciclo
- WUE

---

## Limitações
- dados corporativos consolidados
- ausência de detalhamento por região ou segmento operacional
- comparabilidade parcial de FY24 devido à atualização metodológica

---

## Próximos passos
- incluir proxies por segmento
- incorporar novas métricas públicas
- automatizar atualização com SQL/Python