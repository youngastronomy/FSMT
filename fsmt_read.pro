function fsmt_read,ifile,data,header=header,AR=AR,Region=Region

h=headfits(ifile)
level=sxpar(h,'LEVEL')


data=readfits(ifile,header)

    NAR=sxpar(header,'ARNUM')
    AR_all=sxpar(header,'COMMENT')
    AR_all=AR_all[1:NAR]

    region=Intarr(4,NAR)
    AR=strarr(NAR)

  For k=0,NAR-1 do begin

  AR[k]=AR_all[k]
  temp=sxpar(header,(AR_all[k])[0])

  Region[*,k]=LONG(strsplit(temp,'/',/extract))
  print,region
  endfor



;if level ne 'C3' then   begin
;    
;     data=readfits(ifile,header)
;
;     AR='NONE'
;     
;     Region=[0,0,991,991]
;
;
;endif







return,data

end