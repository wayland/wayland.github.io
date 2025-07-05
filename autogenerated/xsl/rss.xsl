<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xml:base="../.."
  encoding="UTF-8"
>
  <xsl:param name="filesystem-info" select="document('blog/this-site/generated/files.xml')/filesystem-info"/>
  <xsl:param name="file-list" select="$filesystem-info/file-list"/>

  <xsl:template match="/">
    <rss version="2.0">

    <channel>
      <title>Wayland's Scriptorium</title>
      <link>https://wayland.github.io/blog/index.xml</link>
      <description>This is Wayland's website. It links to his main areas of focus (see links), and also functions as a blog for his other thoughts and ideas. </description>
      <xsl:for-each select="$file-list/file[not(@is-index)]">
        <xsl:sort select="@is-index" order="descending"/>
        <xsl:sort select="created"/>
        <xsl:call-template name="process-file">
          <xsl:with-param name="filenode" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <language>en-us</language>
      <copyright>© Copyright Tim Nelson, 2024-2025</copyright>
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
        <link>https://wayland.github.io/<xsl:value-of select="$filenode/@src"/></link>
        <description><xsl:copy-of select="$page/description/node()"/></description>
        <category><xsl:copy-of select="$page/category/node()"/></category>
        <pubDate><xsl:value-of select="$page/pubDate | $filenode/@created"/></pubDate>
        <source>https://wayland.github.io/blog/this-site/generated/rss.xml</source>
      </item>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
