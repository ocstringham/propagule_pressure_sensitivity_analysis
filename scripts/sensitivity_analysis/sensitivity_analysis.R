# script to run the sensitivity analyses presented in paper

library(dplyr)
library(ggplot2)
library(egg)



# load functions
source("scripts/functions/all_pderiv_funs.R")
source("scripts/functions/dpe_multi_fun.R")
source("scripts/functions/sa_funs.R")


# run sensitivity analysis --------------------------------------------------- #

## with respect to PS --> dpe_dps function
dps1 = dpe_multi(FUN = dpe_dps, ps = 1:100, ni = 5, q = 0.96, c = 0.7)
dps2 = dpe_multi(FUN = dpe_dps, ps = 1:100, ni = 5, q = 0.99, c = 0.7)

## with respect to PN (AKA NI) --> dpe_dni function
dni1 = dpe_multi(FUN = dpe_dni, ps = 10, ni = 1:10, q = 0.96, c = 0.7)
dni2 = dpe_multi(FUN = dpe_dni, ps = 10, ni = 1:10, q = 0.99, c = 0.7)


# plot sensitivity analysis  ------------------------------------------------- #

ps1 = sa_ps(dps1, title = 'a')
ps2 = sa_ps(dps2, title = 'c')

ni1 = sa_ni(dni1, title = 'b')
ni2 = sa_ni(dni2, title = 'd')



# plot all ------------------------------------------------------------------- #
gridExtra::grid.arrange(ps1, ni1, ps2, ni2,  ncol = 2)

# save
ggsave(plot = gridExtra::grid.arrange(ps1, ni1, ps2, ni2,  ncol = 2),
       filename = "plots/ppsa_v3.png", scale = 1.25,
       dpi = 300, 
       # width = 15, height = 6, 
       units = 'cm')




# get specific results-------------------------------------------------------- #

## get average difference btwn "locations" for results

mean(dps2$dpe[1:5]/dps1$dpe[1:5])
mean(dni2$dpe[1:5]/dni1$dpe[1:5])


## values for closest to target PE
ps1 = sa_ps(dps1, return_data = TRUE)
ps2 = sa_ps(dps2, return_data = TRUE)

ps1$dps_pe25$ps
ps1$dps_pe50$ps
ps2$dps_pe25$ps
ps2$dps_pe50$ps

ni1 = sa_ni(dni1, return_data = TRUE)
ni2 = sa_ni(dni2, return_data = TRUE)

ni1$dni_pe25$ni
ni1$dni_pe50$ni
ni2$dni_pe25$ni
ni2$dni_pe50$ni

