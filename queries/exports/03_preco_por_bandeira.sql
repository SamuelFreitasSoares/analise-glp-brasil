select
    bandeira,
    count(1) as freq_absoluta,
    round(100.0 * count(1) / (select count(1) from hist_glp.glp_precos), 2) as freq_relativa,
    round(avg(valor_venda), 2) as preco_medio,
    round(stddev(valor_venda), 2) as desvio_padrao
from
    hist_glp.glp_precos
group by bandeira
order by count(1) desc