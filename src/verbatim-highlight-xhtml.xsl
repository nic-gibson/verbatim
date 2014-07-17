<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:pkg="http://expath.org/ns/pkg"
	exclude-result-prefixes="xs xd verbatim saxon pkg"
	version="2.0">
		
	<xsl:import href="verbatim-xhtml.xsl"/>
	
	<pkg:import-uri>http://www.corbas.co.uk/xmlverbatim/highlight-xhtml</pkg:import-uri>
	
	
	
	<xd:doc scope="stylesheet">
		<xd:desc>
			
			<xd:b>
				<xd:b>XML Verbatim XHTML Renderer with Highlighting</xd:b>
			</xd:b>
			
			<xd:p>
				<xd:i>Version 1.0</xd:i>
			</xd:p>
			<xd:p>Contributors: Nic Gibson</xd:p>
			<xd:p>Copyright 2014 Corbas Consulting Ltd</xd:p>
			<xd:p>Contact: corbas@corbas.co.uk</xd:p>
			
			
			<xd:p>XML to "escaped" xhtml with configurability. Generates XHTML with styling and
				override options through modularity. This stylesheet layers on the standard
			xhtml stylesheet to add the facility to provide an XPath statement as a string
			for evaluation. If a node
			matches, it will be highlighted by wrapping it in a xhtml <xd:b>span</xd:b> element
			and applying a CSS class (given by the <xd:b>verbatim:xpath-highlight-class</xd:b> parameter).</xd:p>
			
			<xd:p><xd:b>The XPath evaluation: </xd:b> the XPath statement provided is passed to
			the Saxon <xd:b>saxon:evaluate</xd:b> function. The context node is passed to the function
			as well. Therefore it can be accessed via <xd:i>$p1</xd:i> from within the XPath.</xd:p>
			
			<xd:p>
				<xd:b>License Terms</xd:b>
			</xd:p>
			
			<xd:p>This program and accompanying files are copyright 2014 Corbas Consulting
				Ltd.</xd:p>
			
			<xd:p>This program is free software: you can redistribute it and/or modify it under the
				terms of the GNU General Public License as published by the Free Software
				Foundation, either version 3 of the License, or (at your option) any later
				version.</xd:p>
			
			<xd:p>This program is distributed in the hope that it will be useful, but WITHOUT ANY
				WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
				PARTICULAR PURPOSE. See the GNU General Public License for more details.</xd:p>
			
			<xd:p>You should have received a copy of the GNU General Public License along with this
				program. If not, see http://www.gnu.org/licenses/.</xd:p>
			
			<xd:p>
				<xd:b>Corbas Consulting Clients and Customers</xd:b>
			</xd:p>
			
			<xd:p>If your organisation or company are a customer or client of Corbas Consulting Ltd
				you may be able to use and/or distribute this software under a different license. If
				you are not aware of any such agreement and wish to agree other license terms you
				must contact Corbas Consulting Ltd by email at corbas@corbas.co.uk.</xd:p>
			
		</xd:desc>
		
		<xd:param name="verbatim:xpath-highlight-class">The CSS class name to be applied to spans wrapping
			entire elements. Defaults to <xd:i>verbatim-highlight</xd:i></xd:param>
		
	</xd:doc>
	
	<xsl:output method="xhtml" omit-xml-declaration="yes" indent="no"/>
	
	<xsl:param name="verbatim:highlight-class" select="'verbatim-highlight'"/>
	
	<xsl:template match="node()" mode="verbatim">
		<xsl:param name="highlight-xpath" as="xs:string" select="''"/>
		<xsl:variable name="matching-nodes" select="if ($highlight-xpath) then saxon:evaluate($highlight-xpath, .) else ()" as="item()*"/>
		<xsl:next-match>
			<xsl:with-param name="highlight-matching-nodes" select="$matching-nodes" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	
	<!-- precedence rules mean that we can't be totally generic here -->
	<xsl:template match="*|@*|comment()|processing-instruction()|text()" mode="verbatim:node">
		<xsl:param name="highlight-matching-nodes"  tunnel="yes" as="item()*"/>
		<xsl:variable name="is-highlight" select="some $x in $highlight-matching-nodes satisfies $x is ."/>
		<xsl:choose>
			<xsl:when test="some $x in $highlight-matching-nodes satisfies $x is .">
				<span class="{$verbatim:highlight-class}">
					<xsl:next-match/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:next-match/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>