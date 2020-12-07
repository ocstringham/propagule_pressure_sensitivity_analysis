# ---------------------------------------------------------------------------- #
# script that inputs of (1) various parameter values (in form of vectors) and- #
# (2) a selected parameter to do a partial derivate (e.g. dpe/dps) and return- #
# a dataframe with paratemeter values, pe, and dpe for each combination of---- # 
# parameter value ------------------------------------------------------------ #
# ---------------------------------------------------------------------------- #


dpe_multi = function(FUN = NA, # which function to get dpe: can be dpe_dps, dpe_dni, or dpe_dq. If NA, then no partial derivs run.
                     ps, # vector of PS values to evaluate
                     ni, # vector of NI values to evaluate
                     q, # vector of q values to evlauate
                     c, # vector of c values to evaluate (must be same lenght as q)
                     phi = NA # phi value for dpe_dq
                     )
  {
  
  # define init vars
  pe_val = vector()
  dpe = vector()
  ps_val = vector()
  ni_val = vector()
  q_val = vector()
  c_val = vector()
  ## counter
  d = 1
  
  
  # make df of rr curves
  
  ## check to make sure rr curves params are same length
  if(length(q) != length(c)) return(print("q and c must be same length"))
  
  
  ## inits
  rr_list = list()
  
  ## get unique combos of rr curve params
  for(z in 1:length(q)){
    rr_list[[z]] = c(q[z], c[z])
  }
  ## compile to df and rename cols
  rr_df = do.call(rbind.data.frame, rr_list) 
  colnames(rr_df) = c('q', 'c')
  
  
  # loop through combinations of all vars to calc pe and dpe
  
  for(rr in 1:nrow(rr_df)){
    for(i in 1:length(ps)){
      for(j in 1:length(ni)){
        
        ## calc pe, call pe fun
        pe_val[d] = pe(ps = ps[i], ni = ni[j] , q = rr_df$q[rr], c = rr_df$c[rr])
        
        ## calc dpe, call dpe fun --> depends on var of interest
        
        ## if no function given
        if( !exists(deparse(substitute(FUN))) ){
          dpe[d] = NA
        }
        
        ### if no phi is provided
        else if(is.na(phi)){
          dpe[d] = FUN(ps = ps[i], ni = ni[j] , q = rr_df$q[rr], c = rr_df$c[rr])
          
        ### if phi is provided (for dpe/dq)
        }else{
          dpe[d] = FUN(ps = ps[i], ni = ni[j] , q = rr_df$q[rr], c = rr_df$c[rr], phi = phi)
        }
        

        
        # store var values for df
        ps_val[d] = ps[i]
        ni_val[d] = ni[j] 
        q_val[d] = rr_df$q[rr]
        c_val[d] = rr_df$c[rr]
        
        
        # update counter
        d = d+1
      }
    }
  }
  
  # combine into big df
  df = cbind.data.frame(ps = ps_val,
                        ni = ni_val,
                        q = q_val,
                        c = c_val,
                        pe = pe_val,
                        dpe)
  
  return(df)
  
}




