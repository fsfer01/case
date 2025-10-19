# Proposta de modelagem / Pergunta 3

>Ao terminar de conversar com os stakeholders, você percebe que o modelo de dados atual pode ser melhorado para facilitar a >geração dos dados que os stakeholders pediram e até mesmo possibilitar a disponibilização de outros dados no futuro. >Analisando o modelo atual, identifique e monte uma proposta com possíveis melhorias nele. Fique à vontade para adicionar ou >remover tabelas e colunas do modelo.

Pensando em um produto que pode atender mais de um requísito, o objetivo é:
1. Ter a maior granularidade possível (EVITANDO NÍVEL TRANSACIONAL / ID_PEDIDO))
2. Métricas já prontas para consumo, pensando que o cliente deve apenas consumir o dado e agrupar na forma que desejar.

Com isso, vamos criar duas tabelas:
![54593f28-114d-4ebf-9c02-7849a2391337](https://github.com/user-attachments/assets/4c57335e-f5a4-43e0-8d28-00b697176fe0)


| TABELA | DESCRIÇÃO |
| --- | --- |
| refined.report_vendas_nivel_itens | Essa tabela foi desenvovida na maior granularidade possível, sendo:<br>- data_do_pedido <br>- mes_do_pedido <br>- ano_do_pedido <br>- categoria_do_produto <br>- marca_do_produto <br>- nome_do_produto <br> Como essa tabela está no nível de item do pedido, nela, não conseguimos ver informações como: qtd_de_pedido. Pois um pedido pode ter mais de dois item, e isso poderia gerar confusão.|
| refined.report_vendas_nivel_pedidos | Essa tabela foi desenvolvida na menor granularidade, sendo: <br>- data_do_pedido <br>- mes_do_pedido <br>- ano_do_pedido <br> Após essa granularidade, teremos as métricas já calculadas, que seria:   |



# Pergunta 1
>Pensando em identificar os produtos que estão sendo os best sellers, todos os
>stakeholders entenderam que vão precisar de uma lista com o top 10 produtos
>mais vendidos, de acordo com a quantidade de itens vendidos, por mês e pela
>região de entrega do pedido.

<details>
  <summary>top_10_produtos_mais_vendidos.sql</summary>

  
  Código SQL aqui: https://github.com/fsfer01/case/blob/main/perguntas/top_10_produtos_mais_vendidos.sql
  <img width="1258" height="628" alt="image" src="https://github.com/fsfer01/case/blob/main/imgs/pergunta1.jpg" />

  ```sql
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
```
</details>


# Pergunta 2
>O stakeholder da área de importação, já está planejando a compra dos produtos
>da categoria de Corrida para o próximo ano e quer saber qual foi a variação de
>todas as categorias, que tivemos nas vendas de Abril do ano de 2024 comparado
>com as vendas do mês anterior, por categoria

<details>
  <summary>variacao_de_vendas_de_marco_ate_abril_2024_por_categoria.sql</summary>

  
  Código SQL aqui: https://github.com/fsfer01/case/blob/main/perguntas/variacao_de_vendas_de_marco_ate_abril_2024_por_categoria.sql
  <img width="1258" height="628" alt="image" src="https://github.com/fsfer01/case/blob/main/imgs/pergunta2.jpg" />


  ```sql
WITH qtd_de_itens_e_valor_total_por_categoria AS (    
    SELECT
    categoria_do_produto,
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 3 THEN quantidade_do_produto ELSE 0 END) AS itens_total_2024_03,
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 4 THEN quantidade_do_produto ELSE 0 END) AS itens_total_2024_04,    
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 3 THEN valor_total ELSE 0 END)           AS valor_total_2024_03,
    SUM(CASE WHEN ano_do_pedido = 2024 AND mes_do_pedido = 4 THEN valor_total ELSE 0 END)           AS valor_total_2024_04
    FROM `trusted.vw_pedidos_e_itens_analitico`
    
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
```
</details>


# Pergunta 4
>No Grupo xxx, seguimos as diretrizes da LGPD e tomamos muito cuidado para não
>infringirmos a lei. Sabendo disso, suponha que você tenha a necessidade de
>incluir as identificações dos clientes, junto com as informações de pedido. Como
>você faria isso? Fique à vontade para incluir nas alterações de modelo proposto na
>questão 3.

Eu pensaria na criação de uma dimensão de cliente. Ela teria informações do cliente, todas mascaradas. E para ter acesso, seria necessário um ticket, e após aprovação do ticket, o usuário seria incluído em um grupo de acesso que teria acesso a determinadas colunas. Essa dimensão não seria usada em modelagens. Ela seria separada, e cada necessidade seria entendida antes da aprovação. Após aprovação, o cliente teria autonimia de enriquecer as informações através do JOIN.

# Pergunta 5
> O Grupo xxx é uma empresa de varejo e com a ajuda de dados, estamos sempre
> buscando encontrar melhorias e pensando em novas trilhas para desbravar.
> Sabendo disso e utilizando o modelo de dados que você gerou no passo anterior,
> identifique métricas (KPI’s) que você criaria para conseguir apoiar as tomadas de
> decisões e a identificação de oportunidades para a empresa. Fique à vontade para


<details>
  <summary>pergunta5_conversao_.sql</summary>

  
  Código SQL aqui: https://github.com/fsfer01/case/blob/main/perguntas/pergunta5_conversao_.sql
  <img width="1258" height="628" alt="image" src="https://github.com/fsfer01/case/blob/main/imgs/pergunta2.jpg" />


  ```sql
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
```
</details>


