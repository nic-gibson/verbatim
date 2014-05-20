<?xml version="1.0" encoding="UTF-8"?>

<!--
    XML to HTML Verbatim Formatter with Syntax Highlighting
    
    Version 2.1
    Contributors: Nic Gibson
    Copyright 2014 Corbas Consulting Ltd
    
    Modified to use as the base for escaped content output to more than
    just xhtml. Inspired by Kourosh Mojar's passing comment. This
    base class renders simple content. verbatim.xsl extends this to xhtml
    and verbatim-fo.xsl extends it to xsl-fo.
    
    Version 2.0
   	Contributors: Nic Gibson
   	Copyright 2011, 2013 Corbas Consulting Ltd
	Contact: corbas@corbas.co.uk

   	Full rewrite of Oliver Becker's original code to modularise for reuseability 
   	and rewrite to XSLT 2.0. Code for handling the root element removed as the
   	purpose of the rewrite is to handle code snippets. Modularisation and extensive
   	uses of modes used to ensure that special purpose usages can be achieved
	through use of xsl:import.
   	
    
    Version 1.1
    Contributors: Doug Dicks, added auto-indent (parameter indent-elements)
                  for pretty-print

    Copyright 2002 Oliver Becker
    ob@obqo.de
 
    Licensed under the Apache License, Version 2.0 (the "License"); 
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software distributed
    under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
    CONDITIONS OF ANY KIND, either express or implied. See the License for the
    specific language governing permissions and limitations under the License.

    Alternatively, this software may be used under the terms of the 
    GNU Lesser General Public License (LGPL).
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs cfn xd">
	
	<xsl:import href="verbatim-base.xsl"/>

	<xsl:output method="xhtml" omit-xml-declaration="yes" indent="no"/>

	<xd:doc>
		<xd:desc>
			<xd:p>Set this to true to indent each line by $indent-increment characters.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:param name="indent-elements" select="false()" as="xs:boolean"/>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Set <xd:b>max-depth</xd:b> to override the depth to which this stylesheet
			will traverse the input document before replacing the child nodes of the current
			node with ellipses.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:param name="max-depth" select="10000" as="xs:integer"/>
	
	<xd:doc>
		<xd:desc><xd:p>If <xd:b>limit-text</xd:b> is set to true then the number of words
		output as element text will be determined by the <xd:b>max-words</xd:b> parameter.</xd:p></xd:desc>
	</xd:doc>
	<xsl:param name="limit-text" select="true()" as="xs:boolean"/>

	<xd:doc>
		<xd:desc><xd:p>If set to true, <xd:b>suppress-ns-declarations-default</xd:b> causes all namespace
		declarations to be omitted from the output. This can be overridden by setting the
		<xd:b>suppress-ns-declarations</xd:b> parameter on the element template.</xd:p></xd:desc>
	</xd:doc>
	<xsl:param name="suppress-ns-declarations-default" select="false()" as="xs:boolean"/>
		
	<xd:doc>
		<xd:desc>
			<xd:p>Set a sequence of URIs in the <xd:b>suppressed-namespaces</xd:b> parameter in order
			to always skip declarations for those namespaces. This allows sample code to be placed
			in a namespace and output without one.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:param name="suppressed-namespaces" select="()" as="xs:string*"/>
	
	<xd:doc>
		<xd:desc><xd:p>Setting <xd:b>replace-entities-default</xd:b> to true to leave entities
			in element text unescaped. This can be overridden by setting the
			<xd:b>replace-entities</xd:b> parameter on the element template.</xd:p></xd:desc>
	</xd:doc>
	<xsl:param name="replace-entities-default" select="true()" as="xs:boolean"/>

	<xd:doc>
		<xd:desc>
			<xd:p><xd:b>indent-char</xd:b> is used for tab expansions and indents. Defaults to an
				non-breaking space.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:param name="indent-char" select="'&#xA0;'" as="xs:string"/>

	<xd:doc>
		<xd:desc>
			<xd:p>Number of indent characters to indent each level of hierarchy when indenting is
				enabled.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:param name="indent-increment" select="3" as="xs:integer"/>

	<xd:doc>
		<xd:desc>
			<xd:p>Maximum level of indent before we indent no further.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:param name="max-indent" select="20" as="xs:integer"/>

	<xd:doc>
		<xd:desc>
			<xd:p><xd:b>tab-width</xd:b> is used for tab expansions. Defines the number of spaces
				that will be used to replace a tab character. Defaults to <xd:b>4</xd:b>.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:param name="tab-width" select="4"/>
	
	<xd:doc>
		<xd:desc><xd:p>Override <xd:b>max-words</xd:b> to change the maximum number of words included
		in element text.</xd:p></xd:desc>
	</xd:doc>
	<xsl:param name="max-words" select="50" as="xs:integer"/>

	<!-- horizontal tab chaaracter -->
	<xsl:variable name="tab" select="'&#x9;'" as="xs:string"/>

	<!-- replicate indent-char tab-width times -->
	<xsl:variable name="tab-out" select="cfn:replicate($indent-char, $tab-width)" as="xs:string"/>

	<!--  used to find new lines -->
	<xsl:variable name="nl" select="'&#xA;'" as="xs:string"/>


	<xd:doc>
		<xd:desc><xd:p>Output the namespace prefix for an element that
		actually has one.</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="*[not(local-name() = name())]" mode="verbatim-ns-prefix">
		<span class="verbatim-element-nsprefix">
			<xsl:next-match/>
		</span>
	</xsl:template>

		
	<xd:doc>
		<xd:desc><xd:p>Output the element name itself</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim-element-name">
		<span class="verbatim-element-name"><xsl:next-match/></span>
	</xsl:template>

	<xd:doc>
		<xd:desc><xd:p>Output the namespace declarations required for an
		element. This will be any namespaces which just came into scope.</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim-ns-declarations">
		<xsl:variable name="node" select="."/>
		
		<!-- get all prefixes which were declared on this node -->
		<xsl:variable name="namespace-prefixes" select="cfn:newly-declared-namespaces(.)"
			as="xs:string*"/>

		<!-- loop over them -->
		<xsl:for-each select="$namespace-prefixes">

			<!-- get the namespace uri -->
			<xsl:variable name="uri" select="namespace-uri-for-prefix(., $node)"/>

			<!-- output if not in our suppressed list -->
			<xsl:if test="not($uri = $suppressed-namespaces)">
				<span class="verbatim-ns-name">
					<xsl:value-of
						select="concat(' xmlns', if (. = '') then '' else concat(':', .), '=&quot;', $uri, '&quot;')"
					/>
				</span>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Renders an individual namespace declaration.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template name="render-verbatim-ns-declaration">
		<!-- probably wrong - apply:imports? -->
		<span class="verbatim-ns-name">
			<xsl:next-match/>
		</span>
	</xsl:template>
	
	<xd:doc>
		<xd:desc>Generate a namespace declaration for those elements where the parent
		is in a namespace but the current node isn't</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(namespace-uri())][namespace-uri(parent::*)]" mode="verbatim-ns-declarations">
		<span class="verbatim-ns-name"><xsl:text> xmlns=""</xsl:text></span>
	</xsl:template>
	
	<xd:doc>
		<xd:desc><xd:p>Process the content of elements. If depth has been exceeded,
		this template will replace the content of the current element with
		ellipsis. This template processes elements with children.</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="*[node()]" mode="verbatim-content">

		<xsl:param name="depth" as="xs:integer"/>
		<xsl:param name="indent" as="xs:integer"/>
		<xsl:param name="replace-entities" as="xs:boolean"/>
		<xsl:param name="suppress-ns-declarations" as="xs:boolean"/>

		<!-- process content and recurse if depth is positive -->
		<xsl:choose>

			<xsl:when test="$depth gt 0">
				<xsl:apply-templates mode="verbatim">
					<xsl:with-param name="indent" select="$indent + 1"/>
					<xsl:with-param name="depth" select="$depth - 1"/>
					<xsl:with-param name="replace-entities" select="$replace-entities"/>
					<xsl:with-param name="suppress-ns-declarations"
						select="$suppress-ns-declarations"/>
				</xsl:apply-templates>

			</xsl:when>

			<!-- replace children with ellipsis -->
			<xsl:otherwise>
				<xsl:text> … </xsl:text>
			</xsl:otherwise>

		</xsl:choose>


	</xsl:template>


	<xd:doc>
		<xd:desc><xd:p>Suppress process of the content of elements
		which have none.</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="*[not(node())]" mode="verbatim-content"/>


	<xd:doc>
		<xd:desc>Render an attribute name</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="render-verbatim-attribute-name">
		<span class="verbatim-attr-name"><xsl:next-match/></span>
	</xsl:template>
	

	<xd:doc>
		<xd:desc>Render an attribute value</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="render-verbatim-attribute-value">
		<span class="verbatim-attr-content">
			<xsl:next-match/>
		</span>		
	</xsl:template>
	
	<xd:doc>
		<xd:desc><xd:p>Process text. Potentially
		replaces entities and restricts the amount of output text. Newlines
		are replaced with breaks.</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="text()" mode="verbatim">

		<span class="verbatim-text">
			<xsl:next-match/>
		</span>

	</xsl:template>


	<xd:doc>
		<xd:desc><xd:p>Output the body of a comment wrapped in a span</xd:p></xd:desc>
	</xd:doc>
	
	<xsl:template match="comment()" mode="verbatim-comment-content">
		<span class="verbatim-comment">
			<xsl:next-match/>
		</span>		
	</xsl:template>

	<xd:doc>
		<xd:desc><xd:p>Output processing instructions body, wrapped in a span.</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim-pi-content">
			<span class="verbatim-pi-content">
				<xsl:next-match/>
			</span>
	</xsl:template>

	<xd:doc>
		<xd:desc><xd:p>Output processing instructions name, wrapped in a span.</xd:p></xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim-pi-name">
		<span class="verbatim-pi-name">
			<xsl:next-match/>
		</span>
	</xsl:template>
	


	<xd:doc>
		<xd:desc>
			<xd:p>Write out a break as appropriate for the output type - br node in this case.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template name="verbatim-break">
		<br/>		
	</xsl:template>
	
	
</xsl:stylesheet>
