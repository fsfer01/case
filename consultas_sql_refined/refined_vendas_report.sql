-- TABELA AGRUPADA COM O MÁXIMO POSSÍVEL DE GRANULARIDADE. É ATRAVÉS DELA QUE SERÁ POSSÌVEL REALIZAR ÀS ANÁLISES E CRIAÇÃO DE DASHBOARDS.

SELECT
-- GRANULARIDADE
data_do_pedido,
mes_do_pedido,
ano_do_pedido,
categoria_do_produto,
marca_do_produto,
nome_do_produto,

-- MÉTRICAS TOTAL
--COUNT(DISTINCT id_do_pedido) 												  	AS qtd_de_pedidos,
SUM(quantidade_do_produto) 													  	AS qtd_de_itens_vendidos,
AVG(valor_do_produto) 														  	AS valor_medio_do_produto_vendidos,
SUM(valor_total)   		                                        				AS valor_total_bruto_pedidos,

-- METRICAS DE PEDIDOS APROVADOS
--COUNT(DISTINCT CASE WHEN flag_cancelado <> 'S' THEN id_do_pedido ELSE NULL END) AS qtd_de_pedidos_aprovados,
SUM(CASE WHEN flag_cancelado <> 'S' THEN quantidade_do_produto ELSE 0 END)      AS qtd_de_itens_vendidos_aprovado,
AVG(CASE WHEN flag_cancelado <> 'S' THEN valor_do_produto ELSE 0.00 END)        AS valor_medio_do_produto_vendidos_aprovados,
SUM(CASE WHEN flag_cancelado <> 'S' THEN valor_total ELSE 0.00 END)   			AS valor_total_bruto_pedidos_aprovados,

-- METRICAS DE PEDIDOS CANCELADOS
--COUNT(DISTINCT CASE WHEN flag_cancelado = 'S' THEN id_do_pedido ELSE NULL END)  AS qtd_de_pedidos_cancelados,
SUM(CASE WHEN flag_cancelado = 'S' THEN quantidade_do_produto ELSE 0 END)       AS qtd_de_itens_vendidos_cancelados,
AVG(CASE WHEN flag_cancelado = 'S' THEN valor_do_produto ELSE 0.00  END)    	AS valor_medio_do_produto_vendidos_cancelados,
SUM(CASE WHEN flag_cancelado = 'S' THEN valor_total ELSE 0.00 END)   		    AS valor_total_bruto_pedidos_cancelados

FROM 'trusted.vw_pedidos_e_itens_analitico' 

GROUP BY 
    data_do_pedido,
    mes_do_pedido,
    ano_do_pedido,
    categoria_do_produto,
    marca_do_produto,
    nome_do_produto

<br>- data_do_pedido <br>- mes_do_pedido <br>- ano_do_pedido <br>- categoria_do_produto <br>- marca_do_produto <br>- nome_do_produto