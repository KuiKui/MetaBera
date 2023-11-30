# Méta BERA

Nano service pour rendre accessibles les BERA (Bulletins d'Estimation de Risques d'Avalanches).

Exemple : https://bulletin.metabera.ovh/bera.php?massif=BAUGES

## Problème

Les BERA de Météo France sont publiques, c'est bien. Mais il ne sont pas directement accessibles via une URL, c'est mal.

Il devient alors beaucoup plus compliqué de :
- les partager (ce qui est un comble pour une information publique de sécurité vitale !),
- les intégrer dans une iframe,
- réaliser des traitements automatiques.

## Solution

Le site [metaskirando](https://metaskirando.ovh/Nivo.php) s'est déjà occupé de récupérer les BERA pour les mettre à disposition du plus grand nombre, merci à eux !

Mais suite à mon besoin d'intégration des BERA dans une iframe, avec prise en compte du https et de la hauteur du rendu, j'ai fait un micro script permettant d'accéder aux BERA :
- via une url fixe,
- utilisant les derniers xslt et css de Météo France,
- sans besoin d'avoir une clé d'API Météo France,
- avec une gestion de cache de 10 minutes pour éviter de spammer l'API de Météo France,
- avec du javascript permettant une meilleure intégration dans une iframe.

Une intégration est visible sur ma page https://lagrave.ovh

## Utilisation

Cloner le projet puis lancer un serveur PHP dans le répertoire du projet, après avoir configuré votre clé d'API dans la variable d'environnement adéquate :

```
export METEOFRANCE_API_KEY='votre-clé-api-récupérée-sur-le-site-de-météo-france'
php -S localhost:8000
```

Accéder ensuite à l'url `http://localhost:8000/bera.php?massif=CHAMPSAUR` en précisant le massif parmi les 36 disponibles (voir ci-après).

## Configuration dans une iframe

Afin de pouvoir gérer correctement l'affichage des BERA dans une iframe, le script utilise la librairie JS [iframe-resizer](https://github.com/davidjbradshaw/iframe-resizer).

Inclure le script [iframeResizer.min.js](https://raw.githubusercontent.com/davidjbradshaw/iframe-resizer/master/js/iframeResizer.min.js) et ajouter ces quelques lignes dans la page contenant l'iframe pointant sur le BERA :

```html
<iframe id="bera" src="https://bulletin.metabera.ovh/bera.php?massif=OISANS"></iframe>

<script src="js/iframeResizer.min.js"></script>
<script>
  iFrameResize({}, '#bera')
</script>
```

L'iframe s'affiche ensuite automatiquement à la bonne hauteur et gère correctement le défilement.

## Massifs disponibles

`CHABLAIS`, `ARAVIS`, `MONT-BLANC`, `BAUGES`, `BEAUFORTAIN`, `HAUTE-TARENTAISE`, `CHARTREUSE`, `BELLEDONNE`, `MAURIENNE`, `VANOISE`, `HAUTE-MAURIENNE`, `GRANDES-ROUSSES`, `THABOR`, `VERCORS`, `OISANS`, `PELVOUX`, `QUEYRAS`, `DEVOLUY`, `CHAMPSAUR`, `EMBRUNNAIS-PARPAILLON`, `UBAYE`, `HAUT-VAR-HAUT-VERDON`, `MERCANTOUR`, `CINTO-ROTONDO`, `RENOSO-INCUDINE`, `PAYS-BASQUE`, `ASPE-OSSAU`, `HAUTE-BIGORRE`, `AURE-LOURON`, `LUCHONNAIS`, `COUSERANS`, `HAUTE-ARIEGE`, `ANDORRE`, `ORLU-ST-BARTHELEMY`, `CAPCIR-PUYMORENS`, `CERDAGNE-CANIGOU`.

## Résultat

