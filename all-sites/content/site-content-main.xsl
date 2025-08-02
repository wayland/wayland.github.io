<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>
  <xsl:template match="blog-series-cards" mode="content">
    <xsl:apply-templates select="$sitecontents/site-contents/section[@sitedir=$sitedir]/section" mode="series-cards">
      <xsl:sort select="title"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="section" mode="series-cards">
    <xsl:param name="series" select="document(concat('/', @series-url))/page"/>
    <xsl:call-template name="make-card">
      <xsl:with-param name="href" select="concat('/', $series/series-dir, '/index.xml')"/>
      <xsl:with-param name="hue" select="$series/colour-scheme/@hue"/>
      <xsl:with-param name="level" select="$series/colour-scheme/@level"/>
      <xsl:with-param name="title" select="title"/>
      <xsl:with-param name="content" select="$series/description"/>
    </xsl:call-template>    
  </xsl:template>
</xsl:stylesheet>
