-- Perguntas: 
-- 1) Ranking de estados com preço consistentemente acima da média
-- 2) Desvio do preço por estado em relação à média nacional mês a mês

-- 1: Utilizando CTEs e Window Function para criar um ranking com 
-- os estados em que a média do preço do GLP é maior que a média nacional
with hist_precos as (
    select
        date_part('year', data_coleta) as ano,
        date_part('month', data_coleta) as mes,
        round(avg(valor_venda), 2) as media_nacional
    from
        glp_precos
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
        glp_precos
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


-- 2: desvio médio histórico do preco em relação à média nacional
with hist_precos as (
    select
        date_part('year', data_coleta) as ano,
        date_part('month', data_coleta) as mes,
        round(avg(valor_venda), 2) as media_nacional
    from
        glp_precos
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
        glp_precos
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