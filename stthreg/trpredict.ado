
capture program drop trpredict
program trpredict
 if (`"`e(cmd)'"'!="stthreg") error 301
 else Assign `0'
          
end



capture program drop Assign
program Assign

 

   if (`"`e(model_type)'"'=="standard"){  
     trpredicts `0'
   }
   else if (`"`e(model_type)'"'=="cure-rate"){
     trpredictc `0'
   }


end
