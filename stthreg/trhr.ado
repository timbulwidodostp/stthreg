capture program drop trhr
program trhr
 if (`"`e(cmd)'"'!="stthreg") error 301
 else Assign `0'
          
end







capture program drop Assign
program Assign

 

   if (`"`e(model_type)'"'=="standard"){  
     trhrs `0'
   }
   else if (`"`e(model_type)'"'=="cure-rate"){
     trhrc `0'
   }


end






