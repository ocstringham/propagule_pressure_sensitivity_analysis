# script to run the uncertainty analysis when PS is known but NI and the risk-
# release curve are unknown


library(ggplot2)
library(dplyr)
library(tidyr)


# load functions
source("scripts/functions/all_pderiv_funs.R")
source("scripts/functions/dpe_multi_fun.R")


# mcmc runs

## number of iterations
mcmc = 10000

## get random parameter values for NI
ni_mc = runif(mcmc, min = 1, max = 10) %>% round()

## define risk release curve parameters c and q
q = c(0.87,0.93, 0.96)
c = c(0.7)

## get random samples for p and q
q_mc = sample(q, mcmc, replace = TRUE)
c_mc = sample(c, mcmc, replace = TRUE)


# Run through each iteration via for loop
param_list = list()
for(i in 1:mcmc){
  param_list[[i]] = pe(ps = 1:100, ni = ni_mc[i], q = q_mc[i], c = c_mc[i])
}


# to df

## combine all iterations
df = do.call(rbind.data.frame, param_list)
colnames(df) = 1:100


## reshape to tidy format
df2 = 
  gather(df) %>%
  mutate(ps = as.integer(key)) %>%
  arrange(key) %>% 
  select(-key, pe = value)
  


# check for convergence
convergence = 
  df2 %>% 
  filter(ps <= 10) %>%
  group_by(ps) %>%
  mutate(sd = TTR::runSD(pe, cumulative = TRUE), mcmc_run = 1:mcmc)


ggplot(convergence, aes(x = mcmc_run, y = sd)) +
  geom_line() +
  facet_wrap(~ps)
  

# plot results
ggplot(df2, aes(x = ps, group = ps, y = pe)) +
  geom_boxplot() + #outlier.alpha = 0
  scale_x_continuous(limits = c(0,25))


# get summary stats
df_summary = 
  df2 %>% 
  group_by(ps) %>% 
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
saveRDS(df2, "data/uncertainty/ua1_ps_only_df.rds")
saveRDS(df_summary, "data/uncertainty/ua1_ps_only_sumdf.rds")
