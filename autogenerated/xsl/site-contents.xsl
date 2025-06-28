<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xml:base="../.."
  encoding="UTF-8"?
>
  <xsl:param name="series-list" select="document('blog/this-site/generated/files.xml')/filesystem-info/file-list/file[substring(@src, string-length(@src)-8) = 'index.xml' and @src != 'blog/index.xml']"/>
  
  <xsl:template match="/">
    <site-contents>
      <section sitedir="blog">
        <title>Wayland's Scriptorium</title>
        <xsl:apply-templates select="$series-list"/>
      </section>
    </site-contents>
  </xsl:template>

  <xsl:template name="process-file">
    <xsl:param name="filename"/>
    <xsl:apply-templates select="document(concat('./', $filename))" mode="file">
      <xsl:with-param name="filename" select="$filename"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="/" mode="file">
    <xsl:param name="filename"/>
    <xsl:if test="not(page/@hidden)">
      <xsl:variable name="title" select="page/title/node()"/>
      <xsl:if test="substring($filename, string-length($filename)-8) != 'index.xml'"><article href="{$filename}" name="{$title}" width="{page/width/text()}"/></xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="file">
    <xsl:param name="series" select="document(concat('./', @src))/page"/>
    <xsl:if test="not($series/@hidden)">
      <section series-url="{$series/series-dir}/index.xml">
        <title><xsl:value-of select="$series/title"/></title>

        <xsl:for-each select="document('blog/this-site/generated/files.xml')//file[substring(@src, 0, string-length($series/series-dir)+1) = $series/series-dir]">
          <xsl:sort select="@is-index" order="descending"/>
          <xsl:sort select="@created"/>
          <xsl:call-template name="process-file">
            <xsl:with-param name="filename" select="@src"/>
          </xsl:call-template>
        </xsl:for-each>
      </section>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
