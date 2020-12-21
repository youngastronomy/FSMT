function HSOS_search,SearchResult,T0=T0,T1=T1,TYPE=TYPE,LEVEL=LEVEL,AR=AR,download=download,curl_path=curl_path
if N_elements(type) eq 0 then type='FITS'
if N_elements(level) eq 0 then level='C2'
if N_elements(AR) eq 0 then AR='NONE'
if N_elements(download) eq 0 then download=0
if N_elements(curl_path) eq 0 then curl_path='C:\Users\Thomas\work\HSOS\FSMT\calibration\curl-7.61.0-win64-mingw\bin\'
if N_elements(server) eq 0 then server='https://sun10.bao.ac.cn/HSOS/FsmtQueryData'
if N_elements(T0) eq 0 then T0='2017-07-12T00:00:00'
if N_elements(T1) eq 0 then T1='2017-07-12T23:59:59'

T0=anytim(T0,/CCSDS)
T1=anytim(T1,/CCSDS)

date0=strmid(T0,0,10)
time0=strmid(T0,11,8)
date1=strmid(T1,0,10)
time1=strmid(T1,11,8)


if level eq 'C3' then begin
  query='date0='+date0+'&date1='+date1+'&time0='+time0+'&time1='+time1+'&type='+type+$
        '&ar='+AR+'&level='+level
        
   cmd=curl_path+'curl.exe -d '+'"'+query+'"'+' '+server
endif else begin
   query='date0='+date0+'&date1='+date1+'&time0='+time0+'&time1='+time1+'&type='+type+$
        '&ar=NONE&level='+level
        
   cmd=curl_path+'curl.exe -d '+'"'+query+'"'+' '+server

endelse  
  
  
   print,cmd
  print,'--------------'
  
  spawn,cmd,/log_output,result      
      
;  print,result
       
    
  if result eq 'NODATA' then begin
  item='NONE'
  print,'There is no data in this time range'
  endif else begin
  item=strsplit(result,'|',/extract)                 
  endelse
  
  if N_elements(item) GT 1 then item=item[uniq(item,sort(item))]
  
  print,item
  
  nn=N_elements(item)
  
if download eq 1  and item[0] ne 'NONE' then begin
  
  
   filedownload=''
   openw,lun,'download.log',/get_lun
   for kk=0,nn-1 do printf,lun,item[kk]
 
   free_lun,lun
   
   for kk=0,nn-1 do begin
    filedownload=filedownload+' -O '+item[kk]+' '
  endfor
  
 
  spawn,curl_path+'curl.exe -C - '+filedownload,/log_output
  ;print,curl_path+'curl.exe -C - '+filedownload  
endif else begin
   openw,lun,'download.log',/get_lun
   for kk=0,nn-1 do printf,lun,item[kk]
   free_lun,lun
   
 
endelse
;  
;
;  

SearchResult=item
  
return,SearchResult
  
end
