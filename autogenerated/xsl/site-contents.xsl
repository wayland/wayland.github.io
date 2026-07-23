<?xml version="1.0" encoding="UTF-8"?>
<!-- Build this-site/generated/site-contents.xml from files.xml.
     Site title / sitedir / structure / optional nav-areas come from site-config.
     structure=series — one outer @sitedir section; series nest underneath (blog)
     structure=tree   — each first-level area is a top-level @sitedir section
     Optional page <nav-order> → files.xml @nav-order; sorted with data-type=number
     (pages without nav-order sort after those with it; then @src).
     Optional folder index.xml <nav-title> overrides the submenu title derived
     from the directory name (e.g. Declarative → “Fundamental Declarative…”).
     Optional site-config <nav-areas><area dir="TOP"/>…</nav-areas> fixes top
     menubar order (empty dir = root/site-title section). -->
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
      <xsl:choose>
        <xsl:when test="$resolved-structure = 'series'">
          <section sitedir="{$sitedir}">
            <title><xsl:value-of select="$site-title"/></title>
            <xsl:apply-templates select="$files[substring(@src, string-length(@src)-8) = 'index.xml' and @src != concat($sitedir, '/index.xml')]" mode="series"/>
          </section>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="emit-tree-menubar"/>
        </xsl:otherwise>
      </xsl:choose>
    </site-contents>
  </xsl:template>

  <!-- ===== series mode (blog) ===== -->

  <xsl:template match="file" mode="series">
    <xsl:variable name="series" select="document(concat('./', @src))/page"/>
    <xsl:if test="not($series/@hidden)">
      <section series-url="{$series/series-dir}/index.xml">
        <title><xsl:value-of select="$series/title"/></title>
        <xsl:for-each select="$files[substring(@src, 0, string-length($series/series-dir)+1) = $series/series-dir]">
          <xsl:sort select="number(boolean(@nav-order))" data-type="number" order="descending"/>
          <xsl:sort select="@nav-order" data-type="number"/>
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

  <!-- ===== tree mode ===== -->

  <xsl:template name="emit-tree-menubar">
    <xsl:choose>
      <xsl:when test="$cfg/nav-areas/area">
        <xsl:for-each select="$cfg/nav-areas/area">
          <xsl:call-template name="emit-top-area">
            <xsl:with-param name="dir" select="@dir"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- Discover areas; order by minimum @nav-order among pages in each area -->
        <xsl:call-template name="emit-top-area">
          <xsl:with-param name="dir" select="''"/>
        </xsl:call-template>
        <xsl:for-each select="$files[starts-with(@src, $root-prefix) and contains(substring-after(@src, $root-prefix), '/')]">
          <xsl:sort select="number(boolean(@nav-order))" data-type="number" order="descending"/>
          <xsl:sort select="@nav-order" data-type="number"/>
          <xsl:sort select="@src"/>
          <xsl:variable name="seg" select="substring-before(substring-after(@src, $root-prefix), '/')"/>
          <xsl:variable name="cand" select="."/>
          <xsl:for-each select="$files[starts-with(@src, concat($root-prefix, $seg, '/'))]">
            <xsl:sort select="number(boolean(@nav-order))" data-type="number" order="descending"/>
            <xsl:sort select="@nav-order" data-type="number"/>
            <xsl:sort select="@src"/>
            <xsl:if test="position() = 1 and generate-id() = generate-id($cand)">
              <xsl:call-template name="emit-top-area">
                <xsl:with-param name="dir" select="$seg"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="emit-top-area">
    <xsl:param name="dir"/>
    <xsl:choose>
      <xsl:when test="$dir = ''">
        <section sitedir="{$sitedir}">
          <title><xsl:value-of select="$site-title"/></title>
          <section>
            <title><xsl:value-of select="$site-title"/></title>
            <xsl:for-each select="$files[starts-with(@src, $root-prefix) and not(contains(substring-after(@src, $root-prefix), '/'))]">
              <xsl:sort select="number(boolean(@nav-order))" data-type="number" order="descending"/>
              <xsl:sort select="@nav-order" data-type="number"/>
              <xsl:sort select="@src"/>
              <xsl:call-template name="emit-article">
                <xsl:with-param name="filename" select="@src"/>
                <xsl:with-param name="skip-index" select="false()"/>
              </xsl:call-template>
            </xsl:for-each>
          </section>
        </section>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="area-prefix" select="concat($root-prefix, $dir, '/')"/>
        <xsl:variable name="area-title">
          <xsl:call-template name="folder-section-title">
            <xsl:with-param name="seg" select="$dir"/>
            <xsl:with-param name="seg-prefix" select="$area-prefix"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="has-nested" select="$files[starts-with(@src, $area-prefix) and contains(substring-after(@src, $area-prefix), '/')]"/>
        <section sitedir="{$sitedir}">
          <title><xsl:value-of select="$area-title"/></title>
          <xsl:choose>
            <xsl:when test="not($has-nested)">
              <section>
                <title><xsl:value-of select="$area-title"/></title>
                <xsl:for-each select="$files[starts-with(@src, $area-prefix) and not(contains(substring-after(@src, $area-prefix), '/'))]">
                  <xsl:sort select="number(boolean(@nav-order))" data-type="number" order="descending"/>
                  <xsl:sort select="@nav-order" data-type="number"/>
                  <xsl:sort select="@src"/>
                  <xsl:call-template name="emit-article">
                    <xsl:with-param name="filename" select="@src"/>
                    <xsl:with-param name="skip-index" select="false()"/>
                  </xsl:call-template>
                </xsl:for-each>
              </section>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="emit-tree">
                <xsl:with-param name="prefix" select="$area-prefix"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </section>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Interleave direct pages and nested folders by @nav-order (folder key =
       min @nav-order among its pages). -->
  <xsl:template name="emit-tree">
    <xsl:param name="prefix"/>
    <xsl:for-each select="$files[starts-with(@src, $prefix)]">
      <xsl:sort select="number(boolean(@nav-order))" data-type="number" order="descending"/>
      <xsl:sort select="@nav-order" data-type="number"/>
      <xsl:sort select="@src"/>
      <xsl:variable name="rest" select="substring-after(@src, $prefix)"/>
      <xsl:choose>
        <xsl:when test="not(contains($rest, '/'))">
          <xsl:call-template name="emit-article">
            <xsl:with-param name="filename" select="@src"/>
            <xsl:with-param name="skip-index" select="false()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="seg" select="substring-before($rest, '/')"/>
          <xsl:variable name="cand" select="."/>
          <xsl:for-each select="$files[starts-with(@src, concat($prefix, $seg, '/'))]">
            <xsl:sort select="number(boolean(@nav-order))" data-type="number" order="descending"/>
            <xsl:sort select="@nav-order" data-type="number"/>
            <xsl:sort select="@src"/>
            <xsl:if test="position() = 1 and generate-id() = generate-id($cand)">
              <xsl:variable name="seg-prefix" select="concat($prefix, $seg, '/')"/>
              <xsl:variable name="visible">
                <xsl:for-each select="$files[starts-with(@src, $seg-prefix)]">
                  <xsl:variable name="p" select="document(concat('./', @src))/page"/>
                  <xsl:if test="$p and not($p/@hidden)">1</xsl:if>
                </xsl:for-each>
              </xsl:variable>
              <xsl:if test="contains($visible, '1')">
                <section>
                  <title>
                    <xsl:call-template name="folder-section-title">
                      <xsl:with-param name="seg" select="$seg"/>
                      <xsl:with-param name="seg-prefix" select="$seg-prefix"/>
                    </xsl:call-template>
                  </title>
                  <xsl:call-template name="emit-tree">
                    <xsl:with-param name="prefix" select="$seg-prefix"/>
                  </xsl:call-template>
                </section>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Folder submenu title: index.xml <nav-title> if set, else dir name. -->
  <xsl:template name="folder-section-title">
    <xsl:param name="seg"/>
    <xsl:param name="seg-prefix"/>
    <xsl:variable name="index" select="$files[@src = concat($seg-prefix, 'index.xml')]"/>
    <xsl:variable name="nav-title">
      <xsl:if test="$index">
        <xsl:value-of select="document(concat('./', $index/@src))/page/nav-title"/>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string($nav-title) != ''">
        <xsl:value-of select="$nav-title"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate($seg, '-', ' ')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="emit-article">
    <xsl:param name="filename"/>
    <xsl:param name="skip-index" select="false()"/>
    <xsl:if test="not($skip-index and substring($filename, string-length($filename)-8) = 'index.xml')">
      <xsl:variable name="page" select="document(concat('./', $filename))/page"/>
      <!-- Skip non-page XML (e.g. *.svg.xml) and hidden pages -->
      <xsl:if test="$page and not($page/@hidden)">
        <article href="{$filename}" name="{$page/title}" pubDate="{$page/pubDate}"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
