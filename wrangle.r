# wrangle.r

library(ggplot2)

df <- read.csv('dados-fixed.csv')

# # gg1
# gg1 <- ggplot(aes(x=a, y=fam_endividadas, color=vso), data=df) +
# 		geom_jitter(size=5) + 
# 		stat_smooth(span=0.95, method='loess', color='black') +
# 		scale_color_gradient(low='maroon', high='green') +
# 		theme_bw() +
# 		xlab('ano') + ylab('taxa de familias endividadas')
# ggsave('graficos/gg1.png')

# # gg2
# gg2 <- ggplot(aes(x=vso, y=porc_divida_financ_casa), data=df) +
# 		geom_jitter(size=5, shape='O', color='#5378F3') +
# 		stat_smooth(method='loess', color='black', span=0.95) +
# 		theme_bw() + xlab('vso') + ylab('divida devido ao financiamento de moradia') +
# ggsave('graficos/gg2.png')

# # gg3
# gg3 <- ggplot(aes(x=a, y=porc_divida_financ_casa), data=df) +
# 		geom_jitter(size=6, shape='+', color='#F37853') +
# 		stat_smooth(method='loess', color='black', span=0.95) +
# 		theme_bw() + xlab('ano') + ylab('divida devido ao financiamento de moradia') +
# ggsave('graficos/gg3.png')

# # gg4
# dfTmp <- df
# dfTmp['mi.hab'] = signif(dfTmp$pop / 1e6, digits=3)
# dfTmp$pib = signif(dfTmp$pib * 100, digits=3)
# gg4 <- ggplot(aes(x=a, y=pib, size=mi.hab), data=dfTmp) +
# 		geom_line(color='#954763') + theme_bw() +
# 		xlab('ano') + ylab('pib municipal (bi)')
# ggsave('graficos/gg4.png')

# # gg5
# dfTmp <- df
# #dfTmp$selic <- dfTmp$selic / 100
# gg5 <- ggplot() +
# 		geom_point(aes(x=fam_endividadas, y=selic, color=vso), size=10, alpha=0.5, data=dfTmp) +
# 		scale_color_gradient(low='#5534DD', high='#DD3455') +
# 		xlab('taxa de familias endividadas') + ylab('selic (%)') +
# 		theme_bw()
# ggsave('graficos/gg5.png')

# # gg6
# dfTmp <- df
# dfTmp$a <- as.character(dfTmp$a)
# gg6 <- ggplot(aes(x=vso, y=selic, color=a), data=dfTmp) +
# 		geom_point(size=6, shape=18, alpha=0.8) + xlab('vso') + ylab('selic (%)') +
# 		scale_color_manual(name='ano', values=c('firebrick', 'navyblue', 'springgreen4',
# 			'purple', 'chocolate', 'gold', 'maroon', 'magenta', 'gray17', 'lawngreen',
# 			'cornsilk3', 'tan4', 'dodgerblue4')) +
# 		theme_bw()
# ggsave('graficos/gg6.png')

# gg7
dfTmp <- df
dfTmp['datas'] <- seq(as.Date("2004-01-01"), by="month", length.out=12*(2016-2004)+10)
gg7 <- ggplot(aes(x=datas, y=selic, color=vso), data=dfTmp) +
		geom_step(size=3, alpha=0.7) + xlab('ano') + ylab('selic (%)') +
		scale_color_gradient(low='dodgerblue4', high='gold') +
		theme_bw()
ggsave('graficos/gg7.png')

# estatisticas
# correlacao de pearson: vso x divida
cor.test(df$vso, df$fam_endividadas, method='pearson')

# correlacao de pearson: vso x divida especifica moradia
cor.test(df$vso, df$porc_divida_financ_casa, method='pearson')

# correlacao de pearson: divida x divida especifica moradia
cor.test(df$fam_endividadas, df$porc_divida_financ_casa, method='pearson')

# correlacao de pearson: selic x vso
cor.test(df$selic, df$vso, method='pearson')

# correlacao de pearson: selic x divida
cor.test(df$selic, df$fam_endividadas, method='pearson')
