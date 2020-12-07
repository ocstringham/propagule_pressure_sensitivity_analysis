# script to run the uncertainty analysis when PS and NI is known but the risk-
# release curve is unknown

library(ggplot2)
library(dplyr)
library(tidyr)

# load functions
source("scripts/functions/all_pderiv_funs.R")
source("scripts/functions/dpe_multi_fun.R")


# define a function to uncertainty for each value of NI
uncert_ps_const_change_ni = function(ni){

  # mcmc runs
  
  ## number of iterations
  mcmc = 10000
  
  
  ## define risk release curve parameters c and q
  q = c(0.87,0.93, 0.96)
  c = c(0.7)
  
  ## get random samples for p and q
  q_mc = sample(q, mcmc, replace = TRUE)
  c_mc = sample(c, mcmc, replace = TRUE)
  
  
  # Run through each iteration via for loop
  param_list = list()
  for(i in 1:mcmc){
    param_list[[i]] = pe(ps = 1:100, ni = ni, q = q_mc[i], c = c_mc[i])  # calculates for every value of PS
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
    select(-key, pe = value) %>% 
    mutate(ni = ni)
  
  
  
  # # check for convergence
  # convergence = 
  #   df2 %>% 
  #   filter(ps <= 10) %>%
  #   group_by(ps) %>%
  #   mutate(sd = TTR::runSD(pe, cumulative = TRUE), mcmc_run = 1:mcmc)
  
  
  # ggplot(convergence, aes(x = mcmc_run, y = sd)) +
  #   geom_line() + 
  #   facet_wrap(~ps)
  # 
  # 
  # # plot results
  # ggplot(df2, aes(x = ps, group = ps, y = pe)) +
  #   geom_boxplot() + #outlier.alpha = 0
  #   scale_x_continuous(limits = c(0,100))
  
  
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
      sd2 = 2*sd(pe)) %>% 
    mutate(ni = ni)
  
  

  return(list(df2, df_summary))

}



# Run uncertainty analysis for NI = 1 to 10
df1_list = list()
df2_list = list()
for(i in 1:10){
  # run
  temp = uncert_ps_const_change_ni(i)
  # unpack results
  df1_list[[i]] = temp[[1]] # raw results
  df2_list[[i]] = temp[[2]] # summary results
  print(i)
}

# results to single dfs
df1 = bind_rows(df1_list)
df2 = bind_rows(df2_list)


# save df
saveRDS(df1, "data/uncertainty/ua2_no_sp_df.rds")
saveRDS(df2, "data/uncertainty/ua2_no_sp_sumdf.rds")
