--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.7
-- Dumped by pg_dump version 9.6.3

--
-- TOC entry 2356 (class 0 OID 22999)
-- Dependencies: 254
-- Data for Name: decidim_types; Type: TABLE DATA; Schema: public; Owner: admin
--
-- DELETE FROM decidim_types;
INSERT INTO decidim_types VALUES (1, '{"ca": "Consulta prèvia a l''elaboració de la normativa", "es": "Consulta previa a la elaboración de la normativa"}', 1, '2017-08-29 12:59:17.92073', '2017-08-29 12:59:17.92073');
INSERT INTO decidim_types VALUES (2, '{"ca": "Consulta sobre projecte normatiu inicial", "es": "Consulta sobre el proyecto normativo inicial"}', 1, '2017-08-29 12:59:33.09987', '2017-08-29 12:59:33.09987');
INSERT INTO decidim_types VALUES (3, '{"ca": "Projecte normatiu en tràmit d''audiència i d''informació pública", "es": "Proyecto normativo en trámite de audiencia y de información pública"}', 1, '2017-08-29 13:00:46.118349', '2017-08-29 13:00:46.118349');


--
-- TOC entry 2362 (class 0 OID 0)
-- Dependencies: 253
-- Name: decidim_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('decidim_types_id_seq', 3, true);