<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xs xd"
	version="2.0">
	
	<xsl:import href="verbatim-base.xsl"/>
	
	<xsl:output method="text"/>
	
	<xsl:param name="suppressed-namespaces-default" as="xs:anyURI*"
		select="for $u in ('http://www.w3.org/1999/XSL/Transform', 
		'http://www.w3.org/2001/XMLSchema',
		'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',
		'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl') return xs:anyURI($u)"/>
	
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> May 14, 2014</xd:p>
			<xd:p><xd:b>Author:</xd:b> nicg</xd:p>
			<xd:p>Test driver for the verbatim-base.xsl stylesheet. We have to suppress the
			namespaces that XSpec adds to the nodes under test or the results will always
			fail. This does mean that we can never test the exact input!</xd:p>
		</xd:desc>
	</xd:doc>
	
	
	<xsl:template match="node()" mode="verbatim">
		
		<result xmlns="http://www.corbas.co.uk/ns/test"><xsl:next-match>
			<xsl:with-param name=""></xsl:with-param>
		</xsl:next-match></result>
	</xsl:template>
	
	
</xsl:stylesheet>