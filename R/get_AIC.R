get.aic = function(modelList, data, sig = 3, corr.errors = NULL, add.vars = NULL, 
                   grouping.vars = NULL, top.level.vars = NULL, adjust.p = FALSE, 
                   basis.set = NULL, pvalues.df = NULL,  disp.conditional = FALSE,
                   model.control = NULL, .progressBar = TRUE) {
  
  if(is.null(basis.set)) { 
    
    basis.set = get.basis.set(modelList, corr.errors, add.vars)
    
    basis.set = filter.exogenous(modelList, basis.set, corr.errors, add.vars) 
    
  }
  
  if(length(basis.set) < 1) 
    warning("All endogenous variables are conditionally dependent: no test of d-sep necessary")
  
  if(is.null(pvalues.df))
    pvalues.df = get.missing.paths(modelList, data, corr.errors, add.vars, grouping.vars, top.level.vars,
                                   adjust.p, basis.set, disp.conditional, model.control, .progressBar)
  
  fisher.c = get.fisher.c(modelList, data, sig, corr.errors, add.vars, grouping.vars, top.level.vars,
                          adjust.p, basis.set, pvalues.df, disp.conditional, model.control, .progressBar)
  
  K = do.call(sum, lapply(modelList, function(i) attr(logLik(i), "df")))
  
  AIC = unname(fisher.c[1] + 2 * K)
  
  AICc = unname(fisher.c[1] + 2 * K * (min(unlist(lapply(modelList, nobs)))/(min(unlist(lapply(modelList, nobs))) - K - 1)))
  
  round(c(AIC = AIC, AICc = AICc, K = K, n = min(unlist(lapply(modelList, nobs)))), sig)

}