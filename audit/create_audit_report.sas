libname vipgpub postgres schema=public database=SharedServices server='172.32.36.53' port=5431 user=dbmsowner password='dSeDULMQEff2mMwKvBLQoLPqzJ0R3SN';

%macro create_audit_report();
	%let auditTableNames=;
	%let tableName=;
	%let consolidatedTableNames=;

	proc sql noprint;
		select memname into :auditTableNames separated by ' ' 
		from dictionary.tables
		where libname='VIPGPUB' and memname contains '_AUD';
	quit;
	
	%put DEBUG: Table names: &auditTableNames.;
	
	%do i=1 %to %sysfunc(countw(&auditTableNames.,' '));
		%let tableName=%scan(&auditTableNames.,&i.,' ');		
		%let consolidatedTableNames=%substr(&tableName.,1,27)_cns;
		%let idColumn=%sysfunc(tranwrd(&tableName.,AUD,ID));

		%put DEBUG: Audit table name = &auditTableNames.; 
		%put DEBUG: ID Column = &idColumn.;

		data &consolidatedTableNames.;
			set vipgpub.&tableName.;
			by &idColumn. version;
			if operation='INSERT' then output;
			if operation='DELETE' then output;
			if operation='UPDATE' and last.&idColumn. then output;
		run;
				
		proc export data=&consolidatedTableNames. dbms=csv outfile=%tslit(/opt/sasinside/vicpol/temp/audit/&tableName..csv) replace;
		quit;		
	%end;
%mend;

%create_audit_report();