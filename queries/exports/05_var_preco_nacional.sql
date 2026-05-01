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
), var_mes_a_mes as (
    select
        ano,
        mes,
        media_nacional,
        round((1-((lag(media_nacional) over (order by ano,mes)) / media_nacional)), 3) as var_perc_mes_a_mes
    from 
        hist_precos
    order by 
        ano,
        mes
)
select * from var_mes_a_mes