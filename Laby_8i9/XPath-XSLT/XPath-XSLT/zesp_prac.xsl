<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:key name="managerById" match="ROW" use="ID_PRAC"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Zespoły</title>
            </head>
            <body>
                <h1>ZESPOŁY:</h1>

                <ol>
                    <xsl:apply-templates select="ZESPOLY/ROW" mode="list"/>
                </ol>

                <xsl:apply-templates select="ZESPOLY/ROW" mode="details"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ROW" mode="list">
        <li><a href="#{ID_ZESP}"><xsl:value-of select="NAZWA"/></a></li>
    </xsl:template>

    <xsl:template match="ROW" mode="details">
        <p style="font-weight: bold;" id="{ID_ZESP}">
            NAZWA: <xsl:value-of select="NAZWA"/><br/>
            ADRES: <xsl:value-of select="ADRES"/>
        </p>
        <xsl:if test="count(PRACOWNICY/ROW) > 0">
            <table border="1">
                <tr>
                    <th>ID Prac</th>
                    <th>Nazwisko</th>
                    <th>Etat</th>
                    <th>Zatrudniony</th>
                    <th>Placa Pod</th>
                    <th>Placa Dod</th>
                    <th>Szef</th>
                </tr>
                <xsl:apply-templates select="PRACOWNICY/ROW" mode="employee">
                    <xsl:sort select="NAZWISKO"/>
                </xsl:apply-templates>
            </table>
        </xsl:if>
        Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
    </xsl:template>

    <xsl:template match="ROW" mode="employee">
        <tr>
            <td><xsl:value-of select="ID_PRAC"/></td>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td><xsl:value-of select="PLACA_DOD"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="key('managerById', ID_SZEFA)/NAZWISKO">
                        <xsl:value-of select="key('managerById', ID_SZEFA)/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>