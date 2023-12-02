<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
	<xsl:param name="urlBlob"/>

  <!--Chemin acces css -->
  <xsl:variable name="urlCss">
    <xsl:text>https://meteofrance.com/modules/custom/mf_map_layers_v2/assets/BRA.css</xsl:text>
  </xsl:variable>

  <!-- chemin d'accès au picto -->
  <xsl:variable name="CheminPicto">
    <xsl:text>https://meteofrance.com/modules/custom/mf_map_layers_v2/assets/images/</xsl:text>
  </xsl:variable>

  <!-- Canevas général des diverses versions -->
  <xsl:template match="BULLETINS_NEIGE_AVALANCHE">
      <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
      <html lang="fr">
          <head>
              <title>MetaBERA</title>
              <link rel="stylesheet" type="text/css">
                  <xsl:attribute name="href">
                      <xsl:value-of select="$urlCss"/>
                  </xsl:attribute>
              </link>
          </head>
          <body>
            <div id="BRA">
                <xsl:for-each select="BRA">
                    <xsl:call-template name="trame"/>
                </xsl:for-each>
                <xsl:if test="@ID!=''">
                    <xsl:call-template name="trame"/>
                </xsl:if>
            </div>
            <script src="../../js/iframeSizer.contentWindow.min.js"></script>
          </body>
      </html>
  </xsl:template>


  <!--    TRAME GENERALE   -->

  <!-- Trame générale du bulletin-->
  <xsl:template name ="trame">
    <!-- Entête-->
    <div class="BRAentete">
         <h1>
            Bulletin d'estimation du risque d'avalanche
          </h1>
      <h4>
        (valable en dehors des pistes balisées et ouvertes)
      </h4>
      <h1>
        <xsl:text disable-output-escaping="yes"> MASSIF : </xsl:text>
        <xsl:value-of select="@MASSIF"/>
      </h1>
      <h4>
        <xsl:text disable-output-escaping="yes">rédigé le </xsl:text>
        <xsl:call-template name="DateLong">
          <xsl:with-param name="date-heure" select="@DATEBULLETIN"/>
          <xsl:with-param name="avecAnnee" select="string('oui')"/>
        </xsl:call-template>
        <xsl:text disable-output-escaping="yes"> à </xsl:text>
        <xsl:value-of select="substring-before(substring-after(@DATEBULLETIN,'T'),':')"/>
        <xsl:text disable-output-escaping="yes"> h.</xsl:text>
      </h4>
      <xsl:if test="@AMENDEMENT='true'">
        <p class="baliseAmendement">
          ** AMENDEMENT **
        </p>
      </xsl:if>
				<p><xsl:copy-of select="/BULLETINS_NEIGE_AVALANCHE/TexteMeta/Vigilance"/></p>
				<p><xsl:copy-of select="/BULLETINS_NEIGE_AVALANCHE/TexteMeta/EnteteGenerique"/></p>
				<!--<p>Pour consulter la vigilance en cours, veuillez vous rendre sur le site <a href="https://vigilance.meteofrance.fr/fr">https://vigilance.meteofrance.fr/fr</a></p>-->
    </div>
        <h2>
				Estimation des risques
        </h2>

    <!-- rubrique risque-->
		<div id="estimation-risque" class="row">
    <xsl:apply-templates select="CARTOUCHERISQUE"/>
		</div>

    <!-- Entete seconde rubrique stabilite-->
      <p class="legende">Indices de risque : 5 très fort - 4 fort - 3 marqué - 2 limité - 1 faible   --  En noir : les pentes les plus dangereuses</p>
      <h2>
        Stabilité du manteau neigeux jusqu'au
          <xsl:call-template name="DateLong">
            <xsl:with-param name="date-heure" select="@DATEECHEANCE"/>
            <xsl:with-param name="avecAnnee" select="string('oui')"/>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes"> au soir</xsl:text>

      </h2>

    <!-- rubrique stabilité-->
    <pre id="stabilite">


		<xsl:choose>
		<xsl:when test="STABILITE/SitAvalTyp/@SAT1 != ''">
		<!--<a>
		<xsl:attribute name="target">_blank</xsl:attribute>
		<xsl:attribute name="href">
		<xsl:text disable-output-escaping="yes">static/problemes.html#</xsl:text>
		<xsl:call-template name ="ancreSAT">
		<xsl:with-param name="SAT" select="STABILITE/SitAvalTyp/@SAT1"/>
		</xsl:call-template>
		</xsl:attribute>-->

		<img>
		<xsl:attribute name="src">
		<xsl:value-of select="$CheminPicto"/>
		<xsl:text disable-output-escaping="yes">SAT</xsl:text>
		<xsl:value-of select="STABILITE/SitAvalTyp/@SAT1"/>
		<xsl:text disable-output-escaping="yes">.png</xsl:text>
		</xsl:attribute>
		<xsl:attribute name ="title">
		<xsl:call-template name ="texteSAT">
		<xsl:with-param name="SAT" select="STABILITE/SitAvalTyp/@SAT1"/>
		</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name ="alt">
		<xsl:call-template name ="texteSAT">
		<xsl:with-param name="SAT" select="STABILITE/SitAvalTyp/@SAT1"/>
		</xsl:call-template>
		</xsl:attribute>
		</img>
		<!--</a>-->
		</xsl:when>
		</xsl:choose>

 		<xsl:choose>
		<xsl:when test="STABILITE/SitAvalTyp/@SAT2 != ''">
		<!--<a>
		<xsl:attribute name="target">_blank</xsl:attribute>
		<xsl:attribute name="href">
		<xsl:text disable-output-escaping="yes">static/problemes.html#</xsl:text>
		<xsl:call-template name ="ancreSAT">
		<xsl:with-param name="SAT" select="STABILITE/SitAvalTyp/@SAT2"/>
		</xsl:call-template>
		</xsl:attribute>-->

		<img>
		<xsl:attribute name="src">
		<xsl:value-of select="$CheminPicto"/>
		<xsl:text disable-output-escaping="yes">SAT</xsl:text>
		<xsl:value-of select="STABILITE/SitAvalTyp/@SAT2"/>
		<xsl:text disable-output-escaping="yes">.png</xsl:text>
		</xsl:attribute>
		<xsl:attribute name ="title">
		<xsl:call-template name ="texteSAT">
		<xsl:with-param name="SAT" select="STABILITE/SitAvalTyp/@SAT2"/>
		</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name ="alt">
		<xsl:call-template name ="texteSAT">
		<xsl:with-param name="SAT" select="STABILITE/SitAvalTyp/@SAT2"/>
		</xsl:call-template>
		</xsl:attribute>
		</img>
		<!--</a>-->
		</xsl:when>
		</xsl:choose>
       <xsl:value-of select="STABILITE/TEXTE"/>
    </pre>

    <!-- Rubrique météo et neige fraîche -->
    <xsl:if test="@AMENDEMENT='false'">
      <div class="row">
        <!--Rubrique neige fraîche-->
        <div class="col1">
              <h2>
                <xsl:text disable-output-escaping="yes"> Neige fraîche à </xsl:text>
                <xsl:value-of select="NEIGEFRAICHE/@ALTITUDESS" />
                <xsl:text disable-output-escaping="yes"> m</xsl:text>
              </h2>
		<img>
		<xsl:attribute name="src">
		<xsl:value-of select="$urlBlob"/>
		<xsl:value-of select="NEIGEFRAICHE/ImageNeigeFraiche"/>
		</xsl:attribute>
		<xsl:attribute name ="alt">Graphe de neige fraîche</xsl:attribute>
		</img>

        </div>
        <!-- Rubrique météo -->
        <div class="col2">
              <h2>
                Aperçu météo
              </h2>
 <!--         <xsl:apply-templates select="METEO"/>-->
		<img>
		<xsl:attribute name="src">
		<xsl:value-of select="$urlBlob"/>
		<xsl:value-of select="METEO/ImageMeteo"/>
		</xsl:attribute>
		<xsl:attribute name ="alt">Graphe d'enneigement</xsl:attribute>
		</img>

        </div>
      </div>

      <!-- Rubrique enneigement et qualité-->

      <div class="row">
        <!-- rubrique enneigement-->
        <div class="col1">
            <h2>Epaisseur de neige hors-piste</h2>
		<img>
		<xsl:attribute name="src">
		<xsl:value-of select="$urlBlob"/>
		<xsl:value-of select="ENNEIGEMENT/ImageEnneigement"/>
		</xsl:attribute>
		<xsl:attribute name ="alt">Graphe Météo</xsl:attribute>
		</img>


        </div>
        <!-- Rubrique qualité-->
        <div class="col2">
            <h2>Qualité de la neige</h2>
          <pre>
            <xsl:value-of select="QUALITE"/>
          </pre>
        </div>
      </div>
    </xsl:if>
    <!-- cas des ammendement -->
    <xsl:if test="@AMENDEMENT='true'">
      <div class="row">
        <div class="col2">
          <h2>
            Aperçu météo
          </h2>
          <!-- <xsl:apply-templates select="METEO"/>-->
          <img>
          <xsl:attribute name="src">
          <xsl:value-of select="$urlBlob"/>
          <xsl:value-of select="METEO/ImageMeteo"/>
          </xsl:attribute>
          <xsl:attribute name ="alt">Graphe Météo</xsl:attribute>
          </img>
        </div>
      </div>
    </xsl:if>

    <!-- BSH -->
    <xsl:if test="count(BSH)!=0">
      <h2>
        Conditions nivo-météo des 7 derniers jours
      </h2>
      <div id="BSH">
			<img id="BSH_graph_paysage">
		<xsl:attribute name="src">
		<xsl:value-of select="$urlBlob"/>
		<xsl:value-of select="BSH/Image7derniersjours"/>
		</xsl:attribute>
		<xsl:attribute name ="alt">Graphe de conditions nivo-meteo</xsl:attribute>
			</img>
			<img id="BSH_graph_portrait">
		<xsl:attribute name="src">
		<xsl:value-of select="$urlBlob"/>
		<xsl:value-of select="BSH/Image7derniersjours_portrait"/>
		</xsl:attribute>
		<xsl:attribute name ="alt">Graphe de conditions nivo-meteo</xsl:attribute>
			</img>

      </div>
    </xsl:if>
		<p class="basdepage"><xsl:copy-of select="/BULLETINS_NEIGE_AVALANCHE/TexteMeta/BasDePageGenerique"/></p>
		<p class="basdepage"><xsl:copy-of select="/BULLETINS_NEIGE_AVALANCHE/TexteMeta/LienDocumentation"/></p>
    <!-- Bas de page -->
    <!--<p class="basdepage">Rédigé par Météo-France avec la contribution des observateurs du réseau nivo-météorologique. Partenariat : ANMSM (Maires de Stations de Montagne), DSF (Domaines Skiables de France), ADSP (Directeurs de Pistes et de la Sécurité des Stations de Sports d'Hiver) et autres acteurs de la montagne.</p>-->
		<p class="basdepage"><xsl:copy-of select="/BULLETINS_NEIGE_AVALANCHE/TexteMeta/Partenaires"/></p>
  </xsl:template>

  <!-- TRAITEMENT DES RUBRIQUES -->

  <!-- RUBRIQUE RISQUE  -->
  <xsl:template match="CARTOUCHERISQUE">
		<div id="risque-j1" class="col1">
		<h3>
		<xsl:call-template name="DateLong">
		<xsl:with-param name="date-heure" select="/BULLETINS_NEIGE_AVALANCHE/DateValidite"/>
		<xsl:with-param name="avecAnnee" select="string('non')"/>
		</xsl:call-template>
		</h3>
    <div class="Risque">
		<div class="bloc1">
     <!-- Risque Maxi - BRA-Amendement-ancien xml -->
            <div class="risqueMaxi">
              <img >
                <xsl:attribute name="src">
                  <xsl:value-of select="$CheminPicto"/>
                  <xsl:text disable-output-escaping="yes">R</xsl:text>
                  <xsl:value-of select="RISQUE/@RISQUEMAXI"/>
                  <xsl:text disable-output-escaping="yes">.png</xsl:text>
                </xsl:attribute>
                <xsl:attribute name ="alt">
                  <xsl:call-template name ="texteRisque">
                    <xsl:with-param name="risque" select="RISQUE/@RISQUEMAXI"/>
                  </xsl:call-template>
                </xsl:attribute>
              </img>
            </div>

	<!--	</div>
		<div class="bloc2">-->
      <!--Figurine-->
      <div class="figurineRisque">
        <img>
					<xsl:attribute name="src">
		<xsl:value-of select="$urlBlob"/>
					<xsl:value-of select="ImageRisque"/>

					</xsl:attribute>
          <xsl:attribute name="alt">
            Risque détaillé
          </xsl:attribute>
        </img>
      </div>
      <!--Figurine-->
      <div class="figurinePente">
        <img>
					<xsl:attribute name="src">
		<xsl:value-of select="$urlBlob"/>
						<xsl:value-of select="ImagePente"/>
					</xsl:attribute>
          <xsl:attribute name="alt">
					<xsl:value-of select="PENTE/@COMMENTAIRE"/>
          </xsl:attribute>
        </img>
      </div>
		</div>
      <!--catouche-->
          <div class="cartouche">
   <p>
      <xsl:value-of select="RISQUE/@COMMENTAIRE"/>
    </p>
            <xsl:if test="AVIS!=''">
              <xsl:choose>
                <xsl:when test="VIGILANCE=''">
                  <p class="avis">
                    <xsl:value-of select="AVIS"/>
                  </p>
                </xsl:when>
                <xsl:when test="VIGILANCE='JAUNE'">
                  <p class="avis">
                    <xsl:value-of select="AVIS"/>
                  </p>
                </xsl:when>
                <xsl:when test="VIGILANCE='ORANGE'">
                  <p class="vigilanceOrange">
                    <xsl:value-of select="AVIS"/>
                    <br/>
                    <xsl:text>(vigilance orange)</xsl:text>
                  </p>
                </xsl:when>
                <xsl:when test="VIGILANCE='ROUGE'">
                  <p class="vigilanceRouge">
                    <xsl:value-of select="AVIS"/>
                    <br/>
                    <xsl:text>(vigilance rouge)</xsl:text>
                  </p>
                </xsl:when>
              </xsl:choose>
            </xsl:if>

            <p>
              <b>Départs spontanés : </b>
              <xsl:value-of select="NATUREL"/>
              <br/>
              <xsl:if test="AVIS=''">
                <br/>
              </xsl:if>
              <b>Déclenchements skieurs : </b>
              <xsl:value-of select="ACCIDENTEL"/>
            </p>
          </div>

</div>

					</div> <!-- fin risque-j1-->
					<div id="risque-j2" class="col2">
		<h3>Tendance pour 
		<xsl:call-template name="DateLong">
		<xsl:with-param name="date-heure" select="RISQUE/@DATE_RISQUE_J2"/>
		<xsl:with-param name="avecAnnee" select="string('non')"/>
		</xsl:call-template>
		</h3>
					      <div class="Risque">
     <!-- Risque Maxi - BRA-Amendement-ancien xml -->
            <div class="risqueMaxi">
		<div class="bloc1">
            <div class="risqueMaxi">
              <img >
                <xsl:attribute name="src">
                  <xsl:value-of select="$CheminPicto"/>
                  <xsl:text disable-output-escaping="yes">R</xsl:text>
                  <xsl:value-of select="RISQUE/@RISQUEMAXIJ2"/>
                  <xsl:text disable-output-escaping="yes">.png</xsl:text>
                </xsl:attribute>
                <xsl:attribute name ="alt">
                  <xsl:call-template name ="texteRisque">
                    <xsl:with-param name="risque" select="RISQUE/@RISQUEMAXIJ2"/>
                  </xsl:call-template>
                </xsl:attribute>
              </img>
            </div>
            </div>
            </div>

	 <div class="cartouche">
   <p>
      <xsl:value-of select="RisqueJ2"/>
    </p>
						<p><xsl:value-of select="CommentaireRisqueJ2"/></p>
						</div>

 
					</div>
					</div>
  </xsl:template>


  <!-- Rubrique Enneigement (image)-->
  <xsl:template match="ENNEIGEMENT">
    <img>
      <xsl:attribute name="src">
        <xsl:text>data:image/</xsl:text>
        <xsl:value-of select="ImageEnneigement/@Format"/>
        <xsl:text>;base64,</xsl:text>
        <xsl:value-of select="ImageEnneigement/Content"/>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="ImageEnneigement/@Height"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:value-of select="ImageEnneigement/@Width"/>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:text>Enneigement</xsl:text>
      </xsl:attribute>
    </img>
  </xsl:template>


  <!-- rubrique neige fraîche (image)-->
  <xsl:template match="NEIGEFRAICHE">
    <img>
      <xsl:attribute name="src">
        <xsl:text>data:image/</xsl:text>
        <xsl:value-of select="ImageNeigeFraiche/@Format"/>
        <xsl:text>;base64,</xsl:text>
        <xsl:value-of select="ImageNeigeFraiche/Content"/>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="ImageNeigeFraiche/@Height"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:value-of select="ImageNeigeFraiche/@Width"/>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:text>Neige Fraiche</xsl:text>
      </xsl:attribute>
    </img>
  </xsl:template>


  <!-- Rubrique Météo -->
  <xsl:template match="METEO">
    <table class="tableauMeteo">
      <tr>
        <td style="border-bottom-style: none;"/>
        <td style="border-bottom-style: none;"/>
        <td colspan="2" style="border-bottom-style: none;margin-top:5px; text-align:center; font-weight:bold;">
          <xsl:call-template name="DateLong">
            <xsl:with-param name="date-heure" select="../@DATEECHEANCE"/>
          </xsl:call-template>
        </td>
        <td style="border-bottom-style: none;"/>
      </tr>
      <tr >
        <td style="border-top-style: none;border-bottom-style: none;"> </td>
        <td class="temps">
          <xsl:if test="../@AMENDEMENT='false'">
            <b>nuit</b>
            <br/>
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$CheminPicto"/>
                <xsl:text disable-output-escaping="yes">meteo/temps/P</xsl:text>
                <xsl:value-of select="ECHEANCE[1]/@TEMPSSENSIBLE"/>
                <xsl:text disable-output-escaping="yes">N.gif</xsl:text>
              </xsl:attribute>
              <xsl:attribute name ="alt">
                <xsl:call-template name ="textetemps">
                  <xsl:with-param name="picto" select="ECHEANCE[1]/@TEMPSSENSIBLE"/>
                </xsl:call-template>
              </xsl:attribute>
            </img>
            <xsl:if test="ECHEANCE[1]/@MERNUAGES!=-1">
              <br/>
              <span style="margin-top:-40px; display:block; font-size:12px;">
                <xsl:value-of select="ECHEANCE[1]/@MERNUAGES"/>
                <xsl:text> m</xsl:text>
              </span>
            </xsl:if>
          </xsl:if>
        </td>

        <td class="temps">
          <b>matin</b>
          <br/>
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$CheminPicto"/>
              <xsl:text disable-output-escaping="yes">meteo/temps/P</xsl:text>
              <xsl:value-of select="ECHEANCE[2]/@TEMPSSENSIBLE"/>
              <xsl:text disable-output-escaping="yes">.gif</xsl:text>
            </xsl:attribute>
            <xsl:attribute name ="alt">
              <xsl:call-template name ="textetemps">
                <xsl:with-param name="picto" select="ECHEANCE[2]/@TEMPSSENSIBLE"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
          <xsl:if test="ECHEANCE[2]/@MERNUAGES!=-1">
            <br/>
            <span style="margin-top:-40px; display:block; font-size:12px;">
              <xsl:value-of select="ECHEANCE[2]/@MERNUAGES"/>
              <xsl:text> m</xsl:text>
            </span>
          </xsl:if>
        </td>

        <td class="temps">
          <b>après-midi</b>
          <br/>
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$CheminPicto"/>
              <xsl:text disable-output-escaping="yes">meteo/temps/P</xsl:text>
              <xsl:value-of select="ECHEANCE[3]/@TEMPSSENSIBLE"/>
              <xsl:text disable-output-escaping="yes">.gif</xsl:text>
            </xsl:attribute>
            <xsl:attribute name ="alt">
              <xsl:call-template name ="textetemps">
                <xsl:with-param name="picto" select="ECHEANCE[3]/@TEMPSSENSIBLE"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
          <xsl:if test="ECHEANCE[3]/@MERNUAGES!=-1">
            <br/>
            <span style="margin-top:-40px; display:block; font-size:12px;">
              <xsl:value-of select="ECHEANCE[3]/@MERNUAGES"/>
              <xsl:text> m</xsl:text>
            </span>
          </xsl:if>
        </td>

        <td class="temps">
          <b>soir</b>
          <br/>
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$CheminPicto"/>
              <xsl:text disable-output-escaping="yes">meteo/temps/P</xsl:text>
              <xsl:value-of select="ECHEANCE[4]/@TEMPSSENSIBLE"/>
              <xsl:text disable-output-escaping="yes">.gif</xsl:text>
            </xsl:attribute>
            <xsl:attribute name ="alt">
              <xsl:call-template name ="textetemps">
                <xsl:with-param name="picto" select="ECHEANCE[4]/@TEMPSSENSIBLE"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
          <xsl:if test="ECHEANCE[4]/@MERNUAGES!=-1">
            <br/>
            <span style="margin-top:-40px; display:block; font-size:12px;">
              <xsl:value-of select="ECHEANCE[4]/@MERNUAGES"/>
              <xsl:text> m</xsl:text>
            </span>
          </xsl:if>
        </td>
       </tr>

      <!-- xsl:if test ="COMMENTAIRE!=''"-->
      <tr>
        <td colspan="5" style="text-align:right;border-top-style: none;">
          <xsl:value-of select="COMMENTAIRE"/>
        </td>
      </tr>
      <!-- /xsl:if-->
      <tr>
        <td style="text-align:left;">
          <b>Pluie-Neige</b>
        </td>
        <xsl:for-each select="ECHEANCE">
          <xsl:call-template name="limitePluieNeige"/>
        </xsl:for-each>
      </tr>
      <tr>
        <td style="text-align:left;">
          <b>Iso 0°C</b>
        </td>
        <xsl:for-each select="ECHEANCE">
          <xsl:call-template name="Iso0"/>
        </xsl:for-each>
      </tr>
      <tr>
        <td style="text-align:left;">
          <b>
            <xsl:text disable-output-escaping="yes">Vent </xsl:text>
            <xsl:value-of select="@ALTITUDEVENT1"/>
            <xsl:text disable-output-escaping="yes"> m</xsl:text>
          </b>
        </td>
        <xsl:for-each select="ECHEANCE">
          <xsl:call-template name="vent1"/>
        </xsl:for-each>
      </tr>
      <xsl:if test="@ALTITUDEVENT2!='9999'">
        <tr>

          <td style="text-align:left;">
            <b>
              <xsl:text disable-output-escaping="yes">Vent </xsl:text>
              <xsl:value-of select="@ALTITUDEVENT2"/>
              <xsl:text disable-output-escaping="yes"> m</xsl:text>
            </b>
          </td>
          <xsl:for-each select="ECHEANCE">
            <xsl:call-template name="vent2"/>
          </xsl:for-each>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

  <!-- traitement limite pluie neige-->
  <xsl:template name="limitePluieNeige">
    <td>
      <xsl:if test="@PLUIENEIGE!=-1">
        <xsl:value-of select="@PLUIENEIGE"/>
        <xsl:text disable-output-escaping ="yes"> m</xsl:text>
      </xsl:if>
    </td>
  </xsl:template>

  <!-- traitement iso 0°Cc-->
  <xsl:template name="Iso0">
    <td>
      <xsl:if test="@ISO0!=-1">
        <xsl:value-of select="@ISO0"/>
        <xsl:text disable-output-escaping ="yes"> m</xsl:text>
      </xsl:if>
    </td>
  </xsl:template>

  <!-- traitement vent 1 -->
  <xsl:template name="vent1">
    <td>
      <xsl:if test="@FF1!=-1">
        <img>
          <xsl:attribute name="src">
            <xsl:value-of select="$CheminPicto"/>
            <xsl:text disable-output-escaping="yes">/meteo/vent/V</xsl:text>
            <xsl:value-of select="@DD1"/>
            <xsl:text disable-output-escaping="yes">.png</xsl:text>
          </xsl:attribute>
          <xsl:attribute name ="alt">
            <xsl:value-of select="@DD1"/>
          </xsl:attribute>
          <xsl:attribute name ="style">
            <xsl:text>float:left; margin:0 -5px 0 5px;</xsl:text>
          </xsl:attribute>
        </img>

        <xsl:text disable-output-escaping ="yes"> </xsl:text>
        <xsl:value-of select="@FF1"/>
        <xsl:text disable-output-escaping ="yes"> km/h</xsl:text>
      </xsl:if>
    </td>
  </xsl:template>

  <!-- traitement vent 2 -->
  <xsl:template name="vent2">
    <td>
      <xsl:if test="@FF2!=-1">
        <img>
          <xsl:attribute name="src">
            <xsl:value-of select="$CheminPicto"/>
            <xsl:text disable-output-escaping="yes">/meteo/vent/V</xsl:text>
            <xsl:value-of select="@DD2"/>
            <xsl:text disable-output-escaping="yes">.png</xsl:text>
          </xsl:attribute>
          <xsl:attribute name ="alt">
            <xsl:value-of select="@DD2"/>
          </xsl:attribute>
          <xsl:attribute name ="style">
            <xsl:text>float:left; margin:0 -5px 0 5px;</xsl:text>
          </xsl:attribute>
        </img>
        <xsl:text disable-output-escaping ="yes"> </xsl:text>
        <xsl:value-of select="@FF2"/>
        <xsl:text disable-output-escaping ="yes"> km/h</xsl:text>
      </xsl:if>
    </td>
  </xsl:template>

  <!-- Rubrique tendance des riques-->
  <xsl:template match="TENDANCES">
    <ul class="BRAtendance">
      <xsl:for-each select="TENDANCE">
        <li>
          <xsl:call-template name="DateLong">
            <xsl:with-param name="date-heure" select="@DATE"/>
            <xsl:with-param name="avecMois" select="string('non')"/>
          </xsl:call-template>
          <xsl:text disable-output-escaping="yes"> : </xsl:text>
          <xsl:choose>
            <xsl:when test="@VALEUR=-1">
              <img src="{$CheminPicto}baisse.png" alt="en baisse"/>
            </xsl:when>
            <xsl:when test="@VALEUR=0">
              <img src="{$CheminPicto}stable2.png" alt="stable"/>
            </xsl:when>
            <xsl:when test="@VALEUR=1">
              <img src="{$CheminPicto}hausse.png" alt="en hausse"/>
            </xsl:when>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <!--BSH-->

  <!-- Acces direct au BSH -->
  <xsl:template match="BSH">
    <html>
      <head>
        <title>Bulletin synthèse hebdomadaire</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="stylesheet" type="text/css">
          <xsl:attribute name="href">
            <xsl:value-of select="$urlCss"/>
          </xsl:attribute>
        </link>
      </head>
      <body>
        <div id="BRA">
          <xsl:if test="@ID!=''">
            <xsl:call-template name="trameBSH"/>
          </xsl:if>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- trame générale du BSH accès direct-->
  <xsl:template name ="trameBSH">
    <div class="Logo_MF">
      <a href="http://meteofrance.com" target="_blank">
        <img src="{$CheminPicto}Logo_MeteoFrance.png" alt="METEO-FRANCE" />
      </a>
    </div>
    <div class="BRAentete">
      <h1>
        Conditions nivo-météo des 7 derniers jours.
      </h1>
      <h4>
        (valable en dehors des pistes balisées et ouvertes)
      </h4>
      <h1>
        <xsl:text disable-output-escaping="yes"> MASSIF : </xsl:text>
        <xsl:value-of select="@MASSIF"/>
      </h1>
      <h4>
        <xsl:text disable-output-escaping="yes">rédigé le </xsl:text>
        <xsl:call-template name="DateLong">
          <xsl:with-param name="date-heure" select="@DATEBULLETIN"/>
          <xsl:with-param name="avecAnnee" select="string('oui')"/>
        </xsl:call-template>
      </h4>
    </div>
    <div id="BSH">
      <xsl:apply-templates select="." mode="graphe"/>
        <xsl:apply-templates select="." mode="tableau"/>
    </div>
  </xsl:template>


  <!--  BSH mode graphique -->
  <xsl:template match="BSH" mode="graphe">

      <script src="{$CheminPicto}BSHonglet.js"></script>
    <div id="BSH_graph" style="background-image: url({$CheminPicto}fond_BSH.png); background-repeat:no-repeat;">
      <div class="BSHdate">
        <xsl:for-each select="RISQUES/RISQUE">
          <div>
            <xsl:call-template name="DateCourt">
              <xsl:with-param name="date-heure" select="@DATE"/>
            </xsl:call-template>
          </div>
        </xsl:for-each>
      </div>
      <div class="BSHdate1">
        <xsl:for-each select="RISQUES/RISQUE">
          <div >Nuit</div>
          <div>AM</div>
          <div>PM</div>
        </xsl:for-each>
      </div>
      <div>
        <img>
          <xsl:attribute name="src">
            <xsl:text>data:image/</xsl:text>
            <xsl:value-of select="METEO/ImageIso/@Format"/>
            <xsl:text>;base64,</xsl:text>
            <xsl:value-of select="METEO/ImageIso/Content"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="METEO/ImageIso/@Height"/>
          </xsl:attribute>
          <xsl:attribute name="width">
            <xsl:value-of select="METEO/ImageIso/@Width"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:text>Isotherme 0°C et limite pluie neige</xsl:text>
          </xsl:attribute>
        </img>
      </div>
      <div class="BSHtempssensible">
        <xsl:for-each select="METEO/ECHEANCE">
          <div>
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$CheminPicto"/>
                <xsl:choose>
                  <xsl:when test="substring(substring-after(@DATE,'T'),1,2)='00'">
                    <xsl:text disable-output-escaping="yes">pr</xsl:text>
                    <xsl:value-of select="@TEMPSSENSIBLE"/>
                    <xsl:text disable-output-escaping="yes">n.gif</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text disable-output-escaping="yes">pr</xsl:text>
                    <xsl:value-of select="@TEMPSSENSIBLE"/>
                    <xsl:text disable-output-escaping="yes">.gif</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:attribute>
              <xsl:attribute name ="alt">
                <xsl:call-template name ="textetemps">
                  <xsl:with-param name="picto" select="@TEMPSSENSIBLE"/>
                </xsl:call-template>
              </xsl:attribute>
            </img>
          </div>
        </xsl:for-each>
      </div>

      <div>
        <img>
          <xsl:attribute name="src">
            <xsl:text>data:image/</xsl:text>
            <xsl:value-of select="METEO/ImageVent/@Format"/>
            <xsl:text>;base64,</xsl:text>
            <xsl:value-of select="METEO/ImageVent/Content"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="METEO/ImageVent/@Height"/>
          </xsl:attribute>
          <xsl:attribute name="width">
            <xsl:value-of select="METEO/ImageVent/@Width"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:text>Vent en altitude</xsl:text>
          </xsl:attribute>
        </img>
      </div>

      <div>
        <img>
          <xsl:attribute name="src">
            <xsl:text>data:image/</xsl:text>
            <xsl:value-of select="NEIGEFRAICHE/ImageNeigeFraiche/@Format"/>
            <xsl:text>;base64,</xsl:text>
            <xsl:value-of select="NEIGEFRAICHE/ImageNeigeFraiche/Content"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="NEIGEFRAICHE/ImageNeigeFraiche/@Height"/>
          </xsl:attribute>
          <xsl:attribute name="width">
            <xsl:value-of select="NEIGEFRAICHE/ImageNeigeFraiche/@Width"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:text>Neige fraîche</xsl:text>
          </xsl:attribute>
        </img>
      </div>
      <div class="BSHtitreRisque">Risque d'avalanche</div>
      <div class="BSHrisque">
        <xsl:for-each select="RISQUES/RISQUE">
          <div>
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$CheminPicto"/>
                <xsl:text disable-output-escaping="yes">R</xsl:text>
                <xsl:value-of select="@RISQUEMAXI"/>
                <xsl:text disable-output-escaping="yes">_70.png</xsl:text>
              </xsl:attribute>
              <xsl:attribute name ="alt">
                <xsl:call-template name ="texteRisque">
                  <xsl:with-param name="risque" select="@RISQUEMAXI"/>
                </xsl:call-template>
              </xsl:attribute>
            </img>
          </div>
        </xsl:for-each>
      </div>
      <div id="BSHenneigements">
        <div  style="width:85px;" class="BSHtitreRisque">Enneigement</div>
        <ul>
          <li id="BSHenneigements_tab_alt1">
            <a href="javascript:ChangeOnglet('alt1');" >
              <xsl:value-of select="ENNEIGEMENTS/ENNEIGEMENT[1]/NIVEAU[1]/@ALTI"/>
              <xsl:text> m</xsl:text>
            </a>
          </li>
          <li class="active" id="BSHenneigements_tab_alt2" >
            <a href="javascript:ChangeOnglet('alt2');" >
              <xsl:value-of select="ENNEIGEMENTS/ENNEIGEMENT[1]/NIVEAU[2]/@ALTI"/>
              <xsl:text> m</xsl:text>
            </a>
          </li>
          <li id="BSHenneigements_tab_alt3">
            <a href="javascript:ChangeOnglet('alt3');">
              <xsl:value-of select="ENNEIGEMENTS/ENNEIGEMENT[1]/NIVEAU[3]/@ALTI"/>
              <xsl:text> m</xsl:text>
            </a>
          </li>
          <li id="BSHenneigements_tab_nord">
            <a href="javascript:ChangeOnglet('nord');">
              Nord
            </a>
          </li>
          <li id="BSHenneigements_tab_sud">
            <a href="javascript:ChangeOnglet('sud');">
              Sud
            </a>
          </li>
          <li id="BSHenneigements_tab_limite">
            <a href="javascript:ChangeOnglet('limite');" >
              Limite
            </a>
          </li>
        </ul>
        <div id="BSHenneigements_graph_alt1">
          <img>
            <xsl:attribute name="src">
              <xsl:text>data:image/</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt1/@Format"/>
              <xsl:text>;base64,</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt1/Content"/>
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt1/@Height"/>
            </xsl:attribute>
            <xsl:attribute name="width">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt1/@Width"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Enneigement</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div id="BSHenneigements_graph_alt2">
          <img>
            <xsl:attribute name="src">
              <xsl:text>data:image/</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt2/@Format"/>
              <xsl:text>;base64,</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt2/Content"/>
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt2/@Height"/>
            </xsl:attribute>
            <xsl:attribute name="width">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt2/@Width"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Enneigement</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div id="BSHenneigements_graph_alt3">
          <img>
            <xsl:attribute name="src">
              <xsl:text>data:image/</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt3/@Format"/>
              <xsl:text>;base64,</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt3/Content"/>
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt3/@Height"/>
            </xsl:attribute>
            <xsl:attribute name="width">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementAlt3/@Width"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Enneigement</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div id="BSHenneigements_graph_nord">
          <img>
            <xsl:attribute name="src">
              <xsl:text>data:image/</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementNord/@Format"/>
              <xsl:text>;base64,</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementNord/Content"/>
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementNord/@Height"/>
            </xsl:attribute>
            <xsl:attribute name="width">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementNord/@Width"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Enneigement Nord</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div id="BSHenneigements_graph_sud">
          <img>
            <xsl:attribute name="src">
              <xsl:text>data:image/</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementSud/@Format"/>
              <xsl:text>;base64,</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementSud/Content"/>
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementSud/@Height"/>
            </xsl:attribute>
            <xsl:attribute name="width">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementSud/@Width"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Enneigement sud</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div id="BSHenneigements_graph_limite">
          <img>
            <xsl:attribute name="src">
              <xsl:text>data:image/</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementLimite/@Format"/>
              <xsl:text>;base64,</xsl:text>
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementLimite/Content"/>
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementLimite/@Height"/>
            </xsl:attribute>
            <xsl:attribute name="width">
              <xsl:value-of select="ENNEIGEMENTS/ImageEnneigementLimite/@Width"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Enneigement sud</xsl:text>
            </xsl:attribute>
          </img>
        </div>

      </div>
      <div class="BSHdate">
        <xsl:for-each select="RISQUES/RISQUE">
          <div>
            <xsl:call-template name="DateCourt">
              <xsl:with-param name="date-heure" select="@DATE"/>
            </xsl:call-template>
          </div>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>



  <!-- BSH mode tableau-->
  <xsl:template match="BSH" mode="tableau">
    <div id="BSH_tableau">
      <div class="BSH_tableau_meteo">
        <xsl:attribute name="style">
          <xsl:if test="METEO/@ALTITUDEVENT2=9999">
            width:256px;
          </xsl:if>
        </xsl:attribute>
        <div class="BSH_tableau_titre_meteo">
          <xsl:attribute name="style">
            <xsl:if test="METEO/@ALTITUDEVENT2=9999">
              width:180px;
            </xsl:if>
          </xsl:attribute>
          <div class="BSH_ww">
            <img src="{$CheminPicto}ww.png" alt="temps sensible"/>
          </div>
          <div class="BSH_iso-lpn">
            <img src="{$CheminPicto}lpn.png" alt="limite pluie neige"/>
          </div>
          <div class="BSH_iso-lpn">
            <img src="{$CheminPicto}iso0.png" alt="isotherme 0°C"/>
          </div>
          <div class="BSH_vent">
            <img src="{$CheminPicto}vent.png" style="float:left; margin: 3px 0 0 0;" alt="vent (km/h)"/>
            <xsl:value-of select="METEO/@ALTITUDEVENT1"/>m
          </div>
          <xsl:if test="METEO/@ALTITUDEVENT2!=9999">
            <div class="BSH_vent">
              <img src="{$CheminPicto}vent.png" style="float:left; margin: 3px 0 0 0;" alt="vent (km/h)"/>
              <xsl:value-of select="METEO/@ALTITUDEVENT2"/>m
            </div>
          </xsl:if>
        </div>

        <div class="BSHdate">
          <xsl:for-each select="RISQUES/RISQUE">
            <div>
              <xsl:call-template name="DateCourt">
                <xsl:with-param name="date-heure" select="@DATE"/>
              </xsl:call-template>
            </div>
          </xsl:for-each>
        </div>

        <div class="BSH_tableau_donnee">
          <xsl:attribute name="style">
            <xsl:if test="METEO/@ALTITUDEVENT2=9999">
              width:216px;
            </xsl:if>
          </xsl:attribute>
          <xsl:for-each select="METEO/ECHEANCE">
            <xsl:variable name="BSH_tableau_ligne">
              <xsl:choose>
                <xsl:when test="substring(substring-after(@DATE,'T'),1,2)='00'">
                  <xsl:text>BSH_tableau_nuit_meteo</xsl:text>
                </xsl:when>
                <xsl:when test="substring(substring-after(@DATE,'T'),1,2)!='00'">
                  <xsl:text>BSH_tableau_jour_meteo</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <div class="{$BSH_tableau_ligne}">
              <div class="BSHdate1">
                <xsl:choose>
                  <xsl:when test="substring(substring-after(@DATE,'T'),1,2)='00'">
                    <xsl:text>Nuit</xsl:text>
                  </xsl:when>
                  <xsl:when test="substring(substring-after(@DATE,'T'),1,2)='06'">
                    <xsl:text>AM</xsl:text>
                  </xsl:when>
                  <xsl:when test="substring(substring-after(@DATE,'T'),1,2)='12'">
                    <xsl:text>PM</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </div>
              <div class="BSH_ww">
                <img >
                  <xsl:attribute name="src">
                    <xsl:value-of select="$CheminPicto"/>
                    <xsl:choose>
                      <xsl:when test="substring(substring-after(@DATE,'T'),1,2)='00'">
                        <xsl:text disable-output-escaping="yes">pr</xsl:text>
                        <xsl:value-of select="@TEMPSSENSIBLE"/>
                        <xsl:text disable-output-escaping="yes">n.gif</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">pr</xsl:text>
                        <xsl:value-of select="@TEMPSSENSIBLE"/>
                        <xsl:text disable-output-escaping="yes">.gif</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>

                  </xsl:attribute>
                  <xsl:attribute name ="alt">
                    <xsl:call-template name ="textetemps">
                      <xsl:with-param name="picto" select="@TEMPSSENSIBLE"/>
                    </xsl:call-template>
                  </xsl:attribute>
                </img>
              </div>
              <div class="BSH_iso-lpn">
                <xsl:if test="@PLUIENEIGE!=-1">
                  <xsl:value-of select="@PLUIENEIGE"/>
                </xsl:if>
                <xsl:if test="@PLUIENEIGE=-1">
                  <xsl:text>-</xsl:text>
                </xsl:if>
              </div>
              <div class="BSH_iso-lpn">
                <xsl:if test="@ISO0!=-1">
                  <xsl:value-of select="@ISO0"/>
                </xsl:if>
                <xsl:if test="@ISO0=-1">
                  <xsl:text>-</xsl:text>
                </xsl:if>
              </div>
              <div class="BSH_vent">
                <xsl:if test="@FF1!=-1">
                  <img>
                    <xsl:attribute name="src">
                      <xsl:value-of select="$CheminPicto"/>
                      <xsl:text disable-output-escaping="yes">/meteo/vent/V</xsl:text>
                      <xsl:value-of select="@DD1"/>
                      <xsl:text disable-output-escaping="yes">.png</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name ="alt">
                      <xsl:value-of select="@DD1"/>
                    </xsl:attribute>
                    <xsl:attribute name ="style">
                      <xsl:text>float:left; margin: 6px -5px 0 5px;</xsl:text>
                    </xsl:attribute>
                  </img>
                  <xsl:text disable-output-escaping ="yes"> </xsl:text>
                  <xsl:value-of select="@FF1"/>
                </xsl:if>
				 <xsl:if test="@FF1=-1">
					<xsl:text>-</xsl:text>
				 </xsl:if>
              </div>
              <xsl:if test="../@ALTITUDEVENT2!=9999">
                <div class="BSH_vent">
                  <xsl:if test="@FF2!=-1">
                    <img>
                      <xsl:attribute name="src">
                        <xsl:value-of select="$CheminPicto"/>
                        <xsl:text disable-output-escaping="yes">/meteo/vent/V</xsl:text>
                        <xsl:value-of select="@DD2"/>
                        <xsl:text disable-output-escaping="yes">.png</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name ="alt">
                        <xsl:value-of select="@DD2"/>
                      </xsl:attribute>
                      <xsl:attribute name ="style">
                        <xsl:text>float:left; margin:6px -5px 0 5px;</xsl:text>
                      </xsl:attribute>
                    </img>
                    <xsl:text disable-output-escaping ="yes"> </xsl:text>
                    <xsl:value-of select="@FF2"/>
                  </xsl:if>
				   <xsl:if test="@FF2=-1">
					<xsl:text>-</xsl:text>
				 </xsl:if>
                </div>
              </xsl:if>

            </div>
          </xsl:for-each>
        </div>
      </div>
      <ul class="BSH_iso_legende">
        <li>
          <img src="{$CheminPicto}ww.png" alt="temps sensible"/> : Temps sensible
        </li>
        <li>
          <img src="{$CheminPicto}lpn.png" alt="limite pluie neige"/> : Limite pluie neige (m)
        </li>
        <li>
          <img src="{$CheminPicto}iso0.png" alt="isotherme 0°C"/> : Isotherme 0°C (m)
        </li>
        <li>
          <img src="{$CheminPicto}vent.png" alt="vent (km/h)"/> : Vent direction et force (km/h)

        </li>
      </ul>
      <div class="BSH_tableau_neige">
        <div class="BSH_tableau_titre_neige">
          <div>
            Risque avalanche
          </div>
          <div>
            Fraîche à <xsl:value-of select="NEIGEFRAICHE/@ALTITUDESS" /> m
          </div>
          <div>
            Limite enneigement
          </div>
          <div>
            Enneigement à <xsl:value-of select="ENNEIGEMENTS/ENNEIGEMENT[1]/NIVEAU[2]/@ALTI" /> m
          </div>
        </div>
        <div class="BSHdate">
          <xsl:for-each select="RISQUES/RISQUE">
            <div>
              <xsl:call-template name="DateCourt">
                <xsl:with-param name="date-heure" select="@DATE"/>
              </xsl:call-template>
            </div>
          </xsl:for-each>
        </div>
        <div class="BSH_tableau_donnee">
          <div class="BSH_tableau_neige_col">
            <xsl:for-each select="RISQUES/RISQUE">
              <div>
                <img>
                  <xsl:attribute name="src">
                    <xsl:value-of select="$CheminPicto"/>
                    <xsl:text disable-output-escaping="yes">R</xsl:text>
                    <xsl:value-of select="@RISQUEMAXI"/>
                    <xsl:text disable-output-escaping="yes">_70.png</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name ="alt">
                    <xsl:call-template name ="texteRisque">
                      <xsl:with-param name="risque" select="@RISQUEMAXI"/>
                    </xsl:call-template>
                  </xsl:attribute>
                </img>
              </div>
            </xsl:for-each>
          </div>

          <div class="BSH_tableau_neige_col">
            <div style="height:18px;">
            </div>
            <xsl:for-each select="NEIGEFRAICHE/NEIGE24H">
              <xsl:if test="../@SECTEURSS2=''">
                <div style="line-height:55px; vertical-align:middle;">
                  <xsl:choose>
                    <xsl:when test="@SS241=-2">
                      <xsl:text>Pluie</xsl:text>
                    </xsl:when>
                    <xsl:when test="@SS241=-1">
                      <xsl:text>/</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@SS241"/> cm
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </xsl:if>
              <xsl:if test="../@SECTEURSS2!=''">
             
                  <div>
                    <br/>
                    <strong>
                      <xsl:value-of select="substring(../@SECTEURSS1,1,1)"/> :
                    </strong>
                    <xsl:choose>
                      <xsl:when test="@SS241=-2">
                        <xsl:text>Pluie</xsl:text>
                      </xsl:when>
                      <xsl:when test="@SS241=-1">
                        <xsl:text>/</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@SS241"/> cm
                      </xsl:otherwise>
                    </xsl:choose>
                    <br/>
                    <strong>
                      <xsl:value-of select="substring(../@SECTEURSS2,1,1)"/> :
                    </strong>
                    <xsl:choose>
                      <xsl:when test="@SS242=-2">
                        <xsl:text>Pluie</xsl:text>
                      </xsl:when>
                      <xsl:when test="@SS242=-1">
                        <xsl:text>/</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@SS242"/> cm
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>          
              </xsl:if>
            </xsl:for-each>
          </div>
          <div class="BSH_tableau_neige_col">
            <xsl:for-each select="ENNEIGEMENTS/ENNEIGEMENT">
              <div>
                <br/>
                <strong>S : </strong>
                <xsl:choose>
                  <xsl:when test="@LimiteSud=-1">
                    <xsl:text>/</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@LimiteSud"/> m
                  </xsl:otherwise>
                </xsl:choose>
                <br/>
                <strong>N : </strong>
                <xsl:choose>
                  <xsl:when test="@LimiteNord=-1">
                    <xsl:text>/</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@LimiteNord"/> m
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </xsl:for-each>
          </div>
          <div class="BSH_tableau_neige_col">
            <xsl:for-each select="ENNEIGEMENTS/ENNEIGEMENT">

              <div>
                <br/>
                <strong>S : </strong> <xsl:value-of select="NIVEAU[2]/@S"/> cm
                <br/>
                <strong>N : </strong> <xsl:value-of select="NIVEAU[2]/@N"/> cm
              </div>
            </xsl:for-each>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <!--  DIVERS TRAITEMENTS   -->

  <!-- traitement des dates - format long-->
  <xsl:template name ="DateLong">
    <xsl:param name="date-heure"/>
    <xsl:param name ="date" select="substring-before($date-heure,'T')"/>
    <xsl:param name="an" select ="substring-before($date,'-')"/>
    <xsl:param name="mois" select="substring-before(substring-after($date,'-'),'-')"/>
    <xsl:param name="jour" select="substring-after(substring-after($date,'-'),'-')"/>
    <xsl:param name="avecAnnee" select="string('non')"/>
    <xsl:param name="avecMois" select="string('oui')"/>
    <xsl:variable name="a" select="floor((14-$mois)div 12)"/>
    <xsl:variable name="y" select ="$an - $a"/>
    <xsl:variable name="m" select="$mois +12 * $a -2"/>
    <xsl:variable name ="j" select="($jour +$y + floor($y div 4) - floor($y div 100) + floor($y div 400) + floor((31*$m) div 12)) mod 7 "/>
    <xsl:choose>
      <xsl:when test="$j=0">
        <xsl:text>dimanche</xsl:text>
      </xsl:when>
      <xsl:when test="$j=1">
        <xsl:text>lundi</xsl:text>
      </xsl:when>
      <xsl:when test="$j=2">
        <xsl:text>mardi</xsl:text>
      </xsl:when>
      <xsl:when test="$j=3">
        <xsl:text>mercredi</xsl:text>
      </xsl:when>
      <xsl:when test="$j=4">
        <xsl:text>jeudi</xsl:text>
      </xsl:when>
      <xsl:when test="$j=5">
        <xsl:text>vendredi</xsl:text>
      </xsl:when>
      <xsl:when test="$j=6">
        <xsl:text>samedi</xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <xsl:value-of select="$jour"/>
    <xsl:if test="$avecMois='oui'">
      <xsl:text disable-output-escaping="yes"> </xsl:text>
      <xsl:choose>
        <xsl:when test="$mois=1">
          <xsl:text>janvier</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=2">
          <xsl:text>février</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=3">
          <xsl:text>mars</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=4">
          <xsl:text>avril</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=5">
          <xsl:text>mai</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=6">
          <xsl:text>juin</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=7">
          <xsl:text>juillet</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=8">
          <xsl:text>août</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=9">
          <xsl:text>septembre</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=10">
          <xsl:text>octobre</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=11">
          <xsl:text>novembre</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=12">
          <xsl:text>décembre</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:if test ="$avecAnnee='oui'">
        <xsl:text disable-output-escaping="yes"> </xsl:text>
        <xsl:value-of select="$an"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- traitement des dates format court-->
  <xsl:template name ="DateCourt">
    <xsl:param name="date-heure"/>
    <xsl:param name ="date" select="substring-before($date-heure,'T')"/>
    <xsl:param name="an" select ="substring-before($date,'-')"/>
    <xsl:param name="mois" select="substring-before(substring-after($date,'-'),'-')"/>
    <xsl:param name="jour" select="substring-after(substring-after($date,'-'),'-')"/>
    <xsl:param name="avecAnnee" select="string('non')"/>
    <xsl:param name="avecMois" select="string('oui')"/>
    <xsl:variable name="a" select="floor((14-$mois)div 12)"/>
    <xsl:variable name="y" select ="$an - $a"/>
    <xsl:variable name="m" select="$mois +12 * $a -2"/>
    <xsl:variable name ="j" select="($jour +$y + floor($y div 4) - floor($y div 100) + floor($y div 400) + floor((31*$m) div 12)) mod 7 "/>
    <xsl:choose>
      <xsl:when test="$j=0">
        <xsl:text>dim.</xsl:text>
      </xsl:when>
      <xsl:when test="$j=1">
        <xsl:text>lun.</xsl:text>
      </xsl:when>
      <xsl:when test="$j=2">
        <xsl:text>mar.</xsl:text>
      </xsl:when>
      <xsl:when test="$j=3">
        <xsl:text>mer.</xsl:text>
      </xsl:when>
      <xsl:when test="$j=4">
        <xsl:text>jeu.</xsl:text>
      </xsl:when>
      <xsl:when test="$j=5">
        <xsl:text>ven.</xsl:text>
      </xsl:when>
      <xsl:when test="$j=6">
        <xsl:text>sam.</xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <xsl:value-of select="$jour"/>
    <xsl:if test="$avecMois='oui'">
      <xsl:text disable-output-escaping="yes"> </xsl:text>
      <xsl:choose>
        <xsl:when test="$mois=1">
          <xsl:text>jan.</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=2">
          <xsl:text>fév.</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=3">
          <xsl:text>mars</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=4">
          <xsl:text>avr.</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=5">
          <xsl:text>mai</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=6">
          <xsl:text>juin</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=7">
          <xsl:text>juil.</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=8">
          <xsl:text>août</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=9">
          <xsl:text>sept.</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=10">
          <xsl:text>oct.</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=11">
          <xsl:text>nov.</xsl:text>
        </xsl:when>
        <xsl:when test="$mois=12">
          <xsl:text>déc.</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:if test ="$avecAnnee='oui'">
        <xsl:text disable-output-escaping="yes"> </xsl:text>
        <xsl:value-of select="$an"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- texte du temps sensible-->
  <xsl:template name ="textetemps">
    <xsl:param name="picto"/>
    <xsl:choose>
      <xsl:when test="$picto=1">
        <xsl:text>Soleil ou nuit claire</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=2">
        <xsl:text>Soleil voilé ou ciel voilé</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=3">
        <xsl:text>Variable ou nuageux</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=4">
        <xsl:text>Belles éclaircies</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=5">
        <xsl:text>Très nuageux, courtes éclaircies</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=6">
        <xsl:text>Couvert</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=7">
        <xsl:text>Variable avec averses</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=8">
        <xsl:text>Couvert, bruines ou pluies</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=9">
        <xsl:text>Couvert, pluies modérées ou fortes</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=10">
        <xsl:text>Couvert, neige faible</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=11">
        <xsl:text>Variable, averses de neige</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=12">
        <xsl:text>Neige modérée ou forte</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=13">
        <xsl:text>Orages isolés</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=14">
        <xsl:text>Orages</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=15">
        <xsl:text>Brumes ou brouillards</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=16">
        <xsl:text>Brouillards givrants</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=17">
        <xsl:text>Verglas</xsl:text>
      </xsl:when>
      <xsl:when test="$picto=18">
        <xsl:text>Mer de nuages</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- texte des niveau de risque-->
  <xsl:template name ="texteRisque">
    <xsl:param name="risque"/>
    <xsl:choose>
      <xsl:when test="$risque=1">
        <xsl:text>Risque faible</xsl:text>
      </xsl:when>
      <xsl:when test="$risque=2">
        <xsl:text>Risque limité</xsl:text>
      </xsl:when>
      <xsl:when test="$risque=3">
        <xsl:text>Risque marqué</xsl:text>
      </xsl:when>
      <xsl:when test="$risque=4">
        <xsl:text>Risque fort</xsl:text>
      </xsl:when>
      <xsl:when test="$risque=5">
        <xsl:text>Risque très fort</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Risque non défini </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- texte des SAT-->
  <xsl:template name ="texteSAT">
    <xsl:param name="SAT"/>
    <xsl:choose>
      <xsl:when test="$SAT=0">
        <xsl:text>Pas de situation avalancheuse prédominante</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=1">
        <xsl:text>Neige fraîche</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=2">
        <xsl:text>Neige ventée</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=3">
        <xsl:text>Neige humide</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=4">
        <xsl:text>Avalanches de fond</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=5">
        <xsl:text>Sous-couche fragile persitante</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name ="ancreSAT">
    <xsl:param name="SAT"/>
    <xsl:choose>
      <xsl:when test="$SAT=0">
        <xsl:text></xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=1">
        <xsl:text>neige_frache</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=2">
        <xsl:text>wind_slab</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=3">
        <xsl:text>neige_humide</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=4">
        <xsl:text>gliding_snow</xsl:text>
      </xsl:when>
      <xsl:when test="$SAT=5">
        <xsl:text>persistent_weak_layers</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
