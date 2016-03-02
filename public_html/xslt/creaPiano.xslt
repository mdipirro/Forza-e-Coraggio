<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='xml' version='1.0' encoding='UTF-8' indent="yes"
				doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
				doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
				omit-xml-declaration="yes" />
    <xsl:param name="mod" />
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <title>Creazione piano di allenamento - Forza e Coraggio</title>
                <meta name="description" content="Creazione di un piano di allenamento personalizzato" />
                <meta name="keywords" content="Forza e Coraggio, Piano, Allenamento, Creazione" />
                <meta name="language" content="italian it" />
                <meta name="author" content="Matteo Di Pirro, Alex Beccaro, Mattia Trevisan" />
                <meta name="title" content="Creazione piano di allenamento - Forza e Coraggio" />
                <link rel="stylesheet" href="../css/stile.css" type="text/css" media="screen" charset="utf-8" />
		<script src="../js/piani.js" type="text/javascript"></script>
            </head>
            <body onload="nascondi();">
                <div id="header" class="noFloat">
                    <div id="logo">
                        <a href="../index.html"><img alt="Link alla pagina iniziale" src="../img/logo.png" /></a>
                    </div>
                    <div id="nav">
			<span id="menu-icon"></span>
			<a class="skipNav" href="#content">Salta la navigazione</a>
                        <ul>
                            <li><a href="../index.html">Home</a></li
                            ><li class="submenu">Esercizi ▾
                            <ul>
                                <li><a href="../pettorali.html">Pettorali</a></li>
                                <li><a href="../dorsali.html">Dorsali</a></li>
                                <li><a href="../spalle.html">Spalle</a></li>
                                <li><a href="../gambeGlutei.html">Gambe e Glutei</a></li>
                                <li><a href="../addome.html">Addome</a></li>
                                <li><a href="../bicipiti.html">Bicipiti</a></li>
                                <li><a href="../tricipiti.html">Tricipiti</a></li>
                            </ul>
                        </li
                        ><li class="submenu, current">Area riservata ▾
                            <ul>
                                <li><a href="profilo.cgi">Profilo</a></li>
                                <li>Crea piano</li>
                            </ul>
                        </li
                        ><li><a href="../contatti.html">Contatti</a></li>
                        </ul>
                    </div>
                </div>
                <div id="content" class="wide">
                    <h1>Crea un piano di allenamento personalizzato!</h1>
                    <p>
                        Per i campi Ripetizioni, Serie e Recupero inserisci valori numerici. In alternativa sono accettati,
                        rispettivamente, i seguenti valori: "Ad esaurimento", "Ad esaurimento" e "Quanto basta". Se
                        non sarà inserito nessun valore numerico verranno usati questi valori. Fai click sui singoli gruppi muscolari per visualizzare gli esercizi disponibili.
                    </p>
                    <form action="aggiungiModificaPiano.cgi?mod={$mod}" method="post">
                        <p>
                            <label for="nome">Nome: </label>
                            <input type="text" name="nome" id="nome" />
                        </p>
                    <xsl:for-each select="/gruppiMuscolari/gruppoMuscolare">
                        <div>
							<h2 id="box{nomeGruppo}" onclick="showHide('{nomeGruppo}')"><xsl:value-of select="nomeGruppo" />►</h2>
							<div class="zonaM" id="div{nomeGruppo}" >
								<xsl:for-each select="esercizio">
									<fieldset>
										<legend><xsl:copy-of select="nomeEsercizio/node()" /></legend>
										<p>
											<label for="includi{@id}">Includi nel piano</label>
											<input type="checkbox" name="includi" id="includi{@id}" value="{@id}" />
										</p>
										<p>
											<label for="rip{@id}">Ripetizioni:</label>
											<input type="text" name="rip{@id}" id="rip{@id}" />
										</p>
										<p>
											<label for="ser{@id}">Serie:</label>
											<input type="text" name="ser{@id}" id="ser{@id}" />
										</p>
										<p>
											<label for="rec{@id}">Recupero (secondi):</label>
											<input type="text" name="rec{@id}" id="rec{@id}" />
										</p>
									</fieldset>
								</xsl:for-each>
							</div>
                        </div>
                    </xsl:for-each>
                        <fieldset class="submit">
				<button type="submit">Conferma</button> 
				<button type="reset">Annulla</button>
			</fieldset>
                    </form>
                </div>
                <div id="footer" class="noFloat">
                    <p>
                        <a href="http://validator.w3.org/check?uri=referer"><img src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0 Strict"/></a>
                        <a href="http://jigsaw.w3.org/css-validator/check/referer"><img src="http://jigsaw.w3.org/css-validator/images/vcss" alt="CSS Valido!" /></a>
                        Forza e coraggio - <span xml:lang="en">All rights reserved</span>
                    </p>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
