create schema if not exists hist_glp;
set search_path to hist_glp;

create Table if not exists glp_precos(
    regiao VARCHAR(2),
    estado VARCHAR(2),
    municipio VARCHAR(100),
    revenda VARCHAR(150),
    cnpj VARCHAR(20),
    logradouro VARCHAR(150),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cep VARCHAR(10),
    produto VARCHAR(20),
    data_coleta date,
    valor_venda NUMERIC(8,2),
    unidade_medida VARCHAR(20),
    bandeira VARCHAR(100)
)

