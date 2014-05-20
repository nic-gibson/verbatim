<?xml version="1.0" encoding="UTF-8"?>

<!--
    XML to XSL FO Verbatim Formatter with Syntax Highlighting
    
    Version 2.0
   	Contributors: Nic Gibson
   	Copyright 2013 Corbas Consulting Ltd
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
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs cfn">

	<xsl:output method="xhtml" omit-xml-declaration="yes" indent="no"/>

	<xsl:param name="indent-elements" select="false()"/>
	<xsl:param name="max-depth" select="10000"/>
	<xsl:param name="limit-text" select="true()"/>
	
	<xsl:param name="suppress-ns-declarations-default" select="false()"/>

	<xsl:variable name="tab" select="'&#x9;'"/>
	<xsl:variable name="tab-out" select="'&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;'"/>
	<xsl:variable name="nbsp" select="'&#xA0;'"/>
	<xsl:variable name="nl" select="'&#xA;'"/>
	<xsl:param name="indent-increment" select="'&#xA0;&#xA0;&#xA0;'"/>
	
	
	<!-- When we write out FO we don't have the CSS to handle this so it has to be here -->
	<xsl:attribute-set name="verbatim-default">
		<xsl:attribute name="color">#333333</xsl:attribute>
		<xsl:attribute name="font-family">monospace</xsl:attribute>
		<xsl:attribute name="font-size">90%</xsl:attribute>
		<xsl:attribute name="margin-bottom">1em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="verbatim-element-name">
		<xsl:attribute name="color">#990000</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-element-nsprefix">
		<xsl:attribute name="color">#666600</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="verbatim-element-name">
		<xsl:attribute name="color">#990000</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-attr-name">
		<xsl:attribute name="color">#660000</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-attr-content">
		<xsl:attribute name="color">#000099</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-ns-name">
		<xsl:attribute name="color">#666600</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-ns-uri">
		<xsl:attribute name="color">#330099</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-text">
		<xsl:attribute name="color">#000000</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-comment">
		<xsl:attribute name="color">#006600</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verbatim-pi-name">
		<xsl:attribute name="color">#006600</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="verbatim-pi-content">
		<xsl:attribute name="color">#006666</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<!-- element nodes -->
	<xsl:template match="*" mode="verbatim">

		<xsl:param name="indent" select="''"/>
		<xsl:param name="depth" select="$max-depth"/>
		<xsl:param name="suppress-ns-declarations" select="$suppress-ns-declarations-default"/>
		
		<fo:block>

		<xsl:apply-templates select="." mode="verbatim-start">
			<xsl:with-param name="suppress-ns-declarations" select="$suppress-ns-declarations"/>
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="." mode="verbatim-content">
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="." mode="verbatim-end">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>

		<xsl:if test="not(parent::*)">
			<fo:block/>
		</xsl:if>
			
		</fo:block>

	</xsl:template>


	<xsl:template match="*" mode="verbatim-start">
		<xsl:param name="indent" select="''"/>
		<xsl:param name="suppress-ns-declarations" select="$suppress-ns-declarations-default"/>

		<xsl:if test="$indent-elements">
			<xsl:value-of select="$indent"/>
		</xsl:if>

		<xsl:text>&lt;</xsl:text>
		<xsl:apply-templates select="." mode="verbatim-ns-prefix"/>
		<xsl:apply-templates select="." mode="verbatim-element-name"/>
		<xsl:if test="$suppress-ns-declarations = false()">
			<xsl:apply-templates select="." mode="verbatim-ns-declarations"/>
		</xsl:if>
		<xsl:apply-templates select="@*" mode="verbatim-attributes"/>

		<xsl:if test="node()">
			<xsl:text>&gt;</xsl:text>
		</xsl:if>

	</xsl:template>


	<xsl:template match="*[not(node())]" mode="verbatim-end">
		<xsl:text> /&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="*[node()]" mode="verbatim-end">

		<xsl:param name="indent" select="''"/>

		<xsl:if test="* and $indent-elements">
			<xsl:value-of select="$indent"/>
		</xsl:if>

		<xsl:text>&lt;/</xsl:text>
		<xsl:apply-templates select="." mode="verbatim-ns-prefix"/>
		<xsl:apply-templates select="." mode="verbatim-element-name"/>
		<xsl:text>&gt;</xsl:text>

	</xsl:template>

	<xsl:template match="*[not(cfn:namespace-prefix(.) = '')]" mode="verbatim-ns-prefix">
		<xsl:variable name="ns" select="cfn:namespace-prefix(.)"/>
		<fo:inline xsl:use-attribute-sets="verbatim-element-nsprefix">
			<xsl:value-of select="cfn:namespace-prefix(.)"/>
		</fo:inline>
		<xsl:text>:</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="verbatim-ns-prefix"/>

	<xsl:template match="*" mode="verbatim-element-name">
		<fo:inline xsl:use-attribute-sets="verbatim-element-name">
			<xsl:value-of select="local-name()"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*" mode="verbatim-ns-declarations">
		<xsl:variable name="node" select="."/>
		<xsl:variable name="namespace-prefixes" select="cfn:newly-declared-namespaces(.)" as="xs:string*"/>

			<xsl:for-each select="$namespace-prefixes">
				<xsl:variable name="uri" select="namespace-uri-for-prefix(., $node)"/>
				<fo:inline xsl:use-attribute-sets="verbatim-ns-name">
					<xsl:value-of
						select="concat(' xmlns', if (. = '') then '' else concat(':', .), '=&quot;', $uri, '&quot;')"
					/>
				</fo:inline>
			</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[node()]" mode="verbatim-content">

		<xsl:param name="depth"/>
		<xsl:param name="indent"/>

		<xsl:choose>

			<xsl:when test="$depth gt 0">
				<xsl:apply-templates mode="verbatim">
					<xsl:with-param name="indent" select="concat($indent, $indent-increment)"/>
					<xsl:with-param name="depth" select="$depth - 1"/>
				</xsl:apply-templates>

			</xsl:when>


			<xsl:otherwise>
				<xsl:text> … </xsl:text>
			</xsl:otherwise>

		</xsl:choose>


	</xsl:template>

	<xsl:template match="*[not(node())]" mode="verbatim-content"/>

	<xsl:template match="@*" mode="verbatim-attributes">
		<xsl:text> </xsl:text>
		<fo:inline xsl:use-attribute-sets="verbatim-attr-name">
			<xsl:value-of select="name()"/>
		</fo:inline>
		<xsl:text>=&quot;</xsl:text>
		<fo:inline xsl:use-attribute-sets="verbatim-attr-content">
			<xsl:value-of select="cfn:html-replace-entities(normalize-space(.), true())"/>
		</fo:inline>
		<xsl:text>&quot;</xsl:text>
	</xsl:template>

	<xsl:template match="@*" mode="verbatim-id-copy">
		<xsl:attribute name="id" select="."/>
	</xsl:template>

	<xsl:template match="text()" mode="verbatim">

		<fo:inline xsl:use-attribute-sets="verbatim-text">
			<xsl:call-template name="preformatted-output">
				<xsl:with-param name="text"
					select="if ($limit-text = true()) 
					then cfn:html-replace-entities(cfn:limit-text(.))
					else cfn:html-replace-entities(.)"
				/>
			</xsl:call-template>
		</fo:inline>

	</xsl:template>

	<xsl:template match="text()[contains(., $nl)]" mode="verbatim">
		<fo:inline xsl:use-attribute-sets="verbatim-text">
			<xsl:value-of select="cfn:html-replace-entities(cfn:limit-text(.))"/>
		</fo:inline>
	</xsl:template>

	<!-- comments -->
	<xsl:template match="comment()" mode="verbatim">
		
		<xsl:param name="indent" select="''"/>
		
		<xsl:if test="$indent-elements">
			<xsl:value-of select="$indent"/>
		</xsl:if>
		
		<xsl:text>&lt;!--</xsl:text>
		<fo:inline xsl:use-attribute-sets="verbatim-comment">
			<xsl:call-template name="preformatted-output">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>
		</fo:inline>
		<xsl:text>--&gt;</xsl:text>
		<xsl:if test="not(parent::*)">
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- processing instructions -->
	<xsl:template match="processing-instruction()" mode="verbatim">
		<xsl:text>&lt;?</xsl:text>
		<fo:inline xsl:use-attribute-sets="verbatim-pi-name">
			<xsl:value-of select="name()"/>
		</fo:inline>
		<xsl:if test=".!=''">
			<xsl:text> </xsl:text>
			<fo:inline xsl:use-attribute-sets="verbatim-pi-content">
				<xsl:value-of select="."/>
			</fo:inline>
		</xsl:if>
		<xsl:text>?&gt;</xsl:text>
		<xsl:if test="not(parent::*)">
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>


	<!-- =========================================================== -->
	<!--                    Procedures / Functions                   -->
	<!-- =========================================================== -->





	<!-- preformatted output: space as &nbsp;, tab as 8 &nbsp;
                             nl as <br> -->
	<xsl:template name="preformatted-output">
		<xsl:param name="text"/>
		<xsl:call-template name="output-nl">
			<xsl:with-param name="text" select="replace(replace($text, $tab, $tab-out), ' ', $nbsp)"
			/>
		</xsl:call-template>
	</xsl:template>

	<!-- output nl as <br> -->
	<xsl:template name="output-nl">
		<xsl:param name="text"/>
		<xsl:variable name="tokens" select="tokenize($text, '&#xA;')"/>
		<xsl:choose>
			<xsl:when test="count($tokens) = 1">
				<xsl:value-of select="$tokens"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$tokens">
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- restrict text where we have more than 50 words to first five,
   ellipsis and last five -->
	<xsl:function name="cfn:limit-text">
		<xsl:param name="text"/>
		<xsl:variable name="words" select="tokenize($text, '\s+')" as="xs:string*"/>
		<xsl:variable name="nwords" select="count($words)" as="xs:integer"/>
		<xsl:value-of
			select="if ($nwords lt 50) 
   			then $words else 
   			string-join((
   				for $n in 1 to 5 return $words[$n], 
   				' … ', 
   				for $n in $nwords - 5 to $nwords return $words[$n]), 
   				' ')"
		/>
	</xsl:function>

	<xsl:function name="cfn:html-replace-entities">
		<xsl:param name="value"/>
		<xsl:param name="with-attrs"/>
		<xsl:variable name="tmp"
			select="
			replace(replace(replace($value, '&amp;', '&amp;amp;'),'&lt;', '&amp;lt;'),'&gt;', '&amp;gt;')"/>
		<xsl:value-of
			select="if ($with-attrs) then replace(replace($tmp, '&quot;', '&amp;quot;'), '&#xA;', '&amp;#xA;') else $tmp"
		/>
	</xsl:function>

	<xsl:function name="cfn:html-replace-entities">
		<xsl:param name="value"/>
		<xsl:value-of select="cfn:html-replace-entities($value, false())"/>
	</xsl:function>

	<doc:documentation xmlns:doc="http://www.corbas.co.uk/ns/documentation"
		xmlns="http://www.w3.org/1999">
		<p>Return the namespace prefix for a node if known.</p>
	</doc:documentation>
	<xsl:function name="cfn:namespace-prefix" as="xs:string">

		<xsl:param name="node" as="element()"/>
		<xsl:variable name="uri" select="namespace-uri($node)"/>
		<xsl:variable name="prefixes" select="in-scope-prefixes($node)"/>
		<xsl:variable name="prefix"
			select="for $ns in $prefixes return if (namespace-uri-for-prefix($ns, $node) = $uri) then ($ns) else ()"/>
		<xsl:value-of select="$prefix"/>

	</xsl:function>

	<doc:documentation xmlns:doc="http://www.corbas.co.uk/ns/documentation"
		xmlns="http://www.w3.org/1999/xhtml">
		<p>Return a sequence of namespace prefixes which were not declared on the parent
			element.Gets the in scope namespace URIs for the parameter element and the
		parent element. Builds a list of those namespaces that are not in the parent
		scope. Then filters the current prefix list based on that result to find the new prefixes only</p>
	</doc:documentation>
	<xsl:function name="cfn:newly-declared-namespaces" as="xs:string*">
		<xsl:param name="node" as="element()"/>

		<!-- in scope namespace uris for this node -->
		<xsl:variable name="our-namespaces" select="for $ns in in-scope-prefixes($node) return namespace-uri-for-prefix($ns, $node)"/>

		<!-- in scope namespace uris for the parent node -->
		<xsl:variable name="parent-namespaces"
			select="if ($node/parent::*) then for $ns in in-scope-prefixes($node/parent::*) return namespace-uri-for-prefix($ns, $node/parent::*) else ()"/>

		<!-- the URIs that have just become in scope -->
		<xsl:variable name="new-namespace-uris" select="$our-namespaces[not(. = $parent-namespaces)]"/>
		
		<!-- Filter the in scope prefixes based on whether their URIs are represented in the new list -->
		<xsl:variable name="new-namespaces" select="for $prefix in in-scope-prefixes($node) return if (namespace-uri-for-prefix($prefix, $node) = $new-namespace-uris) then $prefix else ()"/>

