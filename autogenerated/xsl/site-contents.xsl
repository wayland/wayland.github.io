<?xml version="1.0" encoding="UTF-8"?>
<!-- Build this-site/generated/site-contents.xml from files.xml.
     Site title / sitedir / structure come from this-site/site-config.xml.
     structure=series — blog-shaped: sections from index.xml + page/series-dir
     structure=tree   — directory tree under sitedir (PP and similar)
     structure=auto   — series if any page has series-dir, else tree -->
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
  <xsl:variable name="site-title" select="$cfg/title"/>
  <xsl:variable name="structure-pref">
    <xsl:choose>
      <xsl:when test="$cfg/structure != ''"><xsl:value-of select="$cfg/structure"/></xsl:when>
      <xsl:otherwise>auto</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="file-list" select="document($files-xml)/filesystem-info/file-list"/>
  <xsl:variable name="files" select="$file-list/file"/>
  <xsl:variable name="root-prefix" select="concat($sitedir, '/')"/>

  <xsl:variable name="resolved-structure">
    <xsl:choose>
      <xsl:when test="$structure-pref = 'series' or $structure-pref = 'tree'">
        <xsl:value-of select="$structure-pref"/>
      </xsl:when>
      <xsl:when test="$files[@src != concat($sitedir, '/index.xml') and substring(@src, string-length(@src)-8) = 'index.xml'][document(concat('./', @src))/page/series-dir]">
        <xsl:text>series</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>tree</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <site-contents>
      <section sitedir="{$sitedir}">
        <title><xsl:value-of select="$site-title"/></title>
        <xsl:choose>
          <xsl:when test="$resolved-structure = 'series'">
            <xsl:apply-templates select="$files[substring(@src, string-length(@src)-8) = 'index.xml' and @src != concat($sitedir, '/index.xml')]" mode="series"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="emit-tree">
              <xsl:with-param name="prefix" select="$root-prefix"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </section>
    </site-contents>
  </xsl:template>

  <!-- ===== series mode (blog) ===== -->

  <xsl:template match="file" mode="series">
    <xsl:variable name="series" select="document(concat('./', @src))/page"/>
    <xsl:if test="not($series/@hidden)">
      <section series-url="{$series/series-dir}/index.xml">
        <title><xsl:value-of select="$series/title"/></title>
        <xsl:for-each select="$files[substring(@src, 0, string-length($series/series-dir)+1) = $series/series-dir]">
          <xsl:sort select="@is-index" order="descending"/>
          <xsl:sort select="@created"/>
          <xsl:call-template name="emit-article">
            <xsl:with-param name="filename" select="@src"/>
            <xsl:with-param name="skip-index" select="true()"/>
          </xsl:call-template>
        </xsl:for-each>
      </section>
    </xsl:if>
  </xsl:template>

  <!-- ===== tree mode (directory hierarchy) ===== -->

  <xsl:template name="emit-tree">
    <xsl:param name="prefix"/>
    <xsl:for-each select="$files[starts-with(@src, $prefix) and not(contains(substring-after(@src, $prefix), '/'))]">
      <xsl:sort select="@src"/>
      <xsl:call-template name="emit-article">
        <xsl:with-param name="filename" select="@src"/>
        <xsl:with-param name="skip-index" select="false()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="$files[starts-with(@src, $prefix) and contains(substring-after(@src, $prefix), '/')]">
      <xsl:sort select="substring-before(substring-after(@src, $prefix), '/')"/>
      <xsl:variable name="seg" select="substring-before(substring-after(@src, $prefix), '/')"/>
      <xsl:variable name="first" select="$files[starts-with(@src, concat($prefix, $seg, '/'))][1]"/>
      <xsl:if test="generate-id() = generate-id($first)">
        <section>
          <title><xsl:value-of select="translate($seg, '-', ' ')"/></title>
          <xsl:call-template name="emit-tree">
            <xsl:with-param name="prefix" select="concat($prefix, $seg, '/')"/>
          </xsl:call-template>
        </section>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="emit-article">
    <xsl:param name="filename"/>
    <xsl:param name="skip-index" select="false()"/>
    <xsl:if test="not($skip-index and substring($filename, string-length($filename)-8) = 'index.xml')">
      <xsl:variable name="page" select="document(concat('./', $filename))/page"/>
      <xsl:if test="not($page/@hidden)">
        <article href="{$filename}" name="{$page/title}" width="{$page/width}" pubDate="{$page/pubDate}"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
