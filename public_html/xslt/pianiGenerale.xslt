<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method='xml' version='1.0' encoding='UTF-8' indent="yes" omit-xml-declaration="yes" />

    <xsl:param name="username" />
    <xsl:template match="/">
        <h4>Piani di allenamento</h4>
        <ul>
        <xsl:for-each select="/piani/piano[utente = $username]">
            <li class="piano">
                <a href="piano.cgi?id={@id}"><xsl:value-of select="nome" /></a>
                Totale Esercizi: <xsl:value-of select="count(esercizio)" />
                <a href="cancellaPiano.cgi?id={@id}">
                    <img class="delete, icon" src="../img/delete-icon.png" alt="Cancella il piano {nome}" />
                </a>
                <a href="modificaPiano.cgi?id={@id}">
                    <img class="edit, icon" src="../img/edit-icon.png" alt="Modifica il piano {nome}" />
                </a>
            </li>
        </xsl:for-each>
        </ul>
    </xsl:template>

</xsl:stylesheet>