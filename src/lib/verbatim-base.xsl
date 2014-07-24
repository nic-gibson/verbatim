<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:pkg="http://expath.org/ns/pkg"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xd verbatim xs pkg">
	
	<xsl:import href="functions.xsl"/>
	
	<pkg:import-uri>http://www.corbas.co.uk/xmlverbatim/base</pkg:import-uri>

	<xd:doc scope="stylesheet">
		<xd:desc>

			<xd:b>
				<xd:b>XML Verbatim Formatter Base</xd:b>
			</xd:b>

			<xd:p>
				<xd:i>Version 2.0</xd:i>
			</xd:p>
			<xd:p>Contributors: Nic Gibson</xd:p>
			<xd:p>Copyright 2014 Corbas Consulting Ltd</xd:p>
			<xd:p>Contact: corbas@corbas.co.uk</xd:p>

			<xd:p>Modified to use as the base for escaped content output to more than just xhtml.
				This base styleheet renders to a simple escaped string. verbatim-xhtml.xsl extends
				this to xhtml and verbatim-fo.xsl extends it to xsl-fo. Even more heavily
				parameterised and templated than the previous version.</xd:p>

			<xd:p>
				<xd:i>Version 1.0</xd:i>
			</xd:p>
			<xd:p>Contributors: Nic Gibson</xd:p>
			<xd:p>Copyright 2013 Corbas Consulting Ltd</xd:p>
			<xd:p>Contact: corbas@corbas.co.uk</xd:p>

			<xd:p>XML to "escaped" html with configurability. Generates XHTML with styling and
				override options through modularity. </xd:p>

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

		<xd:param name="verbatim:indent-elements-default">
			<xd:p>If set to true and not overridden with a template parameter, this sets whether or
				not elements are indented by $indent-increment characters. Defaults to
					<xd:i>false()</xd:i></xd:p>
		</xd:param>

		<xd:param name="verbatim:max-depth-default">
			<xd:p>If the primary template is not called with <xd:b>max-depth</xd:b> parameter, then
				the value of max-depth-default is used. Defaults to <xd:i>10000</xd:i> (or, in
				effect, no limit).</xd:p>
		</xd:param>

		<xd:param name="verbatim:max-indent-default">
			<xd:p>Maximum level of indent before we indent no further. Sets the default value of the
					<xd:b>max-indent</xd:b> parameter. Defaults to <xd:i>20</xd:i></xd:p>
		</xd:param>

		<xd:param name="verbatim:limit-text-default">
			<xd:p>Sets the default value of the <xd:b>limit-text</xd:b> parameter. If this is set to
				true then the number of words output as element text will be determined by the
					<xd:b>max-words</xd:b> and <xd:b>keep-words</xd:b> parameters.</xd:p>
		</xd:param>

		<xd:param name="verbatim:suppress-ns-declarations-default">
			<xd:p>Sets the default value of the <xd:b>suppress-ns-declarations</xd:b> parameter.
				Defaults to <xd:i>false()</xd:i>.</xd:p>
		</xd:param>

		<xd:param name="verbatim:suppressed-namespaces-default">
			<xd:p>The default set of namespaces to suppress whether or not the
					<xd:b>suppress-ns-declarations</xd:b> parameter is set. Defaults to an empty
				sequence.</xd:p>
		</xd:param>

		<xd:param name="verbatim:replace-entities-default">
			<xd:p>The default value of the <xd:b>replace-entities</xd:b> parameter which controls
				whether or not the base XML entities are escaped in element content. Defaults to
					<xd:i>true()</xd:i>.</xd:p>
		</xd:param>

		<xd:param name="verbatim:indent-increment-default">
			<xd:p>The default value of the <xd:b>indent-increment</xd:b> parameter. This sets the
				number of indent characters (set via and <xd:b>indent-string</xd:b>
				<xd:b>indent-string-default</xd:b>) to increment by on each indent.</xd:p>
		</xd:param>

		<xd:param name="verbatim:ellipsis-string-default">
			<xd:p>The default value of the <xd:b>ellipsis-string</xd:b> parameter. This sets the
				string to be used when text is limited (see the <xd:b>limit-text</xd:b> parameter)
				and when the maximum depth has been exceeded.. Defaults to the ellipsis character
				(…).</xd:p>
		</xd:param>

		<xd:param name="verbatim:indent-string-default">
			<xd:p>The default value of the <xd:b>indent-string</xd:b> parameter. Used to build
				strings to indent elements. Defaults to a non-breaking space.</xd:p>
		</xd:param>

		<xd:param name="verbatim:tab-width-default">
			<xd:p>Sets the default value of the <xd:b>tab-width</xd:b> parameter, used for tab
				expansions. Defines the number of spaces that will be used to replace a tab
				character. Defaults to <xd:b>4</xd:b>.</xd:p>
		</xd:param>

		<xd:param name="verbatim:max-words-default">
			<xd:p>Sets the default value of the <xd:b>max-words</xd:b> paramter, used to define the
				maximum number of words to be output for any given text node. If this value is
				exceeded the text will be replaced by the first <xd:b>keep-words</xd:b> words
				followed by an ellipsis (defined by the <xd:b>ellipsis-string</xd:b> paramter)
				followed by the last <xd:d>keep-words</xd:d> words. Defaults to <xd:i>50</xd:i>
				words.</xd:p>
		</xd:param>

		<xd:param name="verbatim:keep-words-default">
			<xd:p>Sets the default number of words kept at each end of a text node when the
					<xd:b>limit-text</xd:b> and <xd:b>max-words</xd:b> parameters indicate that it
				should be truncated. Defaults to <xd:i>5</xd:i> words.</xd:p>
		</xd:param>

	</xd:doc>

	<xsl:param name="verbatim:indent-elements-default" select="false()" as="xs:boolean"/>
	<xsl:param name="verbatim:max-depth-default" select="10000" as="xs:integer"/>
	<xsl:param name="verbatim:limit-text-default" select="true()" as="xs:boolean"/>
	<xsl:param name="verbatim:max-words-default" select="50" as="xs:integer"/>
	<xsl:param name="verbatim:suppress-ns-declarations-default" select="false()" as="xs:boolean"/>
	<xsl:param name="verbatim:suppressed-namespaces-default" select="()" as="xs:anyURI*"/>
	<xsl:param name="verbatim:replace-entities-default" select="true()" as="xs:boolean"/>
	<xsl:param name="verbatim:indent-increment-default" select="3" as="xs:integer"/>
	<xsl:param name="verbatim:max-indent-default" select="20" as="xs:integer"/>
	<xsl:param name="verbatim:ellipsis-string-default" select="'…'" as="xs:string"/>
	<xsl:param name="verbatim:indent-string-default" select="'&#xA0;'" as="xs:string"/>
	<xsl:param name="verbatim:tab-width-default" select="4"/>
	<xsl:param name="verbatim:keep-words-default" select="5"/>



	<!-- horizontal tab character -->
	<xsl:variable name="tab" select="'&#x9;'" as="xs:string"/>

	<!--  used to find new lines -->
	<xsl:variable name="nl" select="'&#xA;'" as="xs:string"/>


	<!-- greater than -->
	<xsl:variable name="greater-than" select="'&gt;'"/>

	<!-- less than -->
	<xsl:variable name="less-than" select="'&lt;'"/>

	<!-- double quote -->
	<xsl:variable name="double-quote" select="'&quot;'"/>

	<xd:doc>
		<xd:desc>
			<xd:p>The verbatim processor entry point. In order to make this as flexible as possible
				each component (opening tag, content, close tag) is processed by applying templates
				to the same element in a different mode.</xd:p>
			<xd:p>All of the parameters have default values defined as stylesheet parameters in
				order to allow overriding at both the application and the node rendering points.
				Parameters are all tunneled through to lower level templates.</xd:p>
			<xd:p>Some tunneled parameters are calculated in this template and passed on:</xd:p>
			<xd:ul>
				<xd:li><xd:b>tab-out</xd:b> — the string that literal tabs are to replaced with.
					Generated from the <xd:b>tab-width</xd:b> and <xd:b>indent-string</xd:b>
					parameters.</xd:li>
				<xd:li><xd:b>verbatim-root</xd:b> — the top level node being processed by the
					verbatim processor.</xd:li>
			</xd:ul>
		</xd:desc>

		<xd:param name="max-indent">
			<xd:p> Set <xd:b>max-indent</xd:b> to limit the level to which the stylesheet will
				indent nested elements. Defaults to the value of the
					<xd:b>verbatim:max-indent-default</xd:b> stylesheet parameter.</xd:p>
		</xd:param>

		<xd:param name="max-depth">
			<xd:p>Set <xd:b>max-depth</xd:b> to override the depth to which this stylesheet will
				traverse the input document before replacing the child nodes of the current node
				with ellipses. Defaults to the value of the <xd:b>verbatim:max-depth-default</xd:b>
				stylsheet parameter.</xd:p>
		</xd:param>

		<xd:param name="replace-entities">
			<xd:p>Controls whether or not the base XML entities are escaped in element content or
				not. Defaults to the value of the <xd:b>verbatim:replace-entities-default</xd:b>
				stylesheet parameter.</xd:p>
		</xd:param>

		<xd:param name="indent-elements">
			<xd:p>Controls whether or not elements are indented as nesting increases. Defaults to
				the value of the <xd:b>verbatim:indent-elements-default</xd:b> stylesheet
				parameter.</xd:p>
		</xd:param>

		<xd:param name="suppress-ns-declarations">
			<xd:p>If set to true, <xd:b>suppress-ns-declarations</xd:b> causes all namespace
				declarations to be omitted from the output. If not set, the value of the
					<xd:b>verbatim:suppress-ns-declarations-default</xd:b> stylesheet parameter is
				used.</xd:p>
		</xd:param>

		<xd:param name="suppressed-namespaces">
			<xd:p>Set a sequence of URIs in the <xd:b>suppressed-namespaces</xd:b> parameter in
				order to always skip declarations for those namespaces. This allows sample code to
				be placed in a namespace and output without one. Defaults to the value of the
					<xd:b>verbatim:suppressed-namespaces-default</xd:b> stylesheet
				parameter.</xd:p>
		</xd:param>

		<xd:param name="limit-text">
			<xd:p>If set to true, the amount of text output as part of a text node will be limited
				to the number of words defined by the <xd:b>max-words</xd:b> parameter. All of the
				text after the limit will be replaced by the value of the
					<xd:b>ellipsis-string</xd:b> parameter. Defaults to the value of the
					<xd:b>verbatim:limit-text-default</xd:b> stylesheet parameter.</xd:p>
		</xd:param>

		<xd:param name="ellipsis-string">
			<xd:p>The character to be used to replace trailing text longer than the
					<xd:b>max-words</xd:b> parameter and when the maximum depth has been exceeded.
				Defaults to the value of the <xd:b>verbatim:ellipsis-string-default</xd:b>
				stylesheet parameter.</xd:p>
		</xd:param>

		<xd:param name="indent-string">
			<xd:p>The string to be used when building up indent strings. Defaults to the value of
				the the <xd:b>verbatim:indent-string-default</xd:b> stylesheet parameter.</xd:p>
		</xd:param>

		<xd:param name="tab-width">
			<xd:p>Sets value of the <xd:b>tab-width</xd:b> parameter, used for tab expansions.
				Defines the number of spaces that will be used to replace a tab character. Defaults
				to the value of the <xd:b>tab-width-default</xd:b> stylesheet parameter. Generates
				the <xd:b>verbatim:tab-out</xd:b> tunnel paramater available to all further
				templates.</xd:p>
		</xd:param>

		<xd:param name="max-words">
			<xd:p>Defines the maximum number of words to be output in any given text node before
				truncation occurs. If the <xd:b>limit-text</xd:b> parameter is set to false, this
				has no effect. Defaults to the value of the <xd:b>verbatim:max-words-default</xd:b>
				stylesheet parameter.</xd:p>
		</xd:param>

		<xd:param name="keep-words">
			<xd:p>Defines the number of words retained when text truncation occurs.
					<xd:b>keep-words</xd:b> words will be retained each side of the ellipsis when
				truncation occurs. Defaults to the value of the
					<xd:b>verbatim:keep-words-default</xd:b> stylesheet parameter.</xd:p>
		</xd:param>


	</xd:doc>
	<xsl:template match="@*|node()" mode="verbatim" as="item()*">

		<xsl:param name="max-indent" select="$verbatim:max-indent-default" as="xs:integer"/>
		<xsl:param name="max-depth" select="$verbatim:max-depth-default" as="xs:integer"
			tunnel="yes"/>
		<xsl:param name="replace-entities" select="$verbatim:replace-entities-default"
			as="xs:boolean"/>
		<xsl:param name="indent-elements" select="$verbatim:indent-elements-default" as="xs:boolean"/>
		<xsl:param name="suppress-ns-declarations"
			select="$verbatim:suppress-ns-declarations-default" as="xs:boolean"/>
		<xsl:param name="indent-increment" select="$verbatim:indent-increment-default"
			as="xs:integer"/>
		<xsl:param name="suppressed-namespaces" select="$verbatim:suppressed-namespaces-default"
			as="xs:anyURI*"/>
		<xsl:param name="limit-text" select="$verbatim:limit-text-default" as="xs:boolean"/>
		<xsl:param name="ellipsis-string" select="$verbatim:ellipsis-string-default" as="xs:string"/>
		<xsl:param name="indent-string" select="$verbatim:indent-string-default" as="xs:string"/>
		<xsl:param name="tab-width" select="$verbatim:tab-width-default" as="xs:integer"/>
		<xsl:param name="max-words" select="$verbatim:max-words-default" as="xs:integer"/>
		<xsl:param name="keep-words" select="$verbatim:keep-words-default" as="xs:integer"/>


		<xsl:apply-templates select="." mode="verbatim:initial-node">
			<xsl:with-param name="indent" select="0" tunnel="yes"/>
			<!-- start at zero -->
			<xsl:with-param name="depth" select="0" tunnel="yes"/>
			<!-- start at zero -->
			<xsl:with-param name="max-depth" select="$max-depth" tunnel="yes"/>
			<xsl:with-param name="max-indent" select="$max-indent" tunnel="yes"/>
			<xsl:with-param name="suppress-ns-declarations" select="$suppress-ns-declarations"
				tunnel="yes"/>
			<xsl:with-param name="suppressed-namespaces" select="$suppressed-namespaces"
				tunnel="yes"/>
			<xsl:with-param name="replace-entities" select="$replace-entities" tunnel="yes"/>
			<xsl:with-param name="indent-elements" select="$indent-elements" tunnel="yes"/>
			<xsl:with-param name="limit-text" select="$limit-text" tunnel="yes"/>
			<xsl:with-param name="ellipsis-string" select="$ellipsis-string" tunnel="yes"/>
			<xsl:with-param name="indent-string" select="$indent-string" tunnel="yes"/>
			<xsl:with-param name="max-words" select="$max-words" tunnel="yes"/>
			<xsl:with-param name="keep-words" select="$keep-words" tunnel="yes"/>
			<xsl:with-param name="indent-increment" select="$indent-increment" tunnel="yes"/>

			<xsl:with-param name="tab-out" select="verbatim:replicate-string($indent-string, $tab-width)"
				as="xs:string" tunnel="yes"/>
			<xsl:with-param name="verbatim-root" select="." as="item()" tunnel="yes"/>

		</xsl:apply-templates>

	</xsl:template>

	<xd:doc>
		<xd:desc>Process the initial node. This is an opportunity to wrap something around the
			entire output. The default implementation does nothing.</xd:desc>
	</xd:doc>
	<xsl:template match="node()" mode="verbatim:initial-node" as="item()*">
		<xsl:apply-templates select="." mode="verbatim:node"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>Base processing for all elements. Simply apply the start, content
		and end template modes to the current element. There is unlikely to be a
		reason to override this template.</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:node" as="item()*">

		<!-- output the start tag, namespaces and attributes -->
		<xsl:apply-templates select="." mode="verbatim:start"/>

		<!-- output the node content -->
		<xsl:apply-templates select="." mode="verbatim:content"/>

		<!-- output the closing tag-->
		<xsl:apply-templates select="." mode="verbatim:end"/>

	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>This template handles processing the start tag, namespaces and attributes for
				elements with child nodes with no meaningful (non whitespace) text nodes</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[node()][not(verbatim:meaningful-text-children(.))]" mode="verbatim:start"
		as="item()*">

		<!-- shared processing -->
		<xsl:next-match/>

		<!-- close the start tag -->
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="$greater-than"/>
		</xsl:call-template>

		<!-- line break -->
		<xsl:apply-templates select="." mode="verbatim:potential-start-break"/>

	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>This template handles processing the start tag, namespaces and attributes for
				elements with text children</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[verbatim:meaningful-text-children(.)]" mode="verbatim:start" as="item()*"
		priority="1">

		<!-- shared processing -->
		<xsl:next-match/>

		<!-- close the start tag -->
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="$greater-than"/>
		</xsl:call-template>

	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>This template handles processing the start tag, namespaces and attributes for
				elements without child nodes (and the base of the elements with child nodes)</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:start" as="item()*">

		<!-- generate the indent if required -->
		<xsl:apply-templates select="." mode="verbatim:potential-indent"/>

		<!-- start tag -->
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="$less-than"/>
		</xsl:call-template>


		<!-- element name -->
		<xsl:apply-templates select="." mode="verbatim:name"/>

		<!-- any new namespace declarations unless suppressed -->
		<xsl:apply-templates select="." mode="verbatim:ns-declarations"/>

		<!-- attributes -->
		<xsl:apply-templates select="@*" mode="verbatim:node"/>

	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>Output the close for an element with no children.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(node())]" mode="verbatim:end">
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="concat('/', $greater-than)"/>
		</xsl:call-template>
		<xsl:apply-templates select="." mode="verbatim:potential-end-break"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output the closing tag for elements which have content.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[node()]" mode="verbatim:end">

		<!-- indent if required -->
		<xsl:apply-templates select="." mode="verbatim:potential-indent"/>

		<!-- output closing tag with prefix if required -->
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="concat($less-than, '/')"/>
		</xsl:call-template>

		<xsl:apply-templates select="." mode="verbatim:name"/>

		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="$greater-than"/>
		</xsl:call-template>

		<xsl:apply-templates select="." mode="verbatim:potential-end-break"/>

	</xsl:template>




	<xd:doc>
		<xd:desc>Output an element or attribute name by calling the prefix template and the local
			name template.</xd:desc>
	</xd:doc>
	<xsl:template match="@*|*" mode="verbatim:name">
		<xsl:apply-templates select="." mode="verbatim:ns-prefix"/>
		<xsl:apply-templates select="." mode="verbatim:local-name"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output the namespace prefix for an element that has one.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(local-name() = name())]" mode="verbatim:ns-prefix">
		<xsl:value-of select="verbatim:namespace-prefix(.)"/>
		<xsl:text>:</xsl:text>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output the namespace prefix for an attribute that has one.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="@*[not(local-name() = name())]" mode="verbatim:ns-prefix">
		<xsl:value-of select="verbatim:namespace-prefix(.)"/>
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="':'"/>
		</xsl:call-template>
	</xsl:template>



	<xd:doc>
		<xd:desc>
			<xd:p>Suppress processing of namespace prefix for elements or attributes in the default
				(or no) namespace.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="node()|@*" mode="verbatim:ns-prefix"/>


	<xd:doc>
		<xd:desc>
			<xd:p>Output the element or attribute name itself</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="@*|node()" mode="verbatim:local-name">
		<xsl:value-of select="local-name()"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Output the namespace declarations required for an element. This will be any
				namespaces which just came into scope.</xd:p>
			<xd:p>Tunnels the <xd:b>suppressed-namespaces</xd:b> and 
				<xd:b>suppress-ns-declarations</xd:b> parameters.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:ns-declarations">

		<xsl:param name="suppressed-namespaces" as="xs:anyURI*" tunnel="yes"/>
		<xsl:param name="suppress-ns-declarations" as="xs:boolean" tunnel="yes"/>
		<xsl:variable name="node" select="."/>

		<xsl:if test="$suppress-ns-declarations = false()">

			<!-- get all prefixes which were declared on this node, removing suppressed ones -->
			<xsl:variable name="namespace-prefixes" select="verbatim:newly-declared-prefixes(.)"
				as="xs:string*"/>

			<!-- loop over them -->
			<xsl:for-each select="$namespace-prefixes">

				<!-- get the namespace uri -->
				<xsl:variable name="uri" select="namespace-uri-for-prefix(., $node)"/>

				<!-- output if not in our suppressed list -->
				<xsl:if test="not($uri = $suppressed-namespaces)">
					<xsl:apply-templates select="$node" mode="verbatim:render-ns-declaration">
						<xsl:with-param name="prefix" select="." tunnel="yes"/>
					</xsl:apply-templates>
				</xsl:if>

			</xsl:for-each>

		</xsl:if>

	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Renders an individual namespace declaration.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:render-ns-declaration">
		<xsl:param name="prefix" as="xs:string" tunnel="yes"/>
		<xsl:variable name="uri" select="namespace-uri-for-prefix($prefix, .)" as="xs:anyURI"/>

		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="if ($prefix) then ' xmlns:' else ' xmlns'"/>
		</xsl:call-template>
		<xsl:call-template name="verbatim:render-ns-prefix">
			<xsl:with-param name="prefix" select="$prefix"/>
		</xsl:call-template>
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="'=&quot;'"/>
		</xsl:call-template>
		<xsl:call-template name="verbatim:render-ns-name">
			<xsl:with-param name="name" select="$uri"/>
		</xsl:call-template>
		<xsl:call-template name="verbatim:decorate">
			<xsl:with-param name="text" select="'&quot;'"/>
		</xsl:call-template>

	</xsl:template>

	<xd:doc>
		<xd:desc>Render a namespace declaration's prefix</xd:desc>
	</xd:doc>
	<xsl:template name="verbatim:render-ns-prefix">
		<xsl:param name="prefix" as="xs:string"/>
		<xsl:value-of select="$prefix"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>Render a namespace declaration's name</xd:desc>
	</xd:doc>
	<xsl:template name="verbatim:render-ns-name">
		<xsl:param name="name" as="xs:anyURI"/>
		<xsl:value-of select="$name"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>Generate a namespace declaration for those elements where the parent is in a
			namespace but the current node isn't</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(namespace-uri())][namespace-uri(parent::*)]"
		mode="verbatim:ns-declarations">
		<xsl:text> xmlns=""</xsl:text>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Process the content of elements. If depth has been exceeded, this template will
				replace the content of the current element with ellipsis. This template processes
				elements with children.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[node()]" mode="verbatim:content">

		<xsl:param name="depth" as="xs:integer" tunnel="yes"/>
		<xsl:param name="max-depth" as="xs:integer" tunnel="yes"/>
		<xsl:param name="indent" as="xs:integer" tunnel="yes"/>
		<xsl:param name="max-indent" as="xs:integer" tunnel="yes"/>
		<xsl:param name="ellipsis-string" as="xs:string" tunnel="yes"/>

		<!-- process content and recurse if depth is positive -->
		<xsl:choose>

			<xsl:when test="$depth lt $max-depth">
				<xsl:apply-templates mode="verbatim:node">
					<xsl:with-param name="indent"
						select="if ($indent lt $max-indent) then $indent + 1 else $indent"
						tunnel="yes"/>
					<xsl:with-param name="depth" select="$depth + 1" tunnel="yes"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- replace children with ellipsis -->
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$ellipsis-string"/>
				<xsl:text> </xsl:text>
			</xsl:otherwise>

		</xsl:choose>


	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>Suppress processing of the content of elements which have none.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(node())]" mode="verbatim:content"/>


	<xd:doc>
		<xd:desc>
			<xd:p>Process attributes. Each attribute is output with a space before it. </xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="verbatim:node">

		<!-- space -->
		<xsl:text> </xsl:text>

		<!-- attribute name -->
		<xsl:apply-templates select="." mode="verbatim:name"/>


		<!-- equals and start of value -->
		<xsl:text>=&quot;</xsl:text>

		<!-- value with entities escaped -->
		<xsl:apply-templates select="." mode="verbatim:content"/>

		<!-- end quote -->
		<xsl:text>&quot;</xsl:text>

	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>Render the value of an attribute</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="@*" mode="verbatim:content">
		<xsl:value-of select="verbatim:html-replace-entities(normalize-space(.), true())"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Process text. Potentially replaces entities and restricts the amount of output
				text. Newlines are replaced with breaks.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="text()" mode="verbatim:node">

		<xsl:param name="replace-entities" as="xs:boolean" tunnel="yes"/>
		<xsl:param name="limit-text" as="xs:boolean" tunnel="yes"/>
		<xsl:param name="max-words" as="xs:integer" tunnel="yes"/>
		<xsl:param name="keep-words" as="xs:integer" tunnel="yes"/>
		<xsl:param name="ellipsis-string" as="xs:string" tunnel="yes"/>

		<xsl:call-template name="preformatted-output">
			<xsl:with-param name="text"
				select="if ($replace-entities = true()) 
						then 
							if ($limit-text = true()) 
								then verbatim:html-replace-entities(verbatim:limit-text(., $max-words, $keep-words, $ellipsis-string))
								else verbatim:html-replace-entities(.)
						else
							if ($limit-text = true()) 
								then verbatim:limit-text(., $max-words, $keep-words, $ellipsis-string)
								else .
						"
			/>
		</xsl:call-template>

	</xsl:template>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Process comments. NOTE: this will always place a newline before the comment.
				Sometimes this may not give optimal output but it's hard to see how to resolve it.
				The problem occurs when the comment is separated from the node before by spaces or
				tabs not a newline.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="comment()" mode="verbatim:node">

		<!-- indent if required -->
		<xsl:apply-templates select="." mode="verbatim:potential-indent"/>

		<!-- output the comment -->
		<xsl:text>&lt;!--</xsl:text>
		<xsl:apply-templates select="." mode="verbatim:content"/>
		<xsl:text>--&gt;</xsl:text>

		<xsl:apply-templates select="." mode="verbatim:potential-break"/>

	</xsl:template>


	<xd:doc>
		<xd:desc>Output the content of a comment</xd:desc>
	</xd:doc>

	<xsl:template match="comment()" mode="verbatim:content">
		<xsl:call-template name="preformatted-output">
			<xsl:with-param name="text" select="."/>
		</xsl:call-template>
	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>Output processing instructions.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim:node">
		<xsl:param name="verbatim-root" as="item()" tunnel="yes"/>

		<xsl:apply-templates select="." mode="verbatim:potential-indent"/>

		<xsl:text>&lt;?</xsl:text>
		<xsl:apply-templates select="." mode="verbatim:name"/>
		<xsl:if test=".!=''">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="." mode="verbatim:content"/>
		</xsl:if>
		<xsl:text>?&gt;</xsl:text>

		<xsl:apply-templates select="." mode="verbatim:potential-break"/>

	</xsl:template>

	<xd:doc>
		<xd:desc>Output the name of a processing instruction</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim:name">
		<xsl:value-of select="name()"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>Output the content of a processing instruction</xd:desc>
	</xd:doc>
	<xsl:template match="processing-instruction()" mode="verbatim:content">
		<xsl:value-of select="."/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>This template replaces all tabs with the tab indent (defined as $tab-width indent
				characters). </xd:p>
		</xd:desc>
	</xd:doc>
	<!-- preformatted output: space as &nbsp;, tab as 8 &nbsp;
                             nl as <br> -->
	<xsl:template name="preformatted-output">
		<xsl:param name="text" as="xs:string"/>
		<xsl:param name="tab-out" as="xs:string" tunnel="yes"/>
		<xsl:call-template name="output-nl">
			<xsl:with-param name="text" select="replace($text, $tab, $tab-out)"/>
		</xsl:call-template>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>This template replaces all occurrences of newline in the input text with a break
				element. This is implemented as template rather than a function as it generaters
				output.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template name="output-nl">
		<xsl:param name="text"/>
		<xsl:variable name="tokens" select="tokenize($text, '&#xA;')"/>

		<xsl:choose>
			<xsl:when test="count($tokens) = 1">
				<xsl:value-of select="$tokens"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$tokens">
					<!-- if the first token is empty then we had a line
						break at the start of the string and we want
						to ignore that -->
					<xsl:if test="not(. = '')">
						<xsl:call-template name="verbatim:break"/>
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xd:doc>
		<xd:desc>End breaks happen unless we have text siblings and
			aren't last.</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:potential-end-break">
		<xsl:apply-templates select="." mode="verbatim:break"/>
	</xsl:template>
		
		
		
	<xd:doc>
		<xd:desc>Suppress the end break if the element has text siblings
		and has *any* following siblings (unless following sibling is an 
		empty text node)</xd:desc>
	</xd:doc>
	<xsl:template match="*[verbatim:meaningful-text-siblings(.)][verbatim:meaningful-following-siblings(.)]" 
		mode="verbatim:potential-end-break"/>
	
	
	<xd:doc>
		<xd:desc>Start and end breaks  are normally suppressed.</xd:desc>
	</xd:doc>
	<xsl:template match="*" mode="verbatim:potential-start-break"/>

	<xd:doc>
		<xd:desc>An element with no text children or siblings has breaks before
			and after.</xd:desc>
	</xd:doc>
	<xsl:template match="*[not(verbatim:meaningful-text-children(.))]
		[not(verbatim:meaningful-text-children(.))]" priority="1" 
		mode="verbatim:potential-end-break verbatim:potential-start-break">
		
		<xsl:apply-templates select="." mode="verbatim:break"/>
		
	</xsl:template>
	
	<xd:doc>
		<xd:desc></xd:desc>
	</xd:doc>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Write out a break as appropriate for the output type.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="node()" mode="verbatim:break" name="verbatim:break" as="xs:string">
		<xsl:text>&#10;</xsl:text>
	</xsl:template>


	<xd:doc>
		<xd:desc>Do not generate indents or breaks for text() nodes</xd:desc>
	</xd:doc>
	<xsl:template match="text()" mode="verbatim:potential-break verbatim:potential-indent"/>

	<xd:doc>
		<xd:desc>Processing instructions and comments have preceding indents if and only if they
			have no meaningful text siblings.</xd:desc>
	</xd:doc>
	<xsl:template
		match="comment()[not(verbatim:meaningful-text-siblings(.))]|
		processing-instruction()[not(verbatim:meaningful-text-siblings(.))]"
		mode="verbatim:potential-indent">
		<xsl:param name="indent-elements" as="xs:boolean" tunnel="yes" select="false()"/>
		<xsl:apply-templates select="." mode="verbatim:indent"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Write out an indent as appropriate for the output type.</xd:p>
			<xd:p>Uses the tunneled <xd:b>indent</xd:b>, <xd:b>indent-string</xd:b>,
			<xd:b>indent-increment</xd:b> and <xd:b>indent-elements</xd:b> parameters.</xd:p>
			<xd:p>No indent occurrs unless <xd:b>indent-elements</xd:b> is true</xd:p>
		</xd:desc>
	</xd:doc>

	<xsl:template match="node()" mode="verbatim:indent">
		<xsl:param name="indent" as="xs:integer" tunnel="yes"/>
		<xsl:param name="indent-string" as="xs:string" tunnel="yes"/>
		<xsl:param name="indent-increment" as="xs:integer" tunnel="yes"/>
		<xsl:param name="indent-elements" as="xs:boolean" tunnel="yes"/>
		<xsl:if test="$indent-elements">
			<xsl:value-of select="verbatim:indent($indent, $indent-string, $indent-increment)"/>
		</xsl:if>
	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>This is a placeholder template that allows the basic syntax (angle brackets,
				quotes, etc) to be overridden. All literal text is passed through this template
			which, by default, does nothing.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template name="verbatim:decorate">
		<xsl:param name="text" as="xs:string"/>
		<xsl:value-of select="$text"/>
	</xsl:template>





</xsl:stylesheet>
