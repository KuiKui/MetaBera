## Problème

Les BERA (Bulletins d'Estimation de Risques d'Avalanches) de Météo France sont publics, c'est bien. Mais il ne sont pas directement accessibles via une URL, c'est mal.

Il devient alors beaucoup plus compliqué de :
- les partager (ce qui est un comble pour une information publique de sécurité vitale !),
- les intégrer dans une iframe,
- réaliser des traitements automatiques.

## Solution

Le site [metaskirando](https://metaskirando.ovh/Nivo.php) s'est déjà occupé de récupérer les BERA pour les mettre à disposition du plus grand nombre, merci à eux !

Mais suite à mon besoin d'intégration des BERA dans une iframe, avec prise en compte du https et de la hauteur du rendu, j'ai fait un micro script permettant de récupérer les BERA :
- via une url fixe,
- utilisant les derniers xslt et css de Météo France,
- toujours à la dernière version (avec la gestion simplifiée d'un cache),
- avec du js permettant une meilleure intégration dans une iframe.

Ce script est un POC, il est simple et moche, mais il fonctionne.

## Utilisation

Cloner le projet puis lancer un serveur PHP dans le répertoire du projet :

```
$ php -S localhost:8000
```

Accéder ensuite à l'url `http://localhost:8000/bera.php?massif=CHAMPSAUR` en précisant le massif parmi les 36 disponibles (voir ci-après).


## Configuration dans une iframe

Afin de pouvoir gérer correctement l'affichage des BERA dans une iframe, le script utilise la librairie JS [iframe-resizer](https://github.com/davidjbradshaw/iframe-resizer).

Télécharger le script [iframeResizer.min.js](https://raw.githubusercontent.com/davidjbradshaw/iframe-resizer/master/js/iframeResizer.min.js) et ajouter ces quelques lignes dans la page contenant l'iframe pointant sur le BERA :

```html
<iframe id="bera" src="http://localhost:8000/bera.php?massif=OISANS"></iframe>

<script src="js/iframeResizer.min.js"></script>
<script>
  iFrameResize({}, '#bera')
</script>
```

L'iframe s'affiche ensuite automatiquement à la bonne hauteur et gère correctement le défilement.

## Massifs disponibles

`BELLEDONNE`, `CHARTREUSE`, `GRANDES-ROUSSES`, `OISANS`, `VERCORS`, `ASPE-OSSAU`, `AURE-LOURON`, `HAUTE-BIGORRE`, `LUCHONNAIS`, `PAYS-BASQUE`, `BAUGES`, `BEAUFORTAIN`, `HAUTE-MAURIENNE`, `HAUTE-TARENTAISE`, `MAURIENNE`, `VANOISE`, `ARAVIS`, `CHABLAIS`, `MONT-BLANC`, `CINTO-ROTONDO`, `RENOSO-INCUDINE`, `ANDORRE`, `CAPCIR-PUYMORENS`, `CERDAGNE-CANIGOU`, `COUSERANS`, `HAUTE-ARIEGE`, `ORLU__ST_BARTHELEMY`, `CHAMPSAUR`, `DEVOLUY`, `EMBRUNAIS-PARPAILLON`, `HAUT-VAR_HAUT-VERDON`, `MERCANTOUR`, `PELVOUX`, `QUEYRAS`, `THABOR`, `UBAYE`.

