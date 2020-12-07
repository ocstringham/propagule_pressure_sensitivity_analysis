# script to plot the results of each uncertainty analysis scenario

library(dplyr)
library(ggplot2)
library(egg)
library(stringr)


# load in results
ua1 = readRDS("data/uncertainty/ua1_ps_only_sumdf.rds") %>% mutate(upe = upper_95 - lower_95) %>% 
  mutate(scenario = "known PS")

ua2 = readRDS("data/uncertainty/ua2_no_sp_sumdf.rds") %>% mutate(upe = upper_95 - lower_95) %>% 
  mutate(scenario = "known PS and NI")

ua3 = readRDS("data/uncertainty/ua3_ni_only_sumdf.rds") %>% mutate(upe = upper_95 - lower_95) %>% 
  mutate(scenario = "known NI")

ua4 = readRDS("data/uncertainty/ua4_no_pp_sumdf.rds") %>% mutate(upe = upper_95 - lower_95) %>% 
  mutate(scenario = "known risk-release curve")

# all results to one df
df_all = bind_rows(ua1, ua3, ua2, ua4) %>% mutate(scenario = str_replace(scenario, "NI", "PN"))




# overall summary and boxplots

## summary stats
df_all %>% 
  group_by(scenario) %>% 
  summarise(mean = mean(upe), sd = sd(upe), var = var(upe))


## box plot
ggplot(df_all, aes(y = upe, x = scenario)) + 
  geom_boxplot(width = 0.5) +
  labs(y = "uncertainty in PE") + 
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  theme_bw() +
  theme(panel.grid = element_blank())

### save
ggsave(filename = "plots/uncertainty_box.png", last_plot())



# detailed plots (Figure S1)

## known PS
p1 = 
  ggplot(ua1, aes(x = `ps`))+
    geom_errorbar(aes(ymin = lower_95, ymax = upper_95), color = "gray") +
    geom_line(aes(y = upper_95 - lower_95), color = "#b2abd2", size = 1 ) + 
    scale_y_continuous(limits = c(0, 1)) +
    labs(y = "", x = "PS", 
         title = "(a) known PS", subtitle = "unknown PN and risk-release curve") +
  theme_bw() +
  theme(#axis.title.x = element_blank(), 
        panel.grid.minor = element_blank()) + 
  NULL
p1


## known PS and PN
p2 = 
  ggplot(ua2 %>% filter(ni == 1), aes(x = `ps`))+
  geom_errorbar(aes(ymin = lower_95, ymax = upper_95), color = "gray") +
  geom_line(aes(y = upper_95 - lower_95), color = "#b2abd2", size = 1 ) + 
  scale_color_manual(values = c("#9ebcda", "#8c6bb1", "#810f7c")) +
  # scale_x_continuous(limits = c(0,100)) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(y = "", x = "PS", color = "NI", 
       title = "(c) known PS and PN", subtitle = "Unknown risk-release curve") +
  theme_bw() +
  theme(#axis.title.x = element_blank(), 
        panel.grid.minor = element_blank()) + 
  NULL
  
p2


## known PN
p3 = 
  ggplot(ua3, aes(x = `ni`))+
  geom_errorbar(aes(ymin = lower_95, ymax = upper_95), color = "gray") +
  geom_line(aes(y = upper_95 - lower_95), color = "#b2abd2", size = 1 ) + 
  scale_y_continuous(limits = c(0, 1)) +
  scale_x_continuous(breaks = seq(2,10,2)) +
  labs(y = "", x = "PN", 
       title = "(b) known PN", subtitle = "unknown PS and risk-release curve") +
  theme_bw() +
  theme(#axis.title.x = element_blank(), 
        panel.grid.minor.y = element_blank()) + 
  NULL
p3


## known risk-release curve
p4 = 
  ggplot(ua4, aes(x = `rr`))+
  geom_errorbar(aes(ymin = lower_95, ymax = upper_95), color = "gray") +
  geom_bar(stat = 'identity', aes(y = upper_95 - lower_95), 
           color = "#b2abd2", fill = "#b2abd2", size = 1, alpha = 0.5) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0,1,0.25)) +
  scale_x_continuous(breaks = 1:3, labels = c("q = 0.87", "q = 0.93", "q = 0.96")) +
  labs(y = "", x = "risk-release curve", 
       title = "(d) known risk-release curve", subtitle = "unknown PS and PN") +
  theme_bw() +
  theme(axis.title.x = element_blank(), 
        panel.grid.minor = element_blank(), panel.grid.major.x = element_blank()) + 
  NULL
p4


## arrange
ggarrange(p1, p3, p2, p4, ncol = 2, left = 'PE (gray) or\nuncertainty in PE (purple)')


## save
ggsave(ggarrange(p1, p3, p2, p4, ncol = 2, left = 'PE (gray) or\nuncertainty in PE (purple)'),
       filename = "plots/uncertainty.png", dpi = 300, 
       width = 7, height = 5, units = 'in')

