# Propagule Pressure Sensitivity and Uncertainty Analysis
Code and data associated with "Managing propagule pressure to prevent invasive species establishments: propagule size, number, and risk-release curve" by Oliver C. Stringham & Julie L. Lockwood. _Ecological Applications_ (accepted). Link to be avaiable upon publication.


---
## Contents
The following contains descriptions of each file: 


|- scripts
	
	|- functions
		
		|- all_pderiv_funs.R
				A script that defines functions which calculate PE, dpe/dps, and dpe/dni.
				
		|- dpe_multi_fun.R
				A script for function that takes inputs of (1) various parameter values (in form of vectors) and (2) a selected parameter to do a partial derivate (e.g. dpe/dps) and return a dataframe with paratemeter values, pe, and dpe for each combination of parameter value. Accepted paramteres are: PS, PN (called ni), q, c, and phi.
		
		|- max_allowable_pp.R
				A script for function to calculate the maximum allowable propagule pressure (either PS of PN) given a PE threshold.
				
		|- sa_funs.R
				A script for functions to plot results of sensitivity analyses. It also calculated the closest parameter value to the target PE.
		
	|- fit_metaanalysis_lines
		
		|- _01_import_metaanalysis_curves.R
				Imports raw .csv files of the curves generated from Cassey et al. 2018 and compiles the mean, lower, and upper credible interval lines into one dataframe.
				
		|- _02_fit_metaanalysis_curves.R
				Uses non-linear least square to fit a line of best fit to the mean, lower, and upper credible interval lines from Cassesy et al. 2018.
		
	|- uncertainty_analysis
		
		|- _01_uncertainty_analysis_ps_yes_ni_no_rr_no.R
				A script that runs uncertainty analysis scenario 1 (only PS known).
		
		|- _02_uncertainty_analysis_ps_yes_ni_yes_rr_no.R
				A script that runs uncertainty analysis scenario 2 (PN and RR known).
		
		|- _03_uncertainty_analysis_ps_no_ni_yes_rr_no.R
				A script that runs uncertainty analysis 3 (only PN known).
		
		|- _04_uncertainty_analysis_ps_no_ni_no_rr_yes.R
				A script that runs uncertainty analysis 4 (only risk-release curve known).
		
		|- _05_plot.R
				A script that plots all results from each uncertainty analysis.
	
	|- sensitivity_analysis
	
		|- sensitivity_analysis.R
				A script to run the sensitivity analyses presented in paper. It explores the change PE realized when either PS or PN is changed. 
				
		|- max_allowable_pp_analysis.R
				A script to run the maximum allowable propagule pressure analysis presented in paper. 


|- data

	|- metaanalysis_curve
		
		|- cassey2018_metaanalysis_meanline.csv 
				A csv file of the mean line from the meta analysis on propagule pressure (Cassey et al. 2018). We digitized this line using the WebPlotDigitizer (https://apps.automeris.io/wpd/)
		
		|- cassey2018_metaanalysis_upperlowerlines.csv 
				A csv file of the upper and lower credible interval from the meta analysis on propagule pressure (Cassey et al. 2018). We digitized this line using the WebPlotDigitizer (https://apps.automeris.io/wpd/)
		
		|- meta_curves_points_df.rds
				the combined dataframe containing points from the mean, lower, and upper credible intervals from Cassey et al. 2018. Generated from script: script/_01_import_metaanalysis_curves.R
		
	|- uncertainty
		
		|- ua1_ps_only_df.rds
				raw results from the uncertainty analysis scenario 1 (only PS known). Genereated from scripts/uncertainty_analysis/_01_uncertainty_analysis_ps_yes_ni_no_rr_no.R
		
		|- ua1_ps_only_sumdf.rds
				summarized results from the uncertainty analysis scenario 1 (only PS known). Genereated from scripts/uncertainty_analysis/_01_uncertainty_analysis_ps_yes_ni_no_rr_no.R
		
		|- ua2_no_sp_df.rds
				raw results from the uncertainty analysis scenario 2 (PN and RR known). Genereated from scripts/uncertainty_analysis/_02_uncertainty_analysis_ps_yes_ni_yes_rr_no.R
		
		|- ua2_no_sp_sumdf.rds
				summarized results from the uncertainty analysis scenario 2 (PN and RR known). Genereated from scripts/uncertainty_analysis/_02_uncertainty_analysis_ps_yes_ni_yes_rr_no.R
		
		|- ua3_ni_only_df.rds
				raw results from the uncertainty analysis scenario 3 (only PN known). Genereated from scripts/uncertainty_analysis/_03_uncertainty_analysis_ps_no_ni_yes_rr_no.R
		
		|- ua3_ni_only_sumdf.rds
				summarized results from the uncertainty analysis scenario 3 (only PN known). Genereated from scripts/uncertainty_analysis/_03_uncertainty_analysis_ps_no_ni_yes_rr_no.R
		
		|- ua4_no_pp_df.rds
				raw results from the uncertainty analysis scenario 4 (only risk-release curve known). Genereated from scripts/uncertainty_analysis/_04_uncertainty_analysis_ps_no_ni_no_rr_yes.R
		
		|- ua4_no_pp_sumdf.rds
				summarized results from the uncertainty analysis scenario 4 (only risk-release curve known). Genereated from scripts/uncertainty_analysis/_04_uncertainty_analysis_ps_no_ni_no_rr_yes.R	
		
|- plots
	An empty folder to save any plots generated. 
		
|- Stringham_and_Lockwood_2020.Rproj
		R project file that will open RStudio and use this repository as project. 
		
		
		
References
Cassey, P., S. Delean, J. L. Lockwood, J. S. Sadowski, and T. M. Blackburn. 2018. Dissecting the null model for biological invasions: A meta-analysis of the propagule pressure effect. PLOS Biology 16:e2005987.
