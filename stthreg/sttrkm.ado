
/* Plot observed vs. predicted survival curves by categories of X          */
capture program drop sttrkm
program define sttrkm



	Assign `0'
          
end



capture program drop Assign
program Assign
	st_is 2 analysis

	syntax [if] [,mu(varname)  ///
				lny0(varname)   ///
				lgtp(varname)   ///
				cure            ///
		noSHow				///
		SEParate			///
		*				///
        ]


   if ("`cure'"==""){ 
     sttrkms `0'
   }
   else {
     sttrkmc `0'
     
   }


end
