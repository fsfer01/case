--Pensando em identificar os produtos que estão sendo os best sellers, todos os
--stakeholders entenderam que vão precisar de uma lista com o top 10 produtos
--mais vendidos, de acordo com a quantidade de itens vendidos, por mês e pela
--região de entrega do pedido.

  WITH produtos_mais_vendidos_por_mes_e_uf_de_entrega AS (

  SELECT
  ano_do_pedido,
  mes_do_pedido,
  nome_do_produto,
  uf_entrega,
  SUM(quantidade_do_produto) AS qtd_de_itens_vendidos,
  ROW_NUMBER() OVER (
      PARTITION BY ano_do_pedido, mes_do_pedido, uf_entrega
      ORDER BY SUM(quantidade_do_produto) DESC
  ) AS ranking

  FROM `trusted.vw_pedidos_e_itens_analitico`

  WHERE 1=1
  AND flag_cancelado <> 'S'

  GROUP BY 
    ano_do_pedido,
    mes_do_pedido,
    nome_do_produto,
    uf_entrega
  
)

SELECT
ano_do_pedido,
mes_do_pedido,
nome_do_produto,
uf_entrega,
qtd_de_itens_vendidos,
ranking


FROM produtos_mais_vendidos_por_mes_e_uf_de_entrega
WHERE 1=1
AND ranking <= 10
  
ORDER BY ano_do_pedido ASC, mes_do_pedido ASC, uf_entrega ASC, qtd_de_itens_vendidos DESC, ranking ASC
