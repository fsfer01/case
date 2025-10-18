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
| refined.report_vendas_nivel_pedidos | Nome das colunas, seu tipo e sua descrição |



# Pergunta 1
>Pensando em identificar os produtos que estão sendo os best sellers, todos os
>stakeholders entenderam que vão precisar de uma lista com o top 10 produtos
>mais vendidos, de acordo com a quantidade de itens vendidos, por mês e pela
>região de entrega do pedido.


# Pergunta 2
>Pensando em identificar os produtos que estão sendo os best sellers, todos os
>stakeholders entenderam que vão precisar de uma lista com o top 10 produtos
>mais vendidos, de acordo com a quantidade de itens vendidos, por mês e pela
>região de entrega do pedido.

# Pergunta 3
>Pensando em identificar os produtos que estão sendo os best sellers, todos os
>stakeholders entenderam que vão precisar de uma lista com o top 10 produtos
>mais vendidos, de acordo com a quantidade de itens vendidos, por mês e pela
>região de entrega do pedido.