<!--    Debug output
		<xsl:message>Our Namespaces (<xsl:value-of select="string-join($our-namespaces, ', ')"/>)</xsl:message>
		<xsl:message>Parent Namespaces (<xsl:value-of select="string-join($parent-namespaces, ', ')"/>)</xsl:message>		
		<xsl:message>New Namespaces (<xsl:value-of select="string-join($new-namespace-uris, ', ')"/>)</xsl:message>
-->
		
		<!-- Return the sequence or prefixes, having stripped out the xml namespace -->
		<xsl:sequence select="$new-namespaces[not(. = 'xml')]"/>		
		
	</xsl:function>


	<doc:documentation xmlns:doc="http://www.corbas.co.uk/ns/documentation"
		xmlns="http://www.w3.org/1999">
		<p>Return true() if a node is in the default namespace. Checks by ensuring that the element
			is in a namespace and then checking if the namespace prefix is blank.</p>
	</doc:documentation>
	<xsl:function name="cfn:in-default-ns" as="xs:boolean">
		<xsl:param name="node" as="element()"/>
		<xsl:variable name="prefix" select="cfn:namespace-prefix($node)"/>
		<xsl:value-of select="if (namespace-uri($node) and $prefix = '') then true() else false()"/>
	</xsl:function>

</xsl:stylesheet>
