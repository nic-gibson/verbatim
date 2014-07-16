# verbatim

Tools for escaping XML to a form renderable in XML. There are three stylesheets here, all XSLT 2.0.

Most of the documentation is in Oxygen's XD format embedded in the stylesheets. This is just a summary:

```xml
<xsl:apply-templates select="my-interesting-node" mode="verbatim"/>
```

## Base stylesheet ##

The base stylesheet - `lib/verbatim-base.xsl`  - escapes XML to text. The only meaningful formatting options relate to the inclusion of line breaks and indentation.

```xml
<foo name="bar"/>
```

```html
&lt;foo name="bar"/&gt;
```

## XHTML stylesheet ##

The xhtml stylesheet - `verbatim-xhtml.xsl` - escapes XML to XHTML. This allows formatting!

```xml
<foo name="bar"/>
```

```html
<span class="verbatim-element">&lt;<span class="verbatim-element-name">foo</span> <span class="verbatim-attr-name">name</span>="<span class="verbatim-attr-content">bar</span>"/&gt;<br/></span>
```

###  Changing settings ###

All parameters can be set on a global or per application basis. The global parameters are all of the form `verbatim:x` . The local versions simply omit the namespace.

e.g
```xml
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim">
	<xsl:import href="verbatim-xhtml.xsl"/>
	<xsl:param name="verbatim:indent-elements" select="true()"/>
	<xsl:template match="example">
		<xsl:apply-templates select="section" mode="verbatim"/>
	</xsl:apply-templates>
</xsl:stylesheet>
```

or 

```xml
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim">
	<xsl:import href="verbatim-xhtml.xsl"/>
		<xsl:template match="example">
		<xsl:apply-templates select="section" mode="verbatim">
			<xsl:param name="indent-elements" select="true()"/>
		</xsl:apply-templates>
	</xsl:apply-templates>
</xsl:stylesheet>
```

## XHTML with highlighting ##

The third stylesheet - `verbatim-highlight-xhtml.xsl` - layers on top of the previous stylesheet to provide highlighting in the output:

```xml
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim">
	<xsl:import href="verbatim-highlight-xhtml.xsl"/>
		<xsl:template match="example">
		<xsl:apply-templates select="section" mode="verbatim">
			<xsl:param name="indent-elements" select="true()"/>
			<xsl:param name="">
		</xsl:apply-templates>
	</xsl:apply-templates>
</xsl:stylesheet>
```

## XSL-FO ##

The final stylesheet - `verbatim-fo.xsl` - layers on top of `verbatim-base.xsl` to generate XSL-FO renderings.  