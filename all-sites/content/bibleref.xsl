<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>
  <xsl:template match="bible-blockquote[1]" mode="component.content.script">
    <script type="text/javascript">
    function openBibleTab(evt, reference, version) {
      // Declare all variables
      var i, tabcontent, tablinks, versiontabs;

      // Get all elements with class="tabcontent" and hide them
      tabcontent = document.getElementsByClassName("tabcontent");
      for (i = 0; i &lt; tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
      }

      // Show the current tab, and add an "active" class to the button that opened the tab
      versiontabs = document.querySelectorAll(".tabcontent." + version);
      for (i = 0; i &lt; versiontabs.length; i++) {
        versiontabs[i].style.display = "block";
      }

      // Get all elements with class="tablinks" and remove the class "active"
      tablinks = document.getElementsByClassName("tablinks");
      for (i = 0; i &lt; tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
      }
      versiontabs = document.querySelectorAll(".tablinks." + version);
      for (i = 0; i &lt; versiontabs.length; i++) {
        versiontabs[i].className += " active";
      }
    }
    </script>
  </xsl:template>

  <xsl:template match="bible-blockquote[1]" mode="component.content.style">
    <style>
      // .bible-blockquote-container {}

      .bible-blockquote-container .bible-version-tabs {
        padding: 0pt 10pt;
      }

      .bible-blockquote-container .bible-version-tabs button {
        padding: 5pt 10pt;
        border-radius: 4pt 4pt 0pt 0pt;
        border-color: hsl(var(--blockquote-border-hue), 74%, 74%);
        border-style: solid;
        border-width: 1pt;
        background-color: hsl(var(--blockquote-background-hue), 100%, 97%);
      }

      .bible-blockquote-container .bible-version-tabs button.active {
        border-width: 2pt;
        background-color: hsl(var(--blockquote-background-hue), 90%, 90%);
      }

      .bible-blockquote-container .bible-version-tabs button:hover {
        background-color: hsl(var(--blockquote-background-hue), 70%, 70%);
      }

      .bible-blockquote-container .bible-version-tabs button.active:hover {
        background-color: hsl(var(--blockquote-background-hue), 70%, 70%);
      }

      .bible-blockquote-container .bible-verse-content blockquote {
        display: none;
      }

      .bible-blockquote-container .bible-verse-content blockquote.active {
        display: block;
      }

      .bible-blockquote-container .bible-verse-content blockquote:target {
        display: block;
      }
    </style>
  </xsl:template>

  <!-- Bible Blockquotes -->
  <xsl:template match="bible-blockquote" mode="content">
    <div class="bible-blockquote-container">
      <xsl:copy-of select="@*"/>
      <div class="bible-version-tabs"><button onClick="openBibleTab(event, '{@url-reference}', 'traditional')" class="tablinks active">Traditional (KJV)</button><button onClick="openBibleTab(event, '{@url-reference}', 'contemporary')" class="tablinks">Contemporary (CEV)</button></div>
      <div class="bible-verse-content">
        <xsl:apply-templates  select="blockquote" mode="bible-blockquote">
          <xsl:with-param name="blockquote-container" select="."/>
          <xsl:with-param name="active-version" select="'traditional'"/>
        </xsl:apply-templates>
      </div>
    </div>
  </xsl:template>
  <xsl:template match="blockquote" mode="bible-blockquote">
    <xsl:param name="blockquote-container"/>
    <xsl:param name="active-version"/>
    <blockquote>
      <xsl:copy-of select="@*"/>
      <xsl:if test="contains(@class, $active-version)">
        <xsl:attribute name="class"><xsl:value-of select="concat(@class, ' active')"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates  select="node()" mode="content"/>
      <div class="reference"><xsl:value-of select="$blockquote-container/@author"/> (<a href="https://www.biblegateway.com/passage/?search={$blockquote-container/@url-reference}&amp;version={@version-id}"><xsl:value-of select="$blockquote-container/@reference"/></a>)</div>
    </blockquote>
  </xsl:template>
  <xsl:template match="versestart" mode="content"><sub><xsl:value-of select="@num"/></sub></xsl:template>

</xsl:stylesheet>