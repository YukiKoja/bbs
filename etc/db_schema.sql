--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: sample; Type: TABLE; Schema: public; Owner: koja; Tablespace: 
--

CREATE TABLE sample (
    name text,
    comment text,
    create_timestamp timestamp without time zone,
    youtube text,
    tag text,
    tag2 text
);


ALTER TABLE public.sample OWNER TO koja;

--
-- Name: test; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE test (
    name text,
    comment text,
    create_timestamp timestamp without time zone,
    youtube text,
    tag text,
    tag2 text,
    thread_id integer
);


ALTER TABLE public.test OWNER TO postgres;

--
-- Name: thread; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE thread (
    name text,
    thread_id integer NOT NULL
);


ALTER TABLE public.thread OWNER TO postgres;

--
-- Name: thread_thread_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE thread_thread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.thread_thread_id_seq OWNER TO postgres;

--
-- Name: thread_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE thread_thread_id_seq OWNED BY thread.thread_id;


--
-- Name: thread_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY thread ALTER COLUMN thread_id SET DEFAULT nextval('thread_thread_id_seq'::regclass);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

