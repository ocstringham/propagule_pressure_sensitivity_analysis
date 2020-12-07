# script to calculate and plot the maximum allowable propagule pressure to 
# maintain a target PE


library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(egg)


# load funs
source("scripts/functions/all_pderiv_funs.R")
source("scripts/functions/dpe_multi_fun.R")
source("scripts/functions/max_allowable_pp.R")

# run analysis --------------------------------------------------------------- #

# set propagule pressure values to explore
ps = 1:100
ni = 1:10


# set Risk-release curve parameters

## curve 1
q1 = 0.96
c1 = 0.7

## curve 2
q2 = 0.99
c2 = 0.7


# get PE for all combos of parameter values
df1 = dpe_multi(FUN = NA, ps = ps, ni = ni, q = q1, c = c1)
df2 = dpe_multi(FUN = NA, ps = ps, ni = ni, q = q2, c = c2)


# filter out parameter combos that are below a target PE
df1_max = bind_rows(max_allowable_pp(df1, "ps", 0.25),
                   max_allowable_pp(df1, "ps", 0.5))

df2_max = bind_rows(max_allowable_pp(df2, "ps", 0.25),
                    max_allowable_pp(df2, "ps", 0.5))

## bind to one df
df_max = bind_rows(df1_max, df2_max)




# plot ----------------------------------------------------------------------- #

# labels for plot
pe_labels = c('0.25' = 'Target PE = 0.25', '0.5' = 'Target PE = 0.5',
              '0.1' = 'Target PE = 0.10', '0.05' = 'Target PE = 0.05')

rr_labels = c('0.96' = 'Location A', '0.99' = 'Location B')

# plot
gg_max = 
  df_max %>% 
  ggplot(aes(x = ni, y = ps, 
             group = target_pe)) +
  # geom_tile() +
  geom_line(color = "#622C78", size = 1) +
  # geom_point() +
  geom_area(fill = "#A250C3") +
  # scale_fill_manual(values = white_blue) +
  scale_x_continuous(breaks = pretty_breaks()) +
  # scale_y_continuous(breaks = seq(0,10,2), expand = c(0,0)) +
  labs(x = "PN", y = "PS", color = "target PE") +
  facet_grid(q~target_pe, labeller = labeller(target_pe = pe_labels, q = rr_labels)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA)) +
  NULL

gg_max 



ggsave(gg_max, filename = "plots/sa_sa_v2.png", 
       dpi = 300,
       # height = 6, width = 6, 
       units = "in")


# get numbers used in MS ----------------------------------------------------- #

## NI = 2
df_max %>% 
  filter(q == 0.96 & target_pe == 0.5) %>% 
  filter(ni == 2) %>% 
  pull(ps)

## NI = 10
df_max %>% 
  filter(q == 0.99 & target_pe == 0.5) %>% 
  filter(ni == 10) %>% 
  pull(ps)


## % change in ps
df_max %>% 
  group_by(ni, q, target_pe) %>% 
  summarise(ps) %>% 
  pivot_wider(names_from = q, 
              values_from = ps, 
              names_prefix = "ps_q") %>% 
  ungroup() %>% 
  group_by(ni,target_pe ) %>% 
  summarise(d = ps_q0.99/ps_q0.96) %>% 
  ungroup() %>% 
  group_by(target_pe) %>% 
  summarise(mean(d, na.rm = TRUE))


