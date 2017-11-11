<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs verbatim xd">

  <xsl:import href="verbatim-base.xsl"/>


	<xd:doc scope="stylesheet">
		<xd:desc>

			<xd:b>
				<xd:b>XML Verbatim XHTML Renderer</xd:b>
			</xd:b>

			<xd:p>
				<xd:i>Version 2.0</xd:i>
			</xd:p>
			<xd:p>Contributors: Nic Gibson</xd:p>
			<xd:p>Copyright 2014 Corbas Consulting Ltd</xd:p>
			<xd:p>Contact: corbas@corbas.co.uk</xd:p>

			<xd:p>Rewritten as a layer above the base renderer.</xd:p>

			<xd:p>
				<xd:i>Version 1.0</xd:i>
			</xd:p>
			<xd:p>Contributors: Nic Gibson</xd:p>
			<xd:p>Copyright 2013 Corbas Consulting Ltd</xd:p>
			<xd:p>Contact: corbas@corbas.co.uk</xd:p>

			<xd:p>XML to "escaped" xhtml with configurability. Generates XHTML with styling and
				override options through modularity. </xd:p>
			
			<xd:p>You may override any CSS class used by simply changing the appropriate parameters
			documented below.</xd:p>

			<xd:p>
				<xd:b>License Terms</xd:b>
			</xd:p>

			<xd:p>This program and accompanying files are copyright 2013, 2014 Corbas Consulting
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

		<xd:param name="verbatim:element-class">The CSS class name to be applied to spans wrapping
			entire elements. Defaults to <xd:i>verbatim-element</xd:i></xd:param>

		<xd:param name="verbatim:element-name-class">The CSS class to be applied to spans wrapping
			element names. Defaults to <xd:i>verbatim-element-name</xd:i></xd:param>
		
		<xd:param name="verbatim:attribute-name-class">The CSS class to be applied to spans wrapping
			attribute names. Defaults to <xd:i>verbatim-attr-name</xd:i></xd:param>
		
		<xd:param name="verbatim:attribute-content-class">The CSS class to be applied to spans wrapping
			attribute values. Defaults to <xd:i>verbatim-attr-content</xd:i></xd:param>
		

		<xd:param name="verbatim:element-ns-prefix-class">The CSS class name to applied to spans
			wrapping element namespace prefixes. Defaults to
			<xd:i>verbatim-ns-prefix</xd:i></xd:param>

		<xd:param name="verbatin:ns-name-class">The CSS class name applied to spans wrapping
			namespace URIs. Defaults to <xd:i>verbatim-ns-name</xd:i></xd:param>
		
		<xd:param name="verbatin:text-class">The CSS class name applied to spans wrapping
			text nodes. Defaults to <xd:i>verbatim-text</xd:i></xd:param>
		
		<xd:param name="verbatin:comment-class">The CSS class name applied to spans wrapping
			comments. Defaults to <xd:i>verbatim-comment</xd:i></xd:param>
		
		<xd:param name="verbatin:pi-name-class">The CSS class name applied to spans wrapping
			processing instruction names. Defaults to <xd:i>verbatim-pi-name</xd:i></xd:param>
		
		<xd:param name="verbatin:pi-content-class">The CSS class name applied to spans wrapping
			processing instruction content. Defaults to <xd:i>verbatim-pi-content</xd:i></xd:param>
		
		<xd:param name="verbatin:indent-class">The CSS class name applied to spans wrapping
			indent text. Defaults to <xd:i>verbatim-indent</xd:i></xd:param>

	</xd:doc>

	<xsl:output method="xhtml" omit-xml-declaration="yes" indent="no"/>

	<xsl:param name="verbatim:element-class" select="'verbatim-element'"/>
	<xsl:param name="verbatim:element-ns-prefix-class" select="'verbatim-ns-prefix'"/>
	<xsl:param name="verbatim:ns-name-class" select="'verbatim-ns-name'"/>
	<xsl:param name="verbatim:element-name-class" select="'verbatim-element-name'"/>
	<xsl:param name="verbatim:attribute-name-class" select="'verbatim-attr-name'"/>
	<xsl:param name="verbatim:attribute-content-class" select="'verbatim-attr-content'"/>
	<xsl:param name="verbatim:text-class" select="'verbatim-text'"/>
	<xsl:param name="verbatim:comment-class" select="'verbatim-comment'"/>
	<xsl:param name="verbatim:pi-name-class" select="'verbatim-pi-name'"/>
	<xsl:param name="verbatim:pi-content-class" select="'verbatim-pi-content'"/>
	<xsl:param name="verbatim:indent-class" select="'verbatim-indent'"/>

	<xd:doc>
		<xd:desc>
			<xd:p>Wrap elements in element spans.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:node">
		
		<span class="{$verbatim:element-class}">
			<xsl:next-match/>
		</span>
		<xsl:text>&#x0A;</xsl:text>
		
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output the namespace prefix for an element that actually has one, wrapped
			in a span. Uses the value of <xd:b>verbatim:element-ns-prefix-class</xd:b> for the <xd:i>class</xd:i>
			attribute.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(local-name() = name())]" mode="verbatim:ns-prefix">
		<span class="{$verbatim:element-ns-prefix-class}">
			<xsl:next-match/>
		</span>
	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>Output the element name itself, wrapped in a span.  Uses the value of <xd:b>verbatim:element-name-class</xd:b> for the <xd:i>class</xd:i>
				attribute.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:name">
		<span class="{$verbatim:element-name-class}">
			<xsl:next-match/>
		</span>
	</xsl:template>



	<xd:doc>
		<xd:desc>
			<xd:p>Renders an individual namespace declaration, wrapped in a span.  
				Uses the value of <xd:b>verbatim:element-ns-name-class</xd:b> for the <xd:i>class</xd:i>
				attribute.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:render-ns-declaration">
		<span class="{$verbatim:ns-name-class}">
			<xsl:next-match/>
		</span>
	</xsl:template>

	<xd:doc>
		<xd:desc>Generate a namespace declaration for those elements where the parent is in a
			namespace but the current node isn't, wrapped in a span.
			Uses the value of <xd:b>verbatim:element-ns-name-class</xd:b> for the <xd:i>class</xd:i>
			attribute.</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(namespace-uri())][namespace-uri(parent::*)]"
		mode="verbatim:ns-declarations">
		<span class="{$verbatim:ns-name-class}"><xsl:next-match/></span>
	</xsl:template>


	<xd:doc>
		<xd:desc>Render an attribute name, wrapped in a span.
			Uses the value of <xd:b>verbatim:attribute-name-class</xd:b> for the <xd:i>class</xd:i>
			attribute.</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="verbatim:name">
		<span class="{$verbatim:attribute-name-class}">
			<xsl:next-match/>
		</span>
	</xsl:template>


	<xd:doc>
		<xd:desc>Render an attribute value, wrapped in a span.
			Uses the value of <xd:b>verbatim:attribute-content-class</xd:b> for the <xd:i>class</xd:i>
			attribute.</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="verbatim:content">
		<span class="{$verbatim:attribute-content-class}">
			<xsl:next-match/>
		</span>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Process text. Calls the base version and wraps that 
				in a span if the result is not empty.  Uses the value of 
				<xd:b>verbatim:text-class</xd:b> for the <xd:i>class</xd:i>
				attribute.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="text()" mode="verbatim:node">
		
		<!-- capture this because we don't want to generate an empty span -->
		<xsl:variable name="content">
			<xsl:next-match/>
		</xsl:variable>

		<xsl:if test="not(normalize-space($content) = '')">
			<span class="{$verbatim:text-class}"><xsl:value-of select="$content"/></span>
		</xsl:if>
		
	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>Output the body of a comment wrapped in a span.
				Uses the value of <xd:b>verbatim:comment-class</xd:b> for the <xd:i>class</xd:i>
				attribute.</xd:p>
		</xd:desc>
	</xd:doc>

	<xsl:template match="comment()" mode="verbatim:content">
		<span class="{$verbatim:comment-class}"><xsl:next-match/></span>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output processing instruction body, wrapped in a span.
				Uses the value of <xd:b>verbatim:pi-content-class</xd:b> for the <xd:i>class</xd:i>
				attribute.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim:content">
		<span class="{$verbatim:pi-content-class}">
			<xsl:next-match/>
		</span>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output processing instruction name, wrapped in a span.
				Uses the value of <xd:b>verbatim:pi-name-class</xd:b> for the <xd:i>class</xd:i>
				attribute.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim:name">
		<span class="{$verbatim:pi-name-class}">
			<xsl:next-match/>
		</span>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Write out a break as appropriate for the output type - br node in this
				case.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="node()" mode="verbatim:break" name="verbatim:break">
		<br/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Write out an indent wrapped in a span. Holds the result of next-match
			in a variable so that we can suppress empty results.
			Uses the value of <xd:b>verbatim:indent-class</xd:b> for the <xd:i>class</xd:i>
				attribute.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="node()" mode="verbatim:indent">
		<xsl:variable name="content" as="xs:string">
			<xsl:next-match/>
		</xsl:variable>
		<xsl:if test="not($content = '')">
			<span class="{$verbatim:indent-class}"><xsl:next-match/></span>
		</xsl:if>
		
	</xsl:template>
</xsl:stylesheet>
