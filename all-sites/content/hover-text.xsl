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
        /* Each cite is its own anchor; scope prevents name collisions */
        anchor-name: --hover;
        anchor-scope: --hover;
      }

      .hover-anchor {
        color: blue;
        text-decoration: underline;
      }

      .hover-parent:hover .hover-text,
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

        /* Just to the inline-end of the cite; flip to the start if no room */
        position-anchor: --hover;
        position-area: inline-end;
        margin-inline-start: 4pt;
        margin-block-start: 0.1em;
        position-try-fallbacks: flip-inline;
      }

      /* Invisible bridges toward the cite (both sides, for flip-inline) */
      .hover-text::before,
      .hover-text::after {
        content: "";
        position: absolute;
        top: -0.5em;
        bottom: -0.25em;
        width: 8pt;
      }

      .hover-text::before {
        right: 100%;
      }

      .hover-text::after {
        left: 100%;
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
