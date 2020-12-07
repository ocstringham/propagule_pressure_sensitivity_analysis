library(broom)
library(purrr)
library(dplyr)
library(ggplot2)


# import points for each meta analysis curve (mean, upper, lower)
df = readRDS("data/metaanalysis_curve/meta_curves_points_df.rds")

# fit nonlinear least squares: pe = 1 - (q^ps^c) for each curve
df2 = 
  df %>% 
  group_by(id) %>%
  do(nls = nls(data = ., formula = pe ~ 1 - (q^ps^c), 
                   start = list(q = 0.99, c = 1.0), trace = F))

# summary 
dfsum = tidy(df2, nls)
dfsum

# extract q and c parameters
dfsum %>% select(id, term, estimate)


# plot
library(ggplot2)

## generate curves for fit
df_fit = dfsum %>% 
  select(id, term, estimate) %>% 
  spread(key = term, value = estimate)

### predict points along curve
pe = function(ps, q, c){1 - (q^ps^c)}

ps_vals = 1:100
pred_list = list()
for(i in 1:nrow(df_fit)){
  pred_list[[i]] = data.frame( pe = pe(ps_vals, q = df_fit$q[i], df_fit$c[i]), ps = ps_vals, id = df_fit$id[i])
}

df_fit_pred = do.call(rbind.data.frame, pred_list)

  


## plot
ggplot(df, aes(x = ps, y = pe, group = id, color = id)) +
  geom_line() + 
  geom_line(data = df_fit_pred, aes(x = ps, y = pe), color = "black") + 
  scale_x_continuous(limits = c(0,100)) +
  labs(x = "PS", y = "PE", color = "meta-analysis\ncurve") +
  theme_bw()

