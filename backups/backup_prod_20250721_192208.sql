--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: allocation_backups_20250718_153625; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.allocation_backups_20250718_153625 (
    id integer,
    transaction_id character varying,
    budget_item_id integer,
    amount integer,
    created_at timestamp without time zone,
    backup_timestamp text,
    backup_reason text
);


ALTER TABLE public.allocation_backups_20250718_153625 OWNER TO nagaiku_user;

--
-- Name: allocation_backups_20250718_162116; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.allocation_backups_20250718_162116 (
    id integer,
    transaction_id character varying,
    budget_item_id integer,
    amount integer,
    created_at timestamp without time zone,
    backup_timestamp text,
    backup_reason text
);


ALTER TABLE public.allocation_backups_20250718_162116 OWNER TO nagaiku_user;

--
-- Name: allocation_backups_20250720_152333; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.allocation_backups_20250720_152333 (
    id integer,
    transaction_id character varying,
    budget_item_id integer,
    amount integer,
    created_at timestamp without time zone,
    backup_timestamp text,
    backup_reason text
);


ALTER TABLE public.allocation_backups_20250720_152333 OWNER TO nagaiku_user;

--
-- Name: allocation_backups_20250720_174830; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.allocation_backups_20250720_174830 (
    id integer,
    transaction_id character varying,
    budget_item_id integer,
    amount integer,
    created_at timestamp without time zone,
    backup_timestamp text,
    backup_reason text
);


ALTER TABLE public.allocation_backups_20250720_174830 OWNER TO nagaiku_user;

--
-- Name: allocations; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.allocations (
    id integer NOT NULL,
    transaction_id character varying,
    budget_item_id integer,
    amount integer NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.allocations OWNER TO nagaiku_user;

--
-- Name: allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.allocations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.allocations_id_seq OWNER TO nagaiku_user;

--
-- Name: allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.allocations_id_seq OWNED BY public.allocations.id;


--
-- Name: budget_items; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.budget_items (
    id integer NOT NULL,
    grant_id integer,
    name character varying NOT NULL,
    category character varying,
    budgeted_amount integer,
    remarks character varying
);


ALTER TABLE public.budget_items OWNER TO nagaiku_user;

--
-- Name: budget_items_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.budget_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budget_items_id_seq OWNER TO nagaiku_user;

--
-- Name: budget_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.budget_items_id_seq OWNED BY public.budget_items.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.categories OWNER TO nagaiku_user;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO nagaiku_user;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: dev_allocations; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.dev_allocations (
    id integer NOT NULL,
    transaction_id character varying,
    budget_item_id integer,
    amount integer NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.dev_allocations OWNER TO nagaiku_user;

--
-- Name: dev_allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.dev_allocations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dev_allocations_id_seq OWNER TO nagaiku_user;

--
-- Name: dev_allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.dev_allocations_id_seq OWNED BY public.dev_allocations.id;


--
-- Name: dev_budget_items; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.dev_budget_items (
    id integer NOT NULL,
    grant_id integer,
    name character varying NOT NULL,
    category character varying,
    budgeted_amount integer
);


ALTER TABLE public.dev_budget_items OWNER TO nagaiku_user;

--
-- Name: dev_budget_items_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.dev_budget_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dev_budget_items_id_seq OWNER TO nagaiku_user;

--
-- Name: dev_budget_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.dev_budget_items_id_seq OWNED BY public.dev_budget_items.id;


--
-- Name: dev_freee_syncs; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.dev_freee_syncs (
    id integer NOT NULL,
    sync_type character varying NOT NULL,
    start_date date,
    end_date date,
    status character varying,
    total_records integer,
    processed_records integer,
    created_records integer,
    updated_records integer,
    error_message text,
    created_at timestamp without time zone,
    completed_at timestamp without time zone
);


ALTER TABLE public.dev_freee_syncs OWNER TO nagaiku_user;

--
-- Name: dev_freee_syncs_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.dev_freee_syncs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dev_freee_syncs_id_seq OWNER TO nagaiku_user;

--
-- Name: dev_freee_syncs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.dev_freee_syncs_id_seq OWNED BY public.dev_freee_syncs.id;


--
-- Name: dev_freee_tokens; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.dev_freee_tokens (
    id integer NOT NULL,
    access_token text NOT NULL,
    refresh_token text NOT NULL,
    token_type character varying,
    expires_at timestamp without time zone NOT NULL,
    scope character varying,
    company_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.dev_freee_tokens OWNER TO nagaiku_user;

--
-- Name: dev_freee_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.dev_freee_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dev_freee_tokens_id_seq OWNER TO nagaiku_user;

--
-- Name: dev_freee_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.dev_freee_tokens_id_seq OWNED BY public.dev_freee_tokens.id;


--
-- Name: dev_grants; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.dev_grants (
    id integer NOT NULL,
    name character varying NOT NULL,
    total_amount integer,
    start_date date,
    end_date date,
    status character varying
);


ALTER TABLE public.dev_grants OWNER TO nagaiku_user;

--
-- Name: dev_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.dev_grants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dev_grants_id_seq OWNER TO nagaiku_user;

--
-- Name: dev_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.dev_grants_id_seq OWNED BY public.dev_grants.id;


--
-- Name: dev_transactions; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.dev_transactions (
    id character varying NOT NULL,
    journal_number integer,
    journal_line_number integer,
    date date NOT NULL,
    description text,
    amount integer NOT NULL,
    account character varying,
    supplier character varying,
    item character varying,
    memo character varying,
    remark character varying,
    department character varying,
    management_number character varying,
    raw_data text,
    created_at timestamp without time zone
);


ALTER TABLE public.dev_transactions OWNER TO nagaiku_user;

--
-- Name: freee_syncs; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.freee_syncs (
    id integer NOT NULL,
    sync_type character varying NOT NULL,
    start_date date,
    end_date date,
    status character varying,
    total_records integer,
    processed_records integer,
    created_records integer,
    updated_records integer,
    error_message text,
    created_at timestamp without time zone,
    completed_at timestamp without time zone
);


ALTER TABLE public.freee_syncs OWNER TO nagaiku_user;

--
-- Name: freee_syncs_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.freee_syncs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.freee_syncs_id_seq OWNER TO nagaiku_user;

--
-- Name: freee_syncs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.freee_syncs_id_seq OWNED BY public.freee_syncs.id;


--
-- Name: freee_tokens; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.freee_tokens (
    id integer NOT NULL,
    access_token text NOT NULL,
    refresh_token text NOT NULL,
    token_type character varying,
    expires_at timestamp without time zone NOT NULL,
    scope character varying,
    company_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_active boolean
);


ALTER TABLE public.freee_tokens OWNER TO nagaiku_user;

--
-- Name: freee_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.freee_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.freee_tokens_id_seq OWNER TO nagaiku_user;

--
-- Name: freee_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.freee_tokens_id_seq OWNED BY public.freee_tokens.id;


--
-- Name: grants; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.grants (
    id integer NOT NULL,
    name character varying NOT NULL,
    total_amount integer,
    start_date date,
    end_date date,
    status character varying DEFAULT 'active'::character varying,
    grant_code character varying
);


ALTER TABLE public.grants OWNER TO nagaiku_user;

--
-- Name: grants_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.grants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grants_id_seq OWNER TO nagaiku_user;

--
-- Name: grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.grants_id_seq OWNED BY public.grants.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.transactions (
    id character varying NOT NULL,
    journal_number integer,
    journal_line_number integer,
    date date NOT NULL,
    description text,
    amount integer NOT NULL,
    account character varying,
    supplier character varying,
    item character varying,
    memo character varying,
    remark character varying,
    department character varying,
    management_number character varying,
    raw_data text,
    created_at timestamp without time zone
);


ALTER TABLE public.transactions OWNER TO nagaiku_user;

--
-- Name: wam_mappings; Type: TABLE; Schema: public; Owner: nagaiku_user
--

CREATE TABLE public.wam_mappings (
    id integer NOT NULL,
    account_pattern character varying NOT NULL,
    wam_category character varying NOT NULL,
    priority integer,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.wam_mappings OWNER TO nagaiku_user;

--
-- Name: wam_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: nagaiku_user
--

CREATE SEQUENCE public.wam_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wam_mappings_id_seq OWNER TO nagaiku_user;

--
-- Name: wam_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nagaiku_user
--

ALTER SEQUENCE public.wam_mappings_id_seq OWNED BY public.wam_mappings.id;


--
-- Name: allocations id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.allocations ALTER COLUMN id SET DEFAULT nextval('public.allocations_id_seq'::regclass);


--
-- Name: budget_items id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.budget_items ALTER COLUMN id SET DEFAULT nextval('public.budget_items_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: dev_allocations id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_allocations ALTER COLUMN id SET DEFAULT nextval('public.dev_allocations_id_seq'::regclass);


--
-- Name: dev_budget_items id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_budget_items ALTER COLUMN id SET DEFAULT nextval('public.dev_budget_items_id_seq'::regclass);


--
-- Name: dev_freee_syncs id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_freee_syncs ALTER COLUMN id SET DEFAULT nextval('public.dev_freee_syncs_id_seq'::regclass);


--
-- Name: dev_freee_tokens id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_freee_tokens ALTER COLUMN id SET DEFAULT nextval('public.dev_freee_tokens_id_seq'::regclass);


--
-- Name: dev_grants id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_grants ALTER COLUMN id SET DEFAULT nextval('public.dev_grants_id_seq'::regclass);


--
-- Name: freee_syncs id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.freee_syncs ALTER COLUMN id SET DEFAULT nextval('public.freee_syncs_id_seq'::regclass);


--
-- Name: freee_tokens id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.freee_tokens ALTER COLUMN id SET DEFAULT nextval('public.freee_tokens_id_seq'::regclass);


--
-- Name: grants id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.grants ALTER COLUMN id SET DEFAULT nextval('public.grants_id_seq'::regclass);


--
-- Name: wam_mappings id; Type: DEFAULT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.wam_mappings ALTER COLUMN id SET DEFAULT nextval('public.wam_mappings_id_seq'::regclass);


--
-- Data for Name: allocation_backups_20250718_153625; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.allocation_backups_20250718_153625 (id, transaction_id, budget_item_id, amount, created_at, backup_timestamp, backup_reason) FROM stdin;
256	5040304_1	14	598	2025-07-16 18:09:55.108142	20250718_153625	replace_import
257	5043003_1	12	165	2025-07-16 18:09:55.136204	20250718_153625	replace_import
258	5043018_1	12	160	2025-07-16 18:09:55.14677	20250718_153625	replace_import
259	5043019_1	12	160	2025-07-16 18:09:55.151646	20250718_153625	replace_import
260	5043020_1	12	160	2025-07-16 18:09:55.155448	20250718_153625	replace_import
261	5043021_1	12	160	2025-07-16 18:09:55.160905	20250718_153625	replace_import
262	5043022_1	12	160	2025-07-16 18:09:55.167204	20250718_153625	replace_import
263	5043023_1	12	55	2025-07-16 18:09:55.172442	20250718_153625	replace_import
264	5043024_1	12	160	2025-07-16 18:09:55.177109	20250718_153625	replace_import
265	5043025_1	12	160	2025-07-16 18:09:55.181877	20250718_153625	replace_import
266	5043026_1	12	160	2025-07-16 18:09:55.186932	20250718_153625	replace_import
267	5043027_1	12	160	2025-07-16 18:09:55.192127	20250718_153625	replace_import
268	5043028_1	12	160	2025-07-16 18:09:55.196419	20250718_153625	replace_import
269	5043029_1	12	55	2025-07-16 18:09:55.200327	20250718_153625	replace_import
270	5043031_1	12	160	2025-07-16 18:09:55.204369	20250718_153625	replace_import
271	5053006_1	12	145	2025-07-16 18:09:55.210556	20250718_153625	replace_import
53	5040103_1	30	336469	2025-07-09 11:24:43.186655	20250718_153625	replace_import
54	5040105_1	30	60000	2025-07-09 11:24:43.186662	20250718_153625	replace_import
272	5053007_1	12	145	2025-07-16 18:09:55.215533	20250718_153625	replace_import
273	5053008_1	12	145	2025-07-16 18:09:55.219977	20250718_153625	replace_import
274	5053009_1	12	145	2025-07-16 18:09:55.225239	20250718_153625	replace_import
275	5053013_1	12	145	2025-07-16 18:09:55.230793	20250718_153625	replace_import
59	5050703_1	21	5732	2025-07-09 11:24:43.186672	20250718_153625	replace_import
60	5050909_1	21	9155	2025-07-09 11:24:43.186674	20250718_153625	replace_import
61	5051101_1	21	3453	2025-07-09 11:24:43.186676	20250718_153625	replace_import
62	5051502_1	21	8876	2025-07-09 11:24:43.186678	20250718_153625	replace_import
63	5051803_1	21	6118	2025-07-09 11:24:43.18668	20250718_153625	replace_import
64	5051903_1	21	3230	2025-07-09 11:24:43.186682	20250718_153625	replace_import
276	5053014_1	12	145	2025-07-16 18:09:55.234501	20250718_153625	replace_import
277	5053015_1	12	145	2025-07-16 18:09:55.238445	20250718_153625	replace_import
169	5051605_1	22	250	2025-07-14 07:08:54.34884	20250718_153625	replace_import
278	5053016_1	12	145	2025-07-16 18:09:55.242152	20250718_153625	replace_import
171	5051412_1	22	2420	2025-07-14 07:09:09.771673	20250718_153625	replace_import
172	5051402_1	22	530	2025-07-14 07:09:15.474441	20250718_153625	replace_import
173	5052002_1	21	963	2025-07-14 08:07:08.833452	20250718_153625	replace_import
174	5052102_1	21	10593	2025-07-14 08:07:16.038828	20250718_153625	replace_import
279	5053017_1	12	145	2025-07-16 18:09:55.245822	20250718_153625	replace_import
176	5052902_1	22	12080	2025-07-14 09:49:25.923549	20250718_153625	replace_import
180	5040113_1	14	2184	2025-07-15 10:14:48.012676	20250718_153625	replace_import
181	5040202_1	14	5044	2025-07-15 10:14:48.012713	20250718_153625	replace_import
182	5040504_1	14	2322	2025-07-15 10:14:48.012718	20250718_153625	replace_import
183	5040701_1	14	7534	2025-07-15 10:14:48.012721	20250718_153625	replace_import
184	5040903_1	14	7436	2025-07-15 10:14:48.012723	20250718_153625	replace_import
185	5041401_1	14	7269	2025-07-15 10:14:48.012726	20250718_153625	replace_import
186	5041701_1	14	9776	2025-07-15 10:14:48.012728	20250718_153625	replace_import
187	5041905_1	14	9140	2025-07-15 10:14:48.01273	20250718_153625	replace_import
188	5042102_1	14	896	2025-07-15 10:14:48.012732	20250718_153625	replace_import
189	5042101_1	14	637	2025-07-15 10:14:48.012734	20250718_153625	replace_import
190	5042401_1	14	7687	2025-07-15 10:14:48.012736	20250718_153625	replace_import
191	5042501_1	14	20711	2025-07-15 10:14:48.012738	20250718_153625	replace_import
192	5042602_1	14	4089	2025-07-15 10:14:48.01274	20250718_153625	replace_import
193	5042803_1	14	2283	2025-07-15 10:14:48.012742	20250718_153625	replace_import
194	5043005_1	14	6482	2025-07-15 10:14:48.012745	20250718_153625	replace_import
195	5050109_1	14	576	2025-07-15 10:14:48.012747	20250718_153625	replace_import
196	5050110_1	14	1770	2025-07-15 10:14:48.012749	20250718_153625	replace_import
197	5050801_1	14	1408	2025-07-15 10:14:48.012751	20250718_153625	replace_import
198	5050912_1	14	434	2025-07-15 10:14:48.012753	20250718_153625	replace_import
199	5051310_1	14	857	2025-07-15 10:14:48.012755	20250718_153625	replace_import
200	5051309_1	14	5105	2025-07-15 10:14:48.012758	20250718_153625	replace_import
201	5051401_1	14	213	2025-07-15 10:14:48.01276	20250718_153625	replace_import
202	5051410_1	14	3074	2025-07-15 10:14:48.012762	20250718_153625	replace_import
203	5051501_1	14	2479	2025-07-15 10:14:48.012764	20250718_153625	replace_import
204	5051701_1	14	3054	2025-07-15 10:14:48.012766	20250718_153625	replace_import
205	5052201_1	14	792	2025-07-15 10:14:48.012768	20250718_153625	replace_import
206	5052202_1	14	3580	2025-07-15 10:14:48.01277	20250718_153625	replace_import
207	5052307_1	14	11061	2025-07-15 10:14:48.012772	20250718_153625	replace_import
208	5052404_1	14	1155	2025-07-15 10:14:48.012775	20250718_153625	replace_import
209	5052605_1	14	8913	2025-07-15 10:14:48.012777	20250718_153625	replace_import
210	5052701_1	14	4397	2025-07-15 10:14:48.012779	20250718_153625	replace_import
211	5052804_1	14	3557	2025-07-15 10:14:48.012781	20250718_153625	replace_import
212	5052901_1	14	11975	2025-07-15 10:14:48.012783	20250718_153625	replace_import
213	5053005_1	14	19441	2025-07-15 10:14:48.012785	20250718_153625	replace_import
214	5053101_1	14	3724	2025-07-15 10:14:48.012787	20250718_153625	replace_import
215	5060208_1	14	10874	2025-07-15 10:14:48.012789	20250718_153625	replace_import
216	5060212_1	14	404	2025-07-15 10:14:48.012791	20250718_153625	replace_import
217	5060401_1	14	3759	2025-07-15 10:14:48.012793	20250718_153625	replace_import
218	5060601_1	14	9876	2025-07-15 10:14:48.012795	20250718_153625	replace_import
219	5060602_1	14	19676	2025-07-15 10:14:48.012798	20250718_153625	replace_import
220	5060910_1	14	835	2025-07-15 10:14:48.0128	20250718_153625	replace_import
221	5060904_1	14	859	2025-07-15 10:14:48.012802	20250718_153625	replace_import
222	5061010_1	14	8372	2025-07-15 10:14:48.012804	20250718_153625	replace_import
223	5061302_1	14	9080	2025-07-15 10:14:48.012806	20250718_153625	replace_import
224	5061307_1	14	233	2025-07-15 10:14:48.012808	20250718_153625	replace_import
225	5061308_1	14	18982	2025-07-15 10:14:48.01281	20250718_153625	replace_import
226	5061401_1	14	6021	2025-07-15 10:14:48.012813	20250718_153625	replace_import
227	5061613_1	14	1810	2025-07-15 10:14:48.012815	20250718_153625	replace_import
228	5061703_1	14	2012	2025-07-15 10:14:48.012817	20250718_153625	replace_import
229	5061701_1	14	246	2025-07-15 10:14:48.012819	20250718_153625	replace_import
230	5061704_1	14	2129	2025-07-15 10:14:48.012821	20250718_153625	replace_import
231	5061803_1	14	8009	2025-07-15 10:14:48.012823	20250718_153625	replace_import
232	5061804_1	14	4914	2025-07-15 10:14:48.012825	20250718_153625	replace_import
233	5061805_1	14	5406	2025-07-15 10:14:48.012827	20250718_153625	replace_import
234	5062001_1	14	7377	2025-07-15 10:14:48.012829	20250718_153625	replace_import
235	5062007_1	14	1300	2025-07-15 10:14:48.012831	20250718_153625	replace_import
236	5062016_1	14	14001	2025-07-15 10:14:48.012833	20250718_153625	replace_import
237	5062102_1	14	4086	2025-07-15 10:14:48.012835	20250718_153625	replace_import
238	5062105_1	14	213	2025-07-15 10:14:48.012837	20250718_153625	replace_import
239	5062201_1	14	10343	2025-07-15 10:14:48.012839	20250718_153625	replace_import
240	5062315_1	14	355	2025-07-15 10:14:48.012841	20250718_153625	replace_import
241	5062316_1	14	5900	2025-07-15 10:14:48.012843	20250718_153625	replace_import
242	5062405_1	14	1404	2025-07-15 10:14:48.012845	20250718_153625	replace_import
243	5062408_1	14	6497	2025-07-15 10:14:48.012847	20250718_153625	replace_import
244	5062607_1	14	5780	2025-07-15 10:14:48.012849	20250718_153625	replace_import
245	5062701_1	14	7753	2025-07-15 10:14:48.012852	20250718_153625	replace_import
246	5062712_1	14	6116	2025-07-15 10:14:48.012854	20250718_153625	replace_import
247	5062716_1	14	11166	2025-07-15 10:14:48.012856	20250718_153625	replace_import
248	5062717_1	14	20527	2025-07-15 10:14:48.012858	20250718_153625	replace_import
249	5062801_1	14	4230	2025-07-15 10:14:48.01286	20250718_153625	replace_import
250	5062802_1	14	2023	2025-07-15 10:14:48.012862	20250718_153625	replace_import
251	5062803_1	14	3680	2025-07-15 10:14:48.012864	20250718_153625	replace_import
252	5062901_1	14	2818	2025-07-15 10:14:48.012866	20250718_153625	replace_import
253	5070202_1	14	501	2025-07-15 10:14:48.012869	20250718_153625	replace_import
254	5062410_1	14	1628	2025-07-15 10:14:48.012871	20250718_153625	replace_import
255	5062714_1	14	283	2025-07-15 10:14:48.012873	20250718_153625	replace_import
280	5053018_1	12	145	2025-07-16 18:09:55.249593	20250718_153625	replace_import
281	5050903_1	9	320	2025-07-16 18:09:55.255318	20250718_153625	replace_import
282	5051908_1	9	4140	2025-07-16 18:09:55.260324	20250718_153625	replace_import
283	5043036_1	16	180000	2025-07-16 18:09:55.268505	20250718_153625	replace_import
284	5053108_1	16	180000	2025-07-16 18:09:55.275761	20250718_153625	replace_import
285	5040111_1	13	1000	2025-07-16 18:09:55.279493	20250718_153625	replace_import
286	5040502_1	13	1500	2025-07-16 18:09:55.283765	20250718_153625	replace_import
287	5040805_1	13	500	2025-07-16 18:09:55.288158	20250718_153625	replace_import
288	5041902_1	13	2000	2025-07-16 18:09:55.293358	20250718_153625	replace_import
289	5042201_1	13	500	2025-07-16 18:09:55.299235	20250718_153625	replace_import
290	5050902_1	13	3000	2025-07-16 18:09:55.303354	20250718_153625	replace_import
1	5040304_1	14	598	2025-07-15 21:22:12.05923	20250718_153625	replace_import
2	5043003_1	12	165	2025-07-15 21:22:12.689755	20250718_153625	replace_import
3	5043018_1	12	160	2025-07-15 21:22:13.061312	20250718_153625	replace_import
55	5051402_1	22	598	2025-07-15 15:14:35.390194	20250718_153625	replace_import
56	5051412_1	22	5000	2025-07-15 15:14:35.39022	20250718_153625	replace_import
57	5051605_1	22	336469	2025-07-15 15:14:35.390223	20250718_153625	replace_import
58	5052902_1	22	60000	2025-07-15 15:14:35.390226	20250718_153625	replace_import
65	5052002_1	21	963	2025-07-15 15:14:35.390228	20250718_153625	replace_import
66	5052102_1	21	10593	2025-07-15 15:14:35.390231	20250718_153625	replace_import
291	5051001_1	13	3000	2025-07-16 18:09:55.307756	20250718_153625	replace_import
292	5051306_1	13	3000	2025-07-16 18:09:55.312391	20250718_153625	replace_import
293	5051905_1	13	3000	2025-07-16 18:09:55.316532	20250718_153625	replace_import
294	5052004_1	13	500	2025-07-16 18:09:55.319818	20250718_153625	replace_import
295	5052003_1	13	5000	2025-07-16 18:09:55.324996	20250718_153625	replace_import
296	5052405_1	13	3000	2025-07-16 18:09:55.329427	20250718_153625	replace_import
297	5053003_1	13	3000	2025-07-16 18:09:55.335543	20250718_153625	replace_import
298	5053106_1	13	500	2025-07-16 18:09:55.339141	20250718_153625	replace_import
299	5060206_1	13	3000	2025-07-16 18:09:55.342797	20250718_153625	replace_import
300	5060207_1	13	3000	2025-07-16 18:09:55.349361	20250718_153625	replace_import
301	5061001_1	13	500	2025-07-16 18:09:55.354785	20250718_153625	replace_import
302	5061003_1	13	3000	2025-07-16 18:09:55.358236	20250718_153625	replace_import
303	5061304_1	13	3000	2025-07-16 18:09:55.362625	20250718_153625	replace_import
304	5061405_1	13	1500	2025-07-16 18:09:55.368619	20250718_153625	replace_import
305	5061611_1	13	3000	2025-07-16 18:09:55.371819	20250718_153625	replace_import
306	5062003_1	13	5000	2025-07-16 18:09:55.376222	20250718_153625	replace_import
307	5040702_1	14	110	2025-07-16 18:09:55.380728	20250718_153625	replace_import
308	5042601_1	14	2409	2025-07-16 18:09:55.385119	20250718_153625	replace_import
309	5050301_1	14	1771	2025-07-16 18:09:55.390607	20250718_153625	replace_import
310	5051801_1	14	217	2025-07-16 18:09:55.396414	20250718_153625	replace_import
311	5052806_1	14	220	2025-07-16 18:09:55.400552	20250718_153625	replace_import
312	5060213_1	14	712	2025-07-16 18:09:55.406619	20250718_153625	replace_import
313	5060403_1	14	44	2025-07-16 18:09:55.411481	20250718_153625	replace_import
314	5060914_1	14	2230	2025-07-16 18:09:55.415833	20250718_153625	replace_import
315	5061012_1	14	1353	2025-07-16 18:09:55.419445	20250718_153625	replace_import
316	5061004_1	14	547	2025-07-16 18:09:55.423818	20250718_153625	replace_import
317	5061404_1	14	1430	2025-07-16 18:09:55.427518	20250718_153625	replace_import
318	5061809_1	14	493	2025-07-16 18:09:55.431133	20250718_153625	replace_import
319	5061811_1	14	17160	2025-07-16 18:09:55.437216	20250718_153625	replace_import
320	5061903_1	14	8494	2025-07-16 18:09:55.440773	20250718_153625	replace_import
321	5040113_1	14	2184	2025-07-16 18:09:55.444118	20250718_153625	replace_import
322	5040202_1	14	5044	2025-07-16 18:09:55.447767	20250718_153625	replace_import
323	5040504_1	14	2322	2025-07-16 18:09:55.451176	20250718_153625	replace_import
324	5040701_1	14	7534	2025-07-16 18:09:55.454621	20250718_153625	replace_import
325	5040903_1	14	7436	2025-07-16 18:09:55.459238	20250718_153625	replace_import
326	5041401_1	14	7269	2025-07-16 18:09:55.463046	20250718_153625	replace_import
327	5041501_1	14	8000	2025-07-16 18:09:55.466803	20250718_153625	replace_import
328	5041701_1	14	9776	2025-07-16 18:09:55.47338	20250718_153625	replace_import
329	5041905_1	14	9140	2025-07-16 18:09:55.477182	20250718_153625	replace_import
330	5042102_1	14	896	2025-07-16 18:09:55.480942	20250718_153625	replace_import
331	5042101_1	14	637	2025-07-16 18:09:55.48456	20250718_153625	replace_import
332	5042401_1	14	7687	2025-07-16 18:09:55.488132	20250718_153625	replace_import
333	5042501_1	14	20711	2025-07-16 18:09:55.492091	20250718_153625	replace_import
334	5042602_1	14	4089	2025-07-16 18:09:55.496651	20250718_153625	replace_import
335	5042803_1	14	2283	2025-07-16 18:09:55.50028	20250718_153625	replace_import
336	5043005_1	14	6482	2025-07-16 18:09:55.503979	20250718_153625	replace_import
337	5050109_1	14	576	2025-07-16 18:09:55.507795	20250718_153625	replace_import
338	5050110_1	14	1770	2025-07-16 18:09:55.514293	20250718_153625	replace_import
339	5050701_1	14	12495	2025-07-16 18:09:55.519122	20250718_153625	replace_import
340	5050801_1	14	1408	2025-07-16 18:09:55.522688	20250718_153625	replace_import
341	5050912_1	14	434	2025-07-16 18:09:55.527473	20250718_153625	replace_import
342	5051202_1	14	1520	2025-07-16 18:09:55.531085	20250718_153625	replace_import
343	5051310_1	14	857	2025-07-16 18:09:55.535106	20250718_153625	replace_import
344	5051309_1	14	5105	2025-07-16 18:09:55.539256	20250718_153625	replace_import
345	5051401_1	14	213	2025-07-16 18:09:55.542963	20250718_153625	replace_import
346	5051410_1	14	3074	2025-07-16 18:09:55.547205	20250718_153625	replace_import
347	5051501_1	14	2479	2025-07-16 18:09:55.550847	20250718_153625	replace_import
348	5052201_1	14	792	2025-07-16 18:09:55.555633	20250718_153625	replace_import
349	5052202_1	14	3580	2025-07-16 18:09:55.560517	20250718_153625	replace_import
350	5052307_1	14	11061	2025-07-16 18:09:55.568569	20250718_153625	replace_import
351	5052404_1	14	1155	2025-07-16 18:09:55.573323	20250718_153625	replace_import
352	5052605_1	14	8913	2025-07-16 18:09:55.576829	20250718_153625	replace_import
353	5052701_1	14	4397	2025-07-16 18:09:55.580315	20250718_153625	replace_import
354	5052802_1	14	9573	2025-07-16 18:09:55.583653	20250718_153625	replace_import
355	5052804_1	14	3557	2025-07-16 18:09:55.587129	20250718_153625	replace_import
356	5052901_1	14	11975	2025-07-16 18:09:55.590921	20250718_153625	replace_import
357	5053005_1	14	19441	2025-07-16 18:09:55.594639	20250718_153625	replace_import
358	5053101_1	14	3724	2025-07-16 18:09:55.599067	20250718_153625	replace_import
359	5060208_1	14	10874	2025-07-16 18:09:55.602938	20250718_153625	replace_import
360	5060212_1	14	404	2025-07-16 18:09:55.606491	20250718_153625	replace_import
361	5060401_1	14	3759	2025-07-16 18:09:55.610189	20250718_153625	replace_import
362	5060601_1	14	9876	2025-07-16 18:09:55.615214	20250718_153625	replace_import
363	5060602_1	14	19676	2025-07-16 18:09:55.619517	20250718_153625	replace_import
364	5060910_1	14	835	2025-07-16 18:09:55.624133	20250718_153625	replace_import
365	5060904_1	14	859	2025-07-16 18:09:55.629373	20250718_153625	replace_import
366	5061010_1	14	8372	2025-07-16 18:09:55.63316	20250718_153625	replace_import
367	5061105_1	14	28784	2025-07-16 18:09:55.637752	20250718_153625	replace_import
368	5061302_1	14	9080	2025-07-16 18:09:55.642479	20250718_153625	replace_import
369	5061307_1	14	233	2025-07-16 18:09:55.646707	20250718_153625	replace_import
370	5061308_1	14	18982	2025-07-16 18:09:55.652266	20250718_153625	replace_import
371	5061403_1	14	16496	2025-07-16 18:09:55.656031	20250718_153625	replace_import
372	5061401_1	14	6021	2025-07-16 18:09:55.660049	20250718_153625	replace_import
373	5061613_1	14	1810	2025-07-16 18:09:55.663563	20250718_153625	replace_import
374	5061703_1	14	2012	2025-07-16 18:09:55.667756	20250718_153625	replace_import
375	5061701_1	14	246	2025-07-16 18:09:55.671307	20250718_153625	replace_import
376	5061704_1	14	2129	2025-07-16 18:09:55.674775	20250718_153625	replace_import
377	5061803_1	14	8009	2025-07-16 18:09:55.67828	20250718_153625	replace_import
378	5061804_1	14	4914	2025-07-16 18:09:55.682105	20250718_153625	replace_import
379	5061805_1	14	5406	2025-07-16 18:09:55.685823	20250718_153625	replace_import
380	5062001_1	14	7377	2025-07-16 18:09:55.689447	20250718_153625	replace_import
381	5062007_1	14	1300	2025-07-16 18:09:55.693552	20250718_153625	replace_import
382	5062016_1	14	14001	2025-07-16 18:09:55.698395	20250718_153625	replace_import
383	5062102_1	14	4086	2025-07-16 18:09:55.702677	20250718_153625	replace_import
384	5062105_1	14	213	2025-07-16 18:09:55.706389	20250718_153625	replace_import
385	5062201_1	14	10343	2025-07-16 18:09:55.710135	20250718_153625	replace_import
386	5062315_1	14	355	2025-07-16 18:09:55.713803	20250718_153625	replace_import
387	5062316_1	14	5900	2025-07-16 18:09:55.71918	20250718_153625	replace_import
388	5062405_1	14	1404	2025-07-16 18:09:55.7229	20250718_153625	replace_import
389	5062408_1	14	6497	2025-07-16 18:09:55.728207	20250718_153625	replace_import
390	5062607_1	14	5780	2025-07-16 18:09:55.733621	20250718_153625	replace_import
391	5062701_1	14	7753	2025-07-16 18:09:55.737415	20250718_153625	replace_import
392	5062712_1	14	6116	2025-07-16 18:09:55.746423	20250718_153625	replace_import
393	5062716_1	14	11166	2025-07-16 18:09:55.751183	20250718_153625	replace_import
394	5062717_1	14	20527	2025-07-16 18:09:55.757754	20250718_153625	replace_import
395	5062801_1	14	4230	2025-07-16 18:09:55.761223	20250718_153625	replace_import
396	5062802_1	14	2023	2025-07-16 18:09:55.765569	20250718_153625	replace_import
397	5062803_1	14	3680	2025-07-16 18:09:55.769009	20250718_153625	replace_import
398	5062901_1	14	2818	2025-07-16 18:09:55.773049	20250718_153625	replace_import
399	5040901_1	11	3094	2025-07-16 18:09:55.777199	20250718_153625	replace_import
400	5041703_1	11	25962	2025-07-16 18:09:55.780832	20250718_153625	replace_import
401	5042405_1	11	8349	2025-07-16 18:09:55.784358	20250718_153625	replace_import
402	5052001_1	11	20088	2025-07-16 18:09:55.788138	20250718_153625	replace_import
403	5052501_1	11	6395	2025-07-16 18:09:55.792384	20250718_153625	replace_import
404	5060913_1	11	2819	2025-07-16 18:09:55.795788	20250718_153625	replace_import
405	5042808_1	10	150800	2025-07-16 18:09:55.799376	20250718_153625	replace_import
406	5052812_1	10	150800	2025-07-16 18:09:55.803304	20250718_153625	replace_import
407	5040102_1	17	16500	2025-07-16 18:09:55.807249	20250718_153625	replace_import
408	5042605_1	17	10780	2025-07-16 18:09:55.811509	20250718_153625	replace_import
409	5042807_1	17	8225	2025-07-16 18:09:55.815635	20250718_153625	replace_import
410	5050102_1	17	16500	2025-07-16 18:09:55.819331	20250718_153625	replace_import
411	5051408_1	17	10890	2025-07-16 18:09:55.822602	20250718_153625	replace_import
412	5051409_1	17	10890	2025-07-16 18:09:55.82604	20250718_153625	replace_import
413	5052601_1	17	7909	2025-07-16 18:09:55.829677	20250718_153625	replace_import
414	5052602_1	17	10780	2025-07-16 18:09:55.834732	20250718_153625	replace_import
415	5060104_1	17	16500	2025-07-16 18:09:55.839123	20250718_153625	replace_import
416	5062608_1	17	7539	2025-07-16 18:09:55.843802	20250718_153625	replace_import
417	5062609_1	17	10780	2025-07-16 18:09:55.847664	20250718_153625	replace_import
418	5070102_1	17	16500	2025-07-16 18:09:55.851902	20250718_153625	replace_import
419	5061007_1	18	29250	2025-07-16 18:09:55.856081	20250718_153625	replace_import
420	5043044_1	15	26400	2025-07-16 18:09:55.859743	20250718_153625	replace_import
421	5043045_1	15	66000	2025-07-16 18:09:55.863535	20250718_153625	replace_import
422	5043043_1	15	45360	2025-07-16 18:09:55.868285	20250718_153625	replace_import
423	5043040_1	15	43450	2025-07-16 18:09:55.871838	20250718_153625	replace_import
424	5043039_1	15	17280	2025-07-16 18:09:55.875144	20250718_153625	replace_import
425	5043042_1	15	28800	2025-07-16 18:09:55.881469	20250718_153625	replace_import
426	5043041_1	15	35200	2025-07-16 18:09:55.885293	20250718_153625	replace_import
427	5053116_1	15	15400	2025-07-16 18:09:55.889781	20250718_153625	replace_import
428	5053117_1	15	46017	2025-07-16 18:09:55.894502	20250718_153625	replace_import
429	5053115_1	15	10980	2025-07-16 18:09:55.898144	20250718_153625	replace_import
430	5053112_1	15	55550	2025-07-16 18:09:55.901723	20250718_153625	replace_import
431	5053111_1	15	16740	2025-07-16 18:09:55.90522	20250718_153625	replace_import
432	5053114_1	15	22000	2025-07-16 18:09:55.909295	20250718_153625	replace_import
433	5053113_1	15	45467	2025-07-16 18:09:55.912649	20250718_153625	replace_import
434	5040304_1	14	598	2025-07-16 18:23:44.570955	20250718_153625	replace_import
435	5043003_1	12	165	2025-07-16 18:23:44.589266	20250718_153625	replace_import
436	5043018_1	12	160	2025-07-16 18:23:44.595834	20250718_153625	replace_import
437	5043019_1	12	160	2025-07-16 18:23:44.601702	20250718_153625	replace_import
438	5043020_1	12	160	2025-07-16 18:23:44.606224	20250718_153625	replace_import
439	5043021_1	12	160	2025-07-16 18:23:44.610799	20250718_153625	replace_import
440	5043022_1	12	160	2025-07-16 18:23:44.615211	20250718_153625	replace_import
441	5043023_1	12	55	2025-07-16 18:23:44.620614	20250718_153625	replace_import
442	5043024_1	12	160	2025-07-16 18:23:44.624185	20250718_153625	replace_import
443	5043025_1	12	160	2025-07-16 18:23:44.628412	20250718_153625	replace_import
444	5043026_1	12	160	2025-07-16 18:23:44.637098	20250718_153625	replace_import
445	5043027_1	12	160	2025-07-16 18:23:44.643747	20250718_153625	replace_import
446	5043028_1	12	160	2025-07-16 18:23:44.64839	20250718_153625	replace_import
447	5043029_1	12	55	2025-07-16 18:23:44.652789	20250718_153625	replace_import
448	5043031_1	12	160	2025-07-16 18:23:44.658485	20250718_153625	replace_import
449	5053006_1	12	145	2025-07-16 18:23:44.663523	20250718_153625	replace_import
450	5053007_1	12	145	2025-07-16 18:23:44.668643	20250718_153625	replace_import
451	5053008_1	12	145	2025-07-16 18:23:44.673622	20250718_153625	replace_import
452	5053009_1	12	145	2025-07-16 18:23:44.679442	20250718_153625	replace_import
453	5053013_1	12	145	2025-07-16 18:23:44.684152	20250718_153625	replace_import
454	5053014_1	12	145	2025-07-16 18:23:44.689592	20250718_153625	replace_import
455	5053015_1	12	145	2025-07-16 18:23:44.694932	20250718_153625	replace_import
456	5053016_1	12	145	2025-07-16 18:23:44.701221	20250718_153625	replace_import
457	5053017_1	12	145	2025-07-16 18:23:44.706172	20250718_153625	replace_import
458	5053018_1	12	145	2025-07-16 18:23:44.710508	20250718_153625	replace_import
459	5050903_1	9	320	2025-07-16 18:23:44.714273	20250718_153625	replace_import
460	5051908_1	9	4140	2025-07-16 18:23:44.718701	20250718_153625	replace_import
461	5043036_1	16	180000	2025-07-16 18:23:44.72543	20250718_153625	replace_import
462	5053108_1	16	180000	2025-07-16 18:23:44.732221	20250718_153625	replace_import
463	5040111_1	13	1000	2025-07-16 18:23:44.736979	20250718_153625	replace_import
464	5040502_1	13	1500	2025-07-16 18:23:44.741482	20250718_153625	replace_import
465	5040805_1	13	500	2025-07-16 18:23:44.747439	20250718_153625	replace_import
466	5041902_1	13	2000	2025-07-16 18:23:44.753203	20250718_153625	replace_import
467	5042201_1	13	500	2025-07-16 18:23:44.758228	20250718_153625	replace_import
468	5050902_1	13	3000	2025-07-16 18:23:44.763476	20250718_153625	replace_import
469	5051001_1	13	3000	2025-07-16 18:23:44.767472	20250718_153625	replace_import
470	5051306_1	13	3000	2025-07-16 18:23:44.771773	20250718_153625	replace_import
471	5051905_1	13	3000	2025-07-16 18:23:44.775712	20250718_153625	replace_import
472	5052004_1	13	500	2025-07-16 18:23:44.779853	20250718_153625	replace_import
473	5052003_1	13	5000	2025-07-16 18:23:44.783913	20250718_153625	replace_import
474	5052405_1	13	3000	2025-07-16 18:23:44.787709	20250718_153625	replace_import
475	5053003_1	13	3000	2025-07-16 18:23:44.793039	20250718_153625	replace_import
476	5053106_1	13	500	2025-07-16 18:23:44.796905	20250718_153625	replace_import
477	5060206_1	13	3000	2025-07-16 18:23:44.802446	20250718_153625	replace_import
478	5060207_1	13	3000	2025-07-16 18:23:44.806713	20250718_153625	replace_import
479	5061001_1	13	500	2025-07-16 18:23:44.810994	20250718_153625	replace_import
480	5061003_1	13	3000	2025-07-16 18:23:44.815337	20250718_153625	replace_import
481	5061304_1	13	3000	2025-07-16 18:23:44.82021	20250718_153625	replace_import
482	5061405_1	13	1500	2025-07-16 18:23:44.826478	20250718_153625	replace_import
483	5061611_1	13	3000	2025-07-16 18:23:44.831088	20250718_153625	replace_import
484	5062003_1	13	5000	2025-07-16 18:23:44.835663	20250718_153625	replace_import
485	5040702_1	14	110	2025-07-16 18:23:44.839624	20250718_153625	replace_import
486	5042601_1	14	2409	2025-07-16 18:23:44.844486	20250718_153625	replace_import
487	5050301_1	14	1771	2025-07-16 18:23:44.848724	20250718_153625	replace_import
488	5051801_1	14	217	2025-07-16 18:23:44.855453	20250718_153625	replace_import
489	5052806_1	14	220	2025-07-16 18:23:44.863429	20250718_153625	replace_import
490	5060213_1	14	712	2025-07-16 18:23:44.867664	20250718_153625	replace_import
491	5060403_1	14	44	2025-07-16 18:23:44.872224	20250718_153625	replace_import
492	5060914_1	14	2230	2025-07-16 18:23:44.877481	20250718_153625	replace_import
493	5061012_1	14	1353	2025-07-16 18:23:44.883131	20250718_153625	replace_import
494	5061004_1	14	547	2025-07-16 18:23:44.887734	20250718_153625	replace_import
495	5061404_1	14	1430	2025-07-16 18:23:44.892177	20250718_153625	replace_import
496	5061809_1	14	493	2025-07-16 18:23:44.89652	20250718_153625	replace_import
497	5061811_1	14	17160	2025-07-16 18:23:44.906878	20250718_153625	replace_import
498	5061903_1	14	8494	2025-07-16 18:23:44.912385	20250718_153625	replace_import
499	5040113_1	14	2184	2025-07-16 18:23:44.917726	20250718_153625	replace_import
500	5040202_1	14	5044	2025-07-16 18:23:44.922835	20250718_153625	replace_import
501	5040504_1	14	2322	2025-07-16 18:23:44.927438	20250718_153625	replace_import
502	5040701_1	14	7534	2025-07-16 18:23:44.934997	20250718_153625	replace_import
503	5040903_1	14	7436	2025-07-16 18:23:44.940596	20250718_153625	replace_import
504	5041401_1	14	7269	2025-07-16 18:23:44.947074	20250718_153625	replace_import
505	5041501_1	14	8000	2025-07-16 18:23:44.954709	20250718_153625	replace_import
506	5041701_1	14	9776	2025-07-16 18:23:44.960269	20250718_153625	replace_import
507	5041905_1	14	9140	2025-07-16 18:23:44.968116	20250718_153625	replace_import
508	5042102_1	14	896	2025-07-16 18:23:44.974399	20250718_153625	replace_import
509	5042101_1	14	637	2025-07-16 18:23:44.979578	20250718_153625	replace_import
510	5042401_1	14	7687	2025-07-16 18:23:44.984227	20250718_153625	replace_import
511	5042501_1	14	20711	2025-07-16 18:23:44.989675	20250718_153625	replace_import
512	5042602_1	14	4089	2025-07-16 18:23:44.994559	20250718_153625	replace_import
513	5042803_1	14	2283	2025-07-16 18:23:45.000086	20250718_153625	replace_import
514	5043005_1	14	6482	2025-07-16 18:23:45.005475	20250718_153625	replace_import
515	5050109_1	14	576	2025-07-16 18:23:45.010977	20250718_153625	replace_import
516	5050110_1	14	1770	2025-07-16 18:23:45.017063	20250718_153625	replace_import
517	5050701_1	14	12495	2025-07-16 18:23:45.024522	20250718_153625	replace_import
518	5050801_1	14	1408	2025-07-16 18:23:45.032585	20250718_153625	replace_import
519	5050912_1	14	434	2025-07-16 18:23:45.039903	20250718_153625	replace_import
520	5051202_1	14	1520	2025-07-16 18:23:45.044371	20250718_153625	replace_import
521	5051310_1	14	857	2025-07-16 18:23:45.04971	20250718_153625	replace_import
522	5051309_1	14	5105	2025-07-16 18:23:45.054473	20250718_153625	replace_import
523	5051401_1	14	213	2025-07-16 18:23:45.059135	20250718_153625	replace_import
524	5051410_1	14	3074	2025-07-16 18:23:45.064199	20250718_153625	replace_import
525	5051501_1	14	2479	2025-07-16 18:23:45.06934	20250718_153625	replace_import
526	5052201_1	14	792	2025-07-16 18:23:45.073802	20250718_153625	replace_import
527	5052202_1	14	3580	2025-07-16 18:23:45.07858	20250718_153625	replace_import
528	5052307_1	14	11061	2025-07-16 18:23:45.082899	20250718_153625	replace_import
529	5052404_1	14	1155	2025-07-16 18:23:45.088987	20250718_153625	replace_import
530	5052605_1	14	8913	2025-07-16 18:23:45.094801	20250718_153625	replace_import
531	5052701_1	14	4397	2025-07-16 18:23:45.099521	20250718_153625	replace_import
532	5052802_1	14	9573	2025-07-16 18:23:45.104298	20250718_153625	replace_import
533	5052804_1	14	3557	2025-07-16 18:23:45.11066	20250718_153625	replace_import
534	5052901_1	14	11975	2025-07-16 18:23:45.1164	20250718_153625	replace_import
535	5053005_1	14	19441	2025-07-16 18:23:45.121446	20250718_153625	replace_import
536	5053101_1	14	3724	2025-07-16 18:23:45.128429	20250718_153625	replace_import
537	5060208_1	14	10874	2025-07-16 18:23:45.133496	20250718_153625	replace_import
538	5060212_1	14	404	2025-07-16 18:23:45.140025	20250718_153625	replace_import
539	5060401_1	14	3759	2025-07-16 18:23:45.145062	20250718_153625	replace_import
540	5060601_1	14	9876	2025-07-16 18:23:45.152611	20250718_153625	replace_import
541	5060602_1	14	19676	2025-07-16 18:23:45.15805	20250718_153625	replace_import
542	5060910_1	14	835	2025-07-16 18:23:45.163857	20250718_153625	replace_import
543	5060904_1	14	859	2025-07-16 18:23:45.170203	20250718_153625	replace_import
544	5061010_1	14	8372	2025-07-16 18:23:45.175538	20250718_153625	replace_import
545	5061105_1	14	28784	2025-07-16 18:23:45.183685	20250718_153625	replace_import
546	5061302_1	14	9080	2025-07-16 18:23:45.188202	20250718_153625	replace_import
547	5061307_1	14	233	2025-07-16 18:23:45.192664	20250718_153625	replace_import
548	5061308_1	14	18982	2025-07-16 18:23:45.197111	20250718_153625	replace_import
549	5061403_1	14	16496	2025-07-16 18:23:45.202683	20250718_153625	replace_import
550	5061401_1	14	6021	2025-07-16 18:23:45.207205	20250718_153625	replace_import
551	5061613_1	14	1810	2025-07-16 18:23:45.211482	20250718_153625	replace_import
552	5061703_1	14	2012	2025-07-16 18:23:45.216325	20250718_153625	replace_import
553	5061701_1	14	246	2025-07-16 18:23:45.222278	20250718_153625	replace_import
554	5061704_1	14	2129	2025-07-16 18:23:45.226818	20250718_153625	replace_import
555	5061803_1	14	8009	2025-07-16 18:23:45.23103	20250718_153625	replace_import
556	5061804_1	14	4914	2025-07-16 18:23:45.235886	20250718_153625	replace_import
557	5061805_1	14	5406	2025-07-16 18:23:45.241969	20250718_153625	replace_import
558	5062001_1	14	7377	2025-07-16 18:23:45.246887	20250718_153625	replace_import
559	5062007_1	14	1300	2025-07-16 18:23:45.254485	20250718_153625	replace_import
560	5062016_1	14	14001	2025-07-16 18:23:45.25984	20250718_153625	replace_import
561	5062102_1	14	4086	2025-07-16 18:23:45.265383	20250718_153625	replace_import
562	5062105_1	14	213	2025-07-16 18:23:45.269454	20250718_153625	replace_import
563	5062201_1	14	10343	2025-07-16 18:23:45.273765	20250718_153625	replace_import
564	5062315_1	14	355	2025-07-16 18:23:45.280581	20250718_153625	replace_import
565	5062316_1	14	5900	2025-07-16 18:23:45.294894	20250718_153625	replace_import
566	5062405_1	14	1404	2025-07-16 18:23:45.299953	20250718_153625	replace_import
567	5062408_1	14	6497	2025-07-16 18:23:45.31525	20250718_153625	replace_import
568	5062607_1	14	5780	2025-07-16 18:23:45.321691	20250718_153625	replace_import
569	5062701_1	14	7753	2025-07-16 18:23:45.329723	20250718_153625	replace_import
570	5062712_1	14	6116	2025-07-16 18:23:45.338453	20250718_153625	replace_import
571	5062716_1	14	11166	2025-07-16 18:23:45.348193	20250718_153625	replace_import
572	5062717_1	14	20527	2025-07-16 18:23:45.358659	20250718_153625	replace_import
573	5062801_1	14	4230	2025-07-16 18:23:45.37102	20250718_153625	replace_import
574	5062802_1	14	2023	2025-07-16 18:23:45.377856	20250718_153625	replace_import
575	5062803_1	14	3680	2025-07-16 18:23:45.401407	20250718_153625	replace_import
576	5062901_1	14	2818	2025-07-16 18:23:45.409355	20250718_153625	replace_import
577	5040901_1	11	3094	2025-07-16 18:23:45.41504	20250718_153625	replace_import
578	5041703_1	11	25962	2025-07-16 18:23:45.424888	20250718_153625	replace_import
579	5042405_1	11	8349	2025-07-16 18:23:45.430051	20250718_153625	replace_import
580	5052001_1	11	20088	2025-07-16 18:23:45.4347	20250718_153625	replace_import
581	5052501_1	11	6395	2025-07-16 18:23:45.439016	20250718_153625	replace_import
582	5060913_1	11	2819	2025-07-16 18:23:45.443589	20250718_153625	replace_import
583	5042808_1	10	150800	2025-07-16 18:23:45.447456	20250718_153625	replace_import
584	5052812_1	10	150800	2025-07-16 18:23:45.451956	20250718_153625	replace_import
586	5042605_1	17	10780	2025-07-16 18:23:45.460948	20250718_153625	replace_import
587	5042807_1	17	8225	2025-07-16 18:23:45.466125	20250718_153625	replace_import
588	5050102_1	17	16500	2025-07-16 18:23:45.470556	20250718_153625	replace_import
589	5051408_1	17	10890	2025-07-16 18:23:45.475004	20250718_153625	replace_import
590	5051409_1	17	10890	2025-07-16 18:23:45.478912	20250718_153625	replace_import
591	5052601_1	17	7909	2025-07-16 18:23:45.483933	20250718_153625	replace_import
592	5052602_1	17	10780	2025-07-16 18:23:45.488594	20250718_153625	replace_import
593	5060104_1	17	16500	2025-07-16 18:23:45.493941	20250718_153625	replace_import
594	5062608_1	17	7539	2025-07-16 18:23:45.500994	20250718_153625	replace_import
595	5062609_1	17	10780	2025-07-16 18:23:45.505506	20250718_153625	replace_import
596	5070102_1	17	16500	2025-07-16 18:23:45.51529	20250718_153625	replace_import
597	5061007_1	18	29250	2025-07-16 18:23:45.52129	20250718_153625	replace_import
598	5043044_1	15	26400	2025-07-16 18:23:45.525903	20250718_153625	replace_import
599	5043045_1	15	66000	2025-07-16 18:23:45.529884	20250718_153625	replace_import
600	5043043_1	15	45360	2025-07-16 18:23:45.534288	20250718_153625	replace_import
601	5043040_1	15	43450	2025-07-16 18:23:45.538903	20250718_153625	replace_import
602	5043039_1	15	17280	2025-07-16 18:23:45.543526	20250718_153625	replace_import
603	5043042_1	15	28800	2025-07-16 18:23:45.547341	20250718_153625	replace_import
604	5043041_1	15	35200	2025-07-16 18:23:45.551451	20250718_153625	replace_import
605	5053116_1	15	15400	2025-07-16 18:23:45.555264	20250718_153625	replace_import
606	5053117_1	15	46017	2025-07-16 18:23:45.559522	20250718_153625	replace_import
607	5053115_1	15	10980	2025-07-16 18:23:45.567794	20250718_153625	replace_import
608	5053112_1	15	55550	2025-07-16 18:23:45.574206	20250718_153625	replace_import
609	5053111_1	15	16740	2025-07-16 18:23:45.579452	20250718_153625	replace_import
610	5053114_1	15	22000	2025-07-16 18:23:45.589322	20250718_153625	replace_import
611	5053113_1	15	45467	2025-07-16 18:23:45.596365	20250718_153625	replace_import
612	5040304_1	14	598	2025-07-16 20:30:21.893056	20250718_153625	replace_import
613	5043003_1	12	165	2025-07-16 20:30:21.929988	20250718_153625	replace_import
614	5043018_1	12	160	2025-07-16 20:30:21.93935	20250718_153625	replace_import
615	5043019_1	12	160	2025-07-16 20:30:21.945145	20250718_153625	replace_import
616	5043020_1	12	160	2025-07-16 20:30:21.951096	20250718_153625	replace_import
617	5043021_1	12	160	2025-07-16 20:30:21.956132	20250718_153625	replace_import
618	5043022_1	12	160	2025-07-16 20:30:21.960595	20250718_153625	replace_import
619	5043023_1	12	55	2025-07-16 20:30:21.96455	20250718_153625	replace_import
620	5043024_1	12	160	2025-07-16 20:30:21.969261	20250718_153625	replace_import
621	5043025_1	12	160	2025-07-16 20:30:21.975721	20250718_153625	replace_import
622	5043026_1	12	160	2025-07-16 20:30:21.983435	20250718_153625	replace_import
623	5043027_1	12	160	2025-07-16 20:30:21.990091	20250718_153625	replace_import
624	5043028_1	12	160	2025-07-16 20:30:21.996028	20250718_153625	replace_import
625	5043029_1	12	55	2025-07-16 20:30:22.000961	20250718_153625	replace_import
626	5043031_1	12	160	2025-07-16 20:30:22.006396	20250718_153625	replace_import
627	5053006_1	12	145	2025-07-16 20:30:22.011166	20250718_153625	replace_import
628	5053007_1	12	145	2025-07-16 20:30:22.01688	20250718_153625	replace_import
629	5053008_1	12	145	2025-07-16 20:30:22.021714	20250718_153625	replace_import
630	5053009_1	12	145	2025-07-16 20:30:22.027649	20250718_153625	replace_import
631	5053013_1	12	145	2025-07-16 20:30:22.033323	20250718_153625	replace_import
632	5053014_1	12	145	2025-07-16 20:30:22.038916	20250718_153625	replace_import
633	5053015_1	12	145	2025-07-16 20:30:22.044573	20250718_153625	replace_import
634	5053016_1	12	145	2025-07-16 20:30:22.048568	20250718_153625	replace_import
635	5053017_1	12	145	2025-07-16 20:30:22.055319	20250718_153625	replace_import
636	5053018_1	12	145	2025-07-16 20:30:22.059225	20250718_153625	replace_import
637	5050903_1	9	320	2025-07-16 20:30:22.063928	20250718_153625	replace_import
638	5051908_1	9	4140	2025-07-16 20:30:22.068591	20250718_153625	replace_import
639	5043036_1	16	180000	2025-07-16 20:30:22.074052	20250718_153625	replace_import
640	5053108_1	16	180000	2025-07-16 20:30:22.078703	20250718_153625	replace_import
641	5040111_1	13	1000	2025-07-16 20:30:22.084662	20250718_153625	replace_import
642	5040502_1	13	1500	2025-07-16 20:30:22.090072	20250718_153625	replace_import
643	5040805_1	13	500	2025-07-16 20:30:22.095588	20250718_153625	replace_import
644	5041902_1	13	2000	2025-07-16 20:30:22.10091	20250718_153625	replace_import
645	5042201_1	13	500	2025-07-16 20:30:22.104641	20250718_153625	replace_import
646	5050902_1	13	3000	2025-07-16 20:30:22.108689	20250718_153625	replace_import
647	5051001_1	13	3000	2025-07-16 20:30:22.11331	20250718_153625	replace_import
648	5051306_1	13	3000	2025-07-16 20:30:22.11951	20250718_153625	replace_import
649	5051905_1	13	3000	2025-07-16 20:30:22.126598	20250718_153625	replace_import
650	5052004_1	13	500	2025-07-16 20:30:22.130478	20250718_153625	replace_import
651	5052003_1	13	5000	2025-07-16 20:30:22.135618	20250718_153625	replace_import
652	5052405_1	13	3000	2025-07-16 20:30:22.141051	20250718_153625	replace_import
653	5053003_1	13	3000	2025-07-16 20:30:22.148105	20250718_153625	replace_import
654	5053106_1	13	500	2025-07-16 20:30:22.153366	20250718_153625	replace_import
655	5060206_1	13	3000	2025-07-16 20:30:22.159402	20250718_153625	replace_import
656	5060207_1	13	3000	2025-07-16 20:30:22.16726	20250718_153625	replace_import
657	5061001_1	13	500	2025-07-16 20:30:22.173213	20250718_153625	replace_import
658	5061003_1	13	3000	2025-07-16 20:30:22.177413	20250718_153625	replace_import
659	5061304_1	13	3000	2025-07-16 20:30:22.183198	20250718_153625	replace_import
660	5061405_1	13	1500	2025-07-16 20:30:22.192973	20250718_153625	replace_import
661	5061611_1	13	3000	2025-07-16 20:30:22.200327	20250718_153625	replace_import
662	5062003_1	13	5000	2025-07-16 20:30:22.205209	20250718_153625	replace_import
663	5040702_1	14	110	2025-07-16 20:30:22.213412	20250718_153625	replace_import
664	5042601_1	14	2409	2025-07-16 20:30:22.217451	20250718_153625	replace_import
665	5050301_1	14	1771	2025-07-16 20:30:22.224509	20250718_153625	replace_import
666	5051801_1	14	217	2025-07-16 20:30:22.230462	20250718_153625	replace_import
667	5052806_1	14	220	2025-07-16 20:30:22.240319	20250718_153625	replace_import
668	5060213_1	14	712	2025-07-16 20:30:22.247636	20250718_153625	replace_import
669	5060403_1	14	44	2025-07-16 20:30:22.253329	20250718_153625	replace_import
670	5060914_1	14	2230	2025-07-16 20:30:22.26038	20250718_153625	replace_import
671	5061012_1	14	1353	2025-07-16 20:30:22.264771	20250718_153625	replace_import
672	5061004_1	14	547	2025-07-16 20:30:22.270702	20250718_153625	replace_import
673	5061404_1	14	1430	2025-07-16 20:30:22.274965	20250718_153625	replace_import
674	5061809_1	14	493	2025-07-16 20:30:22.281041	20250718_153625	replace_import
675	5061811_1	14	17160	2025-07-16 20:30:22.287563	20250718_153625	replace_import
676	5061903_1	14	8494	2025-07-16 20:30:22.292184	20250718_153625	replace_import
677	5040113_1	14	2184	2025-07-16 20:30:22.297121	20250718_153625	replace_import
678	5040202_1	14	5044	2025-07-16 20:30:22.301043	20250718_153625	replace_import
679	5040504_1	14	2322	2025-07-16 20:30:22.307284	20250718_153625	replace_import
680	5040701_1	14	7534	2025-07-16 20:30:22.312674	20250718_153625	replace_import
681	5040903_1	14	7436	2025-07-16 20:30:22.318395	20250718_153625	replace_import
682	5041401_1	14	7269	2025-07-16 20:30:22.323082	20250718_153625	replace_import
683	5041501_1	14	8000	2025-07-16 20:30:22.327003	20250718_153625	replace_import
684	5041701_1	14	9776	2025-07-16 20:30:22.330888	20250718_153625	replace_import
685	5041905_1	14	9140	2025-07-16 20:30:22.33766	20250718_153625	replace_import
686	5042102_1	14	896	2025-07-16 20:30:22.341699	20250718_153625	replace_import
687	5042101_1	14	637	2025-07-16 20:30:22.345953	20250718_153625	replace_import
688	5042401_1	14	7687	2025-07-16 20:30:22.349823	20250718_153625	replace_import
689	5042501_1	14	20711	2025-07-16 20:30:22.355017	20250718_153625	replace_import
690	5042602_1	14	4089	2025-07-16 20:30:22.359646	20250718_153625	replace_import
691	5042803_1	14	2283	2025-07-16 20:30:22.363584	20250718_153625	replace_import
692	5043005_1	14	6482	2025-07-16 20:30:22.367481	20250718_153625	replace_import
693	5050109_1	14	576	2025-07-16 20:30:22.372812	20250718_153625	replace_import
694	5050110_1	14	1770	2025-07-16 20:30:22.378921	20250718_153625	replace_import
695	5050701_1	14	12495	2025-07-16 20:30:22.382941	20250718_153625	replace_import
696	5050801_1	14	1408	2025-07-16 20:30:22.387804	20250718_153625	replace_import
697	5050912_1	14	434	2025-07-16 20:30:22.391946	20250718_153625	replace_import
698	5051202_1	14	1520	2025-07-16 20:30:22.399852	20250718_153625	replace_import
699	5051310_1	14	857	2025-07-16 20:30:22.405329	20250718_153625	replace_import
700	5051309_1	14	5105	2025-07-16 20:30:22.414776	20250718_153625	replace_import
701	5051401_1	14	213	2025-07-16 20:30:22.418337	20250718_153625	replace_import
702	5051410_1	14	3074	2025-07-16 20:30:22.426267	20250718_153625	replace_import
703	5051501_1	14	2479	2025-07-16 20:30:22.431659	20250718_153625	replace_import
704	5052201_1	14	792	2025-07-16 20:30:22.437887	20250718_153625	replace_import
705	5052202_1	14	3580	2025-07-16 20:30:22.443254	20250718_153625	replace_import
706	5052307_1	14	11061	2025-07-16 20:30:22.450254	20250718_153625	replace_import
707	5052404_1	14	1155	2025-07-16 20:30:22.455435	20250718_153625	replace_import
708	5052605_1	14	8913	2025-07-16 20:30:22.459522	20250718_153625	replace_import
709	5052701_1	14	4397	2025-07-16 20:30:22.464343	20250718_153625	replace_import
710	5052802_1	14	9573	2025-07-16 20:30:22.469143	20250718_153625	replace_import
711	5052804_1	14	3557	2025-07-16 20:30:22.473039	20250718_153625	replace_import
712	5052901_1	14	11975	2025-07-16 20:30:22.477553	20250718_153625	replace_import
713	5053005_1	14	19441	2025-07-16 20:30:22.480846	20250718_153625	replace_import
714	5053101_1	14	3724	2025-07-16 20:30:22.484656	20250718_153625	replace_import
715	5060208_1	14	10874	2025-07-16 20:30:22.491012	20250718_153625	replace_import
716	5060212_1	14	404	2025-07-16 20:30:22.49535	20250718_153625	replace_import
717	5060401_1	14	3759	2025-07-16 20:30:22.499532	20250718_153625	replace_import
718	5060601_1	14	9876	2025-07-16 20:30:22.507907	20250718_153625	replace_import
719	5060602_1	14	19676	2025-07-16 20:30:22.512293	20250718_153625	replace_import
720	5060910_1	14	835	2025-07-16 20:30:22.517579	20250718_153625	replace_import
721	5060904_1	14	859	2025-07-16 20:30:22.522469	20250718_153625	replace_import
722	5061010_1	14	8372	2025-07-16 20:30:22.526597	20250718_153625	replace_import
723	5061105_1	14	28784	2025-07-16 20:30:22.530719	20250718_153625	replace_import
724	5061302_1	14	9080	2025-07-16 20:30:22.534717	20250718_153625	replace_import
725	5061307_1	14	233	2025-07-16 20:30:22.539021	20250718_153625	replace_import
726	5061308_1	14	18982	2025-07-16 20:30:22.543828	20250718_153625	replace_import
727	5061403_1	14	16496	2025-07-16 20:30:22.549065	20250718_153625	replace_import
728	5061401_1	14	6021	2025-07-16 20:30:22.553318	20250718_153625	replace_import
729	5061613_1	14	1810	2025-07-16 20:30:22.55842	20250718_153625	replace_import
730	5061703_1	14	2012	2025-07-16 20:30:22.562317	20250718_153625	replace_import
731	5061701_1	14	246	2025-07-16 20:30:22.567361	20250718_153625	replace_import
732	5061704_1	14	2129	2025-07-16 20:30:22.571193	20250718_153625	replace_import
733	5061803_1	14	8009	2025-07-16 20:30:22.574517	20250718_153625	replace_import
734	5061804_1	14	4914	2025-07-16 20:30:22.578304	20250718_153625	replace_import
735	5061805_1	14	5406	2025-07-16 20:30:22.581767	20250718_153625	replace_import
736	5062001_1	14	7377	2025-07-16 20:30:22.586638	20250718_153625	replace_import
737	5062007_1	14	1300	2025-07-16 20:30:22.590857	20250718_153625	replace_import
738	5062016_1	14	14001	2025-07-16 20:30:22.595976	20250718_153625	replace_import
739	5062102_1	14	4086	2025-07-16 20:30:22.60034	20250718_153625	replace_import
740	5062105_1	14	213	2025-07-16 20:30:22.609325	20250718_153625	replace_import
741	5062201_1	14	10343	2025-07-16 20:30:22.612621	20250718_153625	replace_import
742	5062315_1	14	355	2025-07-16 20:30:22.616523	20250718_153625	replace_import
743	5062316_1	14	5900	2025-07-16 20:30:22.621934	20250718_153625	replace_import
744	5062405_1	14	1404	2025-07-16 20:30:22.62573	20250718_153625	replace_import
745	5062408_1	14	6497	2025-07-16 20:30:22.630845	20250718_153625	replace_import
746	5062607_1	14	5780	2025-07-16 20:30:22.634958	20250718_153625	replace_import
747	5062701_1	14	7753	2025-07-16 20:30:22.639331	20250718_153625	replace_import
748	5062712_1	14	6116	2025-07-16 20:30:22.645243	20250718_153625	replace_import
749	5062716_1	14	11166	2025-07-16 20:30:22.650294	20250718_153625	replace_import
750	5062717_1	14	20527	2025-07-16 20:30:22.654157	20250718_153625	replace_import
751	5062801_1	14	4230	2025-07-16 20:30:22.658202	20250718_153625	replace_import
752	5062802_1	14	2023	2025-07-16 20:30:22.662009	20250718_153625	replace_import
753	5062803_1	14	3680	2025-07-16 20:30:22.66682	20250718_153625	replace_import
754	5062901_1	14	2818	2025-07-16 20:30:22.670232	20250718_153625	replace_import
755	5040901_1	11	3094	2025-07-16 20:30:22.673792	20250718_153625	replace_import
756	5041703_1	11	25962	2025-07-16 20:30:22.677639	20250718_153625	replace_import
757	5042405_1	11	8349	2025-07-16 20:30:22.681057	20250718_153625	replace_import
758	5052001_1	11	20088	2025-07-16 20:30:22.68456	20250718_153625	replace_import
759	5052501_1	11	6395	2025-07-16 20:30:22.688248	20250718_153625	replace_import
760	5060913_1	11	2819	2025-07-16 20:30:22.691625	20250718_153625	replace_import
761	5042808_1	10	150800	2025-07-16 20:30:22.695388	20250718_153625	replace_import
762	5052812_1	10	150800	2025-07-16 20:30:22.699079	20250718_153625	replace_import
763	5040102_1	17	16500	2025-07-16 20:30:22.704543	20250718_153625	replace_import
764	5042605_1	17	10780	2025-07-16 20:30:22.709129	20250718_153625	replace_import
765	5042807_1	17	8225	2025-07-16 20:30:22.713031	20250718_153625	replace_import
766	5050102_1	17	16500	2025-07-16 20:30:22.716653	20250718_153625	replace_import
767	5051408_1	17	10890	2025-07-16 20:30:22.720273	20250718_153625	replace_import
768	5051409_1	17	10890	2025-07-16 20:30:22.723986	20250718_153625	replace_import
769	5052601_1	17	7909	2025-07-16 20:30:22.727627	20250718_153625	replace_import
770	5052602_1	17	10780	2025-07-16 20:30:22.73112	20250718_153625	replace_import
771	5060104_1	17	16500	2025-07-16 20:30:22.735918	20250718_153625	replace_import
772	5062608_1	17	7539	2025-07-16 20:30:22.741677	20250718_153625	replace_import
773	5062609_1	17	10780	2025-07-16 20:30:22.746353	20250718_153625	replace_import
774	5070102_1	17	16500	2025-07-16 20:30:22.750118	20250718_153625	replace_import
775	5061007_1	18	29250	2025-07-16 20:30:22.754801	20250718_153625	replace_import
776	5043044_1	15	26400	2025-07-16 20:30:22.758743	20250718_153625	replace_import
777	5043045_1	15	66000	2025-07-16 20:30:22.762203	20250718_153625	replace_import
778	5043043_1	15	45360	2025-07-16 20:30:22.766428	20250718_153625	replace_import
779	5043040_1	15	43450	2025-07-16 20:30:22.769768	20250718_153625	replace_import
780	5043039_1	15	17280	2025-07-16 20:30:22.773903	20250718_153625	replace_import
781	5043042_1	15	28800	2025-07-16 20:30:22.778177	20250718_153625	replace_import
782	5043041_1	15	35200	2025-07-16 20:30:22.781825	20250718_153625	replace_import
783	5053116_1	15	15400	2025-07-16 20:30:22.785221	20250718_153625	replace_import
784	5053117_1	15	46017	2025-07-16 20:30:22.789701	20250718_153625	replace_import
785	5053115_1	15	10980	2025-07-16 20:30:22.793251	20250718_153625	replace_import
786	5053112_1	15	55550	2025-07-16 20:30:22.797152	20250718_153625	replace_import
787	5053111_1	15	16740	2025-07-16 20:30:22.802115	20250718_153625	replace_import
788	5053114_1	15	22000	2025-07-16 20:30:22.80566	20250718_153625	replace_import
789	5053113_1	15	45467	2025-07-16 20:30:22.809403	20250718_153625	replace_import
790	5040304_1	14	598	2025-07-16 20:42:14.989376	20250718_153625	replace_import
791	5043003_1	12	165	2025-07-16 20:42:15.078206	20250718_153625	replace_import
792	5043018_1	12	160	2025-07-16 20:42:15.090392	20250718_153625	replace_import
793	5043019_1	12	160	2025-07-16 20:42:15.098408	20250718_153625	replace_import
794	5043020_1	12	160	2025-07-16 20:42:15.107911	20250718_153625	replace_import
795	5043021_1	12	160	2025-07-16 20:42:15.11193	20250718_153625	replace_import
796	5043022_1	12	160	2025-07-16 20:42:15.118719	20250718_153625	replace_import
797	5043023_1	12	55	2025-07-16 20:42:15.126193	20250718_153625	replace_import
798	5043024_1	12	160	2025-07-16 20:42:15.130348	20250718_153625	replace_import
799	5043025_1	12	160	2025-07-16 20:42:15.134216	20250718_153625	replace_import
800	5043026_1	12	160	2025-07-16 20:42:15.140574	20250718_153625	replace_import
801	5043027_1	12	160	2025-07-16 20:42:15.146959	20250718_153625	replace_import
802	5043028_1	12	160	2025-07-16 20:42:15.152941	20250718_153625	replace_import
803	5043029_1	12	55	2025-07-16 20:42:15.157623	20250718_153625	replace_import
804	5043031_1	12	160	2025-07-16 20:42:15.162457	20250718_153625	replace_import
805	5053006_1	12	145	2025-07-16 20:42:15.168516	20250718_153625	replace_import
806	5053007_1	12	145	2025-07-16 20:42:15.175419	20250718_153625	replace_import
807	5053008_1	12	145	2025-07-16 20:42:15.182347	20250718_153625	replace_import
808	5053009_1	12	145	2025-07-16 20:42:15.191544	20250718_153625	replace_import
809	5053013_1	12	145	2025-07-16 20:42:15.198535	20250718_153625	replace_import
810	5053014_1	12	145	2025-07-16 20:42:15.203893	20250718_153625	replace_import
811	5053015_1	12	145	2025-07-16 20:42:15.209831	20250718_153625	replace_import
812	5053016_1	12	145	2025-07-16 20:42:15.215331	20250718_153625	replace_import
813	5053017_1	12	145	2025-07-16 20:42:15.219471	20250718_153625	replace_import
814	5053018_1	12	145	2025-07-16 20:42:15.225446	20250718_153625	replace_import
815	5050903_1	9	320	2025-07-16 20:42:15.229671	20250718_153625	replace_import
816	5051908_1	9	4140	2025-07-16 20:42:15.235858	20250718_153625	replace_import
817	5043036_1	16	180000	2025-07-16 20:42:15.242635	20250718_153625	replace_import
818	5053108_1	16	180000	2025-07-16 20:42:15.247711	20250718_153625	replace_import
819	5040111_1	13	1000	2025-07-16 20:42:15.253138	20250718_153625	replace_import
820	5040502_1	13	1500	2025-07-16 20:42:15.25934	20250718_153625	replace_import
821	5040805_1	13	500	2025-07-16 20:42:15.265092	20250718_153625	replace_import
822	5041902_1	13	2000	2025-07-16 20:42:15.274407	20250718_153625	replace_import
823	5042201_1	13	500	2025-07-16 20:42:15.279115	20250718_153625	replace_import
824	5050902_1	13	3000	2025-07-16 20:42:15.283952	20250718_153625	replace_import
825	5051001_1	13	3000	2025-07-16 20:42:15.288295	20250718_153625	replace_import
826	5051306_1	13	3000	2025-07-16 20:42:15.293264	20250718_153625	replace_import
827	5051905_1	13	3000	2025-07-16 20:42:15.296961	20250718_153625	replace_import
828	5052004_1	13	500	2025-07-16 20:42:15.300882	20250718_153625	replace_import
829	5052003_1	13	5000	2025-07-16 20:42:15.305134	20250718_153625	replace_import
830	5052405_1	13	3000	2025-07-16 20:42:15.309805	20250718_153625	replace_import
831	5053003_1	13	3000	2025-07-16 20:42:15.313903	20250718_153625	replace_import
832	5053106_1	13	500	2025-07-16 20:42:15.319112	20250718_153625	replace_import
833	5060206_1	13	3000	2025-07-16 20:42:15.324803	20250718_153625	replace_import
834	5060207_1	13	3000	2025-07-16 20:42:15.329743	20250718_153625	replace_import
835	5061001_1	13	500	2025-07-16 20:42:15.333957	20250718_153625	replace_import
836	5061003_1	13	3000	2025-07-16 20:42:15.340546	20250718_153625	replace_import
837	5061304_1	13	3000	2025-07-16 20:42:15.344305	20250718_153625	replace_import
838	5061405_1	13	1500	2025-07-16 20:42:15.352523	20250718_153625	replace_import
839	5061611_1	13	3000	2025-07-16 20:42:15.357271	20250718_153625	replace_import
840	5062003_1	13	5000	2025-07-16 20:42:15.361273	20250718_153625	replace_import
841	5040702_1	14	110	2025-07-16 20:42:15.366179	20250718_153625	replace_import
842	5042601_1	14	2409	2025-07-16 20:42:15.374825	20250718_153625	replace_import
843	5050301_1	14	1771	2025-07-16 20:42:15.381214	20250718_153625	replace_import
844	5051801_1	14	217	2025-07-16 20:42:15.387524	20250718_153625	replace_import
845	5052806_1	14	220	2025-07-16 20:42:15.393151	20250718_153625	replace_import
846	5060213_1	14	712	2025-07-16 20:42:15.400489	20250718_153625	replace_import
847	5060403_1	14	44	2025-07-16 20:42:15.405774	20250718_153625	replace_import
848	5060914_1	14	2230	2025-07-16 20:42:15.412657	20250718_153625	replace_import
849	5061012_1	14	1353	2025-07-16 20:42:15.418394	20250718_153625	replace_import
850	5061004_1	14	547	2025-07-16 20:42:15.423389	20250718_153625	replace_import
851	5061404_1	14	1430	2025-07-16 20:42:15.427523	20250718_153625	replace_import
852	5061809_1	14	493	2025-07-16 20:42:15.432679	20250718_153625	replace_import
853	5061811_1	14	17160	2025-07-16 20:42:15.437207	20250718_153625	replace_import
854	5061903_1	14	8494	2025-07-16 20:42:15.44109	20250718_153625	replace_import
855	5040113_1	14	2184	2025-07-16 20:42:15.444991	20250718_153625	replace_import
856	5040202_1	14	5044	2025-07-16 20:42:15.449169	20250718_153625	replace_import
857	5040504_1	14	2322	2025-07-16 20:42:15.454435	20250718_153625	replace_import
858	5040701_1	14	7534	2025-07-16 20:42:15.458409	20250718_153625	replace_import
859	5040903_1	14	7436	2025-07-16 20:42:15.469523	20250718_153625	replace_import
860	5041401_1	14	7269	2025-07-16 20:42:15.475788	20250718_153625	replace_import
861	5041501_1	14	8000	2025-07-16 20:42:15.480969	20250718_153625	replace_import
862	5041701_1	14	9776	2025-07-16 20:42:15.493579	20250718_153625	replace_import
863	5041905_1	14	9140	2025-07-16 20:42:15.499431	20250718_153625	replace_import
864	5042102_1	14	896	2025-07-16 20:42:15.504998	20250718_153625	replace_import
865	5042101_1	14	637	2025-07-16 20:42:15.50928	20250718_153625	replace_import
866	5042401_1	14	7687	2025-07-16 20:42:15.513497	20250718_153625	replace_import
867	5042501_1	14	20711	2025-07-16 20:42:15.520491	20250718_153625	replace_import
868	5042602_1	14	4089	2025-07-16 20:42:15.52607	20250718_153625	replace_import
869	5042803_1	14	2283	2025-07-16 20:42:15.530473	20250718_153625	replace_import
870	5043005_1	14	6482	2025-07-16 20:42:15.534414	20250718_153625	replace_import
871	5050109_1	14	576	2025-07-16 20:42:15.540585	20250718_153625	replace_import
872	5050110_1	14	1770	2025-07-16 20:42:15.545672	20250718_153625	replace_import
873	5050701_1	14	12495	2025-07-16 20:42:15.550498	20250718_153625	replace_import
874	5050801_1	14	1408	2025-07-16 20:42:15.554383	20250718_153625	replace_import
875	5050912_1	14	434	2025-07-16 20:42:15.558287	20250718_153625	replace_import
876	5051202_1	14	1520	2025-07-16 20:42:15.562847	20250718_153625	replace_import
877	5051310_1	14	857	2025-07-16 20:42:15.566321	20250718_153625	replace_import
878	5051309_1	14	5105	2025-07-16 20:42:15.570008	20250718_153625	replace_import
879	5051401_1	14	213	2025-07-16 20:42:15.573409	20250718_153625	replace_import
880	5051410_1	14	3074	2025-07-16 20:42:15.577538	20250718_153625	replace_import
881	5051501_1	14	2479	2025-07-16 20:42:15.581434	20250718_153625	replace_import
882	5052201_1	14	792	2025-07-16 20:42:15.590169	20250718_153625	replace_import
883	5052202_1	14	3580	2025-07-16 20:42:15.595095	20250718_153625	replace_import
884	5052307_1	14	11061	2025-07-16 20:42:15.59904	20250718_153625	replace_import
885	5052404_1	14	1155	2025-07-16 20:42:15.60346	20250718_153625	replace_import
886	5052605_1	14	8913	2025-07-16 20:42:15.607215	20250718_153625	replace_import
887	5052701_1	14	4397	2025-07-16 20:42:15.614156	20250718_153625	replace_import
888	5052802_1	14	9573	2025-07-16 20:42:15.61945	20250718_153625	replace_import
889	5052804_1	14	3557	2025-07-16 20:42:15.622944	20250718_153625	replace_import
890	5052901_1	14	11975	2025-07-16 20:42:15.627444	20250718_153625	replace_import
891	5053005_1	14	19441	2025-07-16 20:42:15.635444	20250718_153625	replace_import
892	5053101_1	14	3724	2025-07-16 20:42:15.6403	20250718_153625	replace_import
893	5060208_1	14	10874	2025-07-16 20:42:15.643741	20250718_153625	replace_import
894	5060212_1	14	404	2025-07-16 20:42:15.646806	20250718_153625	replace_import
895	5060401_1	14	3759	2025-07-16 20:42:15.650623	20250718_153625	replace_import
896	5060601_1	14	9876	2025-07-16 20:42:15.654536	20250718_153625	replace_import
897	5060602_1	14	19676	2025-07-16 20:42:15.661544	20250718_153625	replace_import
898	5060910_1	14	835	2025-07-16 20:42:15.665078	20250718_153625	replace_import
899	5060904_1	14	859	2025-07-16 20:42:15.669373	20250718_153625	replace_import
900	5061010_1	14	8372	2025-07-16 20:42:15.673071	20250718_153625	replace_import
901	5061105_1	14	28784	2025-07-16 20:42:15.677184	20250718_153625	replace_import
902	5061302_1	14	9080	2025-07-16 20:42:15.680764	20250718_153625	replace_import
903	5061307_1	14	233	2025-07-16 20:42:15.684454	20250718_153625	replace_import
904	5061308_1	14	18982	2025-07-16 20:42:15.688113	20250718_153625	replace_import
905	5061403_1	14	16496	2025-07-16 20:42:15.693029	20250718_153625	replace_import
906	5061401_1	14	6021	2025-07-16 20:42:15.697766	20250718_153625	replace_import
907	5061613_1	14	1810	2025-07-16 20:42:15.701304	20250718_153625	replace_import
908	5061703_1	14	2012	2025-07-16 20:42:15.705043	20250718_153625	replace_import
909	5061701_1	14	246	2025-07-16 20:42:15.709834	20250718_153625	replace_import
910	5061704_1	14	2129	2025-07-16 20:42:15.714546	20250718_153625	replace_import
911	5061803_1	14	8009	2025-07-16 20:42:15.71832	20250718_153625	replace_import
912	5061804_1	14	4914	2025-07-16 20:42:15.721654	20250718_153625	replace_import
913	5061805_1	14	5406	2025-07-16 20:42:15.725748	20250718_153625	replace_import
914	5062001_1	14	7377	2025-07-16 20:42:15.72918	20250718_153625	replace_import
915	5062007_1	14	1300	2025-07-16 20:42:15.732668	20250718_153625	replace_import
916	5062016_1	14	14001	2025-07-16 20:42:15.73604	20250718_153625	replace_import
917	5062102_1	14	4086	2025-07-16 20:42:15.741791	20250718_153625	replace_import
918	5062105_1	14	213	2025-07-16 20:42:15.745792	20250718_153625	replace_import
919	5062201_1	14	10343	2025-07-16 20:42:15.749707	20250718_153625	replace_import
920	5062315_1	14	355	2025-07-16 20:42:15.753418	20250718_153625	replace_import
921	5062316_1	14	5900	2025-07-16 20:42:15.757576	20250718_153625	replace_import
922	5062405_1	14	1404	2025-07-16 20:42:15.760855	20250718_153625	replace_import
923	5062408_1	14	6497	2025-07-16 20:42:15.764131	20250718_153625	replace_import
924	5062607_1	14	5780	2025-07-16 20:42:15.768152	20250718_153625	replace_import
925	5062701_1	14	7753	2025-07-16 20:42:15.771901	20250718_153625	replace_import
926	5062712_1	14	6116	2025-07-16 20:42:15.775713	20250718_153625	replace_import
927	5062716_1	14	11166	2025-07-16 20:42:15.781005	20250718_153625	replace_import
928	5062717_1	14	20527	2025-07-16 20:42:15.784439	20250718_153625	replace_import
929	5062801_1	14	4230	2025-07-16 20:42:15.787548	20250718_153625	replace_import
930	5062802_1	14	2023	2025-07-16 20:42:15.790586	20250718_153625	replace_import
931	5062803_1	14	3680	2025-07-16 20:42:15.803945	20250718_153625	replace_import
932	5062901_1	14	2818	2025-07-16 20:42:15.807319	20250718_153625	replace_import
933	5040901_1	11	3094	2025-07-16 20:42:15.810938	20250718_153625	replace_import
934	5041703_1	11	25962	2025-07-16 20:42:15.817258	20250718_153625	replace_import
935	5042405_1	11	8349	2025-07-16 20:42:15.82208	20250718_153625	replace_import
936	5052001_1	11	20088	2025-07-16 20:42:15.825618	20250718_153625	replace_import
937	5052501_1	11	6395	2025-07-16 20:42:15.830385	20250718_153625	replace_import
938	5060913_1	11	2819	2025-07-16 20:42:15.834533	20250718_153625	replace_import
939	5042808_1	10	150800	2025-07-16 20:42:15.841165	20250718_153625	replace_import
940	5052812_1	10	150800	2025-07-16 20:42:15.845099	20250718_153625	replace_import
941	5040102_1	17	16500	2025-07-16 20:42:15.850578	20250718_153625	replace_import
942	5042605_1	17	10780	2025-07-16 20:42:15.854849	20250718_153625	replace_import
943	5042807_1	17	8225	2025-07-16 20:42:15.859639	20250718_153625	replace_import
944	5050102_1	17	16500	2025-07-16 20:42:15.863155	20250718_153625	replace_import
945	5051408_1	17	10890	2025-07-16 20:42:15.86804	20250718_153625	replace_import
946	5051409_1	17	10890	2025-07-16 20:42:15.874825	20250718_153625	replace_import
947	5052601_1	17	7909	2025-07-16 20:42:15.882761	20250718_153625	replace_import
948	5052602_1	17	10780	2025-07-16 20:42:15.887556	20250718_153625	replace_import
949	5060104_1	17	16500	2025-07-16 20:42:15.893151	20250718_153625	replace_import
950	5062608_1	17	7539	2025-07-16 20:42:15.896796	20250718_153625	replace_import
951	5062609_1	17	10780	2025-07-16 20:42:15.901554	20250718_153625	replace_import
952	5070102_1	17	16500	2025-07-16 20:42:15.90466	20250718_153625	replace_import
953	5061007_1	18	29250	2025-07-16 20:42:16.347333	20250718_153625	replace_import
954	5043044_1	15	26400	2025-07-16 20:42:16.353329	20250718_153625	replace_import
955	5043045_1	15	66000	2025-07-16 20:42:16.358231	20250718_153625	replace_import
956	5043043_1	15	45360	2025-07-16 20:42:16.36374	20250718_153625	replace_import
957	5043040_1	15	43450	2025-07-16 20:42:16.372308	20250718_153625	replace_import
958	5043039_1	15	17280	2025-07-16 20:42:16.380562	20250718_153625	replace_import
959	5043042_1	15	28800	2025-07-16 20:42:16.385289	20250718_153625	replace_import
960	5043041_1	15	35200	2025-07-16 20:42:16.391174	20250718_153625	replace_import
961	5053116_1	15	15400	2025-07-16 20:42:16.397586	20250718_153625	replace_import
962	5053117_1	15	46017	2025-07-16 20:42:16.404015	20250718_153625	replace_import
963	5053115_1	15	10980	2025-07-16 20:42:16.408383	20250718_153625	replace_import
964	5053112_1	15	55550	2025-07-16 20:42:16.412802	20250718_153625	replace_import
965	5053111_1	15	16740	2025-07-16 20:42:16.416704	20250718_153625	replace_import
966	5053114_1	15	22000	2025-07-16 20:42:16.422027	20250718_153625	replace_import
967	5053113_1	15	45467	2025-07-16 20:42:16.42774	20250718_153625	replace_import
\.


--
-- Data for Name: allocation_backups_20250718_162116; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.allocation_backups_20250718_162116 (id, transaction_id, budget_item_id, amount, created_at, backup_timestamp, backup_reason) FROM stdin;
256	5040304_1	14	598	2025-07-16 18:09:55.108142	20250718_162116	replace_import
257	5043003_1	12	165	2025-07-16 18:09:55.136204	20250718_162116	replace_import
258	5043018_1	12	160	2025-07-16 18:09:55.14677	20250718_162116	replace_import
259	5043019_1	12	160	2025-07-16 18:09:55.151646	20250718_162116	replace_import
260	5043020_1	12	160	2025-07-16 18:09:55.155448	20250718_162116	replace_import
261	5043021_1	12	160	2025-07-16 18:09:55.160905	20250718_162116	replace_import
262	5043022_1	12	160	2025-07-16 18:09:55.167204	20250718_162116	replace_import
263	5043023_1	12	55	2025-07-16 18:09:55.172442	20250718_162116	replace_import
264	5043024_1	12	160	2025-07-16 18:09:55.177109	20250718_162116	replace_import
265	5043025_1	12	160	2025-07-16 18:09:55.181877	20250718_162116	replace_import
266	5043026_1	12	160	2025-07-16 18:09:55.186932	20250718_162116	replace_import
267	5043027_1	12	160	2025-07-16 18:09:55.192127	20250718_162116	replace_import
268	5043028_1	12	160	2025-07-16 18:09:55.196419	20250718_162116	replace_import
269	5043029_1	12	55	2025-07-16 18:09:55.200327	20250718_162116	replace_import
270	5043031_1	12	160	2025-07-16 18:09:55.204369	20250718_162116	replace_import
53	5040103_1	30	336469	2025-07-09 11:24:43.186655	20250718_162116	replace_import
54	5040105_1	30	60000	2025-07-09 11:24:43.186662	20250718_162116	replace_import
273	5053008_1	12	145	2025-07-16 18:09:55.219977	20250718_162116	replace_import
59	5050703_1	21	5732	2025-07-09 11:24:43.186672	20250718_162116	replace_import
60	5050909_1	21	9155	2025-07-09 11:24:43.186674	20250718_162116	replace_import
61	5051101_1	21	3453	2025-07-09 11:24:43.186676	20250718_162116	replace_import
62	5051502_1	21	8876	2025-07-09 11:24:43.186678	20250718_162116	replace_import
63	5051803_1	21	6118	2025-07-09 11:24:43.18668	20250718_162116	replace_import
64	5051903_1	21	3230	2025-07-09 11:24:43.186682	20250718_162116	replace_import
276	5053014_1	12	145	2025-07-16 18:09:55.234501	20250718_162116	replace_import
169	5051605_1	22	250	2025-07-14 07:08:54.34884	20250718_162116	replace_import
278	5053016_1	12	145	2025-07-16 18:09:55.242152	20250718_162116	replace_import
171	5051412_1	22	2420	2025-07-14 07:09:09.771673	20250718_162116	replace_import
172	5051402_1	22	530	2025-07-14 07:09:15.474441	20250718_162116	replace_import
173	5052002_1	21	963	2025-07-14 08:07:08.833452	20250718_162116	replace_import
174	5052102_1	21	10593	2025-07-14 08:07:16.038828	20250718_162116	replace_import
176	5052902_1	22	12080	2025-07-14 09:49:25.923549	20250718_162116	replace_import
180	5040113_1	14	2184	2025-07-15 10:14:48.012676	20250718_162116	replace_import
182	5040504_1	14	2322	2025-07-15 10:14:48.012718	20250718_162116	replace_import
189	5042101_1	14	637	2025-07-15 10:14:48.012734	20250718_162116	replace_import
194	5043005_1	14	6482	2025-07-15 10:14:48.012745	20250718_162116	replace_import
197	5050801_1	14	1408	2025-07-15 10:14:48.012751	20250718_162116	replace_import
204	5051701_1	14	3054	2025-07-15 10:14:48.012766	20250718_162116	replace_import
214	5053101_1	14	3724	2025-07-15 10:14:48.012787	20250718_162116	replace_import
222	5061010_1	14	8372	2025-07-15 10:14:48.012804	20250718_162116	replace_import
233	5061805_1	14	5406	2025-07-15 10:14:48.012827	20250718_162116	replace_import
238	5062105_1	14	213	2025-07-15 10:14:48.012837	20250718_162116	replace_import
251	5062803_1	14	3680	2025-07-15 10:14:48.012864	20250718_162116	replace_import
253	5070202_1	14	501	2025-07-15 10:14:48.012869	20250718_162116	replace_import
254	5062410_1	14	1628	2025-07-15 10:14:48.012871	20250718_162116	replace_import
255	5062714_1	14	283	2025-07-15 10:14:48.012873	20250718_162116	replace_import
55	5051402_1	22	598	2025-07-15 15:14:35.390194	20250718_162116	replace_import
56	5051412_1	22	5000	2025-07-15 15:14:35.39022	20250718_162116	replace_import
57	5051605_1	22	336469	2025-07-15 15:14:35.390223	20250718_162116	replace_import
58	5052902_1	22	60000	2025-07-15 15:14:35.390226	20250718_162116	replace_import
291	5051001_1	13	3000	2025-07-16 18:09:55.307756	20250718_162116	replace_import
295	5052003_1	13	5000	2025-07-16 18:09:55.324996	20250718_162116	replace_import
301	5061001_1	13	500	2025-07-16 18:09:55.354785	20250718_162116	replace_import
308	5042601_1	14	2409	2025-07-16 18:09:55.385119	20250718_162116	replace_import
312	5060213_1	14	712	2025-07-16 18:09:55.406619	20250718_162116	replace_import
315	5061012_1	14	1353	2025-07-16 18:09:55.419445	20250718_162116	replace_import
316	5061004_1	14	547	2025-07-16 18:09:55.423818	20250718_162116	replace_import
318	5061809_1	14	493	2025-07-16 18:09:55.431133	20250718_162116	replace_import
319	5061811_1	14	17160	2025-07-16 18:09:55.437216	20250718_162116	replace_import
322	5040202_1	14	5044	2025-07-16 18:09:55.447767	20250718_162116	replace_import
328	5041701_1	14	9776	2025-07-16 18:09:55.47338	20250718_162116	replace_import
344	5051309_1	14	5105	2025-07-16 18:09:55.539256	20250718_162116	replace_import
351	5052404_1	14	1155	2025-07-16 18:09:55.573323	20250718_162116	replace_import
352	5052605_1	14	8913	2025-07-16 18:09:55.576829	20250718_162116	replace_import
359	5060208_1	14	10874	2025-07-16 18:09:55.602938	20250718_162116	replace_import
360	5060212_1	14	404	2025-07-16 18:09:55.606491	20250718_162116	replace_import
364	5060910_1	14	835	2025-07-16 18:09:55.624133	20250718_162116	replace_import
367	5061105_1	14	28784	2025-07-16 18:09:55.637752	20250718_162116	replace_import
368	5061302_1	14	9080	2025-07-16 18:09:55.642479	20250718_162116	replace_import
375	5061701_1	14	246	2025-07-16 18:09:55.671307	20250718_162116	replace_import
383	5062102_1	14	4086	2025-07-16 18:09:55.702677	20250718_162116	replace_import
386	5062315_1	14	355	2025-07-16 18:09:55.713803	20250718_162116	replace_import
387	5062316_1	14	5900	2025-07-16 18:09:55.71918	20250718_162116	replace_import
388	5062405_1	14	1404	2025-07-16 18:09:55.7229	20250718_162116	replace_import
389	5062408_1	14	6497	2025-07-16 18:09:55.728207	20250718_162116	replace_import
391	5062701_1	14	7753	2025-07-16 18:09:55.737415	20250718_162116	replace_import
402	5052001_1	11	20088	2025-07-16 18:09:55.788138	20250718_162116	replace_import
405	5042808_1	10	150800	2025-07-16 18:09:55.799376	20250718_162116	replace_import
414	5052602_1	17	10780	2025-07-16 18:09:55.834732	20250718_162116	replace_import
415	5060104_1	17	16500	2025-07-16 18:09:55.839123	20250718_162116	replace_import
417	5062609_1	17	10780	2025-07-16 18:09:55.847664	20250718_162116	replace_import
420	5043044_1	15	26400	2025-07-16 18:09:55.859743	20250718_162116	replace_import
421	5043045_1	15	66000	2025-07-16 18:09:55.863535	20250718_162116	replace_import
422	5043043_1	15	45360	2025-07-16 18:09:55.868285	20250718_162116	replace_import
423	5043040_1	15	43450	2025-07-16 18:09:55.871838	20250718_162116	replace_import
424	5043039_1	15	17280	2025-07-16 18:09:55.875144	20250718_162116	replace_import
425	5043042_1	15	28800	2025-07-16 18:09:55.881469	20250718_162116	replace_import
426	5043041_1	15	35200	2025-07-16 18:09:55.885293	20250718_162116	replace_import
453	5053013_1	12	145	2025-07-16 18:23:44.684152	20250718_162116	replace_import
457	5053017_1	12	145	2025-07-16 18:23:44.706172	20250718_162116	replace_import
458	5053018_1	12	145	2025-07-16 18:23:44.710508	20250718_162116	replace_import
461	5043036_1	16	180000	2025-07-16 18:23:44.72543	20250718_162116	replace_import
462	5053108_1	16	180000	2025-07-16 18:23:44.732221	20250718_162116	replace_import
466	5041902_1	13	2000	2025-07-16 18:23:44.753203	20250718_162116	replace_import
474	5052405_1	13	3000	2025-07-16 18:23:44.787709	20250718_162116	replace_import
476	5053106_1	13	500	2025-07-16 18:23:44.796905	20250718_162116	replace_import
478	5060207_1	13	3000	2025-07-16 18:23:44.806713	20250718_162116	replace_import
481	5061304_1	13	3000	2025-07-16 18:23:44.82021	20250718_162116	replace_import
482	5061405_1	13	1500	2025-07-16 18:23:44.826478	20250718_162116	replace_import
483	5061611_1	13	3000	2025-07-16 18:23:44.831088	20250718_162116	replace_import
505	5041501_1	14	8000	2025-07-16 18:23:44.954709	20250718_162116	replace_import
511	5042501_1	14	20711	2025-07-16 18:23:44.989675	20250718_162116	replace_import
517	5050701_1	14	12495	2025-07-16 18:23:45.024522	20250718_162116	replace_import
521	5051310_1	14	857	2025-07-16 18:23:45.04971	20250718_162116	replace_import
525	5051501_1	14	2479	2025-07-16 18:23:45.06934	20250718_162116	replace_import
526	5052201_1	14	792	2025-07-16 18:23:45.073802	20250718_162116	replace_import
527	5052202_1	14	3580	2025-07-16 18:23:45.07858	20250718_162116	replace_import
534	5052901_1	14	11975	2025-07-16 18:23:45.1164	20250718_162116	replace_import
539	5060401_1	14	3759	2025-07-16 18:23:45.145062	20250718_162116	replace_import
541	5060602_1	14	19676	2025-07-16 18:23:45.15805	20250718_162116	replace_import
556	5061804_1	14	4914	2025-07-16 18:23:45.235886	20250718_162116	replace_import
563	5062201_1	14	10343	2025-07-16 18:23:45.273765	20250718_162116	replace_import
577	5040901_1	11	3094	2025-07-16 18:23:45.41504	20250718_162116	replace_import
578	5041703_1	11	25962	2025-07-16 18:23:45.424888	20250718_162116	replace_import
584	5052812_1	10	150800	2025-07-16 18:23:45.451956	20250718_162116	replace_import
586	5042605_1	17	10780	2025-07-16 18:23:45.460948	20250718_162116	replace_import
588	5050102_1	17	16500	2025-07-16 18:23:45.470556	20250718_162116	replace_import
605	5053116_1	15	15400	2025-07-16 18:23:45.555264	20250718_162116	replace_import
606	5053117_1	15	46017	2025-07-16 18:23:45.559522	20250718_162116	replace_import
630	5053009_1	12	145	2025-07-16 20:30:22.027649	20250718_162116	replace_import
637	5050903_1	9	320	2025-07-16 20:30:22.063928	20250718_162116	replace_import
643	5040805_1	13	500	2025-07-16 20:30:22.095588	20250718_162116	replace_import
646	5050902_1	13	3000	2025-07-16 20:30:22.108689	20250718_162116	replace_import
648	5051306_1	13	3000	2025-07-16 20:30:22.11951	20250718_162116	replace_import
649	5051905_1	13	3000	2025-07-16 20:30:22.126598	20250718_162116	replace_import
650	5052004_1	13	500	2025-07-16 20:30:22.130478	20250718_162116	replace_import
653	5053003_1	13	3000	2025-07-16 20:30:22.148105	20250718_162116	replace_import
655	5060206_1	13	3000	2025-07-16 20:30:22.159402	20250718_162116	replace_import
663	5040702_1	14	110	2025-07-16 20:30:22.213412	20250718_162116	replace_import
666	5051801_1	14	217	2025-07-16 20:30:22.230462	20250718_162116	replace_import
673	5061404_1	14	1430	2025-07-16 20:30:22.274965	20250718_162116	replace_import
676	5061903_1	14	8494	2025-07-16 20:30:22.292184	20250718_162116	replace_import
681	5040903_1	14	7436	2025-07-16 20:30:22.318395	20250718_162116	replace_import
685	5041905_1	14	9140	2025-07-16 20:30:22.33766	20250718_162116	replace_import
691	5042803_1	14	2283	2025-07-16 20:30:22.363584	20250718_162116	replace_import
693	5050109_1	14	576	2025-07-16 20:30:22.372812	20250718_162116	replace_import
713	5053005_1	14	19441	2025-07-16 20:30:22.480846	20250718_162116	replace_import
718	5060601_1	14	9876	2025-07-16 20:30:22.507907	20250718_162116	replace_import
721	5060904_1	14	859	2025-07-16 20:30:22.522469	20250718_162116	replace_import
727	5061403_1	14	16496	2025-07-16 20:30:22.549065	20250718_162116	replace_import
730	5061703_1	14	2012	2025-07-16 20:30:22.562317	20250718_162116	replace_import
732	5061704_1	14	2129	2025-07-16 20:30:22.571193	20250718_162116	replace_import
736	5062001_1	14	7377	2025-07-16 20:30:22.586638	20250718_162116	replace_import
737	5062007_1	14	1300	2025-07-16 20:30:22.590857	20250718_162116	replace_import
738	5062016_1	14	14001	2025-07-16 20:30:22.595976	20250718_162116	replace_import
746	5062607_1	14	5780	2025-07-16 20:30:22.634958	20250718_162116	replace_import
748	5062712_1	14	6116	2025-07-16 20:30:22.645243	20250718_162116	replace_import
749	5062716_1	14	11166	2025-07-16 20:30:22.650294	20250718_162116	replace_import
750	5062717_1	14	20527	2025-07-16 20:30:22.654157	20250718_162116	replace_import
752	5062802_1	14	2023	2025-07-16 20:30:22.662009	20250718_162116	replace_import
757	5042405_1	11	8349	2025-07-16 20:30:22.681057	20250718_162116	replace_import
763	5040102_1	17	16500	2025-07-16 20:30:22.704543	20250718_162116	replace_import
775	5061007_1	18	29250	2025-07-16 20:30:22.754801	20250718_162116	replace_import
788	5053114_1	15	22000	2025-07-16 20:30:22.80566	20250718_162116	replace_import
789	5053113_1	15	45467	2025-07-16 20:30:22.809403	20250718_162116	replace_import
805	5053006_1	12	145	2025-07-16 20:42:15.168516	20250718_162116	replace_import
806	5053007_1	12	145	2025-07-16 20:42:15.175419	20250718_162116	replace_import
811	5053015_1	12	145	2025-07-16 20:42:15.209831	20250718_162116	replace_import
816	5051908_1	9	4140	2025-07-16 20:42:15.235858	20250718_162116	replace_import
819	5040111_1	13	1000	2025-07-16 20:42:15.253138	20250718_162116	replace_import
820	5040502_1	13	1500	2025-07-16 20:42:15.25934	20250718_162116	replace_import
823	5042201_1	13	500	2025-07-16 20:42:15.279115	20250718_162116	replace_import
836	5061003_1	13	3000	2025-07-16 20:42:15.340546	20250718_162116	replace_import
840	5062003_1	13	5000	2025-07-16 20:42:15.361273	20250718_162116	replace_import
843	5050301_1	14	1771	2025-07-16 20:42:15.381214	20250718_162116	replace_import
845	5052806_1	14	220	2025-07-16 20:42:15.393151	20250718_162116	replace_import
847	5060403_1	14	44	2025-07-16 20:42:15.405774	20250718_162116	replace_import
848	5060914_1	14	2230	2025-07-16 20:42:15.412657	20250718_162116	replace_import
858	5040701_1	14	7534	2025-07-16 20:42:15.458409	20250718_162116	replace_import
860	5041401_1	14	7269	2025-07-16 20:42:15.475788	20250718_162116	replace_import
864	5042102_1	14	896	2025-07-16 20:42:15.504998	20250718_162116	replace_import
866	5042401_1	14	7687	2025-07-16 20:42:15.513497	20250718_162116	replace_import
868	5042602_1	14	4089	2025-07-16 20:42:15.52607	20250718_162116	replace_import
872	5050110_1	14	1770	2025-07-16 20:42:15.545672	20250718_162116	replace_import
875	5050912_1	14	434	2025-07-16 20:42:15.558287	20250718_162116	replace_import
876	5051202_1	14	1520	2025-07-16 20:42:15.562847	20250718_162116	replace_import
879	5051401_1	14	213	2025-07-16 20:42:15.573409	20250718_162116	replace_import
880	5051410_1	14	3074	2025-07-16 20:42:15.577538	20250718_162116	replace_import
884	5052307_1	14	11061	2025-07-16 20:42:15.59904	20250718_162116	replace_import
887	5052701_1	14	4397	2025-07-16 20:42:15.614156	20250718_162116	replace_import
888	5052802_1	14	9573	2025-07-16 20:42:15.61945	20250718_162116	replace_import
889	5052804_1	14	3557	2025-07-16 20:42:15.622944	20250718_162116	replace_import
903	5061307_1	14	233	2025-07-16 20:42:15.684454	20250718_162116	replace_import
904	5061308_1	14	18982	2025-07-16 20:42:15.688113	20250718_162116	replace_import
906	5061401_1	14	6021	2025-07-16 20:42:15.697766	20250718_162116	replace_import
907	5061613_1	14	1810	2025-07-16 20:42:15.701304	20250718_162116	replace_import
911	5061803_1	14	8009	2025-07-16 20:42:15.71832	20250718_162116	replace_import
929	5062801_1	14	4230	2025-07-16 20:42:15.787548	20250718_162116	replace_import
932	5062901_1	14	2818	2025-07-16 20:42:15.807319	20250718_162116	replace_import
937	5052501_1	11	6395	2025-07-16 20:42:15.830385	20250718_162116	replace_import
938	5060913_1	11	2819	2025-07-16 20:42:15.834533	20250718_162116	replace_import
943	5042807_1	17	8225	2025-07-16 20:42:15.859639	20250718_162116	replace_import
945	5051408_1	17	10890	2025-07-16 20:42:15.86804	20250718_162116	replace_import
946	5051409_1	17	10890	2025-07-16 20:42:15.874825	20250718_162116	replace_import
947	5052601_1	17	7909	2025-07-16 20:42:15.882761	20250718_162116	replace_import
950	5062608_1	17	7539	2025-07-16 20:42:15.896796	20250718_162116	replace_import
952	5070102_1	17	16500	2025-07-16 20:42:15.90466	20250718_162116	replace_import
963	5053115_1	15	10980	2025-07-16 20:42:16.408383	20250718_162116	replace_import
964	5053112_1	15	55550	2025-07-16 20:42:16.412802	20250718_162116	replace_import
965	5053111_1	15	16740	2025-07-16 20:42:16.416704	20250718_162116	replace_import
\.


--
-- Data for Name: allocation_backups_20250720_152333; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.allocation_backups_20250720_152333 (id, transaction_id, budget_item_id, amount, created_at, backup_timestamp, backup_reason) FROM stdin;
256	5040304_1	14	598	2025-07-16 18:09:55.108142	20250720_152333	replace_import
257	5043003_1	12	165	2025-07-16 18:09:55.136204	20250720_152333	replace_import
258	5043018_1	12	160	2025-07-16 18:09:55.14677	20250720_152333	replace_import
259	5043019_1	12	160	2025-07-16 18:09:55.151646	20250720_152333	replace_import
260	5043020_1	12	160	2025-07-16 18:09:55.155448	20250720_152333	replace_import
261	5043021_1	12	160	2025-07-16 18:09:55.160905	20250720_152333	replace_import
262	5043022_1	12	160	2025-07-16 18:09:55.167204	20250720_152333	replace_import
263	5043023_1	12	55	2025-07-16 18:09:55.172442	20250720_152333	replace_import
264	5043024_1	12	160	2025-07-16 18:09:55.177109	20250720_152333	replace_import
265	5043025_1	12	160	2025-07-16 18:09:55.181877	20250720_152333	replace_import
266	5043026_1	12	160	2025-07-16 18:09:55.186932	20250720_152333	replace_import
267	5043027_1	12	160	2025-07-16 18:09:55.192127	20250720_152333	replace_import
268	5043028_1	12	160	2025-07-16 18:09:55.196419	20250720_152333	replace_import
269	5043029_1	12	55	2025-07-16 18:09:55.200327	20250720_152333	replace_import
270	5043031_1	12	160	2025-07-16 18:09:55.204369	20250720_152333	replace_import
53	5040103_1	30	336469	2025-07-09 11:24:43.186655	20250720_152333	replace_import
54	5040105_1	30	60000	2025-07-09 11:24:43.186662	20250720_152333	replace_import
273	5053008_1	12	145	2025-07-16 18:09:55.219977	20250720_152333	replace_import
59	5050703_1	21	5732	2025-07-09 11:24:43.186672	20250720_152333	replace_import
60	5050909_1	21	9155	2025-07-09 11:24:43.186674	20250720_152333	replace_import
61	5051101_1	21	3453	2025-07-09 11:24:43.186676	20250720_152333	replace_import
62	5051502_1	21	8876	2025-07-09 11:24:43.186678	20250720_152333	replace_import
63	5051803_1	21	6118	2025-07-09 11:24:43.18668	20250720_152333	replace_import
64	5051903_1	21	3230	2025-07-09 11:24:43.186682	20250720_152333	replace_import
276	5053014_1	12	145	2025-07-16 18:09:55.234501	20250720_152333	replace_import
169	5051605_1	22	250	2025-07-14 07:08:54.34884	20250720_152333	replace_import
278	5053016_1	12	145	2025-07-16 18:09:55.242152	20250720_152333	replace_import
171	5051412_1	22	2420	2025-07-14 07:09:09.771673	20250720_152333	replace_import
172	5051402_1	22	530	2025-07-14 07:09:15.474441	20250720_152333	replace_import
173	5052002_1	21	963	2025-07-14 08:07:08.833452	20250720_152333	replace_import
174	5052102_1	21	10593	2025-07-14 08:07:16.038828	20250720_152333	replace_import
176	5052902_1	22	12080	2025-07-14 09:49:25.923549	20250720_152333	replace_import
180	5040113_1	14	2184	2025-07-15 10:14:48.012676	20250720_152333	replace_import
182	5040504_1	14	2322	2025-07-15 10:14:48.012718	20250720_152333	replace_import
189	5042101_1	14	637	2025-07-15 10:14:48.012734	20250720_152333	replace_import
194	5043005_1	14	6482	2025-07-15 10:14:48.012745	20250720_152333	replace_import
197	5050801_1	14	1408	2025-07-15 10:14:48.012751	20250720_152333	replace_import
204	5051701_1	14	3054	2025-07-15 10:14:48.012766	20250720_152333	replace_import
214	5053101_1	14	3724	2025-07-15 10:14:48.012787	20250720_152333	replace_import
222	5061010_1	14	8372	2025-07-15 10:14:48.012804	20250720_152333	replace_import
233	5061805_1	14	5406	2025-07-15 10:14:48.012827	20250720_152333	replace_import
238	5062105_1	14	213	2025-07-15 10:14:48.012837	20250720_152333	replace_import
251	5062803_1	14	3680	2025-07-15 10:14:48.012864	20250720_152333	replace_import
253	5070202_1	14	501	2025-07-15 10:14:48.012869	20250720_152333	replace_import
254	5062410_1	14	1628	2025-07-15 10:14:48.012871	20250720_152333	replace_import
255	5062714_1	14	283	2025-07-15 10:14:48.012873	20250720_152333	replace_import
291	5051001_1	13	3000	2025-07-16 18:09:55.307756	20250720_152333	replace_import
295	5052003_1	13	5000	2025-07-16 18:09:55.324996	20250720_152333	replace_import
301	5061001_1	13	500	2025-07-16 18:09:55.354785	20250720_152333	replace_import
308	5042601_1	14	2409	2025-07-16 18:09:55.385119	20250720_152333	replace_import
312	5060213_1	14	712	2025-07-16 18:09:55.406619	20250720_152333	replace_import
315	5061012_1	14	1353	2025-07-16 18:09:55.419445	20250720_152333	replace_import
316	5061004_1	14	547	2025-07-16 18:09:55.423818	20250720_152333	replace_import
318	5061809_1	14	493	2025-07-16 18:09:55.431133	20250720_152333	replace_import
319	5061811_1	14	17160	2025-07-16 18:09:55.437216	20250720_152333	replace_import
322	5040202_1	14	5044	2025-07-16 18:09:55.447767	20250720_152333	replace_import
328	5041701_1	14	9776	2025-07-16 18:09:55.47338	20250720_152333	replace_import
344	5051309_1	14	5105	2025-07-16 18:09:55.539256	20250720_152333	replace_import
351	5052404_1	14	1155	2025-07-16 18:09:55.573323	20250720_152333	replace_import
352	5052605_1	14	8913	2025-07-16 18:09:55.576829	20250720_152333	replace_import
359	5060208_1	14	10874	2025-07-16 18:09:55.602938	20250720_152333	replace_import
360	5060212_1	14	404	2025-07-16 18:09:55.606491	20250720_152333	replace_import
364	5060910_1	14	835	2025-07-16 18:09:55.624133	20250720_152333	replace_import
367	5061105_1	14	28784	2025-07-16 18:09:55.637752	20250720_152333	replace_import
368	5061302_1	14	9080	2025-07-16 18:09:55.642479	20250720_152333	replace_import
375	5061701_1	14	246	2025-07-16 18:09:55.671307	20250720_152333	replace_import
383	5062102_1	14	4086	2025-07-16 18:09:55.702677	20250720_152333	replace_import
386	5062315_1	14	355	2025-07-16 18:09:55.713803	20250720_152333	replace_import
387	5062316_1	14	5900	2025-07-16 18:09:55.71918	20250720_152333	replace_import
388	5062405_1	14	1404	2025-07-16 18:09:55.7229	20250720_152333	replace_import
389	5062408_1	14	6497	2025-07-16 18:09:55.728207	20250720_152333	replace_import
391	5062701_1	14	7753	2025-07-16 18:09:55.737415	20250720_152333	replace_import
402	5052001_1	11	20088	2025-07-16 18:09:55.788138	20250720_152333	replace_import
405	5042808_1	10	150800	2025-07-16 18:09:55.799376	20250720_152333	replace_import
414	5052602_1	17	10780	2025-07-16 18:09:55.834732	20250720_152333	replace_import
415	5060104_1	17	16500	2025-07-16 18:09:55.839123	20250720_152333	replace_import
417	5062609_1	17	10780	2025-07-16 18:09:55.847664	20250720_152333	replace_import
420	5043044_1	15	26400	2025-07-16 18:09:55.859743	20250720_152333	replace_import
421	5043045_1	15	66000	2025-07-16 18:09:55.863535	20250720_152333	replace_import
422	5043043_1	15	45360	2025-07-16 18:09:55.868285	20250720_152333	replace_import
423	5043040_1	15	43450	2025-07-16 18:09:55.871838	20250720_152333	replace_import
424	5043039_1	15	17280	2025-07-16 18:09:55.875144	20250720_152333	replace_import
425	5043042_1	15	28800	2025-07-16 18:09:55.881469	20250720_152333	replace_import
426	5043041_1	15	35200	2025-07-16 18:09:55.885293	20250720_152333	replace_import
453	5053013_1	12	145	2025-07-16 18:23:44.684152	20250720_152333	replace_import
457	5053017_1	12	145	2025-07-16 18:23:44.706172	20250720_152333	replace_import
458	5053018_1	12	145	2025-07-16 18:23:44.710508	20250720_152333	replace_import
461	5043036_1	16	180000	2025-07-16 18:23:44.72543	20250720_152333	replace_import
462	5053108_1	16	180000	2025-07-16 18:23:44.732221	20250720_152333	replace_import
466	5041902_1	13	2000	2025-07-16 18:23:44.753203	20250720_152333	replace_import
474	5052405_1	13	3000	2025-07-16 18:23:44.787709	20250720_152333	replace_import
476	5053106_1	13	500	2025-07-16 18:23:44.796905	20250720_152333	replace_import
478	5060207_1	13	3000	2025-07-16 18:23:44.806713	20250720_152333	replace_import
481	5061304_1	13	3000	2025-07-16 18:23:44.82021	20250720_152333	replace_import
482	5061405_1	13	1500	2025-07-16 18:23:44.826478	20250720_152333	replace_import
483	5061611_1	13	3000	2025-07-16 18:23:44.831088	20250720_152333	replace_import
505	5041501_1	14	8000	2025-07-16 18:23:44.954709	20250720_152333	replace_import
511	5042501_1	14	20711	2025-07-16 18:23:44.989675	20250720_152333	replace_import
517	5050701_1	14	12495	2025-07-16 18:23:45.024522	20250720_152333	replace_import
521	5051310_1	14	857	2025-07-16 18:23:45.04971	20250720_152333	replace_import
525	5051501_1	14	2479	2025-07-16 18:23:45.06934	20250720_152333	replace_import
526	5052201_1	14	792	2025-07-16 18:23:45.073802	20250720_152333	replace_import
527	5052202_1	14	3580	2025-07-16 18:23:45.07858	20250720_152333	replace_import
534	5052901_1	14	11975	2025-07-16 18:23:45.1164	20250720_152333	replace_import
539	5060401_1	14	3759	2025-07-16 18:23:45.145062	20250720_152333	replace_import
541	5060602_1	14	19676	2025-07-16 18:23:45.15805	20250720_152333	replace_import
556	5061804_1	14	4914	2025-07-16 18:23:45.235886	20250720_152333	replace_import
563	5062201_1	14	10343	2025-07-16 18:23:45.273765	20250720_152333	replace_import
577	5040901_1	11	3094	2025-07-16 18:23:45.41504	20250720_152333	replace_import
578	5041703_1	11	25962	2025-07-16 18:23:45.424888	20250720_152333	replace_import
584	5052812_1	10	150800	2025-07-16 18:23:45.451956	20250720_152333	replace_import
586	5042605_1	17	10780	2025-07-16 18:23:45.460948	20250720_152333	replace_import
588	5050102_1	17	16500	2025-07-16 18:23:45.470556	20250720_152333	replace_import
605	5053116_1	15	15400	2025-07-16 18:23:45.555264	20250720_152333	replace_import
606	5053117_1	15	46017	2025-07-16 18:23:45.559522	20250720_152333	replace_import
630	5053009_1	12	145	2025-07-16 20:30:22.027649	20250720_152333	replace_import
637	5050903_1	9	320	2025-07-16 20:30:22.063928	20250720_152333	replace_import
643	5040805_1	13	500	2025-07-16 20:30:22.095588	20250720_152333	replace_import
646	5050902_1	13	3000	2025-07-16 20:30:22.108689	20250720_152333	replace_import
648	5051306_1	13	3000	2025-07-16 20:30:22.11951	20250720_152333	replace_import
649	5051905_1	13	3000	2025-07-16 20:30:22.126598	20250720_152333	replace_import
650	5052004_1	13	500	2025-07-16 20:30:22.130478	20250720_152333	replace_import
653	5053003_1	13	3000	2025-07-16 20:30:22.148105	20250720_152333	replace_import
655	5060206_1	13	3000	2025-07-16 20:30:22.159402	20250720_152333	replace_import
663	5040702_1	14	110	2025-07-16 20:30:22.213412	20250720_152333	replace_import
666	5051801_1	14	217	2025-07-16 20:30:22.230462	20250720_152333	replace_import
673	5061404_1	14	1430	2025-07-16 20:30:22.274965	20250720_152333	replace_import
676	5061903_1	14	8494	2025-07-16 20:30:22.292184	20250720_152333	replace_import
681	5040903_1	14	7436	2025-07-16 20:30:22.318395	20250720_152333	replace_import
685	5041905_1	14	9140	2025-07-16 20:30:22.33766	20250720_152333	replace_import
691	5042803_1	14	2283	2025-07-16 20:30:22.363584	20250720_152333	replace_import
693	5050109_1	14	576	2025-07-16 20:30:22.372812	20250720_152333	replace_import
713	5053005_1	14	19441	2025-07-16 20:30:22.480846	20250720_152333	replace_import
718	5060601_1	14	9876	2025-07-16 20:30:22.507907	20250720_152333	replace_import
721	5060904_1	14	859	2025-07-16 20:30:22.522469	20250720_152333	replace_import
727	5061403_1	14	16496	2025-07-16 20:30:22.549065	20250720_152333	replace_import
730	5061703_1	14	2012	2025-07-16 20:30:22.562317	20250720_152333	replace_import
732	5061704_1	14	2129	2025-07-16 20:30:22.571193	20250720_152333	replace_import
736	5062001_1	14	7377	2025-07-16 20:30:22.586638	20250720_152333	replace_import
737	5062007_1	14	1300	2025-07-16 20:30:22.590857	20250720_152333	replace_import
738	5062016_1	14	14001	2025-07-16 20:30:22.595976	20250720_152333	replace_import
746	5062607_1	14	5780	2025-07-16 20:30:22.634958	20250720_152333	replace_import
748	5062712_1	14	6116	2025-07-16 20:30:22.645243	20250720_152333	replace_import
749	5062716_1	14	11166	2025-07-16 20:30:22.650294	20250720_152333	replace_import
750	5062717_1	14	20527	2025-07-16 20:30:22.654157	20250720_152333	replace_import
752	5062802_1	14	2023	2025-07-16 20:30:22.662009	20250720_152333	replace_import
757	5042405_1	11	8349	2025-07-16 20:30:22.681057	20250720_152333	replace_import
763	5040102_1	17	16500	2025-07-16 20:30:22.704543	20250720_152333	replace_import
775	5061007_1	18	29250	2025-07-16 20:30:22.754801	20250720_152333	replace_import
788	5053114_1	15	22000	2025-07-16 20:30:22.80566	20250720_152333	replace_import
789	5053113_1	15	45467	2025-07-16 20:30:22.809403	20250720_152333	replace_import
805	5053006_1	12	145	2025-07-16 20:42:15.168516	20250720_152333	replace_import
806	5053007_1	12	145	2025-07-16 20:42:15.175419	20250720_152333	replace_import
811	5053015_1	12	145	2025-07-16 20:42:15.209831	20250720_152333	replace_import
816	5051908_1	9	4140	2025-07-16 20:42:15.235858	20250720_152333	replace_import
819	5040111_1	13	1000	2025-07-16 20:42:15.253138	20250720_152333	replace_import
820	5040502_1	13	1500	2025-07-16 20:42:15.25934	20250720_152333	replace_import
823	5042201_1	13	500	2025-07-16 20:42:15.279115	20250720_152333	replace_import
836	5061003_1	13	3000	2025-07-16 20:42:15.340546	20250720_152333	replace_import
840	5062003_1	13	5000	2025-07-16 20:42:15.361273	20250720_152333	replace_import
843	5050301_1	14	1771	2025-07-16 20:42:15.381214	20250720_152333	replace_import
845	5052806_1	14	220	2025-07-16 20:42:15.393151	20250720_152333	replace_import
847	5060403_1	14	44	2025-07-16 20:42:15.405774	20250720_152333	replace_import
848	5060914_1	14	2230	2025-07-16 20:42:15.412657	20250720_152333	replace_import
858	5040701_1	14	7534	2025-07-16 20:42:15.458409	20250720_152333	replace_import
860	5041401_1	14	7269	2025-07-16 20:42:15.475788	20250720_152333	replace_import
864	5042102_1	14	896	2025-07-16 20:42:15.504998	20250720_152333	replace_import
866	5042401_1	14	7687	2025-07-16 20:42:15.513497	20250720_152333	replace_import
868	5042602_1	14	4089	2025-07-16 20:42:15.52607	20250720_152333	replace_import
872	5050110_1	14	1770	2025-07-16 20:42:15.545672	20250720_152333	replace_import
875	5050912_1	14	434	2025-07-16 20:42:15.558287	20250720_152333	replace_import
876	5051202_1	14	1520	2025-07-16 20:42:15.562847	20250720_152333	replace_import
879	5051401_1	14	213	2025-07-16 20:42:15.573409	20250720_152333	replace_import
880	5051410_1	14	3074	2025-07-16 20:42:15.577538	20250720_152333	replace_import
884	5052307_1	14	11061	2025-07-16 20:42:15.59904	20250720_152333	replace_import
887	5052701_1	14	4397	2025-07-16 20:42:15.614156	20250720_152333	replace_import
888	5052802_1	14	9573	2025-07-16 20:42:15.61945	20250720_152333	replace_import
889	5052804_1	14	3557	2025-07-16 20:42:15.622944	20250720_152333	replace_import
903	5061307_1	14	233	2025-07-16 20:42:15.684454	20250720_152333	replace_import
904	5061308_1	14	18982	2025-07-16 20:42:15.688113	20250720_152333	replace_import
906	5061401_1	14	6021	2025-07-16 20:42:15.697766	20250720_152333	replace_import
907	5061613_1	14	1810	2025-07-16 20:42:15.701304	20250720_152333	replace_import
911	5061803_1	14	8009	2025-07-16 20:42:15.71832	20250720_152333	replace_import
929	5062801_1	14	4230	2025-07-16 20:42:15.787548	20250720_152333	replace_import
932	5062901_1	14	2818	2025-07-16 20:42:15.807319	20250720_152333	replace_import
937	5052501_1	11	6395	2025-07-16 20:42:15.830385	20250720_152333	replace_import
938	5060913_1	11	2819	2025-07-16 20:42:15.834533	20250720_152333	replace_import
943	5042807_1	17	8225	2025-07-16 20:42:15.859639	20250720_152333	replace_import
945	5051408_1	17	10890	2025-07-16 20:42:15.86804	20250720_152333	replace_import
946	5051409_1	17	10890	2025-07-16 20:42:15.874825	20250720_152333	replace_import
947	5052601_1	17	7909	2025-07-16 20:42:15.882761	20250720_152333	replace_import
950	5062608_1	17	7539	2025-07-16 20:42:15.896796	20250720_152333	replace_import
952	5070102_1	17	16500	2025-07-16 20:42:15.90466	20250720_152333	replace_import
963	5053115_1	15	10980	2025-07-16 20:42:16.408383	20250720_152333	replace_import
964	5053112_1	15	55550	2025-07-16 20:42:16.412802	20250720_152333	replace_import
965	5053111_1	15	16740	2025-07-16 20:42:16.416704	20250720_152333	replace_import
\.


--
-- Data for Name: allocation_backups_20250720_174830; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.allocation_backups_20250720_174830 (id, transaction_id, budget_item_id, amount, created_at, backup_timestamp, backup_reason) FROM stdin;
169	5070202_1	14	501	2025-07-20 15:24:22.074346	20250720_174830	replace_import
173	5062801_1	14	4230	2025-07-20 15:24:22.090428	20250720_174830	replace_import
172	5062803_1	14	3680	2025-07-20 15:24:22.094206	20250720_174830	replace_import
176	5062717_1	14	20527	2025-07-20 15:24:22.106419	20250720_174830	replace_import
177	5062716_1	14	11166	2025-07-20 15:24:22.110053	20250720_174830	replace_import
181	5062609_1	17	10780	2025-07-20 15:24:22.122894	20250720_174830	replace_import
180	5062608_1	17	7539	2025-07-20 15:24:22.127256	20250720_174830	replace_import
184	5062410_1	14	1628	2025-07-20 15:24:22.139023	20250720_174830	replace_import
185	5062405_1	14	1404	2025-07-20 15:24:22.142674	20250720_174830	replace_import
188	5062201_1	14	10343	2025-07-20 15:24:22.156301	20250720_174830	replace_import
190	5062105_1	14	213	2025-07-20 15:24:22.15994	20250720_174830	replace_import
191	5062016_1	14	14001	2025-07-20 15:24:22.171699	20250720_174830	replace_import
396	5062008_1	20	26972	2025-07-20 15:24:22.175797	20250720_174830	replace_import
195	5061903_1	14	8494	2025-07-20 15:24:22.187204	20250720_174830	replace_import
196	5061803_1	14	8009	2025-07-20 15:24:22.191015	20250720_174830	replace_import
198	5061805_1	14	5406	2025-07-20 15:24:22.204569	20250720_174830	replace_import
197	5061804_1	14	4914	2025-07-20 15:24:22.20842	20250720_174830	replace_import
201	5061703_1	14	2012	2025-07-20 15:24:22.220664	20250720_174830	replace_import
203	5061701_1	14	246	2025-07-20 15:24:22.224106	20250720_174830	replace_import
395	5061614_1	20	1690	2025-07-20 15:24:22.234903	20250720_174830	replace_import
204	5061611_1	13	3000	2025-07-20 15:24:22.240014	20250720_174830	replace_import
209	5061404_1	14	1430	2025-07-20 15:24:22.25196	20250720_174830	replace_import
206	5061401_1	14	6021	2025-07-20 15:24:22.255827	20250720_174830	replace_import
211	5061307_1	14	233	2025-07-20 15:24:22.266024	20250720_174830	replace_import
212	5061302_1	14	9080	2025-07-20 15:24:22.269735	20250720_174830	replace_import
219	5061012_1	14	1353	2025-07-20 15:24:22.279909	20250720_174830	replace_import
400	5061011_1	20	2130	2025-07-20 15:24:22.283237	20250720_174830	replace_import
220	5061004_1	14	547	2025-07-20 15:24:22.292307	20250720_174830	replace_import
215	5061001_1	13	500	2025-07-20 15:24:22.295179	20250720_174830	replace_import
222	5060910_1	14	835	2025-07-20 15:24:22.30363	20250720_174830	replace_import
221	5060904_1	14	859	2025-07-20 15:24:22.306764	20250720_174830	replace_import
225	5060602_1	14	19676	2025-07-20 15:24:22.315576	20250720_174830	replace_import
386	5060501_1	19	6066	2025-07-20 15:24:22.318466	20250720_174830	replace_import
393	5060404_1	20	4609	2025-07-20 15:24:22.327407	20250720_174830	replace_import
227	5060403_1	14	44	2025-07-20 15:24:22.330376	20250720_174830	replace_import
233	5060206_1	13	3000	2025-07-20 15:24:22.343712	20250720_174830	replace_import
230	5060213_1	14	712	2025-07-20 15:24:22.346567	20250720_174830	replace_import
232	5060207_1	13	3000	2025-07-20 15:24:22.355588	20250720_174830	replace_import
234	5060104_1	17	16500	2025-07-20 15:24:22.35941	20250720_174830	replace_import
244	5053115_1	15	10980	2025-07-20 15:24:22.370709	20250720_174830	replace_import
241	5053114_1	15	22000	2025-07-20 15:24:22.373829	20250720_174830	replace_import
235	5053111_1	15	16740	2025-07-20 15:24:22.383073	20250720_174830	replace_import
242	5053108_1	16	180000	2025-07-20 15:24:22.387433	20250720_174830	replace_import
247	5053008_1	12	145	2025-07-20 15:24:22.397717	20250720_174830	replace_import
384	5053031_1	19	922	2025-07-20 15:24:22.400915	20250720_174830	replace_import
245	5053016_1	12	145	2025-07-20 15:24:22.409403	20250720_174830	replace_import
252	5053015_1	12	145	2025-07-20 15:24:22.412366	20250720_174830	replace_import
248	5053009_1	12	145	2025-07-20 15:24:22.424606	20250720_174830	replace_import
255	5053007_1	12	145	2025-07-20 15:24:22.427799	20250720_174830	replace_import
250	5053003_1	13	3000	2025-07-20 15:24:22.436649	20250720_174830	replace_import
170	5070102_1	17	16500	2025-07-20 15:24:22.080481	20250720_174830	replace_import
174	5062802_1	14	2023	2025-07-20 15:24:22.097862	20250720_174830	replace_import
179	5062714_1	14	283	2025-07-20 15:24:22.114373	20250720_174830	replace_import
182	5062607_1	14	5780	2025-07-20 15:24:22.131643	20250720_174830	replace_import
186	5062315_1	14	355	2025-07-20 15:24:22.147263	20250720_174830	replace_import
189	5062102_1	14	4086	2025-07-20 15:24:22.163543	20250720_174830	replace_import
192	5062003_1	13	5000	2025-07-20 15:24:22.179315	20250720_174830	replace_import
200	5061811_1	14	17160	2025-07-20 15:24:22.194775	20250720_174830	replace_import
401	5061702_1	20	238	2025-07-20 15:24:22.212199	20250720_174830	replace_import
205	5061613_1	14	1810	2025-07-20 15:24:22.227178	20250720_174830	replace_import
207	5061403_1	14	16496	2025-07-20 15:24:22.244234	20250720_174830	replace_import
213	5061304_1	13	3000	2025-07-20 15:24:22.259275	20250720_174830	replace_import
214	5061105_1	14	28784	2025-07-20 15:24:22.273094	20250720_174830	replace_import
217	5061010_1	14	8372	2025-07-20 15:24:22.286067	20250720_174830	replace_import
224	5060914_1	14	2230	2025-07-20 15:24:22.297833	20250720_174830	replace_import
399	5060801_1	20	6200	2025-07-20 15:24:22.309965	20250720_174830	replace_import
228	5060401_1	14	3759	2025-07-20 15:24:22.321166	20250720_174830	replace_import
391	5060402_1	20	2156	2025-07-20 15:24:22.333744	20250720_174830	replace_import
231	5060212_1	14	404	2025-07-20 15:24:22.349354	20250720_174830	replace_import
237	5053117_1	15	46017	2025-07-20 15:24:22.363437	20250720_174830	replace_import
236	5053113_1	15	45467	2025-07-20 15:24:22.37711	20250720_174830	replace_import
240	5053106_1	13	500	2025-07-20 15:24:22.390598	20250720_174830	replace_import
256	5053018_1	12	145	2025-07-20 15:24:22.403884	20250720_174830	replace_import
251	5053014_1	12	145	2025-07-20 15:24:22.41568	20250720_174830	replace_import
254	5053006_1	12	145	2025-07-20 15:24:22.43107	20250720_174830	replace_import
257	5052902_1	22	12080	2025-07-20 15:24:22.439929	20250720_174830	replace_import
259	5052901_1	14	11975	2025-07-20 15:24:22.443454	20250720_174830	replace_import
262	5052806_1	14	220	2025-07-20 15:24:22.45366	20250720_174830	replace_import
260	5052804_1	14	3557	2025-07-20 15:24:22.456936	20250720_174830	replace_import
267	5052602_1	17	10780	2025-07-20 15:24:22.467653	20250720_174830	replace_import
265	5052601_1	17	7909	2025-07-20 15:24:22.470893	20250720_174830	replace_import
269	5052404_1	14	1155	2025-07-20 15:24:22.48072	20250720_174830	replace_import
270	5052405_1	13	3000	2025-07-20 15:24:22.483883	20250720_174830	replace_import
383	5052306_1	19	18892	2025-07-20 15:24:22.494417	20250720_174830	replace_import
390	5052305_1	20	2087	2025-07-20 15:24:22.497489	20250720_174830	replace_import
273	5052202_1	14	3580	2025-07-20 15:24:22.507533	20250720_174830	replace_import
274	5052102_1	21	10593	2025-07-20 15:24:22.511021	20250720_174830	replace_import
278	5052003_1	13	5000	2025-07-20 15:24:22.521286	20250720_174830	replace_import
171	5062901_1	14	2818	2025-07-20 15:24:22.085083	20250720_174830	replace_import
178	5062712_1	14	6116	2025-07-20 15:24:22.102421	20250720_174830	replace_import
175	5062701_1	14	7753	2025-07-20 15:24:22.118531	20250720_174830	replace_import
183	5062408_1	14	6497	2025-07-20 15:24:22.135309	20250720_174830	replace_import
187	5062316_1	14	5900	2025-07-20 15:24:22.152061	20250720_174830	replace_import
194	5062007_1	14	1300	2025-07-20 15:24:22.167572	20250720_174830	replace_import
193	5062001_1	14	7377	2025-07-20 15:24:22.183115	20250720_174830	replace_import
199	5061809_1	14	493	2025-07-20 15:24:22.200555	20250720_174830	replace_import
202	5061704_1	14	2129	2025-07-20 15:24:22.216555	20250720_174830	replace_import
394	5061615_1	20	539	2025-07-20 15:24:22.231217	20250720_174830	replace_import
208	5061405_1	13	1500	2025-07-20 15:24:22.248428	20250720_174830	replace_import
387	5061308_1	20	18982	2025-07-20 15:24:22.262806	20250720_174830	replace_import
218	5061003_1	13	3000	2025-07-20 15:24:22.276687	20250720_174830	replace_import
216	5061007_1	18	29250	2025-07-20 15:24:22.288973	20250720_174830	replace_import
223	5060913_1	11	2819	2025-07-20 15:24:22.300653	20250720_174830	replace_import
226	5060601_1	14	9876	2025-07-20 15:24:22.313022	20250720_174830	replace_import
392	5060405_1	20	3780	2025-07-20 15:24:22.323961	20250720_174830	replace_import
398	5060301_1	20	10890	2025-07-20 15:24:22.340793	20250720_174830	replace_import
229	5060208_1	14	10874	2025-07-20 15:24:22.352434	20250720_174830	replace_import
239	5053116_1	15	15400	2025-07-20 15:24:22.367044	20250720_174830	replace_import
243	5053112_1	15	55550	2025-07-20 15:24:22.379895	20250720_174830	replace_import
238	5053101_1	14	3724	2025-07-20 15:24:22.394227	20250720_174830	replace_import
253	5053017_1	12	145	2025-07-20 15:24:22.406729	20250720_174830	replace_import
249	5053013_1	12	145	2025-07-20 15:24:22.421331	20250720_174830	replace_import
385	5053005_1	19	19441	2025-07-20 15:24:22.433821	20250720_174830	replace_import
261	5052802_1	14	9573	2025-07-20 15:24:22.447098	20250720_174830	replace_import
263	5052812_1	10	150800	2025-07-20 15:24:22.450642	20250720_174830	replace_import
397	5052801_1	20	1548	2025-07-20 15:24:22.460695	20250720_174830	replace_import
264	5052701_1	14	4397	2025-07-20 15:24:22.464125	20250720_174830	replace_import
266	5052605_1	14	8913	2025-07-20 15:24:22.474345	20250720_174830	replace_import
268	5052501_1	11	6395	2025-07-20 15:24:22.477485	20250720_174830	replace_import
389	5052303_1	20	998	2025-07-20 15:24:22.488361	20250720_174830	replace_import
271	5052307_1	14	11061	2025-07-20 15:24:22.491483	20250720_174830	replace_import
382	5052304_1	19	8569	2025-07-20 15:24:22.500539	20250720_174830	replace_import
272	5052201_1	14	792	2025-07-20 15:24:22.503878	20250720_174830	replace_import
276	5052002_1	21	963	2025-07-20 15:24:22.514625	20250720_174830	replace_import
277	5052004_1	13	500	2025-07-20 15:24:22.517818	20250720_174830	replace_import
275	5052001_1	11	20088	2025-07-20 15:24:22.525053	20250720_174830	replace_import
279	5051905_1	13	3000	2025-07-20 15:24:22.528576	20250720_174830	replace_import
280	5051908_1	9	4140	2025-07-20 15:24:22.532602	20250720_174830	replace_import
281	5051903_1	21	3230	2025-07-20 15:24:22.53723	20250720_174830	replace_import
282	5051801_1	14	217	2025-07-20 15:24:22.54047	20250720_174830	replace_import
283	5051803_1	21	6118	2025-07-20 15:24:22.544744	20250720_174830	replace_import
284	5051701_1	14	3054	2025-07-20 15:24:22.548655	20250720_174830	replace_import
286	5051605_1	22	250	2025-07-20 15:24:22.552301	20250720_174830	replace_import
381	5051604_1	19	21103	2025-07-20 15:24:22.556791	20250720_174830	replace_import
288	5051502_1	21	8876	2025-07-20 15:24:22.561461	20250720_174830	replace_import
287	5051501_1	14	2479	2025-07-20 15:24:22.565667	20250720_174830	replace_import
291	5051410_1	14	3074	2025-07-20 15:24:22.569483	20250720_174830	replace_import
293	5051412_1	22	2420	2025-07-20 15:24:22.573628	20250720_174830	replace_import
292	5051409_1	17	10890	2025-07-20 15:24:22.576791	20250720_174830	replace_import
289	5051408_1	17	10890	2025-07-20 15:24:22.580859	20250720_174830	replace_import
294	5051402_1	22	530	2025-07-20 15:24:22.584905	20250720_174830	replace_import
290	5051401_1	14	213	2025-07-20 15:24:22.58817	20250720_174830	replace_import
297	5051310_1	14	857	2025-07-20 15:24:22.591881	20250720_174830	replace_import
298	5051309_1	14	5105	2025-07-20 15:24:22.596567	20250720_174830	replace_import
299	5051306_1	13	3000	2025-07-20 15:24:22.600532	20250720_174830	replace_import
300	5051202_1	14	1520	2025-07-20 15:24:22.603887	20250720_174830	replace_import
301	5051101_1	21	3453	2025-07-20 15:24:22.607249	20250720_174830	replace_import
302	5051001_1	13	3000	2025-07-20 15:24:22.611108	20250720_174830	replace_import
304	5050912_1	14	434	2025-07-20 15:24:22.615603	20250720_174830	replace_import
379	5050911_1	19	5910	2025-07-20 15:24:22.619058	20250720_174830	replace_import
380	5050910_1	19	22578	2025-07-20 15:24:22.6227	20250720_174830	replace_import
303	5050909_1	21	9155	2025-07-20 15:24:22.628671	20250720_174830	replace_import
306	5050903_1	9	320	2025-07-20 15:24:22.632515	20250720_174830	replace_import
305	5050902_1	13	3000	2025-07-20 15:24:22.635977	20250720_174830	replace_import
307	5050801_1	14	1408	2025-07-20 15:24:22.640037	20250720_174830	replace_import
309	5050703_1	21	5732	2025-07-20 15:24:22.643121	20250720_174830	replace_import
308	5050701_1	14	12495	2025-07-20 15:24:22.645956	20250720_174830	replace_import
310	5050301_1	14	1771	2025-07-20 15:24:22.648866	20250720_174830	replace_import
378	5050213_1	19	14158	2025-07-20 15:24:22.652532	20250720_174830	replace_import
377	5050205_1	19	10120	2025-07-20 15:24:22.65601	20250720_174830	replace_import
311	5050109_1	14	576	2025-07-20 15:24:22.659533	20250720_174830	replace_import
313	5050110_1	14	1770	2025-07-20 15:24:22.663392	20250720_174830	replace_import
312	5050102_1	17	16500	2025-07-20 15:24:22.667337	20250720_174830	replace_import
316	5043018_1	12	160	2025-07-20 15:24:22.671091	20250720_174830	replace_import
331	5043045_1	15	66000	2025-07-20 15:24:22.675037	20250720_174830	replace_import
330	5043044_1	15	26400	2025-07-20 15:24:22.679128	20250720_174830	replace_import
332	5043043_1	15	45360	2025-07-20 15:24:22.683239	20250720_174830	replace_import
335	5043042_1	15	28800	2025-07-20 15:24:22.687715	20250720_174830	replace_import
336	5043041_1	15	35200	2025-07-20 15:24:22.694696	20250720_174830	replace_import
333	5043040_1	15	43450	2025-07-20 15:24:22.698684	20250720_174830	replace_import
334	5043039_1	15	17280	2025-07-20 15:24:22.702963	20250720_174830	replace_import
314	5043036_1	16	180000	2025-07-20 15:24:22.706252	20250720_174830	replace_import
328	5043031_1	12	160	2025-07-20 15:24:22.709877	20250720_174830	replace_import
327	5043029_1	12	55	2025-07-20 15:24:22.715924	20250720_174830	replace_import
326	5043028_1	12	160	2025-07-20 15:24:22.720329	20250720_174830	replace_import
325	5043027_1	12	160	2025-07-20 15:24:22.72531	20250720_174830	replace_import
324	5043026_1	12	160	2025-07-20 15:24:22.731518	20250720_174830	replace_import
323	5043025_1	12	160	2025-07-20 15:24:22.739433	20250720_174830	replace_import
322	5043024_1	12	160	2025-07-20 15:24:22.744683	20250720_174830	replace_import
321	5043023_1	12	55	2025-07-20 15:24:22.749494	20250720_174830	replace_import
320	5043022_1	12	160	2025-07-20 15:24:22.754772	20250720_174830	replace_import
319	5043021_1	12	160	2025-07-20 15:24:22.763806	20250720_174830	replace_import
318	5043020_1	12	160	2025-07-20 15:24:22.767754	20250720_174830	replace_import
317	5043019_1	12	160	2025-07-20 15:24:22.77208	20250720_174830	replace_import
329	5043005_1	14	6482	2025-07-20 15:24:22.776393	20250720_174830	replace_import
315	5043003_1	12	165	2025-07-20 15:24:22.779939	20250720_174830	replace_import
376	5042801_1	19	3936	2025-07-20 15:24:22.78332	20250720_174830	replace_import
339	5042808_1	10	150800	2025-07-20 15:24:22.787494	20250720_174830	replace_import
338	5042807_1	17	8225	2025-07-20 15:24:22.791968	20250720_174830	replace_import
337	5042803_1	14	2283	2025-07-20 15:24:22.795701	20250720_174830	replace_import
342	5042601_1	14	2409	2025-07-20 15:24:22.799392	20250720_174830	replace_import
340	5042605_1	17	10780	2025-07-20 15:24:22.805092	20250720_174830	replace_import
341	5042602_1	14	4089	2025-07-20 15:24:22.808581	20250720_174830	replace_import
343	5042501_1	14	20711	2025-07-20 15:24:22.81269	20250720_174830	replace_import
344	5042405_1	11	8349	2025-07-20 15:24:22.818113	20250720_174830	replace_import
345	5042401_1	14	7687	2025-07-20 15:24:22.821634	20250720_174830	replace_import
375	5042203_1	19	16823	2025-07-20 15:24:22.825684	20250720_174830	replace_import
346	5042201_1	13	500	2025-07-20 15:24:22.829661	20250720_174830	replace_import
347	5042102_1	14	896	2025-07-20 15:24:22.834453	20250720_174830	replace_import
348	5042101_1	14	637	2025-07-20 15:24:22.838467	20250720_174830	replace_import
350	5041905_1	14	9140	2025-07-20 15:24:22.842451	20250720_174830	replace_import
349	5041902_1	13	2000	2025-07-20 15:24:22.846343	20250720_174830	replace_import
374	5041804_1	19	1974	2025-07-20 15:24:22.849556	20250720_174830	replace_import
371	5041803_1	19	20601	2025-07-20 15:24:22.852615	20250720_174830	replace_import
351	5041703_1	11	25962	2025-07-20 15:24:22.85629	20250720_174830	replace_import
352	5041701_1	14	9776	2025-07-20 15:24:22.85986	20250720_174830	replace_import
353	5041501_1	14	8000	2025-07-20 15:24:22.864031	20250720_174830	replace_import
354	5041401_1	14	7269	2025-07-20 15:24:22.867343	20250720_174830	replace_import
388	5041405_1	20	699	2025-07-20 15:24:22.870898	20250720_174830	replace_import
373	5041105_1	19	20204	2025-07-20 15:24:22.875186	20250720_174830	replace_import
356	5040903_1	14	7436	2025-07-20 15:24:22.87948	20250720_174830	replace_import
355	5040901_1	11	3094	2025-07-20 15:24:22.883686	20250720_174830	replace_import
359	5040701_1	14	7534	2025-07-20 15:24:22.898677	20250720_174830	replace_import
369	5040401_1	19	8348	2025-07-20 15:24:22.912211	20250720_174830	replace_import
364	5040102_1	17	16500	2025-07-20 15:24:22.927873	20250720_174830	replace_import
357	5040805_1	13	500	2025-07-20 15:24:22.886959	20250720_174830	replace_import
361	5040504_1	14	2322	2025-07-20 15:24:22.902011	20250720_174830	replace_import
362	5040304_1	14	598	2025-07-20 15:24:22.915364	20250720_174830	replace_import
365	5040113_1	14	2184	2025-07-20 15:24:22.933793	20250720_174830	replace_import
358	5040702_1	14	110	2025-07-20 15:24:22.892122	20250720_174830	replace_import
360	5040502_1	13	1500	2025-07-20 15:24:22.905333	20250720_174830	replace_import
363	5040202_1	14	5044	2025-07-20 15:24:22.918715	20250720_174830	replace_import
366	5040111_1	13	1000	2025-07-20 15:24:22.938793	20250720_174830	replace_import
372	5040407_1	19	2980	2025-07-20 15:24:22.895681	20250720_174830	replace_import
370	5040402_1	19	20057	2025-07-20 15:24:22.909049	20250720_174830	replace_import
367	5040105_1	30	60000	2025-07-20 15:24:22.924164	20250720_174830	replace_import
368	5040103_1	30	336469	2025-07-20 15:24:22.944633	20250720_174830	replace_import
1195	5070202_1	14	501	2025-07-20 15:25:35.212218	20250720_174830	replace_import
1196	5070102_1	17	16500	2025-07-20 15:25:35.223516	20250720_174830	replace_import
1197	5062901_1	14	2818	2025-07-20 15:25:35.229347	20250720_174830	replace_import
1198	5062801_1	14	4230	2025-07-20 15:25:35.234652	20250720_174830	replace_import
1199	5062803_1	14	3680	2025-07-20 15:25:35.239449	20250720_174830	replace_import
1200	5062802_1	14	2023	2025-07-20 15:25:35.243744	20250720_174830	replace_import
1201	5062712_1	14	6116	2025-07-20 15:25:35.247683	20250720_174830	replace_import
1202	5062717_1	14	20527	2025-07-20 15:25:35.251468	20250720_174830	replace_import
1203	5062716_1	14	11166	2025-07-20 15:25:35.25546	20250720_174830	replace_import
1204	5062714_1	14	283	2025-07-20 15:25:35.259133	20250720_174830	replace_import
1205	5062701_1	14	7753	2025-07-20 15:25:35.263124	20250720_174830	replace_import
1206	5062609_1	17	10780	2025-07-20 15:25:35.267706	20250720_174830	replace_import
1207	5062608_1	17	7539	2025-07-20 15:25:35.272016	20250720_174830	replace_import
1208	5062607_1	14	5780	2025-07-20 15:25:35.276228	20250720_174830	replace_import
1209	5062408_1	14	6497	2025-07-20 15:25:35.282645	20250720_174830	replace_import
1210	5062410_1	14	1628	2025-07-20 15:25:35.287233	20250720_174830	replace_import
1211	5062405_1	14	1404	2025-07-20 15:25:35.292085	20250720_174830	replace_import
1212	5062315_1	14	355	2025-07-20 15:25:35.297728	20250720_174830	replace_import
1213	5062316_1	14	5900	2025-07-20 15:25:35.302703	20250720_174830	replace_import
1214	5062201_1	14	10343	2025-07-20 15:25:35.307687	20250720_174830	replace_import
1215	5062105_1	14	213	2025-07-20 15:25:35.311943	20250720_174830	replace_import
1216	5062102_1	14	4086	2025-07-20 15:25:35.316701	20250720_174830	replace_import
1217	5062007_1	14	1300	2025-07-20 15:25:35.320831	20250720_174830	replace_import
1218	5062016_1	14	14001	2025-07-20 15:25:35.325267	20250720_174830	replace_import
1219	5062008_1	20	26972	2025-07-20 15:25:35.330702	20250720_174830	replace_import
1220	5062003_1	13	5000	2025-07-20 15:25:35.335126	20250720_174830	replace_import
1221	5062001_1	14	7377	2025-07-20 15:25:35.339457	20250720_174830	replace_import
1222	5061903_1	14	8494	2025-07-20 15:25:35.343757	20250720_174830	replace_import
1223	5061803_1	14	8009	2025-07-20 15:25:35.348153	20250720_174830	replace_import
1224	5061811_1	14	17160	2025-07-20 15:25:35.361393	20250720_174830	replace_import
1225	5061809_1	14	493	2025-07-20 15:25:35.365933	20250720_174830	replace_import
1226	5061805_1	14	5406	2025-07-20 15:25:35.37021	20250720_174830	replace_import
1227	5061804_1	14	4914	2025-07-20 15:25:35.376687	20250720_174830	replace_import
1228	5061702_1	20	238	2025-07-20 15:25:35.381164	20250720_174830	replace_import
1229	5061704_1	14	2129	2025-07-20 15:25:35.385254	20250720_174830	replace_import
1230	5061703_1	14	2012	2025-07-20 15:25:35.389654	20250720_174830	replace_import
1231	5061701_1	14	246	2025-07-20 15:25:35.394517	20250720_174830	replace_import
1232	5061613_1	14	1810	2025-07-20 15:25:35.398594	20250720_174830	replace_import
1233	5061615_1	20	539	2025-07-20 15:25:35.404651	20250720_174830	replace_import
1234	5061614_1	20	1690	2025-07-20 15:25:35.409173	20250720_174830	replace_import
1235	5061611_1	13	3000	2025-07-20 15:25:35.413065	20250720_174830	replace_import
1236	5061403_1	14	16496	2025-07-20 15:25:35.417797	20250720_174830	replace_import
1237	5061405_1	13	1500	2025-07-20 15:25:35.421845	20250720_174830	replace_import
1238	5061404_1	14	1430	2025-07-20 15:25:35.426366	20250720_174830	replace_import
1239	5061401_1	14	6021	2025-07-20 15:25:35.432255	20250720_174830	replace_import
1240	5061304_1	13	3000	2025-07-20 15:25:35.436688	20250720_174830	replace_import
1241	5061308_1	20	18982	2025-07-20 15:25:35.441186	20250720_174830	replace_import
1242	5061307_1	14	233	2025-07-20 15:25:35.46137	20250720_174830	replace_import
1243	5061302_1	14	9080	2025-07-20 15:25:35.466056	20250720_174830	replace_import
1244	5061105_1	14	28784	2025-07-20 15:25:35.473222	20250720_174830	replace_import
1245	5061003_1	13	3000	2025-07-20 15:25:35.4774	20250720_174830	replace_import
1246	5061012_1	14	1353	2025-07-20 15:25:35.481551	20250720_174830	replace_import
1247	5061011_1	20	2130	2025-07-20 15:25:35.485761	20250720_174830	replace_import
1248	5061010_1	14	8372	2025-07-20 15:25:35.49045	20250720_174830	replace_import
1249	5061007_1	18	29250	2025-07-20 15:25:35.494845	20250720_174830	replace_import
1250	5061004_1	14	547	2025-07-20 15:25:35.499082	20250720_174830	replace_import
1251	5061001_1	13	500	2025-07-20 15:25:35.502796	20250720_174830	replace_import
1252	5060914_1	14	2230	2025-07-20 15:25:35.506001	20250720_174830	replace_import
1253	5060913_1	11	2819	2025-07-20 15:25:35.50987	20250720_174830	replace_import
1254	5060910_1	14	835	2025-07-20 15:25:35.513646	20250720_174830	replace_import
1255	5060904_1	14	859	2025-07-20 15:25:35.517057	20250720_174830	replace_import
1256	5060801_1	20	6200	2025-07-20 15:25:35.520215	20250720_174830	replace_import
1257	5060601_1	14	9876	2025-07-20 15:25:35.524119	20250720_174830	replace_import
1258	5060602_1	14	19676	2025-07-20 15:25:35.52827	20250720_174830	replace_import
1259	5060501_1	19	6066	2025-07-20 15:25:35.53305	20250720_174830	replace_import
1260	5060401_1	14	3759	2025-07-20 15:25:35.536955	20250720_174830	replace_import
1261	5060405_1	20	3780	2025-07-20 15:25:35.542924	20250720_174830	replace_import
1262	5060404_1	20	4609	2025-07-20 15:25:35.546602	20250720_174830	replace_import
1263	5060403_1	14	44	2025-07-20 15:25:35.550974	20250720_174830	replace_import
1264	5060402_1	20	2156	2025-07-20 15:25:35.555717	20250720_174830	replace_import
1265	5060301_1	20	10890	2025-07-20 15:25:35.560358	20250720_174830	replace_import
1266	5060206_1	13	3000	2025-07-20 15:25:35.564417	20250720_174830	replace_import
1267	5060213_1	14	712	2025-07-20 15:25:35.56813	20250720_174830	replace_import
1268	5060212_1	14	404	2025-07-20 15:25:35.572111	20250720_174830	replace_import
1269	5060208_1	14	10874	2025-07-20 15:25:35.575696	20250720_174830	replace_import
1270	5060207_1	13	3000	2025-07-20 15:25:35.579186	20250720_174830	replace_import
1271	5060104_1	17	16500	2025-07-20 15:25:35.582912	20250720_174830	replace_import
1272	5053117_1	15	46017	2025-07-20 15:25:35.587148	20250720_174830	replace_import
1273	5053116_1	15	15400	2025-07-20 15:25:35.591298	20250720_174830	replace_import
1274	5053115_1	15	10980	2025-07-20 15:25:35.594764	20250720_174830	replace_import
1275	5053114_1	15	22000	2025-07-20 15:25:35.602978	20250720_174830	replace_import
1276	5053113_1	15	45467	2025-07-20 15:25:35.610425	20250720_174830	replace_import
1277	5053112_1	15	55550	2025-07-20 15:25:35.615977	20250720_174830	replace_import
1278	5053111_1	15	16740	2025-07-20 15:25:35.622767	20250720_174830	replace_import
1279	5053108_1	16	180000	2025-07-20 15:25:35.627536	20250720_174830	replace_import
1280	5053106_1	13	500	2025-07-20 15:25:35.632421	20250720_174830	replace_import
1281	5053101_1	14	3724	2025-07-20 15:25:35.636885	20250720_174830	replace_import
1282	5053008_1	12	145	2025-07-20 15:25:35.640839	20250720_174830	replace_import
1283	5053031_1	19	922	2025-07-20 15:25:35.644656	20250720_174830	replace_import
1284	5053018_1	12	145	2025-07-20 15:25:35.649575	20250720_174830	replace_import
1285	5053017_1	12	145	2025-07-20 15:25:35.653352	20250720_174830	replace_import
1286	5053016_1	12	145	2025-07-20 15:25:35.656646	20250720_174830	replace_import
1287	5053015_1	12	145	2025-07-20 15:25:35.66137	20250720_174830	replace_import
1288	5053014_1	12	145	2025-07-20 15:25:35.665692	20250720_174830	replace_import
1289	5053013_1	12	145	2025-07-20 15:25:35.67051	20250720_174830	replace_import
1290	5053009_1	12	145	2025-07-20 15:25:35.675246	20250720_174830	replace_import
1291	5053007_1	12	145	2025-07-20 15:25:35.679401	20250720_174830	replace_import
1292	5053006_1	12	145	2025-07-20 15:25:35.684171	20250720_174830	replace_import
1293	5053005_1	19	19441	2025-07-20 15:25:35.688246	20250720_174830	replace_import
1294	5053003_1	13	3000	2025-07-20 15:25:35.692133	20250720_174830	replace_import
1295	5052902_1	22	12080	2025-07-20 15:25:35.696743	20250720_174830	replace_import
1296	5052901_1	14	11975	2025-07-20 15:25:35.701261	20250720_174830	replace_import
1297	5052802_1	14	9573	2025-07-20 15:25:35.70497	20250720_174830	replace_import
1298	5052812_1	10	150800	2025-07-20 15:25:35.709689	20250720_174830	replace_import
1299	5052806_1	14	220	2025-07-20 15:25:35.713556	20250720_174830	replace_import
1300	5052804_1	14	3557	2025-07-20 15:25:35.717719	20250720_174830	replace_import
1301	5052801_1	20	1548	2025-07-20 15:25:35.722403	20250720_174830	replace_import
1302	5052701_1	14	4397	2025-07-20 15:25:35.727067	20250720_174830	replace_import
1303	5052602_1	17	10780	2025-07-20 15:25:35.731162	20250720_174830	replace_import
1304	5052601_1	17	7909	2025-07-20 15:25:35.735875	20250720_174830	replace_import
1305	5052605_1	14	8913	2025-07-20 15:25:35.742219	20250720_174830	replace_import
1306	5052501_1	11	6395	2025-07-20 15:25:35.746606	20250720_174830	replace_import
1307	5052404_1	14	1155	2025-07-20 15:25:35.751329	20250720_174830	replace_import
1308	5052405_1	13	3000	2025-07-20 15:25:35.755959	20250720_174830	replace_import
1309	5052303_1	20	998	2025-07-20 15:25:35.760323	20250720_174830	replace_import
1310	5052307_1	14	11061	2025-07-20 15:25:35.76486	20250720_174830	replace_import
1311	5052306_1	19	18892	2025-07-20 15:25:35.769809	20250720_174830	replace_import
1312	5052305_1	20	2087	2025-07-20 15:25:35.774926	20250720_174830	replace_import
1313	5052304_1	19	8569	2025-07-20 15:25:35.781172	20250720_174830	replace_import
1314	5052201_1	14	792	2025-07-20 15:25:35.785904	20250720_174830	replace_import
1315	5052202_1	14	3580	2025-07-20 15:25:35.791461	20250720_174830	replace_import
1316	5052102_1	21	10593	2025-07-20 15:25:35.798618	20250720_174830	replace_import
1317	5052002_1	21	963	2025-07-20 15:25:35.80523	20250720_174830	replace_import
1318	5052004_1	13	500	2025-07-20 15:25:35.813546	20250720_174830	replace_import
1319	5052003_1	13	5000	2025-07-20 15:25:35.820104	20250720_174830	replace_import
1320	5052001_1	11	20088	2025-07-20 15:25:35.827307	20250720_174830	replace_import
1321	5051905_1	13	3000	2025-07-20 15:25:35.833707	20250720_174830	replace_import
1322	5051908_1	9	4140	2025-07-20 15:25:35.839949	20250720_174830	replace_import
1323	5051903_1	21	3230	2025-07-20 15:25:35.84637	20250720_174830	replace_import
1324	5051801_1	14	217	2025-07-20 15:25:35.853264	20250720_174830	replace_import
1325	5051803_1	21	6118	2025-07-20 15:25:35.859805	20250720_174830	replace_import
1326	5051701_1	14	3054	2025-07-20 15:25:35.865249	20250720_174830	replace_import
1327	5051605_1	22	250	2025-07-20 15:25:35.871258	20250720_174830	replace_import
1331	5051410_1	14	3074	2025-07-20 15:25:35.89659	20250720_174830	replace_import
1335	5051402_1	22	530	2025-07-20 15:25:35.916181	20250720_174830	replace_import
1339	5051306_1	13	3000	2025-07-20 15:25:35.93251	20250720_174830	replace_import
1343	5050912_1	14	434	2025-07-20 15:25:35.950507	20250720_174830	replace_import
1347	5050903_1	9	320	2025-07-20 15:25:35.967937	20250720_174830	replace_import
1351	5050701_1	14	12495	2025-07-20 15:25:35.987176	20250720_174830	replace_import
1355	5050109_1	14	576	2025-07-20 15:25:36.004448	20250720_174830	replace_import
1359	5043045_1	15	66000	2025-07-20 15:25:36.021635	20250720_174830	replace_import
1363	5043041_1	15	35200	2025-07-20 15:25:36.037146	20250720_174830	replace_import
1367	5043031_1	12	160	2025-07-20 15:25:36.053326	20250720_174830	replace_import
1371	5043026_1	12	160	2025-07-20 15:25:36.070635	20250720_174830	replace_import
1375	5043022_1	12	160	2025-07-20 15:25:36.086513	20250720_174830	replace_import
1379	5043005_1	14	6482	2025-07-20 15:25:36.107249	20250720_174830	replace_import
1383	5042807_1	17	8225	2025-07-20 15:25:36.125302	20250720_174830	replace_import
1387	5042602_1	14	4089	2025-07-20 15:25:36.141502	20250720_174830	replace_import
1391	5042203_1	19	16823	2025-07-20 15:25:36.158348	20250720_174830	replace_import
1395	5041905_1	14	9140	2025-07-20 15:25:36.17455	20250720_174830	replace_import
1399	5041703_1	11	25962	2025-07-20 15:25:36.19247	20250720_174830	replace_import
1403	5041405_1	20	699	2025-07-20 15:25:36.212387	20250720_174830	replace_import
1407	5040805_1	13	500	2025-07-20 15:25:36.227583	20250720_174830	replace_import
1411	5040504_1	14	2322	2025-07-20 15:25:36.2455	20250720_174830	replace_import
1415	5040304_1	14	598	2025-07-20 15:25:36.261174	20250720_174830	replace_import
1419	5040113_1	14	2184	2025-07-20 15:25:36.279582	20250720_174830	replace_import
1328	5051604_1	19	21103	2025-07-20 15:25:35.878293	20250720_174830	replace_import
1332	5051412_1	22	2420	2025-07-20 15:25:35.902856	20250720_174830	replace_import
1336	5051401_1	14	213	2025-07-20 15:25:35.920445	20250720_174830	replace_import
1340	5051202_1	14	1520	2025-07-20 15:25:35.93702	20250720_174830	replace_import
1344	5050911_1	19	5910	2025-07-20 15:25:35.954797	20250720_174830	replace_import
1348	5050902_1	13	3000	2025-07-20 15:25:35.973863	20250720_174830	replace_import
1352	5050301_1	14	1771	2025-07-20 15:25:35.991473	20250720_174830	replace_import
1356	5050110_1	14	1770	2025-07-20 15:25:36.00873	20250720_174830	replace_import
1360	5043044_1	15	26400	2025-07-20 15:25:36.025755	20250720_174830	replace_import
1364	5043040_1	15	43450	2025-07-20 15:25:36.040592	20250720_174830	replace_import
1368	5043029_1	12	55	2025-07-20 15:25:36.057609	20250720_174830	replace_import
1372	5043025_1	12	160	2025-07-20 15:25:36.074515	20250720_174830	replace_import
1376	5043021_1	12	160	2025-07-20 15:25:36.090965	20250720_174830	replace_import
1380	5043003_1	12	165	2025-07-20 15:25:36.111374	20250720_174830	replace_import
1384	5042803_1	14	2283	2025-07-20 15:25:36.129591	20250720_174830	replace_import
1388	5042501_1	14	20711	2025-07-20 15:25:36.1453	20250720_174830	replace_import
1392	5042201_1	13	500	2025-07-20 15:25:36.162946	20250720_174830	replace_import
1396	5041902_1	13	2000	2025-07-20 15:25:36.180226	20250720_174830	replace_import
1400	5041701_1	14	9776	2025-07-20 15:25:36.199041	20250720_174830	replace_import
1404	5041105_1	19	20204	2025-07-20 15:25:36.216249	20250720_174830	replace_import
1408	5040702_1	14	110	2025-07-20 15:25:36.231343	20250720_174830	replace_import
1412	5040502_1	13	1500	2025-07-20 15:25:36.24939	20250720_174830	replace_import
1416	5040202_1	14	5044	2025-07-20 15:25:36.265184	20250720_174830	replace_import
1420	5040111_1	13	1000	2025-07-20 15:25:36.283289	20250720_174830	replace_import
1329	5051502_1	21	8876	2025-07-20 15:25:35.884765	20250720_174830	replace_import
1333	5051409_1	17	10890	2025-07-20 15:25:35.907084	20250720_174830	replace_import
1337	5051310_1	14	857	2025-07-20 15:25:35.924238	20250720_174830	replace_import
1341	5051101_1	21	3453	2025-07-20 15:25:35.940863	20250720_174830	replace_import
1345	5050910_1	19	22578	2025-07-20 15:25:35.95905	20250720_174830	replace_import
1349	5050801_1	14	1408	2025-07-20 15:25:35.979032	20250720_174830	replace_import
1353	5050213_1	19	14158	2025-07-20 15:25:35.995891	20250720_174830	replace_import
1357	5050102_1	17	16500	2025-07-20 15:25:36.013859	20250720_174830	replace_import
1361	5043043_1	15	45360	2025-07-20 15:25:36.029644	20250720_174830	replace_import
1365	5043039_1	15	17280	2025-07-20 15:25:36.045588	20250720_174830	replace_import
1369	5043028_1	12	160	2025-07-20 15:25:36.061956	20250720_174830	replace_import
1373	5043024_1	12	160	2025-07-20 15:25:36.078098	20250720_174830	replace_import
1377	5043020_1	12	160	2025-07-20 15:25:36.095593	20250720_174830	replace_import
1381	5042801_1	19	3936	2025-07-20 15:25:36.115258	20250720_174830	replace_import
1385	5042601_1	14	2409	2025-07-20 15:25:36.133649	20250720_174830	replace_import
1389	5042405_1	11	8349	2025-07-20 15:25:36.149516	20250720_174830	replace_import
1393	5042102_1	14	896	2025-07-20 15:25:36.166692	20250720_174830	replace_import
1397	5041804_1	19	1974	2025-07-20 15:25:36.184049	20250720_174830	replace_import
1401	5041501_1	14	8000	2025-07-20 15:25:36.203398	20250720_174830	replace_import
1405	5040903_1	14	7436	2025-07-20 15:25:36.220032	20250720_174830	replace_import
1409	5040407_1	19	2980	2025-07-20 15:25:36.236167	20250720_174830	replace_import
1413	5040402_1	19	20057	2025-07-20 15:25:36.253232	20250720_174830	replace_import
1417	5040105_1	30	60000	2025-07-20 15:25:36.270639	20250720_174830	replace_import
1421	5040103_1	30	336469	2025-07-20 15:25:36.287266	20250720_174830	replace_import
1330	5051501_1	14	2479	2025-07-20 15:25:35.891083	20250720_174830	replace_import
1334	5051408_1	17	10890	2025-07-20 15:25:35.911058	20250720_174830	replace_import
1338	5051309_1	14	5105	2025-07-20 15:25:35.927814	20250720_174830	replace_import
1342	5051001_1	13	3000	2025-07-20 15:25:35.945552	20250720_174830	replace_import
1346	5050909_1	21	9155	2025-07-20 15:25:35.963301	20250720_174830	replace_import
1350	5050703_1	21	5732	2025-07-20 15:25:35.983217	20250720_174830	replace_import
1354	5050205_1	19	10120	2025-07-20 15:25:36.000371	20250720_174830	replace_import
1358	5043018_1	12	160	2025-07-20 15:25:36.017924	20250720_174830	replace_import
1362	5043042_1	15	28800	2025-07-20 15:25:36.033143	20250720_174830	replace_import
1366	5043036_1	16	180000	2025-07-20 15:25:36.049429	20250720_174830	replace_import
1370	5043027_1	12	160	2025-07-20 15:25:36.066702	20250720_174830	replace_import
1374	5043023_1	12	55	2025-07-20 15:25:36.082566	20250720_174830	replace_import
1378	5043019_1	12	160	2025-07-20 15:25:36.099843	20250720_174830	replace_import
1382	5042808_1	10	150800	2025-07-20 15:25:36.120603	20250720_174830	replace_import
1386	5042605_1	17	10780	2025-07-20 15:25:36.137782	20250720_174830	replace_import
1390	5042401_1	14	7687	2025-07-20 15:25:36.153511	20250720_174830	replace_import
1394	5042101_1	14	637	2025-07-20 15:25:36.170595	20250720_174830	replace_import
1398	5041803_1	19	20601	2025-07-20 15:25:36.188609	20250720_174830	replace_import
1402	5041401_1	14	7269	2025-07-20 15:25:36.208371	20250720_174830	replace_import
1406	5040901_1	11	3094	2025-07-20 15:25:36.223854	20250720_174830	replace_import
1410	5040701_1	14	7534	2025-07-20 15:25:36.240397	20250720_174830	replace_import
1414	5040401_1	19	8348	2025-07-20 15:25:36.256977	20250720_174830	replace_import
1418	5040102_1	17	16500	2025-07-20 15:25:36.275262	20250720_174830	replace_import
968	5070202_1	14	501	2025-07-20 17:45:48.072434	20250720_174830	replace_import
969	5070102_1	17	16500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
970	5062901_1	14	2818	2025-07-20 17:45:48.072434	20250720_174830	replace_import
971	5062801_1	14	4230	2025-07-20 17:45:48.072434	20250720_174830	replace_import
972	5062803_1	14	3680	2025-07-20 17:45:48.072434	20250720_174830	replace_import
973	5062802_1	14	2023	2025-07-20 17:45:48.072434	20250720_174830	replace_import
974	5062712_1	14	6116	2025-07-20 17:45:48.072434	20250720_174830	replace_import
975	5062717_1	14	20527	2025-07-20 17:45:48.072434	20250720_174830	replace_import
976	5062716_1	14	11166	2025-07-20 17:45:48.072434	20250720_174830	replace_import
977	5062714_1	14	283	2025-07-20 17:45:48.072434	20250720_174830	replace_import
978	5062701_1	14	7753	2025-07-20 17:45:48.072434	20250720_174830	replace_import
979	5062609_1	17	10780	2025-07-20 17:45:48.072434	20250720_174830	replace_import
980	5062608_1	17	7539	2025-07-20 17:45:48.072434	20250720_174830	replace_import
981	5062607_1	14	5780	2025-07-20 17:45:48.072434	20250720_174830	replace_import
982	5062408_1	14	6497	2025-07-20 17:45:48.072434	20250720_174830	replace_import
983	5062410_1	14	1628	2025-07-20 17:45:48.072434	20250720_174830	replace_import
984	5062405_1	14	1404	2025-07-20 17:45:48.072434	20250720_174830	replace_import
985	5062315_1	14	355	2025-07-20 17:45:48.072434	20250720_174830	replace_import
986	5062316_1	14	5900	2025-07-20 17:45:48.072434	20250720_174830	replace_import
987	5062201_1	14	10343	2025-07-20 17:45:48.072434	20250720_174830	replace_import
988	5062105_1	14	213	2025-07-20 17:45:48.072434	20250720_174830	replace_import
989	5062102_1	14	4086	2025-07-20 17:45:48.072434	20250720_174830	replace_import
990	5062007_1	14	1300	2025-07-20 17:45:48.072434	20250720_174830	replace_import
991	5062016_1	14	14001	2025-07-20 17:45:48.072434	20250720_174830	replace_import
992	5062008_1	20	26972	2025-07-20 17:45:48.072434	20250720_174830	replace_import
993	5062003_1	13	5000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
994	5062001_1	14	7377	2025-07-20 17:45:48.072434	20250720_174830	replace_import
995	5061903_1	14	8494	2025-07-20 17:45:48.072434	20250720_174830	replace_import
996	5061803_1	14	8009	2025-07-20 17:45:48.072434	20250720_174830	replace_import
997	5061811_1	14	17160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
998	5061809_1	14	493	2025-07-20 17:45:48.072434	20250720_174830	replace_import
999	5061805_1	14	5406	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1000	5061804_1	14	4914	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1001	5061702_1	20	238	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1002	5061704_1	14	2129	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1003	5061703_1	14	2012	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1004	5061701_1	14	246	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1005	5061613_1	14	1810	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1006	5061615_1	20	539	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1007	5061614_1	20	1690	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1008	5061611_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1009	5061403_1	14	16496	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1010	5061405_1	13	1500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1011	5061404_1	14	1430	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1012	5061401_1	14	6021	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1013	5061304_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1014	5061308_1	20	18982	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1015	5061307_1	14	233	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1016	5061302_1	14	9080	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1017	5061105_1	14	28784	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1018	5061003_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1019	5061012_1	14	1353	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1020	5061011_1	20	2130	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1021	5061010_1	14	8372	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1022	5061007_1	18	29250	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1023	5061004_1	14	547	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1024	5061001_1	13	500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1025	5060914_1	14	2230	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1026	5060913_1	11	2819	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1027	5060910_1	14	835	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1028	5060904_1	14	859	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1029	5060801_1	20	6200	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1030	5060601_1	14	9876	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1031	5060602_1	14	19676	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1032	5060501_1	19	6066	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1033	5060401_1	14	3759	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1034	5060405_1	20	3780	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1035	5060404_1	20	4609	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1036	5060403_1	14	44	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1037	5060402_1	20	2156	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1038	5060301_1	20	10890	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1039	5060206_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1040	5060213_1	14	712	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1041	5060212_1	14	404	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1042	5060208_1	14	10874	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1043	5060207_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1044	5060104_1	17	16500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1045	5053117_1	15	46017	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1046	5053116_1	15	15400	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1047	5053115_1	15	10980	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1048	5053114_1	15	22000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1049	5053113_1	15	45467	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1050	5053112_1	15	55550	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1051	5053111_1	15	16740	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1052	5053108_1	16	180000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1053	5053106_1	13	500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1054	5053101_1	14	3724	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1055	5053008_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1056	5053031_1	19	922	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1057	5053018_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1058	5053017_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1059	5053016_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1060	5053015_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1061	5053014_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1062	5053013_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1063	5053009_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1064	5053007_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1065	5053006_1	12	145	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1066	5053005_1	19	19441	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1067	5053003_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1068	5052902_1	22	12080	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1069	5052901_1	14	11975	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1070	5052802_1	14	9573	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1071	5052812_1	10	150800	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1072	5052806_1	14	220	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1073	5052804_1	14	3557	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1074	5052801_1	20	1548	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1075	5052701_1	14	4397	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1076	5052602_1	17	10780	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1077	5052601_1	17	7909	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1078	5052605_1	14	8913	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1079	5052501_1	11	6395	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1080	5052404_1	14	1155	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1081	5052405_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1082	5052303_1	20	998	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1083	5052307_1	14	11061	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1084	5052306_1	19	18892	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1085	5052305_1	20	2087	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1086	5052304_1	19	8569	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1087	5052201_1	14	792	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1088	5052202_1	14	3580	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1089	5052102_1	21	10593	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1090	5052002_1	21	963	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1091	5052004_1	13	500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1092	5052003_1	13	5000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1093	5052001_1	11	20088	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1094	5051905_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1095	5051908_1	9	4140	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1096	5051903_1	21	3230	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1097	5051801_1	14	217	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1098	5051803_1	21	6118	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1099	5051701_1	14	3054	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1100	5051605_1	22	250	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1101	5051604_1	19	21103	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1102	5051502_1	21	8876	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1103	5051501_1	14	2479	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1104	5051410_1	14	3074	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1105	5051412_1	22	2420	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1106	5051409_1	17	10890	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1107	5051408_1	17	10890	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1108	5051402_1	22	530	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1109	5051401_1	14	213	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1110	5051310_1	14	857	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1111	5051309_1	14	5105	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1112	5051306_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1113	5051202_1	14	1520	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1114	5051101_1	21	3453	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1115	5051001_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1116	5050912_1	14	434	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1117	5050911_1	19	5910	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1118	5050910_1	19	22578	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1119	5050909_1	21	9155	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1120	5050903_1	9	320	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1121	5050902_1	13	3000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1122	5050801_1	14	1408	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1123	5050703_1	21	5732	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1124	5050701_1	14	12495	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1125	5050301_1	14	1771	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1126	5050213_1	19	14158	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1127	5050205_1	19	10120	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1128	5050109_1	14	576	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1129	5050110_1	14	1770	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1130	5050102_1	17	16500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1131	5043018_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1132	5043045_1	15	66000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1133	5043044_1	15	26400	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1134	5043043_1	15	45360	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1135	5043042_1	15	28800	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1136	5043041_1	15	35200	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1137	5043040_1	15	43450	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1138	5043039_1	15	17280	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1139	5043036_1	16	180000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1140	5043031_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1141	5043029_1	12	55	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1142	5043028_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1143	5043027_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1144	5043026_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1145	5043025_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1146	5043024_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1147	5043023_1	12	55	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1148	5043022_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1149	5043021_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1150	5043020_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1151	5043019_1	12	160	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1152	5043005_1	14	6482	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1153	5043003_1	12	165	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1154	5042801_1	19	3936	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1155	5042808_1	10	150800	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1156	5042807_1	17	8225	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1157	5042803_1	14	2283	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1158	5042601_1	14	2409	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1159	5042605_1	17	10780	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1160	5042602_1	14	4089	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1161	5042501_1	14	20711	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1162	5042405_1	11	8349	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1163	5042401_1	14	7687	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1164	5042203_1	19	16823	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1165	5042201_1	13	500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1166	5042102_1	14	896	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1167	5042101_1	14	637	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1168	5041905_1	14	9140	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1169	5041902_1	13	2000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1170	5041804_1	19	1974	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1171	5041803_1	19	20601	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1172	5041703_1	11	25962	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1173	5041701_1	14	9776	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1174	5041501_1	14	8000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1175	5041401_1	14	7269	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1176	5041405_1	20	699	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1177	5041105_1	19	20204	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1178	5040903_1	14	7436	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1179	5040901_1	11	3094	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1180	5040805_1	13	500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1181	5040702_1	14	110	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1182	5040407_1	19	2980	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1183	5040701_1	14	7534	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1184	5040504_1	14	2322	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1185	5040502_1	13	1500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1186	5040402_1	19	20057	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1187	5040401_1	19	8348	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1188	5040304_1	14	598	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1189	5040202_1	14	5044	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1190	5040105_1	30	60000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1191	5040102_1	17	16500	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1192	5040113_1	14	2184	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1193	5040111_1	13	1000	2025-07-20 17:45:48.072434	20250720_174830	replace_import
1194	5040103_1	30	336469	2025-07-20 17:45:48.072434	20250720_174830	replace_import
\.


--
-- Data for Name: allocations; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.allocations (id, transaction_id, budget_item_id, amount, created_at) FROM stdin;
1422	5070202_1	14	501	2025-07-20 17:48:30.467261
1423	5070102_1	17	16500	2025-07-20 17:48:30.467261
1424	5062901_1	14	2818	2025-07-20 17:48:30.467261
1425	5062801_1	14	4230	2025-07-20 17:48:30.467261
1426	5062803_1	14	3680	2025-07-20 17:48:30.467261
1427	5062802_1	14	2023	2025-07-20 17:48:30.467261
1428	5062712_1	14	6116	2025-07-20 17:48:30.467261
1429	5062717_1	14	20527	2025-07-20 17:48:30.467261
1430	5062716_1	14	11166	2025-07-20 17:48:30.467261
1431	5062714_1	14	283	2025-07-20 17:48:30.467261
1432	5062701_1	14	7753	2025-07-20 17:48:30.467261
1433	5062609_1	17	10780	2025-07-20 17:48:30.467261
1434	5062608_1	17	7539	2025-07-20 17:48:30.467261
1435	5062607_1	14	5780	2025-07-20 17:48:30.467261
1436	5062408_1	14	6497	2025-07-20 17:48:30.467261
1437	5062410_1	14	1628	2025-07-20 17:48:30.467261
1438	5062405_1	14	1404	2025-07-20 17:48:30.467261
1439	5062315_1	14	355	2025-07-20 17:48:30.467261
1440	5062316_1	14	5900	2025-07-20 17:48:30.467261
1441	5062201_1	14	10343	2025-07-20 17:48:30.467261
1442	5062105_1	14	213	2025-07-20 17:48:30.467261
1443	5062102_1	14	4086	2025-07-20 17:48:30.467261
1444	5062007_1	14	1300	2025-07-20 17:48:30.467261
1445	5062016_1	14	14001	2025-07-20 17:48:30.467261
1446	5062008_1	20	26972	2025-07-20 17:48:30.467261
1447	5062003_1	13	5000	2025-07-20 17:48:30.467261
1448	5062001_1	14	7377	2025-07-20 17:48:30.467261
1449	5061903_1	14	8494	2025-07-20 17:48:30.467261
1450	5061803_1	14	8009	2025-07-20 17:48:30.467261
1451	5061811_1	14	17160	2025-07-20 17:48:30.467261
1452	5061809_1	14	493	2025-07-20 17:48:30.467261
1453	5061805_1	14	5406	2025-07-20 17:48:30.467261
1454	5061804_1	14	4914	2025-07-20 17:48:30.467261
1455	5061702_1	20	238	2025-07-20 17:48:30.467261
1456	5061704_1	14	2129	2025-07-20 17:48:30.467261
1457	5061703_1	14	2012	2025-07-20 17:48:30.467261
1458	5061701_1	14	246	2025-07-20 17:48:30.467261
1459	5061613_1	14	1810	2025-07-20 17:48:30.467261
1460	5061615_1	20	539	2025-07-20 17:48:30.467261
1461	5061614_1	20	1690	2025-07-20 17:48:30.467261
1462	5061611_1	13	3000	2025-07-20 17:48:30.467261
1463	5061403_1	14	16496	2025-07-20 17:48:30.467261
1464	5061405_1	13	1500	2025-07-20 17:48:30.467261
1465	5061404_1	14	1430	2025-07-20 17:48:30.467261
1466	5061401_1	14	6021	2025-07-20 17:48:30.467261
1467	5061304_1	13	3000	2025-07-20 17:48:30.467261
1468	5061308_1	20	18982	2025-07-20 17:48:30.467261
1469	5061307_1	14	233	2025-07-20 17:48:30.467261
1470	5061302_1	14	9080	2025-07-20 17:48:30.467261
1471	5061105_1	14	28784	2025-07-20 17:48:30.467261
1472	5061003_1	13	3000	2025-07-20 17:48:30.467261
1473	5061012_1	14	1353	2025-07-20 17:48:30.467261
1474	5061011_1	20	2130	2025-07-20 17:48:30.467261
1475	5061010_1	14	8372	2025-07-20 17:48:30.467261
1476	5061007_1	18	29250	2025-07-20 17:48:30.467261
1477	5061004_1	14	547	2025-07-20 17:48:30.467261
1478	5061001_1	13	500	2025-07-20 17:48:30.467261
1479	5060914_1	14	2230	2025-07-20 17:48:30.467261
1480	5060913_1	11	2819	2025-07-20 17:48:30.467261
1481	5060910_1	14	835	2025-07-20 17:48:30.467261
1482	5060904_1	14	859	2025-07-20 17:48:30.467261
1483	5060801_1	20	6200	2025-07-20 17:48:30.467261
1484	5060601_1	14	9876	2025-07-20 17:48:30.467261
1485	5060602_1	14	19676	2025-07-20 17:48:30.467261
1486	5060501_1	19	6066	2025-07-20 17:48:30.467261
1487	5060401_1	14	3759	2025-07-20 17:48:30.467261
1488	5060405_1	20	3780	2025-07-20 17:48:30.467261
1489	5060404_1	20	4609	2025-07-20 17:48:30.467261
1490	5060403_1	14	44	2025-07-20 17:48:30.467261
1491	5060402_1	20	2156	2025-07-20 17:48:30.467261
1492	5060301_1	20	10890	2025-07-20 17:48:30.467261
1493	5060206_1	13	3000	2025-07-20 17:48:30.467261
1494	5060213_1	14	712	2025-07-20 17:48:30.467261
1495	5060212_1	14	404	2025-07-20 17:48:30.467261
1496	5060208_1	14	10874	2025-07-20 17:48:30.467261
1497	5060207_1	13	3000	2025-07-20 17:48:30.467261
1498	5060104_1	17	16500	2025-07-20 17:48:30.467261
1499	5053117_1	15	46017	2025-07-20 17:48:30.467261
1500	5053116_1	15	15400	2025-07-20 17:48:30.467261
1501	5053115_1	15	10980	2025-07-20 17:48:30.467261
1502	5053114_1	15	22000	2025-07-20 17:48:30.467261
1503	5053113_1	15	45467	2025-07-20 17:48:30.467261
1504	5053112_1	15	55550	2025-07-20 17:48:30.467261
1505	5053111_1	15	16740	2025-07-20 17:48:30.467261
1506	5053108_1	16	180000	2025-07-20 17:48:30.467261
1507	5053106_1	13	500	2025-07-20 17:48:30.467261
1508	5053101_1	14	3724	2025-07-20 17:48:30.467261
1509	5053008_1	12	145	2025-07-20 17:48:30.467261
1510	5053031_1	19	922	2025-07-20 17:48:30.467261
1511	5053018_1	12	145	2025-07-20 17:48:30.467261
1512	5053017_1	12	145	2025-07-20 17:48:30.467261
1513	5053016_1	12	145	2025-07-20 17:48:30.467261
1514	5053015_1	12	145	2025-07-20 17:48:30.467261
1515	5053014_1	12	145	2025-07-20 17:48:30.467261
1516	5053013_1	12	145	2025-07-20 17:48:30.467261
1517	5053009_1	12	145	2025-07-20 17:48:30.467261
1518	5053007_1	12	145	2025-07-20 17:48:30.467261
1519	5053006_1	12	145	2025-07-20 17:48:30.467261
1520	5053005_1	19	19441	2025-07-20 17:48:30.467261
1521	5053003_1	13	3000	2025-07-20 17:48:30.467261
1522	5052902_1	22	12080	2025-07-20 17:48:30.467261
1523	5052901_1	14	11975	2025-07-20 17:48:30.467261
1524	5052802_1	14	9573	2025-07-20 17:48:30.467261
1525	5052812_1	10	150800	2025-07-20 17:48:30.467261
1526	5052806_1	14	220	2025-07-20 17:48:30.467261
1527	5052804_1	14	3557	2025-07-20 17:48:30.467261
1528	5052801_1	20	1548	2025-07-20 17:48:30.467261
1529	5052701_1	14	4397	2025-07-20 17:48:30.467261
1530	5052602_1	17	10780	2025-07-20 17:48:30.467261
1531	5052601_1	17	7909	2025-07-20 17:48:30.467261
1532	5052605_1	14	8913	2025-07-20 17:48:30.467261
1533	5052501_1	11	6395	2025-07-20 17:48:30.467261
1534	5052404_1	14	1155	2025-07-20 17:48:30.467261
1535	5052405_1	13	3000	2025-07-20 17:48:30.467261
1536	5052303_1	20	998	2025-07-20 17:48:30.467261
1537	5052307_1	14	11061	2025-07-20 17:48:30.467261
1538	5052306_1	19	18892	2025-07-20 17:48:30.467261
1539	5052305_1	20	2087	2025-07-20 17:48:30.467261
1540	5052304_1	19	8569	2025-07-20 17:48:30.467261
1541	5052201_1	14	792	2025-07-20 17:48:30.467261
1542	5052202_1	14	3580	2025-07-20 17:48:30.467261
1543	5052102_1	21	10593	2025-07-20 17:48:30.467261
1544	5052002_1	21	963	2025-07-20 17:48:30.467261
1545	5052004_1	13	500	2025-07-20 17:48:30.467261
1546	5052003_1	13	5000	2025-07-20 17:48:30.467261
1547	5052001_1	11	20088	2025-07-20 17:48:30.467261
1548	5051905_1	13	3000	2025-07-20 17:48:30.467261
1549	5051908_1	9	4140	2025-07-20 17:48:30.467261
1550	5051903_1	21	3230	2025-07-20 17:48:30.467261
1551	5051801_1	14	217	2025-07-20 17:48:30.467261
1552	5051803_1	21	6118	2025-07-20 17:48:30.467261
1553	5051701_1	14	3054	2025-07-20 17:48:30.467261
1554	5051605_1	22	250	2025-07-20 17:48:30.467261
1555	5051604_1	19	21103	2025-07-20 17:48:30.467261
1556	5051502_1	21	8876	2025-07-20 17:48:30.467261
1557	5051501_1	14	2479	2025-07-20 17:48:30.467261
1558	5051410_1	14	3074	2025-07-20 17:48:30.467261
1559	5051412_1	22	2420	2025-07-20 17:48:30.467261
1560	5051409_1	17	10890	2025-07-20 17:48:30.467261
1561	5051408_1	17	10890	2025-07-20 17:48:30.467261
1562	5051402_1	22	530	2025-07-20 17:48:30.467261
1563	5051401_1	14	213	2025-07-20 17:48:30.467261
1564	5051310_1	14	857	2025-07-20 17:48:30.467261
1565	5051309_1	14	5105	2025-07-20 17:48:30.467261
1566	5051306_1	13	3000	2025-07-20 17:48:30.467261
1567	5051202_1	14	1520	2025-07-20 17:48:30.467261
1568	5051101_1	21	3453	2025-07-20 17:48:30.467261
1569	5051001_1	13	3000	2025-07-20 17:48:30.467261
1570	5050912_1	14	434	2025-07-20 17:48:30.467261
1571	5050911_1	19	5910	2025-07-20 17:48:30.467261
1572	5050910_1	19	22578	2025-07-20 17:48:30.467261
1573	5050909_1	21	9155	2025-07-20 17:48:30.467261
1574	5050903_1	9	320	2025-07-20 17:48:30.467261
1575	5050902_1	13	3000	2025-07-20 17:48:30.467261
1576	5050801_1	14	1408	2025-07-20 17:48:30.467261
1577	5050703_1	21	5732	2025-07-20 17:48:30.467261
1578	5050701_1	14	12495	2025-07-20 17:48:30.467261
1579	5050301_1	14	1771	2025-07-20 17:48:30.467261
1580	5050213_1	19	14158	2025-07-20 17:48:30.467261
1581	5050205_1	19	10120	2025-07-20 17:48:30.467261
1582	5050109_1	14	576	2025-07-20 17:48:30.467261
1583	5050110_1	14	1770	2025-07-20 17:48:30.467261
1584	5050102_1	17	16500	2025-07-20 17:48:30.467261
1585	5043018_1	12	160	2025-07-20 17:48:30.467261
1586	5043045_1	15	66000	2025-07-20 17:48:30.467261
1587	5043044_1	15	26400	2025-07-20 17:48:30.467261
1588	5043043_1	15	45360	2025-07-20 17:48:30.467261
1589	5043042_1	15	28800	2025-07-20 17:48:30.467261
1590	5043041_1	15	35200	2025-07-20 17:48:30.467261
1591	5043040_1	15	43450	2025-07-20 17:48:30.467261
1592	5043039_1	15	17280	2025-07-20 17:48:30.467261
1593	5043036_1	16	180000	2025-07-20 17:48:30.467261
1594	5043031_1	12	160	2025-07-20 17:48:30.467261
1595	5043029_1	12	55	2025-07-20 17:48:30.467261
1596	5043028_1	12	160	2025-07-20 17:48:30.467261
1597	5043027_1	12	160	2025-07-20 17:48:30.467261
1598	5043026_1	12	160	2025-07-20 17:48:30.467261
1599	5043025_1	12	160	2025-07-20 17:48:30.467261
1600	5043024_1	12	160	2025-07-20 17:48:30.467261
1601	5043023_1	12	55	2025-07-20 17:48:30.467261
1602	5043022_1	12	160	2025-07-20 17:48:30.467261
1603	5043021_1	12	160	2025-07-20 17:48:30.467261
1604	5043020_1	12	160	2025-07-20 17:48:30.467261
1605	5043019_1	12	160	2025-07-20 17:48:30.467261
1606	5043005_1	14	6482	2025-07-20 17:48:30.467261
1607	5043003_1	12	165	2025-07-20 17:48:30.467261
1608	5042801_1	19	3936	2025-07-20 17:48:30.467261
1609	5042808_1	10	150800	2025-07-20 17:48:30.467261
1610	5042807_1	17	8225	2025-07-20 17:48:30.467261
1611	5042803_1	14	2283	2025-07-20 17:48:30.467261
1612	5042601_1	14	2409	2025-07-20 17:48:30.467261
1613	5042605_1	17	10780	2025-07-20 17:48:30.467261
1614	5042602_1	14	4089	2025-07-20 17:48:30.467261
1615	5042501_1	14	20711	2025-07-20 17:48:30.467261
1616	5042405_1	11	8349	2025-07-20 17:48:30.467261
1617	5042401_1	14	7687	2025-07-20 17:48:30.467261
1618	5042203_1	19	16823	2025-07-20 17:48:30.467261
1619	5042201_1	13	500	2025-07-20 17:48:30.467261
1620	5042102_1	14	896	2025-07-20 17:48:30.467261
1621	5042101_1	14	637	2025-07-20 17:48:30.467261
1622	5041905_1	14	9140	2025-07-20 17:48:30.467261
1623	5041902_1	13	2000	2025-07-20 17:48:30.467261
1624	5041804_1	19	1974	2025-07-20 17:48:30.467261
1625	5041803_1	19	20601	2025-07-20 17:48:30.467261
1626	5041703_1	11	25962	2025-07-20 17:48:30.467261
1627	5041701_1	14	9776	2025-07-20 17:48:30.467261
1628	5041501_1	14	8000	2025-07-20 17:48:30.467261
1629	5041401_1	14	7269	2025-07-20 17:48:30.467261
1630	5041405_1	20	699	2025-07-20 17:48:30.467261
1631	5041105_1	19	20204	2025-07-20 17:48:30.467261
1632	5040903_1	14	7436	2025-07-20 17:48:30.467261
1633	5040901_1	11	3094	2025-07-20 17:48:30.467261
1634	5040805_1	13	500	2025-07-20 17:48:30.467261
1635	5040702_1	14	110	2025-07-20 17:48:30.467261
1636	5040407_1	19	2980	2025-07-20 17:48:30.467261
1637	5040701_1	14	7534	2025-07-20 17:48:30.467261
1638	5040504_1	14	2322	2025-07-20 17:48:30.467261
1639	5040502_1	13	1500	2025-07-20 17:48:30.467261
1640	5040402_1	19	20057	2025-07-20 17:48:30.467261
1641	5040401_1	19	8348	2025-07-20 17:48:30.467261
1642	5040304_1	14	598	2025-07-20 17:48:30.467261
1643	5040202_1	14	5044	2025-07-20 17:48:30.467261
1644	5040105_1	30	60000	2025-07-20 17:48:30.467261
1645	5040102_1	17	16500	2025-07-20 17:48:30.467261
1646	5040113_1	14	2184	2025-07-20 17:48:30.467261
1647	5040111_1	13	1000	2025-07-20 17:48:30.467261
1648	5040103_1	30	336469	2025-07-20 17:48:30.467261
\.


--
-- Data for Name: budget_items; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.budget_items (id, grant_id, name, category, budgeted_amount, remarks) FROM stdin;
30	7	終了分	ほか	396469	\N
9	1	印刷製本費	固定	39200	\N
10	1	家賃	家賃	1141200	\N
11	1	光熱水費	光熱	342000	\N
12	1	雑役務費	ほか	12000	\N
13	1	謝金	謝金	132000	\N
15	1	賃金（アルバイト）	賃金	2382600	\N
16	1	賃金（職員）	賃金	1920000	\N
17	1	通信運搬費	通信	498000	\N
18	1	保険料	保険	25000	\N
19	2	食材費	食材	216000	\N
20	2	消耗品費	消耗	89127	\N
21	3	食品購入費	食材	48000	\N
22	3	消耗品費	消耗	12000	\N
23	4	食品購入費	食材	82600	\N
24	4	消耗品費	消耗	17400	\N
25	5	食材費	食材	1488000	\N
26	5	衛生用品	消耗	200280	\N
27	5	レンタカー	固定	234000	\N
31	6	学びフェス	固定	470000	\N
14	1	消耗品費	消耗・食材	508000	\N
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.categories (id, name, description, created_at, updated_at, is_active) FROM stdin;
1	固定	固定費用	2025-07-08 15:45:02.001509	2025-07-08 15:45:02.001517	t
2	家賃	賃貸料	2025-07-08 15:45:02.001519	2025-07-08 15:45:02.001521	t
3	光熱	光熱費	2025-07-08 15:45:02.001523	2025-07-08 15:45:02.001524	t
4	ほか	その他	2025-07-08 15:45:02.001526	2025-07-08 15:45:02.001527	t
5	謝金	謝礼金	2025-07-08 15:45:02.001528	2025-07-08 15:45:02.00153	t
6	消耗	消耗品費	2025-07-08 15:45:02.001531	2025-07-08 15:45:02.001532	t
7	賃金	給与・賃金	2025-07-08 15:45:02.001534	2025-07-08 15:45:02.001535	t
8	通信	通信費	2025-07-08 15:45:02.001537	2025-07-08 15:45:02.001538	t
9	保険	保険料	2025-07-08 15:45:02.001539	2025-07-08 15:45:02.001541	t
10	食材	食材費	2025-07-08 15:45:02.001542	2025-07-08 15:45:02.001543	t
11	消耗・食材	\N	2025-07-15 11:22:54.123619	2025-07-15 11:22:54.123629	t
\.


--
-- Data for Name: dev_allocations; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.dev_allocations (id, transaction_id, budget_item_id, amount, created_at) FROM stdin;
\.


--
-- Data for Name: dev_budget_items; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.dev_budget_items (id, grant_id, name, category, budgeted_amount) FROM stdin;
\.


--
-- Data for Name: dev_freee_syncs; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.dev_freee_syncs (id, sync_type, start_date, end_date, status, total_records, processed_records, created_records, updated_records, error_message, created_at, completed_at) FROM stdin;
\.


--
-- Data for Name: dev_freee_tokens; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.dev_freee_tokens (id, access_token, refresh_token, token_type, expires_at, scope, company_id, created_at, updated_at, is_active) FROM stdin;
\.


--
-- Data for Name: dev_grants; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.dev_grants (id, name, total_amount, start_date, end_date, status) FROM stdin;
\.


--
-- Data for Name: dev_transactions; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.dev_transactions (id, journal_number, journal_line_number, date, description, amount, account, supplier, item, memo, remark, department, management_number, raw_data, created_at) FROM stdin;
\.


--
-- Data for Name: freee_syncs; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.freee_syncs (id, sync_type, start_date, end_date, status, total_records, processed_records, created_records, updated_records, error_message, created_at, completed_at) FROM stdin;
\.


--
-- Data for Name: freee_tokens; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.freee_tokens (id, access_token, refresh_token, token_type, expires_at, scope, company_id, created_at, updated_at, is_active) FROM stdin;
\.


--
-- Data for Name: grants; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.grants (id, name, total_amount, start_date, end_date, status, grant_code) FROM stdin;
9	POPOLO	3000000	2025-07-28	2026-01-07	active	250765_POPO_ひとり親
2	つながり10	305127	2025-04-01	2025-07-31	completed	250413_愛知募金_つながり10月
7	日財終了分	396469	2025-04-01	2025-06-30	applied	
1	WAM補	7000000	2025-04-01	2026-03-31	active	250403_WAMG_WAM補
6	日本財団	470000	2025-07-22	2026-06-30	active	250616_日本財団_寄付支援
5	まんぷく	1922280	2025-07-01	2026-06-30	active	250709_フィラン_まんぷく
4	むすファミ	100000	2025-04-01	2025-09-30	active	250411_むすびえ_ファミマ
3	むす春	60000	2025-04-01	2025-05-31	completed	250412_むすびえ_春募集
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.transactions (id, journal_number, journal_line_number, date, description, amount, account, supplier, item, memo, remark, department, management_number, raw_data, created_at) FROM stdin;
5040102_1	5040102	1	2025-04-01	Vデビット　SB*LINE OFFICIAL ACCOUN　1A091001	16500	【事】通信運搬費	LINE株式会社	LINE		LINE公式アカウント	子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3020147349,"\\u4ed5\\u8a33\\u756a\\u53f7":5040102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"LINE","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"LINE\\u516c\\u5f0f\\u30a2\\u30ab\\u30a6\\u30f3\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000SB*LINE OFFICIAL ACCOUN\\u30001A091001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:16","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.325803
5040103_1	5040103	1	2025-04-01	振込 スマイルワン（カ	336469	【事】教養娯楽費	住マイルワン株式会社	その他	JNIPN2419_③支援	プチハウス材料	子育てに関する相談支援事業（旧）	2504-070	{"\\u4ed5\\u8a33ID":3020181553,"\\u4ed5\\u8a33\\u756a\\u53f7":5040103,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-070","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6559\\u990a\\u5a2f\\u697d\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":336469.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u305d\\u306e\\u4ed6","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":"JNIPN2419_\\u2462\\u652f\\u63f4","\\u501f\\u65b9\\u5099\\u8003":"\\u30d7\\u30c1\\u30cf\\u30a6\\u30b9\\u6750\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b9\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\uff08\\u30ab","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 18:49"}	2025-07-09 11:23:17.32581
5040104_1	5040104	1	2025-04-01	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3020182080,"\\u4ed5\\u8a33\\u756a\\u53f7":5040104,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/03 12:05"}	2025-07-09 11:23:17.325813
5040105_1	5040105	1	2025-04-01	振込 スマイルワン（カ	60000	【事】謝金	住マイルワン株式会社	謝金講師	JNIPN2419_③支援	プチハウス制作ワークショップ	子育てに関する相談支援事業（旧）	2504-69	{"\\u4ed5\\u8a33ID":3020182574,"\\u4ed5\\u8a33\\u756a\\u53f7":5040105,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-69","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":60000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":"JNIPN2419_\\u2462\\u652f\\u63f4","\\u501f\\u65b9\\u5099\\u8003":"\\u30d7\\u30c1\\u30cf\\u30a6\\u30b9\\u5236\\u4f5c\\u30ef\\u30fc\\u30af\\u30b7\\u30e7\\u30c3\\u30d7","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b9\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\uff08\\u30ab","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325815
5040106_1	5040106	1	2025-04-01	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3020186177,"\\u4ed5\\u8a33\\u756a\\u53f7":5040106,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/03 12:05"}	2025-07-09 11:23:17.325818
5040108_1	5040108	1	2025-04-01	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3020187718,"\\u4ed5\\u8a33\\u756a\\u53f7":5040108,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/03 12:05"}	2025-07-09 11:23:17.32582
5040109_1	5040109	1	2025-04-01	ＰＡＹＰＡＹ	487	【管】支払手数料					管理部門		{"\\u4ed5\\u8a33ID":3020212093,"\\u4ed5\\u8a33\\u756a\\u53f7":5040109,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":487.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"paypay\\u652f\\u6255\\u3044","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff30\\uff21\\uff39\\uff30\\uff21\\uff39","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:38","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 19:25"}	2025-07-09 11:23:17.325823
5040111_1	5040111	1	2025-04-01		1000	【事】謝金	ボランティア	謝金ボラ		森川、松本	子育てに関する相談支援事業（旧）	2504-001	{"\\u4ed5\\u8a33ID":3020242747,"\\u4ed5\\u8a33\\u756a\\u53f7":5040111,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-001","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u677e\\u672c","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325826
5040113_1	5040113	1	2025-04-01		2184	【事】食材費	株式会社タチヤ	消耗食材			子育てに関する相談支援事業（旧）	2504-005	{"\\u4ed5\\u8a33ID":3026154026,"\\u4ed5\\u8a33\\u756a\\u53f7":5040113,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-005","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2184.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32583
5040201_1	5040201	1	2025-04-02		190	【管】印刷製本費	長久手市役所	印刷		リフレクションシート	管理部門	2504-003	{"\\u4ed5\\u8a33ID":3020231561,"\\u4ed5\\u8a33\\u756a\\u53f7":5040201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-003","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":190.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ea\\u30d5\\u30ec\\u30af\\u30b7\\u30e7\\u30f3\\u30b7\\u30fc\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:45","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/03 17:53"}	2025-07-09 11:23:17.325834
5040202_1	5040202	1	2025-04-02		5044	【事】食材費	イオンリテール株式会社	消耗食材			子育てに関する相談支援事業（旧）	2504-002	{"\\u4ed5\\u8a33ID":3020241306,"\\u4ed5\\u8a33\\u756a\\u53f7":5040202,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-002","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5044.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/03 10:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325837
5040304_1	5040304	1	2025-04-03	ウエルシア長久手岩作店 Freee 今枝	598	【管】会議費	ウエルシア薬局	消耗菓子		菓子	管理部門	2504-004	{"\\u4ed5\\u8a33ID":3024661240,"\\u4ed5\\u8a33\\u756a\\u53f7":5040304,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-004","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/03","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u4f1a\\u8b70\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":598.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u83d3\\u5b50","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/05 13:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/05 13:37"}	2025-07-09 11:23:17.325841
5040305_1	5040305	1	2025-04-03	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	4788	【管】消耗品費	アマゾンジャパン合同会社	消耗		インクカートリッジ	管理部門	2504-007	{"\\u4ed5\\u8a33ID":3026130513,"\\u4ed5\\u8a33\\u756a\\u53f7":5040305,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-007","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/03","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4788.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30a4\\u30f3\\u30af\\u30ab\\u30fc\\u30c8\\u30ea\\u30c3\\u30b8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/07 10:20"}	2025-07-09 11:23:17.325845
5040306_1	5040306	1	2025-04-03	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	3247	【管】消耗品費	アマゾンジャパン合同会社	消耗		コピー用紙	管理部門	2504-006	{"\\u4ed5\\u8a33ID":3026133136,"\\u4ed5\\u8a33\\u756a\\u53f7":5040306,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-006","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/03","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3247.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30b3\\u30d4\\u30fc\\u7528\\u7d19","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/07 10:20"}	2025-07-09 11:23:17.325848
5040401_1	5040401	1	2025-04-04	アミカ Freee 古賀	8348	【事】食材費	アミカ	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-008	{"\\u4ed5\\u8a33ID":3026115562,"\\u4ed5\\u8a33\\u756a\\u53f7":5040401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-008","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8348.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325852
5040402_1	5040402	1	2025-04-04		20057	【事】食材費	株式会社タチヤ	消耗食材			子育てに関する相談支援事業（旧）	2504-009	{"\\u4ed5\\u8a33ID":3026156186,"\\u4ed5\\u8a33\\u756a\\u53f7":5040402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-009","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20057.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325855
5040403_1	5040403	1	2025-04-04		500	【事】謝金	ボランティア	謝金ボラ		森川	子育てに関する相談支援事業（旧）	2504-010	{"\\u4ed5\\u8a33ID":3026162516,"\\u4ed5\\u8a33\\u756a\\u53f7":5040403,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-010","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325858
5040501_1	5040501	1	2025-04-05	ADOBE SYSTEMS SOFTWARE Freee バーチャル（ネット用）	3610	【事】通信運搬費	Adobe Systems Software Ireland Ltd	通信			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3026136106,"\\u4ed5\\u8a33\\u756a\\u53f7":5040501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3610.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ADOBE SYSTEMS SOFTWARE Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.325862
5040502_1	5040502	1	2025-04-05		1500	【事】謝金	ボランティア	謝金ボラ		渡邉、鋤柄、若杉	子育てに関する相談支援事業（旧）	2504-012	{"\\u4ed5\\u8a33ID":3026161276,"\\u4ed5\\u8a33\\u756a\\u53f7":5040502,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-012","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6e21\\u9089\\u3001\\u92e4\\u67c4\\u3001\\u82e5\\u6749","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325865
5040504_1	5040504	1	2025-04-05		2322	【事】食材費	ミニストップ	消耗食材	学習支援	おにぎりなど	子育てに関する相談支援事業（旧）	2504-011	{"\\u4ed5\\u8a33ID":3026223153,"\\u4ed5\\u8a33\\u756a\\u53f7":5040504,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-011","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2322.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u306b\\u304e\\u308a\\u306a\\u3069","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325868
5040701_1	5040701	1	2025-04-07		7534	【事】食材費	イオンリテール株式会社	消耗食材			子育てに関する相談支援事業（旧）	2504-013	{"\\u4ed5\\u8a33ID":3026157722,"\\u4ed5\\u8a33\\u756a\\u53f7":5040701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-013","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7534.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 10:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325872
5040702_1	5040702	1	2025-04-07		110	【事】消耗品費	DAISO	消耗	学習支援	はがき	子育てに関する相談支援事業（旧）	2504-014	{"\\u4ed5\\u8a33ID":3026822828,"\\u4ed5\\u8a33\\u756a\\u53f7":5040702,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-014","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":110.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u5099\\u8003":"\\u306f\\u304c\\u304d","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/07 13:54","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.325875
5040407_1	5040407	1	2025-04-07	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	2980	【事】食材費	アマゾンジャパン合同会社	消耗食材		ペットボトルお茶	子育てに関する相談支援事業（旧）	2504-018	{"\\u4ed5\\u8a33ID":3041244747,"\\u4ed5\\u8a33\\u756a\\u53f7":5040407,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-018","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2980.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30da\\u30c3\\u30c8\\u30dc\\u30c8\\u30eb\\u304a\\u8336","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 15:17","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325878
5040802_1	5040802	1	2025-04-08	未来屋書店　長久手 Freee 古賀	1474	【事】教養娯楽費	未来屋書店長久手店	消耗		学習ドリル	子育てに関する相談支援事業（旧）	2504-016	{"\\u4ed5\\u8a33ID":3029549231,"\\u4ed5\\u8a33\\u756a\\u53f7":5040802,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-016","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6559\\u990a\\u5a2f\\u697d\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1474.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u9577\\u4e45\\u624b\\u5e97","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u9577\\u4e45\\u624b\\u5e97","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5b66\\u7fd2\\u30c9\\u30ea\\u30eb","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u3000\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/08 16:17","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 18:49"}	2025-07-09 11:23:17.325882
5040803_1	5040803	1	2025-04-08	振込手数料	55	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3029553520,"\\u4ed5\\u8a33\\u756a\\u53f7":5040803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":55.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/08 16:18","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/17 10:59"}	2025-07-09 11:23:17.325886
5040804_1	5040804	1	2025-04-08		1700	【管】租税公課	名古屋法務局			履歴事項全部証明書、印鑑証明	管理部門	2504-015	{"\\u4ed5\\u8a33ID":3029629114,"\\u4ed5\\u8a33\\u756a\\u53f7":5040804,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-015","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u79df\\u7a0e\\u516c\\u8ab2","\\u501f\\u65b9\\u91d1\\u984d":1700.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u6cd5\\u52d9\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u6cd5\\u52d9\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5c65\\u6b74\\u4e8b\\u9805\\u5168\\u90e8\\u8a3c\\u660e\\u66f8\\u3001\\u5370\\u9451\\u8a3c\\u660e","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/08 16:45","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/08 16:45"}	2025-07-09 11:23:17.325889
5040805_1	5040805	1	2025-04-08		500	【事】謝金	ボランティア	謝金ボラ		森川	子育てに関する相談支援事業（旧）	2504-017	{"\\u4ed5\\u8a33ID":3029632522,"\\u4ed5\\u8a33\\u756a\\u53f7":5040805,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-017","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/08 16:46","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325892
5040806_1	5040806	1	2025-04-08		2630	【事】通信運搬費	日本郵便株式会社	通信		レターパックライト、切手	子育てに関する相談支援事業（旧）	2504-019	{"\\u4ed5\\u8a33ID":3032719847,"\\u4ed5\\u8a33\\u756a\\u53f7":5040806,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-019","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2630.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ec\\u30bf\\u30fc\\u30d1\\u30c3\\u30af\\u30e9\\u30a4\\u30c8\\u3001\\u5207\\u624b","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/10 10:03","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.325896
5040807_1	5040807	1	2025-04-08	ココナラ Freee田中	3920	【事】謝金	ココナラ	謝金講師		中井優希チラシデザイン	子育てに関する相談支援事業（旧）	2504-022	{"\\u4ed5\\u8a33ID":3032848192,"\\u4ed5\\u8a33\\u756a\\u53f7":5040807,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-022","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3920.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b3\\u30b3\\u30ca\\u30e9","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b3\\u30b3\\u30ca\\u30e9","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u4e2d\\u4e95\\u512a\\u5e0c\\u30c1\\u30e9\\u30b7\\u30c7\\u30b6\\u30a4\\u30f3","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30b3\\u30b3\\u30ca\\u30e9 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/10 10:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325899
5040901_1	5040901	1	2025-04-09		3094	【事】水道光熱費	愛知中部水道企業団	水光		水道代	共通部門	2504-021	{"\\u4ed5\\u8a33ID":3032722234,"\\u4ed5\\u8a33\\u756a\\u53f7":5040901,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-021","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3094.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u4e2d\\u90e8\\u6c34\\u9053\\u4f01\\u696d\\u56e3","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u4e2d\\u90e8\\u6c34\\u9053\\u4f01\\u696d\\u56e3","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6c34\\u9053\\u4ee3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/10 10:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:49"}	2025-07-09 11:23:17.325903
5040903_1	5040903	1	2025-04-09		7436	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-020	{"\\u4ed5\\u8a33ID":3032727692,"\\u4ed5\\u8a33\\u756a\\u53f7":5040903,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-020","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7436.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/10 10:05","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325906
5041001_1	5041001	1	2025-04-10	PRINTPAC CORPORATION Freee バーチャル（ネット用）	12970	【事】印刷製本費	プリントパック	印刷		WAM報告書	子育てに関する相談支援事業（旧）	2504-024	{"\\u4ed5\\u8a33ID":3033768807,"\\u4ed5\\u8a33\\u756a\\u53f7":5041001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-024","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":12970.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"WAM\\u5831\\u544a\\u66f8","\\u53d6\\u5f15\\u5185\\u5bb9":"PRINTPAC CORPORATION Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/10 16:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:44"}	2025-07-09 11:23:17.32591
5041101_1	5041101	1	2025-04-11		1500	【事】謝金	ボランティア	謝金ボラ		三村、馬場、田中	子育てに関する相談支援事業（旧）	2504-025	{"\\u4ed5\\u8a33ID":3041084589,"\\u4ed5\\u8a33\\u756a\\u53f7":5041101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-025","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u4e09\\u6751\\u3001\\u99ac\\u5834\\u3001\\u7530\\u4e2d","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 14:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325913
5041105_1	5041105	1	2025-04-11		20204	【事】食材費	株式会社タチヤ	消耗食材			子育てに関する相談支援事業（旧）	2504-026	{"\\u4ed5\\u8a33ID":3043138019,"\\u4ed5\\u8a33\\u756a\\u53f7":5041105,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-026","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20204.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/16 13:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325916
5041401_1	5041401	1	2025-04-14		7269	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-027	{"\\u4ed5\\u8a33ID":3041088548,"\\u4ed5\\u8a33\\u756a\\u53f7":5041401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-027","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7269.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 14:25","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325919
5041402_1	5041402	1	2025-04-14	ロイヤルホームセンター長久手 Freee 今枝	2922	【管】消耗品費	ロイヤルホームセンター	消耗		害虫忌避剤、ポリ袋	管理部門	2504-028	{"\\u4ed5\\u8a33ID":3041097623,"\\u4ed5\\u8a33\\u756a\\u53f7":5041402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-028","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2922.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5bb3\\u866b\\u5fcc\\u907f\\u5264\\u3001\\u30dd\\u30ea\\u888b","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 14:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/15 15:46"}	2025-07-09 11:23:17.325922
5041404_1	5041404	1	2025-04-14		300	【事】雑費				精米機使用料	子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3041125159,"\\u4ed5\\u8a33\\u756a\\u53f7":5041404,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":300.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7cbe\\u7c73\\u6a5f\\u4f7f\\u7528\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 14:40","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:21"}	2025-07-09 11:23:17.325926
5041405_1	5041405	1	2025-04-14	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	699	【管】消耗品費	アマゾンジャパン合同会社	消耗		キッチンスケール	管理部門	2504-031	{"\\u4ed5\\u8a33ID":3041336465,"\\u4ed5\\u8a33\\u756a\\u53f7":5041405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-031","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":699.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ad\\u30c3\\u30c1\\u30f3\\u30b9\\u30b1\\u30fc\\u30eb","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 15:44","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/15 15:45"}	2025-07-09 11:23:17.325929
5041406_1	5041406	1	2025-04-14		110	【管】消耗品費	DAISO	消耗		出金伝票	管理部門	2504-032	{"\\u4ed5\\u8a33ID":3043139912,"\\u4ed5\\u8a33\\u756a\\u53f7":5041406,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-032","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":110.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u51fa\\u91d1\\u4f1d\\u7968","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/16 13:57","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/16 16:30"}	2025-07-09 11:23:17.325932
5041501_1	5041501	1	2025-04-15	お菓子のひろば　尾張旭店／ＮＦＣ Freee 今枝	8000	【事】食材費	お菓子のひろば	消耗菓子		だがし	子育てに関する相談支援事業（旧）	2504-029	{"\\u4ed5\\u8a33ID":3041113378,"\\u4ed5\\u8a33\\u756a\\u53f7":5041501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-029","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/15","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u3060\\u304c\\u3057","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070\\u3000\\u5c3e\\u5f35\\u65ed\\u5e97\\uff0f\\uff2e\\uff26\\uff23 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 14:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325935
5041502_1	5041502	1	2025-04-15	未来屋書店　長久手 Freee田中	660	【管】消耗品費	未来屋書店長久手店	消耗		朱肉	管理部門	2504-030	{"\\u4ed5\\u8a33ID":3041115480,"\\u4ed5\\u8a33\\u756a\\u53f7":5041502,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-030","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/15","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":660.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u9577\\u4e45\\u624b\\u5e97","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u9577\\u4e45\\u624b\\u5e97","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6731\\u8089","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u3000\\u9577\\u4e45\\u624b Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/15 14:36","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/15 15:45"}	2025-07-09 11:23:17.325939
5041601_1	5041601	1	2025-04-16	未来屋書店　長久手 Freee 古賀	1320	【事】消耗品費	未来屋書店長久手店	消耗		学習参考書	子育てに関する相談支援事業（旧）	2504-033	{"\\u4ed5\\u8a33ID":3043594863,"\\u4ed5\\u8a33\\u756a\\u53f7":5041601,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-033","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1320.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u9577\\u4e45\\u624b\\u5e97","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u9577\\u4e45\\u624b\\u5e97","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5b66\\u7fd2\\u53c2\\u8003\\u66f8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u672a\\u6765\\u5c4b\\u66f8\\u5e97\\u3000\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/16 16:25","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.325943
5041701_1	5041701	1	2025-04-17		9776	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-034	{"\\u4ed5\\u8a33ID":3044484694,"\\u4ed5\\u8a33\\u756a\\u53f7":5041701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-034","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":9776.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/17 10:08","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325946
5041703_1	5041703	1	2025-04-17	中部電力電気料金	25962	【事】水道光熱費	中部電力ミライズ株式会社	水光		電気代	共通部門	2504-023	{"\\u4ed5\\u8a33ID":3044602598,"\\u4ed5\\u8a33\\u756a\\u53f7":5041703,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-023","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":25962.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u90e8\\u96fb\\u529b\\u30df\\u30e9\\u30a4\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u90e8\\u96fb\\u529b\\u30df\\u30e9\\u30a4\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u96fb\\u6c17\\u4ee3","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u4e2d\\u90e8\\u96fb\\u529b\\u96fb\\u6c17\\u6599\\u91d1","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/17 10:54","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:49"}	2025-07-09 11:23:17.325949
5041704_1	5041704	1	2025-04-17	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3044607756,"\\u4ed5\\u8a33\\u756a\\u53f7":5041704,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/17 10:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/17 11:00"}	2025-07-09 11:23:17.325952
5041802_1	5041802	1	2025-04-18		760	【管】通信運搬費	日本郵便株式会社	通信		ゆうパック　WAM報告書類の郵送	管理部門	2504-036	{"\\u4ed5\\u8a33ID":3047543488,"\\u4ed5\\u8a33\\u756a\\u53f7":5041802,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-036","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":760.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u3086\\u3046\\u30d1\\u30c3\\u30af\\u3000WAM\\u5831\\u544a\\u66f8\\u985e\\u306e\\u90f5\\u9001","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/18 16:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 16:20"}	2025-07-09 11:23:17.325955
5041803_1	5041803	1	2025-04-18		20601	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-037	{"\\u4ed5\\u8a33ID":3047546753,"\\u4ed5\\u8a33\\u756a\\u53f7":5041803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-037","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20601.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/18 16:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325958
5041805_1	5041805	1	2025-04-18	ADOBE  *ADOBE Freee バーチャル（ネット用）	3828	【事】通信運搬費	Adobe Systems Software Ireland Ltd	通信			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3050329181,"\\u4ed5\\u8a33\\u756a\\u53f7":5041805,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3828.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ADOBE  *ADOBE Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/21 13:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.325962
5041806_1	5041806	1	2025-04-18		2500	【事】謝金	ボランティア	謝金ボラ		森川、太田、田中、竹内、馬場	子育てに関する相談支援事業（旧）	2504-040	{"\\u4ed5\\u8a33ID":3050469316,"\\u4ed5\\u8a33\\u756a\\u53f7":5041806,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-040","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":2500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u592a\\u7530\\u3001\\u7530\\u4e2d\\u3001\\u7af9\\u5185\\u3001\\u99ac\\u5834","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/21 14:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325965
5041804_1	5041804	1	2025-04-18	イオン長久手 Freee 古賀	1974	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-035	{"\\u4ed5\\u8a33ID":3052542497,"\\u4ed5\\u8a33\\u756a\\u53f7":5041804,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-035","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1974.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/22 15:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325968
5041901_1	5041901	1	2025-04-19		3000	【事】謝金	木村草平	謝金講師		講師謝金	子育てに関する相談支援事業（旧）	2504-042	{"\\u4ed5\\u8a33ID":3050466819,"\\u4ed5\\u8a33\\u756a\\u53f7":5041901,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-042","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6728\\u6751\\u8349\\u5e73","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6728\\u6751\\u8349\\u5e73","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8b1b\\u5e2b\\u8b1d\\u91d1","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/21 14:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325971
5041902_1	5041902	1	2025-04-19		2000	【事】謝金	ボランティア	謝金ボラ		渡邉、鋤柄、羽地、野田	子育てに関する相談支援事業（旧）	2504-041	{"\\u4ed5\\u8a33ID":3050468040,"\\u4ed5\\u8a33\\u756a\\u53f7":5041902,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-041","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":2000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6e21\\u9089\\u3001\\u92e4\\u67c4\\u3001\\u7fbd\\u5730\\u3001\\u91ce\\u7530","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/21 14:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325974
5041905_1	5041905	1	2025-04-19	ブーランジェリーベンケイ長久手店 Freee田中	9140	【事】食材費	BENKEI	消耗食材		パン	子育てに関する相談支援事業（旧）	2504-044	{"\\u4ed5\\u8a33ID":3050508461,"\\u4ed5\\u8a33\\u756a\\u53f7":5041905,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-044","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":9140.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"BENKEI","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"BENKEI","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30d1\\u30f3","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30d6\\u30fc\\u30e9\\u30f3\\u30b8\\u30a7\\u30ea\\u30fc\\u30d9\\u30f3\\u30b1\\u30a4\\u9577\\u4e45\\u624b\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/21 14:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325977
5042101_1	5042101	1	2025-04-21	ウエルシア長久手岩作店 Freee田中	637	【事】食材費	ウエルシア薬局	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-039	{"\\u4ed5\\u8a33ID":3050321477,"\\u4ed5\\u8a33\\u756a\\u53f7":5042101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-039","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":637.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/21 13:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32598
5042102_1	5042102	1	2025-04-21	ﾅｶﾞｸﾃｸﾞﾘ-ﾝｾﾝﾀ- Freee 古賀	896	【事】食材費	JAあいち尾東	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-038	{"\\u4ed5\\u8a33ID":3050323523,"\\u4ed5\\u8a33\\u756a\\u53f7":5042102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-038","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":896.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"JA\\u3042\\u3044\\u3061\\u5c3e\\u6771","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"JA\\u3042\\u3044\\u3061\\u5c3e\\u6771","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff85\\uff76\\uff9e\\uff78\\uff83\\uff78\\uff9e\\uff98-\\uff9d\\uff7e\\uff9d\\uff80- Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/21 13:25","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325984
5042201_1	5042201	1	2025-04-22		500	【事】謝金	ボランティア	謝金ボラ		森川	子育てに関する相談支援事業（旧）	2504-045	{"\\u4ed5\\u8a33ID":3054782955,"\\u4ed5\\u8a33\\u756a\\u53f7":5042201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-045","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/23 17:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.325987
5042202_1	5042202	1	2025-04-22	アミカ Freee 古賀	2056	【事】食材費	アミカ	消耗菓子		駄菓子、コーヒー	子育てに関する相談支援事業（旧）	2504-046	{"\\u4ed5\\u8a33ID":3054802068,"\\u4ed5\\u8a33\\u756a\\u53f7":5042202,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-046","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2056.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u99c4\\u83d3\\u5b50\\u3001\\u30b3\\u30fc\\u30d2\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/23 17:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325991
5042203_1	5042203	1	2025-04-22	アミカ Freee 古賀	16823	【事】食材費	アミカ	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-047	{"\\u4ed5\\u8a33ID":3054804468,"\\u4ed5\\u8a33\\u756a\\u53f7":5042203,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-047","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16823.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/23 17:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.325995
5042204_1	5042204	1	2025-04-22	印刷通販プリントパック Freee バーチャル（ネット用）	2630	【事】印刷製本費	プリントパック	印刷		誕生日カード	子育てに関する相談支援事業（旧）	2504-048	{"\\u4ed5\\u8a33ID":3054831381,"\\u4ed5\\u8a33\\u756a\\u53f7":5042204,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-048","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2630.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8a95\\u751f\\u65e5\\u30ab\\u30fc\\u30c9","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u5370\\u5237\\u901a\\u8ca9\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/23 17:44","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:44"}	2025-07-09 11:23:17.325998
5042301_1	5042301	1	2025-04-23		5000	【管】交際費	利用者			見舞金　山田しょうたさんケガのため	管理部門	2504-061	{"\\u4ed5\\u8a33ID":3059494603,"\\u4ed5\\u8a33\\u756a\\u53f7":5042301,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-061","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u4ea4\\u969b\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5229\\u7528\\u8005","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5229\\u7528\\u8005","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u898b\\u821e\\u91d1\\u3000\\u5c71\\u7530\\u3057\\u3087\\u3046\\u305f\\u3055\\u3093\\u30b1\\u30ac\\u306e\\u305f\\u3081","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 19:21"}	2025-07-09 11:23:17.326001
5042401_1	5042401	1	2025-04-24		7687	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-050	{"\\u4ed5\\u8a33ID":3056010809,"\\u4ed5\\u8a33\\u756a\\u53f7":5042401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-050","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7687.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/24 13:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326004
5042402_1	5042402	1	2025-04-24	アピタ長久手店（専門店） Freee田中	65340	【事】消耗品費	合資会社愛曲楽器	消耗		ハンドベル、スピーカー	子育てに関する相談支援事業（旧）	2504-051	{"\\u4ed5\\u8a33ID":3059464509,"\\u4ed5\\u8a33\\u756a\\u53f7":5042402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-051","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":65340.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5408\\u8cc7\\u4f1a\\u793e\\u611b\\u66f2\\u697d\\u5668","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5408\\u8cc7\\u4f1a\\u793e\\u611b\\u66f2\\u697d\\u5668","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30cf\\u30f3\\u30c9\\u30d9\\u30eb\\u3001\\u30b9\\u30d4\\u30fc\\u30ab\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30d4\\u30bf\\u9577\\u4e45\\u624b\\u5e97\\uff08\\u5c02\\u9580\\u5e97\\uff09 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 14:41","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326006
5043026_1	5043026	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066129949,"\\u4ed5\\u8a33\\u756a\\u53f7":5043026,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:21"}	2025-07-09 11:23:17.326085
5042405_1	5042405	1	2025-04-24	Vデビット　ﾅｺﾞﾔﾌﾟﾛﾊﾟﾝｶﾞｽ　1B114570	8349	【事】水道光熱費	名古屋プロパン瓦斯株式会社	水光			共通部門	2504-067	{"\\u4ed5\\u8a33ID":3066277175,"\\u4ed5\\u8a33\\u756a\\u53f7":5042405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-067","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8349.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u30d7\\u30ed\\u30d1\\u30f3\\u74e6\\u65af\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u30d7\\u30ed\\u30d1\\u30f3\\u74e6\\u65af\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000\\uff85\\uff7a\\uff9e\\uff94\\uff8c\\uff9f\\uff9b\\uff8a\\uff9f\\uff9d\\uff76\\uff9e\\uff7d\\u30001B114570","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 17:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:49"}	2025-07-09 11:23:17.326008
5042501_1	5042501	1	2025-04-25		20711	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-055	{"\\u4ed5\\u8a33ID":3059482067,"\\u4ed5\\u8a33\\u756a\\u53f7":5042501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-055","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/25","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20711.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:05","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32601
5042502_1	5042502	1	2025-04-25		3000	【事】雑費	フトン丸洗い館	その他		カーペット洗濯	子育てに関する相談支援事業（旧）	2504-052	{"\\u4ed5\\u8a33ID":3059484775,"\\u4ed5\\u8a33\\u756a\\u53f7":5042502,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-052","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/25","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d5\\u30c8\\u30f3\\u4e38\\u6d17\\u3044\\u9928","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d5\\u30c8\\u30f3\\u4e38\\u6d17\\u3044\\u9928","\\u501f\\u65b9\\u54c1\\u76ee":"\\u305d\\u306e\\u4ed6","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ab\\u30fc\\u30da\\u30c3\\u30c8\\u6d17\\u6fef","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:09","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:21"}	2025-07-09 11:23:17.326012
5042503_1	5042503	1	2025-04-25		200	【事】雑費	フトン丸洗い館	その他		カーペット洗濯	子育てに関する相談支援事業（旧）	2504-053	{"\\u4ed5\\u8a33ID":3059485104,"\\u4ed5\\u8a33\\u756a\\u53f7":5042503,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-053","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/25","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":200.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d5\\u30c8\\u30f3\\u4e38\\u6d17\\u3044\\u9928","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d5\\u30c8\\u30f3\\u4e38\\u6d17\\u3044\\u9928","\\u501f\\u65b9\\u54c1\\u76ee":"\\u305d\\u306e\\u4ed6","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ab\\u30fc\\u30da\\u30c3\\u30c8\\u6d17\\u6fef","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:21"}	2025-07-09 11:23:17.326014
5042504_1	5042504	1	2025-04-25		100	【事】雑費	フトン丸洗い館	その他		カーペット洗濯	子育てに関する相談支援事業（旧）	2504-054	{"\\u4ed5\\u8a33ID":3059485284,"\\u4ed5\\u8a33\\u756a\\u53f7":5042504,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-054","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/25","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":100.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d5\\u30c8\\u30f3\\u4e38\\u6d17\\u3044\\u9928","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d5\\u30c8\\u30f3\\u4e38\\u6d17\\u3044\\u9928","\\u501f\\u65b9\\u54c1\\u76ee":"\\u305d\\u306e\\u4ed6","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ab\\u30fc\\u30da\\u30c3\\u30c8\\u6d17\\u6fef","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:21"}	2025-07-09 11:23:17.326016
5042505_1	5042505	1	2025-04-25		3500	【事】謝金	ボランティア	謝金ボラ		森川、大谷、佐藤、田中、長谷川、山本、梶田	子育てに関する相談支援事業（旧）	2504-056	{"\\u4ed5\\u8a33ID":3059487775,"\\u4ed5\\u8a33\\u756a\\u53f7":5042505,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-056","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/25","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u5927\\u8c37\\u3001\\u4f50\\u85e4\\u3001\\u7530\\u4e2d\\u3001\\u9577\\u8c37\\u5ddd\\u3001\\u5c71\\u672c\\u3001\\u68b6\\u7530","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326035
5042801_1	5042801	1	2025-04-28		3936	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-063	{"\\u4ed5\\u8a33ID":3061342025,"\\u4ed5\\u8a33\\u756a\\u53f7":5042801,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-063","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3936.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/28 12:34","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32605
5042601_1	5042601	1	2025-04-26	ロイヤルホームセンター長久手 Freee 古賀	2409	【事】消耗品費	ロイヤルホームセンター	消耗	学習支援	ホワイトボード	子育てに関する相談支援事業（旧）	2504-057	{"\\u4ed5\\u8a33ID":3059480956,"\\u4ed5\\u8a33\\u756a\\u53f7":5042601,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-057","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2409.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u5099\\u8003":"\\u30db\\u30ef\\u30a4\\u30c8\\u30dc\\u30fc\\u30c9","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326037
5042602_1	5042602	1	2025-04-26		4089	【事】食材費	LAWSON	消耗食材		おにぎり、パン	子育てに関する相談支援事業（旧）	2504-058	{"\\u4ed5\\u8a33ID":3059486152,"\\u4ed5\\u8a33\\u756a\\u53f7":5042602,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-058","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4089.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LAWSON","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LAWSON","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u306b\\u304e\\u308a\\u3001\\u30d1\\u30f3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326039
5042603_1	5042603	1	2025-04-26		900	【事】旅費交通費	株式会社アイペック	旅費		お誕生日会駐車料金	子育てに関する相談支援事業（旧）	2504-059	{"\\u4ed5\\u8a33ID":3059486346,"\\u4ed5\\u8a33\\u756a\\u53f7":5042603,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-059","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u65c5\\u8cbb\\u4ea4\\u901a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":900.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30a2\\u30a4\\u30da\\u30c3\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30a2\\u30a4\\u30da\\u30c3\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":"\\u65c5\\u8cbb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u8a95\\u751f\\u65e5\\u4f1a\\u99d0\\u8eca\\u6599\\u91d1","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:49"}	2025-07-09 11:23:17.326041
5042604_1	5042604	1	2025-04-26		900	【事】旅費交通費	株式会社アイペック	旅費		お誕生日会駐車料金	子育てに関する相談支援事業（旧）	2504-060	{"\\u4ed5\\u8a33ID":3059486580,"\\u4ed5\\u8a33\\u756a\\u53f7":5042604,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-060","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u65c5\\u8cbb\\u4ea4\\u901a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":900.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30a2\\u30a4\\u30da\\u30c3\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30a2\\u30a4\\u30da\\u30c3\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":"\\u65c5\\u8cbb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u8a95\\u751f\\u65e5\\u4f1a\\u99d0\\u8eca\\u6599\\u91d1","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/26 15:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:49"}	2025-07-09 11:23:17.326044
5042605_1	5042605	1	2025-04-26	Vデビット　L MESSAGE　1A116001	10780	【事】通信運搬費	株式会社ミショナ	LINE			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3061314835,"\\u4ed5\\u8a33\\u756a\\u53f7":5042605,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10780.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30df\\u30b7\\u30e7\\u30ca","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30df\\u30b7\\u30e7\\u30ca","\\u501f\\u65b9\\u54c1\\u76ee":"LINE","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000L MESSAGE\\u30001A116001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/28 12:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326046
5042606_1	5042606	1	2025-04-26		1500	【事】謝金	ボランティア	謝金ボラ	学習支援	鋤柄、野田、三村	子育てに関する相談支援事業（旧）	2504-062	{"\\u4ed5\\u8a33ID":3061340127,"\\u4ed5\\u8a33\\u756a\\u53f7":5042606,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-062","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u5099\\u8003":"\\u92e4\\u67c4\\u3001\\u91ce\\u7530\\u3001\\u4e09\\u6751","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/28 12:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326048
5043025_1	5043025	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066129534,"\\u4ed5\\u8a33\\u756a\\u53f7":5043025,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:20"}	2025-07-09 11:23:17.326083
5042802_1	5042802	1	2025-04-28		530	【管】通信運搬費	日本郵便株式会社	通信		赤い羽根申請書類の郵送　特定記録郵便	管理部門	2504-064	{"\\u4ed5\\u8a33ID":3065877012,"\\u4ed5\\u8a33\\u756a\\u53f7":5042802,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-064","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":530.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8d64\\u3044\\u7fbd\\u6839\\u7533\\u8acb\\u66f8\\u985e\\u306e\\u90f5\\u9001\\u3000\\u7279\\u5b9a\\u8a18\\u9332\\u90f5\\u4fbf","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 15:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 15:20"}	2025-07-09 11:23:17.326053
5042803_1	5042803	1	2025-04-28		2283	【事】食材費	アミカ	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-065	{"\\u4ed5\\u8a33ID":3065881363,"\\u4ed5\\u8a33\\u756a\\u53f7":5042803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-065","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2283.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 15:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326055
5042806_1	5042806	1	2025-04-28	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066121015,"\\u4ed5\\u8a33\\u756a\\u53f7":5042806,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:18","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:18"}	2025-07-09 11:23:17.326057
5042807_1	5042807	1	2025-04-28	ＢＩＧＬＯＢＥ（ＳＭＣＣ	8225	【事】通信運搬費	ビッグローブ株式会社	通信		インターネット	子育てに関する相談支援事業（旧）	2504-049	{"\\u4ed5\\u8a33ID":3066249384,"\\u4ed5\\u8a33\\u756a\\u53f7":5042807,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-049","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8225.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d3\\u30c3\\u30b0\\u30ed\\u30fc\\u30d6\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d3\\u30c3\\u30b0\\u30ed\\u30fc\\u30d6\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30a4\\u30f3\\u30bf\\u30fc\\u30cd\\u30c3\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff22\\uff29\\uff27\\uff2c\\uff2f\\uff22\\uff25\\uff08\\uff33\\uff2d\\uff23\\uff23","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326059
5042808_1	5042808	1	2025-04-28	振込 ミノリトチ　アオヤマ　クニオ	150800	【事】地代家賃	ミノリ土地	家賃		5月分　駐車場代含む	共通部門		{"\\u4ed5\\u8a33ID":3066282174,"\\u4ed5\\u8a33\\u756a\\u53f7":5042808,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5730\\u4ee3\\u5bb6\\u8cc3","\\u501f\\u65b9\\u91d1\\u984d":150800.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30ce\\u30ea\\u571f\\u5730","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30ce\\u30ea\\u571f\\u5730","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5bb6\\u8cc3","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"5\\u6708\\u5206\\u3000\\u99d0\\u8eca\\u5834\\u4ee3\\u542b\\u3080","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30df\\u30ce\\u30ea\\u30c8\\u30c1\\u3000\\u30a2\\u30aa\\u30e4\\u30de\\u3000\\u30af\\u30cb\\u30aa","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 17:03","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:49"}	2025-07-09 11:23:17.326061
5043001_1	5043001	1	2025-04-30		640	【管】通信運搬費	日本郵便株式会社	通信		切手代	管理部門	2504-071	{"\\u4ed5\\u8a33ID":3065745548,"\\u4ed5\\u8a33\\u756a\\u53f7":5043001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-071","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":640.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5207\\u624b\\u4ee3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 14:46","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 15:19"}	2025-07-09 11:23:17.326063
5043003_1	5043003	1	2025-04-30	ＡＴＭ手数料	165	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3065851135,"\\u4ed5\\u8a33\\u756a\\u53f7":5043003,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":165.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff34\\uff2d\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 15:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 15:13"}	2025-07-09 11:23:17.326065
5043005_1	5043005	1	2025-04-30		6482	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2504-066	{"\\u4ed5\\u8a33ID":3065884447,"\\u4ed5\\u8a33\\u756a\\u53f7":5043005,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-066","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6482.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 15:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326067
5043018_1	5043018	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066123113,"\\u4ed5\\u8a33\\u756a\\u53f7":5043018,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:19"}	2025-07-09 11:23:17.326069
5043019_1	5043019	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066123737,"\\u4ed5\\u8a33\\u756a\\u53f7":5043019,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:19"}	2025-07-09 11:23:17.326071
5043020_1	5043020	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066124376,"\\u4ed5\\u8a33\\u756a\\u53f7":5043020,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:19"}	2025-07-09 11:23:17.326073
5043021_1	5043021	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066124913,"\\u4ed5\\u8a33\\u756a\\u53f7":5043021,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:19"}	2025-07-09 11:23:17.326075
5043022_1	5043022	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066125547,"\\u4ed5\\u8a33\\u756a\\u53f7":5043022,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:19"}	2025-07-09 11:23:17.326077
5043023_1	5043023	1	2025-04-30	振込手数料	55	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066126359,"\\u4ed5\\u8a33\\u756a\\u53f7":5043023,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":55.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:20"}	2025-07-09 11:23:17.326079
5043024_1	5043024	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066128245,"\\u4ed5\\u8a33\\u756a\\u53f7":5043024,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:20"}	2025-07-09 11:23:17.326081
5043027_1	5043027	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066130424,"\\u4ed5\\u8a33\\u756a\\u53f7":5043027,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:21"}	2025-07-09 11:23:17.326087
5043028_1	5043028	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066130918,"\\u4ed5\\u8a33\\u756a\\u53f7":5043028,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:21"}	2025-07-09 11:23:17.326089
5043029_1	5043029	1	2025-04-30	振込手数料	55	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066131628,"\\u4ed5\\u8a33\\u756a\\u53f7":5043029,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":55.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:21"}	2025-07-09 11:23:17.326092
5043031_1	5043031	1	2025-04-30	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3066238742,"\\u4ed5\\u8a33\\u756a\\u53f7":5043031,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 16:50","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/04\\/30 16:50"}	2025-07-09 11:23:17.326094
5043033_1	5043033	1	2025-04-30		9877	【事】法定福利費	日本年金機構	健康保険料（事業主負担分）			子育てに関する相談支援事業（旧）	2504-043	{"\\u4ed5\\u8a33ID":3066284768,"\\u4ed5\\u8a33\\u756a\\u53f7":5043033,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-043","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":9877.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5065\\u5eb7\\u4fdd\\u967a\\u6599\\uff08\\u4e8b\\u696d\\u4e3b\\u8ca0\\u62c5\\u5206\\uff09","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 17:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:31"}	2025-07-09 11:23:17.326096
5043033_3	5043033	3	2025-04-30		15555	【事】法定福利費	日本年金機構	厚生年金保険料（事業主負担分）			子育てに関する相談支援事業（旧）	2504-043	{"\\u4ed5\\u8a33ID":3066284768,"\\u4ed5\\u8a33\\u756a\\u53f7":5043033,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":3,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-043","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":15555.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u539a\\u751f\\u5e74\\u91d1\\u4fdd\\u967a\\u6599\\uff08\\u4e8b\\u696d\\u4e3b\\u8ca0\\u62c5\\u5206\\uff09","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 17:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:31"}	2025-07-09 11:23:17.326098
5043033_5	5043033	5	2025-04-30		612	【事】法定福利費	日本年金機構	子ども・子育て拠出金			子育てに関する相談支援事業（旧）	2504-043	{"\\u4ed5\\u8a33ID":3066284768,"\\u4ed5\\u8a33\\u756a\\u53f7":5043033,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":5,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-043","\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":612.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u5b50\\u3069\\u3082\\u30fb\\u5b50\\u80b2\\u3066\\u62e0\\u51fa\\u91d1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/04\\/30 17:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:31"}	2025-07-09 11:23:17.3261
5043035_1	5043035	1	2025-04-30		180000	【事】給与手当	田中直子	給与田中	INGKK2415_利用者	4月分5月払い	共通部門		{"\\u4ed5\\u8a33ID":3068734384,"\\u4ed5\\u8a33\\u756a\\u53f7":5043035,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u7d66\\u4e0e\\u624b\\u5f53","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7530\\u4e2d\\u76f4\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7530\\u4e2d\\u76f4\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u7530\\u4e2d","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":"INGKK2415_\\u5229\\u7528\\u8005","\\u501f\\u65b9\\u5099\\u8003":"4\\u6708\\u52065\\u6708\\u6255\\u3044","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:37"}	2025-07-09 11:23:17.326102
5043036_1	5043036	1	2025-04-30		180000	【事】給与手当	今枝麻里	給与今枝			共通部門		{"\\u4ed5\\u8a33ID":3068735562,"\\u4ed5\\u8a33\\u756a\\u53f7":5043036,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u7d66\\u4e0e\\u624b\\u5f53","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4eca\\u679d\\u9ebb\\u91cc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4eca\\u679d\\u9ebb\\u91cc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u4eca\\u679d","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:32","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:37"}	2025-07-09 11:23:17.326104
5043037_1	5043037	1	2025-04-30		147600	【事】臨時雇用費	古賀めぐみ	給与古賀			共通部門		{"\\u4ed5\\u8a33ID":3068736606,"\\u4ed5\\u8a33\\u756a\\u53f7":5043037,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":147600.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u53e4\\u8cc0","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:32","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326106
5043037_2	5043037	2	2025-04-30		32400	【事】臨時雇用費	古賀めぐみ	給与古賀	JNIPN2419_③支援		共通部門		{"\\u4ed5\\u8a33ID":3068736606,"\\u4ed5\\u8a33\\u756a\\u53f7":5043037,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":2,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":32400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u53e4\\u8cc0","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":"JNIPN2419_\\u2462\\u652f\\u63f4","\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:32","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326108
5043038_1	5043038	1	2025-04-30		55000	【事】臨時雇用費	村里由希	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3068737523,"\\u4ed5\\u8a33\\u756a\\u53f7":5043038,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":55000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6751\\u91cc\\u7531\\u5e0c","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6751\\u91cc\\u7531\\u5e0c","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:32","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.32611
5043039_1	5043039	1	2025-04-30		17280	【事】臨時雇用費	西本和子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3068738408,"\\u4ed5\\u8a33\\u756a\\u53f7":5043039,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":17280.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u897f\\u672c\\u548c\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u897f\\u672c\\u548c\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326112
5043040_1	5043040	1	2025-04-30		43450	【事】臨時雇用費	佐分利麻美	給与佐分利			共通部門		{"\\u4ed5\\u8a33ID":3068739206,"\\u4ed5\\u8a33\\u756a\\u53f7":5043040,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":43450.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f50\\u5206\\u5229\\u9ebb\\u7f8e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f50\\u5206\\u5229\\u9ebb\\u7f8e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u4f50\\u5206\\u5229","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326114
5043041_1	5043041	1	2025-04-30		35200	【事】臨時雇用費	土井容子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3068740537,"\\u4ed5\\u8a33\\u756a\\u53f7":5043041,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":35200.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u571f\\u4e95\\u5bb9\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u571f\\u4e95\\u5bb9\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326116
5043042_1	5043042	1	2025-04-30		28800	【事】臨時雇用費	追立浩貴	給与追立			共通部門		{"\\u4ed5\\u8a33ID":3068743490,"\\u4ed5\\u8a33\\u756a\\u53f7":5043042,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":28800.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8ffd\\u7acb\\u6d69\\u8cb4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8ffd\\u7acb\\u6d69\\u8cb4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u8ffd\\u7acb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:34","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326118
5043043_1	5043043	1	2025-04-30		45360	【事】臨時雇用費	荒木美弥子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3068746439,"\\u4ed5\\u8a33\\u756a\\u53f7":5043043,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":45360.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8352\\u6728\\u7f8e\\u5f25\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8352\\u6728\\u7f8e\\u5f25\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.32612
5043044_1	5043044	1	2025-04-30		26400	【事】臨時雇用費	久野明子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3068748298,"\\u4ed5\\u8a33\\u756a\\u53f7":5043044,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":26400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e45\\u91ce\\u660e\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e45\\u91ce\\u660e\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326122
5043045_1	5043045	1	2025-04-30		66000	【事】臨時雇用費	金澤ひろみ	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3068749185,"\\u4ed5\\u8a33\\u756a\\u53f7":5043045,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":66000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u91d1\\u6fa4\\u3072\\u308d\\u307f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u91d1\\u6fa4\\u3072\\u308d\\u307f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:36","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326124
5043046_1	5043046	1	2025-04-30		99000	【事】臨時雇用費	遠藤百華	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3068751150,"\\u4ed5\\u8a33\\u756a\\u53f7":5043046,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/04\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":99000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9060\\u85e4\\u767e\\u83ef","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9060\\u85e4\\u767e\\u83ef","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 15:36","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326126
5050102_1	5050102	1	2025-05-01	Vデビット　ＬＩＮＥ公式アカウント　1A121001	16500	【事】通信運搬費	LINE株式会社	LINE			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3067611801,"\\u4ed5\\u8a33\\u756a\\u53f7":5050102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"LINE","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000\\uff2c\\uff29\\uff2e\\uff25\\u516c\\u5f0f\\u30a2\\u30ab\\u30a6\\u30f3\\u30c8\\u30001A121001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 10:38","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326128
5050104_1	5050104	1	2025-05-01	ＰＡＹＰＡＹ	234	【管】支払手数料					管理部門		{"\\u4ed5\\u8a33ID":3067617680,"\\u4ed5\\u8a33\\u756a\\u53f7":5050104,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":234.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"paypay\\u652f\\u6255\\u3044","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff30\\uff21\\uff39\\uff30\\uff21\\uff39","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/01 10:40","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 19:25"}	2025-07-09 11:23:17.32613
5050109_1	5050109	1	2025-05-01	ウエルシア長久手岩作店 Freee 今枝	576	【事】食材費	ウエルシア薬局	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-011	{"\\u4ed5\\u8a33ID":3078448198,"\\u4ed5\\u8a33\\u756a\\u53f7":5050109,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-011","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":576.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326132
5050912_1	5050912	1	2025-05-09		434	【事】食材費	Felna	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-020	{"\\u4ed5\\u8a33ID":3085255828,"\\u4ed5\\u8a33\\u756a\\u53f7":5050912,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-020","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":434.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326178
5050110_1	5050110	1	2025-05-01		1770	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-015	{"\\u4ed5\\u8a33ID":3078565803,"\\u4ed5\\u8a33\\u756a\\u53f7":5050110,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-015","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1770.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:46","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326134
5050201_1	5050201	1	2025-05-02	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3078197786,"\\u4ed5\\u8a33\\u756a\\u53f7":5050201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 10:06","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/08 10:26"}	2025-07-09 11:23:17.326136
5050202_1	5050202	1	2025-05-02	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3078199280,"\\u4ed5\\u8a33\\u756a\\u53f7":5050202,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 10:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/08 10:26"}	2025-07-09 11:23:17.326138
5050203_1	5050203	1	2025-05-02	振込 クニナカ　ミサキ	24000	【事】謝金	国仲美早	謝金ボラ			子育てに関する相談支援事業（旧）	2504-068	{"\\u4ed5\\u8a33ID":3078217348,"\\u4ed5\\u8a33\\u756a\\u53f7":5050203,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-068","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":24000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u56fd\\u4ef2\\u7f8e\\u65e9","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u56fd\\u4ef2\\u7f8e\\u65e9","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30af\\u30cb\\u30ca\\u30ab\\u3000\\u30df\\u30b5\\u30ad","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 10:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.32614
5050204_1	5050204	1	2025-05-02	振込 シヤ）シヤカイテキヨウイクチイキシエンネツトワ−ク	2000	【管】諸会費	一般社団法人社会的養育地域支援ネットワーク				管理部門	2505-001	{"\\u4ed5\\u8a33ID":3078230639,"\\u4ed5\\u8a33\\u756a\\u53f7":5050204,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-001","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u8af8\\u4f1a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u793e\\u4f1a\\u7684\\u990a\\u80b2\\u5730\\u57df\\u652f\\u63f4\\u30cd\\u30c3\\u30c8\\u30ef\\u30fc\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u793e\\u4f1a\\u7684\\u990a\\u80b2\\u5730\\u57df\\u652f\\u63f4\\u30cd\\u30c3\\u30c8\\u30ef\\u30fc\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b7\\u30e4\\uff09\\u30b7\\u30e4\\u30ab\\u30a4\\u30c6\\u30ad\\u30e8\\u30a6\\u30a4\\u30af\\u30c1\\u30a4\\u30ad\\u30b7\\u30a8\\u30f3\\u30cd\\u30c4\\u30c8\\u30ef\\u2212\\u30af","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 10:17","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/08 10:19"}	2025-07-09 11:23:17.326142
5050205_1	5050205	1	2025-05-02	イオン長久手 Freee 古賀	10120	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-012	{"\\u4ed5\\u8a33ID":3078443836,"\\u4ed5\\u8a33\\u756a\\u53f7":5050205,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-012","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10120.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326145
5050206_1	5050206	1	2025-05-02		1500	【事】謝金	ボランティア	謝金ボラ		梶田、梅田、橘	子育てに関する相談支援事業（旧）	2505-007	{"\\u4ed5\\u8a33ID":3078468971,"\\u4ed5\\u8a33\\u756a\\u53f7":5050206,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-007","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68b6\\u7530\\u3001\\u6885\\u7530\\u3001\\u6a58","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326147
5050213_1	5050213	1	2025-05-02		14158	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-016	{"\\u4ed5\\u8a33ID":3078567943,"\\u4ed5\\u8a33\\u756a\\u53f7":5050213,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-016","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":14158.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326149
5050301_1	5050301	1	2025-05-03		1771	【事】消耗品費	ジムキング	消耗		幼児教室　手形スタンプ	にこにこ	2505-006	{"\\u4ed5\\u8a33ID":3078459282,"\\u4ed5\\u8a33\\u756a\\u53f7":5050301,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-006","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/03","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1771.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5e7c\\u5150\\u6559\\u5ba4\\u3000\\u624b\\u5f62\\u30b9\\u30bf\\u30f3\\u30d7","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:18","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 19:06"}	2025-07-09 11:23:17.326151
5050501_1	5050501	1	2025-05-05	ADOBE SYSTEMS SOFTWARE Freee バーチャル（ネット用）	3610	【事】通信運搬費	Adobe Systems Software Ireland Ltd	通信			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3078439775,"\\u4ed5\\u8a33\\u756a\\u53f7":5050501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3610.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ADOBE SYSTEMS SOFTWARE Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326153
5050601_1	5050601	1	2025-05-06		320	【管】通信運搬費	ミニストップ	通信		切手	管理部門	2506-028	{"\\u4ed5\\u8a33ID":3147451586,"\\u4ed5\\u8a33\\u756a\\u53f7":5050601,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-028","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/06","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":320.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5207\\u624b","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 17:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/13 17:37"}	2025-07-09 11:23:17.326155
5050701_1	5050701	1	2025-05-07	お菓子のひろば　尾張旭店／ＮＦＣ Freee 今枝	12495	【事】食材費	お菓子のひろば	消耗菓子		駄菓子	子育てに関する相談支援事業（旧）	2505-009	{"\\u4ed5\\u8a33ID":3078397025,"\\u4ed5\\u8a33\\u756a\\u53f7":5050701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-009","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":12495.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u99c4\\u83d3\\u5b50","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070\\u3000\\u5c3e\\u5f35\\u65ed\\u5e97\\uff0f\\uff2e\\uff26\\uff23 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326157
5050702_1	5050702	1	2025-05-07	日本郵便／ＮＦＣ Freee 今枝	2240	【管】通信運搬費	日本郵便株式会社	通信			管理部門	2505-010	{"\\u4ed5\\u8a33ID":3078404688,"\\u4ed5\\u8a33\\u756a\\u53f7":5050702,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-010","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2240.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u65e5\\u672c\\u90f5\\u4fbf\\uff0f\\uff2e\\uff26\\uff23 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:06","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/08 11:07"}	2025-07-09 11:23:17.326159
5050703_1	5050703	1	2025-05-07	イオン長久手 Freee 古賀	5732	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-013	{"\\u4ed5\\u8a33ID":3078422212,"\\u4ed5\\u8a33\\u756a\\u53f7":5050703,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-013","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5732.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326161
5050801_1	5050801	1	2025-05-08	ウエルシア長久手岩作店 Freee田中	1408	【事】食材費	ウエルシア薬局	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-014	{"\\u4ed5\\u8a33ID":3078433291,"\\u4ed5\\u8a33\\u756a\\u53f7":5050801,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-014","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1408.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/08 11:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326163
5050902_1	5050902	1	2025-05-09		3000	【事】謝金	岡田薫	謝金講師		講師謝金	子育てに関する相談支援事業（旧）	2505-022	{"\\u4ed5\\u8a33ID":3085172647,"\\u4ed5\\u8a33\\u756a\\u53f7":5050902,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-022","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5ca1\\u7530\\u85ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5ca1\\u7530\\u85ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8b1b\\u5e2b\\u8b1d\\u91d1","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:18","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326165
5050903_1	5050903	1	2025-05-09		320	【事】印刷製本費	長久手市役所	印刷		ひろば案内、駐車場案内　輪転機コピー	子育てに関する相談支援事業（旧）	2505-021	{"\\u4ed5\\u8a33ID":3085196981,"\\u4ed5\\u8a33\\u756a\\u53f7":5050903,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-021","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":320.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u3072\\u308d\\u3070\\u6848\\u5185\\u3001\\u99d0\\u8eca\\u5834\\u6848\\u5185\\u3000\\u8f2a\\u8ee2\\u6a5f\\u30b3\\u30d4\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:44"}	2025-07-09 11:23:17.326167
5050908_1	5050908	1	2025-05-09		3500	【事】謝金	ボランティア	謝金ボラ		田中、太田、竹内、徳村、柴田、青木、北崎	子育てに関する相談支援事業（旧）	2505-023	{"\\u4ed5\\u8a33ID":3085217738,"\\u4ed5\\u8a33\\u756a\\u53f7":5050908,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-023","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7530\\u4e2d\\u3001\\u592a\\u7530\\u3001\\u7af9\\u5185\\u3001\\u5fb3\\u6751\\u3001\\u67f4\\u7530\\u3001\\u9752\\u6728\\u3001\\u5317\\u5d0e","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:30","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326169
5050909_1	5050909	1	2025-05-09		9155	【事】食材費	Felna	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-017	{"\\u4ed5\\u8a33ID":3085236457,"\\u4ed5\\u8a33\\u756a\\u53f7":5050909,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-017","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":9155.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326171
5050910_1	5050910	1	2025-05-09		22578	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-018	{"\\u4ed5\\u8a33ID":3085251494,"\\u4ed5\\u8a33\\u756a\\u53f7":5050910,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-018","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":22578.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:40","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326174
5050911_1	5050911	1	2025-05-09		5910	【事】食材費	アミカ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-019	{"\\u4ed5\\u8a33ID":3085254184,"\\u4ed5\\u8a33\\u756a\\u53f7":5050911,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-019","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5910.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:41","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326176
5050915_1	5050915	1	2025-05-09	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3085740100,"\\u4ed5\\u8a33\\u756a\\u53f7":5050915,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 14:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/12 14:24"}	2025-07-09 11:23:17.32618
5050916_1	5050916	1	2025-05-09	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3085740917,"\\u4ed5\\u8a33\\u756a\\u53f7":5050916,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 14:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/12 14:23"}	2025-07-09 11:23:17.326182
5050917_1	5050917	1	2025-05-09	振込 ナガクテナツフエスジツコウイインカイ	30000	【管】支払寄付金	ながくて夏フェス実行委員会				管理部門		{"\\u4ed5\\u8a33ID":3085762030,"\\u4ed5\\u8a33\\u756a\\u53f7":5050917,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u5bc4\\u4ed8\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":30000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u306a\\u304c\\u304f\\u3066\\u590f\\u30d5\\u30a7\\u30b9\\u5b9f\\u884c\\u59d4\\u54e1\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u306a\\u304c\\u304f\\u3066\\u590f\\u30d5\\u30a7\\u30b9\\u5b9f\\u884c\\u59d4\\u54e1\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30ca\\u30ac\\u30af\\u30c6\\u30ca\\u30c4\\u30d5\\u30a8\\u30b9\\u30b8\\u30c4\\u30b3\\u30a6\\u30a4\\u30a4\\u30f3\\u30ab\\u30a4","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 14:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/12 14:29"}	2025-07-09 11:23:17.326184
5051001_1	5051001	1	2025-05-10		3000	【事】謝金	ボランティア	謝金ボラ		青木、渡邉、井上、三村、鋤柄、羽地	子育てに関する相談支援事業（旧）	2505-025	{"\\u4ed5\\u8a33ID":3085226237,"\\u4ed5\\u8a33\\u756a\\u53f7":5051001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-025","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9752\\u6728\\u3001\\u6e21\\u9089\\u3001\\u4e95\\u4e0a\\u3001\\u4e09\\u6751\\u3001\\u92e4\\u67c4\\u3001\\u7fbd\\u5730","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326186
5051002_1	5051002	1	2025-05-10		4340	【事】会議費	KOJIMA洋菓子店	会議			子育てに関する相談支援事業（旧）	2505-041	{"\\u4ed5\\u8a33ID":3095757497,"\\u4ed5\\u8a33\\u756a\\u53f7":5051002,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-041","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u4f1a\\u8b70\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4340.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"KOJIMA\\u6d0b\\u83d3\\u5b50\\u5e97","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"KOJIMA\\u6d0b\\u83d3\\u5b50\\u5e97","\\u501f\\u65b9\\u54c1\\u76ee":"\\u4f1a\\u8b70","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/17 13:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:49"}	2025-07-09 11:23:17.326188
5051101_1	5051101	1	2025-05-11		3453	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-024	{"\\u4ed5\\u8a33ID":3085259483,"\\u4ed5\\u8a33\\u756a\\u53f7":5051101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-024","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3453.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32619
5051102_1	5051102	1	2025-05-11	印刷通販プリントパック Freee バーチャル（ネット用）	2130	【事】印刷製本費	プリントパック	印刷		幼児教室にこにこチラシ	子育てに関する相談支援事業（旧）	2505-026	{"\\u4ed5\\u8a33ID":3085266461,"\\u4ed5\\u8a33\\u756a\\u53f7":5051102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-026","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2130.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5e7c\\u5150\\u6559\\u5ba4\\u306b\\u3053\\u306b\\u3053\\u30c1\\u30e9\\u30b7","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u5370\\u5237\\u901a\\u8ca9\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 11:44","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:44"}	2025-07-09 11:23:17.326192
5051202_1	5051202	1	2025-05-12	イオンモール長久手 Freee 古賀	1520	【事】食材費	おかしのまちおか	消耗菓子		駄菓子	子育てに関する相談支援事業（旧）	2504-027	{"\\u4ed5\\u8a33ID":3086013442,"\\u4ed5\\u8a33\\u756a\\u53f7":5051202,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2504-027","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/12","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1520.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u304b\\u3057\\u306e\\u307e\\u3061\\u304a\\u304b","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u304b\\u3057\\u306e\\u307e\\u3061\\u304a\\u304b","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u99c4\\u83d3\\u5b50","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u30e2\\u30fc\\u30eb\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/12 15:44","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326194
5051303_1	5051303	1	2025-05-13	振込手数料	55	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3087598290,"\\u4ed5\\u8a33\\u756a\\u53f7":5051303,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":55.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/13 11:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 13:40"}	2025-07-09 11:23:17.326196
5051305_1	5051305	1	2025-05-13	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3087598980,"\\u4ed5\\u8a33\\u756a\\u53f7":5051305,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/13 11:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 13:39"}	2025-07-09 11:23:17.326198
5051306_1	5051306	1	2025-05-13		3000	【事】謝金	一般社団法人運動習慣推進協会	謝金講師		講師謝金	子育てに関する相談支援事業（旧）	2505-028	{"\\u4ed5\\u8a33ID":3089940617,"\\u4ed5\\u8a33\\u756a\\u53f7":5051306,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-028","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u904b\\u52d5\\u7fd2\\u6163\\u63a8\\u9032\\u5354\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u904b\\u52d5\\u7fd2\\u6163\\u63a8\\u9032\\u5354\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8b1b\\u5e2b\\u8b1d\\u91d1","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/14 13:09","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.3262
5051309_1	5051309	1	2025-05-13	イオン長久手 Freee 古賀	5105	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-029	{"\\u4ed5\\u8a33ID":3089956793,"\\u4ed5\\u8a33\\u756a\\u53f7":5051309,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-029","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5105.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/14 13:17","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326202
5051310_1	5051310	1	2025-05-13	イオン長久手 Freee 古賀	857	【事】食材費	イオンリテール株式会社	消耗食材		おやつ作り材料	子育てに関する相談支援事業（旧）	2505-030	{"\\u4ed5\\u8a33ID":3089959095,"\\u4ed5\\u8a33\\u756a\\u53f7":5051310,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-030","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":857.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u3084\\u3064\\u4f5c\\u308a\\u6750\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/14 13:18","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326204
5051401_1	5051401	1	2025-05-14	ウエルシア長久手岩作店 Freee 今枝	213	【事】食材費	ウエルシア薬局	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-031	{"\\u4ed5\\u8a33ID":3089962785,"\\u4ed5\\u8a33\\u756a\\u53f7":5051401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-031","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":213.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/14 13:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326206
5051402_1	5051402	1	2025-05-14	ウエルシア長久手岩作店 Freee 今枝	530	【事】消耗品費	ウエルシア薬局	消耗		ゴミ袋	子育てに関する相談支援事業（旧）	2505-032	{"\\u4ed5\\u8a33ID":3089969328,"\\u4ed5\\u8a33\\u756a\\u53f7":5051402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-032","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":530.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30b4\\u30df\\u888b","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/14 13:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326208
5051405_1	5051405	1	2025-05-14		1000	【事】雑費				リュネットマルシェ出店料	子育てに関する相談支援事業（旧）	2505-038	{"\\u4ed5\\u8a33ID":3091473183,"\\u4ed5\\u8a33\\u756a\\u53f7":5051405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-038","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ea\\u30e5\\u30cd\\u30c3\\u30c8\\u30de\\u30eb\\u30b7\\u30a7\\u51fa\\u5e97\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 10:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:21"}	2025-07-09 11:23:17.32621
5051408_1	5051408	1	2025-05-14	サイボウズドットコム Freee バーチャル（ネット用）	10890	【事】通信運搬費	サイボウズ株式会社	WEB		キントーン	子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3091510046,"\\u4ed5\\u8a33\\u756a\\u53f7":5051408,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10890.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b5\\u30a4\\u30dc\\u30a6\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b5\\u30a4\\u30dc\\u30a6\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"WEB","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ad\\u30f3\\u30c8\\u30fc\\u30f3","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30b5\\u30a4\\u30dc\\u30a6\\u30ba\\u30c9\\u30c3\\u30c8\\u30b3\\u30e0 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 10:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326212
5051409_1	5051409	1	2025-05-14	サイボウズドットコム Freee バーチャル（ネット用）	10890	【事】通信運搬費	サイボウズ株式会社	WEB		メールワイズ	子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3091511217,"\\u4ed5\\u8a33\\u756a\\u53f7":5051409,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10890.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b5\\u30a4\\u30dc\\u30a6\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b5\\u30a4\\u30dc\\u30a6\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"WEB","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30e1\\u30fc\\u30eb\\u30ef\\u30a4\\u30ba","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30b5\\u30a4\\u30dc\\u30a6\\u30ba\\u30c9\\u30c3\\u30c8\\u30b3\\u30e0 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 10:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326214
5051410_1	5051410	1	2025-05-14	ﾌｱﾐﾘ-ﾏ-ﾄﾅｶﾞｸﾃﾑｻｼﾂﾞｶ Freee 古賀	3074	【事】食材費	FamilyMart	消耗食材		弁当	子育てに関する相談支援事業（旧）	2505-033	{"\\u4ed5\\u8a33ID":3091530865,"\\u4ed5\\u8a33\\u756a\\u53f7":5051410,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-033","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3074.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5f01\\u5f53","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff8c\\uff71\\uff90\\uff98-\\uff8f-\\uff84\\uff85\\uff76\\uff9e\\uff78\\uff83\\uff91\\uff7b\\uff7c\\uff82\\uff9e\\uff76 Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 10:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326217
5051411_1	5051411	1	2025-05-14	シャトレーゼ　長久手店 Freee田中	1479	【事】会議費	シャトレーゼ	会議			子育てに関する相談支援事業（旧）	2505-034	{"\\u4ed5\\u8a33ID":3091548894,"\\u4ed5\\u8a33\\u756a\\u53f7":5051411,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-034","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u4f1a\\u8b70\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1479.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b7\\u30e3\\u30c8\\u30ec\\u30fc\\u30bc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b7\\u30e3\\u30c8\\u30ec\\u30fc\\u30bc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u4f1a\\u8b70","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30b7\\u30e3\\u30c8\\u30ec\\u30fc\\u30bc\\u3000\\u9577\\u4e45\\u624b\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 10:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:49"}	2025-07-09 11:23:17.326219
5051412_1	5051412	1	2025-05-14	ウエルシア長久手岩作店 Freee 今枝	2420	【事】消耗品費	ウエルシア薬局	消耗		食洗機洗剤	子育てに関する相談支援事業（旧）	2505-037	{"\\u4ed5\\u8a33ID":3092204889,"\\u4ed5\\u8a33\\u756a\\u53f7":5051412,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-037","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2420.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6d17\\u6a5f\\u6d17\\u5264","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 14:25","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326221
5051501_1	5051501	1	2025-05-15	ウエルシア長久手岩作店 Freee田中	2479	【事】食材費	ウエルシア薬局	消耗食材		食材　菓子含む	子育てに関する相談支援事業（旧）	2505-035	{"\\u4ed5\\u8a33ID":3091495530,"\\u4ed5\\u8a33\\u756a\\u53f7":5051501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-035","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/15","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2479.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750\\u3000\\u83d3\\u5b50\\u542b\\u3080","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 10:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326223
5051502_1	5051502	1	2025-05-15		8876	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-036	{"\\u4ed5\\u8a33ID":3092210397,"\\u4ed5\\u8a33\\u756a\\u53f7":5051502,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-036","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/15","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8876.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/15 14:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326225
5051603_1	5051603	1	2025-05-16		3000	【事】謝金	ボランティア	謝金ボラ		高柳	子育てに関する相談支援事業（旧）	2505-039	{"\\u4ed5\\u8a33ID":3094320197,"\\u4ed5\\u8a33\\u756a\\u53f7":5051603,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-039","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9ad8\\u67f3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/16 14:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326227
5051604_1	5051604	1	2025-05-16		21103	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-040	{"\\u4ed5\\u8a33ID":3095729851,"\\u4ed5\\u8a33\\u756a\\u53f7":5051604,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-040","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":21103.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/17 13:17","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326229
5051605_1	5051605	1	2025-05-16	ウエルシア長久手岩作店 Freee 今枝	250	【事】消耗品費	ウエルシア薬局	消耗		クッキングシート	子育てに関する相談支援事業（旧）	2505-42	{"\\u4ed5\\u8a33ID":3095747973,"\\u4ed5\\u8a33\\u756a\\u53f7":5051605,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-42","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":250.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30af\\u30c3\\u30ad\\u30f3\\u30b0\\u30b7\\u30fc\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/17 13:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326231
5051606_1	5051606	1	2025-05-16		1500	【事】謝金	ボランティア	謝金ボラ		田中、渡邉、三村	子育てに関する相談支援事業（旧）	2505-044	{"\\u4ed5\\u8a33ID":3095761758,"\\u4ed5\\u8a33\\u756a\\u53f7":5051606,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-044","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7530\\u4e2d\\u3001\\u6e21\\u9089\\u3001\\u4e09\\u6751","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/17 13:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326233
5051701_1	5051701	1	2025-05-17	ミニストップ長久手岩作店 Freee 古賀	3054	【事】食材費	ミニストップ	消耗食材		おにぎり	子育てに関する相談支援事業（旧）	2505-043	{"\\u4ed5\\u8a33ID":3095748715,"\\u4ed5\\u8a33\\u756a\\u53f7":5051701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-043","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3054.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u306b\\u304e\\u308a","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/17 13:34","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326235
5051702_1	5051702	1	2025-05-17		2500	【事】謝金	ボランティア	謝金ボラ		渡邉、井上、野田、羽地、三村	子育てに関する相談支援事業（旧）	2505-045	{"\\u4ed5\\u8a33ID":3095824998,"\\u4ed5\\u8a33\\u756a\\u53f7":5051702,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-045","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":2500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6e21\\u9089\\u3001\\u4e95\\u4e0a\\u3001\\u91ce\\u7530\\u3001\\u7fbd\\u5730\\u3001\\u4e09\\u6751","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/17 14:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326237
5051801_1	5051801	1	2025-05-18	ウエルシア長久手岩作店 Freee 今枝	217	【事】消耗品費	ウエルシア薬局	消耗		培養土	子育てに関する相談支援事業（旧）	2505-049	{"\\u4ed5\\u8a33ID":3098208292,"\\u4ed5\\u8a33\\u756a\\u53f7":5051801,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-049","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":217.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u57f9\\u990a\\u571f","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/19 15:06","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326239
5051802_1	5051802	1	2025-05-18	ADOBE  *ADOBE Freee バーチャル（ネット用）	3828	【事】通信運搬費	Adobe Systems Software Ireland Ltd	通信			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3098213987,"\\u4ed5\\u8a33\\u756a\\u53f7":5051802,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3828.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ADOBE  *ADOBE Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/19 15:08","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326241
5051803_1	5051803	1	2025-05-18		6118	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-048	{"\\u4ed5\\u8a33ID":3098216281,"\\u4ed5\\u8a33\\u756a\\u53f7":5051803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-048","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6118.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/19 15:09","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326243
5051901_1	5051901	1	2025-05-19	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3098205826,"\\u4ed5\\u8a33\\u756a\\u53f7":5051901,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/19 15:05","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/19 15:05"}	2025-07-09 11:23:17.326245
5051903_1	5051903	1	2025-05-19		3230	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-047	{"\\u4ed5\\u8a33ID":3098217465,"\\u4ed5\\u8a33\\u756a\\u53f7":5051903,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-047","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3230.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/19 15:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326247
5051905_1	5051905	1	2025-05-19		3000	【事】謝金	原川千穂	謝金講師			子育てに関する相談支援事業（旧）	2505-046	{"\\u4ed5\\u8a33ID":3098353782,"\\u4ed5\\u8a33\\u756a\\u53f7":5051905,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-046","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u539f\\u5ddd\\u5343\\u7a42","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u539f\\u5ddd\\u5343\\u7a42","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/19 15:52","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326249
5051908_1	5051908	1	2025-05-19	印刷通販プリントパック Freee 今枝	4140	【事】印刷製本費	プリントパック	印刷		おやこ食堂チラシ	子育てに関する相談支援事業（旧）	2505-050	{"\\u4ed5\\u8a33ID":3098383625,"\\u4ed5\\u8a33\\u756a\\u53f7":5051908,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-050","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4140.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u3084\\u3053\\u98df\\u5802\\u30c1\\u30e9\\u30b7","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u5370\\u5237\\u901a\\u8ca9\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/19 16:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:44"}	2025-07-09 11:23:17.326251
5052001_1	5052001	1	2025-05-20	中部電力電気料金	20088	【事】水道光熱費	中部電力ミライズ株式会社	水光		電気代	共通部門	2505-056	{"\\u4ed5\\u8a33ID":3103681950,"\\u4ed5\\u8a33\\u756a\\u53f7":5052001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-056","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20088.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u90e8\\u96fb\\u529b\\u30df\\u30e9\\u30a4\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u90e8\\u96fb\\u529b\\u30df\\u30e9\\u30a4\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u96fb\\u6c17\\u4ee3","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u4e2d\\u90e8\\u96fb\\u529b\\u96fb\\u6c17\\u6599\\u91d1","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 10:40","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:49"}	2025-07-09 11:23:17.326253
5052002_1	5052002	1	2025-05-20	ﾅｶﾞｸﾃｸﾞﾘ-ﾝｾﾝﾀ- Freee 今枝	963	【事】食材費	JAあいち尾東	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-053	{"\\u4ed5\\u8a33ID":3103692698,"\\u4ed5\\u8a33\\u756a\\u53f7":5052002,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-053","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":963.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"JA\\u3042\\u3044\\u3061\\u5c3e\\u6771","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"JA\\u3042\\u3044\\u3061\\u5c3e\\u6771","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff85\\uff76\\uff9e\\uff78\\uff83\\uff78\\uff9e\\uff98-\\uff9d\\uff7e\\uff9d\\uff80- Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 10:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326255
5052003_1	5052003	1	2025-05-20		5000	【事】謝金	鈴木知佳	謝金講師		出張サロン	子育てに関する相談支援事業（旧）	2505-055	{"\\u4ed5\\u8a33ID":3103704463,"\\u4ed5\\u8a33\\u756a\\u53f7":5052003,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-055","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":5000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u51fa\\u5f35\\u30b5\\u30ed\\u30f3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 10:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326257
5052004_1	5052004	1	2025-05-20		500	【事】謝金	ボランティア	謝金ボラ		森川	子育てに関する相談支援事業（旧）	2505-054	{"\\u4ed5\\u8a33ID":3103706641,"\\u4ed5\\u8a33\\u756a\\u53f7":5052004,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-054","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 10:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.32626
5052101_1	5052101	1	2025-05-21	シャトレーゼ　長久手店 Freee田中	2655	【事】会議費	シャトレーゼ	会議			子育てに関する相談支援事業（旧）	2505-52	{"\\u4ed5\\u8a33ID":3103638062,"\\u4ed5\\u8a33\\u756a\\u53f7":5052101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-52","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u4f1a\\u8b70\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2655.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b7\\u30e3\\u30c8\\u30ec\\u30fc\\u30bc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b7\\u30e3\\u30c8\\u30ec\\u30fc\\u30bc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u4f1a\\u8b70","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30b7\\u30e3\\u30c8\\u30ec\\u30fc\\u30bc\\u3000\\u9577\\u4e45\\u624b\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 10:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:49"}	2025-07-09 11:23:17.326262
5052102_1	5052102	1	2025-05-21	イオン長久手 Freee 古賀	10593	【事】食材費	イオンリテール株式会社	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-051	{"\\u4ed5\\u8a33ID":3103643337,"\\u4ed5\\u8a33\\u756a\\u53f7":5052102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-051","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10593.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 10:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326264
5052201_1	5052201	1	2025-05-22	アピタ長久手店＊ Freee 古賀	792	【事】食材費	APITA	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-058	{"\\u4ed5\\u8a33ID":3104322291,"\\u4ed5\\u8a33\\u756a\\u53f7":5052201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-058","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":792.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"APITA","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"APITA","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30d4\\u30bf\\u9577\\u4e45\\u624b\\u5e97\\uff0a Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 14:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326266
5052202_1	5052202	1	2025-05-22		3580	【事】食材費	アヴァンセ	消耗食材		パン	子育てに関する相談支援事業（旧）	2505-059	{"\\u4ed5\\u8a33ID":3104331285,"\\u4ed5\\u8a33\\u756a\\u53f7":5052202,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-059","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3580.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30f4\\u30a1\\u30f3\\u30bb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30f4\\u30a1\\u30f3\\u30bb","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30d1\\u30f3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/22 14:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326268
5052203_1	5052203	1	2025-05-22	ENVATO *70603599 Freee バーチャル（ネット用）	7519	【事】通信運搬費	Envato	通信			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3110519011,"\\u4ed5\\u8a33\\u756a\\u53f7":5052203,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7519.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Envato","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Envato","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ENVATO *70603599 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 16:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.32627
5052301_1	5052301	1	2025-05-23	振込手数料	160	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3110244009,"\\u4ed5\\u8a33\\u756a\\u53f7":5052301,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 13:39"}	2025-07-09 11:23:17.326272
5052302_1	5052302	1	2025-05-23	振込 シイハラ　ミホコ	30000	【事】謝金	椎原美穂子	謝金講師			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3110247202,"\\u4ed5\\u8a33\\u756a\\u53f7":5052302,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":30000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u690e\\u539f\\u7f8e\\u7a42\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u690e\\u539f\\u7f8e\\u7a42\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b7\\u30a4\\u30cf\\u30e9\\u3000\\u30df\\u30db\\u30b3","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326274
5052303_1	5052303	1	2025-05-23	アミカ Freee 古賀	998	【事】消耗品費	アミカ	消耗		割り箸	子育てに関する相談支援事業（旧）	2505-060	{"\\u4ed5\\u8a33ID":3110250237,"\\u4ed5\\u8a33\\u756a\\u53f7":5052303,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-060","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":998.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5272\\u308a\\u7bb8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326276
5052304_1	5052304	1	2025-05-23	アミカ Freee 古賀	8569	【事】食材費	アミカ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-061	{"\\u4ed5\\u8a33ID":3110275678,"\\u4ed5\\u8a33\\u756a\\u53f7":5052304,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-061","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8569.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326278
5052305_1	5052305	1	2025-05-23	ウエルシア長久手岩作店 Freee 今枝	2087	【事】消耗品費	ウエルシア薬局	消耗		オムツ用ゴミ袋	子育てに関する相談支援事業（旧）	2505-062	{"\\u4ed5\\u8a33ID":3110297340,"\\u4ed5\\u8a33\\u756a\\u53f7":5052305,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-062","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2087.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30aa\\u30e0\\u30c4\\u7528\\u30b4\\u30df\\u888b","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:34","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.32628
5052306_1	5052306	1	2025-05-23		18892	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-069	{"\\u4ed5\\u8a33ID":3110356653,"\\u4ed5\\u8a33\\u756a\\u53f7":5052306,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-069","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":18892.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:50","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326282
5052307_1	5052307	1	2025-05-23		11061	【事】食材費	Felna	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-068	{"\\u4ed5\\u8a33ID":3110366159,"\\u4ed5\\u8a33\\u756a\\u53f7":5052307,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-068","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":11061.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326284
5052308_1	5052308	1	2025-05-23		3000	【事】謝金	ボランティア	謝金講師		高柳	子育てに関する相談支援事業（旧）	2505-070	{"\\u4ed5\\u8a33ID":3110372692,"\\u4ed5\\u8a33\\u756a\\u53f7":5052308,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-070","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9ad8\\u67f3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326286
5052309_1	5052309	1	2025-05-23		2500	【事】謝金	ボランティア	謝金ボラ		森川、鈴木、讃井、生田、田中	子育てに関する相談支援事業（旧）	2505-071	{"\\u4ed5\\u8a33ID":3110409749,"\\u4ed5\\u8a33\\u756a\\u53f7":5052309,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-071","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":2500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u9234\\u6728\\u3001\\u8b83\\u4e95\\u3001\\u751f\\u7530\\u3001\\u7530\\u4e2d","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 16:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326288
5052402_1	5052402	1	2025-05-24	ウエルシア長久手岩作店 Freee 今枝	213	【事】食材費	ウエルシア薬局	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-064	{"\\u4ed5\\u8a33ID":3110206019,"\\u4ed5\\u8a33\\u756a\\u53f7":5052402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-064","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":213.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32629
5052404_1	5052404	1	2025-05-24	ウエルシア長久手岩作店 Freee 今枝	1155	【事】食材費	ウエルシア薬局	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-063	{"\\u4ed5\\u8a33ID":3110242918,"\\u4ed5\\u8a33\\u756a\\u53f7":5052404,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-063","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1155.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326292
5052405_1	5052405	1	2025-05-24		3000	【事】謝金	ボランティア	謝金ボラ		渡邊、井上、川合、野田、北崎、青木	子育てに関する相談支援事業（旧）	2505-072	{"\\u4ed5\\u8a33ID":3110380026,"\\u4ed5\\u8a33\\u756a\\u53f7":5052405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-072","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6e21\\u908a\\u3001\\u4e95\\u4e0a\\u3001\\u5ddd\\u5408\\u3001\\u91ce\\u7530\\u3001\\u5317\\u5d0e\\u3001\\u9752\\u6728","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:54","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326294
5052501_1	5052501	1	2025-05-25	Vデビット　ﾅｺﾞﾔﾌﾟﾛﾊﾟﾝｶﾞｽ　1B145403	6395	【事】水道光熱費	名古屋プロパン瓦斯株式会社	水光		ガス代	共通部門	2505-057	{"\\u4ed5\\u8a33ID":3110165355,"\\u4ed5\\u8a33\\u756a\\u53f7":5052501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-057","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/25","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6395.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u30d7\\u30ed\\u30d1\\u30f3\\u74e6\\u65af\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u30d7\\u30ed\\u30d1\\u30f3\\u74e6\\u65af\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ac\\u30b9\\u4ee3","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000\\uff85\\uff7a\\uff9e\\uff94\\uff8c\\uff9f\\uff9b\\uff8a\\uff9f\\uff9d\\uff76\\uff9e\\uff7d\\u30001B145403","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:03","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:49"}	2025-07-09 11:23:17.326296
5052403_1	5052403	1	2025-05-25	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	4950	【事】消耗品費	アマゾンジャパン合同会社	消耗		教師のためのセルフスタディ入門	子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3121674175,"\\u4ed5\\u8a33\\u756a\\u53f7":5052403,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/25","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4950.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6559\\u5e2b\\u306e\\u305f\\u3081\\u306e\\u30bb\\u30eb\\u30d5\\u30b9\\u30bf\\u30c7\\u30a3\\u5165\\u9580","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 15:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326298
5052601_1	5052601	1	2025-05-26	ＢＩＧＬＯＢＥ（ＳＭＣＣ	7909	【事】通信運搬費	ビッグローブ株式会社	通信		インターネット	子育てに関する相談支援事業（旧）	2505-005	{"\\u4ed5\\u8a33ID":3110132054,"\\u4ed5\\u8a33\\u756a\\u53f7":5052601,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-005","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7909.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d3\\u30c3\\u30b0\\u30ed\\u30fc\\u30d6\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d3\\u30c3\\u30b0\\u30ed\\u30fc\\u30d6\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30a4\\u30f3\\u30bf\\u30fc\\u30cd\\u30c3\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff22\\uff29\\uff27\\uff2c\\uff2f\\uff22\\uff25\\uff08\\uff33\\uff2d\\uff23\\uff23","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 14:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.3263
5052602_1	5052602	1	2025-05-26	Vデビット　L MESSAGE　1A146001	10780	【事】通信運搬費	株式会社ミショナ	LINE			子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3110136740,"\\u4ed5\\u8a33\\u756a\\u53f7":5052602,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10780.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30df\\u30b7\\u30e7\\u30ca","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30df\\u30b7\\u30e7\\u30ca","\\u501f\\u65b9\\u54c1\\u76ee":"LINE","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000L MESSAGE\\u30001A146001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 14:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:53"}	2025-07-09 11:23:17.326302
5052603_1	5052603	1	2025-05-26	ﾅｶﾞｸﾃｸﾞﾘ-ﾝｾﾝﾀ- Freee 今枝	480	【事】消耗品費	JAあいち尾東	消耗		肥料	子育てに関する相談支援事業（旧）	2505-066	{"\\u4ed5\\u8a33ID":3110162057,"\\u4ed5\\u8a33\\u756a\\u53f7":5052603,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-066","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":480.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"JA\\u3042\\u3044\\u3061\\u5c3e\\u6771","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"JA\\u3042\\u3044\\u3061\\u5c3e\\u6771","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u80a5\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff85\\uff76\\uff9e\\uff78\\uff83\\uff78\\uff9e\\uff98-\\uff9d\\uff7e\\uff9d\\uff80- Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326304
5052605_1	5052605	1	2025-05-26		8913	【事】食材費	Felna	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-065	{"\\u4ed5\\u8a33ID":3110330182,"\\u4ed5\\u8a33\\u756a\\u53f7":5052605,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-065","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8913.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/26 15:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326307
5052611_1	5052611	1	2025-05-26		640	【管】通信運搬費	日本郵便株式会社	通信		切手	管理部門	2505-076	{"\\u4ed5\\u8a33ID":3120274258,"\\u4ed5\\u8a33\\u756a\\u53f7":5052611,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-076","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":640.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5207\\u624b","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/30 16:42"}	2025-07-09 11:23:17.326308
5052701_1	5052701	1	2025-05-27	アピタ長久手店＊ Freee 今枝	4397	【事】食材費	アピタ	消耗食材		弁当	子育てに関する相談支援事業（旧）	2505-073	{"\\u4ed5\\u8a33ID":3120252496,"\\u4ed5\\u8a33\\u756a\\u53f7":5052701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-073","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4397.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30d4\\u30bf","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30d4\\u30bf","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5f01\\u5f53","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30d4\\u30bf\\u9577\\u4e45\\u624b\\u5e97\\uff0a Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32631
5052801_1	5052801	1	2025-05-28	ロイヤルホームセンター長久手 Freee 今枝	1548	【事】消耗品費	ロイヤルホームセンター	消耗		ゴミ袋、養生テープ	子育てに関する相談支援事業（旧）	2505-074	{"\\u4ed5\\u8a33ID":3120256633,"\\u4ed5\\u8a33\\u756a\\u53f7":5052801,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-074","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1548.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30b4\\u30df\\u888b\\u3001\\u990a\\u751f\\u30c6\\u30fc\\u30d7","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326312
5052802_1	5052802	1	2025-05-28	お菓子のひろば　尾張旭店／ＮＦＣ Freee 今枝	9573	【事】食材費	お菓子のひろば	消耗菓子		駄菓子	子育てに関する相談支援事業（旧）	2505-075	{"\\u4ed5\\u8a33ID":3120261265,"\\u4ed5\\u8a33\\u756a\\u53f7":5052802,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-075","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":9573.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u99c4\\u83d3\\u5b50","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070\\u3000\\u5c3e\\u5f35\\u65ed\\u5e97\\uff0f\\uff2e\\uff26\\uff23 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326315
5053008_1	5053008	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121537799,"\\u4ed5\\u8a33\\u756a\\u53f7":5053008,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 13:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 13:38"}	2025-07-09 11:23:17.326346
5052803_1	5052803	1	2025-05-28		140	【事】印刷製本費	長久手市役所	印刷		出張(東原山)チラシ　輪転機コピー	子育てに関する相談支援事業（旧）	2505-077	{"\\u4ed5\\u8a33ID":3120310085,"\\u4ed5\\u8a33\\u756a\\u53f7":5052803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-077","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":140.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u51fa\\u5f35(\\u6771\\u539f\\u5c71)\\u30c1\\u30e9\\u30b7\\u3000\\u8f2a\\u8ee2\\u6a5f\\u30b3\\u30d4\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:40","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:44"}	2025-07-09 11:23:17.326317
5052804_1	5052804	1	2025-05-28		3557	【事】食材費	ミニストップ	消耗食材		おにぎり　総菜	子育てに関する相談支援事業（旧）	2505-078	{"\\u4ed5\\u8a33ID":3120313633,"\\u4ed5\\u8a33\\u756a\\u53f7":5052804,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-078","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3557.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u306b\\u304e\\u308a\\u3000\\u7dcf\\u83dc","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:41","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326319
5052805_1	5052805	1	2025-05-28		320	【管】通信運搬費	ミニストップ	通信		切手	管理部門	2505-079	{"\\u4ed5\\u8a33ID":3120320470,"\\u4ed5\\u8a33\\u756a\\u53f7":5052805,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-079","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":320.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5207\\u624b","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 19:22"}	2025-07-09 11:23:17.326321
5052806_1	5052806	1	2025-05-28		220	【事】消耗品費	ジムキング	消耗		画用紙　にこにこ	にこにこ	2505-080	{"\\u4ed5\\u8a33ID":3120322930,"\\u4ed5\\u8a33\\u756a\\u53f7":5052806,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-080","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":220.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u753b\\u7528\\u7d19\\u3000\\u306b\\u3053\\u306b\\u3053","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 16:44","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 19:06"}	2025-07-09 11:23:17.326323
5052810_1	5052810	1	2025-05-28	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121572137,"\\u4ed5\\u8a33\\u756a\\u53f7":5052810,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:15"}	2025-07-09 11:23:17.326325
5052812_1	5052812	1	2025-05-28	振込 ミノリトチ　アオヤマ　クニオ	150800	【事】地代家賃	ミノリ土地	家賃		6月分　駐車場代含む	共通部門		{"\\u4ed5\\u8a33ID":3121578768,"\\u4ed5\\u8a33\\u756a\\u53f7":5052812,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5730\\u4ee3\\u5bb6\\u8cc3","\\u501f\\u65b9\\u91d1\\u984d":150800.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30ce\\u30ea\\u571f\\u5730","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30ce\\u30ea\\u571f\\u5730","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5bb6\\u8cc3","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"6\\u6708\\u5206\\u3000\\u99d0\\u8eca\\u5834\\u4ee3\\u542b\\u3080","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30df\\u30ce\\u30ea\\u30c8\\u30c1\\u3000\\u30a2\\u30aa\\u30e4\\u30de\\u3000\\u30af\\u30cb\\u30aa","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:49"}	2025-07-09 11:23:17.326327
5052901_1	5052901	1	2025-05-29		11975	【事】食材費	株式会社タチヤ	消耗食材			子育てに関する相談支援事業（旧）	2505-081	{"\\u4ed5\\u8a33ID":3120481317,"\\u4ed5\\u8a33\\u756a\\u53f7":5052901,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-081","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/29","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":11975.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 17:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326329
5052902_1	5052902	1	2025-05-29	振込 カ）クレンリ−	43197	【事】消耗品費	株式会社　クレンリー	消耗		弁当パック、フタ	子育てに関する相談支援事業（旧）	2505-085	{"\\u4ed5\\u8a33ID":3120581687,"\\u4ed5\\u8a33\\u756a\\u53f7":5052902,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-085","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/29","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":43197.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u3000\\u30af\\u30ec\\u30f3\\u30ea\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u3000\\u30af\\u30ec\\u30f3\\u30ea\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5f01\\u5f53\\u30d1\\u30c3\\u30af\\u3001\\u30d5\\u30bf","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30ab\\uff09\\u30af\\u30ec\\u30f3\\u30ea\\u2212","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 17:52","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 15:55"}	2025-07-09 11:23:17.326332
5052903_1	5052903	1	2025-05-29	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121571907,"\\u4ed5\\u8a33\\u756a\\u53f7":5052903,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/29","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:14"}	2025-07-09 11:23:17.326333
5053003_1	5053003	1	2025-05-30		3000	【事】謝金	鈴木知佳	謝金講師		助産師座談会	子育てに関する相談支援事業（旧）	2505-083	{"\\u4ed5\\u8a33ID":3120469552,"\\u4ed5\\u8a33\\u756a\\u53f7":5053003,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-083","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u52a9\\u7523\\u5e2b\\u5ea7\\u8ac7\\u4f1a","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 17:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326336
5053004_1	5053004	1	2025-05-30		3000	【事】謝金	ボランティア	謝金ボラ		高柳	子育てに関する相談支援事業（旧）	2505-084	{"\\u4ed5\\u8a33ID":3120471214,"\\u4ed5\\u8a33\\u756a\\u53f7":5053004,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-084","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9ad8\\u67f3","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 17:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326338
5053005_1	5053005	1	2025-05-30		19441	【事】食材費	株式会社タチヤ	消耗食材		食材	子育てに関する相談支援事業（旧）	2505-082	{"\\u4ed5\\u8a33ID":3120483167,"\\u4ed5\\u8a33\\u756a\\u53f7":5053005,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-082","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":19441.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/30 17:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.32634
5053006_1	5053006	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121537315,"\\u4ed5\\u8a33\\u756a\\u53f7":5053006,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 13:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 13:38"}	2025-07-09 11:23:17.326342
5053007_1	5053007	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121537637,"\\u4ed5\\u8a33\\u756a\\u53f7":5053007,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 13:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 13:38"}	2025-07-09 11:23:17.326344
5053009_1	5053009	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121537974,"\\u4ed5\\u8a33\\u756a\\u53f7":5053009,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 13:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 13:38"}	2025-07-09 11:23:17.326348
5053013_1	5053013	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121564026,"\\u4ed5\\u8a33\\u756a\\u53f7":5053013,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:07"}	2025-07-09 11:23:17.32635
5053014_1	5053014	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121564181,"\\u4ed5\\u8a33\\u756a\\u53f7":5053014,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:07"}	2025-07-09 11:23:17.326352
5053015_1	5053015	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121564351,"\\u4ed5\\u8a33\\u756a\\u53f7":5053015,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:07"}	2025-07-09 11:23:17.326354
5053016_1	5053016	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121564487,"\\u4ed5\\u8a33\\u756a\\u53f7":5053016,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:07"}	2025-07-09 11:23:17.326356
5053017_1	5053017	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121564643,"\\u4ed5\\u8a33\\u756a\\u53f7":5053017,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:07"}	2025-07-09 11:23:17.326358
5053018_1	5053018	1	2025-05-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121564801,"\\u4ed5\\u8a33\\u756a\\u53f7":5053018,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:08","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 14:08"}	2025-07-09 11:23:17.32636
5053031_1	5053031	1	2025-05-30	ウエルシア長久手岩作店 Freee 今枝	922	【事】食材費	ウエルシア薬局	消耗食材			子育てに関する相談支援事業（旧）	2505-087	{"\\u4ed5\\u8a33ID":3121568576,"\\u4ed5\\u8a33\\u756a\\u53f7":5053031,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-087","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":922.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326362
5053032_1	5053032	1	2025-05-30		3500	【事】謝金	ボランティア	謝金ボラ		森川、梅田、守屋、稲垣、橘、田中、鎌田	子育てに関する相談支援事業（旧）	2505-086	{"\\u4ed5\\u8a33ID":3121590501,"\\u4ed5\\u8a33\\u756a\\u53f7":5053032,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-086","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u6885\\u7530\\u3001\\u5b88\\u5c4b\\u3001\\u7a32\\u57a3\\u3001\\u6a58\\u3001\\u7530\\u4e2d\\u3001\\u938c\\u7530","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:30","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326364
5053101_1	5053101	1	2025-05-31	ミニストップ長久手岩作店 Freee 今枝	3724	【事】食材費	ミニストップ	消耗食材			子育てに関する相談支援事業（旧）	2505-088	{"\\u4ed5\\u8a33ID":3121570818,"\\u4ed5\\u8a33\\u756a\\u53f7":5053101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-088","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3724.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30df\\u30cb\\u30b9\\u30c8\\u30c3\\u30d7\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 14:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:23"}	2025-07-09 11:23:17.326366
5053102_1	5053102	1	2025-05-31	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3121678689,"\\u4ed5\\u8a33\\u756a\\u53f7":5053102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/05\\/31 15:46","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/05\\/31 15:46"}	2025-07-09 11:23:17.326368
5053105_1	5053105	1	2025-05-31	FACEBK *4RGXSQ8NX2 Freee バーチャル（ネット用）	1988	【事】雑費	Facebook	宣伝広告		Facebook広告料金	子育てに関する相談支援事業（旧）		{"\\u4ed5\\u8a33ID":3123402323,"\\u4ed5\\u8a33\\u756a\\u53f7":5053105,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1988.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Facebook","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Facebook","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5ba3\\u4f1d\\u5e83\\u544a","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"Facebook\\u5e83\\u544a\\u6599\\u91d1","\\u53d6\\u5f15\\u5185\\u5bb9":"FACEBK *4RGXSQ8NX2 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 09:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 17:21"}	2025-07-09 11:23:17.32637
5053106_1	5053106	1	2025-05-31		500	【事】謝金	ボランティア	謝金ボラ		羽地	子育てに関する相談支援事業（旧）	2505-089	{"\\u4ed5\\u8a33ID":3123902826,"\\u4ed5\\u8a33\\u756a\\u53f7":5053106,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2505-089","\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b50\\u80b2\\u3066\\u306b\\u95a2\\u3059\\u308b\\u76f8\\u8ac7\\u652f\\u63f4\\u4e8b\\u696d\\uff08\\u65e7\\uff09","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7fbd\\u5730","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:38"}	2025-07-09 11:23:17.326372
5053107_1	5053107	1	2025-05-31		180000	【事】給与手当	田中直子	給与田中		5月分6月払い	共通部門		{"\\u4ed5\\u8a33ID":3124800794,"\\u4ed5\\u8a33\\u756a\\u53f7":5053107,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u7d66\\u4e0e\\u624b\\u5f53","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7530\\u4e2d\\u76f4\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7530\\u4e2d\\u76f4\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u7530\\u4e2d","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"5\\u6708\\u52066\\u6708\\u6255\\u3044","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:46","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:37"}	2025-07-09 11:23:17.326374
5053108_1	5053108	1	2025-05-31		180000	【事】給与手当	今枝麻里	給与今枝			共通部門		{"\\u4ed5\\u8a33ID":3124805601,"\\u4ed5\\u8a33\\u756a\\u53f7":5053108,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u7d66\\u4e0e\\u624b\\u5f53","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4eca\\u679d\\u9ebb\\u91cc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4eca\\u679d\\u9ebb\\u91cc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u4eca\\u679d","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:37"}	2025-07-09 11:23:17.326377
5053109_1	5053109	1	2025-05-31		180000	【事】臨時雇用費	古賀めぐみ	給与古賀			共通部門		{"\\u4ed5\\u8a33ID":3124810405,"\\u4ed5\\u8a33\\u756a\\u53f7":5053109,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u53e4\\u8cc0","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326379
5053110_1	5053110	1	2025-05-31		55000	【事】臨時雇用費	村里由希	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3124812272,"\\u4ed5\\u8a33\\u756a\\u53f7":5053110,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":55000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6751\\u91cc\\u7531\\u5e0c","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6751\\u91cc\\u7531\\u5e0c","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326381
5053111_1	5053111	1	2025-05-31		16740	【事】臨時雇用費	西本和子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3124814451,"\\u4ed5\\u8a33\\u756a\\u53f7":5053111,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16740.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u897f\\u672c\\u548c\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u897f\\u672c\\u548c\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326383
5053112_1	5053112	1	2025-05-31		55550	【事】臨時雇用費	佐分利麻美	給与佐分利			共通部門		{"\\u4ed5\\u8a33ID":3124815914,"\\u4ed5\\u8a33\\u756a\\u53f7":5053112,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":55550.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f50\\u5206\\u5229\\u9ebb\\u7f8e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f50\\u5206\\u5229\\u9ebb\\u7f8e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u4f50\\u5206\\u5229","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326385
5053113_1	5053113	1	2025-05-31		45467	【事】臨時雇用費	土井容子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3124817565,"\\u4ed5\\u8a33\\u756a\\u53f7":5053113,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":45467.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u571f\\u4e95\\u5bb9\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u571f\\u4e95\\u5bb9\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:50","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326387
5053114_1	5053114	1	2025-05-31		22000	【事】臨時雇用費	追立浩貴	給与追立			共通部門		{"\\u4ed5\\u8a33ID":3124819058,"\\u4ed5\\u8a33\\u756a\\u53f7":5053114,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":22000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8ffd\\u7acb\\u6d69\\u8cb4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8ffd\\u7acb\\u6d69\\u8cb4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u8ffd\\u7acb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:50","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326389
5053115_1	5053115	1	2025-05-31		10980	【事】臨時雇用費	荒木美弥子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3124821253,"\\u4ed5\\u8a33\\u756a\\u53f7":5053115,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10980.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8352\\u6728\\u7f8e\\u5f25\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8352\\u6728\\u7f8e\\u5f25\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326391
5053116_1	5053116	1	2025-05-31		15400	【事】臨時雇用費	久野明子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3124822920,"\\u4ed5\\u8a33\\u756a\\u53f7":5053116,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":15400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e45\\u91ce\\u660e\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e45\\u91ce\\u660e\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326393
5053117_1	5053117	1	2025-05-31		46017	【事】臨時雇用費	金澤ひろみ	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3124825663,"\\u4ed5\\u8a33\\u756a\\u53f7":5053117,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":46017.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u91d1\\u6fa4\\u3072\\u308d\\u307f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u91d1\\u6fa4\\u3072\\u308d\\u307f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:52","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326395
5053118_1	5053118	1	2025-05-31		56467	【事】臨時雇用費	遠藤百華	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3124828037,"\\u4ed5\\u8a33\\u756a\\u53f7":5053118,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/05\\/31","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":56467.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9060\\u85e4\\u767e\\u83ef","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9060\\u85e4\\u767e\\u83ef","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/04 19:01"}	2025-07-09 11:23:17.326397
5060101_1	5060101	1	2025-06-01	Vデビット　NPORT　1A152002	11000	【管】消耗品費	税理士法人つばめ			Nport年間利用料	管理部門	2506-004	{"\\u4ed5\\u8a33ID":3123514259,"\\u4ed5\\u8a33\\u756a\\u53f7":5060101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-004","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":11000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7a0e\\u7406\\u58eb\\u6cd5\\u4eba\\u3064\\u3070\\u3081","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7a0e\\u7406\\u58eb\\u6cd5\\u4eba\\u3064\\u3070\\u3081","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"Nport\\u5e74\\u9593\\u5229\\u7528\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000NPORT\\u30001A152002","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 10:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/02 10:24"}	2025-07-09 11:23:17.326399
5060102_1	5060102	1	2025-06-01	ＰＡＹＰＡＹ	524	【管】支払手数料					管理部門		{"\\u4ed5\\u8a33ID":3123519503,"\\u4ed5\\u8a33\\u756a\\u53f7":5060102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":524.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"paypay\\u652f\\u6255\\u3044","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff30\\uff21\\uff39\\uff30\\uff21\\uff39","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 10:25","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/03 13:13"}	2025-07-09 11:23:17.326401
5060104_1	5060104	1	2025-06-01	Vデビット　SB*LINE OFFICIAL ACCOUN　1A152001	16500	【事】通信運搬費	LINE株式会社	LINE			共通部門		{"\\u4ed5\\u8a33ID":3123723061,"\\u4ed5\\u8a33\\u756a\\u53f7":5060104,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"LINE","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000SB*LINE OFFICIAL ACCOUN\\u30001A152001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:02"}	2025-07-09 11:23:17.326403
5060201_1	5060201	1	2025-06-02	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3123508645,"\\u4ed5\\u8a33\\u756a\\u53f7":5060201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 10:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/02 10:22"}	2025-07-09 11:23:17.326405
5060203_1	5060203	1	2025-06-02	振込 クニナカ　ミサキ	18000	【事】謝金	国仲美早	謝金ボラ			ぽんぽん	2506-001	{"\\u4ed5\\u8a33ID":3123528841,"\\u4ed5\\u8a33\\u756a\\u53f7":5060203,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-001","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":18000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u56fd\\u4ef2\\u7f8e\\u65e9","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u56fd\\u4ef2\\u7f8e\\u65e9","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30af\\u30cb\\u30ca\\u30ab\\u3000\\u30df\\u30b5\\u30ad","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 10:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:00"}	2025-07-09 11:23:17.326407
5060204_1	5060204	1	2025-06-02		30793	【管】法定福利費	日本年金機構	健康保険料（事業主負担分）			管理部門		{"\\u4ed5\\u8a33ID":3123695653,"\\u4ed5\\u8a33\\u756a\\u53f7":5060204,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":30793.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5065\\u5eb7\\u4fdd\\u967a\\u6599\\uff08\\u4e8b\\u696d\\u4e3b\\u8ca0\\u62c5\\u5206\\uff09","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 10:47"}	2025-07-09 11:23:17.32641
5060204_3	5060204	3	2025-06-02		48495	【管】法定福利費	日本年金機構	厚生年金保険料（事業主負担分）			管理部門		{"\\u4ed5\\u8a33ID":3123695653,"\\u4ed5\\u8a33\\u756a\\u53f7":5060204,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":3,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":48495.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u539a\\u751f\\u5e74\\u91d1\\u4fdd\\u967a\\u6599\\uff08\\u4e8b\\u696d\\u4e3b\\u8ca0\\u62c5\\u5206\\uff09","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 10:47"}	2025-07-09 11:23:17.326412
5060204_5	5060204	5	2025-06-02		1908	【管】法定福利費	日本年金機構	子ども・子育て拠出金			管理部門		{"\\u4ed5\\u8a33ID":3123695653,"\\u4ed5\\u8a33\\u756a\\u53f7":5060204,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":5,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1908.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u5b50\\u3069\\u3082\\u30fb\\u5b50\\u80b2\\u3066\\u62e0\\u51fa\\u91d1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 10:47"}	2025-07-09 11:23:17.326414
5060206_1	5060206	1	2025-06-02		3000	【事】謝金	高柳公治	謝金ボラ			支援_調理	2506-002	{"\\u4ed5\\u8a33ID":3123916631,"\\u4ed5\\u8a33\\u756a\\u53f7":5060206,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-002","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9ad8\\u67f3\\u516c\\u6cbb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9ad8\\u67f3\\u516c\\u6cbb","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 10:49"}	2025-07-09 11:23:17.326416
5060207_1	5060207	1	2025-06-02		3000	【事】謝金	利光真奈	謝金講師			ぽんぽん	2506-003	{"\\u4ed5\\u8a33ID":3123920675,"\\u4ed5\\u8a33\\u756a\\u53f7":5060207,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-003","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5229\\u5149\\u771f\\u5948","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5229\\u5149\\u771f\\u5948","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:52","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:01"}	2025-07-09 11:23:17.326418
5060208_1	5060208	1	2025-06-02	イオン長久手 Freee 古賀	10874	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-005	{"\\u4ed5\\u8a33ID":3123937575,"\\u4ed5\\u8a33\\u756a\\u53f7":5060208,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-005","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10874.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 11:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:09"}	2025-07-09 11:23:17.32642
5060212_1	5060212	1	2025-06-02	ウエルシア長久手岩作店 Freee 古賀	404	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-009	{"\\u4ed5\\u8a33ID":3124620260,"\\u4ed5\\u8a33\\u756a\\u53f7":5060212,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-009","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":404.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:01","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:10"}	2025-07-09 11:23:17.326423
5060213_1	5060213	1	2025-06-02	ウエルシア長久手岩作店 Freee 古賀	712	【事】消耗品費	ウエルシア薬局	消耗		ドライペット	ぽんぽん	2506-008	{"\\u4ed5\\u8a33ID":3124624697,"\\u4ed5\\u8a33\\u756a\\u53f7":5060213,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-008","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":712.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30c9\\u30e9\\u30a4\\u30da\\u30c3\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:05"}	2025-07-09 11:23:17.326425
5060216_1	5060216	1	2025-06-02		400	【事】雑費				精米機使用料	支援_調理		{"\\u4ed5\\u8a33ID":3124844837,"\\u4ed5\\u8a33\\u756a\\u53f7":5060216,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7cbe\\u7c73\\u6a5f\\u4f7f\\u7528\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/02 15:58","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:08"}	2025-07-09 11:23:17.326427
5060301_1	5060301	1	2025-06-03	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	10890	【事】消耗品費	アマゾンジャパン合同会社	消耗		ムカデ忌避剤	共通部門	2506-010	{"\\u4ed5\\u8a33ID":3128974300,"\\u4ed5\\u8a33\\u756a\\u53f7":5060301,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-010","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/03","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10890.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30e0\\u30ab\\u30c7\\u5fcc\\u907f\\u5264","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/04 11:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:03"}	2025-07-09 11:23:17.326429
5060401_1	5060401	1	2025-06-04	イオン長久手 Freee 古賀	3759	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-015	{"\\u4ed5\\u8a33ID":3134369413,"\\u4ed5\\u8a33\\u756a\\u53f7":5060401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-015","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3759.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 14:59","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 21:01"}	2025-07-09 11:23:17.326431
5060402_1	5060402	1	2025-06-04	イオン長久手 Freee 古賀	2156	【事】消耗品費	イオンリテール株式会社	消耗		タイマー	夕食・放課後・不登校	2506-014	{"\\u4ed5\\u8a33ID":3134373575,"\\u4ed5\\u8a33\\u756a\\u53f7":5060402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-014","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2156.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30bf\\u30a4\\u30de\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:00","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 21:00"}	2025-07-09 11:23:17.326433
5060403_1	5060403	1	2025-06-04	ジムキング　長久手店 Freee 今枝	44	【事】消耗品費	ジムキング	消耗		画用紙	ぽんぽん	2506-011	{"\\u4ed5\\u8a33ID":3134376553,"\\u4ed5\\u8a33\\u756a\\u53f7":5060403,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-011","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":44.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u753b\\u7528\\u7d19","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0\\u3000\\u9577\\u4e45\\u624b\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:00","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 21:00"}	2025-07-09 11:23:17.326435
5060404_1	5060404	1	2025-06-04	ｽ-ﾊﾟ-ﾋﾞﾊﾞﾎ-ﾑ ﾅｶﾞｸﾃﾃﾝ Freee 古賀	4609	【事】消耗品費	ホームセンタースーパービバホーム	消耗		キッチン用品	支援_調理	2506-013	{"\\u4ed5\\u8a33ID":3134381927,"\\u4ed5\\u8a33\\u756a\\u53f7":5060404,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-013","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4609.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u30b9\\u30fc\\u30d1\\u30fc\\u30d3\\u30d0\\u30db\\u30fc\\u30e0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u30b9\\u30fc\\u30d1\\u30fc\\u30d3\\u30d0\\u30db\\u30fc\\u30e0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ad\\u30c3\\u30c1\\u30f3\\u7528\\u54c1","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff7d-\\uff8a\\uff9f-\\uff8b\\uff9e\\uff8a\\uff9e\\uff8e-\\uff91 \\uff85\\uff76\\uff9e\\uff78\\uff83\\uff83\\uff9d Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 21:00"}	2025-07-09 11:23:17.326437
5060405_1	5060405	1	2025-06-04	Vデビット　AMAZON CO JP　1A155001	3780	【事】消耗品費	アマゾンジャパン合同会社	消耗		箸	支援_調理	2506-016	{"\\u4ed5\\u8a33ID":3134424620,"\\u4ed5\\u8a33\\u756a\\u53f7":5060405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-016","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3780.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7bb8","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000AMAZON CO JP\\u30001A155001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 21:00"}	2025-07-09 11:23:17.326439
5070405_1	5070405	1	2025-07-04		7183	【事】食材費	Felna	消耗食材			支援_調理	2507-007	{"\\u4ed5\\u8a33ID":3184915868,"\\u4ed5\\u8a33\\u756a\\u53f7":5070405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-007","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7183.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/04 15:59","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/04 15:59"}	2025-07-09 11:23:17.32678
5060501_1	5060501	1	2025-06-05	イオン長久手 Freee田中	6066	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-012	{"\\u4ed5\\u8a33ID":3134383522,"\\u4ed5\\u8a33\\u756a\\u53f7":5060501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-012","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6066.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:59"}	2025-07-09 11:23:17.326441
5060601_1	5060601	1	2025-06-06		9876	【事】食材費	Felna	消耗食材			支援_調理	2506-017	{"\\u4ed5\\u8a33ID":3134427413,"\\u4ed5\\u8a33\\u756a\\u53f7":5060601,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-017","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/06","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":9876.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:59"}	2025-07-09 11:23:17.326443
5060602_1	5060602	1	2025-06-06		19676	【事】食材費	株式会社タチヤ	消耗食材			支援_調理		{"\\u4ed5\\u8a33ID":3134449404,"\\u4ed5\\u8a33\\u756a\\u53f7":5060602,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/06","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":19676.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:59"}	2025-07-09 11:23:17.326445
5060603_1	5060603	1	2025-06-06	POSIMYTH INNOVATIONS Freee バーチャル（ネット用）	28685	【事】通信運搬費	POSIMYTH Innovations	通信			共通部門	2506-021	{"\\u4ed5\\u8a33ID":3134540488,"\\u4ed5\\u8a33\\u756a\\u53f7":5060603,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-021","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/06","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":28685.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"POSIMYTH Innovations","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"POSIMYTH Innovations","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"POSIMYTH INNOVATIONS Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:59"}	2025-07-09 11:23:17.326447
5060604_1	5060604	1	2025-06-06	ADOBE SYSTEMS SOFTWARE Freee バーチャル（ネット用）	3610	【事】通信運搬費	Adobe Systems Software Ireland Ltd	通信			共通部門		{"\\u4ed5\\u8a33ID":3134541975,"\\u4ed5\\u8a33\\u756a\\u53f7":5060604,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/06","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3610.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ADOBE SYSTEMS SOFTWARE Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/06 15:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:58"}	2025-07-09 11:23:17.326449
5060607_1	5060607	1	2025-06-06		1500	【事】謝金	ボランティア	謝金ボラ		安井、森、田中	夕食・放課後・不登校		{"\\u4ed5\\u8a33ID":3137506710,"\\u4ed5\\u8a33\\u756a\\u53f7":5060607,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/06","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5b89\\u4e95\\u3001\\u68ee\\u3001\\u7530\\u4e2d","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/09 12:59","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:58"}	2025-07-09 11:23:17.326451
5060701_1	5060701	1	2025-06-07	Vデビット　AMAZON CO JP　1A158001	1099	【事】消耗品費	アマゾンジャパン合同会社	消耗		ホワイトボードマーカー	共通部門	2506-029	{"\\u4ed5\\u8a33ID":3148139205,"\\u4ed5\\u8a33\\u756a\\u53f7":5060701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-029","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1099.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30db\\u30ef\\u30a4\\u30c8\\u30dc\\u30fc\\u30c9\\u30de\\u30fc\\u30ab\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000AMAZON CO JP\\u30001A158001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 14:06","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:54"}	2025-07-09 11:23:17.326453
5060801_1	5060801	1	2025-06-08	Vデビット　AMAZON CO JP　1A159001	6200	【事】消耗品費	アマゾンジャパン合同会社	消耗		インクカートリッジ	共通部門	2506-029	{"\\u4ed5\\u8a33ID":3148138769,"\\u4ed5\\u8a33\\u756a\\u53f7":5060801,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-029","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6200.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30a4\\u30f3\\u30af\\u30ab\\u30fc\\u30c8\\u30ea\\u30c3\\u30b8","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000AMAZON CO JP\\u30001A159001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 14:06","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:53"}	2025-07-09 11:23:17.326455
5060901_1	5060901	1	2025-06-09	セリア　アピタ長久手店 Freee 今枝	660	【管】消耗品費	Seria	消耗		プランタースタンド	管理部門	2506-022	{"\\u4ed5\\u8a33ID":3137472744,"\\u4ed5\\u8a33\\u756a\\u53f7":5060901,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-022","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":660.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Seria","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Seria","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30d7\\u30e9\\u30f3\\u30bf\\u30fc\\u30b9\\u30bf\\u30f3\\u30c9","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30bb\\u30ea\\u30a2\\u3000\\u30a2\\u30d4\\u30bf\\u9577\\u4e45\\u624b\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/09 12:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:53"}	2025-07-09 11:23:17.326458
5060902_1	5060902	1	2025-06-09	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3137475928,"\\u4ed5\\u8a33\\u756a\\u53f7":5060902,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/09 12:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/09 12:48"}	2025-07-09 11:23:17.32646
5060904_1	5060904	1	2025-06-09		859	【事】食材費	ウエルシア薬局	消耗食材			支援_パントリー・宅食		{"\\u4ed5\\u8a33ID":3137484534,"\\u4ed5\\u8a33\\u756a\\u53f7":5060904,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":859.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/09 12:50","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:53"}	2025-07-09 11:23:17.326462
5060910_1	5060910	1	2025-06-09	ウエルシア長久手岩作店 Freee 今枝	835	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-026	{"\\u4ed5\\u8a33ID":3137587392,"\\u4ed5\\u8a33\\u756a\\u53f7":5060910,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-026","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":835.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/09 13:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:52"}	2025-07-09 11:23:17.326464
5060911_1	5060911	1	2025-06-09	ウエルシア長久手岩作店 Freee田中	3363	【事】会議費	ウエルシア薬局	消耗菓子			ぽんぽん	2506-025	{"\\u4ed5\\u8a33ID":3137588610,"\\u4ed5\\u8a33\\u756a\\u53f7":5060911,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-025","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u4f1a\\u8b70\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3363.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/09 13:32","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 12:58"}	2025-07-09 11:23:17.326466
5060913_1	5060913	1	2025-06-09		2819	【事】水道光熱費	愛知中部水道企業団	水光			共通部門	2506-044	{"\\u4ed5\\u8a33ID":3148126630,"\\u4ed5\\u8a33\\u756a\\u53f7":5060913,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-044","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2819.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u4e2d\\u90e8\\u6c34\\u9053\\u4f01\\u696d\\u56e3","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u4e2d\\u90e8\\u6c34\\u9053\\u4f01\\u696d\\u56e3","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:51"}	2025-07-09 11:23:17.326468
5060914_1	5060914	1	2025-06-09		2230	【事】消耗品費	ホームセンタースーパービバホーム	消耗		防草シート	ぽんぽん	2506-081	{"\\u4ed5\\u8a33ID":3161642648,"\\u4ed5\\u8a33\\u756a\\u53f7":5060914,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-081","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2230.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u30b9\\u30fc\\u30d1\\u30fc\\u30d3\\u30d0\\u30db\\u30fc\\u30e0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u30b9\\u30fc\\u30d1\\u30fc\\u30d3\\u30d0\\u30db\\u30fc\\u30e0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9632\\u8349\\u30b7\\u30fc\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:32","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:51"}	2025-07-09 11:23:17.32647
5061001_1	5061001	1	2025-06-10		500	【事】謝金	ボランティア	謝金ボラ		森川	支援_調理	2506-030	{"\\u4ed5\\u8a33ID":3147447055,"\\u4ed5\\u8a33\\u756a\\u53f7":5061001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-030","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 17:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:51"}	2025-07-09 11:23:17.326472
5061301_1	5061301	1	2025-06-10		630	【事】印刷製本費	長久手市役所	印刷		無料だがし屋さん＆縁日チラシ　輪転機コピー	地域イベント	2506-036	{"\\u4ed5\\u8a33ID":3147478011,"\\u4ed5\\u8a33\\u756a\\u53f7":5061301,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-036","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":630.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7121\\u6599\\u3060\\u304c\\u3057\\u5c4b\\u3055\\u3093\\uff06\\u7e01\\u65e5\\u30c1\\u30e9\\u30b7\\u3000\\u8f2a\\u8ee2\\u6a5f\\u30b3\\u30d4\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 17:50","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:50"}	2025-07-09 11:23:17.326474
5061003_1	5061003	1	2025-06-10		3000	【事】謝金	一般社団法人運動習慣推進協会	謝金講師			相談支援	2506-031	{"\\u4ed5\\u8a33ID":3147691086,"\\u4ed5\\u8a33\\u756a\\u53f7":5061003,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-031","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u904b\\u52d5\\u7fd2\\u6163\\u63a8\\u9032\\u5354\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u904b\\u52d5\\u7fd2\\u6163\\u63a8\\u9032\\u5354\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u76f8\\u8ac7\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 20:08","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:50"}	2025-07-09 11:23:17.326476
5061004_1	5061004	1	2025-06-10	ウエルシア長久手岩作店 Freee 今枝	547	【事】消耗品費	ウエルシア薬局			コピー用紙	共通部門	2506-035	{"\\u4ed5\\u8a33ID":3147697866,"\\u4ed5\\u8a33\\u756a\\u53f7":5061004,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-035","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":547.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30b3\\u30d4\\u30fc\\u7528\\u7d19","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 20:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:49"}	2025-07-09 11:23:17.326478
5061005_1	5061005	1	2025-06-10	振込 シヤ）ツナグコドモミライ	10000	【事】通信運搬費	一般社団法人つなぐ子ども未来				支援_パントリー・宅食	2506-034	{"\\u4ed5\\u8a33ID":3148115608,"\\u4ed5\\u8a33\\u756a\\u53f7":5061005,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-034","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u3064\\u306a\\u3050\\u5b50\\u3069\\u3082\\u672a\\u6765","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u3064\\u306a\\u3050\\u5b50\\u3069\\u3082\\u672a\\u6765","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b7\\u30e4\\uff09\\u30c4\\u30ca\\u30b0\\u30b3\\u30c9\\u30e2\\u30df\\u30e9\\u30a4","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:49"}	2025-07-09 11:23:17.32648
5061006_1	5061006	1	2025-06-10	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3148117700,"\\u4ed5\\u8a33\\u756a\\u53f7":5061006,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/14 13:31"}	2025-07-09 11:23:17.326482
5061007_1	5061007	1	2025-06-10	振込 エヌピ−オ−ホウジン　コソダテヒロバ　ゼンコクレンラクキヨ	29250	【事】保険料	特定非営利活動法人子育てひろば全国連絡協議会			サイバーリスク保険制度	ぽんぽん		{"\\u4ed5\\u8a33ID":3148118593,"\\u4ed5\\u8a33\\u756a\\u53f7":5061007,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u4fdd\\u967a\\u6599","\\u501f\\u65b9\\u91d1\\u984d":29250.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7279\\u5b9a\\u975e\\u55b6\\u5229\\u6d3b\\u52d5\\u6cd5\\u4eba\\u5b50\\u80b2\\u3066\\u3072\\u308d\\u3070\\u5168\\u56fd\\u9023\\u7d61\\u5354\\u8b70\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7279\\u5b9a\\u975e\\u55b6\\u5229\\u6d3b\\u52d5\\u6cd5\\u4eba\\u5b50\\u80b2\\u3066\\u3072\\u308d\\u3070\\u5168\\u56fd\\u9023\\u7d61\\u5354\\u8b70\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30b5\\u30a4\\u30d0\\u30fc\\u30ea\\u30b9\\u30af\\u4fdd\\u967a\\u5236\\u5ea6","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30a8\\u30cc\\u30d4\\u2212\\u30aa\\u2212\\u30db\\u30a6\\u30b8\\u30f3\\u3000\\u30b3\\u30bd\\u30c0\\u30c6\\u30d2\\u30ed\\u30d0\\u3000\\u30bc\\u30f3\\u30b3\\u30af\\u30ec\\u30f3\\u30e9\\u30af\\u30ad\\u30e8","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:49"}	2025-07-09 11:23:17.326485
5061009_1	5061009	1	2025-06-10	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3148123154,"\\u4ed5\\u8a33\\u756a\\u53f7":5061009,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:41","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:36"}	2025-07-09 11:23:17.326487
5061010_1	5061010	1	2025-06-10		8372	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2506-037	{"\\u4ed5\\u8a33ID":3148128966,"\\u4ed5\\u8a33\\u756a\\u53f7":5061010,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-037","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8372.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:36"}	2025-07-09 11:23:17.326489
5061011_1	5061011	1	2025-06-10	Vデビット　ＡＭＡＺＯＮ．ＣＯ．ＪＰ　1A161001	2130	【事】消耗品費	アマゾンジャパン合同会社	消耗		コピー用紙	共通部門	2506-032	{"\\u4ed5\\u8a33ID":3148136127,"\\u4ed5\\u8a33\\u756a\\u53f7":5061011,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-032","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2130.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30b3\\u30d4\\u30fc\\u7528\\u7d19","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30\\u30001A161001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 14:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:36"}	2025-07-09 11:23:17.326491
5061012_1	5061012	1	2025-06-10	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	1353	【事】消耗品費	アマゾンジャパン合同会社	消耗		オーボール	にこにこ	2506-033	{"\\u4ed5\\u8a33ID":3148137070,"\\u4ed5\\u8a33\\u756a\\u53f7":5061012,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-033","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1353.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30aa\\u30fc\\u30dc\\u30fc\\u30eb","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 14:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 19:07"}	2025-07-09 11:23:17.326493
5061104_1	5061104	1	2025-06-11	アミカ Freee 今枝	1688	【事】食材費	アミカ	消耗食材			支援_調理	2506-039	{"\\u4ed5\\u8a33ID":3148114273,"\\u4ed5\\u8a33\\u756a\\u53f7":5061104,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-039","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1688.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:48"}	2025-07-09 11:23:17.326495
5062009_1	5062009	1	2025-06-20		2000	【事】謝金	ボランティア	謝金ボラ			ぽんぽん	2506-078	{"\\u4ed5\\u8a33ID":3161613813,"\\u4ed5\\u8a33\\u756a\\u53f7":5062009,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-078","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":2000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:22"}	2025-07-09 11:23:17.326572
5061105_1	5061105	1	2025-06-11	お菓子のひろば　尾張旭店 Freee 今枝	28784	【事】食材費	お菓子のひろば	消耗菓子			地域イベント	2506-038	{"\\u4ed5\\u8a33ID":3148115894,"\\u4ed5\\u8a33\\u756a\\u53f7":5061105,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-038","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":28784.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070\\u3000\\u5c3e\\u5f35\\u65ed\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:48"}	2025-07-09 11:23:17.326497
5061302_1	5061302	1	2025-06-13		9080	【事】食材費	Felna	消耗食材		食材	支援_調理	2506-040	{"\\u4ed5\\u8a33ID":3147481958,"\\u4ed5\\u8a33\\u756a\\u53f7":5061302,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-040","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":9080.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6750","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 17:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:47"}	2025-07-09 11:23:17.326499
5061303_1	5061303	1	2025-06-13		1000	【事】謝金	ボランティア	謝金ボラ		森川、田中	ぽんぽん	2506-043	{"\\u4ed5\\u8a33ID":3147489004,"\\u4ed5\\u8a33\\u756a\\u53f7":5061303,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-043","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u7530\\u4e2d","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 17:54","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:47"}	2025-07-09 11:23:17.326501
5061304_1	5061304	1	2025-06-13		3000	【事】謝金	朝岡真実	謝金講師			ぽんぽん	2506-041	{"\\u4ed5\\u8a33ID":3147491540,"\\u4ed5\\u8a33\\u756a\\u53f7":5061304,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-041","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u671d\\u5ca1\\u771f\\u5b9f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u671d\\u5ca1\\u771f\\u5b9f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/13 17:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:01"}	2025-07-09 11:23:17.326503
5061307_1	5061307	1	2025-06-13	ウエルシア長久手岩作店 Freee 今枝	233	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-042	{"\\u4ed5\\u8a33ID":3148113441,"\\u4ed5\\u8a33\\u756a\\u53f7":5061307,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-042","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":233.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:46"}	2025-07-09 11:23:17.326506
5061308_1	5061308	1	2025-06-13		18982	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2506-046	{"\\u4ed5\\u8a33ID":3148128681,"\\u4ed5\\u8a33\\u756a\\u53f7":5061308,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-046","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":18982.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:45"}	2025-07-09 11:23:17.326508
5061319_1	5061319	1	2025-06-13		2700	【事】会議費	KOJIMA洋菓子店	会議			ぽんぽん	2506-047	{"\\u4ed5\\u8a33ID":3148269943,"\\u4ed5\\u8a33\\u756a\\u53f7":5061319,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-047","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/13","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u4f1a\\u8b70\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2700.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"KOJIMA\\u6d0b\\u83d3\\u5b50\\u5e97","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"KOJIMA\\u6d0b\\u83d3\\u5b50\\u5e97","\\u501f\\u65b9\\u54c1\\u76ee":"\\u4f1a\\u8b70","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 16:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:45"}	2025-07-09 11:23:17.32651
5061401_1	5061401	1	2025-06-14	ﾌｱﾐﾘ-ﾏ-ﾄﾋｶﾞｼﾅｶﾞｸﾃ Freee 今枝	6021	【事】食材費	FamilyMart	消耗食材			支援_パントリー・宅食	2506-045	{"\\u4ed5\\u8a33ID":3148112699,"\\u4ed5\\u8a33\\u756a\\u53f7":5061401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-045","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6021.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff8c\\uff71\\uff90\\uff98-\\uff8f-\\uff84\\uff8b\\uff76\\uff9e\\uff7c\\uff85\\uff76\\uff9e\\uff78\\uff83 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 13:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:44"}	2025-07-09 11:23:17.326512
5061403_1	5061403	1	2025-06-14	イオンモール長久手 Freee 今枝	16496	【事】食材費	おかしのまちおか	消耗菓子			地域イベント	2506-050	{"\\u4ed5\\u8a33ID":3148269431,"\\u4ed5\\u8a33\\u756a\\u53f7":5061403,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-050","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16496.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u304b\\u3057\\u306e\\u307e\\u3061\\u304a\\u304b","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u304b\\u3057\\u306e\\u307e\\u3061\\u304a\\u304b","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u30e2\\u30fc\\u30eb\\u9577\\u4e45\\u624b Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 16:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:44"}	2025-07-09 11:23:17.326514
5061404_1	5061404	1	2025-06-14		1430	【事】消耗品費	DAISO	消耗		ペーパーカップ、テープ、ストロー	地域イベント	2506-048	{"\\u4ed5\\u8a33ID":3148270829,"\\u4ed5\\u8a33\\u756a\\u53f7":5061404,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-048","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1430.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30da\\u30fc\\u30d1\\u30fc\\u30ab\\u30c3\\u30d7\\u3001\\u30c6\\u30fc\\u30d7\\u3001\\u30b9\\u30c8\\u30ed\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 16:30","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:43"}	2025-07-09 11:23:17.326516
5061405_1	5061405	1	2025-06-14		1500	【事】謝金	ボランティア	謝金ボラ		野田、羽地、三村	地域イベント		{"\\u4ed5\\u8a33ID":3148273764,"\\u4ed5\\u8a33\\u756a\\u53f7":5061405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u91ce\\u7530\\u3001\\u7fbd\\u5730\\u3001\\u4e09\\u6751","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/14 16:32","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:43"}	2025-07-09 11:23:17.326518
5061611_1	5061611	1	2025-06-16		3000	【事】謝金	ボランティア	謝金ボラ		高栁	支援_調理	2506-055	{"\\u4ed5\\u8a33ID":3152036879,"\\u4ed5\\u8a33\\u756a\\u53f7":5061611,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-055","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9ad8\\u6801","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 12:54","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:41"}	2025-07-09 11:23:17.32652
5061612_1	5061612	1	2025-06-16	イオン長久手 Freee 古賀	11714	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-052	{"\\u4ed5\\u8a33ID":3152044635,"\\u4ed5\\u8a33\\u756a\\u53f7":5061612,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-052","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":11714.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 12:58","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:41"}	2025-07-09 11:23:17.326522
5061613_1	5061613	1	2025-06-16	ウエルシア長久手岩作店 Freee田中	1810	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-053	{"\\u4ed5\\u8a33ID":3152047062,"\\u4ed5\\u8a33\\u756a\\u53f7":5061613,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-053","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1810.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 12:59","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:40"}	2025-07-09 11:23:17.326524
5061614_1	5061614	1	2025-06-16	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	1690	【事】消耗品費	アマゾンジャパン合同会社	消耗		カウンタークロス	支援_調理	2506-056	{"\\u4ed5\\u8a33ID":3152050099,"\\u4ed5\\u8a33\\u756a\\u53f7":5061614,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-056","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1690.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ab\\u30a6\\u30f3\\u30bf\\u30fc\\u30af\\u30ed\\u30b9","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 13:01","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:40"}	2025-07-09 11:23:17.326527
5061615_1	5061615	1	2025-06-16	ウエルシア長久手岩作店 Freee 古賀	539	【事】消耗品費	ウエルシア薬局	消耗		食器用スポンジ	支援_調理	2506-054	{"\\u4ed5\\u8a33ID":3152180740,"\\u4ed5\\u8a33\\u756a\\u53f7":5061615,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-054","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":539.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u5668\\u7528\\u30b9\\u30dd\\u30f3\\u30b8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 13:57","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 11:03"}	2025-07-09 11:23:17.326529
5061619_1	5061619	1	2025-06-16	振込手数料	145	【管】支払手数料		手数			管理部門		{"\\u4ed5\\u8a33ID":3152240000,"\\u4ed5\\u8a33\\u756a\\u53f7":5061619,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/16","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u624b\\u6570","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 14:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:40"}	2025-07-09 11:23:17.326531
5061701_1	5061701	1	2025-06-17		246	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-058	{"\\u4ed5\\u8a33ID":3152038761,"\\u4ed5\\u8a33\\u756a\\u53f7":5061701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-058","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":246.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 12:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:39"}	2025-07-09 11:23:17.326533
5061702_1	5061702	1	2025-06-17	ロイヤルホームセンター長久手 Freee 今枝	238	【事】消耗品費	ロイヤルホームセンター	消耗		S字フック	ぽんぽん	2506-057	{"\\u4ed5\\u8a33ID":3152249106,"\\u4ed5\\u8a33\\u756a\\u53f7":5061702,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-057","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":238.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"S\\u5b57\\u30d5\\u30c3\\u30af","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 14:22","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:39"}	2025-07-09 11:23:17.326535
5061703_1	5061703	1	2025-06-17	アピタ長久手店＊ Freee 古賀	2012	【事】食材費	アピタ	消耗食材			支援_パントリー・宅食	2506-059	{"\\u4ed5\\u8a33ID":3152277626,"\\u4ed5\\u8a33\\u756a\\u53f7":5061703,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-059","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2012.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30d4\\u30bf","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30d4\\u30bf","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30d4\\u30bf\\u9577\\u4e45\\u624b\\u5e97\\uff0a Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 14:30","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:38"}	2025-07-09 11:23:17.326537
5061704_1	5061704	1	2025-06-17	ウエルシア長久手岩作店 Freee 今枝	2129	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-060	{"\\u4ed5\\u8a33ID":3152279930,"\\u4ed5\\u8a33\\u756a\\u53f7":5061704,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-060","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/17","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2129.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/17 14:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:35"}	2025-07-09 11:23:17.326539
5061803_1	5061803	1	2025-06-18	イオン長久手 Freee 古賀	8009	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-064	{"\\u4ed5\\u8a33ID":3157793421,"\\u4ed5\\u8a33\\u756a\\u53f7":5061803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-064","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8009.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:34"}	2025-07-09 11:23:17.326541
5061804_1	5061804	1	2025-06-18	イオン長久手 Freee 古賀	4914	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-063	{"\\u4ed5\\u8a33ID":3157798496,"\\u4ed5\\u8a33\\u756a\\u53f7":5061804,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-063","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4914.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:34"}	2025-07-09 11:23:17.326543
5061805_1	5061805	1	2025-06-18	ウエルシア長久手岩作店 Freee田中	5406	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-061	{"\\u4ed5\\u8a33ID":3157800939,"\\u4ed5\\u8a33\\u756a\\u53f7":5061805,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-061","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5406.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:34"}	2025-07-09 11:23:17.326545
5061806_1	5061806	1	2025-06-18	中部電力電気料金	20730	【事】水道光熱費	中部電力ミライズ株式会社	水光			共通部門	2506-019	{"\\u4ed5\\u8a33ID":3157828263,"\\u4ed5\\u8a33\\u756a\\u53f7":5061806,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-019","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20730.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u90e8\\u96fb\\u529b\\u30df\\u30e9\\u30a4\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u90e8\\u96fb\\u529b\\u30df\\u30e9\\u30a4\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u4e2d\\u90e8\\u96fb\\u529b\\u96fb\\u6c17\\u6599\\u91d1","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:33"}	2025-07-09 11:23:17.326547
5061807_1	5061807	1	2025-06-18	印刷通販プリントパック Freee 今枝	2590	【事】印刷製本費	プリントパック	印刷		誕生会チラシ	地域イベント	2506-065	{"\\u4ed5\\u8a33ID":3157834525,"\\u4ed5\\u8a33\\u756a\\u53f7":5061807,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-065","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2590.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8a95\\u751f\\u4f1a\\u30c1\\u30e9\\u30b7","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u5370\\u5237\\u901a\\u8ca9\\u30d7\\u30ea\\u30f3\\u30c8\\u30d1\\u30c3\\u30af Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:32"}	2025-07-09 11:23:17.326549
5061808_1	5061808	1	2025-06-18	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3157836182,"\\u4ed5\\u8a33\\u756a\\u53f7":5061808,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/20 12:26"}	2025-07-09 11:23:17.326552
5061809_1	5061809	1	2025-06-18	Vデビット　AMAZON CO JP　1A169001	493	【事】消耗品費	アマゾンジャパン合同会社	消耗		カバーテープ	ぽんぽん	2506-066	{"\\u4ed5\\u8a33ID":3157839126,"\\u4ed5\\u8a33\\u756a\\u53f7":5061809,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-066","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":493.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ab\\u30d0\\u30fc\\u30c6\\u30fc\\u30d7","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000AMAZON CO JP\\u30001A169001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:31"}	2025-07-09 11:23:17.326554
5061810_1	5061810	1	2025-06-18	ADOBE  *ADOBE Freee バーチャル（ネット用）	3828	【事】通信運搬費	Adobe Systems Software Ireland Ltd	通信			共通部門		{"\\u4ed5\\u8a33ID":3161683567,"\\u4ed5\\u8a33\\u756a\\u53f7":5061810,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3828.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ADOBE  *ADOBE Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:44","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:31"}	2025-07-09 11:23:17.326556
5061811_1	5061811	1	2025-06-18	振込 ユ）ナガイデザインキカク	17160	【事】消耗品費	有限会社 永井デザイン企画			バナースクリーン	地域イベント	2506-083	{"\\u4ed5\\u8a33ID":3161779566,"\\u4ed5\\u8a33\\u756a\\u53f7":5061811,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-083","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/18","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":17160.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6709\\u9650\\u4f1a\\u793e \\u6c38\\u4e95\\u30c7\\u30b6\\u30a4\\u30f3\\u4f01\\u753b","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6709\\u9650\\u4f1a\\u793e \\u6c38\\u4e95\\u30c7\\u30b6\\u30a4\\u30f3\\u4f01\\u753b","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30d0\\u30ca\\u30fc\\u30b9\\u30af\\u30ea\\u30fc\\u30f3","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30e6\\uff09\\u30ca\\u30ac\\u30a4\\u30c7\\u30b6\\u30a4\\u30f3\\u30ad\\u30ab\\u30af","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 16:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:29"}	2025-07-09 11:23:17.326558
5061903_1	5061903	1	2025-06-19	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	8494	【事】消耗品費	アマゾンジャパン合同会社	消耗		誕生日飾りつけ、ハンドラベラー、レジャーシート	地域イベント	2506-076	{"\\u4ed5\\u8a33ID":3161607077,"\\u4ed5\\u8a33\\u756a\\u53f7":5061903,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-076","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/19","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":8494.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8a95\\u751f\\u65e5\\u98fe\\u308a\\u3064\\u3051\\u3001\\u30cf\\u30f3\\u30c9\\u30e9\\u30d9\\u30e9\\u30fc\\u3001\\u30ec\\u30b8\\u30e3\\u30fc\\u30b7\\u30fc\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:20","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:28"}	2025-07-09 11:23:17.32656
5062001_1	5062001	1	2025-06-20	イオン長久手 Freee 古賀	7377	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-062	{"\\u4ed5\\u8a33ID":3157796119,"\\u4ed5\\u8a33\\u756a\\u53f7":5062001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-062","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7377.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/20 12:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:25"}	2025-07-09 11:23:17.326562
5062002_1	5062002	1	2025-06-20	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3161483618,"\\u4ed5\\u8a33\\u756a\\u53f7":5062002,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 14:35"}	2025-07-09 11:23:17.326564
5062003_1	5062003	1	2025-06-20		5000	【事】謝金	鈴木知佳	謝金講師		預り金あり	相談支援		{"\\u4ed5\\u8a33ID":3161504761,"\\u4ed5\\u8a33\\u756a\\u53f7":5062003,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":5000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u76f8\\u8ac7\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9810\\u308a\\u91d1\\u3042\\u308a","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/04 14:44"}	2025-07-09 11:23:17.326566
5062007_1	5062007	1	2025-06-20	ウエルシア長久手岩作店 Freee 今枝	1300	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-067	{"\\u4ed5\\u8a33ID":3161528365,"\\u4ed5\\u8a33\\u756a\\u53f7":5062007,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-067","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1300.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:23"}	2025-07-09 11:23:17.326568
5062008_1	5062008	1	2025-06-20	振込 カ）クレンリ−	26972	【事】消耗品費	株式会社　クレンリー	消耗		パック	支援_調理	2506-070	{"\\u4ed5\\u8a33ID":3161551276,"\\u4ed5\\u8a33\\u756a\\u53f7":5062008,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-070","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":26972.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u3000\\u30af\\u30ec\\u30f3\\u30ea\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u3000\\u30af\\u30ec\\u30f3\\u30ea\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30d1\\u30c3\\u30af","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30ab\\uff09\\u30af\\u30ec\\u30f3\\u30ea\\u2212","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:57","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:22"}	2025-07-09 11:23:17.32657
5062016_1	5062016	1	2025-06-20		14001	【事】食材費	株式会社タチヤ	消耗食材	古賀立替		支援_調理	2506-080	{"\\u4ed5\\u8a33ID":3161649381,"\\u4ed5\\u8a33\\u756a\\u53f7":5062016,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-080","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/20","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":14001.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":"\\u53e4\\u8cc0\\u7acb\\u66ff","\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:14"}	2025-07-09 11:23:17.326574
5062101_1	5062101	1	2025-06-21	ロイヤルホームセンター長久手 Freee田中	6763	【事】消耗品費	ロイヤルホームセンター	消耗		かき氷機、輪ゴム	夕食・放課後・不登校	2506-068	{"\\u4ed5\\u8a33ID":3161535004,"\\u4ed5\\u8a33\\u756a\\u53f7":5062101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-068","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6763.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304b\\u304d\\u6c37\\u6a5f\\u3001\\u8f2a\\u30b4\\u30e0","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:01"}	2025-07-09 11:23:17.326576
5062102_1	5062102	1	2025-06-21	ﾌｱﾐﾘ-ﾏ-ﾄﾋｶﾞｼﾅｶﾞｸﾃ Freee 今枝	4086	【事】食材費	FamilyMart	消耗食材		パン・おにぎり	支援_パントリー・宅食	2506-069	{"\\u4ed5\\u8a33ID":3161538827,"\\u4ed5\\u8a33\\u756a\\u53f7":5062102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-069","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4086.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30d1\\u30f3\\u30fb\\u304a\\u306b\\u304e\\u308a","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff8c\\uff71\\uff90\\uff98-\\uff8f-\\uff84\\uff8b\\uff76\\uff9e\\uff7c\\uff85\\uff76\\uff9e\\uff78\\uff83 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:52","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:13"}	2025-07-09 11:23:17.326578
5062103_1	5062103	1	2025-06-21		340	【事】印刷製本費	長久手市役所	印刷		だがし縁日チラシ	学習支援	2506-077	{"\\u4ed5\\u8a33ID":3161610984,"\\u4ed5\\u8a33\\u756a\\u53f7":5062103,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-077","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":340.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u3060\\u304c\\u3057\\u7e01\\u65e5\\u30c1\\u30e9\\u30b7","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:11"}	2025-07-09 11:23:17.32658
5062104_1	5062104	1	2025-06-21		3000	【事】謝金	ボランティア	謝金ボラ			学習支援	2506-079	{"\\u4ed5\\u8a33ID":3161615697,"\\u4ed5\\u8a33\\u756a\\u53f7":5062104,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-079","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:10"}	2025-07-09 11:23:17.326582
5062105_1	5062105	1	2025-06-21		213	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2506-093	{"\\u4ed5\\u8a33ID":3169830489,"\\u4ed5\\u8a33\\u756a\\u53f7":5062105,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-093","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/21","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":213.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:25","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:25"}	2025-07-09 11:23:17.326584
5062201_1	5062201	1	2025-06-22		10343	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-082	{"\\u4ed5\\u8a33ID":3161645136,"\\u4ed5\\u8a33\\u756a\\u53f7":5062201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-082","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/22","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10343.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:06"}	2025-07-09 11:23:17.326587
5062301_1	5062301	1	2025-06-23	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3161481514,"\\u4ed5\\u8a33\\u756a\\u53f7":5062301,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:34","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 14:34"}	2025-07-09 11:23:17.326589
5062302_1	5062302	1	2025-06-23	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3161481844,"\\u4ed5\\u8a33\\u756a\\u53f7":5062302,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 14:35"}	2025-07-09 11:23:17.326591
5062303_1	5062303	1	2025-06-23	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3161482250,"\\u4ed5\\u8a33\\u756a\\u53f7":5062303,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 14:35"}	2025-07-09 11:23:17.326593
5062304_1	5062304	1	2025-06-23	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3161482588,"\\u4ed5\\u8a33\\u756a\\u53f7":5062304,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 14:35"}	2025-07-09 11:23:17.326595
5062305_1	5062305	1	2025-06-23	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3161483012,"\\u4ed5\\u8a33\\u756a\\u53f7":5062305,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 14:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 14:35"}	2025-07-09 11:23:17.326597
5062306_1	5062306	1	2025-06-23	振込 スマイルワン（カ	68200	【管】修繕費	住マイルワン株式会社			エアコンクリーニング	管理部門	2506-072	{"\\u4ed5\\u8a33ID":3161565060,"\\u4ed5\\u8a33\\u756a\\u53f7":5062306,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-072","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u4fee\\u7e55\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":68200.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30a8\\u30a2\\u30b3\\u30f3\\u30af\\u30ea\\u30fc\\u30cb\\u30f3\\u30b0","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b9\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\uff08\\u30ab","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:05"}	2025-07-09 11:23:17.326599
5062307_1	5062307	1	2025-06-23	振込 スマイルワン（カ	34100	【管】修繕費	住マイルワン株式会社				管理部門	2506-071	{"\\u4ed5\\u8a33ID":3161567718,"\\u4ed5\\u8a33\\u756a\\u53f7":5062307,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-071","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u4fee\\u7e55\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":34100.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f4f\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b9\\u30de\\u30a4\\u30eb\\u30ef\\u30f3\\uff08\\u30ab","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:05"}	2025-07-09 11:23:17.326601
5062402_1	5062402	1	2025-06-24		500	【事】謝金	ボランティア	謝金ボラ		森川	ぽんぽん	2506-091	{"\\u4ed5\\u8a33ID":3169850853,"\\u4ed5\\u8a33\\u756a\\u53f7":5062402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-091","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:33","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:33"}	2025-07-09 11:23:17.326617
5062308_1	5062308	1	2025-06-23	振込 ナガクテシシヨウコウカイ　カイチヨウ　カワモト　タツシ	7000	【管】諸会費	長久手市商工会				管理部門	2506-073	{"\\u4ed5\\u8a33ID":3161580816,"\\u4ed5\\u8a33\\u756a\\u53f7":5062308,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-073","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u8af8\\u4f1a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5546\\u5de5\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5546\\u5de5\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30ca\\u30ac\\u30af\\u30c6\\u30b7\\u30b7\\u30e8\\u30a6\\u30b3\\u30a6\\u30ab\\u30a4\\u3000\\u30ab\\u30a4\\u30c1\\u30e8\\u30a6\\u3000\\u30ab\\u30ef\\u30e2\\u30c8\\u3000\\u30bf\\u30c4\\u30b7","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:09","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 15:09"}	2025-07-09 11:23:17.326603
5062309_1	5062309	1	2025-06-23	振込 シヤ）ナガクテシカンコウコウリユウキヨ	5000	【管】諸会費	一般社団法人長久手市観光交流協会				管理部門	2506-074	{"\\u4ed5\\u8a33ID":3161586959,"\\u4ed5\\u8a33\\u756a\\u53f7":5062309,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-074","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u8af8\\u4f1a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u9577\\u4e45\\u624b\\u5e02\\u89b3\\u5149\\u4ea4\\u6d41\\u5354\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u9577\\u4e45\\u624b\\u5e02\\u89b3\\u5149\\u4ea4\\u6d41\\u5354\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30b7\\u30e4\\uff09\\u30ca\\u30ac\\u30af\\u30c6\\u30b7\\u30ab\\u30f3\\u30b3\\u30a6\\u30b3\\u30a6\\u30ea\\u30e6\\u30a6\\u30ad\\u30e8","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 15:12"}	2025-07-09 11:23:17.326605
5062310_1	5062310	1	2025-06-23	振込 フク）ナガクテシシヤカイフクシキヨウギカイ　リジチヨウ　カワモト	2855	【管】諸会費	長久手市社会福祉協議会				管理部門	2506-075	{"\\u4ed5\\u8a33ID":3161591498,"\\u4ed5\\u8a33\\u756a\\u53f7":5062310,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-075","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u8af8\\u4f1a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2855.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u793e\\u4f1a\\u798f\\u7949\\u5354\\u8b70\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u793e\\u4f1a\\u798f\\u7949\\u5354\\u8b70\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30d5\\u30af\\uff09\\u30ca\\u30ac\\u30af\\u30c6\\u30b7\\u30b7\\u30e4\\u30ab\\u30a4\\u30d5\\u30af\\u30b7\\u30ad\\u30e8\\u30a6\\u30ae\\u30ab\\u30a4\\u3000\\u30ea\\u30b8\\u30c1\\u30e8\\u30a6\\u3000\\u30ab\\u30ef\\u30e2\\u30c8","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 15:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/23 15:15"}	2025-07-09 11:23:17.326607
5062313_1	5062313	1	2025-06-23		400	【事】雑費				精米機使用料	支援_調理		{"\\u4ed5\\u8a33ID":3161750655,"\\u4ed5\\u8a33\\u756a\\u53f7":5062313,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7cbe\\u7c73\\u6a5f\\u4f7f\\u7528\\u6599","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/23 16:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/26 20:01"}	2025-07-09 11:23:17.326609
5062314_1	5062314	1	2025-06-23		340	【事】印刷製本費	長久手市役所	印刷	WAM2024	だがしチケット	夕食・放課後・不登校	2506-092	{"\\u4ed5\\u8a33ID":3169825594,"\\u4ed5\\u8a33\\u756a\\u53f7":5062314,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-092","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":340.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":"WAM2024","\\u501f\\u65b9\\u5099\\u8003":"\\u3060\\u304c\\u3057\\u30c1\\u30b1\\u30c3\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:23","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:23"}	2025-07-09 11:23:17.326611
5062315_1	5062315	1	2025-06-23		355	【事】食材費	Felna	消耗食材			支援_調理	2506-094	{"\\u4ed5\\u8a33ID":3169831615,"\\u4ed5\\u8a33\\u756a\\u53f7":5062315,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-094","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":355.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:26"}	2025-07-09 11:23:17.326613
5062316_1	5062316	1	2025-06-23	Vデビット　AMAZON CO JP　1A174001	5900	【事】食材費	アマゾンジャパン合同会社	消耗食材		ペットボトルお茶	支援_調理	2506-117	{"\\u4ed5\\u8a33ID":3179635255,"\\u4ed5\\u8a33\\u756a\\u53f7":5062316,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-117","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/23","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5900.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30da\\u30c3\\u30c8\\u30dc\\u30c8\\u30eb\\u304a\\u8336","\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000AMAZON CO JP\\u30001A174001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 13:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 13:55"}	2025-07-09 11:23:17.326615
5062404_1	5062404	1	2025-06-24	振込手数料	145	【管】支払手数料					管理部門		{"\\u4ed5\\u8a33ID":3170631003,"\\u4ed5\\u8a33\\u756a\\u53f7":5062404,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 20:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 20:04"}	2025-07-09 11:23:17.326619
5062405_1	5062405	1	2025-06-24	ウエルシア長久手岩作店 Freee 今枝	1404	【事】食材費	ウエルシア薬局				支援_調理	2506-107	{"\\u4ed5\\u8a33ID":3174700751,"\\u4ed5\\u8a33\\u756a\\u53f7":5062405,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-107","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1404.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:09","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:09"}	2025-07-09 11:23:17.326621
5062406_1	5062406	1	2025-06-24	ウエルシア長久手岩作店 Freee 今枝	2420	【事】消耗品費	ウエルシア薬局	消耗		食洗機洗剤	ぽんぽん	2506-105	{"\\u4ed5\\u8a33ID":3174704427,"\\u4ed5\\u8a33\\u756a\\u53f7":5062406,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-105","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2420.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u98df\\u6d17\\u6a5f\\u6d17\\u5264","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:10"}	2025-07-09 11:23:17.326623
5062407_1	5062407	1	2025-06-24	お菓子のひろば　尾張旭店 Freee 今枝	24341	【事】食材費	お菓子のひろば	消耗菓子			地域イベント	2506-106	{"\\u4ed5\\u8a33ID":3174828224,"\\u4ed5\\u8a33\\u756a\\u53f7":5062407,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-106","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":24341.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u83d3\\u5b50","\\u501f\\u65b9\\u90e8\\u9580":"\\u5730\\u57df\\u30a4\\u30d9\\u30f3\\u30c8","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u304a\\u83d3\\u5b50\\u306e\\u3072\\u308d\\u3070\\u3000\\u5c3e\\u5f35\\u65ed\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:37","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:38"}	2025-07-09 11:23:17.326625
5062408_1	5062408	1	2025-06-24		6497	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2506-114	{"\\u4ed5\\u8a33ID":3174886857,"\\u4ed5\\u8a33\\u756a\\u53f7":5062408,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-114","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6497.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:54"}	2025-07-09 11:23:17.326627
5062409_1	5062409	1	2025-06-24	PE ホウムシヨウ	1340	【管】租税公課	法務省			履歴事項全部証明書	管理部門		{"\\u4ed5\\u8a33ID":3179646519,"\\u4ed5\\u8a33\\u756a\\u53f7":5062409,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u79df\\u7a0e\\u516c\\u8ab2","\\u501f\\u65b9\\u91d1\\u984d":1340.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6cd5\\u52d9\\u7701","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6cd5\\u52d9\\u7701","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u5c65\\u6b74\\u4e8b\\u9805\\u5168\\u90e8\\u8a3c\\u660e\\u66f8","\\u53d6\\u5f15\\u5185\\u5bb9":"PE \\u30db\\u30a6\\u30e0\\u30b7\\u30e8\\u30a6","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 13:58","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 13:58"}	2025-07-09 11:23:17.32663
5062410_1	5062410	1	2025-06-24	ＡＭＡＺＯＮ．ＣＯ．ＪＰ Freee バーチャル（ネット用）	1628	【事】消耗品費	アマゾンジャパン合同会社	消耗		おむつ用ゴミ箱	ぽんぽん	2506-118	{"\\u4ed5\\u8a33ID":3179649761,"\\u4ed5\\u8a33\\u756a\\u53f7":5062410,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-118","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1628.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30de\\u30be\\u30f3\\u30b8\\u30e3\\u30d1\\u30f3\\u5408\\u540c\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u3080\\u3064\\u7528\\u30b4\\u30df\\u7bb1","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff21\\uff2d\\uff21\\uff3a\\uff2f\\uff2e\\uff0e\\uff23\\uff2f\\uff0e\\uff2a\\uff30 Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:00","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:00"}	2025-07-09 11:23:17.326632
5062411_1	5062411	1	2025-06-24		27770	【管】法定福利費	愛知労働局			労災保険	管理部門		{"\\u4ed5\\u8a33ID":3188565694,"\\u4ed5\\u8a33\\u756a\\u53f7":5062411,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":27770.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u52b4\\u50cd\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u52b4\\u50cd\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u52b4\\u707d\\u4fdd\\u967a","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 14:38","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 14:40"}	2025-07-09 11:23:17.326634
5062411_2	5062411	2	2025-06-24		36299	【管】法定福利費	愛知労働局	雇用保険料（事業主負担分）			管理部門		{"\\u4ed5\\u8a33ID":3188565694,"\\u4ed5\\u8a33\\u756a\\u53f7":5062411,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":2,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":36299.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u52b4\\u50cd\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96c7\\u7528\\u4fdd\\u967a\\u6599\\uff08\\u4e8b\\u696d\\u4e3b\\u8ca0\\u62c5\\u5206\\uff09","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 14:38","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 14:40"}	2025-07-09 11:23:17.326636
5062411_3	5062411	3	2025-06-24		168	【管】法定福利費	愛知労働局			一般拠出金	管理部門		{"\\u4ed5\\u8a33ID":3188565694,"\\u4ed5\\u8a33\\u756a\\u53f7":5062411,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":3,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/24","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":168.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u52b4\\u50cd\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u4e00\\u822c\\u62e0\\u51fa\\u91d1","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 14:38","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 14:40"}	2025-07-09 11:23:17.326638
5062601_1	5062601	1	2025-06-26	Vデビット　ﾅｺﾞﾔﾌﾟﾛﾊﾟﾝｶﾞｽ　1B177062	6379	【事】水道光熱費	名古屋プロパン瓦斯株式会社	水光				2506-085	{"\\u4ed5\\u8a33ID":3169805409,"\\u4ed5\\u8a33\\u756a\\u53f7":5062601,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-085","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6c34\\u9053\\u5149\\u71b1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6379.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u30d7\\u30ed\\u30d1\\u30f3\\u74e6\\u65af\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u540d\\u53e4\\u5c4b\\u30d7\\u30ed\\u30d1\\u30f3\\u74e6\\u65af\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6c34\\u5149","\\u501f\\u65b9\\u90e8\\u9580":null,"\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000\\uff85\\uff7a\\uff9e\\uff94\\uff8c\\uff9f\\uff9b\\uff8a\\uff9f\\uff9d\\uff76\\uff9e\\uff7d\\u30001B177062","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:14"}	2025-07-09 11:23:17.32664
5062603_1	5062603	1	2025-06-26		110	【事】消耗品費	Seria	消耗		結束バンド	にこにこ	2506-086	{"\\u4ed5\\u8a33ID":3169836707,"\\u4ed5\\u8a33\\u756a\\u53f7":5062603,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-086","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":110.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Seria","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Seria","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u7d50\\u675f\\u30d0\\u30f3\\u30c9","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:28"}	2025-07-09 11:23:17.326642
5062604_1	5062604	1	2025-06-26		330	【事】消耗品費	DAISO	消耗		ペーパープレート、ワイヤーネット	にこにこ	2506-087	{"\\u4ed5\\u8a33ID":3169841800,"\\u4ed5\\u8a33\\u756a\\u53f7":5062604,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-087","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":330.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"DAISO","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30da\\u30fc\\u30d1\\u30fc\\u30d7\\u30ec\\u30fc\\u30c8\\u3001\\u30ef\\u30a4\\u30e4\\u30fc\\u30cd\\u30c3\\u30c8","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:30","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:30"}	2025-07-09 11:23:17.326644
5062605_1	5062605	1	2025-06-26		500	【事】謝金	ボランティア	謝金ボラ		渡邉	学習支援	2506-090	{"\\u4ed5\\u8a33ID":3169854035,"\\u4ed5\\u8a33\\u756a\\u53f7":5062605,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-090","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6e21\\u9089","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:34","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:34"}	2025-07-09 11:23:17.326646
5062712_1	5062712	1	2025-06-27		6116	【事】食材費	アミカ	消耗食材			支援_調理	2506-100	{"\\u4ed5\\u8a33ID":3174453765,"\\u4ed5\\u8a33\\u756a\\u53f7":5062712,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-100","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6116.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:03"}	2025-07-09 11:23:17.326663
5062606_1	5062606	1	2025-06-26	ｽ-ﾊﾟ-ﾋﾞﾊﾞﾎ-ﾑ ﾅｶﾞｸﾃﾃﾝ Freee 古賀	283	【事】消耗品費	ホームセンタースーパービバホーム	消耗		おりがみ	夕食・放課後・不登校	2506-108	{"\\u4ed5\\u8a33ID":3174693525,"\\u4ed5\\u8a33\\u756a\\u53f7":5062606,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-108","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":283.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u30b9\\u30fc\\u30d1\\u30fc\\u30d3\\u30d0\\u30db\\u30fc\\u30e0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u30b9\\u30fc\\u30d1\\u30fc\\u30d3\\u30d0\\u30db\\u30fc\\u30e0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u308a\\u304c\\u307f","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff7d-\\uff8a\\uff9f-\\uff8b\\uff9e\\uff8a\\uff9e\\uff8e-\\uff91 \\uff85\\uff76\\uff9e\\uff78\\uff83\\uff83\\uff9d Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:07"}	2025-07-09 11:23:17.326648
5062607_1	5062607	1	2025-06-26	ブーランジェリーベンケイ長久手店 Freee田中	5780	【事】食材費	BENKEI	消耗食材			支援_パントリー・宅食	2506-113	{"\\u4ed5\\u8a33ID":3174853557,"\\u4ed5\\u8a33\\u756a\\u53f7":5062607,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-113","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":5780.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"BENKEI","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"BENKEI","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30d6\\u30fc\\u30e9\\u30f3\\u30b8\\u30a7\\u30ea\\u30fc\\u30d9\\u30f3\\u30b1\\u30a4\\u9577\\u4e45\\u624b\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:45"}	2025-07-09 11:23:17.32665
5062608_1	5062608	1	2025-06-26	ＢＩＧＬＯＢＥ（ＳＭＣＣ	7539	【事】通信運搬費	ビッグローブ株式会社	通信			共通部門		{"\\u4ed5\\u8a33ID":3174924435,"\\u4ed5\\u8a33\\u756a\\u53f7":5062608,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7539.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d3\\u30c3\\u30b0\\u30ed\\u30fc\\u30d6\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30d3\\u30c3\\u30b0\\u30ed\\u30fc\\u30d6\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff22\\uff29\\uff27\\uff2c\\uff2f\\uff22\\uff25\\uff08\\uff33\\uff2d\\uff23\\uff23","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:57","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:58"}	2025-07-09 11:23:17.326653
5062609_1	5062609	1	2025-06-26	Vデビット　Ｌ　Ｍｅｓｓａｇｅ　1A177001	10780	【事】通信運搬費	株式会社ミショナ	LINE			共通部門		{"\\u4ed5\\u8a33ID":3179661199,"\\u4ed5\\u8a33\\u756a\\u53f7":5062609,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/26","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":10780.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30df\\u30b7\\u30e7\\u30ca","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30df\\u30b7\\u30e7\\u30ca","\\u501f\\u65b9\\u54c1\\u76ee":"LINE","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000\\uff2c\\u3000\\uff2d\\uff45\\uff53\\uff53\\uff41\\uff47\\uff45\\u30001A177001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:05","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:05"}	2025-07-09 11:23:17.326655
5062701_1	5062701	1	2025-06-27		7753	【事】食材費	Felna	消耗食材			支援_調理	2506-088	{"\\u4ed5\\u8a33ID":3169835252,"\\u4ed5\\u8a33\\u756a\\u53f7":5062701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-088","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7753.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Felna","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:27"}	2025-07-09 11:23:17.326657
5062702_1	5062702	1	2025-06-27		3000	【事】謝金	畑中恭子	謝金講師			ぽんぽん	2506-089	{"\\u4ed5\\u8a33ID":3169855652,"\\u4ed5\\u8a33\\u756a\\u53f7":5062702,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-089","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7551\\u4e2d\\u606d\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7551\\u4e2d\\u606d\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/27 14:35","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/27 14:35"}	2025-07-09 11:23:17.326659
5062707_1	5062707	1	2025-06-27	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174184470,"\\u4ed5\\u8a33\\u756a\\u53f7":5062707,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:16","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:16"}	2025-07-09 11:23:17.326661
5062713_1	5062713	1	2025-06-27		2000	【事】謝金	ボランティア	謝金ボラ		森川、田中、渡邉、前川	夕食・放課後・不登校	2506-104	{"\\u4ed5\\u8a33ID":3174476232,"\\u4ed5\\u8a33\\u756a\\u53f7":5062713,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-104","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":2000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u7530\\u4e2d\\u3001\\u6e21\\u9089\\u3001\\u524d\\u5ddd","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:18","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 15:18"}	2025-07-09 11:23:17.326665
5062714_1	5062714	1	2025-06-27	ウエルシア長久手岩作店 Freee 今枝	283	【事】消耗品費	ウエルシア薬局	消耗		生理用品	ぽんぽん	2506-111	{"\\u4ed5\\u8a33ID":3174659429,"\\u4ed5\\u8a33\\u756a\\u53f7":5062714,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-111","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":283.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u751f\\u7406\\u7528\\u54c1","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:59","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:01"}	2025-07-09 11:23:17.326667
5062715_1	5062715	1	2025-06-27	ロイヤルホームセンター長久手 Freee 今枝	6589	【事】消耗品費	ロイヤルホームセンター	消耗		かき氷機	夕食・放課後・不登校	2506-110	{"\\u4ed5\\u8a33ID":3174674163,"\\u4ed5\\u8a33\\u756a\\u53f7":5062715,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-110","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6589.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304b\\u304d\\u6c37\\u6a5f","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:02"}	2025-07-09 11:23:17.326669
5062716_1	5062716	1	2025-06-27	アミカ Freee 古賀	11166	【事】食材費	アミカ	消耗食材			支援_調理	2506-109	{"\\u4ed5\\u8a33ID":3174681889,"\\u4ed5\\u8a33\\u756a\\u53f7":5062716,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-109","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":11166.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:04"}	2025-07-09 11:23:17.326671
5062717_1	5062717	1	2025-06-27		20527	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2506-115	{"\\u4ed5\\u8a33ID":3174884867,"\\u4ed5\\u8a33\\u756a\\u53f7":5062717,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-115","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20527.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:54"}	2025-07-09 11:23:17.326673
5062718_1	5062718	1	2025-06-27	振込 ミノリトチ　アオヤマ　クニオ	150800	【事】地代家賃	ミノリ土地	家賃		7月分　駐車場代含む	共通部門		{"\\u4ed5\\u8a33ID":3179675643,"\\u4ed5\\u8a33\\u756a\\u53f7":5062718,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/27","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5730\\u4ee3\\u5bb6\\u8cc3","\\u501f\\u65b9\\u91d1\\u984d":150800.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30ce\\u30ea\\u571f\\u5730","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30df\\u30ce\\u30ea\\u571f\\u5730","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5bb6\\u8cc3","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"7\\u6708\\u5206\\u3000\\u99d0\\u8eca\\u5834\\u4ee3\\u542b\\u3080","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30df\\u30ce\\u30ea\\u30c8\\u30c1\\u3000\\u30a2\\u30aa\\u30e4\\u30de\\u3000\\u30af\\u30cb\\u30aa","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:10"}	2025-07-09 11:23:17.326675
5062801_1	5062801	1	2025-06-28		4230	【事】食材費	FamilyMart	消耗食材		だがしや縁日	夕食・放課後・不登校	2506-098	{"\\u4ed5\\u8a33ID":3174403518,"\\u4ed5\\u8a33\\u756a\\u53f7":5062801,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-098","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4230.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u3060\\u304c\\u3057\\u3084\\u7e01\\u65e5","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 15:06"}	2025-07-09 11:23:17.326683
5062802_1	5062802	1	2025-06-28		2023	【事】食材費	FamilyMart	消耗食材		だがしや縁日	夕食・放課後・不登校	2506-097	{"\\u4ed5\\u8a33ID":3174410660,"\\u4ed5\\u8a33\\u756a\\u53f7":5062802,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-097","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2023.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u3060\\u304c\\u3057\\u3084\\u7e01\\u65e5","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:03","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 15:03"}	2025-07-09 11:23:17.326685
5062803_1	5062803	1	2025-06-28		3680	【事】食材費	FamilyMart	消耗食材		だがしや縁日	夕食・放課後・不登校	2506-096	{"\\u4ed5\\u8a33ID":3174416061,"\\u4ed5\\u8a33\\u756a\\u53f7":5062803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-096","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3680.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"FamilyMart","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u3060\\u304c\\u3057\\u3084\\u7e01\\u65e5","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 15:04"}	2025-07-09 11:23:17.326687
5062804_1	5062804	1	2025-06-28		3000	【事】謝金	ボランティア	謝金ボラ		青木、鋤柄、北﨑、羽地、野田、北澤	夕食・放課後・不登校	2506-103	{"\\u4ed5\\u8a33ID":3174488730,"\\u4ed5\\u8a33\\u756a\\u53f7":5062804,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-103","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/28","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u9752\\u6728\\u3001\\u92e4\\u67c4\\u3001\\u5317\\ufa11\\u3001\\u7fbd\\u5730\\u3001\\u91ce\\u7530\\u3001\\u5317\\u6fa4","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 15:21"}	2025-07-09 11:23:17.326689
5062901_1	5062901	1	2025-06-29		2818	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2506-099	{"\\u4ed5\\u8a33ID":3174451593,"\\u4ed5\\u8a33\\u756a\\u53f7":5062901,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-099","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/29","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2818.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:13","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:03"}	2025-07-09 11:23:17.326691
5062902_1	5062902	1	2025-06-29		539	【事】消耗品費	ジムキング	消耗			にこにこ	2506-101	{"\\u4ed5\\u8a33ID":3174456716,"\\u4ed5\\u8a33\\u756a\\u53f7":5062902,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-101","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/29","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":539.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:14","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 15:14"}	2025-07-09 11:23:17.326693
5062903_1	5062903	1	2025-06-29		278	【事】消耗品費	ジムキング	消耗			にこにこ	2506-102	{"\\u4ed5\\u8a33ID":3174457987,"\\u4ed5\\u8a33\\u756a\\u53f7":5062903,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-102","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/29","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":278.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30b8\\u30e0\\u30ad\\u30f3\\u30b0","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:15","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 15:15"}	2025-07-09 11:23:17.326695
5063001_1	5063001	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174160579,"\\u4ed5\\u8a33\\u756a\\u53f7":5063001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:10"}	2025-07-09 11:23:17.326697
5063002_1	5063002	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174161311,"\\u4ed5\\u8a33\\u756a\\u53f7":5063002,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:10"}	2025-07-09 11:23:17.326699
5063003_1	5063003	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174161977,"\\u4ed5\\u8a33\\u756a\\u53f7":5063003,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:11"}	2025-07-09 11:23:17.326701
5063004_1	5063004	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174162700,"\\u4ed5\\u8a33\\u756a\\u53f7":5063004,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:11"}	2025-07-09 11:23:17.326703
5063005_1	5063005	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174163262,"\\u4ed5\\u8a33\\u756a\\u53f7":5063005,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:11"}	2025-07-09 11:23:17.326705
5063006_1	5063006	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174164185,"\\u4ed5\\u8a33\\u756a\\u53f7":5063006,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:11"}	2025-07-09 11:23:17.326707
5063007_1	5063007	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174164837,"\\u4ed5\\u8a33\\u756a\\u53f7":5063007,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:11"}	2025-07-09 11:23:17.326709
5063008_1	5063008	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174165497,"\\u4ed5\\u8a33\\u756a\\u53f7":5063008,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:12"}	2025-07-09 11:23:17.326711
5063009_1	5063009	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174166182,"\\u4ed5\\u8a33\\u756a\\u53f7":5063009,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:12"}	2025-07-09 11:23:17.326714
5063010_1	5063010	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174166967,"\\u4ed5\\u8a33\\u756a\\u53f7":5063010,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:12"}	2025-07-09 11:23:17.326716
5063023_1	5063023	1	2025-06-30		30793	【管】法定福利費	日本年金機構	健康保険料（事業主負担分）			管理部門		{"\\u4ed5\\u8a33ID":3174198735,"\\u4ed5\\u8a33\\u756a\\u53f7":5063023,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":30793.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5065\\u5eb7\\u4fdd\\u967a\\u6599\\uff08\\u4e8b\\u696d\\u4e3b\\u8ca0\\u62c5\\u5206\\uff09","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:19"}	2025-07-09 11:23:17.326718
5063023_3	5063023	3	2025-06-30		48495	【管】法定福利費	日本年金機構	厚生年金保険料（事業主負担分）			管理部門		{"\\u4ed5\\u8a33ID":3174198735,"\\u4ed5\\u8a33\\u756a\\u53f7":5063023,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":3,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":48495.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u539a\\u751f\\u5e74\\u91d1\\u4fdd\\u967a\\u6599\\uff08\\u4e8b\\u696d\\u4e3b\\u8ca0\\u62c5\\u5206\\uff09","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:19"}	2025-07-09 11:23:17.32672
5063023_5	5063023	5	2025-06-30		1908	【管】法定福利費	日本年金機構	子ども・子育て拠出金			管理部門		{"\\u4ed5\\u8a33ID":3174198735,"\\u4ed5\\u8a33\\u756a\\u53f7":5063023,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":5,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u6cd5\\u5b9a\\u798f\\u5229\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1908.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u5e74\\u91d1\\u6a5f\\u69cb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u5b50\\u3069\\u3082\\u30fb\\u5b50\\u80b2\\u3066\\u62e0\\u51fa\\u91d1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 14:19","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 14:19"}	2025-07-09 11:23:17.326722
5063027_1	5063027	1	2025-06-30	ロイヤルホームセンター長久手 Freee田中	11383	【事】消耗品費	ロイヤルホームセンター	消耗		草取り道具	ぽんぽん	2506-112	{"\\u4ed5\\u8a33ID":3174645967,"\\u4ed5\\u8a33\\u756a\\u53f7":5063027,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2506-112","\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":11383.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8349\\u53d6\\u308a\\u9053\\u5177","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 15:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:01"}	2025-07-09 11:23:17.326724
5063028_1	5063028	1	2025-06-30	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3174907225,"\\u4ed5\\u8a33\\u756a\\u53f7":5063028,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/06\\/30 16:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/06\\/30 16:53"}	2025-07-09 11:23:17.326726
5063032_1	5063032	1	2025-06-30	ウエルシア長久手岩作店 Freee 古賀	884	【事】消耗品費	ウエルシア薬局	消耗		生理用品、ビニール袋、ゴミ袋	ぽんぽん		{"\\u4ed5\\u8a33ID":3179724730,"\\u4ed5\\u8a33\\u756a\\u53f7":5063032,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":884.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u751f\\u7406\\u7528\\u54c1\\u3001\\u30d3\\u30cb\\u30fc\\u30eb\\u888b\\u3001\\u30b4\\u30df\\u888b","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:24","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:24"}	2025-07-09 11:23:17.326728
5063033_1	5063033	1	2025-06-30		180000	【事】給与手当	田中直子	給与田中		6月分7月払い	共通部門		{"\\u4ed5\\u8a33ID":3188808196,"\\u4ed5\\u8a33\\u756a\\u53f7":5063033,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u7d66\\u4e0e\\u624b\\u5f53","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7530\\u4e2d\\u76f4\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7530\\u4e2d\\u76f4\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u7530\\u4e2d","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"6\\u6708\\u52067\\u6708\\u6255\\u3044","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:53"}	2025-07-09 11:23:17.32673
5063034_1	5063034	1	2025-06-30		180000	【事】給与手当	今枝麻里	給与今枝			共通部門		{"\\u4ed5\\u8a33ID":3188810211,"\\u4ed5\\u8a33\\u756a\\u53f7":5063034,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u7d66\\u4e0e\\u624b\\u5f53","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4eca\\u679d\\u9ebb\\u91cc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4eca\\u679d\\u9ebb\\u91cc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u4eca\\u679d","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:54","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:54"}	2025-07-09 11:23:17.326732
5063035_1	5063035	1	2025-06-30		180000	【事】臨時雇用費	古賀めぐみ	給与古賀			共通部門		{"\\u4ed5\\u8a33ID":3188812706,"\\u4ed5\\u8a33\\u756a\\u53f7":5063035,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":180000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u53e4\\u8cc0\\u3081\\u3050\\u307f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u53e4\\u8cc0","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:55"}	2025-07-09 11:23:17.326734
5063036_1	5063036	1	2025-06-30		55000	【事】臨時雇用費	村里由希	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3188813705,"\\u4ed5\\u8a33\\u756a\\u53f7":5063036,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":55000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6751\\u91cc\\u7531\\u5e0c","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u6751\\u91cc\\u7531\\u5e0c","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:55"}	2025-07-09 11:23:17.326736
5063037_1	5063037	1	2025-06-30		18540	【事】臨時雇用費	西本和子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3188815263,"\\u4ed5\\u8a33\\u756a\\u53f7":5063037,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":18540.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u897f\\u672c\\u548c\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u897f\\u672c\\u548c\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:56"}	2025-07-09 11:23:17.326739
5063038_1	5063038	1	2025-06-30		50234	【事】臨時雇用費	佐分利麻美	給与佐分利			共通部門		{"\\u4ed5\\u8a33ID":3188817289,"\\u4ed5\\u8a33\\u756a\\u53f7":5063038,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":50234.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f50\\u5206\\u5229\\u9ebb\\u7f8e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4f50\\u5206\\u5229\\u9ebb\\u7f8e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u4f50\\u5206\\u5229","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:56"}	2025-07-09 11:23:17.326741
5063039_1	5063039	1	2025-06-30		59767	【事】臨時雇用費	土井容子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3188818795,"\\u4ed5\\u8a33\\u756a\\u53f7":5063039,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":59767.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u571f\\u4e95\\u5bb9\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u571f\\u4e95\\u5bb9\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:57","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:57"}	2025-07-09 11:23:17.326743
5063040_1	5063040	1	2025-06-30		46400	【事】臨時雇用費	追立浩貴	給与追立			共通部門		{"\\u4ed5\\u8a33ID":3188820238,"\\u4ed5\\u8a33\\u756a\\u53f7":5063040,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":46400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8ffd\\u7acb\\u6d69\\u8cb4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8ffd\\u7acb\\u6d69\\u8cb4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u8ffd\\u7acb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:57","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:57"}	2025-07-09 11:23:17.326745
5063041_1	5063041	1	2025-06-30		14940	【事】臨時雇用費	荒木美弥子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3188822493,"\\u4ed5\\u8a33\\u756a\\u53f7":5063041,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":14940.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8352\\u6728\\u7f8e\\u5f25\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u8352\\u6728\\u7f8e\\u5f25\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 15:58","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 15:58"}	2025-07-09 11:23:17.326747
5063042_1	5063042	1	2025-06-30		20534	【事】臨時雇用費	久野明子	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3188835529,"\\u4ed5\\u8a33\\u756a\\u53f7":5063042,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":20534.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e45\\u91ce\\u660e\\u5b50","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e45\\u91ce\\u660e\\u5b50","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 16:00","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 16:00"}	2025-07-09 11:23:17.326749
5063043_1	5063043	1	2025-06-30		56467	【事】臨時雇用費	金澤ひろみ	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3188838208,"\\u4ed5\\u8a33\\u756a\\u53f7":5063043,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":56467.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u91d1\\u6fa4\\u3072\\u308d\\u307f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u9810\\u308a\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u91d1\\u6fa4\\u3072\\u308d\\u307f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 16:01","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 16:01"}	2025-07-09 11:23:17.326751
5063044_1	5063044	1	2025-06-30		70400	【事】臨時雇用費	遠藤百華	給与臨時			共通部門		{"\\u4ed5\\u8a33ID":3188839982,"\\u4ed5\\u8a33\\u756a\\u53f7":5063044,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/06\\/30","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u81e8\\u6642\\u96c7\\u7528\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":70400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9060\\u85e4\\u767e\\u83ef","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9060\\u85e4\\u767e\\u83ef","\\u501f\\u65b9\\u54c1\\u76ee":"\\u7d66\\u4e0e\\u81e8\\u6642","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 16:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 16:02"}	2025-07-09 11:23:17.326753
5070102_1	5070102	1	2025-07-01	Vデビット　ＬＩＮＥ公式アカウント　1A182001	16500	【事】通信運搬費	LINE株式会社	LINE			共通部門		{"\\u4ed5\\u8a33ID":3179735407,"\\u4ed5\\u8a33\\u756a\\u53f7":5070102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"LINE\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"LINE","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"V\\u30c7\\u30d3\\u30c3\\u30c8\\u3000\\uff2c\\uff29\\uff2e\\uff25\\u516c\\u5f0f\\u30a2\\u30ab\\u30a6\\u30f3\\u30c8\\u30001A182001","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:26"}	2025-07-09 11:23:17.326755
5070103_1	5070103	1	2025-07-01	振込 クニナカ　ミサキ	19500	【事】謝金	国仲美早	謝金ボラ			ぽんぽん		{"\\u4ed5\\u8a33ID":3179746719,"\\u4ed5\\u8a33\\u756a\\u53f7":5070103,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":19500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u56fd\\u4ef2\\u7f8e\\u65e9","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u56fd\\u4ef2\\u7f8e\\u65e9","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30af\\u30cb\\u30ca\\u30ab\\u3000\\u30df\\u30b5\\u30ad","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:29"}	2025-07-09 11:23:17.326757
5070104_1	5070104	1	2025-07-01	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3179748124,"\\u4ed5\\u8a33\\u756a\\u53f7":5070104,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:29"}	2025-07-09 11:23:17.326759
5070106_2	5070106	2	2025-07-01	ＰＡＹＰＡＹ	487	【管】支払手数料					管理部門		{"\\u4ed5\\u8a33ID":3179798620,"\\u4ed5\\u8a33\\u756a\\u53f7":5070106,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":2,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/01","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":487.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":null,"\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":null,"\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff30\\uff21\\uff39\\uff30\\uff21\\uff39","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:41","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:41"}	2025-07-09 11:23:17.326761
5070201_1	5070201	1	2025-07-02	ロイヤルホームセンター長久手 Freee 今枝	524	【事】消耗品費	ロイヤルホームセンター	消耗		ポリ袋	ぽんぽん	2507-001	{"\\u4ed5\\u8a33ID":3179805557,"\\u4ed5\\u8a33\\u756a\\u53f7":5070201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-001","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":524.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30dd\\u30ea\\u888b","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:42"}	2025-07-09 11:23:17.326763
5070202_1	5070202	1	2025-07-02		501	【事】食材費	ウエルシア薬局	消耗食材			ぽんぽん	2507-002	{"\\u4ed5\\u8a33ID":3179826683,"\\u4ed5\\u8a33\\u756a\\u53f7":5070202,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-002","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":501.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:47"}	2025-07-09 11:23:17.326765
5070203_1	5070203	1	2025-07-02		369	【事】消耗品費	ウエルシア薬局	消耗		ポリ袋	ぽんぽん	2507-002	{"\\u4ed5\\u8a33ID":3179831455,"\\u4ed5\\u8a33\\u756a\\u53f7":5070203,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-002","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":369.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30dd\\u30ea\\u888b","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/02 14:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/02 14:48"}	2025-07-09 11:23:17.326767
5070301_1	5070301	1	2025-07-03	ロイヤルホームセンター長久手 Freee 今枝	1547	【事】消耗品費	ロイヤルホームセンター	消耗		袋	ぽんぽん	2507-004	{"\\u4ed5\\u8a33ID":3184878667,"\\u4ed5\\u8a33\\u756a\\u53f7":5070301,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-004","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/03","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1547.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u888b","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30ed\\u30a4\\u30e4\\u30eb\\u30db\\u30fc\\u30e0\\u30bb\\u30f3\\u30bf\\u30fc\\u9577\\u4e45\\u624b Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/04 15:46","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/04 15:46"}	2025-07-09 11:23:17.326772
5070402_1	5070402	1	2025-07-04		3000	【事】謝金	鈴木知佳	謝金講師			相談支援	2507-008	{"\\u4ed5\\u8a33ID":3184909978,"\\u4ed5\\u8a33\\u756a\\u53f7":5070402,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-008","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9234\\u6728\\u77e5\\u4f73","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u76f8\\u8ac7\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/04 15:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/04 15:56"}	2025-07-09 11:23:17.326778
5070411_1	5070411	1	2025-07-04	ﾆﾝﾃﾝﾄﾞｰEｼｮｯﾌﾟ Freee バーチャル（ネット用）	1540	【事】教養娯楽費	任天堂株式会社	その他		カラオケJOYSOUND	夕食・放課後・不登校		{"\\u4ed5\\u8a33ID":3188131153,"\\u4ed5\\u8a33\\u756a\\u53f7":5070411,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6559\\u990a\\u5a2f\\u697d\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1540.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4efb\\u5929\\u5802\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4efb\\u5929\\u5802\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u305d\\u306e\\u4ed6","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30ab\\u30e9\\u30aa\\u30b1JOYSOUND","\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff86\\uff9d\\uff83\\uff9d\\uff84\\uff9e\\uff70E\\uff7c\\uff6e\\uff6f\\uff8c\\uff9f Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:11"}	2025-07-09 11:23:17.326784
5070413_1	5070413	1	2025-07-04		354	【事】食材費	ウエルシア薬局	消耗食材			支援_調理		{"\\u4ed5\\u8a33ID":3188211199,"\\u4ed5\\u8a33\\u756a\\u53f7":5070413,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":354.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:42"}	2025-07-09 11:23:17.326788
5070414_1	5070414	1	2025-07-04		1500	【事】謝金	ボランティア	謝金ボラ			夕食・放課後・不登校	2507-016	{"\\u4ed5\\u8a33ID":3188215734,"\\u4ed5\\u8a33\\u756a\\u53f7":5070414,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-016","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:43"}	2025-07-09 11:23:17.32679
5070501_1	5070501	1	2025-07-05	ADOBE SYSTEMS SOFTWARE Freee バーチャル（ネット用）	3610	【事】通信運搬費	Adobe Systems Software Ireland Ltd	通信			共通部門		{"\\u4ed5\\u8a33ID":3188105935,"\\u4ed5\\u8a33\\u756a\\u53f7":5070501,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3610.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"Adobe Systems Software Ireland Ltd","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u5171\\u901a\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"ADOBE SYSTEMS SOFTWARE Freee \\u30d0\\u30fc\\u30c1\\u30e3\\u30eb\\uff08\\u30cd\\u30c3\\u30c8\\u7528\\uff09","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:03"}	2025-07-09 11:23:17.326794
5070502_1	5070502	1	2025-07-05		1000	【事】謝金	ボランティア	謝金ボラ			学習支援	2507-017	{"\\u4ed5\\u8a33ID":3188213727,"\\u4ed5\\u8a33\\u756a\\u53f7":5070502,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-017","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:43","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 13:00"}	2025-07-09 11:23:17.326796
5070503_1	5070503	1	2025-07-05		4740	【事】食材費	アミカ	消耗食材			支援_調理	2507-019	{"\\u4ed5\\u8a33ID":3188230253,"\\u4ed5\\u8a33\\u756a\\u53f7":5070503,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-019","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":4740.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:50","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:50"}	2025-07-09 11:23:17.326798
5070601_1	5070601	1	2025-07-06		284	【管】通信運搬費	日本郵便株式会社	通信			管理部門	2507-012	{"\\u4ed5\\u8a33ID":3188255838,"\\u4ed5\\u8a33\\u756a\\u53f7":5070601,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-012","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/06","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":284.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:58","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:58"}	2025-07-09 11:23:17.326802
5070701_1	5070701	1	2025-07-07	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3188095527,"\\u4ed5\\u8a33\\u756a\\u53f7":5070701,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 11:58","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 11:58"}	2025-07-09 11:23:17.326804
5070702_1	5070702	1	2025-07-07	振込 ヤマトウンユ（カ	2079	【管】雑費	ヤマト運輸株式会社	通信		機密文書リサイクルサービス	管理部門		{"\\u4ed5\\u8a33ID":3188105470,"\\u4ed5\\u8a33\\u756a\\u53f7":5070702,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u96d1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2079.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30e4\\u30de\\u30c8\\u904b\\u8f38\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30e4\\u30de\\u30c8\\u904b\\u8f38\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u6a5f\\u5bc6\\u6587\\u66f8\\u30ea\\u30b5\\u30a4\\u30af\\u30eb\\u30b5\\u30fc\\u30d3\\u30b9","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc \\u30e4\\u30de\\u30c8\\u30a6\\u30f3\\u30e6\\uff08\\u30ab","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 13:05"}	2025-07-09 11:23:17.326806
5070703_1	5070703	1	2025-07-07		7588	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2507-020	{"\\u4ed5\\u8a33ID":3188224098,"\\u4ed5\\u8a33\\u756a\\u53f7":5070703,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-020","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7588.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:47"}	2025-07-09 11:23:17.326808
5070504_1	5070504	1	2025-07-05		2217	【事】食材費	セブン－イレブン	消耗食材			学習支援	2507-014	{"\\u4ed5\\u8a33ID":3188290451,"\\u4ed5\\u8a33\\u756a\\u53f7":5070504,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-014","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/05","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":2217.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30bb\\u30d6\\u30f3\\uff0d\\u30a4\\u30ec\\u30d6\\u30f3","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30bb\\u30d6\\u30f3\\uff0d\\u30a4\\u30ec\\u30d6\\u30f3","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 13:10","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:37"}	2025-07-09 11:23:17.3268
5070206_1	5070206	1	2025-07-02	ウエルシア長久手岩作店 Freee 今枝	217	【事】消耗品費	ウエルシア薬局	消耗		おかずカップ	ぽんぽん	2507-003	{"\\u4ed5\\u8a33ID":3184881977,"\\u4ed5\\u8a33\\u756a\\u53f7":5070206,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-003","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/02","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":217.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304a\\u304b\\u305a\\u30ab\\u30c3\\u30d7","\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/04 15:46","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/04 15:46"}	2025-07-09 11:23:17.326769
5070302_1	5070302	1	2025-07-03	ウエルシア長久手岩作店 Freee田中	1682	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2507-005	{"\\u4ed5\\u8a33ID":3184896126,"\\u4ed5\\u8a33\\u756a\\u53f7":5070302,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-005","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/03","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1682.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/04 15:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/04 15:51"}	2025-07-09 11:23:17.326774
5070401_1	5070401	1	2025-07-04	ﾆｺﾆｺﾚﾝﾀｶ-ｱｲﾁｶﾞｸｲﾝﾀﾞｲ Freee田中	117000	【事】賃借料	ニコニコレンタカー	通信			支援_パントリー・宅食	2507-006	{"\\u4ed5\\u8a33ID":3184890280,"\\u4ed5\\u8a33\\u756a\\u53f7":5070401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-006","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8cc3\\u501f\\u6599","\\u501f\\u65b9\\u91d1\\u984d":117000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30cb\\u30b3\\u30cb\\u30b3\\u30ec\\u30f3\\u30bf\\u30ab\\u30fc","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30cb\\u30b3\\u30cb\\u30b3\\u30ec\\u30f3\\u30bf\\u30ab\\u30fc","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff86\\uff7a\\uff86\\uff7a\\uff9a\\uff9d\\uff80\\uff76-\\uff71\\uff72\\uff81\\uff76\\uff9e\\uff78\\uff72\\uff9d\\uff80\\uff9e\\uff72 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/04 15:49","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/04 15:49"}	2025-07-09 11:23:17.326776
5070410_1	5070410	1	2025-07-04	ウエルシア長久手岩作店 Freee 今枝	317	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2507-011	{"\\u4ed5\\u8a33ID":3188109849,"\\u4ed5\\u8a33\\u756a\\u53f7":5070410,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-011","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":317.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:04","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:04"}	2025-07-09 11:23:17.326782
5070412_1	5070412	1	2025-07-04	ｸﾗｳﾄﾞｴﾝﾎﾞ Freee 今枝	21780	【管】通信運搬費	クラウド円簿	通信			管理部門	2507-021	{"\\u4ed5\\u8a33ID":3188164702,"\\u4ed5\\u8a33\\u756a\\u53f7":5070412,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-021","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":21780.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30af\\u30e9\\u30a6\\u30c9\\u5186\\u7c3f","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30af\\u30e9\\u30a6\\u30c9\\u5186\\u7c3f","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\uff78\\uff97\\uff73\\uff84\\uff9e\\uff74\\uff9d\\uff8e\\uff9e Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 12:21","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/07 12:21"}	2025-07-09 11:23:17.326786
5070419_1	5070419	1	2025-07-04		19779	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2507-013	{"\\u4ed5\\u8a33ID":3188292820,"\\u4ed5\\u8a33\\u756a\\u53f7":5070419,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-013","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":19779.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u672a\\u6255\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/07 13:11","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:37"}	2025-07-09 11:23:17.326792
5070420_1	5070420	1	2025-07-04		3410	【管】通信運搬費	日本郵便株式会社	通信			管理部門	2507-027	{"\\u4ed5\\u8a33ID":3197550535,"\\u4ed5\\u8a33\\u756a\\u53f7":5070420,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-027","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/04","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3410.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 13:58","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 13:58"}	2025-07-14 04:59:55.420551
5070707_1	5070707	1	2025-07-07		560	【事】消耗品費	るるビオ　エピスリー星が丘	消耗		かんてん遊び用	にこにこ		{"\\u4ed5\\u8a33ID":3200985877,"\\u4ed5\\u8a33\\u756a\\u53f7":5070707,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/07","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":560.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u308b\\u308b\\u30d3\\u30aa\\u3000\\u30a8\\u30d4\\u30b9\\u30ea\\u30fc\\u661f\\u304c\\u4e18","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u308b\\u308b\\u30d3\\u30aa\\u3000\\u30a8\\u30d4\\u30b9\\u30ea\\u30fc\\u661f\\u304c\\u4e18","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304b\\u3093\\u3066\\u3093\\u904a\\u3073\\u7528","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:29","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:29"}	2025-07-14 04:59:55.42057
5070803_1	5070803	1	2025-07-08		6794	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2507-028	{"\\u4ed5\\u8a33ID":3197556046,"\\u4ed5\\u8a33\\u756a\\u53f7":5070803,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-028","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":6794.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:00","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:00"}	2025-07-14 04:59:55.420574
5070804_1	5070804	1	2025-07-08		3000	【事】謝金	一般社団法人運動習慣推進協会	謝金講師			相談支援	2507-024	{"\\u4ed5\\u8a33ID":3197576889,"\\u4ed5\\u8a33\\u756a\\u53f7":5070804,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-024","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u904b\\u52d5\\u7fd2\\u6163\\u63a8\\u9032\\u5354\\u4f1a","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e00\\u822c\\u793e\\u56e3\\u6cd5\\u4eba\\u904b\\u52d5\\u7fd2\\u6163\\u63a8\\u9032\\u5354\\u4f1a","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u76f8\\u8ac7\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:05","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:05"}	2025-07-14 04:59:55.420576
5070805_1	5070805	1	2025-07-08	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3197710676,"\\u4ed5\\u8a33\\u756a\\u53f7":5070805,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:53"}	2025-07-14 04:59:55.420579
5070807_1	5070807	1	2025-07-08	振込手数料	145	【管】支払手数料		雑役			管理部門		{"\\u4ed5\\u8a33ID":3197711734,"\\u4ed5\\u8a33\\u756a\\u53f7":5070807,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u652f\\u6255\\u624b\\u6570\\u6599","\\u501f\\u65b9\\u91d1\\u984d":145.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u30b8\\u30e3\\u30d1\\u30f3\\u30cd\\u30c3\\u30c8\\u9280\\u884c\\uff08API\\uff09","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":null,"\\u501f\\u65b9\\u54c1\\u76ee":"\\u96d1\\u5f79","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u632f\\u8fbc\\u624b\\u6570\\u6599","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:53"}	2025-07-14 04:59:55.420581
5070808_1	5070808	1	2025-07-08	イオン長久手 Freee 古賀	13731	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2507-038	{"\\u4ed5\\u8a33ID":3197715843,"\\u4ed5\\u8a33\\u756a\\u53f7":5070808,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-038","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":13731.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:55"}	2025-07-14 04:59:55.420584
5070809_1	5070809	1	2025-07-08	イオン長久手 Freee 古賀	16400	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理		{"\\u4ed5\\u8a33ID":3197717254,"\\u4ed5\\u8a33\\u756a\\u53f7":5070809,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":16400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a4\\u30aa\\u30f3\\u9577\\u4e45\\u624b Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:55"}	2025-07-14 04:59:55.420586
5070810_1	5070810	1	2025-07-08	アミカ Freee 古賀	3878	【事】食材費	アミカ	消耗食材			支援_調理	2507-037	{"\\u4ed5\\u8a33ID":3197720611,"\\u4ed5\\u8a33\\u756a\\u53f7":5070810,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-037","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3878.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a2\\u30df\\u30ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30df\\u30ab Freee \\u53e4\\u8cc0","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:56"}	2025-07-14 04:59:55.420589
5070811_1	5070811	1	2025-07-08	ウエルシア長久手岩作店 Freee 今枝	1061	【事】食材費	ウエルシア薬局	消耗食材			支援_調理	2507-040	{"\\u4ed5\\u8a33ID":3197730006,"\\u4ed5\\u8a33\\u756a\\u53f7":5070811,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-040","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/08","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1061.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u9577\\u4e45\\u624b\\u5ca9\\u4f5c\\u5e97 Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:59","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:59"}	2025-07-14 04:59:55.420591
5070901_1	5070901	1	2025-07-09		640	【管】通信運搬費	APITA	通信			管理部門	2507-029	{"\\u4ed5\\u8a33ID":3197563312,"\\u4ed5\\u8a33\\u756a\\u53f7":5070901,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-029","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":640.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"APITA","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"APITA","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:02","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:02"}	2025-07-14 04:59:55.420593
5070902_1	5070902	1	2025-07-09		1700	【事】教養娯楽費	竹島開発株式会社	その他			夕食・放課後・不登校	2507-030	{"\\u4ed5\\u8a33ID":3197569728,"\\u4ed5\\u8a33\\u756a\\u53f7":5070902,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-030","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6559\\u990a\\u5a2f\\u697d\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1700.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7af9\\u5cf6\\u958b\\u767a\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u7af9\\u5cf6\\u958b\\u767a\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u305d\\u306e\\u4ed6","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:03","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:03"}	2025-07-14 04:59:55.420596
5070903_1	5070903	1	2025-07-09	NAKANIHONKOUSOKUDOURO Freee 今枝	110	【事】旅費交通費	愛知道路コンセッション株式会社	旅費			夕食・放課後・不登校	2507-035	{"\\u4ed5\\u8a33ID":3197695940,"\\u4ed5\\u8a33\\u756a\\u53f7":5070903,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-035","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u65c5\\u8cbb\\u4ea4\\u901a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":110.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u9053\\u8def\\u30b3\\u30f3\\u30bb\\u30c3\\u30b7\\u30e7\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u9053\\u8def\\u30b3\\u30f3\\u30bb\\u30c3\\u30b7\\u30e7\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u65c5\\u8cbb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"NAKANIHONKOUSOKUDOURO Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:47","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:48"}	2025-07-14 04:59:55.420598
5070904_1	5070904	1	2025-07-09	NAKANIHONKOUSOKUDOURO Freee 今枝	1400	【事】旅費交通費	中日本高速道路株式会社	旅費			夕食・放課後・不登校	2507-034	{"\\u4ed5\\u8a33ID":3197697958,"\\u4ed5\\u8a33\\u756a\\u53f7":5070904,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-034","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u65c5\\u8cbb\\u4ea4\\u901a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u65e5\\u672c\\u9ad8\\u901f\\u9053\\u8def\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u65e5\\u672c\\u9ad8\\u901f\\u9053\\u8def\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u65c5\\u8cbb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"NAKANIHONKOUSOKUDOURO Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:48"}	2025-07-14 04:59:55.4206
5070905_1	5070905	1	2025-07-09	アピタ長久手店（専門店） Freee田中	3060	【事】食材費	SUBWAY	消耗食材			ぽんぽん	2507-042	{"\\u4ed5\\u8a33ID":3197706035,"\\u4ed5\\u8a33\\u756a\\u53f7":5070905,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-042","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3060.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"SUBWAY","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"SUBWAY","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"\\u30a2\\u30d4\\u30bf\\u9577\\u4e45\\u624b\\u5e97\\uff08\\u5c02\\u9580\\u5e97\\uff09 Freee\\u7530\\u4e2d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:51"}	2025-07-14 04:59:55.420603
5070906_1	5070906	1	2025-07-09	NAKANIHONKOUSOKUDOURO Freee 今枝	1400	【事】旅費交通費	中日本高速道路株式会社	旅費			夕食・放課後・不登校	2507-033	{"\\u4ed5\\u8a33ID":3197707992,"\\u4ed5\\u8a33\\u756a\\u53f7":5070906,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-033","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u65c5\\u8cbb\\u4ea4\\u901a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":1400.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u65e5\\u672c\\u9ad8\\u901f\\u9053\\u8def\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u4e2d\\u65e5\\u672c\\u9ad8\\u901f\\u9053\\u8def\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u65c5\\u8cbb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"NAKANIHONKOUSOKUDOURO Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:52","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:52"}	2025-07-14 04:59:55.420605
5070907_1	5070907	1	2025-07-09		335	【事】消耗品費	APITA	消耗		かんてん遊び用	にこにこ		{"\\u4ed5\\u8a33ID":3200977928,"\\u4ed5\\u8a33\\u756a\\u53f7":5070907,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":335.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"APITA","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"APITA","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u306b\\u3053\\u306b\\u3053","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u304b\\u3093\\u3066\\u3093\\u904a\\u3073\\u7528","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:26","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:26"}	2025-07-14 04:59:55.420608
5070908_1	5070908	1	2025-07-09		110	【事】旅費交通費	愛知道路コンセッション株式会社	旅費			夕食・放課後・不登校	2507-036	{"\\u4ed5\\u8a33ID":3201058913,"\\u4ed5\\u8a33\\u756a\\u53f7":5070908,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-036","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/09","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u65c5\\u8cbb\\u4ea4\\u901a\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":110.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u9053\\u8def\\u30b3\\u30f3\\u30bb\\u30c3\\u30b7\\u30e7\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u611b\\u77e5\\u9053\\u8def\\u30b3\\u30f3\\u30bb\\u30c3\\u30b7\\u30e7\\u30f3\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u65c5\\u8cbb","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:55","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:55"}	2025-07-14 04:59:55.42061
5071001_1	5071001	1	2025-07-10		11801	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2507-031	{"\\u4ed5\\u8a33ID":3197632293,"\\u4ed5\\u8a33\\u756a\\u53f7":5071001,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-031","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":11801.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:27","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:27"}	2025-07-14 04:59:55.420612
5071002_1	5071002	1	2025-07-10	AEON NAGAKUTE Freee 今枝	3543	【事】食材費	イオンリテール株式会社	消耗食材			支援_調理	2507-041	{"\\u4ed5\\u8a33ID":3197677062,"\\u4ed5\\u8a33\\u756a\\u53f7":5071002,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-041","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/10","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3543.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"freee\\u30ab\\u30fc\\u30c9 Unlimited","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a4\\u30aa\\u30f3\\u30ea\\u30c6\\u30fc\\u30eb\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":"AEON NAGAKUTE Freee \\u4eca\\u679d","\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:42","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:42"}	2025-07-14 04:59:55.420615
5071101_1	5071101	1	2025-07-11		3000	【事】謝金	岡田薫	謝金講師			相談支援	2507-025	{"\\u4ed5\\u8a33ID":3197580426,"\\u4ed5\\u8a33\\u756a\\u53f7":5071101,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-025","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5ca1\\u7530\\u85ab","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u5ca1\\u7530\\u85ab","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u8b1b\\u5e2b","\\u501f\\u65b9\\u90e8\\u9580":"\\u76f8\\u8ac7\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:07","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:07"}	2025-07-14 04:59:55.420617
5071102_1	5071102	1	2025-07-11		3000	【事】謝金	高柳公治	謝金ボラ			支援_調理	2507-026	{"\\u4ed5\\u8a33ID":3197593851,"\\u4ed5\\u8a33\\u756a\\u53f7":5071102,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-026","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":3000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9ad8\\u67f3\\u516c\\u6cbb","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9ad8\\u67f3\\u516c\\u6cbb","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:12","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:12"}	2025-07-14 04:59:55.420619
5071106_1	5071106	1	2025-07-11		530	【管】通信運搬費	日本郵便株式会社	通信		赤い羽根	管理部門	2507-032	{"\\u4ed5\\u8a33ID":3197636420,"\\u4ed5\\u8a33\\u756a\\u53f7":5071106,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-032","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u7ba1\\u3011\\u901a\\u4fe1\\u904b\\u642c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":530.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u65e5\\u672c\\u90f5\\u4fbf\\u682a\\u5f0f\\u4f1a\\u793e","\\u501f\\u65b9\\u54c1\\u76ee":"\\u901a\\u4fe1","\\u501f\\u65b9\\u90e8\\u9580":"\\u7ba1\\u7406\\u90e8\\u9580","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u8d64\\u3044\\u7fbd\\u6839","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/11 14:28","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/11 14:28"}	2025-07-14 04:59:55.420621
5071107_1	5071107	1	2025-07-11		90	【事】印刷製本費	長久手市役所	印刷		パントリー用チラシ	支援_パントリー・宅食		{"\\u4ed5\\u8a33ID":3200988799,"\\u4ed5\\u8a33\\u756a\\u53f7":5071107,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u5370\\u5237\\u88fd\\u672c\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":90.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u9577\\u4e45\\u624b\\u5e02\\u5f79\\u6240","\\u501f\\u65b9\\u54c1\\u76ee":"\\u5370\\u5237","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u30fb\\u5b85\\u98df","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30d1\\u30f3\\u30c8\\u30ea\\u30fc\\u7528\\u30c1\\u30e9\\u30b7","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:31","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:32"}	2025-07-14 04:59:55.420624
5071108_1	5071108	1	2025-07-11		3894	【事】消耗品費	ウエルシア薬局	消耗		ハチスプレー	ぽんぽん		{"\\u4ed5\\u8a33ID":3201036758,"\\u4ed5\\u8a33\\u756a\\u53f7":5071108,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":null,"\\u53d6\\u5f15\\u65e5":"2025\\/07\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u6d88\\u8017\\u54c1\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":3894.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30a6\\u30a8\\u30eb\\u30b7\\u30a2\\u85ac\\u5c40","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017","\\u501f\\u65b9\\u90e8\\u9580":"\\u307d\\u3093\\u307d\\u3093","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u30cf\\u30c1\\u30b9\\u30d7\\u30ec\\u30fc","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:48","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:48"}	2025-07-14 04:59:55.420626
5071109_1	5071109	1	2025-07-11		2000	【事】謝金	ボランティア	謝金ボラ		森川、長田、佐藤、一井	夕食・放課後・不登校	2507-047	{"\\u4ed5\\u8a33ID":3201044139,"\\u4ed5\\u8a33\\u756a\\u53f7":5071109,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-047","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/11","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":2000.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5915\\u98df\\u30fb\\u653e\\u8ab2\\u5f8c\\u30fb\\u4e0d\\u767b\\u6821","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u68ee\\u5ddd\\u3001\\u9577\\u7530\\u3001\\u4f50\\u85e4\\u3001\\u4e00\\u4e95","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:51","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:51"}	2025-07-14 04:59:55.420628
5071201_1	5071201	1	2025-07-12		1500	【事】謝金	ボランティア	謝金ボラ		鋤柄、野田、羽地	学習支援	2507-048	{"\\u4ed5\\u8a33ID":3201049487,"\\u4ed5\\u8a33\\u756a\\u53f7":5071201,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-048","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/12","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u8b1d\\u91d1","\\u501f\\u65b9\\u91d1\\u984d":1500.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u30dc\\u30e9\\u30f3\\u30c6\\u30a3\\u30a2","\\u501f\\u65b9\\u54c1\\u76ee":"\\u8b1d\\u91d1\\u30dc\\u30e9","\\u501f\\u65b9\\u90e8\\u9580":"\\u5b66\\u7fd2\\u652f\\u63f4","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":"\\u92e4\\u67c4\\u3001\\u91ce\\u7530\\u3001\\u7fbd\\u5730","\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:53","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:58"}	2025-07-14 04:59:55.420631
5071401_1	5071401	1	2025-07-14		7720	【事】食材費	株式会社タチヤ	消耗食材			支援_調理	2507-049	{"\\u4ed5\\u8a33ID":3201063335,"\\u4ed5\\u8a33\\u756a\\u53f7":5071401,"\\u4ed5\\u8a33\\u884c\\u756a\\u53f7":1,"\\u7ba1\\u7406\\u756a\\u53f7":"2507-049","\\u53d6\\u5f15\\u65e5":"2025\\/07\\/14","\\u501f\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u3010\\u4e8b\\u3011\\u98df\\u6750\\u8cbb","\\u501f\\u65b9\\u91d1\\u984d":7720.0,"\\u501f\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u8cb8\\u65b9\\u52d8\\u5b9a\\u79d1\\u76ee":"\\u73fe\\u91d1","\\u8cb8\\u65b9\\u53d6\\u5f15\\u5148\\u540d":"\\u682a\\u5f0f\\u4f1a\\u793e\\u30bf\\u30c1\\u30e4","\\u501f\\u65b9\\u54c1\\u76ee":"\\u6d88\\u8017\\u98df\\u6750","\\u501f\\u65b9\\u90e8\\u9580":"\\u652f\\u63f4_\\u8abf\\u7406","\\u501f\\u65b9\\u30e1\\u30e2":null,"\\u501f\\u65b9\\u5099\\u8003":null,"\\u53d6\\u5f15\\u5185\\u5bb9":null,"\\u4f5c\\u6210\\u65e5\\u6642":"2025\\/07\\/14 13:56","\\u66f4\\u65b0\\u65e5\\u6642":"2025\\/07\\/14 13:56"}	2025-07-14 04:59:55.420633
\.


--
-- Data for Name: wam_mappings; Type: TABLE DATA; Schema: public; Owner: nagaiku_user
--

COPY public.wam_mappings (id, account_pattern, wam_category, priority, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Name: allocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.allocations_id_seq', 1648, true);


--
-- Name: budget_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.budget_items_id_seq', 31, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.categories_id_seq', 11, true);


--
-- Name: dev_allocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.dev_allocations_id_seq', 1, false);


--
-- Name: dev_budget_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.dev_budget_items_id_seq', 1, false);


--
-- Name: dev_freee_syncs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.dev_freee_syncs_id_seq', 1, false);


--
-- Name: dev_freee_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.dev_freee_tokens_id_seq', 1, false);


--
-- Name: dev_grants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.dev_grants_id_seq', 1, false);


--
-- Name: freee_syncs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.freee_syncs_id_seq', 1, false);


--
-- Name: freee_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.freee_tokens_id_seq', 1, false);


--
-- Name: grants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.grants_id_seq', 9, true);


--
-- Name: wam_mappings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nagaiku_user
--

SELECT pg_catalog.setval('public.wam_mappings_id_seq', 1, false);


--
-- Name: allocations allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.allocations
    ADD CONSTRAINT allocations_pkey PRIMARY KEY (id);


--
-- Name: budget_items budget_items_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: dev_allocations dev_allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_allocations
    ADD CONSTRAINT dev_allocations_pkey PRIMARY KEY (id);


--
-- Name: dev_budget_items dev_budget_items_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_budget_items
    ADD CONSTRAINT dev_budget_items_pkey PRIMARY KEY (id);


--
-- Name: dev_freee_syncs dev_freee_syncs_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_freee_syncs
    ADD CONSTRAINT dev_freee_syncs_pkey PRIMARY KEY (id);


--
-- Name: dev_freee_tokens dev_freee_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_freee_tokens
    ADD CONSTRAINT dev_freee_tokens_pkey PRIMARY KEY (id);


--
-- Name: dev_grants dev_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_grants
    ADD CONSTRAINT dev_grants_pkey PRIMARY KEY (id);


--
-- Name: dev_transactions dev_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_transactions
    ADD CONSTRAINT dev_transactions_pkey PRIMARY KEY (id);


--
-- Name: freee_syncs freee_syncs_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.freee_syncs
    ADD CONSTRAINT freee_syncs_pkey PRIMARY KEY (id);


--
-- Name: freee_tokens freee_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.freee_tokens
    ADD CONSTRAINT freee_tokens_pkey PRIMARY KEY (id);


--
-- Name: grants grants_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.grants
    ADD CONSTRAINT grants_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: wam_mappings wam_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.wam_mappings
    ADD CONSTRAINT wam_mappings_pkey PRIMARY KEY (id);


--
-- Name: ix_allocations_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_allocations_id ON public.allocations USING btree (id);


--
-- Name: ix_budget_items_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_budget_items_id ON public.budget_items USING btree (id);


--
-- Name: ix_categories_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_categories_id ON public.categories USING btree (id);


--
-- Name: ix_dev_allocations_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_allocations_id ON public.dev_allocations USING btree (id);


--
-- Name: ix_dev_budget_items_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_budget_items_id ON public.dev_budget_items USING btree (id);


--
-- Name: ix_dev_freee_syncs_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_freee_syncs_id ON public.dev_freee_syncs USING btree (id);


--
-- Name: ix_dev_freee_tokens_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_freee_tokens_id ON public.dev_freee_tokens USING btree (id);


--
-- Name: ix_dev_grants_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_grants_id ON public.dev_grants USING btree (id);


--
-- Name: ix_dev_transactions_account; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_transactions_account ON public.dev_transactions USING btree (account);


--
-- Name: ix_dev_transactions_date; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_transactions_date ON public.dev_transactions USING btree (date);


--
-- Name: ix_dev_transactions_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_transactions_id ON public.dev_transactions USING btree (id);


--
-- Name: ix_dev_transactions_journal_number; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_dev_transactions_journal_number ON public.dev_transactions USING btree (journal_number);


--
-- Name: ix_freee_syncs_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_freee_syncs_id ON public.freee_syncs USING btree (id);


--
-- Name: ix_freee_tokens_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_freee_tokens_id ON public.freee_tokens USING btree (id);


--
-- Name: ix_grants_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_grants_id ON public.grants USING btree (id);


--
-- Name: ix_transactions_account; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_transactions_account ON public.transactions USING btree (account);


--
-- Name: ix_transactions_date; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_transactions_date ON public.transactions USING btree (date);


--
-- Name: ix_transactions_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_transactions_id ON public.transactions USING btree (id);


--
-- Name: ix_transactions_journal_number; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_transactions_journal_number ON public.transactions USING btree (journal_number);


--
-- Name: ix_wam_mappings_id; Type: INDEX; Schema: public; Owner: nagaiku_user
--

CREATE INDEX ix_wam_mappings_id ON public.wam_mappings USING btree (id);


--
-- Name: allocations allocations_budget_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.allocations
    ADD CONSTRAINT allocations_budget_item_id_fkey FOREIGN KEY (budget_item_id) REFERENCES public.budget_items(id);


--
-- Name: allocations allocations_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.allocations
    ADD CONSTRAINT allocations_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- Name: budget_items budget_items_grant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_grant_id_fkey FOREIGN KEY (grant_id) REFERENCES public.grants(id);


--
-- Name: dev_allocations dev_allocations_budget_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_allocations
    ADD CONSTRAINT dev_allocations_budget_item_id_fkey FOREIGN KEY (budget_item_id) REFERENCES public.dev_budget_items(id);


--
-- Name: dev_allocations dev_allocations_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_allocations
    ADD CONSTRAINT dev_allocations_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.dev_transactions(id);


--
-- Name: dev_budget_items dev_budget_items_grant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nagaiku_user
--

ALTER TABLE ONLY public.dev_budget_items
    ADD CONSTRAINT dev_budget_items_grant_id_fkey FOREIGN KEY (grant_id) REFERENCES public.dev_grants(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO nagaiku_user;


--
-- PostgreSQL database dump complete
--

