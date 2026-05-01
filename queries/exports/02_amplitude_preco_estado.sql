select 
    date_part('year',data_coleta) as ano,
    date_part('month',data_coleta) as mes,
    estado,
    round(stddev(valor_venda), 2) as desvio_padrao
from 
    hist_glp.glp_precos
group by 
    date_part('year',data_coleta), 
    date_part('month', data_coleta), 
    estado
order by
    ano,
    mes,
    estado