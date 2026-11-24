--
-- PostgreSQL database dump
--

\restrict 3LA4pXkBKe6TNEqWp2ayN3zzUrm8hIfWn6OYCSIqxG8uRvi1gyE2aTr9TKwEeKh

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-25 03:11:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 9 (class 2615 OID 39428)
-- Name: boundaries; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA boundaries;


ALTER SCHEMA boundaries OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 39427)
-- Name: processed; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA processed;


ALTER SCHEMA processed OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 39426)
-- Name: raw; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA raw;


ALTER SCHEMA raw OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 38338)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5854 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 39442)
-- Name: islamabad_boundary; Type: TABLE; Schema: boundaries; Owner: postgres
--

CREATE TABLE boundaries.islamabad_boundary (
    id integer NOT NULL,
    geom public.geometry(Polygon,4326),
    "shapeName" character varying,
    "shapeISO" character varying,
    "shapeID" character varying,
    "shapeGroup" character varying,
    "shapeType" character varying
);


ALTER TABLE boundaries.islamabad_boundary OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 39441)
-- Name: islamabad_boundary_id_seq; Type: SEQUENCE; Schema: boundaries; Owner: postgres
--

CREATE SEQUENCE boundaries.islamabad_boundary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE boundaries.islamabad_boundary_id_seq OWNER TO postgres;

--
-- TOC entry 5855 (class 0 OID 0)
-- Dependencies: 229
-- Name: islamabad_boundary_id_seq; Type: SEQUENCE OWNED BY; Schema: boundaries; Owner: postgres
--

ALTER SEQUENCE boundaries.islamabad_boundary_id_seq OWNED BY boundaries.islamabad_boundary.id;


--
-- TOC entry 231 (class 1259 OID 39477)
-- Name: islamabad_facilities; Type: TABLE; Schema: processed; Owner: postgres
--

CREATE TABLE processed.islamabad_facilities (
    id character varying,
    geom public.geometry(Point,4326),
    "@id" character varying,
    access character varying,
    "addr:block" character varying,
    "addr:city" character varying,
    "addr:city:ar" character varying,
    "addr:city:en" character varying,
    "addr:city:fr" character varying,
    "addr:city:ks" character varying,
    "addr:city:pa" character varying,
    "addr:city:pnb" character varying,
    "addr:city:ps" character varying,
    "addr:city:sd" character varying,
    "addr:city:ur" character varying,
    "addr:floor" character varying,
    "addr:full" character varying,
    "addr:housename" character varying,
    "addr:housenumber" character varying,
    "addr:place" character varying,
    "addr:postcode" character varying,
    "addr:street" character varying,
    "addr:street:ur" character varying,
    air_conditioning character varying,
    alt_name character varying,
    "alt_name:ar" character varying,
    "alt_name:ur" character varying,
    "alt_name:zh-Hans" character varying,
    amenity character varying,
    area character varying,
    atm character varying,
    barrier character varying,
    boundary character varying,
    brand character varying,
    "brand:ar" character varying,
    "brand:pnb" character varying,
    "brand:ps" character varying,
    "brand:ur" character varying,
    "brand:wikidata" character varying,
    "brand:wikipedia" character varying,
    "brand:wikipedia:ar" character varying,
    "brand:wikipedia:pnb" character varying,
    "brand:wikipedia:ps" character varying,
    "brand:wikipedia:ur" character varying,
    building character varying,
    "building:levels" character varying,
    check_date date,
    "contact:facebook" character varying,
    created_by character varying,
    denomination character varying,
    description character varying,
    dispensing character varying,
    dog character varying,
    drive_through character varying,
    education character varying,
    email character varying,
    emergency character varying,
    fax character varying,
    fence_type character varying,
    "generator:source" character varying,
    grades character varying,
    healthcare character varying,
    "healthcare:speciality" character varying,
    height character varying,
    indoor character varying,
    institute character varying,
    internet_access character varying,
    "internet_access:fee" character varying,
    "internet_access:ssid" character varying,
    is_in character varying,
    "isced:level" character varying,
    landuse character varying,
    layer character varying,
    leisure character varying,
    level character varying,
    max_age character varying,
    min_age character varying,
    mobile character varying,
    name character varying,
    "name:ace" character varying,
    "name:ar" character varying,
    "name:de" character varying,
    "name:en" character varying,
    "name:es" character varying,
    "name:etymology" character varying,
    "name:etymology:wikidata" character varying,
    "name:etymology:wikipedia" character varying,
    "name:hi" character varying,
    "name:ml" character varying,
    "name:pa" character varying,
    "name:pnb" character varying,
    "name:ps" character varying,
    "name:ur" character varying,
    "not:name" character varying,
    note character varying,
    official_name character varying,
    opening_hours character varying,
    "opening_hours:covid19" character varying,
    operator character varying,
    "operator:en" character varying,
    "operator:short" character varying,
    "operator:type" character varying,
    "operator:ur" character varying,
    "operator:wikidata" character varying,
    ownership character varying,
    "payment:cash" character varying,
    "payment:credit_cards" character varying,
    "payment:visa" character varying,
    phone character varying,
    "playground:theme" character varying,
    power character varying,
    religion character varying,
    "school:gender" character varying,
    second_hand character varying,
    short_name character varying,
    source character varying,
    sport character varying,
    stroller character varying,
    surface character varying,
    technology character varying,
    "toilets:wheelchair" character varying,
    tourism character varying,
    type character varying,
    university character varying,
    vaccination character varying,
    website character varying,
    wheelchair character varying,
    wikidata character varying,
    wikimedia_commons character varying,
    wikipedia character varying,
    "wikipedia:pnb" character varying,
    "@geometry" character varying,
    facility_category character varying(50),
    facility_id bigint NOT NULL
);


