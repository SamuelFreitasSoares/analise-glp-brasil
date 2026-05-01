-- Perguntas:
-- 1) qual a variação percentual do preço médio nacional mes a mes?
-- 2) quais foram os meses com maior alta e maior queda de preço no período?

-- Visão inicial dos dados
select *
from glp_precos
limit 5

-- Para facilitar a construção e interpretação da consulta, 
-- resolvi criar tabelas temporárias que serão reutilizadas 
-- nas queries
create temp table if not exists hist_precos as (
    select
        date_part('year', data_coleta) as ano,
        date_part('month', data_coleta) as mes,
        round(avg(valor_venda), 2) as media_nacional
    from
        glp_precos
    group by 
        ano,
        mes
)

create temp table if not exists var_mes_a_mes as (
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

-- 1: Analisando a variação percentual MoM do preço médio nacional
select * from var_mes_a_mes

-- 2.1: Selecionando o top 3 onde a variação mensal é maior que 0.01%
select *
from var_mes_a_mes
where var_perc_mes_a_mes is not null and var_perc_mes_a_mes > 0.01

-- 2.2: Selecionando o bottom 3 onde a variação mensal é menor que -0.01%
select *
from var_mes_a_mes
where var_perc_mes_a_mes is not null and var_perc_mes_a_mes < -0.01