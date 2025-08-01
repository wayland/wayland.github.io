<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:str="http://exslt.org/strings"
>
  <xsl:template match="div[@class='card-container']|card" mode="component.content.style">
    <style>
      .card-container {
        display: grid;
        grid-template-columns: repeat(var(--card-column-count), 1fr);
        justify-content: space-around;
        align-items: stretch;
      }
      .card {
        display: grid;
        grid-template-area: "date" "main";

        border-width: 6pt;
        border-color: hsl(var(--card-hue), var(--card-border-level), var(--card-border-level));
        border-style: outset;
        border-radius: 12pt;
        margin: 3%;

        background-color: hsl(var(--card-hue), var(--card-background-level), var(--card-background-level));

        color: inherit;
        text-decoration: inherit; 
      }
      .date-content {
        grid-area: "date";

        margin-inline: 3%;
        text-align: right;
      }
      .card-content {
        grid-area: "main";

        margin-inline: 3%;
      }
      .card-container h2 {
        background-color: rgba(0,0,0,0);
        border-width: 0px;

        color: black;
        text-align: center;
        font-family: "Urbanist";
      }
    </style>
  </xsl:template>

  <xsl:template match="card" mode="content">
    <xsl:call-template name="make-card">
      <xsl:with-param name="href" select="@href"/>
      <xsl:with-param name="hue" select="@hue"/>
      <xsl:with-param name="level" select="'60%'"/>
      <xsl:with-param name="title" select="@title"/>
      <xsl:with-param name="content" select="./node()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="make-card">
    <xsl:param name="href"/>
    <xsl:param name="hue"/>
    <xsl:param name="level"/>
    <xsl:param name="title"/>
    <xsl:param name="content"/>
    <xsl:param name="date"/>
    <a href="{$href}" style="--card-hue: {$hue}; --card-border-level: calc({$level} - 10%); --card-background-level: {$level}" class="card">
      <div class="date-content"><xsl:value-of select="$date"/></div>
      <div class="card-content">
        <h2><xsl:value-of select="$title"/></h2>
        <p><xsl:copy-of select="$content"/></p>
      </div>
    </a>
  </xsl:template>
</xsl:stylesheet>
