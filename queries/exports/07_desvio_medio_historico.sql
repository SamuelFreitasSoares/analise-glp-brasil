with hist_precos as (
    select
        date_part('year', data_coleta) as ano,
        date_part('month', data_coleta) as mes,
        round(avg(valor_venda), 2) as media_nacional
    from
        hist_glp.glp_precos
    group by 
        ano,
        mes
), preco_medio_estados as (
    select
        date_part('year', data_coleta) as ano,
        date_part('month', data_coleta) as mes,
        estado,
        round(avg(valor_venda), 2) as preco_medio
    from
        hist_glp.glp_precos
    group by 
        date_part('year',data_coleta), 
        date_part('month', data_coleta),
        estado
), comparacao_estados as (
    select
        hp.ano,
        hp.mes,
        pm.estado,
        pm.preco_medio,
        hp.media_nacional
    from 
        hist_precos as hp
        inner join preco_medio_estados as pm
            on hp.ano = pm.ano and hp.mes = pm.mes
), hist_completo_precos as (
    select 
        ano,
        mes,
        estado,
        preco_medio,
        media_nacional,
        preco_medio - media_nacional as diferenca_de_preco
    from 
        comparacao_estados
)
select
    estado,
    round(avg(diferenca_de_preco), 2) as desvio_medio_hist,
    rank() over (order by avg(diferenca_de_preco) desc) as ranking
from 
    hist_completo_precos
group by
    estado