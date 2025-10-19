-- TABELA AGRUPADA COM O MÁXIMO POSSÍVEL DE GRANULARIDADE.

DROP TABLE IF EXISTS `refined.vendas_report_produtos`;

CREATE TABLE `refined.vendas_report_produtos` AS 

SELECT
-- GRANULARIDADE
data_do_pedido,
mes_do_pedido,
ano_do_pedido,
categoria_do_produto,
marca_do_produto,
nome_do_produto,

-- MÉTRICAS TOTAL
SUM(quantidade_do_produto) 													  	                                                    AS qtd_de_itens_vendidos,
AVG(valor_do_produto) 														  	                                                    AS valor_medio_do_produto_vendidos,
SUM(valor_total)   		                                        				                                                    AS valor_total_bruto_pedidos,

-- METRICAS DE PEDIDOS APROVADOS / STATUS "PEDIDO INTEIRO APROVADO"
SUM(CASE WHEN status_pedido = 'PEDIDO INTEIRO APROVADO' THEN quantidade_do_produto END)                                             AS qtd_de_itens_vendidos_aprovado,
AVG(CASE WHEN status_pedido = 'PEDIDO INTEIRO APROVADO' THEN valor_do_produto END)        	                                        AS valor_medio_do_produto_vendidos_aprovados,
SUM(CASE WHEN status_pedido = 'PEDIDO INTEIRO APROVADO' THEN valor_total END)   			                                        AS valor_total_bruto_pedidos_aprovados,

-- METRICAS DE PEDIDOS MISTOS / COM ITENS APROVADOS E CANCELADOS - VISAO APROVADO
SUM(CASE WHEN status_pedido = 'PEDIDO COM ITENS APROVADOS E CANCELADOS' AND flag_cancelado = 'N' THEN quantidade_do_produto END)    AS qtd_de_itens_vendidos_misto_aprovado,
AVG(CASE WHEN status_pedido = 'PEDIDO COM ITENS APROVADOS E CANCELADOS' AND flag_cancelado = 'N' THEN valor_do_produto END)    		AS valor_medio_do_produto_vendidos_misto_aprovado,
SUM(CASE WHEN status_pedido = 'PEDIDO COM ITENS APROVADOS E CANCELADOS' AND flag_cancelado = 'N' THEN valor_total END)   		    AS valor_total_bruto_pedidos_misto_aprovado,

-- METRICAS DE PEDIDOS MISTOS / COM ITENS APROVADOS E CANCELADOS - VISAO CANCELADO
SUM(CASE WHEN status_pedido = 'PEDIDO COM ITENS APROVADOS E CANCELADOS' AND flag_cancelado = 'S' THEN quantidade_do_produto END)    AS qtd_de_itens_vendidos_misto_cancelado,
AVG(CASE WHEN status_pedido = 'PEDIDO COM ITENS APROVADOS E CANCELADOS' AND flag_cancelado = 'S' THEN valor_do_produto END)    		AS valor_medio_do_produto_vendidos_misto_cancelado,
SUM(CASE WHEN status_pedido = 'PEDIDO COM ITENS APROVADOS E CANCELADOS' AND flag_cancelado = 'S' THEN valor_total END)   		    AS valor_total_bruto_pedidos_misto_cancelado,

-- METRICAS DE PEDIDOS CANCELADOS
SUM(CASE WHEN status_pedido = 'PEDIDO INTEIRO CANCELADO' THEN quantidade_do_produto END)                                            AS qtd_de_itens_vendidos_cancelados,
AVG(CASE WHEN status_pedido = 'PEDIDO INTEIRO CANCELADO' THEN valor_do_produto END)    		                                        AS valor_medio_do_produto_vendidos_cancelados,
SUM(CASE WHEN status_pedido = 'PEDIDO INTEIRO CANCELADO' THEN valor_total END)   		                                            AS valor_total_bruto_pedidos_cancelados

FROM 'trusted.vw_pedidos_e_itens_analitico' 

GROUP BY 
    data_do_pedido,
    mes_do_pedido,
    ano_do_pedido,
    categoria_do_produto,
    marca_do_produto,
    nome_do_produto
;
