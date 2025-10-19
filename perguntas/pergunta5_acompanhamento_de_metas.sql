-- OBS: NO SQLITE, NÃO TEMOS ALGUMAS FUNÇõES QUE DEIXARIA O CÓDIGO MAIS LEGÍVEL. ENTÃO, QUAL É A LÓGICA AQUI:
-- DIARIZO A META PELA QUANTIDADE DE DIAS, TIPO: valor / LAST_DAY(data)

WITH meta_diarizada_por_marca AS (

  SELECT
  d.data                                                                                                                          AS data,
  marca.nome                                                                                                                      AS marca,
  ROUND(m.vlr_meta / CAST(strftime('%d', date(m.ano || '-' || printf('%02d', m.mes) || '-01', '+1 month', '-1 day')) AS REAL), 2) AS vlr_meta_diaria

  FROM 'trusted.meta'       AS m
  INNER JOIN 'trusted.data' AS d      ON d.ano = m.ano AND d.mes = m.mes
  LEFT JOIN 'trusted.marca' AS marca  ON  m.id_marca = marca.id
  
  ORDER BY m.id_marca, d.data
),

realizado_diarizado_por_marca AS (
  SELECT
  data_do_pedido                                          	AS data,
  ano_do_pedido                                           	AS ano_do_pedido,
  mes_do_pedido                                           	AS mes_do_pedido,
  marca_do_produto                                        	AS marca,
  SUM(COALESCE(valor_total_bruto_pedidos_aprovados,0.00))	AS valor_total_bruto_pedidos_aprovados_por_marca

  FROM 'refined.vendas_report_produtos' 

  GROUP BY 
  data_do_pedido,
  marca_do_produto
),

final AS (

  SELECT
  realizado_diarizado_por_marca.data,
  realizado_diarizado_por_marca.ano_do_pedido,
  realizado_diarizado_por_marca.mes_do_pedido,
  realizado_diarizado_por_marca.marca,
  meta_diarizada_por_marca.vlr_meta_diaria                                    AS meta,
  realizado_diarizado_por_marca.valor_total_bruto_pedidos_aprovados_por_marca AS realizado,
  ROUND(1.0 * realizado_diarizado_por_marca.valor_total_bruto_pedidos_aprovados_por_marca 
    / NULLIF(meta_diarizada_por_marca.vlr_meta_diaria,0) , 2)                 AS atingimento


  FROM realizado_diarizado_por_marca
  LEFT JOIN meta_diarizada_por_marca  ON realizado_diarizado_por_marca.data = meta_diarizada_por_marca.data
                                      AND realizado_diarizado_por_marca.marca = meta_diarizada_por_marca.marca


)

SELECT
ano_do_pedido,
mes_do_pedido,
marca,
SUM(meta)                                               AS meta,
SUM(realizado)                                          AS realizado,
ROUND(1.0 * SUM(realizado) / NULLIF(SUM(meta),0) , 2)   AS atingimento

FROM final

GROUP BY 
  ano_do_pedido,
  mes_do_pedido,
  marca
  
 ORDER BY 1 ASC, 2 ASC, 3 ASC 
