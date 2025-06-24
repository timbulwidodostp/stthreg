
capture program drop stthreg
program stthreg
  version 9.0
  if `"`0'"'=="" {
    if (`"`e(cmd)'"'!="stthreg") error 301
    Replay `0'

  }
  else Assign `0'
          
end





capture program drop Assign
program Assign, eclass sortpreserve


   
   
   syntax [if] [in]                 ///
              ,     ///
              [lny0(varlist)]                 ///
              [Mu(varlist)]                 ///specify covariates for mu
	      [lgtp(varlist)]                 ///specify covariates for lgtp
	      [cure]                        ///specify if is for the cure-rate model
	      [noCONStant noLOg]                  /// -ml model- options
              [init(string)]                ///
	      [Level(cilevel)]                   ///
              [DEbug]                                  ///
              [*  ]                               /// -mlopts- options


   if("`cure'"==""){  
     stthregs `0'
   }
   else{
     stthregc `0'
   }


	  
	  ereturn local cmd stthreg 

end


capture program drop Replay
program Replay

      syntax [, Level(cilevel)]
      ml display, level(`level')
end


