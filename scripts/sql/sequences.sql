--
-- PostgreSQL database sequence update
--

-- Adding manually some registers to de database causes some troubles with the index on the sequences, giving
-- DUPLICATE_KEY errors on inserting objects on that database

-- We should alter some of those sequences to avoid those problems
-- ONLY do this if you face problems when creating Active Records linked to the sequence
ALTER SEQUENCE decicim_attachments_id_seq RESTART WITH 1000