SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: page_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_revisions (
    id integer NOT NULL,
    content text NOT NULL,
    slug text NOT NULL,
    title text NOT NULL,
    page_id integer NOT NULL,
    comment text,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT comment_not_too_long CHECK ((char_length(comment) <= 50)),
    CONSTRAINT content_not_too_long CHECK ((char_length(content) <= 1000000)),
    CONSTRAINT slug_not_empty CHECK ((slug <> ''::text)),
    CONSTRAINT slug_not_too_long CHECK ((char_length(slug) <= 1000)),
    CONSTRAINT slug_uses_uri_unreserved_characters CHECK ((slug ~ '\A[A-Za-z0-9\-_.!~*''()]*\Z'::text)),
    CONSTRAINT title_not_empty CHECK ((title <> ''::text)),
    CONSTRAINT title_not_too_long CHECK ((char_length(title) <= 1000))
);


--
-- Name: page_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.page_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.page_revisions_id_seq OWNED BY public.page_revisions.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    content text NOT NULL,
    slug text NOT NULL,
    title text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT content_not_too_long CHECK ((char_length(content) <= 1000000)),
    CONSTRAINT slug_not_empty CHECK ((slug <> ''::text)),
    CONSTRAINT slug_not_too_long CHECK ((char_length(slug) <= 1000)),
    CONSTRAINT slug_uses_uri_unreserved_characters CHECK ((slug ~ '\A[A-Za-z0-9\-_.!~*''()]*\Z'::text)),
    CONSTRAINT title_not_empty CHECK ((title <> ''::text)),
    CONSTRAINT title_not_too_long CHECK ((char_length(title) <= 1000))
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: page_revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_revisions ALTER COLUMN id SET DEFAULT nextval('public.page_revisions_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: page_revisions page_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_revisions
    ADD CONSTRAINT page_revisions_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: pages_slug_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX pages_slug_idx ON public.pages USING btree (lower(slug));


--
-- Name: page_revisions page_revisions_page_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_revisions
    ADD CONSTRAINT page_revisions_page_id_fkey FOREIGN KEY (page_id) REFERENCES public.pages(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190104195046'),
('20190201234142'),
('20190208053352');


