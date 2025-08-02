<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>
  <xsl:template match="h1" mode="component.content.style">
    <style>
      @media screen and (max-width: 1000px) {
        #table-of-contents {
          display: none;
        }
      }

      @media screen and (min-width: 1000px) {
        #table-of-contents {
          display: block;
          z-index: 1;
      /*		margin-top: 20pt; */
      /*		border-width: 1px;
          border-radius: 4pt;
          border-color: var(--blockquote-border-color);
          border-style: solid; */
      /*		background-color: #f2f2f2; */
      /*		padding-left: 5pt; */

          grid-column-start: 1;
        }

        #table-of-contents ul {
          list-style-type: none;	
          margin: 0;
          padding-left: 5pt;
          text-align: left;
        }

        #table-of-contents ul li {
          padding: 6pt 0pt;
        }

        #table-of-contents ul li a {
          color: black;
        }

        #table-of-contents ul li a:link {
          text-decoration-style: dotted;
        }

        #table-of-contents ul li a:visited {
          text-decoration-style: dashed;
        }

        #table-of-contents ul li a:hover {
          text-decoration-style: solid;
        }
      }
    </style>
  </xsl:template>

  <xsl:template name="page-contents">
    <div class="tab-headers">
      <span class="tab-header">Page Contents</span>
    </div>
    <div class="tab-body">
      <div id="table-of-contents">
        <ul>
          <xsl:apply-templates select="//h1" mode="toc"/>
        </ul>
      </div>
    </div>  
  </xsl:template>

  <xsl:template match="h1" mode="toc">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <li><a href="{$filename}#{$id}"><xsl:apply-templates  select="node()" mode="toc"/></a></li>
    <ul>
      <xsl:apply-templates select="following::h2[preceding::h1[1]/@id = $id] | following::h2[generate-id(preceding::h1[1]) = $id]" mode="toc"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="h2" mode="toc">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <li><a href="{$filename}#{$id}"><xsl:copy-of select="./text()"/></a></li>
    <ul>
      <xsl:apply-templates select="following::h3[generate-id(preceding::h2[1]) = $id]" mode="toc"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="h3" mode="toc">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <li><a href="{$filename}#{$id}"><xsl:copy-of select="./text()"/></a></li>
  </xsl:template>

  <xsl:template match="@* | node()" mode="toc">
    <xsl:copy>
      <xsl:apply-templates  select="@* | node()" mode="content"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>