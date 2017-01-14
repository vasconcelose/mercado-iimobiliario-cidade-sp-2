# wrangle-trends.r

df <- read.csv('dados.csv')

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
df$d <- as.Date(paste(df$m_str, '01', df$a_str, sep='/'), format='%m/%d/%Y')

# ler dados de trends
dfTrends <- read.csv('dados-crus/google-trends/apartamento-sao-paulo.csv', skip=2)
dfTrends$d <- as.Date(paste(as.character(dfTrends$data), '01', sep='-'), format='%Y-%m-%d')

dfTrends$vso <- c(df$vso, NA, NA, NA)

# library(ggplot2)

p <- list()
# plotar trend por ano
for (i in c(4:16)) {
	ano <- toString(2000 + i)
	p[[i]] <- ggplot(aes(x=d, y=financiamento_caixa), data=dfTrends) +
		geom_line(alpha=0.75, color='dodgerblue') +
		geom_point(alpha=0.75, color='black', shape='O') +
		geom_line(aes(x=d, y=vso), data=dfTrends, color='tomato2', alpha=0.75) +
		geom_point(aes(x=d, y=vso), data=dfTrends, color='black', alpha=0.75, shape='O') +
		xlim(as.Date(paste(ano,'-01-01', sep=''), format='%Y-%m-%d'),
			as.Date(paste(ano, '-12-01', sep=''), format='%Y-%m-%d')) +
		xlab('') + ylab('') +
		theme(axis.text.x=element_text(size=6, angle=25),
			axis.text.y = element_text(size=6))
}

library(cowplot)

plot_grid(p[[4]], p[[5]], p[[6]], p[[7]], p[[8]], p[[9]], p[[10]], p[[11]], p[[12]],
	p[[13]], p[[14]], p[[15]], p[[16]], labels=c("'04", "'05", "'06", "'07",
		"'08", "'09", "'10", "'11", "'12", "'13", "'14", "'15", "'16"),
	label_size=10, ncol=4, nrow=4)

ggsave('graficos/trends.png')

# estatisticas
library(sqldf)

p <- list()
for (i in c(1:12)) { # iterar sobre os meses do ano
	ano <- ''
	if (i < 10) {
		ano <- paste('0', toString(i), sep='')
	} else {
		ano <- toString(i)
	}
	q <- paste("select apartamento_sao_paulo, vso from dfTrends where data like '%-", ano, "'", sep='')
	p[[i]] <- sqldf(q)
}

# testes de hipotese: buscas em janeiro superam todos os outros meses?
for (i in c(2:12)) {
	print(paste('mes 1 x mes', toString(i)))
	print('apartamento sao paulo')
	ttest <- t.test(p[[1]]$apartamento_sao_paulo, p[[i]]$apartamento_sao_paulo, alternative='greater', conf.level=0.95)
	print(ttest)
	print('vso')
	ttest <- t.test(p[[1]]$vso, p[[i]]$vso, alternative='less', conf.level=0.95)
	print(ttest)
}
