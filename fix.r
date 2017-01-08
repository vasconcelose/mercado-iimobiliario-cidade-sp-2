# fix.r

# *** carregar df
df <- read.csv("dados.csv")

# *** primeiro conserto nos dados:
# interpolar valores de populacao inexistentes

# visualizar dados
df[,c("a", "pop", "pib")] # 2005 a 2009 (fim 12 e inicio 73)

# interpolacao
a <- c(df$a[12], df$a[73])
b <- c(df$pop[12], df$pop[73])
inter <- approx(a, b, method="linear", n=7)

# corrigir valores de 2005 a 2009
for (i in c(2005:2009)) {
	df$pop[df$a == i] <- inter$y[i - 2003]
}

# *** segundo conserto nos dados:
# continuar valores de populacao seguindo a tendencia
# de crescimento

# visualizar dados
df

# a taxa pode ser encontrada do 73 para o 72 (diferenca de pop)
taxa <- df$pop[73] - df$pop[72]

# corrigir valores de populacao dos anos posteriores a 2010
for (i in c(2011:2016)) {
	df$pop[df$a == i] <- df$pop[df$a == i - 1] + taxa
}

df$pop = as.integer(df$pop)

# *** terceiro conserto nos dados:
# divisao da vso por 100 (porcentagem)
df$vso = df$vso / 100

# *** quarto conserto nos dados:
# divisao de pib por 10e8 (bilhoes)
df$pib = signif(df$pib / 1e8, digits=3)

# *** escrever df
write.csv(df, "dados-fixed.csv", quote=FALSE, row.names=FALSE)
