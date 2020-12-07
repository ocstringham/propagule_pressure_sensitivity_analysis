# function to calculate the maximum allowable propagule pressure (either PS
# of PN) given a PE threshold


max_allowable_pp = function(df, param, pe_threshold){
  
  param_list = c("ps", "ni", "q")
  group_by_params = param_list[ param_list != param  ]
  
  df2 = 
    df %>% 
      filter(pe <= pe_threshold) %>% 
      mutate(closest_to_target = abs(pe - pe_threshold)) %>% 
      group_by(.dots = group_by_params ) %>%
      top_n(-1, closest_to_target) %>% 
      mutate(target_pe = pe_threshold, param_of_interest = param)

  return(df2)
  
  }


                 

  
