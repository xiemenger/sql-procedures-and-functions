DO $$
	DECLARE 
	account varchar := 'user';
	logSchemaName varchar := 'logging';
	implementSchemaName varchar := 'xxx';
	logTableName varchar := 'yyy';
	triggerFunction varchar := 'xx';
	triggerNameInTable varchar := 'uuu';
	_toexe text;
	
BEGIN 
	-- Create Schema for logging
	-- CREATE SCHEMA IF NOT EXISTS logging AUTHORIZATION "Priceadmin";
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
	 
	-- Create Trigger Function
	CREATE OR REPLACE FUNCTION pricing.changestrigger2()
		RETURNS trigger
		LANGUAGE 'plpgsql'
		VOLATILE
		COST 100
	AS $BODY$
	DECLARE 
		HISTORYTABLENAME varchar := logSchemaName || '.' || logTableName;
		USERPREFIX varchar := 'modifiedby';
		query varchar := current_query();
		op_user varchar;
		pos integer;
	BEGIN
		CASE TG_OP
		WHEN 'INSERT' THEN
			INSERT INTO logging.pricingchangeshistory(tstamp, schemaname, tabname, operation, who, newval)
			VALUES (now(), TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP, new.modifiedby, row_to_json(NEW));																			   
			RETURN NEW;																							  

		WHEN 'UPDATE' THEN
			INSERT INTO logging.pricingchangeshistory(tstamp, schemaname, tabname, operation, who, newval, oldval)
			VALUES (now(), TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP, new.modifiedby, row_to_json(NEW), row_to_json(OLD));
			RETURN NEW;

		WHEN'DELETE' THEN			
			pos := position(userprefix IN query);										  
			IF pos != 0 THEN
				query := substring(query, pos + char_length(USERPREFIX) + 4);
				pos := GREATEST(0, position(')' IN query) - 2);										  
				op_user := substring(query, 0, pos);									  	
			END IF;																										
			INSERT INTO logging.pricingchangeshistory(tstamp, schemaname, tabname, operation, who, oldval)
			VALUES (now(), TG_TABLE_SCHEMA, TG_TABLE_NAME, TG_OP, op_user, row_to_json(OLD));
			RETURN OLD;	

		END CASE;
	END;
	$BODY$;


END;
$$
