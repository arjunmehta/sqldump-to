--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.4
-- Dumped by pg_dump version 9.1.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: craig
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO craig;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: craig
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: products; Type: TABLE; Schema: public; Owner: craig
--

CREATE TABLE products (
    id integer NOT NULL,
    title character varying(255),
    price numeric,
    created_at timestamp with time zone,
    deleted_at timestamp with time zone,
    tags character varying(255)[]
);


ALTER TABLE public.products OWNER TO craig;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: craig
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO craig;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: craig
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: craig
--

SELECT pg_catalog.setval('products_id_seq', 20, true);


--
-- Name: purchase_items; Type: TABLE; Schema: public; Owner: craig
--

CREATE TABLE purchase_items (
    id integer NOT NULL,
    purchase_id integer,
    product_id integer,
    price numeric,
    quantity integer,
    state character varying(255)
);


ALTER TABLE public.purchase_items OWNER TO craig;

--
-- Name: purchase_items_id_seq; Type: SEQUENCE; Schema: public; Owner: craig
--

CREATE SEQUENCE purchase_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_items_id_seq OWNER TO craig;

--
-- Name: purchase_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: craig
--

ALTER SEQUENCE purchase_items_id_seq OWNED BY purchase_items.id;


--
-- Name: purchase_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: craig
--

SELECT pg_catalog.setval('purchase_items_id_seq', 1458, true);


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: craig
--

CREATE TABLE purchases (
    id integer NOT NULL,
    created_at timestamp with time zone,
    name character varying(255),
    address character varying(255),
    state character varying(2),
    zipcode integer,
    user_id integer
);


ALTER TABLE public.purchases OWNER TO craig;

--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: craig
--

CREATE SEQUENCE purchases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchases_id_seq OWNER TO craig;

--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: craig
--

ALTER SEQUENCE purchases_id_seq OWNED BY purchases.id;


--
-- Name: purchases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: craig
--

SELECT pg_catalog.setval('purchases_id_seq', 1000, true);


--
-- Name: users; Type: TABLE; Schema: public; Owner: craig
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255),
    password character varying(255),
    details hstore,
    created_at timestamp with time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO craig;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: craig
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO craig;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: craig
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: craig
--

