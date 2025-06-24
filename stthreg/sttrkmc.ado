
capture program drop sttrkmc
program define sttrkmc
version 10.0

	st_is 2 analysis

	syntax [if] [,mu(varname)  ///
				lny0(varname)   ///
				lgtp(varname)   ///
		noSHow				///
		SEParate			///
                cure                            ///
		*				///
        ]


	_gs_byopts_combine byopts options : `"`options'"'

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	tempvar touse
	st_smpl `touse' `"`if'"' `"`in'"'  
	markout `touse' `by', strok

	preserve
	qui keep if `touse'


                if ("`lny0'"!="" & "`mu'"!="" & "`lgtp'"!="") {
		
		
			if "`mu'"=="`lny0'" & "`mu'"=="`lgtp'" {
	
			  local by = "`mu'"
			}
			else {
			  di as error "the categorical variable specified in lny0(), mu() and lgtp() must be the same"
			  error 197		
			}		
		
		
			*quietly:xi:stthregc,lny0(i.`by') mu(i.`by') lgtp(i.`by')
		}
		else if ("`lny0'"!="" & "`mu'"!="" & "`lgtp'"=="") {
		
			if "`lny0'"=="`mu'"{
	
			  local by = "`mu'"
			}
			else {
			  di as error "the categorical variable specified in lny0() and mu() must be the same"
			  error 197		
			}			
			*quietly:xi:stthregc,lny0(i.`by') mu(i.`by')
		}
		else if ("`lny0'"!="" & "`mu'"=="" & "`lgtp'"!="") {
			if "`lny0'"=="`lgtp'"{
	
			  local by = "`lny0'"
			}
			else {
			  di as error "the categorical variable specified in lny0() and lgtp() must be the same"
			  error 197		
			}			        
			*quietly:xi:stthregc,lny0(i.`by') lgtp(i.`by')
		}
		else if ("`lny0'"!="" & "`mu'"=="" & "`lgtp'"=="") {

	
			  local by = "`lny0'"
	
			*quietly:xi:stthregc,lny0(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"!="" & "`lgtp'"!="") {
			if "`mu'"=="`lgtp'"{
	
			  local by = "`mu'"
			}
			else {
			  di as error "the categorical variable specified in mu() and lgtp() must be the same"
			  error 197		
			}		
			*quietly:xi:stthregc,mu(i.`by') lgtp(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"!="" & "`lgtp'"=="") {
		    local by = "`mu'"
			*quietly:xi:stthregc,mu(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"=="" & "`lgtp'"!="") {
		    local by = "`lgtp'"
			*quietly:xi:stthregc,lgtp(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"=="" & "`lgtp'"=="") {
		    local by = ""
			*quietly:xi:stthregc,
		}	






	keep `by' _d _t _t0  _st




	if "`by'"=="" {

		tempvar obs
		quietly sts gen `obs'=s
		format `obs' %3.2f
		label var `obs' `"Observed"'	
		local obsplot (connected `obs' _t, sort connect(stairstep) `obsops')
		quietly:stthregc, 
		trpredictc,prefix(sttrkmc_)

		tempvar surv
		quietly gen `surv'=sttrkmc_S
		format `surv' %3.2f
		label var `surv' `"Predicted"'		

		local predplt (line `surv' _t, sort `predops')


	}
	else {
		local xlbl : variable label `by'
		if `"`xlbl'"'=="" { 
			local xlbl "`by'" 
		}
		local timelbl : variable label _t
	 

		quietly tab `by', gen(XCat)
		local numcat=r(r)
		local i 1
		while `i'<=`numcat' {
			if `i'>1 { 
				local xlist `xlist' XCat`i' 
			}
			local vlbl`i' : variable label XCat`i'
			local i=`i'+1
		}
		
		if "`separate'" != "" {
			local 0 , `options'
			syntax [, OBSOPts(string asis) * ]
			local obsops `obsopts'
			while `"`obsopts'"' != "" {
			    local 0 `", `options'"'
			    syntax [, OBSOPts(string asis) * ]
			    if `"`obsopts'"' != "" {
				local obsops `"`obsops' `obsopts'"'
			    }
			}
		}

		local i 1
		while `i'<=`numcat' {
			tempvar obsi
			local obslist `obslist' `obsi'
			quietly `vv' sts gen `obsi'=s if XCat`i'==1
			format `obsi' %3.2f
			tokenize `"`vlbl`i''"', parse("==")
			cap confirm number `3'
			if _rc==0 {
				if `3'==int(`3') {
					local int=int(`3')
					local vlbl`i' "`1' = `int'"
				}
			}
			else  	local vlbl`i' `"`1' = `3'"'
			label var `obsi' "Observed: `vlbl`i''"

			if "`separate'" == "" {
				local 0 , `options'
				syntax [, OBS`i'opts(string asis) * ]
				local obsops `obs`i'opts'
				while `"`obs`i'opts'"' != "" {
				    local 0 `", `options'"'
				    syntax [, OBS`i'opts(string asis) * ]
				    if `"`obs`i'opts'"' != "" {
					local obsops `"`obsops' `obs`i'opts'"'
				    }
				}
			}
			local obsplot `obsplot' (connected `obsi' _t, sort connect(stairstep) `obsops')
			*gen obs`i'=`obsi'
			local i=`i'+1
		}







 








                if ("`lny0'"!="" & "`mu'"!="" & "`lgtp'"!="") {
			
			quietly:xi:stthregc,lny0(i.`by') mu(i.`by') lgtp(i.`by')
		}
		else if ("`lny0'"!="" & "`mu'"!="" & "`lgtp'"=="") {
		
			quietly:xi:stthregc,lny0(i.`by') mu(i.`by')
		}
		else if ("`lny0'"!="" & "`mu'"=="" & "`lgtp'"!="") {
			quietly:xi:stthregc,lny0(i.`by') lgtp(i.`by')
		}
		else if ("`lny0'"!="" & "`mu'"=="" & "`lgtp'"=="") {
	
			quietly:xi:stthregc,lny0(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"!="" & "`lgtp'"!="") {
			quietly:xi:stthregc,mu(i.`by') lgtp(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"!="" & "`lgtp'"=="") {
		    quietly:xi:stthregc,mu(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"=="" & "`lgtp'"!="") {
		    quietly:xi:stthregc,lgtp(i.`by')
		}
		else if ("`lny0'"=="" & "`mu'"=="" & "`lgtp'"=="") {
		    quietly:xi:stthregc,
		}	


		trpredictc,prefix(sttrkmc_)


		if "`separate'" != "" {
			local 0 , `options'
			syntax [, PREDOPts(string asis) * ]
			local predops `predopts'
			while `"`predopts'"' != "" {
			    local 0 `", `options'"'
			    syntax [, PREDOPts(string asis) * ]
			    if `"`predopts'"' != "" {
				local predops `"`predops' `predopts'"'
			    }
			}
		}	


		local i 1
		while `i'<=`numcat'  {
			tempvar survi
			local svlist `svlist' `survi'
			quietly gen `survi'=sttrkmc_S if XCat`i'==1
			format `survi' %3.2f
			label var `survi' `"Predicted: `vlbl`i''"'
			if "`separate'" == "" {
				local 0 , `options'
				syntax [, PRED`i'opts(string asis) * ]
				local predops `pred`i'opts'
				while `"`pred`i'opts'"' != "" {
				    local 0 `", `options'"'
				    syntax [, PRED`i'opts(string asis) * ]
				    if `"`pred`i'opts'"' != "" {
					local predops `"`predops' `pred`i'opts'"'
				    }
				}
			}
			
			local predplt `predplt' (line `survi' _t, sort `predops')
			local i=`i'+1
		}


        }


	label var _t `"`timelbl'"'









	local yttl "Survival Probability"
	local xttl "analysis time"

	if "`separate'"!="" {
		local byopt by(`by', `byopts')
	}
	if `"`plot'`addplot'"' != "" {
		local draw nodraw
	}
	version 8: graph twoway			///
		`obsplot' `predplt',		///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		`draw'				///
		`byopt'				///
		`options'			///
	// blank
	if `"`plot'`addplot'"' != "" {
		restore
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}
end
