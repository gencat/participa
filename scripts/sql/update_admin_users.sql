--
-- Esto es necesarioo sólo si hemos hecho una migración de usuarios en los que el rol de admin se le asigna mediante 
-- roles={admin} en vez de poner a true la columna "admin". Esto causa que al borrar un usuario desde la administración
-- se siga viendo el rol de administración y siga apareciendo
--
-- Actualiza los usuarios para que aquellos con roles{admin} sean {} y su columna admin sea true
UPDATE public.decidim_users
SET roles = '{}', admin = true
WHERE roles = '{admin}'