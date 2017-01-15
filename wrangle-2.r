# wrangle-trends.r

df <- read.csv('dados.csv')
dfTrends <- read.csv('dados-crus/google-trends/apartamento-sao-paulo.csv', skip=2)
dfTmp <- read.csv('dados-crus/google-trends/financiamento-caixa.csv', skip=2)

# substituir datas em pt por numeros de meses
df$a_str <- as.character(df$a)

df$m_str <- as.character(df$m)

df$m_str[df$m_str == 'jan'] <- '01'
df$m_str[df$m_str == 'fev'] <- '02'
df$m_str[df$m_str == 'mar'] <- '03'
df$m_str[df$m_str == 'abr'] <- '04'
df$m_str[df$m_str == 'mai'] <- '05'
df$m_str[df$m_str == 'jun'] <- '06'
df$m_str[df$m_str == 'jul'] <- '07'
df$m_str[df$m_str == 'ago'] <- '08'
df$m_str[df$m_str == 'set'] <- '09'
df$m_str[df$m_str == 'out'] <- '10'
df$m_str[df$m_str == 'nov'] <- '11'
df$m_str[df$m_str == 'dez'] <- '12'

# criar coluna data (d)
df$d <- as.Date(paste(df$m_str, '01', df$a_str, sep='-'), format='%m-%d-%Y')
dfTrends$d <- as.Date(paste(as.character(dfTrends$data), '01', sep='-'), format='%Y-%m-%d')

# colocar dados em um unico data frame
dfTrends$financiamento_caixa <- dfTmp$financiamento_caixa
dfTrends$vso <- c(df$vso, NA, NA, NA)

# bibliotecas usadas daqui para a frente
library(ggplot2)
library(scales)
library(cowplot)
library(sqldf)

dfTrends <- sqldf("select * from dfTrends where data not like '2017%'") # excluir dados de 2017

ggplot(aes(x=d, y=apartamento_sao_paulo), data=dfTrends) +
	geom_line(alpha=0.75, color='orange') +
	geom_point(alpha=0.75, color='black', shape='O') +
	xlab('ano') + ylab('trend "apartamento sao paulo"') +
	scale_x_date(date_labels='%Y', date_breaks='1 year', date_minor_breaks='2 month') +
	theme_dark()
ggsave('graficos/p-2-apartamento-sao-paulo.png')

ggplot(aes(x=d, y=financiamento_caixa), data=dfTrends) +
	geom_line(color='firebrick', alpha=0.75) +
	geom_point(color='black', alpha=0.75, shape='O') +
	xlab('ano') + ylab('trend "financiamento caixa"') +
	scale_x_date(date_labels='%Y', date_breaks='1 year', date_minor_breaks='2 month') +
	theme_dark()
ggsave('graficos/p-2-financiamento-caixa.png')

ggplot(aes(x=d, y=vso), data=dfTrends) +
	geom_line(color='seashell', alpha=0.75) +
	geom_point(color='black', alpha=0.75, shape='O') +
	xlab('ano') + ylab('vso (%)') +
	scale_x_date(date_labels='%Y', date_breaks='1 year', date_minor_breaks='2 month') +
	theme_dark()
ggsave('graficos/p-2-vso.png')

# estatisticas
p <- list()

for (trend in c('apartamento_sao_paulo', 'financiamento_caixa')) { # iterar sobre trends
	print(paste('##########', trend))
	for (i in c(1:12)) { # iterar sobre os meses do ano
		ano <- ''
		if (i < 10) {
			ano <- paste('0', toString(i), sep='')
		} else {
			ano <- toString(i)
		}
		q <- paste("select ", trend, ", vso from dfTrends where data like '%-", ano, "'", sep='')
		p[[i]] <- sqldf(q)
	}
	# testes de hipotese: buscas em janeiro superam todos os outros meses?
	for (i in c(2:12)) {
		print(paste('mes 1 x mes', toString(i)))
		ttest <- t.test(p[[1]][[trend]], p[[i]][[trend]], alternative='greater', conf.level=0.95)
		print(ttest)		
	}
}

print('######## vso')
for (i in c(2:12)) {
	print(paste('mes 1 x mes', toString(i)))
	ttest <- t.test(p[[1]]$vso, p[[i]]$vso, alternative='less', conf.level=0.95)
	print(ttest)
}
