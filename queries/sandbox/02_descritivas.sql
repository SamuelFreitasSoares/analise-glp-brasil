-- Pergunta: Como se comporta a média dos preços do GLP ao longo do tempo

-- Visão inicial dos dados
select *
from glp_precos
limit 5

-- Número de entradas por região
-- Result: o Sudeste demonstra ter 42,25% de todas as entradas 
select 
    regiao,
    count(1) as qtd_linhas,
    round(100.0*count(1) / (select count(1) from glp_precos),2) as perc_qtd_total
from 
    glp_precos
group by 
    regiao
order by 
    count(1) desc

-- Número de entradas por estado
-- Result: São Paulo sozinho representa 22,56% de todas as medidas
-- enquanto estados como Amapá e Roraima não chegam a 1%
select 
    estado,
    count(1) as qtd_linhas,
    round(100.0*count(1) / (select count(1) from glp_precos),2) as perc_qtd_total
from 
    glp_precos
group by 
    estado
order by 
    count(1) desc

-- Devido à diferença significativa no número de registros entre os estados,
-- uma média nacional simples sairia distorcida, portanto
-- decidí calcular a variação da média do preço do GLP 
---por Estado e não do Brasil como um todo
select 
    date_part('year',data_coleta) as ano,
    date_part('month',data_coleta) as mes,
    estado,
    round(avg(valor_venda), 2) as preco_medio,
    min(valor_venda) as menor_valor,
    max(valor_venda) as maior_valor
from 
    glp_precos
group by 
    date_part('year',data_coleta), 
    date_part('month', data_coleta), 
    estado

