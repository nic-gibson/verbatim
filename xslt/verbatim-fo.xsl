<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions" xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs cfn xd verbatim">

	<!--
	* Copyright 2008, 2009, 20011, 2012, 2013, 2018 Corbas Consulting Ltd
	*
	* Licensed under the Apache License, Version 2.0 (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*    http://www.apache.org/licenses/LICENSE-2.0
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
	-->
	
  <xsl:import href="verbatim-base.xsl"/>
	
	<xd:doc scope="stylesheet">
		<xd:desc>
			
			<xd:b>
				<xd:b>XML Verbatim FO Highlighter</xd:b>
			</xd:b>
			
			<xd:p>
				<xd:i>Version 1.0</xd:i>
			</xd:p>
			<xd:p>Contributors: Nic Gibson</xd:p>
			<xd:p>Copyright 2014 Corbas Consulting Ltd</xd:p>
			<xd:p>Contact: corbas@corbas.co.uk</xd:p>
			
			
			<xd:p>XML to "escaped" XSL-FO with configurability. Generates XSL-FO with styling and
				override options through modularity. This stylesheet layers on the standard
				xhtml stylesheet to add the facility to provide an XPath statement as a string
				for evaluation.</xd:p>
			
		</xd:desc>
		
		
	</xd:doc>

	
	<!-- When we write out FO we don't have the CSS to handle this so it has to be here -->
	<xsl:attribute-set name="verbatim:fo-defaults" >
		<xsl:attribute name="color">#333333</xsl:attribute>
		<xsl:attribute name="font-family">monospace</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="verbatim:fo-element-name">
		<xsl:attribute name="color">#990000</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-element-nsprefix">
		<xsl:attribute name="color">#666600</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="verbatim:fo-element-name">
		<xsl:attribute name="color">#990000</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-attr-name">
		<xsl:attribute name="color">#660000</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-attr-content">
		<xsl:attribute name="color">#000099</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-ns-prefix">
		<xsl:attribute name="color">#666600</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-ns-uri">
		<xsl:attribute name="color">#330099</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-text">
		<xsl:attribute name="color">#000000</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-comment">
		<xsl:attribute name="color">#006600</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-pi-name">
		<xsl:attribute name="color">#006600</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="verbatim:fo-pi-content">
		<xsl:attribute name="color">#006666</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim:fo-indent-class"/>
	<xsl:attribute-set name="verbatim:fo-element"/>
	
	<xd:doc>
		<xd:desc>Output a block around the output</xd:desc>
	</xd:doc>
	<xsl:template match="node()" mode="verbatim:initial-node">
		<fo:block xsl:use-attribute-sets="verbatim:fo-defaults">
			<xsl:next-match/>
		</fo:block>
	</xsl:template>
			
	

	<xd:doc>
		<xd:desc>
			<xd:p>Output the namespace prefix for an element that actually has one.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(local-name() = name())]" mode="verbatim:ns-prefix">
		<fo:inline xsl:use-attribute-sets="verbatim:fo-ns-prefix">
			<xsl:next-match/>
		</fo:inline>
	</xsl:template>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Output the element name itself</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:name">
		<fo:inline  xsl:use-attribute-sets="verbatim:fo-element-name">
			<xsl:next-match/>
		</fo:inline>
	</xsl:template>	




	<xd:doc>
		<xd:desc>Render an attribute name</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="verbatim:name">
		<fo:inline  xsl:use-attribute-sets="verbatim:fo-attr-name">
			<xsl:next-match/>
		</fo:inline>
	</xsl:template>
	
	
	<xd:doc>
		<xd:desc>Render an attribute value</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="verbatim:content">
		<fo:inline  xsl:use-attribute-sets="verbatim:fo-attr-content">
			<xsl:next-match/>
		</fo:inline>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Process text. Potentially replaces entities and restricts the amount of output
				text. Newlines are replaced with breaks.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="text()" mode="verbatim:node">
		
		<!-- capture this because we don't want to generate an empty span -->
		<xsl:variable name="content">
			<xsl:next-match/>
		</xsl:variable>
		
		<xsl:if test="not(normalize-space($content) = '')">
			<fo:inline xsl:use-attribute-sets="verbatim:fo-text"><xsl:next-match/></fo:inline>
		</xsl:if>
		
	</xsl:template>



	<xd:doc>
		<xd:desc>
			<xd:p>Output the body of a comment wrapped in an fo:inline</xd:p>
		</xd:desc>
	</xd:doc>
	
	<xsl:template match="comment()" mode="verbatim:content">
		<fo:inline xsl:use-attribute-sets="verbatim:fo-comment"><xsl:next-match/></fo:inline>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output processing instruction body, wrapped in an fo:inline.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim:content">
		<fo:inline xsl:use-attribute-sets="verbatim:fo-pi-content">
			<xsl:next-match/>
		</fo:inline>
	</xsl:template>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Output processing instruction name, wrapped in an fo:inline.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim:name">
		<fo:inline xsl:use-attribute-sets="verbatim:fo-pi-name">
			<xsl:next-match/>
		</fo:inline>
	</xsl:template>	

	<xd:doc>
		<xd:desc>
			<xd:p>Write out a break as appropriate for the output type -  a block node in this
				case.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="node()" mode="verbatim:break" name="verbatim:break">
		<fo:block/>
	</xsl:template>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Write out an indent wrapped in a span. Holds the result of next-match
				in a variable so that we can suppress empty results.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="node()" mode="verbatim:indent">
		<xsl:variable name="content" as="xs:string">
			<xsl:next-match/>
		</xsl:variable>
		<xsl:if test="not($content = '')">
			<fo:inline xsl:use-attribute-sets="verbatim:fo-indent-class">
				<xsl:next-match/>
			</fo:inline>
		</xsl:if>	
	</xsl:template>



</xsl:stylesheet>
