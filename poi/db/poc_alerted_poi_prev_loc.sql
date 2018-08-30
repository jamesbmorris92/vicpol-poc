CREATE TABLE public.poc_alerted_poi_prev_loc (
    id character varying(100) NOT NULL,
    poc_ie_person_of_int_id character varying(36) NOT NULL,
    poc_ch_risk_zones_id bigint NOT NULL,
    latitude numeric(10,7),
    longitude numeric(10,7),
    device_id character varying,
	alerted_location_flg integer,
    "timestamp" timestamp without time zone
);