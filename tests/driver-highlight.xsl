<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim" version="2.0">

	<xsl:import href="../src/verbatim-highlight-xhtml.xsl"/>

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">

		<html>
			<head>
				<title>Verbatim Highlight XHTML Test</title>
				<link rel="stylesheet" type="text/css" href="documentation.css"/>
			</head>


			<body>
				<h1>Verbatim Highlight XHTML Test</h1>

				<div class="verbatim">
					<p>
						<xsl:apply-templates select="." mode="verbatim">
							<xsl:with-param name="matching-nodes" select="//grandchild"/>
							<xsl:with-param name="indent-elements" select="true()"/>
						</xsl:apply-templates>
					</p>
				</div>

			</body>

		</html>

	</xsl:template>


</xsl:stylesheet>
