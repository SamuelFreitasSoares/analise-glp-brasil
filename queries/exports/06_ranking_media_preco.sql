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
        hp.media_nacional,
        case
            when pm.preco_medio > hp.media_nacional then 1
            else 0 
        end as mais_caro
    from 
        hist_precos as hp
        inner join preco_medio_estados as pm
            on hp.ano = pm.ano and hp.mes = pm.mes
)
select
    estado,
    count(1) as qtd_meses,
    sum(mais_caro) as qtd_meses_caros,
    round(100.0*sum(mais_caro) / count(1), 2) as perc_meses_caros,
    rank() over (order by sum(mais_caro) desc) as ranking_mais_caro
from comparacao_estados
group by estado