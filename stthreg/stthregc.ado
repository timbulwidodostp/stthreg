
capture program drop stthregc 
program stthregc,properties(ml_score or svyb svyj svyr swml)
  version 9.0
  if `"`0'"'=="" {
    if (`"`e(cmd)'"'!="stthregc") error 301
    Replay `0'

  }
  else Estimate `0'
          
end





capture program drop Estimate
program Estimate, eclass sortpreserve
  version 9.0


   st_is 2 analysis

   syntax [if] [in]                 ///
              ,     ///
              [lny0(varlist)]                 ///
              [Mu(varlist)]                 ///specify covariates for mu
              [lgtp(varlist)]                 ///specify covariates for lgtp
              [cure]                        ///specify if is for the cure-rate model
              [noCONStant noLOg]                  /// -ml model- options
              [init(string)]                ///
	      [Level(cilevel)]                   ///
              [*  ]                               /// -mlopts- options








   local studytime "_t"


   
   global time_combination "#ML_y1"


  
   
   
   global time_combination = subinstr(subinstr("$time_combination","%","\`",.),"#","\$",.)




 ************************************************** 

      // mark the estimation sample
	  marksample touse
	  // check syntax
	  mlopts mlopts, `options'
	  local cns `s(constraints)'



	  if "`mu'"!="" {
			  local varlist_mu `mu'
	  }
	  if "`lgtp'"!="" {
			  local varlist_lgtp `lgtp'
	  }
	  *else    local varlist_mu `varlist'
	  if "`lny0'"!="" {
			  local varlist_lny0 `lny0'
	  }
	  if "`studytime'"!="" {
			  local studytime `studytime'
	  }
          local failure _d

	  if "`init'"!="" {
			  local init_command `init'
	  } 	 
 

  




	  *display the summary of the survival-time variables
	  st_show `show'

	  //fit the full model

	

 

          ml model lf stthregc_lf (lny0: `studytime' `failure' = `varlist_lny0',`constant') ///
                               (mu: `varlist_mu', `constant')                  ///
                               (lgtp: `varlist_lgtp', `constant')                  ///
			    if `touse',                     ///
			   maximize                     ///
			   init(`init_command') waldtest(-3) `mlopts' `log'
			   
			   ml query 

          
          
	  // save a title for -Replay- and the name of this command
	  ereturn local title "Threshold Regression Cure Rate Model Estimates"
	  
	  ereturn local cmd stthregc 
          ereturn local model_type cure-rate
          ereturn local stthregc_para "`0'"
	  Replay , level(`level') 
	  






end


capture program drop Replay
program Replay

      syntax [, Level(cilevel)]
      ml display, level(`level')
end


