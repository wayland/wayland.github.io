Source for website: [Wayland's Smithy](https://wayland.github.io/index.xml)

# Code

Source is XML, and is processed with XSLT (on the browser side) to become HTML/CSS.  

The XSLT has been broken down into various components.  Each component has three sections:
-	(Optional) A Script section, containing the Javascript; see bibleref for an example
-	(Optional) A <style> section, for the CSS styling
-	Templates: One or more templates, which turn specific XML tags into HTML

## Components

The components are categorised either as "content" (including meta-content, like footnotes 
and table-of-contents), or "interface".  

### Content Components

* bibleref
* cards
* site-content-main (aka blog-series)
* footnotes
* page-contents

### Interface Components

* section-contents
* menu

