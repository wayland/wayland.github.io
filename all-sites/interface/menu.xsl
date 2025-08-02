<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>
  <xsl:template match="content[1]" mode="component.content.style">
    <xsl:apply-templates select="*" mode="component.content.style"/>
    <style>
      /* Code for CSS menus */
      .menu-bar {
        z-index: 2;
        grid-area: sitemenu;
      }

      .menu-bar ul {
        top: 0;
        width: 100%;
        height: fit-content; 

        margin: 0;
        padding: 0;

        list-style-type: none;
        background-color: hsl(var(--site-hue), 50%, 50%);
        font-weight: bold;
      }

      .menu-bar li a, .menu-bar .menu-bar-button {
        display: inline-block;
        color: black;
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
      }

      .menu-bar li a:hover, .menu-bar :is(.menu-container:hover, .dropmenu-container.hover) .menu-bar .menu-bar-button {
        background-color: var(--menu-bar-background-color-hover);
      }

      .menu-bar :is(span.menu-container, li.dropmenu-container) {
        display: inline-block;
      }


      .menu-bar .menu-content {
        display: none;
        position: absolute;
        background-color: hsl(var(--site-hue), 50%, 50%);
        box-shadow: 0px 8px 16px hsl(var(--site-hue), 50%, 50%, 0.2);
        min-width: 160px;
        z-index: 1;
      }

      .menu-bar .menu-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
        text-align: left;
        border-radius: 4pt;
      }

      .menu-bar .menu-content a:hover {
        border-radius: 4pt;
        background-color: hsl(var(--site-hue), 50%, 80%);
      }

      .menu-bar .menu-container:hover .menu-content {
        display: block;
      }

      /* Drop menu */
      .menu-bar .dropmenu-content {
        background-color: var(--menu-bar-background-color);
        display: none;
      }
      .menu-bar .menu-content.dropmenu-content a.menu-bar-button {
        color: white;
      }
      .menu-bar a.menu-bar-button:hover {
        background-color: hsl(var(--site-hue), 50%, 80%);
        border-radius: 4pt;
      }

      .menu-bar .dropmenu-container:hover .dropmenu-content .menu-content { /* menu from dropmenu */
        /*display: none;*/
      }

      .menu-bar .dropmenu-content is:(.menu:hover, .dropmenu-container:hover) .menu-content { /* When hovering over menubar item */
        display: block;
      }
      .menu-bar :is(.menu-container, .dropmenu-container) .dropmenu-content:hover .menu-content {
      }
      .menu-bar .dropmenu-container:hover .dropmenu-content {
        display: flex;
        position: absolute;
        left: 0;
        z-index: 2;
      /*	width: 100%; */
      }


      .menu-bar .menu-subheader {
        font-weight: 900;
        font-size: 130%;
        background-color: #bfbfbf;
        padding: 4pt 4pt;

        display: inline-block;
        width: 100%;
        border-radius: 4pt;
      }

      .menu-bar section {
        margin: 0px 16px;
      }

      .menu-bar .unimportant {
        background-color: #7fbfff;
      }

      .menu-bar a:hover.unimportant {
        background-color: #dfefff;
      }

      .siteslist ul {
        display: flex;
        border: 0pt solid red;
        width: 100%;
        padding-top: 5pt;
        padding-bottom: 5pt;
        padding-left: 0pt;
        padding-right: 0pt;
        background-color: black;
        margin: 0pt;

        font-family: "Urbanist", sans-serif;
        font-optical-sizing: auto;
        font-weight: 900;
        font-style: bold;

        color: white;
      }
      .siteslist ul li {
        display: inline;
        padding: 6pt;
        border-left: 1pt solid white;
        border-right: 1pt solid white;
      }
      .siteslist li a {
        color: inherit;
        text-decoration: none;	
      }
      
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
  </xsl:template>

  <xsl:template name="siteslist">
    <div class="siteslist">
      <xsl:apply-templates select="$siteslist/sites"/>
    </div>
  </xsl:template>

  <xsl:template name="menu-bar">
    <div class="menu-bar"><ul>
      <xsl:apply-templates select="$sitecontents/site-contents/section" mode="menubar"/>
    </ul></div>
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
</xsl:stylesheet>