ALTER TABLE processed.islamabad_facilities OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 39536)
-- Name: islamabad_facilities_facility_id_seq; Type: SEQUENCE; Schema: processed; Owner: postgres
--

ALTER TABLE processed.islamabad_facilities ALTER COLUMN facility_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME processed.islamabad_facilities_facility_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 39525)
-- Name: vw_islamabad_facilities; Type: VIEW; Schema: processed; Owner: postgres
--

CREATE VIEW processed.vw_islamabad_facilities AS
 SELECT name,
    amenity,
    leisure,
    facility_category,
    geom,
    facility_id
   FROM processed.islamabad_facilities;


ALTER VIEW processed.vw_islamabad_facilities OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 39429)
-- Name: islamabad_facilities; Type: TABLE; Schema: raw; Owner: postgres
--

CREATE TABLE raw.islamabad_facilities (
    id character varying NOT NULL,
    geom public.geometry(Point,4326),
    "@id" character varying,
    access character varying,
    "addr:block" character varying,
    "addr:city" character varying,
    "addr:city:ar" character varying,
    "addr:city:en" character varying,
    "addr:city:fr" character varying,
    "addr:city:ks" character varying,
    "addr:city:pa" character varying,
    "addr:city:pnb" character varying,
    "addr:city:ps" character varying,
    "addr:city:sd" character varying,
    "addr:city:ur" character varying,
    "addr:floor" character varying,
    "addr:full" character varying,
    "addr:housename" character varying,
    "addr:housenumber" character varying,
    "addr:place" character varying,
    "addr:postcode" character varying,
    "addr:street" character varying,
    "addr:street:ur" character varying,
    air_conditioning character varying,
    alt_name character varying,
    "alt_name:ar" character varying,
    "alt_name:ur" character varying,
    "alt_name:zh-Hans" character varying,
    amenity character varying,
    area character varying,
    atm character varying,
    barrier character varying,
    boundary character varying,
    brand character varying,
    "brand:ar" character varying,
    "brand:pnb" character varying,
    "brand:ps" character varying,
    "brand:ur" character varying,
    "brand:wikidata" character varying,
    "brand:wikipedia" character varying,
    "brand:wikipedia:ar" character varying,
    "brand:wikipedia:pnb" character varying,
    "brand:wikipedia:ps" character varying,
    "brand:wikipedia:ur" character varying,
    building character varying,
    "building:levels" character varying,
    check_date date,
    "contact:facebook" character varying,
    created_by character varying,
    denomination character varying,
    description character varying,
    dispensing character varying,
    dog character varying,
    drive_through character varying,
    education character varying,
    email character varying,
    emergency character varying,
    fax character varying,
    fence_type character varying,
    "generator:source" character varying,
    grades character varying,
    healthcare character varying,
    "healthcare:speciality" character varying,
    height character varying,
    indoor character varying,
    institute character varying,
    internet_access character varying,
    "internet_access:fee" character varying,
    "internet_access:ssid" character varying,
    is_in character varying,
    "isced:level" character varying,
    landuse character varying,
    layer character varying,
    leisure character varying,
    level character varying,
    max_age character varying,
    min_age character varying,
    mobile character varying,
    name character varying,
    "name:ace" character varying,
    "name:ar" character varying,
    "name:de" character varying,
    "name:en" character varying,
    "name:es" character varying,
    "name:etymology" character varying,
    "name:etymology:wikidata" character varying,
    "name:etymology:wikipedia" character varying,
    "name:hi" character varying,
    "name:ml" character varying,
    "name:pa" character varying,
    "name:pnb" character varying,
    "name:ps" character varying,
    "name:ur" character varying,
    "not:name" character varying,
    note character varying,
    official_name character varying,
    opening_hours character varying,
    "opening_hours:covid19" character varying,
    operator character varying,
    "operator:en" character varying,
    "operator:short" character varying,
    "operator:type" character varying,
    "operator:ur" character varying,
    "operator:wikidata" character varying,
    ownership character varying,
    "payment:cash" character varying,
    "payment:credit_cards" character varying,
    "payment:visa" character varying,
    phone character varying,
    "playground:theme" character varying,
    power character varying,
    religion character varying,
    "school:gender" character varying,
    second_hand character varying,
    short_name character varying,
    source character varying,
    sport character varying,
    stroller character varying,
    surface character varying,
    technology character varying,
    "toilets:wheelchair" character varying,
    tourism character varying,
    type character varying,
    university character varying,
    vaccination character varying,
    website character varying,
    wheelchair character varying,
    wikidata character varying,
    wikimedia_commons character varying,
    wikipedia character varying,
    "wikipedia:pnb" character varying,
    "@geometry" character varying
);


