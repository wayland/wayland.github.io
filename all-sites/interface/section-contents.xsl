<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>

  <xsl:template name="section-contents">
    <div class="tab-headers">
      <span class="tab-header">Section Contents</span>
    </div>
    <div class="tab-body">
      <div id="site-contents">
        <xsl:choose>
          <xsl:when test="$sitecontents/site-contents/section[@sitedir=$sitedir]/section[@series-url=$indexfile]">
            <xsl:apply-templates select="$sitecontents/site-contents/section[@sitedir=$sitedir]/section[@series-url = $indexfile]" mode="site-toc"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$sitecontents/site-contents/section[@sitedir=$sitedir]" mode="site-toc"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="section" mode="site-toc">
    <li><xsl:value-of select="title"/></li>
    <ul>
      <xsl:apply-templates select="section|article" mode="site-toc"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="article" mode="site-toc">
    <li><a href="{@href}"><xsl:value-of select="@name"/></a></li>
  </xsl:template>
</xsl:stylesheet>
