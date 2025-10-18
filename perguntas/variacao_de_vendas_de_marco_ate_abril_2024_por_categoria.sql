WITH qtd_de_itens_e_valor_total_por_categoria AS (    
    SELECT
    categoria_do_produto,
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 3 THEN quantidade_do_produto ELSE 0 END) AS itens_total_2024_03,
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 4 THEN quantidade_do_produto ELSE 0 END) AS itens_total_2024_04,    
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 3 THEN valor_total ELSE 0 END)           AS valor_total_2024_03,
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 4 THEN valor_total ELSE 0 END)           AS valor_total_2024_04
    FROM "trusted"."vw_pedidos_e_itens_analitico"
    
    WHERE 1=1
    AND flag_cancelado <> 'S'
    AND ano_do_pedido = 2024
    AND mes_do_pedido IN (3,4)
    
    GROUP BY categoria_do_produto
)

SELECT
categoria_do_produto,
valor_total_2024_03                                                     AS faturamento_marco_2024,
valor_total_2024_04                                                     AS faturamento_abril_2024,
ROUND(COALESCE(((valor_total_2024_04 - valor_total_2024_03) * 100.0 
    / NULLIF(valor_total_2024_03, 0)), 0), 2)                           AS variacao_percentual_faturamento,

itens_total_2024_03                                                     AS itens_vendidos_marco_2024,
itens_total_2024_04                                                     AS itens_vendidos_abril_2024,
    ROUND(COALESCE(((itens_total_2024_04 - itens_total_2024_03) * 100.0 
    / NULLIF(itens_total_2024_03, 0)), 0),2)                            AS variacao_percentual_itens_vendidos

FROM qtd_de_itens_e_valor_total_por_categoria