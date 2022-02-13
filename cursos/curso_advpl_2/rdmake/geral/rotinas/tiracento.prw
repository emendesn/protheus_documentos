#INCLUDE 'RWMAKE.CH'  

USER FUNCTION TiraAcento(_cStrIn)     


Local _cStrOut, i
_cStrOut := ''
IF len(_cStrIn) > 0
  For i := 1 to len(_cStrIn)
    if   substr(_cStrIn,i,1) $ "¡¿¬√·‡‚„"
      _cStrOut := _cStrOut + 'a'
    elseif substr(_cStrIn,i,1) $ "…» ÈËÍ"
      _cStrOut := _cStrOut + 'e'
    elseif substr(_cStrIn,i,1) $ "ÕÃÌÏ"
      _cStrOut := _cStrOut + 'i'
    elseif substr(_cStrIn,i,1) $ "”“‘’ÛÚÙı"
      _cStrOut := _cStrOut + 'o'
    elseif substr(_cStrIn,i,1) $ "⁄Ÿ€‹˙˘¸"
      _cStrOut := _cStrOut + 'u'
    elseif substr(_cStrIn,i,1) $ "«Á"
      _cStrOut := _cStrOut + 'c'
    elseif substr(_cStrIn,i,1) $ "∫"+chr(167)+chr(176)
      _cStrOut := _cStrOut + '.'
    elseif substr(_cStrIn,i,1) $ "™"+chr(166)
      _cStrOut := _cStrOut + 'a.'     
    elseif substr(_cStrIn,i,1) $ "ê"
      _cStrOut := _cStrOut + 'E'    
    elseif substr(_cStrIn,i,1) $ "È"
      _cStrOut := _cStrOut + 'e'
    elseif substr(_cStrIn,i,1) $ "…"
      _cStrOut := _cStrOut + 'E'   
    elseif substr(_cStrIn,i,1) $ "'"
      _cStrOut := _cStrOut + ' '  
    elseif substr(_cStrIn,i,1) $ "?"
      _cStrOut := _cStrOut + 'C' 
    elseif substr(_cStrIn,i,1) $ "Ä"  
      _cStrOut := _cStrOut + 'C'  
    elseif substr(_cStrIn,i,1) $ ","  
      _cStrOut := _cStrOut + ' '    
    elseif substr(_cStrIn,i,1) $ "›"    
      _cStrOut := _cStrOut + 'Y' 
    elseif substr(_cStrIn,i,1) $ "Ü"    
      _cStrOut := _cStrOut + 'O'       
    elseif substr(_cStrIn,i,1) $ "ù"
      _cStrOut := _cStrOut + 'C'
    elseif substr(_cStrIn,i,1) $ "Æ"      
      _cStrOut := _cStrOut + 'O'
    elseif substr(_cStrIn,i,1) $ "ô"  
     _cStrOut := _cStrOut + 'I'   
    elseif substr(_cStrIn,i,1) $ "ã"
     _cStrOut := _cStrOut + ''    
    elseif substr(_cStrIn,i,1) $ "`"
     _cStrOut := _cStrOut + ''  
    elseif substr(_cStrIn,i,1) $ "Ö" 
     _cStrOut := _cStrOut + 'O'  
    else                     

     _cStrOut := _cStrOut + substr(_cStrIn,i,1)
    endif
  next
ENDIF                                    
_cStrOut := Upper(_cStrOut)
return _cStrOut