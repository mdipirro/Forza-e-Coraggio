<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method='xml' version='1.0' encoding='UTF-8' indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="exerciseName" />
	<xsl:template match="/">
		<h2>Commenti</h2>
		<xsl:for-each select="commenti/commento[esercizio = $exerciseName]">
			<div>
				<p><strong><xsl:value-of select="utente" /></strong> ha scritto: <xsl:value-of select="testo" /></p>
			</div>
		</xsl:for-each>
		<form action="inserisciCommento.cgi" method="post">
			<fieldset>
				<textarea id="commento" name="commento" rows="2" cols="50">Inserisci un commento</textarea>
				<input type="hidden" id="esercizio" name="esercizio" value="{$exerciseName}" />
			</fieldset>
			<fieldset class="submit">
				<button type="submit">Conferma</button> 
			</fieldset>
		</form>
	</xsl:template>
</xsl:stylesheet>
