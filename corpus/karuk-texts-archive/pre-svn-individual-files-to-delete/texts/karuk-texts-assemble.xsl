<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <!--   <xsl:template match="text">
        <xsl:copy-of select="document(concat(@id,'.xml'))/text"/>
    </xsl:template>  -->
    <xsl:template match="text">
        <xsl:apply-templates select="document(concat(@id,'.xml'))/text" mode="each-text"/>
    </xsl:template>
    <xsl:template match="text" mode="each-text">
        <xsl:copy>
            <xsl:attribute name="id" select="@id"/>
            <xsl:if test="@audio-source">
                <xsl:attribute name="audio-source" select="@audio-source"/>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="note">
        <xsl:copy>
            <xsl:if test="@publish">
                <xsl:attribute name="publish" select="@publish"/>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="s">
        <xsl:copy>
            <xsl:if test="@spkr">
                <xsl:attribute name="spkr" select="@spkr"/>
            </xsl:if>
            <xsl:if test="@audio">
                <xsl:attribute name="audio" select="@audio"/>
            </xsl:if>
            <xsl:if test="@audio-start-time">
                <xsl:attribute name="audio-start-time" select="@audio-start-time"/>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="kar">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <karuk-plain>
            <xsl:apply-templates mode="karuk-plain"/>
        </karuk-plain>
    </xsl:template>
    <xsl:template match="w" mode="karuk-plain">
        <xsl:value-of
            select="replace(normalize-space(replace(translate(., 'áâéêíîóôúûã', 'aaeeiioouua'),' ','')),' ','')"
        />
    </xsl:template>
    <xsl:template match="w">
        <xsl:variable name="m-id" select="m[1]/@id"/>
        <xsl:variable name="Gloss"
            select="document('karuk-lexicon.xml')/database/lxGroup[IDNumber=$m-id]/Gloss"/>
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="@gl">
                    <xsl:attribute name="gl" select="@gl"/>
                </xsl:when>
                <xsl:when test="contains($Gloss,' ;')">
                    <xsl:attribute name="gl"
                        select="translate(translate(substring-before($Gloss,';'),'_–—','.::'),' ','.')"
                    />
                </xsl:when>
                <xsl:when test="contains($Gloss,';')">
                    <xsl:attribute name="gl"
                        select="translate(translate(substring-before($Gloss,';'),'_–—','.::'),' ','.')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="gl"
                        select="translate(translate($Gloss,'_–—','.::'),' ','.')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="m">
        <xsl:variable name="m-id" select="@id"/>
        <xsl:variable name="Gloss"
            select="document('karuk-lexicon.xml')/database/lxGroup[IDNumber=$m-id]/Gloss"/>
        <xsl:copy>
            <xsl:if test="@language">
                <xsl:attribute name="language" select="@language"/>
            </xsl:if>
            <xsl:if test="@id">
                <xsl:attribute name="id" select="$m-id"/>
                <xsl:choose>
                    <xsl:when test="contains($Gloss,' ;')">
                        <xsl:attribute name="gl"
                            select="translate(translate(substring-before($Gloss,' ;'),'_–—','.::'),' ','.')"
                        />
                    </xsl:when>
                    <xsl:when test="contains($Gloss,';')">
                        <xsl:attribute name="gl"
                            select="translate(translate(substring-before($Gloss,';'),'_–—','.::'),' ','.')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="gl"
                            select="translate(translate($Gloss,'_–—','.::'),' ','.')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
