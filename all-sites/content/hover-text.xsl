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
        display: inline;
        /* Scope the name so each cite uses its own anchor, not the last on the page */
        anchor-name: --hover;
        anchor-scope: --hover;
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
        box-sizing: border-box;

        width: 400px;
        border: 2px solid hsl(var(--blockquote-border-hue), 74%, 74%);
        border-radius: 4pt;
        padding: 10px;

        background-color: hsl(var(--blockquote-background-hue), 100%, 97%);

        /* Down and to the inline-end of the cite; flip inline if that would overflow */
        position-anchor: --hover;
        position-area: end;
        position-try-fallbacks: flip-inline;
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
