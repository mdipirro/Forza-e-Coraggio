<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method='xml' version='1.0' encoding='UTF-8' indent="yes"
				doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
				doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
				omit-xml-declaration="yes" />

	<xsl:param name="exerciseName" />
	<xsl:variable name="exercise" select="/gruppiMuscolari/gruppoMuscolare/esercizio[nomeEsercizio = $exerciseName]" />
	<xsl:variable name="musclesInvolved" select="$exercise/muscoliCoinvolti" />
	<!-- Variabili per rendere maiuscola la prima lettera della difficolta' -->
	<xsl:variable name="vLower" select="'abcdefgijklmnopqrstuvwxyz'"/>
   <xsl:variable name="vUpper" select="'ABCDEFGIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<title><xsl:copy-of select="$exerciseName" /> - Forza e Coraggio</title>
				<meta name="description" content="Descrizione dell'esercizio {$exerciseName}" />
				<meta name="keywords" content="Forza e Coraggio, Esercizi, {$exerciseName}" />
				<meta name="language" content="italian it" />
				<meta name="author" content="Matteo Di Pirro, Alex Beccaro, Mattia Trevisan" />
				<meta name="title" content="{$exerciseName} - Forza e Coraggio" />
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
							><li class="submenu, current">Esercizi ▾
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
							><li class="submenu">Area riservata ▾
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
						<xsl:when test="$exercise">
							<!--Descrizione esercizio-->
							<h1><xsl:copy-of select="$exercise/nomeEsercizio/node()" /> - <xsl:value-of select="$exercise/../nomeGruppo" /></h1>
							<img class="categoryImage" alt="" src="../img/esercizi/{$exercise/immagine}" />
							<dl>
								<dt>Spiegazione</dt>
								<dd>
									<xsl:copy-of select="$exercise/spiegazione/node()" />
								</dd>
								<dt>Respirazione</dt>
								<dd>
									<xsl:copy-of select="$exercise/respirazione/node()"/>
								</dd>
								<dt>Errori:</dt>
								<dd>
									<ul>
										<xsl:for-each select="$exercise/errori/errore">
											<li><xsl:copy-of select="./node()"/></li>
										</xsl:for-each>
									</ul>
								</dd>
								<dt>Muscoli coinvolti</dt>
								<dd>
									<dl>
										<dt>Principali</dt>
										<dd>
											<ul>
												<xsl:for-each select="$musclesInvolved/principali/muscolo">
													<li><xsl:value-of select="." /></li>
												</xsl:for-each>
											</ul>
										</dd>
										<xsl:if test="$musclesInvolved/secondari">
											<dt>Secondari</dt>
											<dd>
												<ul>
													<xsl:for-each select="$musclesInvolved/secondari/muscolo">
														<li><xsl:value-of select="." /></li>
													</xsl:for-each>
												</ul>
											</dd>
										</xsl:if>
										<xsl:if test="$musclesInvolved/accessori">
											<dt>Accessori</dt>
											<dd>
												<ul>
													<xsl:for-each select="$musclesInvolved/accessori/muscolo">
														<li><xsl:value-of select="." /></li>
													</xsl:for-each>
												</ul>
											</dd>
										</xsl:if>
									</dl>
								</dd>
								<dt>
									Difficoltà:
								</dt>
								<dd>
									<xsl:value-of select="translate(substring($exercise/difficolta,1,1),$vLower,$vUpper)" /> <!-- prima lettera maiuscola -->
									<xsl:value-of select="substring($exercise/difficolta,2)" /> <!-- altre lettere minuscole -->
									<img alt="Difficoltà {$exercise/difficolta}" src="../img/diff/{$exercise/difficolta}.png" />
								</dd>
							</dl>
							<!--Commenti-->
							<div id="commenti">

							</div>
						</xsl:when>
						<xsl:otherwise>
							<h1>Esercizio non trovato!</h1>
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
