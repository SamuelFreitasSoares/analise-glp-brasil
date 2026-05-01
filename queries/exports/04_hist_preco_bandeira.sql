select 
    date_part('year',data_coleta) as ano,
    date_part('month',data_coleta) as mes,
    bandeira, 
    count(1) as freq_absoluta, 
    round(avg(valor_venda), 2) as preco_medio, 
    round(stddev(valor_venda), 2) as desvio_padrao
from 
    hist_glp.glp_precos
group by 
    date_part('year',data_coleta), 
    date_part('month', data_coleta),
    bandeira
having 
    bandeira in ('BRANCA', 'SUPERGASBRAS ENERGIA', 'ULTRAGAZ', 'NACIONAL GÁS BUTANO', 'LIQUIGÁS', 'BAHIANA', 'COPA ENERGIA', 'FOGAS')
order by 
    ano,
    mes ASC 