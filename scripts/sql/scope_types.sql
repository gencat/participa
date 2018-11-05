--
-- PostgreSQL database dump
--

INSERT INTO decidim_scope_types VALUES (1, 1, '{"ca": "provincia", "en": "province", "es": "province", "oc": "provincia"}','{"ca": "provincies", "en": "provinces", "es": "provincias", "oc": "provincies"}');
INSERT INTO decidim_scope_types VALUES (2, 1, '{"ca": "municipi", "en": "municipality", "es": "municipio", "oc":"municipi"}', '{"ca": "municipis", "en": "municipalities", "es": "municipios", "os": "municipis"}');

SELECT pg_catalog.setval('decidim_scope_types_id_seq', 2, true);