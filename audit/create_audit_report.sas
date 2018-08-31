/* ----------------------------------------------------------------------------------------------------------------- */
/* This macro is used to generate a CSV audit report of the changes to VI Entities, child entities and bridge tables */
/* ----------------------------------------------------------------------------------------------------------------- */

/* Configuration */

/* Configure this libname to point at the VI postgres database */
libname vipgpub postgres schema=public database=SharedServices server='172.32.36.53' port=5431 user=dbmsowner password='dSeDULMQEff2mMwKvBLQoLPqzJ0R3SN';

/* This macro var controls whether the report is generated for all days or just a single days worth of changes */
/* The accepted values are FULL or DAILY */
/* %let mode=DAILY; */
%let mode=FULL;

/* End of configuration */

%macro create_audit_report(mode);
	%let auditTableNames=;
	%let tableName=;
	%let consolidatedTableName=;
	%let cleansedMode=%upcase(&mode.);	

	%if %index(&cleansedMode.,FULL) = 0 %then %do;
		%let cleansedMode=DAILY;
	%end;	

	%put INFO: You are running in &cleansedMode. mode;

	proc sql noprint;
		select memname into :auditTableNames separated by ' ' 
		from dictionary.tables
		where libname='VIPGPUB' and memname contains '_AUD';
	quit;
	
	%put DEBUG: Table names: &auditTableNames.;
	
	%do i=1 %to %sysfunc(countw(&auditTableNames.,' '));
		%let tableName=%scan(&auditTableNames.,&i.,' ');		
		%let consolidatedTableName=%substr(&tableName.,1,27)_cns;
		%let idColumn=%sysfunc(tranwrd(&tableName.,AUD,ID));

		%put DEBUG: Audit table name = &auditTableNames.; 
		%put DEBUG: ID Column = &idColumn.;

		data &consolidatedTableName.;
			set vipgpub.&tableName. 
			%if &cleansedMode.='DAILY' %then %do;
				(where=(datepart(audit_stamp)=today()))
			%end;
			;
			by &idColumn. version;
			if operation='INSERT' then output;
			if operation='DELETE' then output;
			if operation='UPDATE' and last.&idColumn. then output;
		run;
				
		proc export data=&consolidatedTableName. dbms=csv outfile=%tslit(/opt/sasinside/vicpol/temp/audit/&tableName..csv) replace;
		quit;		

	%end;
%mend;

%create_audit_report(&mode.);