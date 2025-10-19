-- PENSANDO EM UMA VIEW ANALÍTICA JÁ NORMALIZADA, A IDEIA É ESSA MODELAGEM SER A PRINCIPAL PARA OS PRÓXIMOS PASSOS.

DROP VIEW IF EXISTS `trusted.vw_pedidos_e_itens_analitico`;

CREATE VIEW `trusted.vw_pedidos_e_itens_analitico` AS 

  SELECT
  pedido.data 	     	                            	      AS data_do_pedido,
  dim_date.mes 	     	                                    AS mes_do_pedido,
  dim_date.ano 	     	                                    AS ano_do_pedido,
  pedido.id 	     	                                      AS id_do_pedido,
  pedido_item.flg_cancelado                               AS flag_cancelado,
  pedido.sgl_uf_entrega 	                                AS uf_entrega,
  marca.nome 			                                        AS marca_do_produto, 
  produto.nome 	 	                                        AS nome_do_produto,  
  produto.categoria 	 	                                  AS categoria_do_produto, 
  pedido_item.qtd_produto 				                        AS quantidade_do_produto,
  pedido_item.vlr_unitario 				                        AS valor_do_produto,
  (pedido_item.qtd_produto * pedido_item.vlr_unitario)    AS valor_total
  
  FROM 'trusted.pedido' 			        AS pedido    
  LEFT JOIN 'trusted.pedido_item' 	  AS pedido_item 	ON pedido_item.id_pedido = pedido.id
  LEFT JOIN 'trusted.produto'    	    AS produto 		  ON pedido_item.id_produto = produto.id
  LEFT JOIN 'trusted.marca'      	    AS marca 		    ON produto.id_marca = marca.id
  LEFT JOIN 'trusted.data'       	    AS dim_date 	  ON pedido.data = dim_date.data
; 
