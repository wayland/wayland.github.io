<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>
<xsl:include href="content/bibleref.xsl"/>
<xsl:include href="content/cards.xsl"/>

<!-- Overall Page Layout -->

  <!-- Get filename -->
  <xsl:param name="sitedir" select="page/sitedir"/>
  <xsl:param name="sitedir_string">
    <xsl:choose>
      <xsl:when test="$sitedir != ''"><xsl:value-of select="$sitedir"/>/</xsl:when>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="filename" select="concat($sitedir_string, page/filename)"/>
  <xsl:param name="interface_structure" select="document('structure.xml')"/>
  <!-- Get sites -->
  <xsl:param name="siteslist" select="document('siteslist.xml')"/>
  <!-- Get sitemap -->
  <xsl:param name="sitecontents" select="document(concat('../', $sitedir, '/this-site/generated/site-contents.xml'))"/>
  <!-- Set up node variables -->
  <xsl:param name="currentnode" select="$sitecontents//article[@href=$filename] | $sitecontents//section[@series-url=$filename]"/>
  <xsl:param name="prevnode" select="page/prevnode/article | $currentnode/preceding::article[position()=1]"/>
  <xsl:param name="nextnode" select="page/nextnode/article | $currentnode/following::article[position()=1]"/>
  <!-- Set up usable text variables -->
  <xsl:param name="title" select="page/title"/>
  <!-- Set up usable text variables -->
  <xsl:param name="is-landing" select="page/width = 'landing'"/>
  <xsl:param name="currentpath">/<xsl:value-of select="$filename"/></xsl:param>
  <xsl:param name="author">
    <xsl:choose>
      <xsl:when test="page/author/@name"><xsl:value-of select="page/author/@name"/></xsl:when>
      <xsl:otherwise>Tim Nelson</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <!-- Formatted to keep extra space out of the return value -->
  <xsl:param name="indexfile">
    <xsl:call-template name="select-not-last">
      <xsl:with-param name="parseText" select="$filename"/>
      <xsl:with-param name="separator" select="'/'"/>
      <xsl:with-param name="first" select="true()"/>
    </xsl:call-template>/index.xml</xsl:param>
  <xsl:param name="site-index" select="document(concat('/', $sitedir, '/index.xml'))/page"/>
  <xsl:param name="bibliography" select="document(concat('../', $sitedir, page/content/@bibliography))/page/content//biblio-ref | //biblio-ref"/>

  <xsl:template match="/">
<html>
<head>
<title><xsl:value-of select="$title"/> :: <xsl:value-of select="$site-index/title"/></title>
<!-- Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime:ital,wght@0,400;0,700;1,400;1,700&amp;family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400;1,600;1,700&amp;family=Gravitas+One:ital@0;1&amp;family=Dosis:wght@200..800&amp;family=Forum&amp;family=Noto+Emoji:wght@300..700&amp;family=Quattrocento:wght@400;700&amp;family=Urbanist:ital,wght@0,100..900;1,100..900&amp;display=swap" rel="stylesheet"/>

<!-- jQuery -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.slim.min.js">
</script>

<xsl:apply-templates select="*" mode="component.content.script"/>
<xsl:apply-templates select="*" mode="component.content.style"/>

<!-- Links and stylesheet -->
<base href="{$interface_structure/window/base/@href}"/>

<link rel="stylesheet" href="/all-sites/interface.css"/>
<link rel="stylesheet" href="/all-sites/toc.css"/>
<link rel="stylesheet" href="/all-sites/content.css"/>
<link rel="stylesheet" href="{$sitedir}/this-site/site-styling.css"/>

</head>
<body>

<div class="wide-box {$currentnode/@width}">

<div class="siteslist">
    <style>
    .sites-list-item:hover[hue]:not([hue=""]) {
        background-color: hsl(var(--item-hue), 60%, 60%);
    }
    .sites-list-item:hover[hue=""] {
        background-color: grey;
        color: white;
    }
    .sites-list-item:hover {
      color: black;
    }
    .sites-menu-chosen {
        <xsl:choose>
          <xsl:when test="$currentpath='/index.xml'">
            background-color: white;
            color: black;
          </xsl:when>
          <xsl:otherwise>
            background-color: hsl(var(--site-hue), 50%, 50%);
          </xsl:otherwise>
        </xsl:choose>
    }
    .sites-menu-chosen:hover {
        <xsl:if test="$currentpath='/index.xml'">
          background-color: grey;
          color: white;
        </xsl:if>
    }
    </style>
	<xsl:apply-templates select="$siteslist/sites"/>
</div>

<div class="left-column">
  <div class="tab-widget">
    <xsl:if test="not($is-landing)">
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
    </xsl:if>
  </div>

</div>

