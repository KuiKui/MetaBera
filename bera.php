<?php

// Récupération des heures par massif
$heuresBeraParMassif = [];
$hier = date('Ymd', strtotime('yesterday'));
$publicationHier = json_decode(récupérationViaAPIMétéoFrance("https://donneespubliques.meteofrance.fr/donnees_libres/Pdf/BRA/bra.$hier.json"), true);
foreach ($publicationHier as $ligne) {
    $heuresBeraParMassif[$ligne['massif']] = end($ligne['heures']);
}

$aujourdhui = date('Ymd');
$publicationAujourdhui = json_decode(récupérationViaAPIMétéoFrance("https://donneespubliques.meteofrance.fr/donnees_libres/Pdf/BRA/bra.$aujourdhui.json"), true);
foreach ($publicationAujourdhui as $ligne) {
    $heuresBeraParMassif[$ligne['massif']] = end($ligne['heures']);
}

// Récupération et vérification du massif demandé
$massif = strtoupper($_GET['massif']);
if (!in_array($massif, array_keys($heuresBeraParMassif))) {
    throw new \Exception('Massif non reconnu ou pas de BERA valide pour ce massif');
}

// Récupération du dernier BERA pour le massif s'il n'est pas présent en cache
$nomDuFichierBera = "$massif.$heuresBeraParMassif[$massif].xml";
if (!file_exists("cache/$nomDuFichierBera")) {
    $bera = récupérationViaAPIMétéoFrance("https://donneespubliques.meteofrance.fr/donnees_libres/Pdf/BRA/BRA.$nomDuFichierBera");
    $bera = str_replace('bra.xslt', '../bera.xslt', $bera);

    if (!is_dir('cache')) {
        mkdir('cache');
    }

    file_put_contents("cache/$nomDuFichierBera", $bera);
}

// Réponse directe en XML depuis le cache
header("Location: cache/$nomDuFichierBera");

// Factorisation de l'appel aux "APIs" de MétéoFrance
function récupérationViaAPIMétéoFrance($ressource)
{
    $requête = curl_init($ressource);
    curl_setopt($requête, CURLOPT_RETURNTRANSFER, 1);
    $réponse = curl_exec($requête);
    curl_close($requête);

    if ($réponse === false) {
        throw new \Exception("Erreur curl lors de la récupération de $ressource");
    }

    return $réponse;
}
