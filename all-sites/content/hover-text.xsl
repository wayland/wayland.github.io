<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>
  <!-- Handles hover text of all kinds -->
  <xsl:template name="HoverAnchorStyle">
    <style>
      .hover-parent {
        position: relative;
        display: inline;
      }

      .hover-anchor {
        color: blue;
        text-decoration: underline;
      }

      .hover-anchor:hover + .hover-text {
        display: block;
      }

      .hover-text:hover {
        display: block;
      }

      .hover-text {
        z-index: 1;
        position: absolute;
        display: none;

        width: 400px;
        left: 10pt;
        top: 0pt;
        border: 2px solid hsl(var(--blockquote-border-hue), 74%, 74%);
        border-radius: 4pt;
        padding: 10px;

        background-color: hsl(var(--blockquote-background-hue), 100%, 97%);
      }
    </style>
  </xsl:template>

  <!-- Superscripted hover anchor for footnotes -->
  <xsl:template name="HoverAnchorContent">
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
</xsl:stylesheet>
