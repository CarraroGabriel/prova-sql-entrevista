/* Esquema do Banco de Dados:

O banco de dados possui as seguintes tabelas: */ 

    -- EMPRESA (id_empresa, razao_social, inativo)
    -- PRODUTOS (id_produto, descricao, inativo)
    -- CONFIG_PRECO_PRODUTO (id_config_preco_produto, id_vendedor, id_empresa, id_produto, preco_minimo, preco_maximo)
    -- VENDEDORES (id_vendedor, nome, cargo, salario, data_admissao, inativo)
    -- CLIENTES (id_cliente, razao_social, data_cadastro, id_vendedor, id_empresa, inativo)
    -- PEDIDO (id_pedido, id_empresa, id_cliente, valor_total, data_emissao, situacao)
    -- ITENS_PEDIDO (id_item_pedido, id_pedido, id_produto, preco_praticado, quantidade)



/* Tarefas: 

Consultas Básicas:
Escreva consultas SQL para obter as seguintes informações: */

    -- 1) Lista de funcionários ordenando pelo salário decrescente.

select * from VENDEDORES order by salario DESC;

    -- 2) Lista de pedidos de vendas ordenado por data de emissão.

select * from PEDIDO order by data_emissao;

    -- 3) Valor de faturamento por cliente.

select C.id_cliente, C.razao_social AS cliente, SUM(P.valor_total) AS faturamento 
                                    from CLIENTES C
                                    JOIN PEDIDO P ON P.id_cliente = C.id_cliente
                                    group by C.id_cliente, C.razao_social
                                    order by faturamento DESC;

    -- 4) Valor de faturamento por empresa.

select C.id_empresa, E.razao_social AS empresa, SUM(P.valor_total) AS faturamento
                                    from EMPRESA E
                                    JOIN PEDIDO P ON P.id_cliente = C.id_cliente
                                    JOIN CLIENTES C ON C.id_empresa = E.id_empresa
                                    group by C.id_empresa, e.razao_social
                                    order by faturamento DESC;

    -- 5) Valor de faturamento por vendedor.

select V.nome, V.id_vendedor AS vendedor, SUM(P.valor_total) AS faturamento
                             from VENDEDORES V
                             JOIN CLIENTES C ON C.id_vendedor = V.id_vendedor
                             JOIN PEDIDO P ON P.id_cliente = C.id_cliente
                             group by V.nome, V.id_vendedor
                             order by faturamento DESC;

/* Consultas de Junção:
Escreva consultas SQL para obter as seguintes informações usando junções:

Unindo a listagem de produtos com a listagem de clientes, procure o último preço praticado nesse cliente com esse produto, formule o preço base do produto dentro da coluna chamada preco_base no seu select, conforme a seguinte regra:
O preço base do produto deve obedecer a configuração de preço da tabela CONFIG_PRECO_PRODUTO.
Caso as junções não retornem o último preço praticado, utilize o menor da configuração de preço do produto.
Nesta mesma consulta, os seguintes campos deverão estar contidos: */

    -- Id do produto em questão;

    -- Descrição do produto;

    -- Id do cliente do pedido;

    -- Razão social do cliente;

    -- Id da empresa do pedido;

    -- Razão social da empresa;

    -- Id do vendedor do pedido;

    -- Nome do vendedor;

    -- Preço mínimo e máximo da configuração de preço;

    -- Preço base do produto conforme a regra. 

select P.id_produto, P.descricao, 
       C.id_cliente, C.razao_social AS cliente_razao_social, 
       E.id_empresa, E.razao_social AS empresa_razao_social, 
       V.id_vendedor, V.nome AS vendedor_nome, 
       CP.preco_minimo, CP.preco_maximo, COALESCE(ip.preco_praticado, cp.preco_minimo) AS preco_base
       from PRODUTOS P 
       JOIN ITENS_PEDIDO IP ON P.id_produto = IP.id_produto
       JOIN PEDIDO PD ON IP.id_pedido = PD.id_pedido
       JOIN CLIENTES C ON PD.id_cliente = C.id_cliente
       JOIN EMPRESA E ON PD.id_empresa = E.id_empresa
       JOIN VENDEDORES V ON C.id_vendedor = V.id_vendedor
       JOIN CONFIG_PRECO_PRODUTO CP ON P.id_produto = CPP.id_produto AND C.id_empresa = CPP.id_empresa AND V.id_vendedor = CPP.id_vendedor
       order by P.id_produto, C.id_cliente;