<div class="main-column">
  <xsl:if test="not($is-landing)">
    <div class="menu-bar"><ul>
      <xsl:apply-templates select="$sitecontents/site-contents/section" mode="menubar"/>
    </ul></div>
  </xsl:if>

<div class="main-box">

<div class="breadcrumbs">
  <xsl:for-each select="$currentnode//ancestor::section[title != $title]">
    <a href="{@sitedir | @series-url}"><xsl:value-of select="./title/node()"/></a> > 
  </xsl:for-each>
  <a href="{$currentpath}"><xsl:value-of select="$title"/></a>
</div>

<div class="title"><xsl:value-of select="$title"/></div>

<xsl:if test="not($is-landing)"><div class="tagline"><xsl:value-of select="$author"/>, <xsl:choose><xsl:when test="substring(page/pubDate, 0, 17)"><xsl:value-of select="substring(page/pubDate, 0, 17)"/></xsl:when><xsl:otherwise>2024-2025</xsl:otherwise></xsl:choose></div></xsl:if>

<xsl:choose>
  <xsl:when test="page/content/@type = 'blog-index'">
    <xsl:apply-templates select="$sitecontents/site-contents/section[@sitedir=$sitedir]/section[@series-url = $filename]" mode="blog-series"/>
  </xsl:when>
  <xsl:when test="page/content/@type = 'bibliography'">
    <xsl:apply-templates select="page/content/node()" mode="content-bibliography"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="page/content/node()" mode="content"/>
  </xsl:otherwise>
</xsl:choose>

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
</div> <!-- main-box -->

<div class="footer">
  <xsl:if test="not($is-landing)">
    <span class="left"><xsl:call-template name="FooterLink">
      <xsl:with-param name="type" select="'prev'"/>
      <xsl:with-param name="node" select="$prevnode"/>
    </xsl:call-template></span>
    <span class="centre"><xsl:if test="$sitedir = 'blog'">
      <a href="blog/this-site/generated/rss.xml">
        <img src="all-sites/Feed-icon.svg" height="24pt"/>
      </a>
    </xsl:if></span>
    <span class="right"><xsl:call-template name="FooterLink">
      <xsl:with-param name="type" select="'next'"/>
      <xsl:with-param name="node" select="$nextnode"/>
    </xsl:call-template></span>
  </xsl:if>
</div>
<div class="copyright">© Copyright Tim Nelson, 2024-2025</div>
</div>

<div class="right-column">
  <div class="tab-widget">
    <xsl:if test="not($is-landing)">
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
    </xsl:if>
  </div>
</div>

</div> <!-- wide-box -->

