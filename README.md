# DREAL

Interface web à destination de la dreal afin de:
* Donner un questionnaire sur les ODD
* Diffuser les résultats
* Permettre de définir et sensibiliser aux ODD

## Installation

Les prochaines étapes vont vous permettre de vous doter d'une version de développement de DREAL

### Prerequis

Il vous faudra une version de R et Rstudio à jour

[R studio](https://www.rstudio.com/products/rstudio/download/)


### Installation du repos

```
git clone https://github.com/manderhalt/dreal.git
```

### Installation des packages

Il faudra executer le fichier *package_dependency.R* afin d'importer le package divwheel qui est un add on Javascript de la roue.


### Dev guide

4 fichiers différents:
* server.R: server de shiny
* ui.R: ui de shiny
* data.R: data nécessaire au bon fonctionnement
* helper.R: fonctions nécessaires au bon fonctionnement

1 package R html-widget:
* divwheel: besoin de modifier divwheel.js et divwheel.R pour tout changement sur la roue


## Versioning

Versioning classique, à jour sur le changelog

### Déploiement

psql -h ec2-46-137-170-51.eu-west-1.compute.amazonaws.com -d dfc1pthbflg0oa -U tqzzczaqbdfgsn -p 5432 -f dump.sql



