# script to run the uncertainty analysis when the risk-release relationship is 
# known but NI and PS are unknown


library(ggplot2)
library(dplyr)
library(tidyr)


# load functions
source("scripts/functions/all_pderiv_funs.R")
source("scripts/functions/dpe_multi_fun.R")

# mcmc runs

## number of iterations
mcmc = 10000

## get random parameter values for PS and NI
ps_mc = runif(mcmc, min = 1, max = 100) %>% round()
ni_mc = runif(mcmc, min = 1, max = 10) %>% round()

## define risk release curve parameters c and q
q = c(0.87,0.93, 0.96)
c = c(0.7)

# make df where each row is a risk-release curve
rr_df = 
  c(q[1], c[1],
    q[2], c[1],
    q[3], c[1]) %>% 
  matrix(ncol = 2, byrow = TRUE) %>% as.data.frame() %>% rename(q = `V1`, c = `V2`)


# Run through each iteration via for loop

## initialize results in a list
param_list = rep(list(rep(NA, nrow(rr_df))),mcmc)

## loop
for(i in 1:mcmc){
  for(j in 1:nrow(rr_df)){
    param_list[[i]][j] = pe(ps = ps_mc[i], ni = ni_mc[i], q = rr_df$q[j], c = rr_df$c[j])
  }
}


# to df

## combine all iterations
df = do.call(rbind.data.frame, param_list)
colnames(df) = as.character(1:3)


## reshape to tidy format
df2 = 
  gather(df) %>%
  mutate(rr = as.integer(key)) %>%
  arrange(key) %>% 
  select(-key, pe = value)



# check for convergence
convergence = 
  df2 %>% 
  group_by(rr) %>%
  mutate(sd = TTR::runSD(pe, cumulative = TRUE), mcmc_run = 1:mcmc)

ggplot(convergence, aes(x = mcmc_run, y = sd)) +
  geom_line() +
  scale_y_continuous(trans = "log1p") +
  facet_wrap(~rr)


# plot results
ggplot(df2, aes(x = rr, group = rr, y = pe)) +
  geom_boxplot() #outlier.alpha = 0


# get CV
df_summary = 
  df2 %>% 
  group_by(rr) %>% 
  summarise(
    # q_97525 = quantile(pe, 0.975) - quantile(pe, 0.025),
    # q_8020 = quantile(pe, 0.80) - quantile(pe, 0.20),
    q_50 = quantile(pe, 0.75) - quantile(pe, 0.25),
    q_95 = quantile(pe, 0.975) - quantile(pe, 0.025),
    upper_95 = quantile(pe, 0.975),
    lower_95 = quantile(pe, 0.025),
    sd = sd(pe),
    sd2 = 2*sd(pe))



# save df
saveRDS(df2, "data/uncertainty/ua4_no_pp_df.rds")
saveRDS(df_summary, "data/uncertainty/ua4_no_pp_sumdf.rds")
