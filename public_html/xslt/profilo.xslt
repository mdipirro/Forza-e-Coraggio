<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method='xml' version='1.0' encoding='UTF-8' indent="yes"
				doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
				doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
				omit-xml-declaration="yes"	/>

	<xsl:param name="username" />
	<xsl:variable name="user" select="/utenti/utente[username = $username]" />
	<xsl:variable name="height" select="$user/altezza" />
	<xsl:variable name="weight" select="$user/peso" />
	
	<xsl:template match="/" >
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="it" lang="it">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<title>Profilo Personale di <xsl:value-of select="$username" /> - Forza e Coraggio</title>
				<meta name="description" content="Profilo personale dell'utente {$username}" />
				<meta name="keywords" content="Forza e Coraggio, Profilo personale" />
				<meta name="language" content="italian it" />
				<meta name="author" content="Matteo Di Pirro, Alex Beccaro, Mattia Trevisan" />
				<meta name="title" content="Profilo Personale di {$username} - Forza e Coraggio" />
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
									<li>Profilo</li>
									<li><a href="creaPiani.cgi">Crea piano</a></li>
								</ul>
							</li
							><li><a href="../contatti.html">Contatti</a></li>
						</ul>
					</div>
				</div>
				<div id="content" class="wide">
					<h1 id="personal_name" xml:space="preserve"><xsl:value-of select="$user/nome" /> <xsl:value-of select="$user/cognome" /></h1>
					<div id="linkProfilo"><p><a href="logout.cgi">Logout</a> <a href="modificaProfilo.cgi">Modifica il tuo profilo</a></p></div>
					<div class="info">
						<h2><xsl:value-of select="$user/username" /></h2>
						<xsl:choose>
							<xsl:when test="$user/sesso = 'M'">
								<img alt="" src="../img/utenti/uomo.png"/>
							</xsl:when>
							<xsl:otherwise>
								<img alt="" src="../img/utenti/donna.png" />
							</xsl:otherwise>
						</xsl:choose>
						<ul>
							<xsl:if test="$weight">
								<li>Peso: <xsl:value-of select="$weight" /> Kg</li>
							</xsl:if>
							<xsl:if test="$height">
								<li>Altezza: <xsl:value-of select="$height" /> cm</li>
							</xsl:if>
							<li>Sesso: <xsl:value-of select="$user/sesso" /></li>
							<!--Formatto la data secondo il formato italiano-->
							<li>Nato il giorno: <xsl:value-of select="concat(
																		  substring($user/dataNascita, 9, 2),
																		  '/',
																		  substring($user/dataNascita, 6, 2),
																		  '/',
																		  substring($user/dataNascita, 1, 4)
																		)" />
							</li>
							<xsl:if test="$height and $weight">
								<li>
									IMC (Indice di Massa Corporea):
									<xsl:value-of select="	format-number(
																$weight div (($height div 100)*($height div 100)),
																'##.##'
															)" />
								</li>
							</xsl:if>
						</ul>
					</div>
					<div class="info">
						<h3>Contatti</h3>
						<p>Indirizzo email: <xsl:value-of select="$user/email" /></p>
						<xsl:if test="$user/tel">
							<p>
								Numero di telefono <xsl:value-of select="$user/tel" />
							</p>
						</xsl:if>
					</div>
					<div id="piani">
						
					</div>
				</div>
				<div id="footer" class="noFloat">
					<p>
						<a href="http://validator.w3.org/check?uri=referer"><img src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0 Strict" /></a>
						<a href="http://jigsaw.w3.org/css-validator/check/referer"><img src="http://jigsaw.w3.org/css-validator/images/vcss" alt="CSS Valido!" /></a>
						Forza e coraggio - <span xml:lang="en">All rights reserved</span>
					</p>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
