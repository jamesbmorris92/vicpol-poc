libname vipgpub postgres schema=public database=SharedServices server='172.32.36.53' port=5431 user=dbmsowner password='dSeDULMQEff2mMwKvBLQoLPqzJ0R3SN';

proc setinit;
quit;

%macro create_audit_report();
	proc sql noprint;
		select memname into :tablenames separated by ' ' 
		from dictionary.tables
		where libname='VIPGPUB' and memname contains '_AUD';
	quit;
	
	%put DEBUG: Tablesnames: &tablenames.;
	
	%do i=1 %to %sysfunc(countw(&tablenames.,' '));
		%put DEBUG: Tablename: %scan(&tablenames.,&i.,' ');
		%let tablename=%scan(&tablenames.,&i.,' ');		

		proc export data=vipgpub.&tablename. dbms=csv outfile=%tslit(/opt/sasinside/vicpol/temp/audit/&tablename..csv) replace;
		quit;		
	%end;
%mend;

%create_audit_report();