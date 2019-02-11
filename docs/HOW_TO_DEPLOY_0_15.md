# KEEP IN MIND WHEN DEPLOYING 0.15

- S'ha d'executar la rake task de registres orphes, abans d'executar migracions perquè si no fallen al intentar buscar l'organització d'una propota per afegir-la en català
- Probablament s'hagi de fer un PR a part amb la rake task, i executar-la abans de fer el deploy
Posar el nom de les rake tasks a executar.

## Notes.
- Comentar les diferencies entre el Meeting Directory de Decidim i el que té Gencat. El millor seria quedar-se el de Decidim i afegir només l'enllaç al menú
- Comentar com funciona el sistema de blocks de la home. S'ha d'activar slider, 0.14, el FEDER.
- A la 0.15 es pot dir quants espais participatius surten a cada block de la home. Per defecte són 4.


- [x] Afegir DelayedJOB, per exectuar les metriques.
- S'ha d'inicialitzar 'bin/delayed_job start'
- Afegir Whenever
- Afegir al crontab, la rake tasks d'eliminació de dades del DataPortability, (pendent de la versió 13.)
- Afegir al crontab, la rake task de metriques. (v0.15.0)


No entenc com s'envien els mails si no hi ha un Job activat...
