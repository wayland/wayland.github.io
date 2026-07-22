<?xml version="1.0" encoding="UTF-8" ?>
<!-- Build this-site/generated/rss.xml from files.xml + this-site/site-config.xml. -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xml:base="../.."
  encoding="UTF-8"
>
  <xsl:param name="site-config" select="'blog/this-site/site-config.xml'"/>
  <xsl:param name="files-xml" select="'blog/this-site/generated/files.xml'"/>

  <xsl:variable name="cfg" select="document($site-config)/site-config"/>
  <xsl:variable name="sitedir" select="$cfg/sitedir"/>
  <xsl:variable name="link-prefix" select="$cfg/link-prefix"/>
  <xsl:variable name="rss-source" select="concat($link-prefix, $sitedir, '/this-site/generated/rss.xml')"/>

  <xsl:variable name="filesystem-info" select="document($files-xml)/filesystem-info"/>
  <xsl:variable name="file-list" select="$filesystem-info/file-list"/>

  <xsl:template match="/">
    <rss version="2.0">

    <channel>
      <title><xsl:value-of select="$cfg/title"/></title>
      <link><xsl:value-of select="concat($link-prefix, $sitedir, '/index.xml')"/></link>
      <description><xsl:value-of select="$cfg/description"/></description>
      <xsl:for-each select="$file-list/file[not(@is-index)]">
        <xsl:sort select="@is-index" order="descending"/>
        <xsl:sort select="created"/>
        <xsl:call-template name="process-file">
          <xsl:with-param name="filenode" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <language><xsl:value-of select="$cfg/language"/></language>
      <copyright><xsl:value-of select="$cfg/copyright"/></copyright>
      <lastBuildDate><xsl:value-of select="$filesystem-info/lastBuildDate"/></lastBuildDate>
      <generator>xsltproc</generator>
      <docs>https://www.rssboard.org/rss-specification</docs>
      <ttl>1440</ttl>
    </channel>
    </rss>
  </xsl:template>

  <xsl:template name="process-file">
    <xsl:param name="filenode"/>
    <xsl:apply-templates select="document(concat('./', $filenode/@src))" mode="file">
      <xsl:with-param name="filenode" select="$filenode"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="/" mode="file">
    <xsl:param name="filenode"/>

    <xsl:variable name="page" select="document(concat('./', $filenode/@src))/page"/>
    <xsl:if test="not(page/@hidden)">
      <xsl:variable name="title" select="page/title/node()"/>
      <item>
        <title><xsl:value-of select="$title"/></title>
        <link><xsl:value-of select="$link-prefix"/><xsl:value-of select="$filenode/@src"/></link>
        <description><xsl:copy-of select="$page/description/node()"/></description>
        <category><xsl:copy-of select="$page/category/node()"/></category>
        <pubDate><xsl:value-of select="$page/pubDate | $filenode/@created"/></pubDate>
        <source><xsl:value-of select="$rss-source"/></source>
      </item>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
