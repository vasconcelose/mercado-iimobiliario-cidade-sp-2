# mercado-imobiliario-cidade-sp-2
Material usado para escrever as postagens _"Paulistanos e a casa própria, Parte I: a história que os dados contam"_ e _"Paulistanos e a casa própria, Parte II: como pensa o paulistano médio quando faz um financiamento (e como tirar proveito disso)"_ no blog Edudatalab (https://edudatalab.wordpress.com/)


* dados-crus/\*: bases de dados baixadas, antes de qualquer tratamento
* dados-crus/google-trends/\*: dados de busca do Google Trends
* dados.csv: base de dados compilada, sem imputação
* dados-fixed.csv: base de dados compilada, com imputação
* dados.ods: mesmo conteúdo de dados.csv, mas em ODS
* graficos/\*: visualizações geradas pelo R em wrangle.r
* fix.r: script R para efetuar correções na base de dados e imputar valores
* wrangle.r: execução da análise exploratória - geração de visualizações e cálculo de estatísticas
* wrangle-trends.r: wrangle da parte 2
* estatisticas.txt: saída de wrangle.r em texto (coeficientes de Pearson)
* trends-\*.txt: saidas de wrangle-trends.txt

>Eduardo Vasconcelos<br>
>eduardovasconcelos@usp.br
