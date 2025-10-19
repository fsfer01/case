WITH base_agrupada AS (

  SELECT 
  data_do_pedido,
  -- VISÃO DE PEDIDOS
  SUM(qtd_de_pedidos_unicos_vendidos)                                                                                 AS qtd_total_pedidos_realizados,
  SUM(qtd_de_pedidos_unicos_vendidos_aprovados )                                                                      AS qtd_total_pedidos_aprovados,
  SUM(qtd_de_pedidos_unicos_vendidos_misto_cancelado + qtd_de_pedidos_unicos_vendidos_cancelados)                     AS qtd_total_pedidos_cancelados,
  -- VISÃO DE FATURAMENTO
  SUM(COALESCE(valor_total_bruto_pedidos,0.00))                                                                       AS valor_total_pedidos_realizados,
  SUM(COALESCE(valor_total_bruto_pedidos_aprovados,0.00))                                                             AS valor_total_pedidos_aprovados,
  SUM(COALESCE(valor_total_bruto_pedidos_misto_cancelado,0.00) + COALESCE(valor_total_bruto_pedidos_cancelados,0.00)) AS valor_total_pedidos_cancelados,
  -- VISÃO DE ITENS
  SUM(COALESCE(qtd_de_itens_vendidos,0.00))                                                                           AS qtd_total_itens_vendidos,
  SUM(COALESCE(qtd_de_itens_vendidos_aprovado,0.00))                                                                  AS qtd_total_itens_vendidos_aprovados,
  SUM(COALESCE(qtd_de_itens_vendidos_misto_cancelado,0.00) + COALESCE(qtd_de_itens_vendidos_cancelados,0.00))         AS qtd_total_itens_vendidos_cancelados
  
  FROM 'refined.vendas_report_pedidos'
  
  GROUP BY  data_do_pedido
)

SELECT
data_do_pedido,

-- PEDIDOS
qtd_total_pedidos_realizados,
qtd_total_pedidos_aprovados,
qtd_total_pedidos_cancelados,
ROUND(1.0 * qtd_total_pedidos_aprovados / NULLIF(qtd_total_pedidos_realizados,0) , 2)     AS conversao_pedidos,
-- VALOR
valor_total_pedidos_realizados,
valor_total_pedidos_aprovados,
valor_total_pedidos_cancelados,
ROUND(1.0 * valor_total_pedidos_aprovados / NULLIF(valor_total_pedidos_realizados,0) , 2) AS conversao_valor,
-- ITENS
qtd_total_itens_vendidos,
qtd_total_itens_vendidos_aprovados,
qtd_total_itens_vendidos_cancelados,
ROUND(1.0 * qtd_total_itens_vendidos_aprovados / NULLIF(qtd_total_itens_vendidos,0) , 2)  AS conversao_itens

FROM base_agrupada
ORDER BY data_do_pedido ASC;