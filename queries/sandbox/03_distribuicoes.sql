-- Perguntas:
-- 1) Qual a amplitude de preço dentro de cada estado num mesmo período?
-- 2) como os preços se comportam por bandeira?

-- Visão inicial dos dados
select *
from glp_precos
limit 5

-- 1: Devido ao fato de que a presença de outliers pode
-- afetar a interpretação da medida 'amplitude', que é 
-- apenas a diferença simples entre o menor e maior valor,
-- decidi que seria melhor usar o desvio padrao para analisar
-- a variação de preco do GLP em cada Estado, pois ele mede
-- a dispersão média dos dados em relação à média aritimética
select 
    date_part('year',data_coleta) as ano,
    date_part('month',data_coleta) as mes,
    estado,
    round(stddev(valor_venda), 2) as desvio_padrao
from 
    glp_precos
group by 
    date_part('year',data_coleta), 
    date_part('month', data_coleta), 
    estado
order by
    ano,
    mes asc


-- por algum motivo uma mesma bandeira possui dois nomes
-- supergasbras e supergasbras energia, corrigindo isso:
update glp_precos
set bandeira = 'SUPERGASBRAS ENERGIA'
where bandeira = 'SUPERGASBRAS'

-- 2.1: Similar à discrepância do numero de entradas por estado,
-- existe uma concentração na quantidade de medições entre
-- poucas bandeiras, portanto deve-se ter cautela ao interpretar
-- os resultados de bandeiras com poucos registros
select
    bandeira,
    count(1) as freq_absoluta,
    round(100.0 * count(1) / (select count(1) from glp_precos), 2) as freq_relativa,
    round(avg(valor_venda), 2) as preco_medio,
    round(stddev(valor_venda), 2) as desvio_padrao
from
    glp_precos
group by bandeira
order by count(1) desc

-- 2.2: considerando apenas bandeiras com mais de 20 mil entradas 
-- como sendo significativas, obtemos a seguinte série histórica:
select 
    date_part('year',data_coleta) as ano,
    date_part('month',data_coleta) as mes,
    bandeira, 
    count(1) as freq_absoluta, 
    round(avg(valor_venda), 2) as preco_medio, 
    round(stddev(valor_venda), 2) as desvio_padrao
from 
    glp_precos
group by 
    date_part('year',data_coleta), 
    date_part('month', data_coleta),
    bandeira
having 
    bandeira in ('BRANCA', 'SUPERGASBRAS ENERGIA', 'ULTRAGAZ', 'NACIONAL GÁS BUTANO', 'LIQUIGÁS', 'BAHIANA', 'COPA ENERGIA', 'FOGAS')
order by 
    ano,
    mes ASC