SELECT pg_catalog.setval('users_id_seq', 50, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: craig
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: craig
--

ALTER TABLE ONLY purchase_items ALTER COLUMN id SET DEFAULT nextval('purchase_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: craig
--

ALTER TABLE ONLY purchases ALTER COLUMN id SET DEFAULT nextval('purchases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: craig
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: craig
--

COPY products (id, title, price, created_at, deleted_at, tags) FROM stdin;
1	Dictionary	9.99	2011-01-01 12:00:00-08	\N	{Book}
2	Python Book	29.99	2011-01-01 12:00:00-08	\N	{Book,Programming,Python}
3	Ruby Book	27.99	2011-01-01 12:00:00-08	\N	{Book,Programming,Ruby}
4	Baby Book	7.99	2011-01-01 12:00:00-08	\N	{Book,Children,Baby}
5	Coloring Book	5.99	2011-01-01 12:00:00-08	\N	{Book,Children}
6	Desktop Computer	499.99	2011-01-01 12:00:00-08	\N	{Technology}
7	Laptop Computer	899.99	2011-01-01 12:00:00-08	\N	{Technology}
8	MP3 Player	108.00	2011-01-01 12:00:00-08	\N	{Technology,Music}
9	42" LCD TV	499.00	2011-01-01 12:00:00-08	\N	{Technology,TV}
10	42" Plasma TV	529.00	2011-01-01 12:00:00-08	\N	{Technology,TV}
11	Classical CD	9.99	2011-01-01 12:00:00-08	\N	{Music}
12	Holiday CD	9.99	2011-01-01 12:00:00-08	\N	{Music}
13	Country CD	9.99	2011-01-01 12:00:00-08	\N	{Music}
14	Pop CD	9.99	2011-01-01 12:00:00-08	\N	{Music}
15	Electronic CD	9.99	2011-01-01 12:00:00-08	\N	{Music}
16	Comedy Movie	14.99	2011-01-01 12:00:00-08	\N	{Movie,Comedy}
17	Documentary	14.99	2011-01-01 12:00:00-08	\N	{Movie}
18	Romantic	14.99	2011-01-01 12:00:00-08	\N	{Movie}
19	Drama	14.99	2011-01-01 12:00:00-08	\N	{Movie}
20	Action	14.99	2011-01-01 12:00:00-08	\N	{Movie}
\.


--
-- Data for Name: purchase_items; Type: TABLE DATA; Schema: public; Owner: craig
--

COPY purchase_items (id, purchase_id, product_id, price, quantity, state) FROM stdin;
2	1	3	27.99	1	Delivered
3	1	8	108.00	1	Delivered
4	2	1	9.99	2	Delivered
5	3	12	9.99	1	Delivered
6	3	17	14.99	4	Delivered
7	3	11	9.99	1	Delivered
8	4	4	7.99	3	Delivered
9	5	18	14.99	1	Delivered
10	5	2	29.99	4	Delivered
11	6	5	5.99	1	Delivered
12	7	6	499.99	3	Returned
13	8	10	529.00	1	Delivered
14	8	7	899.99	1	Delivered
15	9	15	9.99	2	Delivered
16	10	2	29.99	1	Delivered
17	11	9	499.00	2	Delivered
18	12	14	9.99	5	Delivered
19	12	10	529.00	1	Delivered
20	13	8	108.00	1	Delivered
21	14	20	14.99	1	Delivered
22	14	7	899.99	1	Delivered
23	14	9	499.00	1	Delivered
24	15	10	529.00	2	Delivered
25	16	2	29.99	1	Delivered
26	16	11	9.99	1	Delivered
27	16	5	5.99	1	Delivered
28	17	15	9.99	2	Delivered
29	18	4	7.99	2	Delivered
30	19	1	9.99	1	Returned
31	19	7	899.99	1	Returned
32	19	9	499.00	1	Returned
33	20	20	14.99	5	Delivered
34	21	13	9.99	3	Delivered
35	21	20	14.99	1	Delivered
36	22	7	899.99	1	Delivered
37	22	4	7.99	1	Delivered
38	22	15	9.99	1	Delivered
39	23	4	7.99	1	Delivered
40	24	4	7.99	2	Delivered
41	25	14	9.99	4	Delivered
42	25	12	9.99	1	Delivered
43	26	12	9.99	2	Delivered
44	26	6	499.99	1	Delivered
45	26	4	7.99	1	Delivered
46	27	11	9.99	1	Delivered
47	28	9	499.00	1	Delivered
48	29	8	108.00	1	Delivered
49	29	10	529.00	1	Delivered
50	30	13	9.99	1	Delivered
51	31	2	29.99	2	Delivered
52	32	16	14.99	1	Delivered
53	32	19	14.99	2	Delivered
54	33	9	499.00	1	Delivered
55	34	16	14.99	1	Delivered
56	34	1	9.99	1	Delivered
57	35	6	499.99	1	Returned
58	36	3	27.99	1	Delivered
59	36	20	14.99	4	Delivered
60	37	14	9.99	1	Delivered
61	38	10	529.00	1	Returned
62	39	2	29.99	2	Delivered
63	40	17	14.99	1	Delivered
64	41	12	9.99	1	Delivered
65	42	14	9.99	2	Delivered
66	43	6	499.99	2	Delivered
67	43	3	27.99	1	Delivered
68	44	10	529.00	4	Delivered
69	44	3	27.99	4	Delivered
70	45	12	9.99	1	Delivered
71	46	7	899.99	1	Delivered
72	47	12	9.99	2	Delivered
73	48	3	27.99	4	Delivered
74	49	6	499.99	1	Delivered
75	49	20	14.99	1	Delivered
76	50	8	108.00	1	Delivered
77	51	7	899.99	1	Pending
78	52	9	499.00	1	Delivered
79	53	16	14.99	1	Delivered
80	54	16	14.99	2	Delivered
81	55	4	7.99	1	Delivered
82	55	15	9.99	1	Delivered
83	55	19	14.99	5	Delivered
84	56	14	9.99	1	Delivered
85	57	3	27.99	3	Delivered
86	58	9	499.00	4	Delivered
87	58	16	14.99	1	Delivered
88	59	1	9.99	2	Delivered
89	60	1	9.99	2	Delivered
90	61	2	29.99	2	Delivered
91	61	15	9.99	3	Delivered
92	62	14	9.99	5	Delivered
93	63	6	499.99	1	Delivered
94	64	20	14.99	1	Delivered
95	65	15	9.99	1	Returned
96	66	12	9.99	1	Delivered
97	67	11	9.99	2	Returned
98	68	11	9.99	3	Pending
99	69	12	9.99	2	Delivered
100	70	4	7.99	1	Delivered
101	71	12	9.99	2	Delivered
102	71	15	9.99	1	Delivered
103	71	14	9.99	1	Delivered
104	72	12	9.99	1	Returned
105	73	7	899.99	1	Delivered
106	73	2	29.99	2	Delivered
107	74	2	29.99	1	Delivered
108	75	16	14.99	1	Returned
109	75	7	899.99	1	Returned
110	76	16	14.99	2	Pending
111	76	15	9.99	1	Pending
112	76	18	14.99	1	Pending
113	77	10	529.00	5	Delivered
114	78	5	5.99	1	Delivered
115	79	6	499.99	1	Delivered
116	79	7	899.99	1	Delivered
117	80	13	9.99	1	Delivered
118	80	17	14.99	5	Delivered
119	81	13	9.99	2	Delivered
120	82	1	9.99	1	Delivered
121	82	13	9.99	1	Delivered
122	83	14	9.99	1	Delivered
123	84	20	14.99	1	Delivered
124	85	12	9.99	1	Delivered
125	85	7	899.99	1	Delivered
126	86	15	9.99	1	Delivered
127	87	17	14.99	2	Delivered
128	88	3	27.99	1	Delivered
129	89	8	108.00	1	Delivered
130	89	20	14.99	1	Delivered
131	89	10	529.00	1	Delivered
132	90	6	499.99	5	Delivered
133	90	1	9.99	1	Delivered
134	91	17	14.99	2	Delivered
135	92	8	108.00	1	Delivered
136	92	12	9.99	1	Delivered
137	93	2	29.99	1	Delivered
138	93	7	899.99	2	Delivered
139	94	6	499.99	2	Delivered
140	95	8	108.00	5	Delivered
141	95	9	499.00	1	Delivered
142	96	4	7.99	2	Delivered
143	96	16	14.99	1	Delivered
144	97	7	899.99	1	Delivered
145	98	14	9.99	5	Delivered
146	99	17	14.99	1	Delivered
147	100	17	14.99	1	Delivered
148	101	19	14.99	1	Delivered
149	102	17	14.99	1	Delivered
150	102	18	14.99	1	Delivered
151	102	8	108.00	1	Delivered
152	103	13	9.99	1	Delivered
153	103	15	9.99	3	Delivered
154	104	3	27.99	1	Delivered
155	105	4	7.99	1	Delivered
156	106	18	14.99	1	Delivered
157	107	6	499.99	2	Delivered
158	107	19	14.99	1	Delivered
159	107	16	14.99	1	Delivered
160	108	16	14.99	1	Delivered
161	109	7	899.99	2	Delivered
162	109	6	499.99	1	Delivered
163	109	16	14.99	4	Delivered
164	110	2	29.99	1	Delivered
165	110	9	499.00	2	Delivered
166	111	17	14.99	1	Delivered
167	112	17	14.99	2	Delivered
168	113	8	108.00	1	Delivered
169	114	5	5.99	3	Delivered
170	115	5	5.99	1	Delivered
171	116	17	14.99	2	Delivered
172	117	13	9.99	1	Delivered
173	118	11	9.99	1	Delivered
174	119	9	499.00	1	Delivered
175	119	9	499.00	1	Delivered
176	120	19	14.99	1	Delivered
177	121	11	9.99	2	Delivered
178	122	20	14.99	1	Delivered
179	122	8	108.00	3	Delivered
180	122	13	9.99	1	Delivered
181	123	19	14.99	3	Delivered
182	123	1	9.99	2	Delivered
183	124	7	899.99	1	Delivered
184	125	17	14.99	1	Delivered
185	126	12	9.99	3	Delivered
186	126	3	27.99	1	Delivered
187	127	14	9.99	1	Delivered
188	128	19	14.99	2	Delivered
189	128	12	9.99	1	Delivered
190	128	15	9.99	1	Delivered
191	129	15	9.99	1	Delivered
192	130	1	9.99	1	Delivered
193	130	7	899.99	2	Delivered
194	131	7	899.99	1	Returned
195	132	8	108.00	1	Delivered
196	133	2	29.99	1	Delivered
197	134	6	499.99	1	Delivered
198	134	6	499.99	1	Delivered
199	135	2	29.99	1	Delivered
200	135	1	9.99	2	Delivered
201	136	17	14.99	2	Delivered
202	136	14	9.99	1	Delivered
203	137	3	27.99	1	Delivered
204	138	11	9.99	3	Delivered
205	138	17	14.99	2	Delivered
206	139	14	9.99	1	Delivered
207	140	13	9.99	1	Delivered
208	141	7	899.99	1	Delivered
209	142	16	14.99	5	Returned
210	142	9	499.00	1	Returned
211	143	7	899.99	1	Delivered
212	143	17	14.99	1	Delivered
213	144	14	9.99	1	Delivered
214	145	12	9.99	2	Delivered
215	145	13	9.99	1	Delivered
216	145	5	5.99	1	Delivered
217	146	4	7.99	2	Delivered
218	147	2	29.99	1	Delivered
219	148	7	899.99	1	Delivered
220	148	17	14.99	5	Delivered
221	148	8	108.00	2	Delivered
222	149	18	14.99	1	Delivered
223	150	11	9.99	1	Delivered
224	151	19	14.99	2	Pending
225	152	2	29.99	1	Pending
226	153	15	9.99	2	Delivered
227	154	4	7.99	3	Delivered
228	155	4	7.99	1	Delivered
229	156	2	29.99	1	Delivered
230	156	10	529.00	1	Delivered
231	157	19	14.99	2	Delivered
232	158	5	5.99	3	Delivered
233	159	8	108.00	2	Delivered
234	159	4	7.99	3	Delivered
235	160	18	14.99	2	Delivered
236	161	19	14.99	1	Delivered
237	162	14	9.99	1	Delivered
238	162	15	9.99	1	Delivered
239	163	10	529.00	3	Delivered
240	163	3	27.99	1	Delivered
241	163	14	9.99	1	Delivered
242	164	19	14.99	1	Delivered
243	164	14	9.99	3	Delivered
244	165	15	9.99	1	Delivered
245	166	15	9.99	1	Delivered
246	167	3	27.99	1	Returned
247	168	2	29.99	1	Delivered
248	169	12	9.99	2	Delivered
249	170	12	9.99	1	Delivered
250	170	8	108.00	1	Delivered
251	170	15	9.99	2	Delivered
252	171	7	899.99	1	Delivered
253	172	11	9.99	5	Delivered
254	172	20	14.99	1	Delivered
255	173	12	9.99	1	Delivered
256	174	4	7.99	3	Delivered
257	175	18	14.99	1	Delivered
258	176	18	14.99	2	Delivered
259	177	18	14.99	1	Delivered
260	178	7	899.99	1	Delivered
261	179	5	5.99	2	Delivered
262	179	17	14.99	1	Delivered
263	179	2	29.99	1	Delivered
264	180	13	9.99	1	Delivered
265	181	3	27.99	5	Delivered
266	181	15	9.99	4	Delivered
267	181	20	14.99	2	Delivered
268	182	10	529.00	2	Delivered
269	182	13	9.99	3	Delivered
270	183	12	9.99	1	Delivered
271	183	12	9.99	1	Delivered
272	184	2	29.99	5	Pending
273	185	3	27.99	1	Delivered
274	186	17	14.99	1	Delivered
275	186	3	27.99	1	Delivered
276	187	13	9.99	1	Delivered
277	188	1	9.99	2	Delivered
278	189	14	9.99	1	Pending
279	189	10	529.00	1	Pending
280	190	13	9.99	1	Delivered
281	190	14	9.99	2	Delivered
282	190	11	9.99	5	Delivered
283	191	2	29.99	1	Delivered
284	192	5	5.99	2	Delivered
285	193	5	5.99	2	Delivered
286	194	6	499.99	4	Delivered
287	195	16	14.99	2	Delivered
288	196	11	9.99	1	Delivered
289	197	11	9.99	1	Delivered
290	198	17	14.99	1	Delivered
291	199	6	499.99	1	Delivered
292	199	15	9.99	1	Delivered
293	199	6	499.99	5	Delivered
294	200	1	9.99	1	Delivered
295	201	19	14.99	1	Pending
296	202	2	29.99	5	Delivered
297	203	16	14.99	1	Delivered
298	203	3	27.99	1	Delivered
299	204	5	5.99	1	Delivered
300	205	15	9.99	1	Delivered
301	206	12	9.99	1	Delivered
302	207	3	27.99	2	Delivered
303	208	19	14.99	1	Delivered
304	209	3	27.99	1	Delivered
305	210	15	9.99	1	Returned
306	210	12	9.99	2	Returned
307	211	20	14.99	1	Delivered
308	212	1	9.99	2	Returned
309	212	10	529.00	1	Returned
310	213	12	9.99	1	Delivered
311	214	2	29.99	1	Delivered
312	214	6	499.99	1	Delivered
313	214	13	9.99	2	Delivered
314	215	16	14.99	1	Delivered
315	215	19	14.99	1	Delivered
316	216	10	529.00	2	Delivered
317	217	4	7.99	4	Delivered
318	218	10	529.00	1	Delivered
319	219	12	9.99	1	Delivered
320	220	5	5.99	1	Delivered
321	220	13	9.99	2	Delivered
322	221	20	14.99	2	Delivered
323	222	5	5.99	1	Delivered
324	223	15	9.99	1	Delivered
325	223	2	29.99	1	Delivered
326	224	17	14.99	1	Delivered
327	224	17	14.99	1	Delivered
328	224	5	5.99	2	Delivered
329	225	2	29.99	1	Delivered
330	226	18	14.99	1	Returned
331	226	14	9.99	3	Returned
332	226	12	9.99	1	Returned
333	227	16	14.99	1	Delivered
334	228	17	14.99	1	Delivered
335	229	4	7.99	2	Delivered
336	230	14	9.99	1	Delivered
337	231	3	27.99	2	Delivered
338	231	16	14.99	4	Delivered
339	232	14	9.99	1	Delivered
340	232	6	499.99	2	Delivered
341	233	2	29.99	5	Delivered
342	233	13	9.99	2	Delivered
343	234	18	14.99	2	Delivered
344	235	17	14.99	1	Delivered
345	235	4	7.99	2	Delivered
346	235	4	7.99	1	Delivered
347	236	9	499.00	2	Delivered
348	236	16	14.99	1	Delivered
349	237	16	14.99	1	Delivered
350	237	13	9.99	1	Delivered
351	238	10	529.00	1	Delivered
352	238	13	9.99	1	Delivered
353	239	5	5.99	1	Delivered
354	240	13	9.99	3	Delivered
355	241	19	14.99	1	Delivered
356	241	14	9.99	2	Delivered
357	241	16	14.99	2	Delivered
358	242	10	529.00	1	Delivered
359	243	11	9.99	1	Delivered
360	244	10	529.00	1	Delivered
361	245	1	9.99	2	Delivered
362	245	6	499.99	3	Delivered
363	245	4	7.99	1	Delivered
364	246	7	899.99	2	Delivered
365	247	3	27.99	1	Pending
366	248	4	7.99	1	Delivered
367	249	3	27.99	1	Delivered
368	250	5	5.99	1	Delivered
369	251	15	9.99	1	Delivered
370	252	10	529.00	1	Delivered
371	252	1	9.99	1	Delivered
372	253	10	529.00	1	Delivered
373	253	19	14.99	1	Delivered
374	253	7	899.99	5	Delivered
375	254	14	9.99	1	Delivered
376	255	5	5.99	1	Delivered
377	255	1	9.99	1	Delivered
378	256	12	9.99	2	Delivered
379	257	12	9.99	1	Delivered
380	258	6	499.99	1	Delivered
381	259	12	9.99	3	Delivered
382	260	12	9.99	1	Delivered
383	261	11	9.99	1	Delivered
384	261	6	499.99	1	Delivered
385	261	13	9.99	1	Delivered
386	262	4	7.99	2	Returned
387	262	7	899.99	1	Returned
388	263	2	29.99	1	Delivered
389	264	1	9.99	1	Delivered
390	265	13	9.99	1	Delivered
391	265	1	9.99	1	Delivered
392	266	12	9.99	1	Delivered
393	267	9	499.00	2	Delivered
394	268	17	14.99	1	Pending
395	269	20	14.99	3	Delivered
396	270	13	9.99	3	Delivered
397	271	10	529.00	1	Delivered
398	272	1	9.99	1	Delivered
399	272	17	14.99	1	Delivered
400	273	10	529.00	5	Delivered
401	274	17	14.99	1	Delivered
402	274	2	29.99	1	Delivered
403	275	18	14.99	2	Delivered
404	275	8	108.00	1	Delivered
405	275	8	108.00	3	Delivered
406	276	18	14.99	1	Delivered
407	277	15	9.99	1	Delivered
408	277	5	5.99	1	Delivered
409	278	10	529.00	1	Delivered
410	279	12	9.99	2	Delivered
411	280	20	14.99	1	Pending
412	281	20	14.99	1	Delivered
413	281	5	5.99	1	Delivered
414	281	20	14.99	1	Delivered
415	282	2	29.99	1	Delivered
416	283	7	899.99	1	Delivered
417	283	15	9.99	2	Delivered
418	284	10	529.00	1	Delivered
419	285	17	14.99	1	Delivered
420	285	5	5.99	1	Delivered
421	286	15	9.99	3	Delivered
422	286	5	5.99	2	Delivered
423	286	5	5.99	1	Delivered
424	287	5	5.99	1	Delivered
425	288	18	14.99	1	Delivered
426	289	12	9.99	1	Delivered
427	290	12	9.99	1	Pending
428	291	12	9.99	1	Delivered
429	292	13	9.99	2	Delivered
430	293	7	899.99	2	Delivered
431	293	12	9.99	1	Delivered
432	293	12	9.99	1	Delivered
433	294	12	9.99	1	Pending
434	295	7	899.99	4	Delivered
435	296	6	499.99	1	Delivered
436	296	3	27.99	1	Delivered
437	297	4	7.99	2	Delivered
438	297	16	14.99	2	Delivered
439	298	12	9.99	4	Delivered
440	299	7	899.99	1	Delivered
441	300	18	14.99	1	Delivered
442	301	9	499.00	1	Delivered
443	302	10	529.00	2	Returned
444	303	13	9.99	1	Returned
445	303	20	14.99	1	Returned
446	304	20	14.99	1	Delivered
447	305	8	108.00	1	Delivered
448	306	17	14.99	1	Returned
449	307	10	529.00	1	Delivered
450	308	16	14.99	1	Delivered
451	309	17	14.99	2	Delivered
452	310	18	14.99	1	Delivered
453	311	6	499.99	5	Delivered
454	311	14	9.99	1	Delivered
455	312	18	14.99	1	Delivered
456	313	11	9.99	4	Delivered
457	314	18	14.99	2	Delivered
458	315	5	5.99	1	Delivered
459	315	12	9.99	1	Delivered
460	316	7	899.99	3	Delivered
461	316	10	529.00	1	Delivered
462	317	18	14.99	1	Delivered
463	318	12	9.99	1	Delivered
464	319	5	5.99	1	Delivered
465	320	17	14.99	1	Delivered
466	321	13	9.99	1	Delivered
467	322	20	14.99	1	Delivered
468	323	20	14.99	1	Delivered
469	324	5	5.99	1	Delivered
470	325	3	27.99	1	Delivered
471	326	6	499.99	1	Delivered
472	327	4	7.99	1	Delivered
473	327	15	9.99	1	Delivered
474	328	2	29.99	1	Pending
475	329	20	14.99	1	Delivered
476	330	9	499.00	1	Delivered
477	331	4	7.99	1	Delivered
478	331	19	14.99	1	Delivered
479	331	2	29.99	1	Delivered
480	332	6	499.99	1	Delivered
481	333	5	5.99	1	Delivered
482	333	1	9.99	1	Delivered
483	333	2	29.99	4	Delivered
484	334	3	27.99	1	Delivered
485	335	6	499.99	1	Delivered
486	335	9	499.00	2	Delivered
487	336	2	29.99	1	Delivered
488	337	11	9.99	1	Delivered
489	338	12	9.99	1	Delivered
490	339	12	9.99	4	Delivered
491	339	6	499.99	1	Delivered
492	340	20	14.99	2	Delivered
493	340	2	29.99	2	Delivered
494	341	3	27.99	1	Delivered
495	341	10	529.00	1	Delivered
496	342	11	9.99	4	Delivered
497	342	4	7.99	1	Delivered
498	342	19	14.99	1	Delivered
499	343	11	9.99	1	Delivered
500	343	8	108.00	2	Delivered
501	344	14	9.99	1	Delivered
502	345	6	499.99	1	Delivered
503	345	17	14.99	1	Delivered
504	345	20	14.99	2	Delivered
505	346	2	29.99	1	Returned
506	347	14	9.99	1	Delivered
507	348	6	499.99	1	Delivered
508	348	10	529.00	1	Delivered
509	348	14	9.99	1	Delivered
510	349	10	529.00	1	Delivered
511	350	20	14.99	1	Returned
512	351	13	9.99	1	Delivered
513	351	3	27.99	1	Delivered
514	352	10	529.00	1	Delivered
515	352	12	9.99	1	Delivered
516	353	17	14.99	1	Delivered
517	353	18	14.99	1	Delivered
518	354	18	14.99	1	Delivered
519	355	5	5.99	1	Delivered
520	356	1	9.99	1	Delivered
521	357	18	14.99	1	Delivered
522	357	3	27.99	1	Delivered
523	358	13	9.99	2	Delivered
524	359	5	5.99	2	Delivered
525	359	13	9.99	1	Delivered
526	360	12	9.99	2	Delivered
527	361	2	29.99	2	Delivered
528	362	7	899.99	1	Delivered
529	363	8	108.00	1	Pending
530	363	6	499.99	1	Pending
531	363	19	14.99	2	Pending
532	364	18	14.99	2	Delivered
533	365	10	529.00	1	Pending
534	366	18	14.99	3	Delivered
535	367	20	14.99	2	Delivered
536	368	4	7.99	1	Returned
537	369	2	29.99	1	Delivered
538	369	16	14.99	5	Delivered
539	370	18	14.99	1	Returned
540	370	2	29.99	4	Returned
541	371	9	499.00	2	Delivered
542	372	13	9.99	1	Delivered
543	373	9	499.00	1	Delivered
544	374	2	29.99	2	Pending
545	375	15	9.99	1	Delivered
546	376	3	27.99	1	Delivered
547	377	6	499.99	2	Delivered
548	378	6	499.99	2	Delivered
549	379	2	29.99	5	Returned
550	379	14	9.99	1	Returned
551	380	18	14.99	1	Delivered
552	380	6	499.99	1	Delivered
553	381	19	14.99	5	Delivered
554	382	14	9.99	2	Delivered
555	383	16	14.99	1	Delivered
556	383	1	9.99	1	Delivered
557	384	1	9.99	2	Delivered
558	384	9	499.00	2	Delivered
559	385	17	14.99	4	Returned
560	385	1	9.99	1	Returned
561	386	17	14.99	5	Returned
562	387	1	9.99	1	Delivered
563	388	9	499.00	2	Delivered
564	388	11	9.99	2	Delivered
565	389	2	29.99	1	Delivered
566	390	14	9.99	2	Delivered
567	391	1	9.99	1	Delivered
568	392	2	29.99	2	Delivered
569	393	16	14.99	1	Delivered
570	394	4	7.99	2	Delivered
571	395	6	499.99	1	Delivered
572	396	14	9.99	2	Delivered
573	397	19	14.99	3	Delivered
574	397	10	529.00	5	Delivered
575	398	15	9.99	1	Delivered
576	398	17	14.99	1	Delivered
577	398	4	7.99	1	Delivered
578	399	17	14.99	1	Delivered
579	400	18	14.99	1	Delivered
580	401	17	14.99	1	Delivered
581	402	16	14.99	1	Delivered
582	403	8	108.00	1	Delivered
583	404	2	29.99	1	Delivered
584	404	12	9.99	2	Delivered
585	404	10	529.00	1	Delivered
586	405	12	9.99	1	Delivered
587	406	5	5.99	3	Delivered
588	406	5	5.99	1	Delivered
589	406	9	499.00	1	Delivered
590	407	6	499.99	1	Delivered
591	408	8	108.00	2	Delivered
592	409	16	14.99	1	Delivered
593	410	13	9.99	1	Pending
594	411	11	9.99	1	Delivered
595	411	18	14.99	1	Delivered
596	411	8	108.00	1	Delivered
597	412	9	499.00	1	Returned
598	413	20	14.99	1	Delivered
599	413	14	9.99	1	Delivered
600	414	12	9.99	1	Delivered
601	415	18	14.99	1	Delivered
602	416	4	7.99	2	Delivered
603	417	17	14.99	1	Pending
604	418	8	108.00	1	Delivered
605	418	12	9.99	1	Delivered
606	419	4	7.99	1	Delivered
607	419	13	9.99	5	Delivered
608	420	6	499.99	1	Delivered
609	421	1	9.99	1	Delivered
610	422	3	27.99	5	Delivered
611	423	9	499.00	2	Delivered
612	424	5	5.99	4	Delivered
613	425	4	7.99	5	Delivered
614	426	11	9.99	1	Delivered
615	427	5	5.99	1	Delivered
616	427	16	14.99	1	Delivered
617	427	1	9.99	1	Delivered
618	428	6	499.99	2	Pending
619	428	17	14.99	1	Pending
620	428	6	499.99	1	Pending
621	429	3	27.99	2	Delivered
622	430	13	9.99	2	Delivered
623	430	19	14.99	1	Delivered
624	431	1	9.99	1	Delivered
625	431	12	9.99	4	Delivered
626	431	19	14.99	1	Delivered
627	432	5	5.99	1	Delivered
628	433	18	14.99	4	Pending
629	433	8	108.00	1	Pending
630	434	2	29.99	1	Delivered
631	435	10	529.00	1	Delivered
632	436	1	9.99	1	Delivered
633	437	18	14.99	1	Delivered
634	437	19	14.99	1	Delivered
635	438	4	7.99	1	Delivered
636	438	18	14.99	1	Delivered
637	439	16	14.99	1	Delivered
638	440	6	499.99	1	Delivered
639	440	3	27.99	1	Delivered
640	441	14	9.99	2	Returned
641	441	15	9.99	2	Returned
642	442	10	529.00	5	Delivered
643	443	13	9.99	1	Delivered
644	444	12	9.99	4	Delivered
645	444	16	14.99	3	Delivered
646	444	19	14.99	1	Delivered
647	445	14	9.99	4	Delivered
648	445	9	499.00	1	Delivered
649	446	19	14.99	1	Returned
650	447	10	529.00	1	Delivered
651	448	2	29.99	1	Delivered
652	449	10	529.00	1	Delivered
653	450	7	899.99	1	Pending
654	451	7	899.99	1	Delivered
655	452	6	499.99	1	Delivered
656	452	3	27.99	1	Delivered
657	452	10	529.00	1	Delivered
658	453	8	108.00	5	Delivered
659	453	13	9.99	1	Delivered
660	453	7	899.99	2	Delivered
661	454	5	5.99	1	Delivered
662	454	8	108.00	3	Delivered
663	455	4	7.99	1	Delivered
664	456	4	7.99	1	Pending
665	456	9	499.00	2	Pending
666	456	20	14.99	3	Pending
667	457	19	14.99	1	Delivered
668	458	16	14.99	1	Delivered
669	459	19	14.99	1	Delivered
670	460	10	529.00	2	Delivered
671	460	20	14.99	2	Delivered
672	460	19	14.99	2	Delivered
673	461	2	29.99	1	Delivered
674	462	4	7.99	1	Delivered
675	463	8	108.00	3	Delivered
676	463	14	9.99	2	Delivered
677	464	16	14.99	1	Delivered
678	464	6	499.99	3	Delivered
679	464	3	27.99	2	Delivered
680	465	20	14.99	1	Delivered
681	466	5	5.99	1	Delivered
682	466	13	9.99	4	Delivered
683	466	13	9.99	1	Delivered
684	467	16	14.99	1	Delivered
685	467	7	899.99	1	Delivered
686	468	7	899.99	5	Delivered
687	469	16	14.99	1	Delivered
688	469	15	9.99	1	Delivered
689	470	11	9.99	1	Delivered
690	471	6	499.99	1	Delivered
691	472	4	7.99	1	Delivered
692	473	18	14.99	1	Delivered
693	473	1	9.99	3	Delivered
694	473	16	14.99	1	Delivered
695	474	14	9.99	2	Delivered
696	475	2	29.99	1	Delivered
697	476	6	499.99	1	Delivered
698	477	14	9.99	1	Delivered
699	477	17	14.99	2	Delivered
700	478	19	14.99	2	Delivered
701	479	17	14.99	2	Delivered
702	480	12	9.99	1	Delivered
703	481	1	9.99	4	Delivered
704	481	2	29.99	1	Delivered
705	482	20	14.99	1	Delivered
706	482	13	9.99	1	Delivered
707	482	2	29.99	1	Delivered
708	483	18	14.99	1	Delivered
709	484	12	9.99	1	Delivered
710	485	10	529.00	1	Delivered
711	485	3	27.99	2	Delivered
712	486	18	14.99	3	Delivered
713	487	16	14.99	1	Delivered
714	487	9	499.00	2	Delivered
715	488	15	9.99	1	Delivered
716	489	8	108.00	5	Delivered
717	489	15	9.99	1	Delivered
718	489	12	9.99	1	Delivered
719	490	9	499.00	5	Delivered
720	491	1	9.99	1	Pending
721	492	19	14.99	2	Returned
722	492	11	9.99	1	Returned
723	493	16	14.99	2	Returned
724	493	7	899.99	1	Returned
725	494	11	9.99	2	Delivered
726	494	13	9.99	1	Delivered
727	494	3	27.99	1	Delivered
728	495	14	9.99	1	Delivered
729	496	14	9.99	1	Delivered
730	497	16	14.99	2	Delivered
731	497	13	9.99	1	Delivered
732	498	7	899.99	1	Delivered
733	498	17	14.99	2	Delivered
734	499	11	9.99	1	Delivered
735	500	7	899.99	4	Delivered
736	501	20	14.99	1	Delivered
737	502	5	5.99	2	Delivered
738	503	14	9.99	1	Delivered
739	504	11	9.99	1	Delivered
740	505	8	108.00	1	Delivered
741	506	5	5.99	1	Pending
742	507	8	108.00	5	Delivered
743	507	20	14.99	1	Delivered
744	508	12	9.99	2	Delivered
745	509	10	529.00	1	Delivered
746	510	19	14.99	2	Delivered
747	510	1	9.99	1	Delivered
748	510	8	108.00	1	Delivered
749	511	17	14.99	1	Delivered
750	512	9	499.00	2	Delivered
751	513	4	7.99	1	Delivered
752	514	3	27.99	1	Delivered
753	514	1	9.99	2	Delivered
754	515	17	14.99	1	Delivered
755	516	1	9.99	1	Delivered
756	517	10	529.00	1	Delivered
757	518	14	9.99	1	Delivered
758	518	6	499.99	1	Delivered
759	519	18	14.99	1	Delivered
760	520	3	27.99	3	Delivered
761	520	16	14.99	1	Delivered
762	520	9	499.00	1	Delivered
763	521	1	9.99	2	Delivered
764	522	7	899.99	1	Delivered
765	522	8	108.00	1	Delivered
766	523	4	7.99	1	Delivered
767	524	3	27.99	2	Delivered
768	525	7	899.99	1	Delivered
769	526	2	29.99	1	Delivered
770	527	9	499.00	1	Delivered
771	528	12	9.99	1	Delivered
772	529	16	14.99	1	Delivered
773	529	10	529.00	1	Delivered
774	530	15	9.99	1	Delivered
775	531	18	14.99	5	Delivered
776	532	19	14.99	1	Delivered
777	532	14	9.99	1	Delivered
778	533	7	899.99	1	Delivered
779	534	19	14.99	1	Delivered
780	535	5	5.99	1	Delivered
781	536	7	899.99	1	Delivered
782	537	11	9.99	1	Delivered
783	538	20	14.99	1	Delivered
784	539	11	9.99	1	Delivered
785	539	19	14.99	5	Delivered
786	540	15	9.99	1	Delivered
787	541	8	108.00	2	Delivered
788	541	7	899.99	1	Delivered
789	542	11	9.99	2	Delivered
790	542	9	499.00	2	Delivered
791	542	8	108.00	1	Delivered
792	543	10	529.00	4	Delivered
793	544	8	108.00	1	Delivered
794	544	14	9.99	1	Delivered
795	544	1	9.99	1	Delivered
796	545	18	14.99	2	Delivered
797	546	14	9.99	1	Delivered
798	547	17	14.99	2	Delivered
799	547	8	108.00	1	Delivered
800	548	16	14.99	1	Delivered
801	548	13	9.99	1	Delivered
802	549	10	529.00	5	Delivered
803	550	17	14.99	2	Delivered
804	551	7	899.99	4	Delivered
805	552	18	14.99	1	Pending
806	553	16	14.99	1	Delivered
807	553	3	27.99	2	Delivered
808	553	20	14.99	1	Delivered
809	554	13	9.99	1	Pending
810	554	17	14.99	2	Pending
811	554	8	108.00	1	Pending
812	555	8	108.00	1	Delivered
813	556	13	9.99	1	Delivered
814	557	20	14.99	1	Delivered
815	558	1	9.99	1	Delivered
816	559	11	9.99	1	Delivered
817	559	17	14.99	1	Delivered
818	560	7	899.99	1	Delivered
819	561	15	9.99	1	Delivered
820	561	10	529.00	1	Delivered
821	561	9	499.00	2	Delivered
822	562	3	27.99	2	Delivered
823	563	4	7.99	3	Delivered
824	563	20	14.99	1	Delivered
825	564	8	108.00	1	Delivered
826	565	5	5.99	2	Pending
827	566	18	14.99	1	Delivered
828	567	16	14.99	1	Delivered
829	568	3	27.99	3	Delivered
830	568	4	7.99	1	Delivered
831	569	1	9.99	5	Pending
832	570	6	499.99	3	Delivered
833	570	5	5.99	2	Delivered
834	571	8	108.00	1	Delivered
835	572	6	499.99	4	Delivered
836	573	12	9.99	1	Delivered
837	574	17	14.99	1	Delivered
838	575	17	14.99	1	Delivered
839	575	9	499.00	2	Delivered
840	575	9	499.00	2	Delivered
841	576	1	9.99	1	Delivered
842	576	3	27.99	1	Delivered
843	577	7	899.99	1	Delivered
844	578	12	9.99	2	Delivered
845	578	1	9.99	1	Delivered
846	579	17	14.99	1	Delivered
847	580	6	499.99	1	Delivered
848	581	16	14.99	1	Pending
849	581	4	7.99	1	Pending
850	581	4	7.99	1	Pending
851	582	1	9.99	1	Delivered
852	583	17	14.99	1	Returned
853	583	14	9.99	1	Returned
854	584	3	27.99	2	Delivered
855	585	16	14.99	2	Delivered
856	586	4	7.99	2	Delivered
857	586	5	5.99	1	Delivered
858	586	15	9.99	1	Delivered
859	587	20	14.99	1	Delivered
860	587	10	529.00	1	Delivered
861	587	14	9.99	1	Delivered
862	588	1	9.99	1	Delivered
863	588	19	14.99	1	Delivered
864	589	16	14.99	3	Delivered
865	590	7	899.99	1	Delivered
866	591	3	27.99	1	Delivered
867	592	9	499.00	1	Delivered
868	593	13	9.99	1	Delivered
869	593	8	108.00	2	Delivered
870	594	7	899.99	1	Pending
871	595	1	9.99	4	Delivered
872	596	6	499.99	1	Delivered
873	596	10	529.00	1	Delivered
874	596	15	9.99	1	Delivered
875	597	9	499.00	1	Delivered
876	598	14	9.99	2	Delivered
877	599	9	499.00	2	Delivered
878	600	20	14.99	3	Pending
879	601	12	9.99	5	Delivered
880	601	12	9.99	4	Delivered
881	601	20	14.99	1	Delivered
882	602	20	14.99	1	Delivered
883	603	11	9.99	1	Delivered
884	604	5	5.99	1	Delivered
885	605	17	14.99	2	Delivered
886	605	14	9.99	1	Delivered
887	605	12	9.99	1	Delivered
888	606	9	499.00	1	Delivered
889	607	2	29.99	1	Returned
890	607	8	108.00	2	Returned
891	608	7	899.99	1	Delivered
892	608	8	108.00	1	Delivered
893	608	20	14.99	1	Delivered
894	609	10	529.00	3	Delivered
895	610	8	108.00	1	Delivered
896	611	11	9.99	1	Delivered
897	611	15	9.99	1	Delivered
898	611	8	108.00	1	Delivered
899	612	18	14.99	2	Delivered
900	612	7	899.99	1	Delivered
901	612	2	29.99	1	Delivered
902	613	14	9.99	1	Delivered
903	614	2	29.99	1	Delivered
904	615	2	29.99	3	Delivered
905	616	2	29.99	2	Delivered
906	616	20	14.99	1	Delivered
907	617	13	9.99	1	Delivered
908	618	4	7.99	5	Delivered
909	619	9	499.00	1	Delivered
910	620	19	14.99	1	Delivered
911	621	16	14.99	2	Delivered
912	622	9	499.00	1	Delivered
913	623	5	5.99	1	Delivered
914	624	1	9.99	1	Delivered
915	625	10	529.00	1	Delivered
916	626	1	9.99	1	Delivered
917	626	1	9.99	1	Delivered
918	626	13	9.99	1	Delivered
919	627	10	529.00	1	Delivered
920	628	15	9.99	1	Delivered
921	629	2	29.99	1	Delivered
922	630	8	108.00	3	Delivered
923	631	15	9.99	1	Delivered
924	632	17	14.99	1	Delivered
925	633	4	7.99	1	Returned
926	634	4	7.99	1	Pending
927	635	3	27.99	3	Delivered
928	636	11	9.99	1	Delivered
929	637	17	14.99	1	Delivered
930	638	13	9.99	2	Returned
931	639	19	14.99	2	Delivered
932	640	3	27.99	2	Delivered
933	641	15	9.99	1	Delivered
934	642	20	14.99	1	Delivered
935	642	1	9.99	2	Delivered
936	642	12	9.99	3	Delivered
937	643	15	9.99	1	Delivered
938	644	14	9.99	1	Delivered
939	645	16	14.99	1	Delivered
940	645	16	14.99	1	Delivered
941	645	6	499.99	4	Delivered
942	646	13	9.99	1	Delivered
943	647	17	14.99	4	Delivered
944	648	9	499.00	2	Delivered
945	648	16	14.99	1	Delivered
946	649	6	499.99	1	Delivered
947	649	1	9.99	1	Delivered
948	650	10	529.00	1	Returned
949	651	7	899.99	3	Delivered
950	652	10	529.00	1	Delivered
951	653	15	9.99	1	Delivered
952	654	16	14.99	1	Delivered
953	655	2	29.99	3	Delivered
954	656	11	9.99	1	Delivered
955	656	9	499.00	2	Delivered
956	656	14	9.99	1	Delivered
957	657	14	9.99	1	Delivered
958	657	20	14.99	1	Delivered
959	658	4	7.99	1	Delivered
960	658	18	14.99	1	Delivered
961	658	4	7.99	1	Delivered
962	659	14	9.99	3	Delivered
963	659	13	9.99	1	Delivered
964	660	17	14.99	1	Delivered
965	661	15	9.99	1	Delivered
966	662	17	14.99	5	Returned
967	663	13	9.99	1	Delivered
968	663	1	9.99	1	Delivered
969	664	2	29.99	5	Delivered
970	665	11	9.99	1	Delivered
971	666	6	499.99	2	Returned
972	667	9	499.00	2	Delivered
973	668	5	5.99	4	Returned
974	669	18	14.99	1	Returned
975	670	1	9.99	2	Delivered
976	671	3	27.99	3	Delivered
977	671	11	9.99	1	Delivered
978	672	12	9.99	1	Delivered
979	672	4	7.99	2	Delivered
980	673	11	9.99	1	Delivered
981	673	17	14.99	1	Delivered
982	674	20	14.99	1	Delivered
983	674	9	499.00	1	Delivered
984	675	10	529.00	1	Delivered
985	676	20	14.99	1	Delivered
986	676	14	9.99	1	Delivered
987	677	2	29.99	1	Delivered
988	678	8	108.00	1	Delivered
989	678	14	9.99	1	Delivered
990	678	4	7.99	1	Delivered
991	679	1	9.99	2	Delivered
992	679	18	14.99	2	Delivered
993	679	16	14.99	1	Delivered
994	680	6	499.99	1	Delivered
995	680	2	29.99	2	Delivered
996	680	13	9.99	3	Delivered
997	681	17	14.99	3	Delivered
998	682	9	499.00	1	Delivered
999	683	10	529.00	2	Delivered
1000	684	20	14.99	1	Delivered
1001	685	17	14.99	1	Delivered
1002	686	18	14.99	1	Delivered
1003	686	2	29.99	3	Delivered
1004	686	4	7.99	5	Delivered
1005	687	17	14.99	1	Delivered
1006	688	16	14.99	1	Delivered
1007	689	19	14.99	1	Delivered
1008	689	9	499.00	1	Delivered
1009	689	6	499.99	1	Delivered
1010	690	17	14.99	4	Delivered
1011	691	4	7.99	3	Delivered
1012	692	10	529.00	2	Delivered
1013	692	9	499.00	2	Delivered
1014	693	19	14.99	1	Delivered
1015	694	6	499.99	1	Delivered
1016	695	3	27.99	1	Pending
1017	696	14	9.99	1	Delivered
1018	696	11	9.99	4	Delivered
1019	696	3	27.99	1	Delivered
1020	697	7	899.99	1	Delivered
1021	697	2	29.99	1	Delivered
1022	697	17	14.99	1	Delivered
1023	698	13	9.99	1	Delivered
1024	698	4	7.99	1	Delivered
1025	698	19	14.99	1	Delivered
1026	699	6	499.99	1	Delivered
1027	700	8	108.00	2	Delivered
1028	701	14	9.99	4	Delivered
1029	702	3	27.99	1	Delivered
1030	702	13	9.99	1	Delivered
1031	703	7	899.99	1	Delivered
1032	704	4	7.99	5	Delivered
1033	705	20	14.99	1	Delivered
1034	705	14	9.99	1	Delivered
1035	706	8	108.00	1	Delivered
1036	706	5	5.99	1	Delivered
1037	707	2	29.99	1	Delivered
1038	708	17	14.99	1	Delivered
1039	709	4	7.99	1	Delivered
1040	709	17	14.99	1	Delivered
1041	709	6	499.99	1	Delivered
1042	710	18	14.99	1	Delivered
1043	711	16	14.99	1	Delivered
1044	712	14	9.99	1	Delivered
1045	712	19	14.99	1	Delivered
1046	712	20	14.99	1	Delivered
1047	713	6	499.99	2	Delivered
1048	713	7	899.99	2	Delivered
1049	713	6	499.99	5	Delivered
1050	714	16	14.99	3	Delivered
1051	715	9	499.00	4	Delivered
1052	716	19	14.99	1	Delivered
1053	717	11	9.99	1	Delivered
1054	717	15	9.99	1	Delivered
1055	718	9	499.00	5	Delivered
1056	718	12	9.99	3	Delivered
1057	719	10	529.00	1	Delivered
1058	720	12	9.99	1	Delivered
1059	721	8	108.00	1	Delivered
1060	722	10	529.00	1	Delivered
1061	723	4	7.99	1	Delivered
1062	723	6	499.99	1	Delivered
1063	724	13	9.99	1	Delivered
1064	725	3	27.99	2	Delivered
1065	726	12	9.99	2	Delivered
1066	727	16	14.99	2	Delivered
1067	728	12	9.99	1	Delivered
1068	728	13	9.99	1	Delivered
1069	728	19	14.99	2	Delivered
1070	729	5	5.99	1	Delivered
1071	730	2	29.99	1	Delivered
1072	731	12	9.99	1	Delivered
1073	732	8	108.00	1	Delivered
1074	733	16	14.99	1	Delivered
1075	734	2	29.99	1	Pending
1076	734	9	499.00	1	Pending
1077	735	14	9.99	4	Delivered
1078	735	5	5.99	1	Delivered
1079	736	6	499.99	1	Delivered
1080	737	20	14.99	3	Delivered
1081	737	9	499.00	1	Delivered
1082	738	13	9.99	1	Delivered
1083	738	8	108.00	1	Delivered
1084	739	13	9.99	1	Delivered
1085	740	17	14.99	2	Pending
1086	740	4	7.99	2	Pending
1087	741	20	14.99	1	Delivered
1088	742	1	9.99	1	Delivered
1089	743	4	7.99	1	Delivered
1090	743	13	9.99	5	Delivered
1091	744	14	9.99	2	Pending
1092	744	5	5.99	1	Pending
1093	744	16	14.99	2	Pending
1094	745	16	14.99	1	Delivered
1095	746	4	7.99	1	Delivered
1096	746	20	14.99	1	Delivered
1097	747	19	14.99	1	Delivered
1098	748	15	9.99	1	Delivered
1099	749	16	14.99	1	Pending
1100	750	9	499.00	2	Pending
1101	751	16	14.99	4	Delivered
1102	752	8	108.00	3	Delivered
1103	753	12	9.99	1	Delivered
1104	753	1	9.99	2	Delivered
1105	754	13	9.99	4	Delivered
1106	755	2	29.99	1	Delivered
1107	755	13	9.99	1	Delivered
1108	755	18	14.99	1	Delivered
1109	756	5	5.99	3	Delivered
1110	756	19	14.99	1	Delivered
1111	756	11	9.99	1	Delivered
1112	757	1	9.99	1	Delivered
1113	758	9	499.00	1	Delivered
1114	759	4	7.99	1	Returned
1115	759	3	27.99	1	Returned
1116	760	8	108.00	1	Pending
1117	761	20	14.99	2	Delivered
1118	761	20	14.99	5	Delivered
1119	761	3	27.99	1	Delivered
1120	762	17	14.99	1	Delivered
1121	763	17	14.99	1	Delivered
1122	764	14	9.99	1	Delivered
1123	765	5	5.99	2	Delivered
1124	766	12	9.99	2	Pending
1125	767	10	529.00	2	Delivered
1126	767	1	9.99	2	Delivered
1127	768	14	9.99	4	Delivered
1128	769	12	9.99	1	Delivered
1129	770	14	9.99	1	Delivered
1130	771	2	29.99	1	Delivered
1131	772	1	9.99	2	Pending
1132	772	11	9.99	1	Pending
1133	773	4	7.99	1	Delivered
1134	774	14	9.99	2	Delivered
1135	775	13	9.99	5	Returned
1136	776	17	14.99	2	Delivered
1137	777	4	7.99	5	Delivered
1138	777	18	14.99	2	Delivered
1139	778	14	9.99	5	Delivered
1140	778	10	529.00	1	Delivered
1141	779	16	14.99	1	Delivered
1142	779	13	9.99	1	Delivered
1143	780	7	899.99	1	Delivered
1144	781	18	14.99	2	Delivered
1145	782	18	14.99	1	Delivered
1146	782	12	9.99	1	Delivered
1147	782	16	14.99	1	Delivered
1148	783	6	499.99	1	Delivered
1149	784	15	9.99	3	Delivered
1150	784	6	499.99	1	Delivered
1151	785	8	108.00	4	Delivered
1152	786	14	9.99	2	Delivered
1153	787	18	14.99	3	Returned
1154	788	13	9.99	1	Delivered
1155	789	1	9.99	1	Delivered
1156	790	16	14.99	1	Delivered
1157	790	9	499.00	2	Delivered
1158	791	10	529.00	2	Delivered
1159	792	12	9.99	1	Delivered
1160	792	6	499.99	1	Delivered
1161	793	13	9.99	4	Returned
1162	794	3	27.99	1	Delivered
1163	795	16	14.99	1	Delivered
1164	796	7	899.99	1	Delivered
1165	796	17	14.99	3	Delivered
1166	796	6	499.99	1	Delivered
1167	797	3	27.99	2	Delivered
1168	798	8	108.00	1	Delivered
1169	799	10	529.00	1	Delivered
1170	800	9	499.00	1	Returned
1171	800	9	499.00	5	Returned
1172	801	15	9.99	4	Delivered
1173	802	3	27.99	1	Delivered
1174	802	14	9.99	1	Delivered
1175	803	6	499.99	1	Delivered
1176	804	6	499.99	1	Delivered
1177	805	15	9.99	1	Returned
1178	806	8	108.00	1	Delivered
1179	807	16	14.99	1	Delivered
1180	808	15	9.99	1	Delivered
1181	809	20	14.99	1	Delivered
1182	810	13	9.99	1	Delivered
1183	810	16	14.99	2	Delivered
1184	811	3	27.99	1	Delivered
1185	811	16	14.99	3	Delivered
1186	812	3	27.99	1	Delivered
1187	812	16	14.99	1	Delivered
1188	813	15	9.99	1	Delivered
1189	813	14	9.99	1	Delivered
1190	813	11	9.99	3	Delivered
1191	814	7	899.99	1	Delivered
1192	815	5	5.99	3	Delivered
1193	815	4	7.99	1	Delivered
1194	816	14	9.99	1	Returned
1195	817	1	9.99	1	Delivered
1196	817	17	14.99	1	Delivered
1197	817	10	529.00	1	Delivered
1198	818	16	14.99	4	Delivered
1199	819	2	29.99	1	Delivered
1200	819	19	14.99	1	Delivered
1201	820	11	9.99	2	Delivered
1202	821	11	9.99	1	Delivered
1203	822	12	9.99	2	Delivered
1204	823	3	27.99	1	Delivered
1205	824	15	9.99	1	Delivered
1206	825	7	899.99	1	Delivered
1207	826	6	499.99	4	Delivered
1208	827	5	5.99	1	Delivered
1209	828	10	529.00	1	Delivered
1210	829	1	9.99	4	Delivered
1211	829	3	27.99	1	Delivered
1212	830	12	9.99	2	Delivered
1213	830	4	7.99	1	Delivered
1214	831	2	29.99	1	Delivered
1215	831	13	9.99	4	Delivered
1216	832	16	14.99	5	Delivered
1217	833	1	9.99	4	Delivered
1218	834	3	27.99	2	Delivered
1219	834	5	5.99	2	Delivered
1220	834	20	14.99	1	Delivered
1221	835	20	14.99	1	Delivered
1222	836	13	9.99	1	Delivered
1223	837	20	14.99	2	Delivered
1224	838	13	9.99	5	Delivered
1225	839	20	14.99	4	Delivered
1226	839	5	5.99	2	Delivered
1227	840	10	529.00	2	Delivered
1228	840	3	27.99	2	Delivered
1229	841	20	14.99	2	Delivered
1230	842	13	9.99	1	Delivered
1231	842	12	9.99	1	Delivered
1232	843	11	9.99	1	Delivered
1233	844	17	14.99	1	Delivered
1234	845	18	14.99	1	Delivered
1235	846	16	14.99	1	Returned
1236	847	12	9.99	1	Returned
1237	848	20	14.99	1	Delivered
1238	848	8	108.00	1	Delivered
1239	849	14	9.99	4	Delivered
1240	850	14	9.99	1	Delivered
1241	851	8	108.00	1	Delivered
1242	852	3	27.99	1	Delivered
1243	852	4	7.99	1	Delivered
1244	853	5	5.99	3	Returned
1245	853	18	14.99	5	Returned
1246	853	5	5.99	1	Returned
1247	854	3	27.99	1	Delivered
1248	854	15	9.99	1	Delivered
1249	855	18	14.99	1	Delivered
1250	855	1	9.99	1	Delivered
1251	856	14	9.99	1	Delivered
1252	857	9	499.00	1	Delivered
1253	858	5	5.99	1	Delivered
1254	859	7	899.99	1	Delivered
1255	860	13	9.99	1	Delivered
1256	860	12	9.99	2	Delivered
1257	861	18	14.99	2	Delivered
1258	862	18	14.99	2	Delivered
1259	862	5	5.99	1	Delivered
1260	863	17	14.99	1	Delivered
1261	863	9	499.00	2	Delivered
1262	864	15	9.99	2	Delivered
1263	865	13	9.99	1	Delivered
1264	866	4	7.99	1	Delivered
1265	867	1	9.99	1	Delivered
1266	868	7	899.99	1	Delivered
1267	869	18	14.99	2	Delivered
1268	870	4	7.99	1	Returned
1269	871	11	9.99	3	Delivered
1270	872	12	9.99	4	Delivered
1271	873	6	499.99	3	Delivered
1272	874	20	14.99	2	Delivered
1273	875	7	899.99	1	Delivered
1274	875	13	9.99	2	Delivered
1275	876	14	9.99	1	Delivered
1276	876	17	14.99	3	Delivered
1277	877	5	5.99	2	Delivered
1278	878	13	9.99	1	Delivered
1279	879	4	7.99	1	Delivered
1280	880	8	108.00	2	Delivered
1281	881	20	14.99	1	Returned
1282	882	9	499.00	2	Delivered
1283	883	17	14.99	5	Delivered
1284	884	13	9.99	4	Delivered
1285	884	8	108.00	1	Delivered
1286	885	2	29.99	1	Pending
1287	886	13	9.99	1	Delivered
1288	887	14	9.99	1	Delivered
1289	887	18	14.99	1	Delivered
1290	887	13	9.99	1	Delivered
1291	888	12	9.99	1	Delivered
1292	888	11	9.99	3	Delivered
1293	888	19	14.99	1	Delivered
1294	889	10	529.00	5	Delivered
1295	890	2	29.99	1	Delivered
1296	891	5	5.99	2	Delivered
1297	892	15	9.99	1	Delivered
1298	893	12	9.99	1	Pending
1299	894	15	9.99	1	Delivered
1300	895	8	108.00	2	Delivered
1301	896	13	9.99	1	Delivered
1302	897	15	9.99	2	Delivered
1303	898	6	499.99	1	Delivered
1304	898	2	29.99	3	Delivered
1305	898	2	29.99	1	Delivered
1306	899	15	9.99	2	Delivered
1307	900	3	27.99	3	Delivered
1308	901	20	14.99	1	Pending
1309	901	2	29.99	1	Pending
1310	902	4	7.99	2	Delivered
1311	903	2	29.99	1	Delivered
1312	903	15	9.99	1	Delivered
1313	904	14	9.99	1	Returned
1314	904	6	499.99	3	Returned
1315	904	5	5.99	2	Returned
1316	905	16	14.99	3	Delivered
1317	905	2	29.99	2	Delivered
1318	906	5	5.99	1	Delivered
1319	907	13	9.99	1	Delivered
1320	908	5	5.99	2	Delivered
1321	909	2	29.99	4	Delivered
1322	909	12	9.99	1	Delivered
1323	909	19	14.99	2	Delivered
1324	910	19	14.99	1	Delivered
1325	911	9	499.00	1	Delivered
1326	912	13	9.99	1	Delivered
1327	913	12	9.99	1	Delivered
1328	913	6	499.99	2	Delivered
1329	913	4	7.99	1	Delivered
1330	914	9	499.00	2	Delivered
1331	915	12	9.99	3	Returned
1332	916	6	499.99	5	Delivered
1333	917	13	9.99	1	Delivered
1334	918	8	108.00	1	Delivered
1335	918	12	9.99	1	Delivered
1336	918	1	9.99	1	Delivered
1337	919	16	14.99	1	Delivered
1338	920	4	7.99	1	Delivered
1339	921	19	14.99	1	Delivered
1340	922	5	5.99	1	Delivered
1341	923	10	529.00	1	Delivered
1342	924	8	108.00	4	Delivered
1343	924	12	9.99	1	Delivered
1344	925	6	499.99	1	Delivered
1345	926	1	9.99	2	Delivered
1346	926	13	9.99	1	Delivered
1347	927	10	529.00	2	Delivered
1348	928	16	14.99	1	Delivered
1349	929	1	9.99	1	Delivered
1350	930	5	5.99	2	Delivered
1351	931	17	14.99	2	Pending
1352	931	1	9.99	1	Pending
1353	931	16	14.99	1	Pending
1354	932	6	499.99	1	Delivered
1355	933	3	27.99	1	Returned
1356	934	9	499.00	1	Delivered
1357	935	10	529.00	5	Delivered
1358	935	15	9.99	2	Delivered
1359	935	3	27.99	2	Delivered
1360	936	9	499.00	5	Pending
1361	936	6	499.99	1	Pending
1362	936	16	14.99	3	Pending
1363	937	9	499.00	1	Delivered
1364	938	8	108.00	1	Delivered
1365	939	1	9.99	3	Delivered
1366	940	15	9.99	1	Delivered
1367	941	15	9.99	1	Delivered
1368	941	6	499.99	1	Delivered
1369	941	11	9.99	1	Delivered
1370	942	18	14.99	4	Delivered
1371	943	19	14.99	1	Delivered
1372	944	4	7.99	1	Delivered
1373	944	19	14.99	1	Delivered
1374	945	15	9.99	2	Delivered
1375	946	4	7.99	2	Returned
1376	946	16	14.99	1	Returned
1377	946	12	9.99	2	Returned
1378	947	12	9.99	1	Delivered
1379	948	17	14.99	3	Delivered
1380	949	19	14.99	1	Delivered
1381	950	11	9.99	2	Delivered
1382	951	6	499.99	1	Delivered
1383	951	2	29.99	1	Delivered
1384	951	2	29.99	1	Delivered
1385	952	9	499.00	1	Delivered
1386	953	1	9.99	1	Delivered
1387	954	15	9.99	1	Delivered
1388	955	6	499.99	2	Delivered
1389	956	9	499.00	1	Delivered
1390	956	6	499.99	2	Delivered
1391	957	11	9.99	1	Delivered
1392	958	1	9.99	1	Delivered
1393	959	10	529.00	1	Delivered
1394	960	1	9.99	1	Delivered
1395	961	13	9.99	1	Delivered
1396	961	14	9.99	1	Delivered
1397	961	7	899.99	1	Delivered
1398	962	17	14.99	1	Delivered
1399	963	11	9.99	1	Delivered
1400	963	3	27.99	4	Delivered
1401	963	7	899.99	4	Delivered
1402	964	8	108.00	1	Delivered
1403	965	14	9.99	1	Delivered
1404	966	18	14.99	5	Delivered
1405	967	18	14.99	5	Delivered
1406	967	13	9.99	1	Delivered
1407	967	19	14.99	1	Delivered
1408	968	8	108.00	1	Returned
1409	969	2	29.99	2	Delivered
1410	969	5	5.99	4	Delivered
1411	970	18	14.99	2	Delivered
1412	970	16	14.99	1	Delivered
1413	971	10	529.00	1	Delivered
1414	971	10	529.00	5	Delivered
1415	972	8	108.00	5	Delivered
1416	973	11	9.99	1	Delivered
1417	973	19	14.99	1	Delivered
1418	974	3	27.99	1	Delivered
1419	975	17	14.99	5	Pending
1420	975	2	29.99	2	Pending
1421	976	4	7.99	1	Delivered
1422	976	17	14.99	1	Delivered
1423	976	3	27.99	1	Delivered
1424	977	10	529.00	2	Delivered
1425	978	16	14.99	1	Delivered
1426	979	12	9.99	1	Pending
1427	979	9	499.00	2	Pending
1428	980	14	9.99	5	Delivered
1429	981	8	108.00	4	Delivered
1430	982	7	899.99	2	Delivered
1431	983	2	29.99	1	Delivered
1432	984	16	14.99	1	Delivered
1433	985	4	7.99	1	Delivered
1434	985	9	499.00	1	Delivered
1435	986	20	14.99	1	Delivered
1436	987	4	7.99	1	Delivered
1437	988	7	899.99	1	Delivered
1438	988	17	14.99	1	Delivered
1439	988	17	14.99	1	Delivered
1440	989	14	9.99	1	Delivered
1441	990	20	14.99	1	Delivered
1442	990	5	5.99	4	Delivered
1443	990	11	9.99	5	Delivered
1444	991	11	9.99	1	Delivered
1445	992	14	9.99	1	Pending
1446	993	18	14.99	1	Delivered
1447	993	17	14.99	1	Delivered
1448	994	5	5.99	1	Delivered
1449	995	2	29.99	2	Delivered
1450	996	8	108.00	1	Delivered
1451	996	18	14.99	2	Delivered
1452	996	14	9.99	1	Delivered
1453	997	5	5.99	4	Delivered
1454	998	1	9.99	4	Pending
1455	998	16	14.99	2	Pending
1456	998	2	29.99	2	Pending
1457	999	5	5.99	1	Delivered
1458	999	16	14.99	1	Delivered
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: craig
--

COPY purchases (id, created_at, name, address, state, zipcode, user_id) FROM stdin;
1	2011-03-16 08:03:00-07	Harrison Jonson	6425 43rd St.	FL	50382	7
2	2011-09-13 22:00:00-07	Cortney Fontanilla	321 MLK Ave.	WA	43895	30
3	2011-09-10 22:54:00-07	Ruthie Vashon	2307 45th St.	GA	98937	18
4	2011-02-27 12:53:00-08	Isabel Wynn	7046 10th Ave.	NY	57243	11
5	2011-12-20 04:45:00-08	Shari Dutra	4046 8th Ave.	FL	61539	34
6	2011-12-10 05:29:00-08	Kristofer Galvez	2545 8th Ave.	WA	83868	39
7	2011-06-18 20:42:00-07	Maudie Medlen	2049 44th Ave.	FL	52107	8
8	2011-05-27 18:19:00-07	Isabel Crissman	1992 50th Ave.	VA	91062	50
9	2011-03-31 03:33:00-07	Nydia Moe	5847 50th Ave.	WY	86738	32
10	2011-01-26 20:58:00-08	Dee Heavner	8021 8th Ave.	TX	11065	23
11	2011-12-14 17:12:00-08	Kristofer Larimer	5574 43rd St.	NY	78804	45
12	2011-01-21 18:06:00-08	Rosemary Letellier	9888 California St.	CO	59199	25
13	2011-08-14 12:27:00-07	Becky Stukes	7470 Washington Ave.	CO	49527	33
14	2011-07-12 12:29:00-07	Berta Fruchter	3528 31st St.	GA	64386	5
15	2011-08-02 07:37:00-07	Adell Doyel	1549 50th Ave.	VA	73935	9
16	2011-03-24 03:04:00-07	Bradly Vasko	4388 45th St.	NY	84583	22
17	2011-09-18 01:55:00-07	Clemencia Durio	478 44th Ave.	TX	27038	27
18	2011-02-24 11:42:00-08	Kristle Pung	8394 8th Ave.	IL	67659	36
19	2011-04-19 10:51:00-07	Adell Mayon	1482 31st St.	TX	72775	28
20	2011-01-20 09:52:00-08	Carolann Yoshimura	9520 Washington Ave.	GA	20503	37
21	2011-07-07 07:41:00-07	Andres Schippers	9600 44th Ave.	CO	62899	8
22	2011-03-05 14:53:00-08	Divina Hamill	2103 50th Ave.	CO	73210	45
23	2011-12-22 05:39:00-08	Romaine Coderre	6990 Washington Ave.	VA	31853	39
24	2011-12-20 15:44:00-08	Kourtney Julian	8277 44th Ave.	VA	67133	37
25	2011-05-30 10:49:00-07	Danyel Styers	8464 8th Ave.	WA	56917	9
26	2011-12-23 18:29:00-08	Jame Petrin	410 44th Ave.	SC	94048	11
27	2011-02-28 07:00:00-08	Kimi Birdsell	2438 50th Ave.	CO	58337	17
28	2011-10-14 09:27:00-07	Jame Heavner	5307 43rd St.	TX	81439	34
29	2011-07-08 15:20:00-07	Cammy Mayon	8612 Washington Ave.	NY	79807	8
30	2011-05-24 01:03:00-07	Tommie Lanser	3673 10th Ave.	WY	50519	27
31	2011-03-30 14:44:00-07	Brandon Fruchter	8354 Washington Ave.	NY	50274	43
32	2011-01-12 08:26:00-08	Ricarda Pressey	6479 31st St.	TX	95407	48
33	2011-11-01 14:34:00-07	Shalon Fontanilla	7271 50th Ave.	IL	71634	25
34	2011-09-10 19:23:00-07	Edmund Pressnell	1644 31st St.	TX	63152	5
35	2011-01-14 03:25:00-08	Homer Gasper	6472 46th Ave.	IL	86204	18
36	2011-10-23 11:14:00-07	Brady Harshberger	1510 45th St.	VA	94138	37
37	2011-06-20 14:37:00-07	Clemencia Matheson	204 California St.	CO	59664	47
38	2011-04-06 23:52:00-07	Danyel Sisemore	5944 43rd St.	CO	62994	20
39	2011-01-31 07:27:00-08	Laurence Kump	3057 43rd St.	IL	95353	15
40	2011-11-01 15:01:00-07	Mitchell Pellegrin	7896 MLK Ave.	CO	55259	40
41	2011-02-17 22:06:00-08	Emely Kimball	9162 MLK Ave.	GA	10585	24
42	2011-10-29 12:36:00-07	Russ Petrin	6719 Washington Ave.	IL	75651	48
43	2011-07-03 19:28:00-07	Miyoko Allbright	6824 35th St.42nd Ave.	WA	77819	44
44	2011-03-15 01:42:00-07	Becky Wassink	4144 10th Ave.	WY	89509	49
45	2011-11-10 17:22:00-08	Harley Dement	3438 44th Ave.	GA	34758	42
46	2011-05-16 13:41:00-07	Mirta Alba	5171 10th Ave.	VA	67003	16
47	2011-08-31 18:01:00-07	Buford Yoshimura	7387 35th St.42nd Ave.	IL	84086	18
48	2011-05-29 11:37:00-07	Ruthie Tartaglia	2370 8th Ave.	TX	13848	50
49	2011-05-21 17:02:00-07	Colleen Mcqueeney	8125 50th Ave.	NY	51760	9
50	2011-10-11 15:53:00-07	Minerva Iriarte	9165 44th Ave.	IL	83449	27
51	2011-10-19 17:28:00-07	Beverlee Mcdougle	5912 44th Ave.	WY	72995	23
52	2011-10-07 22:19:00-07	Danyel Kipp	3085 31st St.	GA	44471	35
53	2011-06-08 19:58:00-07	Miyoko Emmerich	6214 MLK Ave.	SC	92365	15
54	2011-08-23 12:51:00-07	Colleen Connors	8948 46th Ave.	CO	16281	23
55	2011-01-02 13:54:00-08	Milda Rabb	2727 43rd St.	VA	12546	24
56	2011-08-25 16:55:00-07	Rivka Pressnell	2623 8th Ave.	WA	58091	10
57	2011-01-02 17:49:00-08	Letitia Sprau	2106 Washington Ave.	IL	76898	1
58	2011-08-31 00:41:00-07	Wendie Dilks	463 46th Ave.	NY	30838	41
59	2011-01-24 14:11:00-08	Williams Alber	9289 Washington Ave.	NY	20505	31
60	2011-12-17 04:59:00-08	Ricarda Nowakowski	3434 Washington Ave.	CO	53662	43
61	2011-08-23 07:28:00-07	Irma Currier	6494 Washington Ave.	NY	98527	2
62	2011-02-15 19:00:00-08	Salvatore Lightcap	7496 10th Ave.	SC	75435	6
63	2011-04-28 13:22:00-07	Sol Fruchter	7295 10th Ave.	VA	50135	13
64	2011-10-05 20:50:00-07	Nana Arends	6812 43rd St.	SC	48227	16
65	2011-07-06 10:51:00-07	Brandon Roth	7583 35th St.42nd Ave.	TX	17570	29
66	2011-09-04 03:32:00-07	Graig Sturgill	8547 45th St.	CO	67015	29
67	2011-12-29 04:45:00-08	Lawerence Roff	8555 31st St.	NY	60022	35
68	2011-04-29 13:05:00-07	Jenee Haefner	2232 43rd St.	FL	51498	20
69	2011-03-29 14:35:00-07	Karole Calico	6659 Washington Ave.	VA	58202	14
70	2011-04-07 03:43:00-07	Buddy Doyel	656 35th St.42nd Ave.	FL	89794	29
71	2011-07-26 07:06:00-07	Ozella Selden	4063 8th Ave.	GA	28335	37
72	2011-06-10 02:18:00-07	Mauro Allbright	9344 44th Ave.	IL	47037	7
73	2011-03-01 08:56:00-08	Salvatore Kimball	8181 10th Ave.	CO	11819	10
74	2011-10-31 03:51:00-07	Nana Suits	6844 45th St.	WY	45801	23
75	2011-12-24 19:13:00-08	Minerva Li	5546 31st St.	FL	37071	12
76	2011-01-24 06:13:00-08	Georgina Crissman	2534 35th St.42nd Ave.	SC	92320	26
77	2011-12-22 13:08:00-08	Tommie Ange	4651 31st St.	NY	43609	44
78	2011-04-21 00:52:00-07	Kymberly Ange	7780 44th Ave.	VA	17138	3
79	2011-05-17 21:38:00-07	Reed Larimer	4937 Washington Ave.	NY	53172	16
80	2011-08-27 13:03:00-07	Carmel Letellier	8915 Washington Ave.	FL	76107	16
81	2011-11-04 04:56:00-07	Colleen Seabaugh	6198 California St.	TX	25936	20
82	2011-11-26 08:47:00-08	Granville Blumer	7705 MLK Ave.	WY	21361	23
83	2011-01-28 15:07:00-08	Brady Durio	7813 45th St.	WA	15632	8
84	2011-11-22 12:47:00-08	Graciela Kiser	3266 California St.	NY	40432	13
85	2011-05-01 15:45:00-07	Angel Lesane	2318 MLK Ave.	FL	93225	15
86	2011-03-18 02:04:00-07	Shawanda Ange	5504 8th Ave.	WA	28528	26
87	2011-03-31 13:54:00-07	Samatha Dougal	7052 35th St.42nd Ave.	NY	36717	15
88	2011-08-17 17:43:00-07	Dee Luman	7214 10th Ave.	WY	35245	37
89	2011-08-03 21:14:00-07	Rolf Crenshaw	5857 43rd St.	TX	21037	7
90	2011-11-24 11:35:00-08	Irma Disney	2848 MLK Ave.	VA	73667	44
91	2011-11-13 13:18:00-08	Letitia Strayer	4441 35th St.42nd Ave.	SC	14491	8
92	2011-04-14 14:12:00-07	Angel Benedetto	4875 35th St.42nd Ave.	WA	30254	18
93	2011-06-12 11:43:00-07	Claud Vasko	7661 8th Ave.	WY	10935	32
94	2011-05-12 13:46:00-07	Berta Fretz	272 45th St.	FL	36777	48
95	2011-07-16 15:41:00-07	Johnathan Pressey	1162 44th Ave.	SC	46110	38
96	2011-02-12 11:30:00-08	Brady Mcclain	3235 Washington Ave.	IL	31913	23
97	2011-03-23 07:11:00-07	Theresia Lesane	2797 44th Ave.	GA	67585	23
98	2011-07-23 06:01:00-07	Lawerence Senko	1528 31st St.	NY	49526	49
99	2011-11-19 21:41:00-08	Rivka Scharf	7255 10th Ave.	TX	59794	36
100	2011-09-11 21:07:00-07	Rubie Wassink	4864 10th Ave.	CO	35894	12
101	2011-05-03 14:47:00-07	Mauro Kimball	465 50th Ave.	VA	31809	1
102	2011-04-22 19:08:00-07	Collin Julian	563 MLK Ave.	SC	21495	11
103	2011-04-28 23:00:00-07	Berta Slone	9457 46th Ave.	VA	66128	32
104	2011-02-21 10:36:00-08	Jame Bonacci	3015 8th Ave.	VA	75126	9
105	2011-08-01 22:57:00-07	Jenee Crays	3679 43rd St.	WY	93895	43
106	2011-12-08 13:31:00-08	Neoma Tripodi	3564 44th Ave.	IL	48258	29
107	2011-03-04 13:16:00-08	Tommie Schippers	5687 8th Ave.	FL	91160	12
108	2011-04-15 14:38:00-07	Shawanda Bodkin	2264 8th Ave.	WY	20206	5
109	2011-12-31 20:55:00-08	Alfonzo Haubrich	1955 43rd St.	TX	38201	2
110	2011-06-09 10:30:00-07	Daniele Selden	7032 MLK Ave.	SC	13960	35
111	2011-02-21 07:10:00-08	Edmund Hedgpeth	336 35th St.42nd Ave.	GA	46804	24
112	2011-02-11 14:50:00-08	Humberto Emmerich	4113 California St.	WA	63066	26
113	2011-02-08 08:11:00-08	Allen Bulfer	3615 50th Ave.	SC	34865	7
114	2011-03-12 10:54:00-08	Andres Styers	9216 31st St.	FL	16017	15
115	2011-09-04 08:56:00-07	Renda Larimer	292 35th St.42nd Ave.	WA	71516	45
116	2011-04-27 02:19:00-07	Lean Melendez	3476 Washington Ave.	WY	48887	13
117	2011-01-15 22:28:00-08	Andrew Nowakowski	7525 California St.	NY	24140	20
118	2011-03-08 04:46:00-08	Catina Kiser	5315 35th St.42nd Ave.	WA	84188	22
119	2011-08-25 10:44:00-07	Stasia Alber	6075 Washington Ave.	WY	99825	39
120	2011-04-10 16:34:00-07	Beverlee Jonson	1765 45th St.	WA	88408	4
121	2011-01-18 12:50:00-08	Williams Selden	3949 35th St.42nd Ave.	FL	12104	18
122	2011-11-10 21:43:00-08	Sherrill Canter	2230 Washington Ave.	FL	98547	15
123	2011-01-19 23:44:00-08	Evelyn Schauwecker	4512 50th Ave.	SC	37554	41
124	2011-03-02 11:30:00-08	Kourtney Brazell	5980 43rd St.	IL	10309	13
125	2011-06-17 02:42:00-07	Homer Kimball	364 43rd St.	CO	80565	27
126	2011-01-31 15:29:00-08	Jerald Dement	4257 31st St.	CO	97763	18
127	2011-03-12 03:25:00-08	Clemencia Canter	8637 45th St.	SC	25008	50
128	2011-03-27 04:10:00-07	Sherilyn Fruchter	2218 35th St.42nd Ave.	IL	16333	6
129	2011-11-24 18:10:00-08	Emmitt Nowakowski	7932 35th St.42nd Ave.	SC	72275	42
130	2011-04-20 09:25:00-07	Laurence Dilks	2006 8th Ave.	TX	37105	44
131	2011-08-19 11:18:00-07	Jami Parrilla	9366 MLK Ave.	NY	97171	16
132	2011-10-15 18:42:00-07	Nydia Uyehara	6769 45th St.	VA	10974	34
133	2011-11-01 20:49:00-07	Williams Schauwecker	778 35th St.42nd Ave.	NY	83694	7
134	2011-03-19 00:03:00-07	Fidelia Sarver	4372 46th Ave.	GA	41138	40
135	2011-11-04 20:35:00-07	Clay Mor	4616 35th St.42nd Ave.	CO	73038	26
136	2011-01-21 06:19:00-08	Humberto Junge	3825 8th Ave.	SC	38489	44
137	2011-10-04 17:03:00-07	Miyoko Scharf	450 Washington Ave.	TX	39551	42
138	2011-08-06 14:49:00-07	Williams Lesane	193 44th Ave.	SC	93229	7
139	2011-12-03 02:56:00-08	Alyse Sarver	7961 46th Ave.	GA	38307	29
140	2011-08-01 11:07:00-07	Jannette Scharf	6507 50th Ave.	CO	83265	50
141	2011-01-23 20:05:00-08	Graig Blatt	2872 43rd St.	NY	84064	13
142	2011-12-17 21:24:00-08	Shawana Alber	1057 8th Ave.	SC	70002	17
143	2012-01-01 02:15:00-08	Pauletta Verner	8926 44th Ave.	WY	22058	38
144	2011-05-19 14:22:00-07	Cherryl Chivers	4740 Washington Ave.	VA	70417	16
145	2011-06-23 19:18:00-07	Ricarda Rodda	6077 44th Ave.	NY	90025	41
146	2011-03-29 17:53:00-07	Sona Wanner	7849 43rd St.	WY	94347	31
147	2011-03-04 18:21:00-08	Jules Dossey	9487 43rd St.	NY	29504	41
148	2011-07-11 21:45:00-07	Danyelle Bonacci	6534 50th Ave.	TX	77998	28
149	2011-11-29 15:43:00-08	Antonio Greening	9498 MLK Ave.	FL	71212	32
150	2011-07-05 17:33:00-07	Una Coderre	7449 43rd St.	NY	41612	42
151	2011-11-11 00:11:00-08	Miyoko Lepore	4087 46th Ave.	IL	83719	12
152	2011-07-30 12:15:00-07	Harley Fontanilla	6872 44th Ave.	WA	40996	18
153	2011-02-27 06:06:00-08	Harley Kimball	3157 44th Ave.	CO	36878	39
154	2011-07-11 09:40:00-07	Cammy Halpin	3778 45th St.	CO	80611	42
155	2011-09-09 18:30:00-07	Buford Sandoval	7702 MLK Ave.	WY	80205	40
156	2011-07-23 10:02:00-07	Becky Bona	9814 45th St.	TX	50950	4
157	2011-02-06 21:40:00-08	Gaylene Coderre	5861 46th Ave.	FL	44627	6
158	2011-07-20 07:11:00-07	Andres Iriarte	3523 43rd St.	FL	97921	8
159	2011-12-29 08:30:00-08	Tommie Roff	6316 45th St.	TX	21937	43
160	2011-12-15 13:47:00-08	Keri Puett	4652 8th Ave.	CO	72241	39
161	2011-07-12 05:34:00-07	Jami Hersey	380 MLK Ave.	SC	43408	43
162	2011-10-24 17:40:00-07	Neoma Vashon	3697 MLK Ave.	NY	95244	38
163	2011-03-25 00:44:00-07	Hildred Crissman	5188 MLK Ave.	NY	42924	36
164	2011-10-09 21:11:00-07	Takako Greening	3215 35th St.42nd Ave.	GA	51779	20
165	2011-07-15 06:30:00-07	Cammy Heavner	5135 10th Ave.	FL	76311	1
166	2011-07-11 01:48:00-07	Jeffie Wichman	5369 46th Ave.	VA	44351	12
167	2011-05-13 13:42:00-07	Marshall Pressey	4163 46th Ave.	NY	81609	16
168	2011-01-22 02:03:00-08	Adell Fretz	2284 10th Ave.	WA	85429	1
169	2011-10-21 15:02:00-07	Salvatore Dorado	783 43rd St.	TX	65768	45
170	2011-04-16 20:45:00-07	Williams Lanphear	6766 California St.	WY	83367	45
171	2011-09-17 01:58:00-07	Charlotte Tripodi	4453 Washington Ave.	WA	68292	31
172	2011-05-29 20:43:00-07	Isreal Schuh	9758 MLK Ave.	NY	88586	30
173	2011-04-09 09:05:00-07	Rosemary Gilpatrick	5869 44th Ave.	GA	85059	47
174	2011-04-30 09:52:00-07	Amos Hendon	7292 31st St.	WA	47446	10
175	2011-08-12 23:37:00-07	Ivana Haubrich	5328 8th Ave.	GA	99526	40
176	2011-10-03 01:49:00-07	Hans Bough	7629 10th Ave.	NY	79631	50
177	2011-06-18 23:24:00-07	Lawerence Crays	8505 California St.	NY	83037	37
178	2011-07-04 02:00:00-07	Inocencia Purtee	8266 50th Ave.	IL	65461	10
179	2011-07-09 15:05:00-07	Kristofer Dutra	7623 MLK Ave.	VA	12933	15
180	2011-06-11 08:33:00-07	Tonette Alba	7128 50th Ave.	FL	80964	23
181	2011-09-19 14:49:00-07	Allen Harshberger	6495 Washington Ave.	VA	10553	12
182	2011-07-16 17:50:00-07	Hans Pinegar	9718 California St.	GA	76976	1
183	2011-04-14 17:58:00-07	Jean Dutra	9310 31st St.	WY	71693	48
184	2011-02-22 11:28:00-08	Layne Bueche	6069 45th St.	VA	78715	12
185	2011-06-07 10:18:00-07	Kristofer Morejon	8541 10th Ave.	CO	49772	3
186	2011-05-31 04:32:00-07	Granville Lanphear	3404 California St.	TX	67824	5
187	2011-01-27 11:46:00-08	Rolando Crowley	1922 44th Ave.	WY	70653	4
188	2011-04-04 08:55:00-07	Cortney Seabaugh	7047 43rd St.	GA	66768	13
189	2011-05-10 12:13:00-07	Amos Nowakowski	7426 California St.	SC	69075	25
190	2011-11-08 01:08:00-08	Buford Akey	8600 MLK Ave.	VA	46714	14
191	2011-06-15 16:38:00-07	Karole Pellegrin	9426 8th Ave.	WY	55003	47
192	2011-11-09 07:29:00-08	Humberto Cousineau	7249 50th Ave.	FL	13899	1
193	2011-10-04 21:44:00-07	Romaine Dutra	2765 35th St.42nd Ave.	WA	78179	30
194	2011-11-10 11:39:00-08	Buford Tarnowski	1488 MLK Ave.	GA	80085	37
195	2011-03-05 10:25:00-08	Glen Sprau	4063 45th St.	IL	92012	35
196	2011-04-04 12:09:00-07	Angel Durio	8163 44th Ave.	TX	69144	14
197	2011-02-28 07:20:00-08	Jill Upson	9989 45th St.	GA	89238	50
198	2011-12-07 08:50:00-08	Hildred Paramo	4598 46th Ave.	GA	92377	35
199	2011-01-20 15:02:00-08	Ngan Dement	3769 8th Ave.	TX	56709	33
200	2011-07-30 17:59:00-07	Inocencia Gasper	8295 45th St.	NY	43241	47
201	2011-04-09 14:24:00-07	Shelba Hedgpeth	391 35th St.42nd Ave.	IL	55856	34
202	2011-04-23 12:19:00-07	Danyelle Barsh	8545 50th Ave.	IL	72822	43
203	2011-02-21 04:47:00-08	Alessandra Lago	4157 43rd St.	NY	67276	8
204	2011-09-11 20:50:00-07	Sol Rabb	1067 8th Ave.	SC	70557	20
205	2011-01-19 09:05:00-08	Deetta Bodkin	3559 Washington Ave.	FL	46603	17
206	2011-05-23 05:10:00-07	Emely Dougal	4665 8th Ave.	SC	48734	2
207	2011-06-11 23:57:00-07	Donald Schuh	3582 MLK Ave.	FL	25953	6
208	2011-11-16 16:44:00-08	Sol Brazell	5365 35th St.42nd Ave.	GA	89865	19
209	2011-06-24 17:13:00-07	Lula Greening	2503 10th Ave.	WY	31416	50
210	2011-10-21 16:36:00-07	Pauletta Arends	868 8th Ave.	SC	86408	22
211	2011-11-20 14:25:00-08	Brady Crete	2608 46th Ave.	FL	59951	48
212	2011-05-27 09:55:00-07	Jettie Mcqueeney	8241 50th Ave.	NY	71938	25
213	2011-10-30 21:50:00-07	Miyoko Potter	6472 31st St.	WY	98880	22
214	2011-01-17 23:44:00-08	Ruthie Hedgpeth	8766 California St.	WA	81990	20
215	2011-01-10 19:18:00-08	Shera Matheson	1728 10th Ave.	NY	69912	34
216	2011-04-04 04:19:00-07	Eva Arent	9496 35th St.42nd Ave.	FL	80721	47
217	2011-08-22 11:29:00-07	Derek Parrilla	8921 California St.	WA	77671	35
218	2011-11-05 14:51:00-07	Takako Dutra	7671 8th Ave.	TX	11338	20
219	2011-01-24 14:22:00-08	Theresia Canter	3555 California St.	WY	78296	38
220	2011-11-30 09:21:00-08	Georgina Lessley	2767 43rd St.	GA	53380	7
221	2011-07-05 15:49:00-07	Takako Lanphear	5622 Washington Ave.	IL	38312	45
222	2011-10-20 19:09:00-07	Eva Bonacci	1996 50th Ave.	VA	39743	5
223	2011-05-06 08:20:00-07	Shanell Beasley	7440 43rd St.	NY	15979	3
224	2011-08-28 05:21:00-07	Thersa Struthers	6787 43rd St.	VA	92393	12
225	2011-07-03 19:48:00-07	Douglass Pung	7659 10th Ave.	SC	99460	49
226	2011-07-25 02:07:00-07	Daisey Roff	5485 45th St.	WA	89188	23
227	2011-02-12 01:01:00-08	Carmel Luman	2860 Washington Ave.	NY	36014	32
228	2011-09-04 21:26:00-07	Candie Junior	3559 MLK Ave.	VA	27403	31
229	2011-12-16 00:59:00-08	Raye Galvez	8062 10th Ave.	TX	50391	49
230	2011-01-15 18:41:00-08	Jules Galvez	7027 43rd St.	IL	40528	31
231	2011-11-30 17:21:00-08	Misty Kurth	1764 44th Ave.	FL	48707	43
232	2011-04-20 05:20:00-07	Kourtney Cousineau	9197 45th St.	VA	49029	45
233	2011-02-21 03:00:00-08	Williams Arent	4466 Washington Ave.	VA	27476	49
234	2011-12-09 21:16:00-08	Ruthie Mcqueeney	1127 California St.	WA	80245	27
235	2011-01-31 05:50:00-08	Quintin Delpriore	5449 44th Ave.	NY	53642	48
236	2011-09-07 16:50:00-07	Harley Rodda	2068 44th Ave.	WY	53076	25
237	2011-01-20 23:20:00-08	Marquis Stukes	8694 43rd St.	GA	45658	47
238	2011-03-24 16:47:00-07	Isabel Vasko	1875 Washington Ave.	FL	72185	31
239	2011-03-23 09:11:00-07	Leonard Roundtree	7016 43rd St.	NY	30645	14
240	2011-09-15 16:26:00-07	Allen Uyehara	8659 California St.	WA	84766	36
241	2011-12-31 20:22:00-08	Romaine Rodda	6819 46th Ave.	WA	28649	40
242	2011-04-04 05:20:00-07	Yuki Lago	6743 35th St.42nd Ave.	NY	15113	6
243	2011-08-20 10:07:00-07	Eve Uyehara	2245 MLK Ave.	VA	87083	46
244	2011-07-03 05:50:00-07	Jonell Morrissey	1562 46th Ave.	TX	66057	11
245	2011-04-22 00:25:00-07	Hans Vasko	2839 10th Ave.	IL	30974	30
246	2011-08-19 03:59:00-07	Ronnie Wassink	932 50th Ave.	NY	10028	41
247	2011-09-23 10:54:00-07	Wendie Hedgpeth	7691 45th St.	TX	20202	19
248	2011-08-24 16:53:00-07	Evelyn Fretz	2127 MLK Ave.	WA	20168	10
249	2011-11-27 23:18:00-08	Kristofer Uyehara	9260 MLK Ave.	TX	61050	37
250	2011-08-29 03:23:00-07	Thersa Sisemore	436 31st St.	GA	25895	35
251	2011-09-25 21:22:00-07	Evelyn Bough	8671 35th St.42nd Ave.	VA	53312	5
252	2011-04-22 18:26:00-07	Ivana Crenshaw	1249 43rd St.	FL	89546	21
253	2011-11-19 15:48:00-08	Mitchell Tartaglia	4395 MLK Ave.	VA	69439	43
254	2011-05-14 18:23:00-07	Yuki Roose	3980 45th St.	CO	81596	12
255	2011-11-28 19:02:00-08	Milda Milam	8539 46th Ave.	VA	91339	12
256	2011-10-26 21:11:00-07	Susanna Mcdougle	8392 8th Ave.	FL	29137	4
257	2011-02-04 21:29:00-08	Dovie Scharf	9841 43rd St.	IL	72609	5
258	2011-03-03 18:33:00-08	Amos Lesane	360 Washington Ave.	SC	48655	2
259	2011-01-29 17:07:00-08	Dee Birdsell	1985 Washington Ave.	SC	73249	44
260	2011-09-08 11:11:00-07	Ronnie Barsh	8679 31st St.	NY	88166	45
261	2011-03-25 10:25:00-07	Douglass Arends	4626 45th St.	TX	10709	42
262	2011-09-16 17:32:00-07	Letitia Lepore	7132 45th St.	CO	26686	15
263	2011-12-14 04:38:00-08	Camie Crenshaw	5239 8th Ave.	NY	64153	7
264	2011-02-13 15:01:00-08	Neoma Parrilla	9959 46th Ave.	NY	82911	31
265	2011-03-20 00:18:00-07	Rosemary Wanner	7647 31st St.	GA	39353	24
266	2011-07-01 09:19:00-07	Sherrill Junge	9089 46th Ave.	FL	67670	30
267	2011-06-01 20:30:00-07	Salvatore Dilks	7466 Washington Ave.	NY	82375	9
268	2011-11-30 06:55:00-08	Harley Crowley	1764 MLK Ave.	WA	34515	32
269	2011-12-12 03:17:00-08	Andrew Bough	9371 44th Ave.	GA	59570	1
270	2011-06-24 16:37:00-07	Emmitt Moe	2369 MLK Ave.	VA	97140	11
271	2011-06-15 07:47:00-07	Catina Drexler	1348 44th Ave.	CO	58919	17
272	2011-03-19 14:06:00-07	Johnathan Greenway	9229 46th Ave.	WY	40056	40
273	2011-07-08 20:51:00-07	Isreal Wassink	4695 MLK Ave.	NY	70269	5
274	2011-10-14 11:45:00-07	Candie Mcdougle	2202 35th St.42nd Ave.	VA	22747	31
275	2011-08-06 21:12:00-07	Sherilyn Tarnowski	9327 44th Ave.	NY	65717	46
276	2011-01-12 01:07:00-08	Isabel Calico	4597 44th Ave.	WY	25373	3
277	2011-05-21 16:05:00-07	Kristle Alba	8828 44th Ave.	FL	56914	41
278	2011-11-03 16:29:00-07	Fidelia Lanser	7587 31st St.	SC	41859	37
279	2011-03-30 16:42:00-07	Isabel Cocke	9830 MLK Ave.	WY	70034	28
280	2011-12-02 03:44:00-08	Susannah Sturgill	4634 MLK Ave.	TX	63536	12
281	2011-08-22 03:01:00-07	Eve Sosnowski	8559 50th Ave.	WY	99759	47
282	2011-04-25 12:13:00-07	Russ Roth	7908 31st St.	GA	55550	34
283	2011-03-16 22:44:00-07	Graciela Pung	2047 50th Ave.	SC	75110	5
284	2011-05-04 19:42:00-07	Georgina Matheson	5699 Washington Ave.	NY	70903	14
285	2011-09-03 18:49:00-07	Carmel Crowley	8549 35th St.42nd Ave.	VA	63651	39
286	2011-02-01 22:13:00-08	Danyelle Morrissey	4789 45th St.	NY	16337	37
287	2011-12-05 05:35:00-08	Glen Tarnowski	5002 44th Ave.	SC	22253	33
288	2011-10-29 18:22:00-07	Miyoko Slone	1556 45th St.	FL	63153	10
289	2011-10-16 10:55:00-07	Camie Matheson	5336 43rd St.	TX	94078	42
290	2011-10-14 10:47:00-07	Kelli Langenfeld	5654 MLK Ave.	NY	58294	45
291	2011-03-16 11:47:00-07	Donald Morejon	9083 Washington Ave.	WA	17893	5
292	2011-09-09 06:57:00-07	Jean Greenway	4423 44th Ave.	WY	46940	6
293	2011-10-04 20:59:00-07	Rubie Mccubbin	3031 50th Ave.	TX	41893	16
294	2011-05-31 03:14:00-07	Kourtney Yoshimura	1034 43rd St.	WY	71924	48
295	2011-11-17 08:02:00-08	Thersa Roundtree	1554 44th Ave.	IL	80252	3
296	2011-05-29 03:31:00-07	Thersa Larimer	2166 46th Ave.	VA	44952	1
297	2011-08-02 06:48:00-07	Emely Blatt	2628 43rd St.	VA	89807	39
298	2011-09-18 12:42:00-07	Lawerence Arent	3242 46th Ave.	WA	36892	42
299	2011-08-29 06:33:00-07	Nydia Petrin	2337 44th Ave.	GA	89430	13
300	2011-03-11 10:57:00-08	Dovie Harshberger	3071 46th Ave.	NY	97275	3
301	2011-09-09 08:59:00-07	Dalton Dilks	4728 45th St.	TX	36223	28
302	2011-04-18 14:53:00-07	Evelina Mccubbin	8786 10th Ave.	IL	31700	4
303	2011-09-13 19:37:00-07	Meg Haubrich	683 44th Ave.	CO	69805	2
304	2011-03-26 17:58:00-07	Nathanial Verner	1091 35th St.42nd Ave.	IL	44647	46
305	2011-08-14 02:51:00-07	Bradly Cocke	182 10th Ave.	NY	51705	17
306	2011-06-20 13:32:00-07	Brandon Petrin	5953 35th St.42nd Ave.	SC	38643	23
307	2011-11-06 22:10:00-08	Lawerence Nowakowski	5917 8th Ave.	SC	41250	3
308	2011-07-28 22:41:00-07	Sherice Pressnell	1560 MLK Ave.	GA	84924	10
309	2011-11-14 08:50:00-08	Emmitt Kimball	8045 8th Ave.	FL	48966	13
310	2011-05-01 01:31:00-07	Danae Wassink	927 35th St.42nd Ave.	IL	57971	7
311	2011-02-18 07:22:00-08	Amos Monteith	7116 35th St.42nd Ave.	CO	68363	11
312	2011-11-18 07:28:00-08	Dee Jeon	7275 35th St.42nd Ave.	WA	49468	39
313	2011-09-26 19:18:00-07	Leonard Rodda	3214 8th Ave.	CO	51575	19
314	2011-10-02 18:52:00-07	Rolando Rudy	7932 10th Ave.	GA	74545	18
315	2011-01-29 01:28:00-08	Gena Mcdougle	6438 43rd St.	CO	21928	25
316	2011-03-11 19:33:00-08	Theresia Mcdougle	2678 10th Ave.	VA	56608	32
317	2011-06-12 20:32:00-07	Cammy Galvez	5328 50th Ave.	GA	31104	5
318	2011-06-01 07:28:00-07	Angel Dorado	3724 43rd St.	WA	80153	2
319	2011-10-09 15:24:00-07	Antonio Pung	728 10th Ave.	SC	15225	9
320	2011-06-18 11:41:00-07	Quinton Hendon	5114 50th Ave.	SC	90564	40
321	2011-11-01 13:49:00-07	Shawana Selden	6200 45th St.	NY	67164	5
322	2011-03-03 05:29:00-08	Sherrill Roth	5049 46th Ave.	GA	90088	29
323	2011-12-03 03:40:00-08	Alfonzo Sevigny	2350 Washington Ave.	TX	55374	48
324	2011-07-09 05:36:00-07	Arianne Levron	3811 45th St.	IL	96626	1
325	2011-03-30 17:28:00-07	Inocencia Scharf	5327 MLK Ave.	GA	46450	42
326	2011-09-12 23:06:00-07	Granville Haefner	6079 50th Ave.	WA	89548	2
327	2011-07-16 10:03:00-07	Salvatore Junge	8648 10th Ave.	FL	15213	8
328	2011-07-03 00:45:00-07	Milda Caba	3216 Washington Ave.	GA	61402	26
329	2011-03-11 07:05:00-08	Karole Bough	9462 Washington Ave.	GA	71938	35
330	2011-07-09 21:18:00-07	Camie Julian	2085 43rd St.	CO	26637	16
331	2011-09-22 06:40:00-07	Harley Garrels	6905 California St.	WY	28389	48
332	2011-05-23 05:51:00-07	Arianne Tarnowski	7175 Washington Ave.	SC	69261	11
333	2011-02-20 15:21:00-08	Kelli Julian	4456 44th Ave.	SC	62035	39
334	2011-10-31 17:56:00-07	Jame Bulfer	8976 Washington Ave.	GA	12615	2
335	2011-04-24 07:20:00-07	Jonell Redd	3634 Washington Ave.	CO	13986	31
336	2011-07-19 15:45:00-07	Carolann Arent	6122 43rd St.	FL	45492	4
337	2011-12-09 21:15:00-08	Angel Birdsell	2072 Washington Ave.	SC	27814	35
338	2011-02-26 02:11:00-08	Milda Canter	1205 45th St.	NY	63489	9
339	2011-10-25 17:57:00-07	Mohammad Peet	5158 50th Ave.	IL	62026	13
340	2011-03-07 20:09:00-08	Mikki Stimac	8415 35th St.42nd Ave.	IL	10765	23
341	2011-08-23 00:32:00-07	Beverlee Crissman	8073 8th Ave.	GA	40300	28
342	2011-11-19 07:16:00-08	Danyelle Brazell	4038 43rd St.	TX	56121	38
343	2011-05-16 12:51:00-07	Mauro Rudy	4053 35th St.42nd Ave.	SC	55631	3
344	2011-04-12 01:11:00-07	Gaye Suits	6483 10th Ave.	TX	61034	26
345	2011-03-19 16:15:00-07	Kourtney Damore	4515 43rd St.	TX	33042	13
346	2011-08-26 16:36:00-07	Shawanda Rooney	6089 46th Ave.	CO	35106	35
347	2011-07-25 00:38:00-07	Gena Roundtree	7623 46th Ave.	TX	84205	38
348	2011-02-22 23:33:00-08	Alfonzo Jay	3490 8th Ave.	SC	83590	8
349	2011-12-08 21:27:00-08	Stasia Mercedes	704 Washington Ave.	TX	52960	23
350	2011-05-04 18:36:00-07	Candie Bueche	5170 31st St.	WY	35781	8
351	2011-09-12 00:59:00-07	Dalton Melendez	868 8th Ave.	CO	56410	43
352	2011-03-22 18:57:00-07	Berta Garrels	2028 35th St.42nd Ave.	GA	48286	21
353	2011-12-16 20:53:00-08	Harrison Crenshaw	1318 46th Ave.	TX	50005	2
354	2011-01-17 04:40:00-08	Clemencia Rudy	9875 California St.	CO	18280	36
355	2011-05-23 00:34:00-07	Wynona Suits	1712 46th Ave.	SC	28416	31
356	2011-07-18 08:53:00-07	Jettie Dilks	3267 8th Ave.	VA	19637	22
357	2011-12-10 10:03:00-08	Stasia Dement	4782 10th Ave.	IL	22100	13
358	2011-08-10 14:51:00-07	Von Larimer	3112 31st St.	TX	32000	46
359	2011-04-19 14:16:00-07	Pauletta Luman	5904 45th St.	WY	11065	46
360	2011-01-14 12:45:00-08	Humberto Haubrich	410 35th St.42nd Ave.	TX	15328	25
361	2011-12-23 15:09:00-08	Vivian Blumer	1641 44th Ave.	TX	19159	45
362	2011-06-30 16:41:00-07	Susanna Wassink	4887 10th Ave.	SC	22559	39
363	2011-08-14 07:29:00-07	Earlean Calico	1670 Washington Ave.	FL	22778	17
364	2011-03-14 16:21:00-07	Kristofer Redd	7015 46th Ave.	IL	12432	18
365	2011-05-25 10:21:00-07	Inocencia Cousineau	3518 50th Ave.	CO	52550	18
366	2011-03-07 03:01:00-08	Raye Kurth	799 MLK Ave.	WY	31918	46
367	2011-11-24 20:43:00-08	Gudrun Dougal	4043 8th Ave.	WY	96969	36
368	2011-10-03 19:29:00-07	Renda Luman	5310 50th Ave.	TX	52241	14
369	2011-08-27 10:14:00-07	Misty Bonacci	4701 46th Ave.	IL	73567	26
370	2011-10-28 18:09:00-07	Hiedi Slone	8483 35th St.42nd Ave.	SC	73176	42
371	2011-08-18 04:56:00-07	Victor Disney	2843 45th St.	VA	18586	6
372	2011-04-22 03:28:00-07	Cammy Bough	8593 8th Ave.	VA	12915	18
373	2011-10-23 20:31:00-07	Ozella Lichtenstein	4999 MLK Ave.	SC	20615	15
374	2011-12-21 18:02:00-08	Dewayne Lichtenstein	7552 45th St.	GA	53373	22
375	2011-05-13 21:51:00-07	Missy Haubrich	8909 43rd St.	IL	71877	6
376	2011-10-21 08:38:00-07	Douglass Upson	5512 35th St.42nd Ave.	SC	45361	35
377	2011-07-10 08:21:00-07	Divina Blatt	5801 10th Ave.	VA	55037	49
378	2011-04-24 21:52:00-07	Yuki Sandoval	4549 46th Ave.	NY	17928	49
379	2011-02-08 11:01:00-08	Vincenzo Galvez	387 50th Ave.	VA	52571	36
380	2011-04-14 12:25:00-07	Misty Selden	3937 35th St.42nd Ave.	IL	62446	24
381	2011-11-17 11:01:00-08	Nydia Dougal	7535 California St.	NY	62882	33
382	2011-09-23 00:11:00-07	Divina Mcqueeney	3209 31st St.	VA	32958	49
383	2011-06-08 10:04:00-07	Russ Matheson	1290 35th St.42nd Ave.	CO	58795	4
384	2011-08-12 21:56:00-07	Nathanial Cousineau	2539 35th St.42nd Ave.	CO	38110	38
385	2011-08-11 01:22:00-07	Gaye Akey	9714 50th Ave.	WY	65718	3
386	2011-07-26 12:17:00-07	Colleen Larimer	5503 46th Ave.	TX	49564	2
387	2011-08-06 12:55:00-07	Daisey Hamill	7312 Washington Ave.	FL	65600	36
388	2011-08-06 07:09:00-07	Harley Sarver	7141 45th St.	CO	27028	49
389	2011-06-21 13:58:00-07	Alessandra Mayon	6681 Washington Ave.	TX	51730	15
390	2011-01-11 00:16:00-08	Theresia Mor	4790 California St.	IL	68142	1
391	2011-06-18 12:24:00-07	Dewayne Edwin	967 50th Ave.	TX	24030	20
392	2011-02-15 09:01:00-08	Raye Durio	6613 50th Ave.	FL	44612	4
393	2011-05-23 05:36:00-07	Danny Wanner	1955 MLK Ave.	WA	83602	17
394	2011-01-09 08:56:00-08	Graig Halpin	2263 50th Ave.	IL	62079	3
395	2011-08-11 12:52:00-07	Gena Lanser	5301 50th Ave.	IL	51771	41
396	2011-08-09 22:45:00-07	Alfonzo Crays	2089 Washington Ave.	FL	48359	34
397	2011-10-31 16:03:00-07	Jami Paramo	1667 35th St.42nd Ave.	WY	38035	46
398	2011-11-15 01:47:00-08	Granville Nowakowski	9922 8th Ave.	FL	57464	3
399	2011-09-23 07:10:00-07	Amos Roundtree	6897 MLK Ave.	SC	16332	3
400	2011-04-11 11:43:00-07	Von Scharf	4570 California St.	GA	40138	46
401	2011-04-28 19:35:00-07	Berta Vashon	5476 43rd St.	NY	47322	2
402	2011-03-29 17:16:00-07	Miyoko Scharf	519 44th Ave.	TX	84403	6
403	2011-08-17 17:25:00-07	Minerva Kipp	4822 8th Ave.	WA	68983	5
404	2011-12-27 22:56:00-08	Conchita Parrilla	120 44th Ave.	TX	42409	20
405	2011-10-11 17:35:00-07	Alessandra Monteith	4466 50th Ave.	SC	86074	12
406	2011-04-14 18:02:00-07	Chadwick Mcclain	7537 31st St.	WA	10288	34
407	2011-04-25 07:10:00-07	Angel Letellier	567 California St.	NY	36325	26
408	2011-04-12 22:48:00-07	Buford Pinegar	592 44th Ave.	VA	20333	27
409	2011-12-27 02:51:00-08	Raye Paramo	2512 50th Ave.	GA	24379	36
410	2011-06-15 07:39:00-07	Isreal Patnode	5091 California St.	IL	41997	8
411	2011-01-17 01:25:00-08	Kelli Verner	3037 50th Ave.	FL	29556	11
412	2011-03-13 12:24:00-07	Kelli Greenway	5021 10th Ave.	WA	50509	3
413	2011-04-14 14:53:00-07	Chadwick Hersey	3620 43rd St.	WA	94240	14
414	2011-12-03 15:37:00-08	Graig Wichman	6254 31st St.	FL	87381	36
415	2011-12-11 13:14:00-08	Andra Lightcap	1044 50th Ave.	WA	22450	49
416	2011-10-16 06:14:00-07	Jettie Schauwecker	4549 Washington Ave.	FL	62444	48
417	2011-05-20 03:46:00-07	Shawana Damore	246 45th St.	SC	79746	44
418	2011-01-15 15:08:00-08	Jannette Mccubbin	207 10th Ave.	CO	60286	1
419	2011-12-13 19:22:00-08	Vincenzo Kubala	6780 46th Ave.	IL	86115	16
420	2011-12-05 22:17:00-08	Brady Julian	7299 California St.	FL	12322	6
421	2011-10-04 22:35:00-07	Von Bulfer	3224 50th Ave.	CO	13913	14
422	2011-04-09 14:31:00-07	Bradly Lanphear	7009 31st St.	VA	48596	49
423	2011-12-20 09:34:00-08	Jeremiah Disney	2201 31st St.	SC	16109	6
424	2011-07-01 09:48:00-07	Glen Roles	8995 35th St.42nd Ave.	WY	60714	39
425	2011-12-04 05:06:00-08	Conchita Sevigny	875 46th Ave.	VA	96493	30
426	2011-11-25 16:25:00-08	Earlean Beasley	2720 45th St.	SC	69013	46
427	2011-07-01 23:22:00-07	Kristle Lanphear	2651 Washington Ave.	FL	77570	46
428	2011-02-22 02:44:00-08	Gudrun Akey	8483 California St.	WY	37623	17
429	2011-12-14 05:46:00-08	Kimi Cousineau	8045 44th Ave.	TX	13711	38
430	2011-07-04 12:31:00-07	Granville Kipp	4038 46th Ave.	VA	49917	24
431	2011-12-10 21:05:00-08	Leonard Roles	5226 31st St.	WY	55309	36
432	2011-01-21 08:57:00-08	Letitia Lago	5583 California St.	TX	68493	27
433	2011-05-15 01:01:00-07	Mauro Morrissey	5457 46th Ave.	TX	57451	5
434	2011-12-10 12:31:00-08	Nathanial Sarver	3705 50th Ave.	IL	52560	45
435	2011-02-05 11:37:00-08	Humberto Blatt	2162 31st St.	WA	85094	23
436	2011-12-30 20:31:00-08	Kali Alber	772 44th Ave.	FL	18333	45
437	2011-02-02 19:03:00-08	Victor Kubala	2805 44th Ave.	CO	28807	39
438	2011-02-28 17:20:00-08	Lean Parrilla	3675 44th Ave.	IL	75020	24
439	2011-04-26 02:27:00-07	Tonette Schippers	9369 Washington Ave.	FL	83815	19
440	2011-11-18 06:20:00-08	Johnathon Julian	7620 10th Ave.	SC	76615	29
441	2011-03-31 21:19:00-07	Mauro Birdsell	6002 43rd St.	FL	91013	16
442	2011-06-03 04:42:00-07	Shalon Stukes	3092 31st St.	CO	35884	49
443	2011-08-23 15:35:00-07	Hans Wichman	2187 California St.	IL	10897	29
444	2011-07-29 18:51:00-07	Shera Edwin	1334 31st St.	WA	66328	47
445	2011-01-06 02:19:00-08	Mitchell Dutra	6518 MLK Ave.	WY	87834	28
446	2011-09-04 03:01:00-07	Ricarda Cocke	8098 California St.	WA	37091	42
447	2011-06-22 18:40:00-07	Brandon Mcclain	7768 44th Ave.	NY	45318	34
448	2011-10-30 16:40:00-07	Kimi Lessley	9569 46th Ave.	IL	58300	8
449	2011-04-19 20:06:00-07	Bradly Garrels	3394 10th Ave.	TX	50712	14
450	2011-03-18 18:34:00-07	Missy Galvez	2773 MLK Ave.	NY	47075	29
451	2011-08-26 10:03:00-07	Kelli Pung	5262 45th St.	VA	67524	37
452	2011-06-13 22:53:00-07	Kristle Schippers	6857 31st St.	FL	92180	43
453	2011-01-10 17:46:00-08	Reed Arends	4083 10th Ave.	WY	26225	33
454	2011-10-10 22:27:00-07	Lawerence Hendon	9665 46th Ave.	WA	30170	22
455	2011-02-22 18:17:00-08	Keri Doyel	1028 44th Ave.	VA	81690	6
456	2011-01-05 22:16:00-08	Angel Coderre	735 45th St.	GA	69845	29
457	2011-03-23 16:38:00-07	Cortney Hamill	3674 44th Ave.	WY	99335	21
458	2011-11-26 04:09:00-08	Yuki Crissman	2311 Washington Ave.	TX	33434	19
459	2011-12-13 23:28:00-08	Eva Hamill	9749 Washington Ave.	NY	33603	48
460	2011-04-12 23:48:00-07	Russ Mcdougle	6113 31st St.	FL	98243	3
461	2011-01-20 07:39:00-08	Lawerence Peet	4138 44th Ave.	FL	18527	24
462	2011-09-14 14:31:00-07	Salvatore Purtee	9437 44th Ave.	TX	10412	5
463	2011-02-08 15:51:00-08	Danyelle Greenway	7337 45th St.	CO	84602	29
464	2011-12-06 14:12:00-08	Bo Slone	8852 43rd St.	TX	68335	6
465	2011-08-19 11:58:00-07	Letitia Bough	9341 California St.	IL	43968	28
466	2011-03-19 15:10:00-07	Sherice Benedetto	2670 Washington Ave.	VA	45721	16
467	2011-11-17 10:36:00-08	Kali Chivers	935 8th Ave.	WA	57368	27
468	2011-11-07 01:05:00-08	Antonio Gravel	4309 8th Ave.	SC	95345	1
469	2011-02-21 08:25:00-08	Andra Benedetto	5668 31st St.	VA	74675	13
470	2011-11-19 07:45:00-08	Kali Mercedes	7806 8th Ave.	GA	74555	26
471	2011-05-20 01:14:00-07	Glen Dorado	6548 Washington Ave.	NY	81455	24
472	2011-08-01 18:01:00-07	Donald Mercedes	2814 MLK Ave.	CO	55580	14
473	2011-08-31 09:25:00-07	Danny Benedetto	6282 44th Ave.	NY	20116	19
474	2011-10-28 08:28:00-07	Brady Parrilla	7564 45th St.	NY	23470	35
475	2011-06-09 03:01:00-07	Evelina Pressey	7201 10th Ave.	NY	86831	8
476	2011-12-30 21:06:00-08	Brandon Struthers	7044 MLK Ave.	GA	40799	12
477	2011-11-05 13:25:00-07	Antonio Kiser	7501 44th Ave.	WA	12647	14
478	2011-05-05 20:28:00-07	Kimi Fretz	3122 44th Ave.	VA	22818	38
479	2011-02-27 19:55:00-08	Sherilyn Styers	4307 43rd St.	SC	12739	20
480	2011-11-12 20:53:00-08	Danae Westmoreland	1132 10th Ave.	CO	45880	37
481	2011-05-17 07:12:00-07	Laronda Stimac	9991 35th St.42nd Ave.	GA	19121	45
482	2011-01-16 16:39:00-08	Tonette Dutra	6060 Washington Ave.	TX	47021	4
483	2011-03-13 16:25:00-07	Carolann Fruchter	3972 10th Ave.	WY	56225	2
484	2011-04-19 20:20:00-07	Danyelle Haefner	8999 8th Ave.	CO	65078	18
485	2011-05-17 17:08:00-07	Charlotte Knouse	9728 Washington Ave.	GA	76659	37
486	2011-01-13 03:33:00-08	Raye Slone	3566 31st St.	TX	63406	22
487	2011-02-05 04:58:00-08	Susannah Pressey	1906 10th Ave.	WY	13494	45
488	2011-02-17 15:43:00-08	Danyel Sandoval	3009 31st St.	FL	56150	30
489	2011-06-20 14:30:00-07	Kelli Bodkin	3573 46th Ave.	WY	15913	17
490	2011-11-29 12:52:00-08	Andres Schippers	5892 8th Ave.	CO	60768	47
491	2011-06-09 10:21:00-07	Russ Matheson	7805 35th St.42nd Ave.	VA	70928	7
492	2011-07-29 06:52:00-07	Letitia Uyehara	5266 California St.	GA	90583	43
493	2011-04-16 23:34:00-07	Romaine Lepore	260 50th Ave.	FL	36675	15
494	2011-05-22 13:33:00-07	Becky Hendon	9473 45th St.	NY	60622	8
495	2011-04-20 23:42:00-07	Michelina Dilks	2754 44th Ave.	WA	46955	21
496	2011-04-15 14:08:00-07	Jeffie Pinegar	807 California St.	TX	28845	44
497	2011-09-20 01:10:00-07	Emmitt Vashon	5082 Washington Ave.	TX	38229	12
498	2011-05-08 16:54:00-07	Theresia Mayon	7110 50th Ave.	NY	62141	38
499	2011-07-12 14:46:00-07	Sol Puett	2339 California St.	GA	30816	17
500	2011-08-01 16:08:00-07	Ricarda Goldsberry	4167 MLK Ave.	VA	22244	18
501	2011-04-05 08:17:00-07	Andrew Buonocore	6174 MLK Ave.	GA	82477	34
502	2011-10-17 11:54:00-07	Amos Maxson	7355 MLK Ave.	GA	14627	12
503	2011-12-05 10:16:00-08	Brady Fretz	2397 35th St.42nd Ave.	IL	29747	10
504	2011-01-11 00:55:00-08	Shera Suits	164 31st St.	NY	75364	3
505	2011-07-16 14:01:00-07	Rosemary Jay	1385 8th Ave.	NY	12171	14
506	2011-07-07 14:04:00-07	Alyse Bonacci	2268 35th St.42nd Ave.	NY	94114	14
507	2011-02-13 23:19:00-08	Chadwick Sarver	8590 45th St.	SC	98708	24
508	2011-04-09 02:53:00-07	Takako Schauwecker	7146 Washington Ave.	IL	31229	4
509	2011-01-21 08:26:00-08	Neoma Halpin	215 MLK Ave.	TX	85602	48
510	2011-07-30 11:13:00-07	Carolann Kipp	4126 31st St.	VA	14400	12
511	2011-02-25 14:32:00-08	Inocencia Heavner	7401 50th Ave.	FL	38349	9
512	2011-04-22 06:38:00-07	Lawerence Westmoreland	8499 45th St.	FL	88067	1
513	2011-11-29 23:29:00-08	Daniele Rodda	2013 8th Ave.	GA	72276	17
514	2011-06-06 01:04:00-07	Wendie Westmoreland	5949 Washington Ave.	VA	53222	22
515	2011-02-22 10:57:00-08	Evelyn Lago	7378 MLK Ave.	NY	92781	44
516	2011-11-11 07:23:00-08	Jannette Styers	2105 35th St.42nd Ave.	WA	61423	43
517	2011-04-24 14:19:00-07	Cherryl Arends	7325 MLK Ave.	WY	59068	18
518	2011-10-24 15:09:00-07	Kourtney Uyehara	9588 46th Ave.	IL	61203	17
519	2011-05-06 21:18:00-07	Letitia Fruchter	8677 35th St.42nd Ave.	GA	47375	26
520	2011-04-14 16:30:00-07	Milda Schrack	2243 46th Ave.	NY	39947	34
521	2011-06-26 11:14:00-07	Sherrill Potter	7188 Washington Ave.	WA	93036	43
522	2011-06-07 03:08:00-07	Becky Roff	9103 46th Ave.	CO	14001	36
523	2011-08-08 18:38:00-07	Wan Rodda	4202 8th Ave.	FL	52789	49
524	2011-04-07 12:02:00-07	Williams Wassink	6340 California St.	IL	78223	4
525	2011-01-13 19:10:00-08	Shari Mcdougle	6125 Washington Ave.	WA	54701	2
526	2011-10-16 01:49:00-07	Ruthie Dutra	5653 35th St.42nd Ave.	VA	93309	14
527	2011-01-23 01:34:00-08	Divina Sarver	2301 California St.	WA	87006	19
528	2011-09-20 02:27:00-07	Mikki Goldsberry	7885 44th Ave.	TX	79727	50
529	2011-01-09 02:33:00-08	Zita Parrilla	1989 44th Ave.	GA	64047	44
530	2011-12-26 11:50:00-08	Graig Knouse	5446 8th Ave.	CO	47028	24
531	2011-02-23 10:20:00-08	Clemencia Dossey	6590 Washington Ave.	SC	43538	15
532	2011-06-13 07:31:00-07	Wan Fruchter	9529 California St.	TX	44640	19
533	2011-06-26 01:35:00-07	Rosalinda Birdsell	6160 44th Ave.	CO	42687	48
534	2011-08-18 07:18:00-07	Ivana Henkel	7482 46th Ave.	FL	19857	48
535	2011-08-22 05:53:00-07	Susanna Melendez	7318 44th Ave.	CO	74193	18
536	2011-09-26 00:36:00-07	Wynona Jay	5131 35th St.42nd Ave.	IL	43267	36
537	2011-01-20 23:27:00-08	Ricarda Stimac	4154 45th St.	FL	52976	3
538	2011-09-08 00:25:00-07	Granville Scharf	7039 31st St.	CO	66585	12
539	2011-08-29 22:01:00-07	Shanell Fontanilla	7837 Washington Ave.	WY	20096	2
540	2011-03-23 00:22:00-07	Quintin Hintzen	3440 Washington Ave.	CO	37297	50
541	2011-03-26 16:59:00-07	Keri Puett	5282 45th St.	TX	24948	2
542	2011-01-12 18:41:00-08	Williams Paramo	5245 50th Ave.	NY	14158	48
543	2011-06-13 14:43:00-07	Michelina Schauwecker	8567 35th St.42nd Ave.	VA	76883	3
544	2011-08-16 14:56:00-07	Gudrun Redd	8423 31st St.	TX	99867	21
545	2011-10-28 07:02:00-07	Earlean Disney	6840 44th Ave.	WA	99652	41
546	2011-09-22 07:42:00-07	Brandon Morejon	8972 10th Ave.	FL	24682	2
547	2011-08-24 10:27:00-07	Karole Rooney	6159 44th Ave.	WY	81140	38
548	2011-11-30 00:14:00-08	Misty Moe	4753 MLK Ave.	WA	32611	27
549	2011-09-12 08:47:00-07	Kimi Schippers	9366 44th Ave.	TX	24339	6
550	2011-05-03 14:44:00-07	Ricarda Langenfeld	1706 31st St.	FL	42167	3
551	2011-12-08 09:50:00-08	Dalton Razor	6687 44th Ave.	FL	65336	8
552	2011-12-28 06:44:00-08	Clay Ange	445 50th Ave.	WA	90622	25
553	2011-05-16 23:44:00-07	Von Monteith	3049 31st St.	WA	52877	29
554	2011-08-27 02:29:00-07	Lean Drexler	3306 10th Ave.	VA	55418	21
555	2011-01-21 13:40:00-08	Adell Rodda	9751 10th Ave.	GA	55079	24
556	2011-05-17 10:58:00-07	Una Doyel	5495 31st St.	WA	90382	2
557	2011-06-30 13:24:00-07	Shalon Chaffee	5599 50th Ave.	TX	19051	43
558	2011-09-20 12:56:00-07	Kali Harshberger	9699 44th Ave.	WA	23895	23
559	2011-07-29 13:16:00-07	Kristle Stimac	2085 MLK Ave.	NY	75676	31
560	2011-10-31 04:30:00-07	Shera Struthers	477 35th St.42nd Ave.	VA	51580	30
561	2011-12-01 10:13:00-08	Gudrun Pressnell	7126 35th St.42nd Ave.	GA	65729	34
562	2011-06-30 10:50:00-07	Leonard Ladwig	463 10th Ave.	VA	68129	27
563	2011-07-05 15:38:00-07	Eva Mayon	354 50th Ave.	VA	16343	30
564	2011-12-22 01:46:00-08	Conchita Nowakowski	851 10th Ave.	CO	53797	28
565	2011-04-01 04:04:00-07	Wynona Damore	4264 California St.	WA	71715	47
566	2011-10-27 01:58:00-07	Lula Janzen	519 California St.	NY	58016	5
567	2011-08-02 02:08:00-07	Hildred Lanser	2499 Washington Ave.	WA	81754	37
568	2011-08-16 05:17:00-07	Ricarda Patnode	2814 44th Ave.	TX	24958	30
569	2011-11-15 03:36:00-08	Granville Junge	9909 45th St.	NY	78868	18
570	2011-08-28 14:41:00-07	Layne Roundtree	4390 California St.	WA	58199	26
571	2011-10-07 15:30:00-07	Jeremiah Gravel	9707 MLK Ave.	TX	69851	27
572	2011-10-22 03:47:00-07	Jame Kroenke	2180 8th Ave.	VA	80019	17
573	2011-01-30 16:30:00-08	Shalon Buonocore	9475 10th Ave.	WY	68267	13
574	2011-08-27 15:32:00-07	Jettie Edwin	6859 44th Ave.	FL	49084	19
575	2011-07-07 17:58:00-07	Collin Tripodi	2206 California St.	SC	15274	45
576	2011-04-22 22:27:00-07	Keri Sevigny	5228 California St.	WA	27499	33
577	2011-05-06 12:00:00-07	Gaye Lanser	9768 50th Ave.	NY	14249	23
578	2011-03-18 06:47:00-07	Sona Alber	7952 43rd St.	WA	34769	12
579	2011-11-25 14:18:00-08	Kimi Disney	3200 Washington Ave.	WA	33001	23
580	2011-07-27 02:30:00-07	Jame Greening	8331 31st St.	SC	85422	24
581	2011-04-20 08:34:00-07	Gena Pung	309 43rd St.	TX	52596	24
582	2011-09-05 19:14:00-07	Harrison Bonacci	3403 35th St.42nd Ave.	FL	79666	10
583	2011-12-19 09:21:00-08	Karole Cocke	8856 8th Ave.	IL	47974	8
584	2011-04-28 09:31:00-07	Theresia Emmerich	6188 45th St.	WA	20948	48
585	2011-09-13 02:25:00-07	Vivian Calico	2496 45th St.	TX	80365	36
586	2011-04-11 16:21:00-07	Vivian Roose	3698 46th Ave.	VA	30727	26
587	2011-01-17 01:28:00-08	Mohammad Chivers	6744 46th Ave.	VA	31865	4
588	2011-04-02 21:46:00-07	Williams Selden	8161 10th Ave.	GA	20815	44
589	2011-09-30 15:08:00-07	Evelyn Mccubbin	9743 44th Ave.	SC	13690	3
590	2011-03-01 00:32:00-08	Vincenzo Lanphear	1161 31st St.	IL	38974	41
591	2011-09-21 22:01:00-07	Alfonzo Stukes	6156 35th St.42nd Ave.	IL	64038	10
592	2011-06-08 22:10:00-07	Layne Haefner	7731 8th Ave.	SC	81379	17
593	2011-03-25 02:43:00-07	Jill Schuh	3103 45th St.	GA	39564	28
594	2011-01-14 03:52:00-08	Yuki Medlen	4059 45th St.	FL	26849	10
595	2011-06-22 18:33:00-07	Camie Fontanilla	6309 31st St.	IL	64405	20
596	2011-11-03 14:56:00-07	Tommie Vasko	3210 31st St.	FL	35026	21
597	2011-07-09 07:46:00-07	Jerald Schuh	7098 MLK Ave.	SC	90236	18
598	2011-05-14 01:33:00-07	Takako Nowakowski	911 31st St.	VA	63630	11
599	2011-10-24 01:44:00-07	Kali Janzen	6393 46th Ave.	SC	93441	19
600	2011-12-01 14:44:00-08	Rivka Caba	8935 50th Ave.	TX	26608	11
601	2011-12-07 00:58:00-08	Angel Sevigny	9967 10th Ave.	FL	77831	47
602	2011-07-31 22:06:00-07	Shanell Henkel	2863 California St.	TX	26317	45
603	2011-10-17 00:35:00-07	Isreal Vashon	415 35th St.42nd Ave.	VA	64550	5
604	2011-12-24 12:09:00-08	Shelba Verner	6570 10th Ave.	WY	51198	30
605	2011-07-11 04:27:00-07	Wynona Ridgley	4197 31st St.	VA	74671	39
606	2011-08-14 08:22:00-07	Cortney Damore	5431 43rd St.	IL	52967	30
607	2011-01-29 01:56:00-08	Neoma Pung	2013 43rd St.	IL	98416	4
608	2011-08-22 06:26:00-07	Hans Milam	4633 43rd St.	GA	39245	44
609	2011-10-29 22:49:00-07	Shera Dilks	2452 8th Ave.	SC	59905	46
610	2011-12-31 19:33:00-08	Andra Roundtree	649 Washington Ave.	CO	76230	21
611	2011-03-19 06:17:00-07	Amos Hintzen	9724 31st St.	SC	39009	45
612	2011-04-03 21:39:00-07	Letitia Levron	5590 50th Ave.	SC	18459	41
613	2011-01-21 19:00:00-08	Rolando Bona	8471 10th Ave.	WY	90622	46
614	2011-12-18 09:20:00-08	Edmund Crowley	5461 California St.	GA	27639	12
615	2011-07-24 19:03:00-07	Mirta Puett	695 43rd St.	CO	21128	22
616	2011-06-27 22:28:00-07	Allen Jay	5850 MLK Ave.	WY	81016	3
617	2011-09-29 01:13:00-07	Graig Hintzen	3460 46th Ave.	SC	97544	40
618	2011-10-13 05:39:00-07	Arianne Lessley	1753 45th St.	IL	62683	49
619	2011-05-25 08:16:00-07	Berta Petrin	1075 MLK Ave.	WY	87817	8
620	2011-08-20 12:32:00-07	Arianne Pellegrin	8882 35th St.42nd Ave.	SC	17670	13
621	2011-04-06 14:44:00-07	Harley Bough	7091 MLK Ave.	IL	11502	7
622	2011-09-25 15:00:00-07	Misty Sisemore	9331 MLK Ave.	WY	70914	27
623	2011-06-28 03:15:00-07	Jeremiah Goldsberry	8565 43rd St.	TX	27240	4
624	2011-02-02 03:17:00-08	Rolf Morejon	4975 10th Ave.	VA	35356	33
625	2011-09-26 05:00:00-07	Alfonzo Brazell	1169 California St.	GA	99392	48
626	2011-01-19 09:46:00-08	Eva Dilks	9253 MLK Ave.	IL	42192	31
627	2011-12-27 00:28:00-08	Sherrill Westmoreland	342 31st St.	FL	84077	47
628	2011-10-12 19:50:00-07	Brady Pressey	9092 35th St.42nd Ave.	VA	57270	33
629	2011-05-29 12:33:00-07	Rosalinda Tartaglia	4706 50th Ave.	FL	19686	41
630	2011-09-14 21:57:00-07	Dee Sisemore	2998 45th St.	IL	73590	17
631	2011-09-09 09:53:00-07	Jami Crete	374 8th Ave.	VA	21683	45
632	2011-09-25 12:43:00-07	Cortney Breeding	8266 California St.	TX	23203	13
633	2011-11-06 19:28:00-08	Susanna Lichtenstein	6346 MLK Ave.	NY	64663	25
634	2011-05-25 03:15:00-07	Layne Julian	8485 44th Ave.	TX	98479	18
635	2011-01-03 23:10:00-08	Rosemary Hersey	8855 44th Ave.	CO	78367	43
636	2011-07-05 20:52:00-07	Mirta Milam	1017 Washington Ave.	FL	70700	12
637	2011-02-20 11:25:00-08	Isabel Cocke	8324 10th Ave.	GA	67138	1
638	2011-04-07 12:27:00-07	Ngan Tarnowski	9455 43rd St.	NY	36763	4
639	2011-08-17 15:11:00-07	Ronnie Sosnowski	3554 8th Ave.	VA	12607	6
640	2011-07-02 15:08:00-07	Jame Edwin	4091 45th St.	FL	36373	19
641	2011-04-08 06:44:00-07	Jenee Kipp	8008 50th Ave.	FL	36774	15
642	2011-06-02 01:43:00-07	Evelyn Fretz	5077 10th Ave.	NY	37230	24
643	2011-04-05 18:46:00-07	Irma Allbright	8235 8th Ave.	IL	68781	38
644	2011-11-22 12:29:00-08	Mauro Bergeron	3445 50th Ave.	FL	94308	15
645	2011-09-07 04:07:00-07	Rolf Bonacci	7298 50th Ave.	GA	12058	4
646	2011-07-07 20:20:00-07	Jean Parrilla	350 50th Ave.	IL	97409	39
647	2011-02-11 23:26:00-08	Dalton Dossey	7734 50th Ave.	FL	35868	50
648	2011-11-15 22:50:00-08	Gaylene Julian	7135 45th St.	VA	65762	6
649	2011-02-13 14:27:00-08	Jean Rabb	634 45th St.	CO	88040	41
650	2011-01-12 03:15:00-08	Eva Crenshaw	2236 Washington Ave.	GA	49182	31
651	2011-06-16 17:55:00-07	Fidelia Dossey	2842 43rd St.	WY	75789	5
652	2011-04-13 05:03:00-07	Claud Roles	1817 44th Ave.	WY	91120	35
653	2011-11-30 07:48:00-08	Buddy Pinegar	7045 44th Ave.	VA	78545	9
654	2011-01-10 23:04:00-08	Vivian Scharf	8119 50th Ave.	FL	41144	12
655	2011-03-08 13:27:00-08	Shera Wassink	3933 Washington Ave.	VA	13903	30
656	2011-10-02 16:36:00-07	Victor Delpriore	1657 Washington Ave.	WA	33690	43
657	2011-12-24 01:49:00-08	Lula Roth	3366 44th Ave.	NY	95881	5
658	2011-02-16 16:01:00-08	Shawana Calico	3980 MLK Ave.	IL	35066	39
659	2011-07-24 22:34:00-07	Sona Junior	4526 50th Ave.	VA	78994	9
660	2011-08-17 15:44:00-07	Danae Canter	163 31st St.	NY	42624	19
661	2011-12-26 23:33:00-08	Vincenzo Hamill	971 44th Ave.	WY	97404	10
662	2011-08-09 20:43:00-07	Sherice Redd	628 8th Ave.	VA	11093	27
663	2011-09-24 11:22:00-07	Jean Yoshimura	7374 46th Ave.	FL	41415	44
664	2011-11-24 23:53:00-08	Zita Lichtenstein	5305 Washington Ave.	VA	19175	31
665	2011-01-18 03:52:00-08	Berta Galvez	1004 Washington Ave.	SC	38343	47
666	2011-06-03 15:01:00-07	Lean Larimer	602 45th St.	NY	27108	13
667	2011-07-10 18:03:00-07	Ruthie Potter	1032 50th Ave.	VA	28510	48
668	2011-06-05 14:06:00-07	Sherilyn Lessley	2565 46th Ave.	IL	34437	40
669	2011-02-15 03:48:00-08	Laronda Bueche	1016 35th St.42nd Ave.	SC	75860	34
670	2011-04-20 09:17:00-07	Andrew Bergeron	8979 43rd St.	NY	51464	13
671	2011-06-13 07:19:00-07	Emmitt Westmoreland	1312 35th St.42nd Ave.	NY	15141	11
672	2011-02-07 03:37:00-08	Hiedi Jasik	7608 Washington Ave.	TX	58493	3
673	2011-04-21 06:45:00-07	Chadwick Crete	8122 46th Ave.	WY	51272	11
674	2011-12-19 23:10:00-08	Daisey Currier	2077 California St.	GA	61899	50
675	2011-11-21 05:35:00-08	Von Ladwig	6761 10th Ave.	GA	59789	22
676	2011-10-31 08:10:00-07	Thersa Kubala	5547 44th Ave.	VA	65225	35
677	2011-04-12 12:43:00-07	Yuki Lago	4434 45th St.	WY	75697	36
678	2011-02-26 19:39:00-08	Bo Razor	770 35th St.42nd Ave.	WY	21075	2
679	2011-07-29 03:21:00-07	Alfonzo Kump	112 50th Ave.	NY	80875	29
680	2011-06-17 09:37:00-07	Susannah Pellegrin	726 50th Ave.	GA	94111	38
681	2011-04-15 06:57:00-07	Rubie Harshberger	4483 46th Ave.	IL	57046	2
682	2011-02-06 16:12:00-08	Hildred Blumer	7864 MLK Ave.	GA	95684	37
683	2011-02-13 15:15:00-08	Gena Petrin	9601 45th St.	VA	61548	1
684	2011-05-30 06:04:00-07	Raye Mcdougle	8294 31st St.	SC	22563	41
685	2011-11-05 13:53:00-07	Mitchell Knouse	1576 8th Ave.	CO	68187	41
686	2011-04-19 15:23:00-07	Salvatore Lepore	7533 44th Ave.	NY	19693	17
687	2011-11-28 02:11:00-08	Amos Petrin	3096 MLK Ave.	FL	98958	23
688	2011-04-08 06:26:00-07	Mauro Currier	5812 10th Ave.	GA	65897	32
689	2011-09-15 07:14:00-07	Victor Rabb	5027 10th Ave.	WA	37897	9
690	2011-11-17 20:29:00-08	Shelba Morrissey	7086 8th Ave.	TX	99845	12
691	2011-09-27 18:35:00-07	Rolando Durio	6791 31st St.	WY	12528	16
692	2011-02-15 02:25:00-08	Hiedi Mor	8525 46th Ave.	VA	78731	38
693	2011-01-04 05:25:00-08	Evelina Benedetto	9838 31st St.	CO	10656	38
694	2011-11-20 05:18:00-08	Brady Durio	5860 31st St.	NY	70905	16
695	2011-06-11 14:24:00-07	Salvatore Vasko	7813 43rd St.	FL	44121	27
696	2011-12-15 07:19:00-08	Homer Melendez	7638 Washington Ave.	FL	44915	20
697	2011-04-25 13:32:00-07	Brandon Moe	5863 45th St.	FL	77550	40
698	2011-04-04 01:04:00-07	Rolf Crowley	1261 44th Ave.	FL	40895	21
699	2011-11-13 16:05:00-08	Graig Dorado	4269 50th Ave.	WA	84891	29
700	2011-07-07 09:30:00-07	Candie Milam	5312 45th St.	WA	45860	9
701	2011-06-12 11:57:00-07	Conchita Fruchter	6950 46th Ave.	GA	43588	41
702	2011-09-29 01:59:00-07	Homer Wichman	9037 Washington Ave.	NY	53648	33
703	2011-11-26 11:58:00-08	Gaylene Sandoval	5621 35th St.42nd Ave.	SC	83540	34
704	2011-09-21 21:07:00-07	Bradly Knittel	8323 45th St.	TX	83118	24
705	2011-12-23 10:47:00-08	Lula Lesane	7086 31st St.	GA	33013	9
706	2011-11-29 01:10:00-08	Chadwick Crays	8161 46th Ave.	FL	33577	41
707	2011-05-31 13:31:00-07	Fidelia Calico	810 10th Ave.	SC	42491	10
708	2011-10-03 06:36:00-07	Johnathan Puett	3381 44th Ave.	FL	94915	12
709	2011-01-24 06:32:00-08	Inocencia Slone	9026 50th Ave.	GA	86739	4
710	2011-07-30 16:35:00-07	Romaine Letellier	3431 35th St.42nd Ave.	FL	89591	5
711	2011-08-15 17:40:00-07	Alyse Rodda	6318 50th Ave.	GA	79072	45
712	2011-12-29 06:36:00-08	Mikki Dilks	4663 California St.	NY	61822	9
713	2011-03-16 10:05:00-07	Keri Cocke	5472 8th Ave.	WY	83881	29
714	2011-04-11 17:30:00-07	Russ Jonson	2631 44th Ave.	WA	17053	39
715	2011-11-28 12:10:00-08	Shera Suits	6896 10th Ave.	CO	17323	32
716	2011-04-12 01:45:00-07	Buddy Hamill	2941 50th Ave.	CO	27032	15
717	2011-01-14 14:08:00-08	Harley Janzen	2243 10th Ave.	VA	11100	5
718	2011-02-10 11:35:00-08	Russ Durio	2351 50th Ave.	NY	36018	1
719	2011-10-18 02:40:00-07	Jill Sturgill	7313 10th Ave.	TX	84557	10
720	2011-08-25 16:29:00-07	Cortney Gilpatrick	6611 43rd St.	TX	65964	28
721	2011-03-02 01:38:00-08	Bud Rabb	6157 45th St.	NY	76060	8
722	2011-02-26 21:52:00-08	Vivian Larimer	3249 43rd St.	CO	82344	22
723	2011-10-12 11:20:00-07	Laurence Mcclain	2874 10th Ave.	GA	24347	11
724	2011-07-29 09:08:00-07	Danyelle Chaffee	3027 43rd St.	VA	72325	14
725	2011-05-28 06:50:00-07	Claud Damore	5861 31st St.	WY	99199	40
726	2011-03-05 13:17:00-08	Clay Lanser	6872 MLK Ave.	FL	72805	30
727	2011-02-17 06:19:00-08	Kristofer Hamill	9462 10th Ave.	FL	94130	33
728	2011-09-14 02:41:00-07	Samatha Fretz	8550 MLK Ave.	FL	46242	42
729	2011-08-13 14:44:00-07	Kourtney Medlen	9620 44th Ave.	WA	90377	43
730	2011-07-04 11:15:00-07	Una Milam	1156 10th Ave.	FL	92056	45
731	2011-08-05 11:04:00-07	Shari Pressnell	280 California St.	GA	74364	17
732	2011-02-14 10:44:00-08	Susanna Mercedes	9633 8th Ave.	NY	16708	35
733	2011-03-02 04:29:00-08	Edison Struthers	6914 44th Ave.	SC	79250	40
734	2011-10-02 21:09:00-07	Beverlee Crenshaw	3326 10th Ave.	NY	14913	5
735	2011-06-28 14:16:00-07	Kimi Mayon	9179 45th St.	TX	65654	20
736	2011-07-28 14:15:00-07	Samatha Mccubbin	2653 46th Ave.	IL	23318	41
737	2011-07-24 06:50:00-07	Yuki Garrels	8176 MLK Ave.	FL	19550	2
738	2011-07-07 11:23:00-07	Rivka Crete	1490 50th Ave.	TX	62560	49
739	2011-10-13 04:01:00-07	Ivana Breeding	9535 California St.	TX	69871	12
740	2011-09-20 12:31:00-07	Camie Stukes	8526 44th Ave.	CO	61659	25
741	2011-07-07 08:47:00-07	Eva Bukowski	5478 31st St.	WA	42854	21
742	2011-07-16 17:40:00-07	Jerald Langenfeld	1129 50th Ave.	WY	97711	50
743	2011-08-17 14:51:00-07	Danyelle Goldsberry	2250 44th Ave.	TX	45854	25
744	2011-02-04 08:45:00-08	Shawana Heavner	564 MLK Ave.	SC	24621	6
745	2011-01-23 12:44:00-08	Shari Barsh	9053 44th Ave.	NY	97390	8
746	2011-04-25 08:05:00-07	Derek Kroenke	7459 MLK Ave.	IL	44222	37
747	2011-09-15 09:38:00-07	Homer Mcqueeney	7011 44th Ave.	NY	66983	13
748	2011-10-22 20:27:00-07	Clay Doyel	6202 MLK Ave.	VA	80739	47
749	2011-01-24 18:43:00-08	Keri Sisemore	9830 43rd St.	SC	88253	2
750	2011-10-28 16:10:00-07	Bennie Tripodi	2521 50th Ave.	CO	71097	32
751	2011-10-13 16:09:00-07	Ngan Fontanilla	4227 45th St.	IL	99652	30
752	2011-03-24 08:05:00-07	Brandon Currier	9106 44th Ave.	GA	35161	50
753	2011-06-05 07:46:00-07	Gaylene Blumer	8295 50th Ave.	NY	85339	12
754	2011-05-04 15:06:00-07	Reed Pinegar	6212 44th Ave.	NY	67140	50
755	2011-10-18 23:34:00-07	Hiedi Gasper	7115 46th Ave.	FL	90508	46
756	2011-05-09 22:50:00-07	Thersa Hintzen	6847 44th Ave.	WA	83177	32
757	2011-01-04 15:41:00-08	Johnathon Doyel	4706 46th Ave.	VA	14114	41
758	2011-02-06 20:37:00-08	Theresia Yoshimura	6548 31st St.	WA	15364	29
759	2011-03-12 02:47:00-08	Kourtney Dorado	5852 Washington Ave.	TX	83413	1
760	2011-05-08 11:36:00-07	Candie Crete	4325 MLK Ave.	FL	65102	35
761	2011-02-07 12:01:00-08	Isabel Canter	5544 California St.	WY	27052	23
762	2011-03-29 16:35:00-07	Cherryl Kiser	5057 31st St.	IL	41689	33
763	2011-01-20 07:09:00-08	Trudie Haubrich	1502 50th Ave.	IL	39473	41
764	2011-02-19 12:55:00-08	Von Haefner	5337 44th Ave.	WY	14237	18
765	2011-03-11 19:42:00-08	Adell Emmerich	9431 Washington Ave.	CO	39044	40
766	2011-05-20 20:01:00-07	Hildred Currier	4301 44th Ave.	TX	54256	32
767	2011-05-22 09:33:00-07	Misty Chaffee	8261 California St.	NY	19416	13
768	2011-11-03 14:27:00-07	Cortney Kipp	6494 Washington Ave.	GA	75901	6
769	2011-05-26 13:47:00-07	Edmund Breeding	599 50th Ave.	CO	55808	22
770	2011-08-16 15:19:00-07	Edison Gasper	5214 8th Ave.	FL	62778	7
771	2011-02-24 14:50:00-08	Gaylene Cocke	1133 Washington Ave.	TX	45852	31
772	2011-05-16 17:07:00-07	Brady Birdsell	4929 31st St.	FL	78883	8
773	2011-06-16 11:42:00-07	Harley Mercedes	5649 Washington Ave.	VA	41306	47
774	2011-12-20 09:17:00-08	Earlean Bough	5548 35th St.42nd Ave.	IL	61383	32
775	2011-08-13 08:24:00-07	Missy Upson	9368 46th Ave.	VA	19115	24
776	2011-09-04 21:25:00-07	Susannah Mccubbin	8300 46th Ave.	SC	14675	8
777	2011-07-27 16:29:00-07	Chadwick Yoshimura	8446 31st St.	WA	92529	5
778	2011-01-27 15:32:00-08	Lawerence Benedetto	9887 8th Ave.	VA	60714	17
779	2011-02-22 17:12:00-08	Vincenzo Wassink	8531 35th St.42nd Ave.	SC	26315	12
780	2011-08-25 16:26:00-07	Maudie Alber	9553 46th Ave.	TX	87869	19
781	2011-11-23 01:15:00-08	Emely Medlen	5180 8th Ave.	CO	82727	19
782	2011-05-11 08:28:00-07	Rosemary Upson	5990 50th Ave.	VA	68820	19
783	2011-11-09 13:00:00-08	Brady Purtee	2214 MLK Ave.	NY	45803	31
784	2011-12-19 20:31:00-08	Quinton Stimac	723 46th Ave.	SC	61619	49
785	2011-07-03 18:27:00-07	Evelina Pellegrin	816 8th Ave.	SC	19170	47
786	2011-09-05 10:56:00-07	Berta Strayer	1132 California St.	NY	49114	39
787	2011-03-05 21:56:00-08	Granville Halpin	1789 44th Ave.	IL	56266	14
788	2011-04-17 13:29:00-07	Jannette Rodda	683 California St.	NY	53871	12
789	2011-08-15 21:29:00-07	Shera Harshberger	3499 43rd St.	GA	87671	30
790	2011-12-30 16:13:00-08	Missy Jay	113 35th St.42nd Ave.	SC	40341	3
791	2011-07-21 05:56:00-07	Meg Letellier	404 MLK Ave.	GA	58262	33
792	2011-01-06 21:36:00-08	Brandon Mayon	148 10th Ave.	GA	57222	6
793	2011-02-19 23:52:00-08	Danyelle Schrack	3233 46th Ave.	FL	60943	42
794	2011-09-07 12:58:00-07	Humberto Julian	6410 50th Ave.	FL	19255	42
795	2011-09-13 06:21:00-07	Dee Calico	8696 MLK Ave.	TX	94219	45
796	2011-10-21 13:48:00-07	Ivana Durio	7872 10th Ave.	FL	66404	1
797	2011-08-09 10:14:00-07	Williams Schauwecker	2496 8th Ave.	NY	98010	40
798	2011-07-15 13:57:00-07	Johnathan Kubala	179 10th Ave.	NY	28644	48
799	2011-06-24 21:57:00-07	Johnathan Letellier	9349 Washington Ave.	IL	25793	14
800	2011-07-19 13:47:00-07	Leonard Wichman	3327 8th Ave.	FL	15004	5
801	2011-03-05 13:16:00-08	Evelina Paramo	9077 35th St.42nd Ave.	VA	95151	41
802	2011-07-25 14:15:00-07	Mirta Hendon	6852 50th Ave.	VA	90958	27
803	2011-06-05 01:40:00-07	Homer Gravel	8660 31st St.	GA	71832	5
804	2011-12-03 02:42:00-08	Edison Damore	8602 50th Ave.	CO	77828	32
805	2011-05-23 15:41:00-07	Jill Bergeron	3194 31st St.	VA	33584	6
806	2011-02-14 15:23:00-08	Mauro Lesane	4020 45th St.	WY	65847	9
807	2011-03-22 13:33:00-07	Rosalinda Bodkin	2784 8th Ave.	VA	64881	19
808	2011-07-02 00:30:00-07	Trudie Upson	9280 10th Ave.	WY	63649	27
809	2011-02-28 21:36:00-08	Trudie Seabaugh	1209 California St.	WA	61669	23
810	2011-12-30 07:58:00-08	Rosalinda Crenshaw	3068 44th Ave.	FL	38012	41
811	2011-05-30 14:35:00-07	Angel Purtee	8249 43rd St.	SC	15034	6
812	2011-10-21 02:07:00-07	Colleen Arends	7049 43rd St.	VA	57149	45
813	2011-11-27 12:40:00-08	Irma Mcqueeney	5009 8th Ave.	WA	23364	46
814	2011-07-17 20:58:00-07	Takako Letellier	1258 45th St.	WA	18369	24
815	2011-03-07 17:45:00-08	Thersa Arent	6887 46th Ave.	FL	71692	31
816	2011-01-03 16:59:00-08	Kristofer Haubrich	9162 California St.	TX	44703	14
817	2011-11-10 11:36:00-08	Collin Tarnowski	1605 44th Ave.	IL	62863	36
818	2011-04-02 07:46:00-07	Emely Dougal	5196 31st St.	SC	76566	41
819	2011-05-29 02:59:00-07	Victor Garrels	4784 44th Ave.	FL	13148	6
820	2011-01-25 07:45:00-08	Reed Milam	3287 31st St.	WA	21196	9
821	2011-04-04 15:50:00-07	Lean Damore	7678 43rd St.	FL	69383	30
822	2011-08-13 11:39:00-07	Gena Rodda	9641 California St.	WA	67532	45
823	2011-06-11 09:07:00-07	Daniele Yoshimura	8529 Washington Ave.	VA	10190	15
824	2011-02-24 04:31:00-08	Charlotte Langenfeld	2982 50th Ave.	GA	27631	23
825	2011-01-12 13:10:00-08	Isabel Wanner	2689 Washington Ave.	FL	29667	3
826	2011-11-28 07:25:00-08	Shalon Barsh	1421 44th Ave.	NY	67957	29
827	2011-05-16 22:47:00-07	Romaine Luman	471 MLK Ave.	VA	43507	49
828	2011-03-15 16:54:00-07	Mikki Roles	2006 46th Ave.	CO	84091	4
829	2011-06-17 07:13:00-07	Buddy Levron	9966 8th Ave.	WA	97122	50
830	2011-10-06 05:55:00-07	Irma Lepore	1161 8th Ave.	CO	45216	45
831	2011-07-08 07:42:00-07	Jean Junge	3780 California St.	VA	63977	11
832	2011-09-29 19:25:00-07	Amos Benedetto	7117 46th Ave.	NY	19650	11
833	2011-10-20 20:45:00-07	Susannah Sandoval	2358 50th Ave.	GA	83886	25
834	2011-11-24 13:13:00-08	Emely Suits	1753 44th Ave.	FL	55350	35
835	2011-03-08 01:56:00-08	Renda Struthers	6454 35th St.42nd Ave.	TX	60927	28
836	2011-04-19 07:25:00-07	Irma Crowley	7351 8th Ave.	WA	30127	50
837	2011-02-16 12:44:00-08	Danyelle Haubrich	4744 46th Ave.	WA	10575	2
838	2011-02-25 17:17:00-08	Layne Fontanilla	5241 46th Ave.	WA	34689	30
839	2011-07-22 23:13:00-07	Danyelle Ridgley	8176 10th Ave.	FL	23810	27
840	2011-07-19 22:41:00-07	Miyoko Durio	5636 43rd St.	FL	16828	3
841	2011-06-09 18:02:00-07	Fidelia Rodda	6238 43rd St.	VA	15995	23
842	2011-10-22 00:26:00-07	Cammy Letellier	1154 50th Ave.	GA	97282	40
843	2011-04-22 19:30:00-07	Vincenzo Allbright	5199 California St.	WA	21335	33
844	2011-12-12 02:25:00-08	Isabel Tripodi	3282 Washington Ave.	SC	67699	44
845	2011-08-14 00:04:00-07	Kristofer Blumer	5866 44th Ave.	VA	51094	18
846	2011-01-29 22:08:00-08	Andrew Iriarte	7752 Washington Ave.	TX	24191	47
847	2011-03-13 09:24:00-07	Ronnie Garrels	5357 43rd St.	FL	26667	29
848	2011-10-03 15:18:00-07	Sherice Gilpatrick	6817 46th Ave.	VA	66763	6
849	2011-02-27 18:37:00-08	Buddy Kurth	1435 46th Ave.	SC	41569	45
850	2011-11-20 18:19:00-08	Isreal Crowley	8404 44th Ave.	FL	46926	17
851	2011-07-06 09:25:00-07	Antonio Hersey	8246 California St.	GA	41833	43
852	2011-05-05 16:59:00-07	Samatha Tarnowski	9856 43rd St.	VA	46578	14
853	2011-09-22 01:25:00-07	Sherilyn Blatt	7553 31st St.	WA	26399	26
854	2011-04-12 02:22:00-07	Leonard Heavner	1827 35th St.42nd Ave.	SC	24658	19
855	2011-07-17 19:28:00-07	Mauro Akey	1486 MLK Ave.	SC	47688	13
856	2011-02-01 22:21:00-08	Eleanor Blumer	2144 MLK Ave.	CO	31592	2
857	2011-02-08 19:12:00-08	Quinton Mccubbin	4237 31st St.	WY	16224	40
858	2011-01-27 14:37:00-08	Jonell Doyel	5205 10th Ave.	WY	94203	38
859	2011-02-15 02:24:00-08	Stacia Chivers	7134 California St.	VA	97225	45
860	2011-05-23 17:46:00-07	Nydia Calico	6790 43rd St.	WA	28021	47
861	2011-04-03 17:29:00-07	Layne Matheson	2349 35th St.42nd Ave.	WY	33387	45
862	2011-10-21 02:46:00-07	Lean Puett	6735 45th St.	GA	17320	31
863	2011-10-21 03:15:00-07	Una Dossey	1989 10th Ave.	CO	91601	37
864	2011-01-07 06:38:00-08	Jenee Upson	4659 43rd St.	WY	56224	36
865	2011-02-17 04:22:00-08	Andres Hersey	2372 MLK Ave.	WY	57097	47
866	2011-03-11 12:38:00-08	Rosalinda Mayon	8287 Washington Ave.	VA	39844	42
867	2011-02-12 07:23:00-08	Ngan Jeon	7658 35th St.42nd Ave.	WA	86422	31
868	2011-06-20 15:16:00-07	Amos Haefner	2715 8th Ave.	CO	53325	38
869	2011-04-06 15:42:00-07	Kimi Drexler	6887 46th Ave.	VA	64698	41
870	2011-02-10 20:39:00-08	Johnathan Knittel	4270 45th St.	WA	46938	40
871	2011-02-25 12:32:00-08	Andrew Roundtree	1588 8th Ave.	WY	11974	13
872	2011-01-26 06:41:00-08	Quinton Kimball	6956 8th Ave.	TX	22652	6
873	2011-03-08 10:37:00-08	Quinton Harshberger	2738 35th St.42nd Ave.	IL	12470	45
874	2011-10-11 11:06:00-07	Kristle Cousineau	955 8th Ave.	IL	48133	40
875	2011-06-13 06:49:00-07	Rivka Medlen	3812 31st St.	CO	47410	5
876	2011-12-27 08:01:00-08	Dee Lanphear	6038 46th Ave.	WY	89359	49
877	2011-05-21 01:54:00-07	Harrison Bonacci	6419 44th Ave.	NY	31030	35
878	2011-01-31 16:14:00-08	Collin Slone	9662 10th Ave.	CO	96886	16
879	2011-11-07 18:00:00-08	Jame Dilks	8873 31st St.	SC	96607	16
880	2011-07-07 15:12:00-07	Rubie Hendon	2139 MLK Ave.	WA	62250	2
881	2011-11-29 09:43:00-08	Antonio Alba	1461 45th St.	CO	92726	49
882	2011-12-17 18:16:00-08	Bud Medlen	3437 MLK Ave.	SC	56583	15
883	2011-03-26 00:31:00-07	Allen Chivers	1889 46th Ave.	WY	83083	47
884	2011-03-05 00:43:00-08	Daisey Li	4439 31st St.	CO	90653	46
885	2011-11-09 19:38:00-08	Georgina Barsh	6389 45th St.	CO	25105	7
886	2011-03-04 23:08:00-08	Hiedi Pressnell	7388 Washington Ave.	IL	28147	10
887	2011-11-19 01:24:00-08	Irma Wanner	9741 California St.	NY	16950	19
888	2011-06-04 09:13:00-07	Yuki Lanser	5651 46th Ave.	SC	39354	19
889	2011-06-01 13:57:00-07	Karole Buonocore	1368 MLK Ave.	IL	98178	6
890	2011-01-23 11:11:00-08	Jami Mayon	1430 Washington Ave.	TX	66513	33
891	2011-02-07 19:07:00-08	Jerald Nowakowski	2443 Washington Ave.	IL	32925	21
892	2011-10-23 02:50:00-07	Hildred Pinegar	5080 43rd St.	GA	84577	7
893	2011-04-21 03:12:00-07	Danyelle Schuh	6071 MLK Ave.	FL	86612	6
894	2011-11-17 07:40:00-08	Isabel Hedgpeth	7833 10th Ave.	WA	14737	37
895	2011-10-27 02:05:00-07	Susanna Birdsell	2383 8th Ave.	CO	69247	37
896	2011-11-26 02:23:00-08	Vincenzo Lepore	7297 MLK Ave.	IL	34989	8
897	2011-09-27 11:40:00-07	Homer Connors	3663 California St.	WA	19964	8
898	2011-04-10 03:34:00-07	Berta Birdsell	9304 46th Ave.	TX	22410	42
899	2011-11-11 19:40:00-08	Glen Morrissey	7565 8th Ave.	GA	19357	29
900	2011-06-30 01:43:00-07	Humberto Tartaglia	3458 California St.	CO	74270	11
901	2011-05-03 14:42:00-07	Evelyn Bodkin	3499 46th Ave.	CO	29269	4
902	2011-03-20 03:24:00-07	Buddy Mcclain	9987 California St.	IL	87470	25
903	2011-11-11 22:14:00-08	Jeffie Blatt	1943 8th Ave.	TX	53362	15
904	2011-03-20 16:22:00-07	Shelba Greenway	7847 50th Ave.	CO	67516	31
905	2011-10-10 17:10:00-07	Amos Crete	6857 46th Ave.	CO	33597	29
906	2011-05-05 01:40:00-07	Daisey Galvez	8573 43rd St.	WA	23696	27
907	2011-02-04 16:14:00-08	Emmitt Pinegar	5072 MLK Ave.	NY	70998	6
908	2011-05-07 14:56:00-07	Nathanial Hersey	7067 Washington Ave.	FL	62516	39
909	2011-09-21 03:26:00-07	Jame Yoshimura	3852 35th St.42nd Ave.	IL	49864	25
910	2011-04-19 09:42:00-07	Harley Connors	4738 31st St.	FL	44667	2
911	2011-12-21 11:57:00-08	Daniele Drexler	4501 8th Ave.	VA	11898	24
912	2011-01-28 03:33:00-08	Sherrill Akey	4928 35th St.42nd Ave.	CO	92339	29
913	2011-03-21 23:24:00-07	Maudie Dorado	885 44th Ave.	CO	41036	28
914	2011-09-22 07:52:00-07	Ruthie Petrin	8152 44th Ave.	WY	25067	18
915	2011-05-22 16:56:00-07	Tonette Benedetto	5776 Washington Ave.	WY	31160	24
916	2011-01-25 21:14:00-08	Isreal Mcclain	1619 43rd St.	SC	82189	15
917	2011-01-21 07:26:00-08	Una Westmoreland	7402 44th Ave.	WY	78115	18
918	2011-08-27 23:42:00-07	Reed Upson	3380 44th Ave.	NY	81279	12
919	2011-09-06 15:22:00-07	Bradly Dorado	8659 8th Ave.	CO	24696	34
920	2011-03-06 05:59:00-08	Camie Haefner	3053 50th Ave.	NY	65949	41
921	2011-02-12 17:31:00-08	Jeffie Langenfeld	8409 45th St.	CO	49813	7
922	2011-02-20 06:32:00-08	Andrew Buonocore	259 8th Ave.	NY	52048	16
923	2011-01-31 05:06:00-08	Vivian Langenfeld	3013 Washington Ave.	GA	38297	15
924	2011-02-05 12:07:00-08	Takako Blumer	2165 35th St.42nd Ave.	FL	24515	31
925	2011-04-29 20:09:00-07	Williams Selden	5981 45th St.	GA	42431	22
926	2011-07-05 02:53:00-07	Cortney Crissman	204 MLK Ave.	GA	72564	19
927	2011-05-07 13:09:00-07	Antonio Letellier	1344 8th Ave.	IL	30931	21
928	2011-11-03 23:53:00-07	Douglass Mayon	8413 MLK Ave.	SC	22567	6
929	2011-08-16 01:37:00-07	Eva Currier	4140 MLK Ave.	WY	25835	50
930	2011-03-15 00:02:00-07	Rivka Benedetto	2993 10th Ave.	WA	93423	28
931	2011-12-24 00:42:00-08	Kristofer Rodda	529 46th Ave.	VA	85858	32
932	2011-12-15 11:44:00-08	Nathanial Roles	9194 43rd St.	CO	63646	26
933	2011-06-19 17:06:00-07	Stacia Fretz	8334 Washington Ave.	CO	58604	48
934	2011-12-28 04:23:00-08	Danyel Delpriore	8755 10th Ave.	CO	38121	42
935	2011-01-01 19:09:00-08	Reed Drexler	8825 8th Ave.	SC	52472	10
936	2011-03-08 05:19:00-08	Wan Kubala	7082 10th Ave.	GA	79961	17
937	2011-06-07 19:14:00-07	Arianne Schuh	2583 Washington Ave.	CO	50556	44
938	2011-03-22 21:46:00-07	Maudie Morrissey	9422 46th Ave.	GA	70726	36
939	2011-01-19 01:35:00-08	Carolann Dement	8003 45th St.	SC	16451	2
940	2011-02-07 17:09:00-08	Catina Janzen	6189 Washington Ave.	VA	29953	10
941	2011-02-28 17:39:00-08	Russ Petrin	1814 50th Ave.	WA	31883	28
942	2011-03-19 17:41:00-07	Colleen Wassink	8127 Washington Ave.	WY	99593	48
943	2011-07-29 07:43:00-07	Milda Patnode	5189 35th St.42nd Ave.	IL	13644	45
944	2011-06-23 01:56:00-07	Susannah Greening	1218 35th St.42nd Ave.	CO	90396	25
945	2011-07-11 00:07:00-07	Harrison Doyel	2444 31st St.	IL	71397	13
946	2011-07-04 15:31:00-07	Granville Beasley	8230 Washington Ave.	IL	21782	38
947	2011-10-13 15:57:00-07	Vincenzo Canter	431 California St.	TX	25926	27
948	2011-05-11 05:32:00-07	Vivian Doyel	1044 31st St.	IL	89202	3
949	2011-12-18 09:57:00-08	Buddy Bulfer	301 8th Ave.	VA	31374	8
950	2011-09-25 02:31:00-07	Layne Lichtenstein	4679 10th Ave.	SC	10176	18
951	2011-07-14 08:38:00-07	Hiedi Mcdougle	6575 35th St.42nd Ave.	VA	34767	50
952	2011-02-23 23:40:00-08	Letitia Kubala	6371 45th St.	IL	22040	19
953	2011-05-23 12:40:00-07	Mirta Uyehara	707 California St.	WA	74112	11
954	2011-07-23 04:44:00-07	Edison Schippers	8016 50th Ave.	IL	53206	31
955	2011-03-07 08:18:00-08	Tonette Matheson	2759 Washington Ave.	IL	98923	7
956	2011-09-17 07:46:00-07	Alessandra Mccubbin	1788 31st St.	GA	22786	12
957	2011-03-13 10:10:00-07	Sherrill Delpriore	2414 35th St.42nd Ave.	NY	19970	14
958	2011-07-15 02:53:00-07	Jean Breeding	5607 50th Ave.	VA	10700	10
959	2011-05-30 14:46:00-07	Rosemary Mercedes	8046 44th Ave.	GA	74109	16
960	2011-10-21 01:40:00-07	Cherryl Julian	3392 10th Ave.	WY	68020	27
961	2011-04-02 01:10:00-07	Wynona Olmeda	9773 35th St.42nd Ave.	FL	61543	8
962	2011-10-01 01:39:00-07	Minerva Crays	1492 45th St.	VA	81866	48
963	2011-05-29 23:29:00-07	Alfonzo Bodkin	8330 10th Ave.	FL	62406	13
964	2011-05-27 14:12:00-07	Lula Ladwig	3586 31st St.	CO	48999	34
965	2011-07-11 09:02:00-07	Dee Garrels	7686 46th Ave.	TX	27454	41
966	2011-04-22 09:20:00-07	Minerva Roose	877 50th Ave.	NY	47558	11
967	2011-06-02 11:18:00-07	Sherilyn Bough	8308 50th Ave.	SC	73310	28
968	2011-02-08 19:55:00-08	Ngan Milam	1496 MLK Ave.	SC	55640	17
969	2011-11-06 12:18:00-08	Graciela Gilpatrick	7256 44th Ave.	NY	68109	10
970	2011-01-18 23:01:00-08	Eleanor Lightcap	1715 Washington Ave.	CO	51326	1
971	2011-03-31 04:56:00-07	Letitia Parrilla	5699 31st St.	FL	20962	7
972	2011-09-25 10:44:00-07	Buford Allbright	7610 50th Ave.	WY	64202	20
973	2011-10-29 04:18:00-07	Victor Janzen	8722 35th St.42nd Ave.	IL	88546	24
974	2011-04-06 15:43:00-07	Colleen Disney	8183 10th Ave.	IL	36051	3
975	2011-10-15 16:46:00-07	Harley Potter	7635 43rd St.	WY	74245	43
976	2011-01-14 15:33:00-08	Jeremiah Blumer	8376 45th St.	SC	26007	33
977	2011-04-08 19:09:00-07	Leonard Damore	9398 10th Ave.	TX	85334	33
978	2011-05-05 16:05:00-07	Sherilyn Maxson	823 10th Ave.	CO	59878	35
979	2011-03-08 20:27:00-08	Bradly Schrack	7932 8th Ave.	WA	59768	17
980	2011-09-22 03:06:00-07	Edmund Sprau	3229 8th Ave.	WA	84669	48
981	2011-02-09 08:07:00-08	Rolando Bough	3179 8th Ave.	WA	22907	33
982	2011-08-17 23:13:00-07	Thersa Gravel	2970 45th St.	IL	25466	33
983	2011-09-27 07:40:00-07	Reed Caba	5555 46th Ave.	CO	24275	3
984	2011-04-14 12:10:00-07	Fidelia Lesane	9006 50th Ave.	WA	29444	28
985	2011-10-09 18:34:00-07	Rolf Maxson	4231 10th Ave.	GA	82371	43
986	2011-10-24 12:40:00-07	Dewayne Seabaugh	4718 50th Ave.	WA	17484	17
987	2011-01-06 10:29:00-08	Chadwick Moe	3277 35th St.42nd Ave.	NY	99250	43
988	2011-09-30 10:10:00-07	Carmel Lanser	6783 California St.	NY	96692	27
989	2011-11-26 06:58:00-08	Nana Fruchter	9132 46th Ave.	GA	83639	6
990	2011-04-28 05:30:00-07	Wan Crissman	2995 50th Ave.	VA	32713	4
991	2011-09-21 01:01:00-07	Ricarda Sisemore	7889 45th St.	VA	16845	34
992	2011-08-07 03:59:00-07	Russ Seabaugh	5946 45th St.	SC	15468	24
993	2011-02-15 09:49:00-08	Buford Connors	4585 10th Ave.	GA	68876	29
994	2011-11-27 00:45:00-08	Harley Coderre	1735 44th Ave.	VA	45474	21
995	2011-08-17 18:22:00-07	Salvatore Rapozo	9683 50th Ave.	WA	13537	38
996	2011-07-06 06:45:00-07	Laurence Potter	211 8th Ave.	WY	57857	26
997	2011-06-23 00:27:00-07	Stacia Selden	2017 35th St.42nd Ave.	TX	43524	48
998	2011-10-14 13:26:00-07	Glen Alba	2663 35th St.42nd Ave.	CO	83571	48
999	2011-03-21 12:11:00-07	Bo Stimac	6617 45th St.	SC	71771	45
1000	2011-12-03 12:36:00-08	Hiedi Heavner	5977 35th St.42nd Ave.	CO	14885	42
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: craig
--

COPY users (id, email, password, details, created_at, deleted_at) FROM stdin;
1	Earlean.Bonacci@yahoo.com	029761dd44fec0b14825843ad0dfface	\N	2009-12-20 12:36:00-08	\N
2	Evelyn.Patnode@gmail.com	d678656644a3f44023f90e4f1cace1f4	"sex"=>"M"	2010-11-12 13:27:00-08	\N
3	Derek.Crenshaw@gmail.com	5ab7bc159c6371c65b41059097ff0efe	"sex"=>"F"	2009-03-07 19:06:00-08	\N
4	Shari.Julian@yahoo.com	9d38df22b71c8896137d363e29814e5f	"sex"=>"M"	2010-11-20 02:58:00-08	\N
5	Zita.Breeding@gmail.com	7a1c8d1d180d75da38efbd03f388472d	\N	2009-08-11 15:33:00-07	\N
6	Samatha.Hedgpeth@yahoo.com	e129316bf01b0440247414b715726956	"sex"=>"F"	2010-07-18 03:40:00-07	\N
7	Quinton.Gilpatrick@yahoo.com	7c63f3c25ee52041c2b9aec3c21a96b6	"sex"=>"M"	2010-09-02 14:56:00-07	\N
8	Vivian.Westmoreland@yahoo.com	100945c1684d6926dcafcacd967aedd9	"sex"=>"F", "state"=>"South Carolina"	2009-10-01 04:34:00-07	\N
9	Danny.Crays@gmail.com	511e3229996147ae68f83bab75b9733e	"sex"=>"M"	2009-04-22 00:30:00-07	\N
10	Edmund.Roles@yahoo.com	aeac2309a2b01e19177564126a6f8393	"sex"=>"F", "state"=>"New York"	2009-07-07 14:01:00-07	\N
11	Shanell.Lichtenstein@aol.com	98ac14b2c6b7bef8a55b5654aee5f28b	"sex"=>"M"	2009-05-21 17:18:00-07	\N
12	Romaine.Birdsell@aol.com	4571853f5ee73e305ac152c765ad2915	"sex"=>"F"	2009-01-13 21:07:00-08	\N
13	Zita.Luman@yahoo.com	7467fa8332bc45a15ad2c7003c963ea2	\N	2009-02-04 06:49:00-08	\N
14	Claud.Cousineau@gmail.com	82bcc0c4c3fc1a9bbae75dc7b8fabccc	"sex"=>"F"	2009-08-17 11:48:00-07	\N
15	Kali.Damore@yahoo.com	66327b7500c1b4a115910260418fd582	"sex"=>"F"	2010-07-07 03:28:00-07	\N
16	Graciela.Kubala@yahoo.com	85dbdc9fff08c157d7d10555009ef8ff	"sex"=>"F"	2010-08-18 22:42:00-07	\N
17	Theresia.Edwin@yahoo.com	87b2ae03da521142fd37676e6a3c376a	"sex"=>"M"	2010-08-11 01:21:00-07	\N
18	Ozella.Yoshimura@gmail.com	df68a6070ac1f18ce7a16baa96922948	"sex"=>"M"	2010-07-23 09:03:00-07	\N
19	Wynona.Greening@aol.com	176c818bc66324925ff6c274667e3e8f	"sex"=>"M"	2009-05-24 07:25:00-07	\N
20	Kimi.Mcqueeney@gmail.com	588169a56191c0f99b08e7a392e03ada	\N	2010-06-22 08:16:00-07	\N
21	Cherryl.Tarnowski@gmail.com	35981f660fedede469fce21cc146aa86	\N	2009-01-26 01:56:00-08	\N
22	Isabel.Breeding@gmail.com	a32fbb3e28f4cea747d0eef30aaf9ae5	\N	2010-07-11 06:28:00-07	\N
23	Ivana.Kurth@yahoo.com	ca72fafea92a1ef152006b53e2532571	\N	2010-06-25 01:36:00-07	\N
24	Humberto.Jonson@yahoo.com	642a91737480d3bbbf621689633ee9c3	\N	2009-09-23 06:09:00-07	\N
25	Ivana.Sosnowski@aol.com	f12980358430ee7ae192b041aa6ac05d	"sex"=>"M"	2009-01-16 03:55:00-08	\N
26	Cortney.Strayer@gmail.com	d80da950209cffdb96c76648d4f5b8f7	"sex"=>"M", "state"=>"Virginia"	2009-07-18 23:08:00-07	\N
27	Williams.Upson@gmail.com	de9a71ad16e0443955d38e4f6864d3c4	"sex"=>"F"	2010-08-09 22:48:00-07	\N
28	Jeremiah.Buonocore@yahoo.com	1994c6611461fc9d11683b50e540d701	\N	2009-03-19 00:49:00-07	\N
29	Ozella.Roles@gmail.com	8bee01c9b64ed4ca3e68f3c3502e1d85	\N	2009-10-09 02:44:00-07	\N
30	Salvatore.Arends@aol.com	8c64e4bf1574238287f230fde0314664	"sex"=>"F", "state"=>"Virginia"	2009-09-04 18:55:00-07	\N
31	Layne.Sarver@aol.com	296ca911a6fc78b4b3e75f927c16fcfd	"sex"=>"M"	2010-09-26 01:00:00-07	\N
32	Takako.Gilpatrick@aol.com	3abe3e825f6e749dca1b8193d5f15215	"sex"=>"M"	2009-02-22 07:46:00-08	\N
33	Russ.Mcclain@yahoo.com	cf17dc7c023e4a9f3fe6be05352aa57f	"sex"=>"F"	2010-01-12 09:27:00-08	\N
34	Claud.Westmoreland@aol.com	631f77eeef3e513c8aad646fdd73c03a	\N	2010-06-11 10:21:00-07	\N
35	Derek.Knittel@gmail.com	ce3ce9650891124de7f449c84a33ff71	"sex"=>"F"	2010-08-16 14:09:00-07	\N
36	Eleanor.Patnode@yahoo.com	c20912ab068921f869ee26724bdfc081	"sex"=>"F", "state"=>"Florida"	2010-06-05 18:27:00-07	\N
37	Carmel.Bulfer@aol.com	15267e65daa06c6fcde10c80f8a744d3	"sex"=>"F", "state"=>"Florida"	2009-06-06 13:13:00-07	\N
38	Mauro.Pung@yahoo.com	4e625168e5ea9bd548c303d20ecc95b5	"sex"=>"F", "state"=>"Illinois"	2009-08-19 19:34:00-07	\N
39	Sherilyn.Hamill@gmail.com	2f313c4006182796faf17d83e7f3312b	"sex"=>"M"	2010-04-01 16:39:00-07	\N
40	Glen.Lanphear@yahoo.com	66565168a637a3c5f43bdf5bf2e9313a	\N	2010-08-06 08:14:00-07	\N
41	Stacia.Schrack@aol.com	8a918b3f99c9d9aefbbd5de4fbc2ba07	"sex"=>"M"	2010-06-14 12:28:00-07	\N
42	Tonette.Alba@gmail.com	9e742176f6d41b88a4c77334267a8ac0	\N	2009-12-28 02:21:00-08	\N
43	Eve.Kump@yahoo.com	300b9c56bfe5d45417961ef08f28498a	"sex"=>"M"	2009-08-20 02:45:00-07	\N
44	Shanell.Maxson@gmail.com	e47a8b0056427f189f146889d457f5c2	"sex"=>"M"	2009-11-20 22:28:00-08	\N
45	Gudrun.Arends@gmail.com	735dba8760996aafd1b08b443c6fa4f9	\N	2010-06-30 05:30:00-07	\N
46	Angel.Lessley@yahoo.com	970efafe901fff211538e536ad797443	"sex"=>"F"	2009-08-21 10:06:00-07	\N
47	Harrison.Puett@yahoo.com	ff9e460aaca39a2c3bbd68043047826a	"sex"=>"M"	2009-07-21 08:20:00-07	\N
48	Granville.Hedgpeth@gmail.com	87f0bfd98e2a9b8d30bc1309936744cb	\N	2009-08-03 07:54:00-07	\N
49	Samatha.Pellegrin@yahoo.com	4e2a5f4b462636dbc7519bc49f841822	\N	2009-03-25 13:17:00-07	\N
50	Wan.Dilks@gmail.com	0650f5923e2abce41721d3d9ab37cc54	"sex"=>"M"	2009-10-08 15:43:00-07	\N
\.


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: craig
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: craig
--

ALTER TABLE ONLY purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: craig
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: purchase_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: craig
--

ALTER TABLE ONLY purchase_items
    ADD CONSTRAINT purchase_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: purchase_items_purchase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: craig
--

ALTER TABLE ONLY purchase_items
    ADD CONSTRAINT purchase_items_purchase_id_fkey FOREIGN KEY (purchase_id) REFERENCES purchases(id);


--
-- Name: purchases_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: craig
--

ALTER TABLE ONLY purchases
    ADD CONSTRAINT purchases_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

