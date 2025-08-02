<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>

  <xsl:template name="footnote-block">
    <xsl:if test="//ref | //footnote">
      <h1>Footnotes</h1>
      <xsl:if test="//footnote">
        <h2>Informational</h2>
        <xsl:apply-templates select="//footnote" mode="footnotes"/>
      </xsl:if>
      <xsl:if test="//ref">
        <h2>References</h2>
        <xsl:apply-templates select="//ref" mode="footnotes"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ref|footnote" mode="component.content.style">
    <style>
      .reference {
        margin-top: 5pt;
      }
      .reference::before {
        content: "\2014 ";
      }

      .references-reference {
        font-size: -10%;
        margin: 0 10pt;
      }
    </style>
  </xsl:template>

  <xsl:template match="footnote" mode="content">
      <xsl:call-template name="HoverAnchor">
        <xsl:with-param name="item_count"><xsl:number count="footnote" level="any" format="a"/></xsl:with-param>
        <xsl:with-param name="content"><xsl:apply-templates select="@* | node()" mode="content"/></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template match="footnote" mode="footnotes">
    <div class="references-reference">
      <xsl:number count="footnote" level="any" format="a"/>. 
      <xsl:apply-templates select="@* | node()" mode="content"/>
    </div>
  </xsl:template>

  <xsl:template match="ref" mode="content">
      <xsl:call-template name="HoverAnchor">
        <xsl:with-param name="item_count"><xsl:number count="ref" level="any"/></xsl:with-param>
        <xsl:with-param name="content"><xsl:call-template name="ReferenceContent"/></xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template match="ref" mode="footnotes">
    <div class="references-reference">
      <xsl:number count="ref" level="any"/>. 
      <xsl:call-template name="ReferenceContent"/>
    </div>
  </xsl:template>
  
  <xsl:template match="biblio-ref" mode="content"/>
  
  <xsl:template match="bibliography" mode="content-bibliography">
    <div style="padding: 4pt; display: grid; grid-template-columns: * *; justify-content: start; gap: 4pt 2em">
      <xsl:apply-templates select="*" mode="content-bibliography">
        <xsl:sort select="@label"/>
        <xsl:sort select="authors"/>
        <xsl:sort select="@title"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="biblio-ref" mode="content-bibliography">
      <span style="grid-column: 1"><xsl:value-of select="@label"/></span>
      <span style="grid-column: 2"><xsl:call-template name="ReferenceContent"/></span>
  </xsl:template>

  <!-- Superscripted hover anchor for footnotes -->
  <xsl:template name="HoverAnchor">
    <xsl:param name="item_count"/>
    <xsl:param name="content"/>
    <span class="hover-parent">
			<span class="hover-anchor"><sup>[<xsl:value-of select="$item_count"/>]</sup></span>
			<span class="hover-text">
	<xsl:copy-of select="$content"/>
        <xsl:value-of select="comment"/>
      </span>
		</span>
  </xsl:template>
  
  <!-- Almost-Chicago "Notes and Bibliography" style -->
  <xsl:template name="ReferenceContent">
    <xsl:param name="ref" select="."/>
    <xsl:param name="biblio-ref" select="$bibliography[@label=$ref/@label]"/>
    <xsl:if test="authors | $biblio-ref/authors"><xsl:value-of select="authors | $biblio-ref/authors"/>, </xsl:if>
    <i>
      <xsl:choose>
        <xsl:when test="@href | $biblio-ref/@href">
          <xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="@href | $biblio-ref/@href"/></xsl:attribute>
            <xsl:value-of select="@title | $biblio-ref/@title"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@title | $biblio-ref/@title"/>
        </xsl:otherwise>
      </xsl:choose>
    </i><xsl:if test="@largerwork | $biblio-ref/@largerwork"> in <i><xsl:value-of select="@largerwork | $biblio-ref/@largerwork"/></i></xsl:if>
    <xsl:choose>
      <xsl:when test="@publishinglocation | $biblio-ref/@publishinglocation">,
        (<xsl:value-of select="@publishinglocation | $biblio-ref/@publishinglocation"/>: <xsl:value-of select="@publishinghouse | $biblio-ref/@publishinghouse"/>,
        <xsl:value-of select="@publishingdate | $biblio-ref/@publishingdate"/>)</xsl:when>
      <xsl:when test="@publishingdate | $biblio-ref/@publishingdate">
        (<xsl:value-of select="@publishingdate | $biblio-ref/@publishingdate"/>)</xsl:when>
    </xsl:choose><xsl:if test="@pages">,
      <xsl:value-of select="@pages"/>
    </xsl:if>.  <xsl:if test="@comments"><xsl:value-of select="@comments"/></xsl:if>
  </xsl:template>

</xsl:stylesheet>