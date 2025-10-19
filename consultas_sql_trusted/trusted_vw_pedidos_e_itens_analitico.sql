-- PENSANDO EM UMA VIEW ANALÍTICA JÁ NORMALIZADA, A IDEIA É ESSA MODELAGEM SER A PRINCIPAL PARA OS PRÓXIMOS PASSOS, SEJA USANDO ELA PARA UMA ANÁLISE TRANSACIONAL, OU PARA USO DE TABELAS NA REFINED

DROP VIEW IF EXISTS `trusted.vw_pedidos_e_itens_analitico`;

CREATE VIEW `trusted.vw_pedidos_e_itens_analitico` AS 
WITH normalizacao AS (

  SELECT
  pedido.data                                            AS data_do_pedido,
  dim_date.mes                                           AS mes_do_pedido,
  dim_date.ano                                           AS ano_do_pedido,
  pedido.id                                              AS id_do_pedido,
  pedido_item.flg_cancelado                              AS flag_cancelado,
  pedido.sgl_uf_entrega                                  AS uf_entrega,
  marca.nome                                             AS marca_do_produto,
  produto.nome                                           AS nome_do_produto,
  produto.categoria                                      AS categoria_do_produto, 
  pedido_item.qtd_produto                                AS quantidade_do_produto,
  pedido_item.vlr_unitario                               AS valor_do_produto,
  (pedido_item.qtd_produto * pedido_item.vlr_unitario)   AS valor_total
  
  FROM 'trusted.pedido'                 AS pedido    
  LEFT JOIN 'trusted.pedido_item'       AS pedido_item   ON pedido_item.id_pedido = pedido.id
  LEFT JOIN 'trusted.produto'           AS produto       ON pedido_item.id_produto = produto.id
  LEFT JOIN 'trusted.marca'             AS marca         ON produto.id_marca = marca.id
  LEFT JOIN 'trusted.data'              AS dim_date      ON pedido.data = dim_date.data
),

status_pedido AS (
 	SELECT
    id_do_pedido,
    COUNT(*)                                                AS total_itens,
    SUM(CASE WHEN flag_cancelado = 'S' THEN 1 ELSE 0 END)   AS itens_cancelados,
    SUM(CASE WHEN flag_cancelado = 'N' THEN 1 ELSE 0 END)   AS itens_aprovados,
    SUM(CASE WHEN flag_cancelado IS NULL THEN 1 ELSE 0 END) AS itens_pendentes,
    CASE
      WHEN SUM(CASE WHEN flag_cancelado = 'N' THEN 1 ELSE 0 END) = COUNT(*)   THEN 'PEDIDO INTEIRO APROVADO'
      WHEN SUM(CASE WHEN flag_cancelado = 'S' THEN 1 ELSE 0 END) = COUNT(*)   THEN 'PEDIDO INTEIRO CANCELADO'
      WHEN SUM(CASE WHEN flag_cancelado = 'S' THEN 1 ELSE 0 END) > 0 
        AND SUM(CASE WHEN flag_cancelado = 'N' THEN 1 ELSE 0 END) > 0         THEN 'PEDIDO COM ITENS APROVADOS E CANCELADOS'
      WHEN SUM(CASE WHEN flag_cancelado IS NULL THEN 1 ELSE 0 END) = COUNT(*) THEN 'PEDIDO INTEIRO PENDENTE'
      ELSE 'ANALISAR'
    END                                                      AS status_pedido
  
  FROM normalizacao
  GROUP BY id_do_pedido
)

SELECT
pedidos.data_do_pedido,
pedidos.mes_do_pedido,
pedidos.ano_do_pedido,
pedidos.id_do_pedido,
status_pedido.status_pedido,
pedidos.flag_cancelado,
pedidos.uf_entrega,
pedidos.marca_do_produto,
pedidos.nome_do_produto,
pedidos.categoria_do_produto,
pedidos.quantidade_do_produto,
pedidos.valor_do_produto,
pedidos.valor_total

FROM normalizacao AS pedidos
LEFT JOIN status_pedido ON pedidos.id_do_pedido = status_pedido.id_do_pedido;