ALTER TABLE raw.islamabad_facilities OWNER TO postgres;

--
-- TOC entry 5684 (class 2604 OID 39445)
-- Name: islamabad_boundary id; Type: DEFAULT; Schema: boundaries; Owner: postgres
--

ALTER TABLE ONLY boundaries.islamabad_boundary ALTER COLUMN id SET DEFAULT nextval('boundaries.islamabad_boundary_id_seq'::regclass);


--
-- TOC entry 5692 (class 2606 OID 39448)
-- Name: islamabad_boundary islamabad_boundary_pkey; Type: CONSTRAINT; Schema: boundaries; Owner: postgres
--

ALTER TABLE ONLY boundaries.islamabad_boundary
    ADD CONSTRAINT islamabad_boundary_pkey PRIMARY KEY (id);


--
-- TOC entry 5695 (class 2606 OID 39545)
-- Name: islamabad_facilities pk_islamabad_facilities; Type: CONSTRAINT; Schema: processed; Owner: postgres
--

ALTER TABLE ONLY processed.islamabad_facilities
    ADD CONSTRAINT pk_islamabad_facilities PRIMARY KEY (facility_id);


--
-- TOC entry 5689 (class 2606 OID 39436)
-- Name: islamabad_facilities islamabad_facilities_pkey; Type: CONSTRAINT; Schema: raw; Owner: postgres
--

ALTER TABLE ONLY raw.islamabad_facilities
    ADD CONSTRAINT islamabad_facilities_pkey PRIMARY KEY (id);


--
-- TOC entry 5690 (class 1259 OID 39467)
-- Name: idx_islamabad_boundary_geom; Type: INDEX; Schema: boundaries; Owner: postgres
--

CREATE INDEX idx_islamabad_boundary_geom ON boundaries.islamabad_boundary USING gist (geom);


--
-- TOC entry 5693 (class 1259 OID 39482)
-- Name: idx_islamabad_facilities_geom; Type: INDEX; Schema: processed; Owner: postgres
--

CREATE INDEX idx_islamabad_facilities_geom ON processed.islamabad_facilities USING gist (geom);


-- Completed on 2026-11-25 03:11:39

--
-- PostgreSQL database dump complete
--

\unrestrict 3LA4pXkBKe6TNEqWp2ayN3zzUrm8hIfWn6OYCSIqxG8uRvi1gyE2aTr9TKwEeKh

