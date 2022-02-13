#INCLUDE 'RWMAKE.CH'  

USER FUNCTION TiraAcento(_cStrIn)     


Local _cStrOut, i
_cStrOut := ''
IF len(_cStrIn) > 0
  For i := 1 to len(_cStrIn)
    if   substr(_cStrIn,i,1) $ "��������"
      _cStrOut := _cStrOut + 'a'
    elseif substr(_cStrIn,i,1) $ "������"
      _cStrOut := _cStrOut + 'e'
    elseif substr(_cStrIn,i,1) $ "����"
      _cStrOut := _cStrOut + 'i'
    elseif substr(_cStrIn,i,1) $ "��������"
      _cStrOut := _cStrOut + 'o'
    elseif substr(_cStrIn,i,1) $ "�������"
      _cStrOut := _cStrOut + 'u'
    elseif substr(_cStrIn,i,1) $ "��"
      _cStrOut := _cStrOut + 'c'
    elseif substr(_cStrIn,i,1) $ "�"+chr(167)+chr(176)
      _cStrOut := _cStrOut + '.'
    elseif substr(_cStrIn,i,1) $ "�"+chr(166)
      _cStrOut := _cStrOut + 'a.'     
    elseif substr(_cStrIn,i,1) $ "�"
      _cStrOut := _cStrOut + 'E'    
    elseif substr(_cStrIn,i,1) $ "�"
      _cStrOut := _cStrOut + 'e'
    elseif substr(_cStrIn,i,1) $ "�"
      _cStrOut := _cStrOut + 'E'   
    elseif substr(_cStrIn,i,1) $ "'"
      _cStrOut := _cStrOut + ' '  
    elseif substr(_cStrIn,i,1) $ "?"
      _cStrOut := _cStrOut + 'C' 
    elseif substr(_cStrIn,i,1) $ "�"  
      _cStrOut := _cStrOut + 'C'  
    elseif substr(_cStrIn,i,1) $ ","  
      _cStrOut := _cStrOut + ' '    
    elseif substr(_cStrIn,i,1) $ "�"    
      _cStrOut := _cStrOut + 'Y' 
    elseif substr(_cStrIn,i,1) $ "�"    
      _cStrOut := _cStrOut + 'O'       
    elseif substr(_cStrIn,i,1) $ "�"
      _cStrOut := _cStrOut + 'C'
    elseif substr(_cStrIn,i,1) $ "�"      
      _cStrOut := _cStrOut + 'O'
    elseif substr(_cStrIn,i,1) $ "�"  
     _cStrOut := _cStrOut + 'I'   
    elseif substr(_cStrIn,i,1) $ "�"
     _cStrOut := _cStrOut + ''    
    elseif substr(_cStrIn,i,1) $ "`"
     _cStrOut := _cStrOut + ''  
    elseif substr(_cStrIn,i,1) $ "�" 
     _cStrOut := _cStrOut + 'O'  
    else                     

     _cStrOut := _cStrOut + substr(_cStrIn,i,1)
    endif
  next
ENDIF                                    
_cStrOut := Upper(_cStrOut)
return _cStrOut