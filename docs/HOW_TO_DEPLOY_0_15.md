## Notes.
- Comentar les diferencies entre el Meeting Directory de Decidim i el que té Gencat. El millor seria quedar-se el de Decidim i afegir només l'enllaç al menú
- Comentar com funciona el sistema de blocks de la home. S'ha d'activar slider, 0.14, el FEDER.
- A la 0.15 es pot dir quants espais participatius surten a cada block de la home. Per defecte són 4.


- [x] Afegir DelayedJOB, per exectuar les metriques.
- S'ha d'inicialitzar `bin/delayed_job start`
- [x] Afegir Whenever
- [x] Afegir al crontab, la rake tasks d'eliminació de dades del DataPortability, (pendent de la versió 13.)
- [x] Afegir al crontab, la rake task de metriques. (v0.15.0)
- S'ha d'actualitzar el crontab `whenever --update-crontab`

No entenc com s'envien els mails si no hi ha un Job activat...
