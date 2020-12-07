library(dplyr)
library(tidyr)

# load in data

## upper and lower intervals
df = read.csv("data/metaanalysis_curve/cassey2018_metaanalysis_upperlowerlines.csv", skip = 1)

## mean
metacurve_mean = read.csv("data/metaanalysis_curve/cassey2018_metaanalysis_meanline.csv", col.names = c("ps","pe"))



# convert each line to list

## empty list, dummy var
dflist = list()
dflist[[1]] = metacurve_mean

d = 1
f = 2

## loop through cols
for(i in 1:(ncol(df)/2)){
  
  ### subset out cols for one line & drop NAs
  df_temp = df[, c(d:(d+1))] %>%
    drop_na()
  
  ### rename cols
  colnames(df_temp) =  c("ps", "pe")
  
  ### assign to list
  dflist[[f]] = df_temp
  
  ### update vars
  d = d + 2
  f = f +1
  rm(df_temp)
}


# convert to 1 df
dflist[[1]]$id = "mean"
dflist[[2]]$id = "upper"
dflist[[3]]$id = "lower"

df_meta_curves = bind_rows(dflist)


# save
saveRDS(df_meta_curves, "data/metaanalysis_curve/meta_curves_points_df.rds")
