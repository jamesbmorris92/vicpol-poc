--Creates a function that selects POC tables and creates audit tables for each of them.
CREATE OR REPLACE FUNCTION create_audit_tables() RETURNS void AS $$
DECLARE 
    curs CURSOR FOR 
        SELECT 
            table_name 
        FROM information_schema.tables 
        WHERE 
            table_schema='fdhdata'
--Here we create a cursor to loop over by finding POC tables to loop over. We identify POC tables by the patterns described in the line below.
            AND (table_name LIKE '%poc_%' OR table_name LIKE '%neo_invest%' OR table_name LIKE '%vp_ie_warrant%' OR table_name LIKE '%vp_ch_ninv%');
BEGIN
    FOR curs_val IN curs LOOP
--Drop audit table, this is only used as a convenience during development and should be commented out once stable.
--        EXECUTE 'DROP TABLE IF EXISTS public.' || curs_val.table_name || '_aud CASCADE;';
--Create audit table as duplicate of table it will be auditting with no data in.
        EXECUTE 'CREATE TABLE public.'|| curs_val.table_name || '_aud AS SELECT * FROM fdhdata.' || curs_val.table_name || ' WITH NO DATA;';
--Alter the table to contain a column that holds what action was performed to entity / child entity either INSERT UPDATE OR DELETE.
        EXECUTE 'ALTER TABLE public.'|| curs_val.table_name || '_aud ADD COLUMN operation character varying NOT NULL, ADD COLUMN audit_stamp timestamp NOT NULL;';
--For each table create a trigger function that adds a row to the audit table following either an INSERT UPDATE or DELETE to the entity / child entity table. 
        EXECUTE 'CREATE OR REPLACE FUNCTION ' || curs_val.table_name || '() RETURNS TRIGGER AS $'|| curs_val.table_name ||'$ 
             BEGIN 
                IF (TG_OP =' || $token$'DELETE'$token$ || ') THEN 
                    INSERT INTO public.' || curs_val.table_name || '_aud SELECT OLD.*, TG_OP, now();
                    RETURN OLD;
                END IF;
                IF (TG_OP =' || $token$'UPDATE'$token$ || ') THEN
                    INSERT INTO public.' || curs_val.table_name || '_aud SELECT NEW.*, TG_OP, now();
                    RETURN NEW;
                END IF;
                IF (TG_OP =' || $token$'INSERT'$token$ || ') THEN 
                    INSERT INTO public.' || curs_val.table_name || '_aud SELECT NEW.*, TG_OP, now();
                    RETURN NEW;
                END IF;
                RETURN NULL;
            END;
        $' || curs_val.table_name || '$ LANGUAGE plpgsql;';
--Drop trigger, this is only used a convenience during development and should be commented out once stable.
--        EXECUTE 'DROP TRIGGER IF EXISTS ' || curs_val.table_name || '_trg on fdhdata.' || curs_val.table_name || ';';         
--Create the trigger and apply it to the entity / child entitity table. 
        EXECUTE 'CREATE TRIGGER ' || curs_val.table_name || '_trg AFTER INSERT OR UPDATE OR DELETE ON fdhdata.' || curs_val.table_name || ' FOR EACH ROW EXECUTE PROCEDURE ' || curs_val.table_name || '();';
    END LOOP;
END;    
$$ LANGUAGE plpgsql;
--Run this function
select create_audit_tables();