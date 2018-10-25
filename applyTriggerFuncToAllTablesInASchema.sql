DO $$
	DECLARE 
	account varchar := 'Priceadmin';
	logSchemaName varchar := 'logging';
	implementSchemaName varchar := 'pricing';
	logTableName varchar := 'loggingchangeshistory';
	triggerFunction varchar := 'changestrigger';
	triggerNameInTable varchar := 'historytrigger';
	_toexe text;
	
BEGIN 
	-- Create Schema for logging
	CREATE SCHEMA IF NOT EXISTS logging AUTHORIZATION "Priceadmin";
	EXECUTE 'CREATE SCHEMA IF NOT EXISTS ' || logSchemaName || ' AUTHORIZATION "' || account || '";';
	
	-- Create Table
 	EXECUTE '
 	 CREATE TABLE IF NOT EXISTS ' || logSchemaName || '.' || logTableName || '(
 			 '|| logtableName || 'id  SERIAL 	 PRIMARY KEY,
 			 tstamp                    timestamp  DEFAULT now(),
 			 schemaname           	  text,
 			 tabname                   text,
 			 operation                 text,
 			 who             		  text,        
 			 newval                    json,
 			 oldval                    json
 	 );' ;

-- 	INSERT INTO pricing.alltablelisttmp(cmd)
	FOR _toexe IN SELECT 'CREATE TRIGGER '|| triggerNameInTable || ' AFTER INSERT OR DELETE OR UPDATE ON ' 
		          || p.schemaname || '.' || p.tablename || ' FOR EACH ROW EXECUTE PROCEDURE ' || implementSchemaName || '.' || triggerFunction || '();'
	FROM pg_tables p
	WHERE p.schemaname = 'pricing'
	LOOP 
		EXECUTE _toexe;
	END LOOP;

END;
$$
