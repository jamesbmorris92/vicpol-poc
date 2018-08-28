DROP TABLE public.poc_ie_poi_audit CASCADE;

CREATE TABLE public.poc_ie_poi_audit(
    operation         character varying NOT NULL,
    audit_stamp             timestamp NOT NULL,
    audit_userid            text      NOT NULL,
    created_at_dttm timestamp without time zone NULL,
    created_by_user_id character varying(30) NULL,
    device_id character varying,
    firstname character varying,
    gender character varying(10),
    last_updated_at_dttm timestamp without time zone NULL,
    last_updated_by_user_id character varying(30) NULL,
    lastname character varying,
    poc_ie_person_of_int_id character varying(36) NULL,
    risk character varying,
    version bigint DEFAULT 1 NULL,
    "_ID_NUMERIC_PART_NO" bigint
);

CREATE OR REPLACE FUNCTION poc_ie_poi_audit_func() RETURNS TRIGGER AS $poc_ie_poi_audit$
    BEGIN
        --
        -- Create a row in poc_ie_poi_audit to reflect the operation performed on fdhdata.poc_ie_person_of_int,
        -- make use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO public.poc_ie_poi_audit SELECT TG_OP, now(), OLD.last_updated_by_user_id, OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO public.poc_ie_poi_audit SELECT TG_OP, now(), NEW.last_updated_by_user_id, NEW.*;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO public.poc_ie_poi_audit SELECT TG_OP, now(), NEW.last_updated_by_user_id, NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$poc_ie_poi_audit$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS poc_ie_poi_audit on fdhdata.poc_ie_person_of_int;

CREATE TRIGGER poc_ie_poi_audit
AFTER INSERT OR UPDATE OR DELETE ON fdhdata.poc_ie_person_of_int
    FOR EACH ROW EXECUTE PROCEDURE poc_ie_poi_audit_func();