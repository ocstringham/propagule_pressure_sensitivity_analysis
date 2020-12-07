# functions to plot results of sensitivity analyses. 
# It also calculated the closest parameter value to the target PE

library(dplyr)
library(ggplot2)
library(egg)


# ---------------------------------------------------------------------------- #

# Sensitivity analysis in relation to PS

sa_ps = function(dps_df, title = NA, return_data = FALSE){
  
  dps = dps_df
  
  ## calculate max allowable PS
  dps_pe25 =  
    dps %>% 
    filter(pe <= 0.25) %>% 
    mutate(closest_to_target = abs(pe - 0.25)) %>% 
    # group_by(ni,q) %>% 
    top_n(-1, closest_to_target)
  
  dps_pe50 = 
    dps %>% 
    filter(pe <= 0.5) %>% 
    mutate(closest_to_target = abs(pe - 0.5)) %>% 
    # group_by(ni,q) %>% 
    top_n(-1, closest_to_target)
  
  ## draw risk-release curve
  dps_curve = 
    dps %>% 
    ggplot(aes(x = ps, y = pe)) +
    geom_line() +
    scale_y_continuous(limits = c(0,1), breaks = c(0, 0.5, 1), labels = c(0,'',1)) +
    scale_x_continuous(limits = c(0,50)) + 
    labs(x = "PS", y = "PE", title = title) + 
    geom_vline(data = dps_pe25, aes(xintercept = ps), linetype = "dotted") +
    geom_vline(data = dps_pe50, aes(xintercept = ps), linetype = "dashed") +
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.title.x = element_blank(), 
          axis.text.x = element_blank(), 
          plot.title = element_text(hjust=1)) +
    NULL
  dps_curve
  
  ## draw sensitivity analysis curve with vlines for PE targets
  dps_sa = 
    dps %>% 
    ggplot(aes(x = ps, y = dpe)) +
    # geom_bar(stat = 'identity', fill = "#ff9232", color = NA, width = 0.65) +
    geom_line(color = "#ff9232") +
    geom_point(color = "#ff9232") +
    scale_y_continuous(limits = c(0, 0.20)) +
    scale_x_continuous(limits = c(0,50)) + 
    labs(x = "PS",
         y = expression(over(Delta*"PE", Delta*"PS"))) + 
    geom_vline(data = dps_pe25, aes(xintercept = ps), linetype = "dotted") +
    geom_vline(data = dps_pe50, aes(xintercept = ps), linetype = "dashed") +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    NULL
  dps_sa
  
  
  # return raw data if wanted
  if(return_data){
    
    return(list(dps = dps, 
                dps_pe25 = dps_pe25, 
                dps_pe50 = dps_pe50))
    
  # else just return plot
  }else{
    
    ggps = ggarrange(dps_curve, dps_sa, heights = c(0.5, 2), ncol = 1)
    return(ggps)
  }
  
}

# ---------------------------------------------------------------------------- #

# Sensitivity analysis in relation to NI

sa_ni = function(dni_df, title = NA, return_data = FALSE){
  
  dni = dni_df
  
  ## calculate max allowable NI
  dni_pe25 =  
    dni %>% 
    filter(pe <= 0.25) %>% 
    mutate(closest_to_target = abs(pe - 0.25)) %>% 
    # group_by(ps,q) %>%
    top_n(-1, closest_to_target)
  
  dni_pe50 = 
    dni %>% 
    filter(pe <= 0.5) %>% 
    mutate(closest_to_target = abs(pe - 0.5)) %>% 
    # group_by(ps,q) %>% 
    top_n(-1, closest_to_target)
  
  ## draw risk-release curve (except NI is the x axis)
  dni_curve = 
    dni %>% 
    ggplot(aes(x = ni, y = pe)) +
    geom_line() +
    scale_y_continuous(limits = c(0,1), breaks = c(0, 0.5, 1), labels = c(0,'',1)) +
    scale_x_continuous(limits = c(0.5,10.5), breaks = seq(2,10, 2)) +
    labs(x = "PN", y = "PE", title = title) + 
    geom_vline(data = dni_pe25, aes(xintercept = ni), linetype = "dotted") +
    geom_vline(data = dni_pe50, aes(xintercept = ni), linetype = "dashed") +
    theme_bw() +
    theme(panel.grid = element_blank(), 
          axis.title.x = element_blank(), 
          axis.text.x = element_blank(), 
          plot.title = element_text(hjust=1)) +
    NULL
  dni_curve
  
  ## draw sensitivity analysis curve
  dni_sa = 
    dni %>% 
    ggplot(aes(x = ni, y = dpe)) +
    # geom_bar(stat = 'identity', fill = "#ff9232", color = NA, width = 0.65) +  
    geom_line(color = "#ff9232") +
    geom_point(color = "#ff9232") +
    scale_y_continuous(limits = c(0, 0.20)) +
    scale_x_continuous(limits = c(0.5,10.5), breaks = seq(2,10, 2)) +
    labs(x = "PN",
         y = expression(over(Delta*"PE", Delta*"PN"))) + 
    geom_vline(data = dni_pe25, aes(xintercept = ni), linetype = "dotted") +
    geom_vline(data = dni_pe50, aes(xintercept = ni), linetype = "dashed") +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    NULL
  dni_sa
  
  # return raw data if wanted
  if(return_data){
    
    return(list(dni = dni, 
                dni_pe25 = dni_pe25, 
                dni_pe50 = dni_pe50))
    
  # else just return plot  
  }else{
    ggni = ggarrange(dni_curve, dni_sa, heights = c(0.5, 2), ncol = 1)
    return(ggni)
    
  }

  
  
}




