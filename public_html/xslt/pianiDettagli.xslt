<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='html' version='1.0' encoding='UTF-8' indent="yes"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
                doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

    <xsl:param name="planID" />
    <xsl:variable name="plan" select="/piani/piano[@id = $planID]" />
    
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <title><xsl:value-of select="$plan/nome" /> - Forza e Coraggio</title>
                <meta name="description" content="Dettagli del piano di allenamento {$plan/nome}" />
                <meta name="keywords" content="Forza e Coraggio, Piano, {$plan/nome}" />
                <meta name="language" content="italian it" />
                <meta name="author" content="Matteo Di Pirro, Alex Beccaro, Mattia Trevisan" />
                <meta name="title" content="{$plan/nome} - Forza e Coraggio" />
                <link rel="stylesheet" href="../css/stile.css" type="text/css" media="screen" charset="utf-8" />
            </head>
            <body>
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
                                <li><a href="creaPiani.cgi">Crea piano</a></li>
                            </ul>
                        </li
                        ><li><a href="../contatti.html">Contatti</a></li>
                        </ul>
                    </div>
                </div>
                <div id="content" class="wide">
                    <xsl:choose>
                        <xsl:when test="$plan">
                            <h1>Piano di allenamento <xsl:value-of select="$plan/nome" /></h1>
                            <table summary="Tabella contenente i dettagli degli esercizi inseriti nel piano di allenamento">
                                <thead>
                                    <tr>
                                        <th id="esercizio" abbr="es">Nome esercizio</th>
                                        <th id="ripetizioni" abbr="rip">Ripetizioni</th>
                                        <th id="serie">Serie</th>
                                        <th id="recupero" abbr="rec">Recupero (s)</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <th>Nome esercizio</th>
                                        <th>Ripetizioni</th>
                                        <th>Serie</th>
                                        <th>Recupero (s)</th>
                                    </tr>
                                </tfoot>
                                <tbody>
                                <xsl:for-each select="$plan/esercizio">
                                    <tr>
                                        <th id="{nomeEsercizio}" headers="esercizio">
                                            <a href="esercizio.cgi?es={nomeEsercizio}"><xsl:copy-of select="nomeEsercizio" /></a>
                                        </th>
                                        <td headers="esercizio {nomeEsercizio} ripetizioni"><xsl:value-of select="ripetizioni" /></td>
                                        <td headers="esercizio {nomeEsercizio} serie"><xsl:value-of select="serie" /></td>
                                        <td headers="esercizio {nomeEsercizio} recupero"><xsl:value-of select="recupero" /></td>
                                    </tr>
                                </xsl:for-each>
                                </tbody>
                            </table>
                        </xsl:when>
                        <xsl:otherwise>
                            <h1>Piano di allenamento non trovato!</h1>
                        </xsl:otherwise>
                    </xsl:choose>
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
