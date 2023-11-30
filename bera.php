<?php

//-----------------------------
// Initialisation des variables
//-----------------------------

// Récupération de la clé d'API
$cléAPI = getenv('METEOFRANCE_API_KEY');
if ($cléAPI === false) {
    throw new \Exception('Clé API manquante');
}

// Table de correspondance des massifs
$correspondanceMassif = [
    'CHABLAIS' => '1',
    'ARAVIS' => '2',
    'MONT-BLANC' => '3',
    'BAUGES' => '4',
    'BEAUFORTAIN' => '5',
    'HAUTE-TARENTAISE' => '6',
    'CHARTREUSE' => '7',
    'BELLEDONNE' => '8',
    'MAURIENNE' => '9',
    'VANOISE' => '10',
    'HAUTE-MAURIENNE' => '11',
    'GRANDES-ROUSSES' => '12',
    'THABOR' => '13',
    'VERCORS' => '14',
    'OISANS' => '15',
    'PELVOUX' => '16',
    'QUEYRAS' => '17',
    'DEVOLUY' => '18',
    'CHAMPSAUR' => '19',
    'EMBRUNNAIS-PARPAILLON' => '20',
    'UBAYE' => '21',
    'HAUT-VAR-HAUT-VERDON' => '22',
    'MERCANTOUR' => '23',
    'CINTO-ROTONDO' => '40',
    'RENOSO-INCUDINE' => '41',
    'PAYS-BASQUE' => '64',
    'ASPE-OSSAU' => '65',
    'HAUTE-BIGORRE' => '66',
    'AURE-LOURON' => '67',
    'LUCHONNAIS' => '68',
    'COUSERANS' => '69',
    'HAUTE-ARIEGE' => '70',
    'ANDORRE' => '71',
    'ORLU-ST-BARTHELEMY' => '72',
    'CAPCIR-PUYMORENS' => '73',
    'CERDAGNE-CANIGOU' => '74',
];

//---------------------
// Exécution principale
//---------------------

// Récupération du massif depuis la requête
$massif = strtoupper($_GET['massif']);
if (!in_array($massif, array_keys($correspondanceMassif))) {
    throw new \Exception('Massif non reconnu');
}

$fichierBera = "cache/$massif/bera.xml";

// Régénération du cache si :
// - Le fichier n'existe pas.
// - Le fichier existe depuis plus de 10 minutes.
if (!file_exists($fichierBera) || (time() - filemtime($fichierBera) > 600)) {
    récupérationInformationsMassif($cléAPI, $massif, $correspondanceMassif);
}

// Redirection vers le XML du cache
header("Location: $fichierBera");

//----------
// Fonctions
//----------

function récupérationInformationsMassif($cléApi, $massif, $correspondanceMassif)
{
    $répertoireMassif = "cache/$massif";

    if (!is_dir($répertoireMassif)) {
        mkdir($répertoireMassif, 0744, true);
    }

    $numéroMassif = $correspondanceMassif[$massif];

    $ressources = [
        'BRA?format=xml&id-massif='.$numéroMassif => $répertoireMassif.'/bera.xml',
        'image/montagne-risques?id-massif='.$numéroMassif => sprintf("%s/montagne_risques_%s.png", $répertoireMassif, $numéroMassif),
        'image/rose-pentes?id-massif='.$numéroMassif => sprintf("%s/rose_pentes_%s.png", $répertoireMassif, $numéroMassif),
        'image/montagne-enneigement?id-massif='.$numéroMassif => sprintf("%s/montagne_enneigement_%s.png", $répertoireMassif, $numéroMassif),
        'image/graphe-neige-fraiche?id-massif='.$numéroMassif => sprintf("%s/graphe_neige_fraiche_%s.png", $répertoireMassif, $numéroMassif),
        'image/apercu-meteo?id-massif='.$numéroMassif => sprintf("%s/apercu_meteo_%s.png", $répertoireMassif, $numéroMassif),
        'image/sept-derniers-jours?id-massif='.$numéroMassif => sprintf("%s/sept_derniers_jours_%s.png", $répertoireMassif, $numéroMassif),
    ];

    foreach ($ressources as $ressource => $destination) {
        récupérationRessourceViaAPI($cléApi, $ressource, $destination);
    }

    // Modification à l'arrache pour faire correspondre le xml à l'arborescence.
    $contenu = file_get_contents($répertoireMassif.'/bera.xml');
    $contenu = str_replace('../web/bra.xslt', '../../bera.xslt', $contenu);
    file_put_contents($répertoireMassif.'/bera.xml', $contenu);
}

function récupérationRessourceViaAPI($cléAPI, $ressource, $destination)
{
    $emplacement = 'https://public-api.meteofrance.fr/public/DPBRA/v1/massif/' . $ressource;
    $requête = curl_init($emplacement);
    curl_setopt($requête, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($requête, CURLOPT_HTTPHEADER, ["apikey: $cléAPI"]);
    $réponse = curl_exec($requête);
    curl_close($requête);

    if ($réponse === false) {
        throw new \Exception("Erreur curl lors de la récupération de $ressource");
    }

    file_put_contents($destination, $réponse);
}