</body>
</html>
    
  </xsl:template>
  
  <xsl:template name="FooterLink">
    <xsl:param name="type"/>
    <xsl:param name="node"/>
    <a href="{$node/@href}"><xsl:if test="$type = 'prev' and $node/@href != ''">&lt;&lt; </xsl:if><xsl:value-of select="$node/@name"/><xsl:if test="$type = 'next'"> &gt;&gt;</xsl:if></a>
  </xsl:template>
  
  <xsl:template match="section" mode="menubar">
	<span class="menu-container">
	  <xsl:apply-templates select="title"/>
    <div class="menu-content">
      <xsl:apply-templates select="./section" mode="menu"/>
    </div>
	</span>
  </xsl:template>
  
  <xsl:template match="menubar/dropmenu">
	<li class="dropmenu-container">
	  <xsl:apply-templates select="title"/>
    <div class="dropmenu-content">
      <xsl:apply-templates select="*[self::menu or self::menuitem]" mode="submenu"/>
    </div>
	</li>
  </xsl:template>
  
  <xsl:template match="section/title">
		<a href="javascript:void(0)" class="menu-bar-button"><xsl:value-of select="."/></a>
  </xsl:template>
    
  <xsl:template match="section" mode="menu--">
	  <span class="menu-container">
      <a href="javascript:void(0)" class="menu-bar-button"><xsl:value-of select="title"/></a>
      <div class="menu-content">
        <xsl:apply-templates select="*[self::menu or self::menuitem]"/>
      </div>
    </span>
  </xsl:template>
  
  <xsl:template match="section" mode="menu--">
			<section>
        <xsl:variable name="href" select="article[1]/@href"/>
        <a href="{$href}"><xsl:value-of select="title"/></a>
			</section>
  </xsl:template>
  
  <xsl:template match="section" mode="menu">
			<section>
                          <xsl:apply-templates select="article"/>
			</section>
  </xsl:template>
  
  <xsl:template match="article">
			<a href="{@href}"><xsl:value-of select="@name"/></a>
  </xsl:template>
   
  <xsl:template match="@* | node()" mode="content">
    <xsl:copy>
      <xsl:apply-templates  select="@* | node()" mode="content"/>
    </xsl:copy>
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

  <xsl:template match="callout" mode="content">
    <div class="callout-parent">
      <xsl:attribute name="style">min-width: <xsl:value-of select="@min-width"/></xsl:attribute>
      <span class="callout-quote-mark">“</span>
      <span class="callout-text"><xsl:apply-templates select="@* | node()" mode="content"/></span>
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

  <xsl:template match="xtlinclude" mode="content">
    <xsl:variable name="svgdoc" select="document(@href)/svg:svg"/>
    <xsl:variable name="width">
        <xsl:choose>
          <xsl:when test="@width"><xsl:value-of select="@width"/>mm</xsl:when>
          <xsl:when test="$svgdoc/@width"><xsl:value-of select="$svgdoc/@width"/></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="height">
        <xsl:choose>
          <xsl:when test="@height"><xsl:value-of select="@height"/>mm</xsl:when>
          <xsl:when test="$svgdoc/@height"><xsl:value-of select="$svgdoc/@height"/></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- xsl:variable name="viewBox">
        <xsl:choose>
          <xsl:when test="@width and @height">0 0 <xsl:value-of select="$width"/> <xsl:value-of select="$height"/></xsl:when>
          <xsl:when test="$svgdoc/@viewBox"><xsl:value-of select="$svgdoc/@viewBox"/></xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable -->
    <svg:svg>
      <xsl:if test="$width"><xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute></xsl:if>
      <xsl:if test="$height"><xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute></xsl:if>
      <!-- xsl:if test="$viewBox"><xsl:attribute name="viewBox"><xsl:value-of select="$viewBox"/></xsl:attribute></xsl:if -->
      <xsl:copy-of select="$svgdoc/* | $svgdoc/@*[local-name() != 'width' and local-name() != 'height']"/>
    </svg:svg>
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

  <xsl:template match="h1|h2|h3" mode="content">
    <xsl:param name="id">
      <xsl:choose>
        <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <a class="pre-heading" name="{$id}"/>
    <a class="heading-link" href="{$filename}#{$id}">
      <xsl:element name="{name()}">
        <xsl:copy-of select="./text() | ./*"/>
        <xsl:if test="@id">
          <span style="font-family: 'Noto Emoji'">⚓</span>
        </xsl:if>
      </xsl:element>
    </a>
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

  <!-- sites list -->
  <xsl:template match="sites">
      <ul class="siteslist">
        <span style="width: 30pt"><img src="/all-sites/WaylandSmithLogo.png" style="width: 24pt; height: 24pt;"/></span>
        <xsl:apply-templates select="site"/>
      </ul>
  </xsl:template>

  <xsl:template match="site">
    <xsl:param name="chosen-class">
      <xsl:if test="@slug=substring($currentpath, 0, string-length(@slug)+1)">sites-menu-chosen</xsl:if>
    </xsl:param>
    <li class="{$chosen-class} sites-list-item" style="--item-hue: {@hue}" hue="{@hue}">
      <a href="{@href}">
        <xsl:value-of select="@title"/>
      </a>
    </li>
  </xsl:template>
  
  <!-- blog series cards -->
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

  <xsl:template match="section" mode="blog-series">
    <div class="card-container" style="--card-column-count: 1">
      <xsl:apply-templates select="section|article" mode="blog-series">
        <xsl:sort select="@pubDate" order="descending"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>
  
  <xsl:template match="article" mode="blog-series">
    <xsl:param name="article" select="document(concat('/', @href))/page"/>
    <xsl:call-template name="make-card">
      <xsl:with-param name="href" select="@href"/>
      <xsl:with-param name="hue" select="0"/>
      <xsl:with-param name="level" select="'97%'"/>
      <xsl:with-param name="title" select="@name"/>
      <xsl:with-param name="content" select="$article/description"/>
      <xsl:with-param name="date" select="substring($article/pubDate, 0, 17)"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Inspired by the "Plain XSLT 1.0 solution" by Dimitre Novatchev at https://stackoverflow.com/questions/4845660/xsl-how-to-split-strings -->
  <!-- Formatted to keep extra space out of the return value -->
  <xsl:template name="select-not-last">
    <xsl:param name="parseText" select="."/>
    <xsl:param name="separator"/>
    <xsl:param name="first"/>
    <xsl:if test="string-length($parseText) and contains($parseText, $separator)">
      <xsl:if test="not($first)">/</xsl:if><xsl:value-of select="substring-before(concat($parseText,$separator),$separator)"/>
      <xsl:call-template name="select-not-last">
        <xsl:with-param name="parseText" select="substring-after($parseText, $separator)"/>
        <xsl:with-param name="separator" select="$separator"/>
        <xsl:with-param name="first" select="false()"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Prevent text from appearing in the wrong modes -->
  <xsl:template match="text()" mode="component.content.script"/>
  <xsl:template match="text()" mode="component.content.style"/>

</xsl:stylesheet>
