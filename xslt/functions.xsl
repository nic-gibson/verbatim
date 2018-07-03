<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xs xd"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim"
	version="2.0">

	<!--
	* Copyright 2009-2018 Corbas Consulting Ltd
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
	
	<xd:doc>
		<xd:desc>
			<xd:p>Restrict text where we have more than $max-words words to first $keep-words,
				ellipsis and last $keep-words. Note that if $max-words is less than or equal to
				double $keep-words we keep all the words. If $keep-words is less than or equal to
				zero, we treat it as one.</xd:p>
		</xd:desc>
		<xd:param name="text">The text to be potentially limited</xd:param>
		<xd:param name="max-words">The maximum number of words allowed</xd:param>
		<xd:param name="keep-words">The number of words to be retained either side of the ellipsis.
			Not that if double <xd:i>$keep-words</xd:i> is double or mare than
			<xd:i>$max-words</xd:i> then the whole string is returned.</xd:param>
		<xd:param name="ellipsis-string">The string to be used for ellipsis.</xd:param>
		<xd:return>A string of words, either the same as <xd:i>$text</xd:i> or
			shortened.</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:limit-text" as="xs:string">
		<xsl:param name="text" as="item()"/>
		<xsl:param name="max-words" as="xs:integer"/>
		<xsl:param name="keep-words" as="xs:integer"/>
		<xsl:param name="ellipsis-string" as="xs:string"/>
		
		<xsl:variable name="keep" as="xs:integer"
			select="if ($keep-words le 0) then 1 else $keep-words"/>
		
		<xsl:variable name="words" select="if (normalize-space($text) = '') then () else tokenize($text, '\s+')" as="xs:string*"/>
		<xsl:variable name="nwords" select="count($words)" as="xs:integer"/>
		
		<xsl:value-of
			select="if (($nwords lt $max-words) or ($keep * 2 ge $max-words)) 
			then xs:string($text) else 
			string-join((
			subsequence($words, 1, $keep),
			$ellipsis-string,
			subsequence($words, $nwords - $keep + 1, $keep)
			), 
			' ')"
		/>
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>This function replaces all occurrences of ampersand, less than and greater than,
				with escaped entities. If the <xd:i>with-attrs</xd:i> parameter is set then the value is
				assumed to be an attribute value and quotes are replaced as well. </xd:p>
		</xd:desc>
		<xd:param name="value">The text to be escaped</xd:param>
		<xd:param name="is-attribute">Set to true if <xd:b>value</xd:b> is an attribute value</xd:param>
		<xd:return>A string with all entities escaped to appear as if they were the literal entity</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:html-replace-entities" as="xs:string">
		<xsl:param name="value" as="item()"/>	<!-- treat as text but could be a node -->
		<xsl:param name="is-attribute" as="xs:boolean"/> 
		<xsl:variable name="tmp"
			select="
			replace(replace(replace($value, '&amp;', '&amp;amp;'),'&lt;', '&amp;lt;'),'&gt;', '&amp;gt;')"/>
		<xsl:value-of
			select="if ($is-attribute) then replace(replace($tmp, '&quot;', '&amp;quot;'), '&#xA;', '&amp;#xA;') else $tmp"
		/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>This function replaces all occurrences of ampersand, less than and greater than,
				with escaped entities. It is identical to the two parameter version but never 
			treats the parameter as an attribute value.</xd:p>
		</xd:desc>
		<xd:param name="value">The text to be escaped</xd:param>
		<xd:return>A string with all entities escaped to appear as if they were the literal entity</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:html-replace-entities" as="xs:string">
		<xsl:param name="value" as="item()"/>
		<xsl:sequence select="verbatim:html-replace-entities($value, false())"/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return the namespace prefix for a node if known and it has one.</xd:p>
		</xd:desc>
		<xd:param name="node">The node for which the namespace prefix is to be found.</xd:param>
		<xd:return>The namespace prefix for the node or the empty string if there isn't one.</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:namespace-prefix" as="xs:string">
		
		<xsl:param name="node" as="item()"/>
		<xsl:value-of select="substring-before($node/name(), ':')"/>
		
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return a sequence of namespace prefixes which were not declared on the parent
				element.Gets the in scope namespace URIs for the parameter element and the parent
				element. Builds a list of those namespaces that are not in the parent scope. Then
				filters the current prefix list based on that result to find the new prefixes
				only</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:newly-declared-prefixes" as="xs:string*">
		<xsl:param name="node" as="element()"/>
		
		<xsl:variable name="new-namespace-uris" select="verbatim:new-in-scope-namespaces($node)"/>
		
		<!-- Filter the in scope prefixes based on whether their URIs are represented in the new list -->
		<xsl:variable name="new-prefixes"
			select="for $prefix in in-scope-prefixes($node) return if (namespace-uri-for-prefix($prefix, $node) = $new-namespace-uris) then $prefix else ()"/>
		
		<!-- Return the sequence or prefixes, having stripped out the xml namespace -->
		<xsl:sequence select="$new-prefixes[not(. = 'xml')]"/>
		
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return a sequence of namespace URIs that are in scope on the element passed as a
				parameter but not on its parent (if any). If the root element is provided then all
				the namespaces in scope at the root are returned.</xd:p>
		</xd:desc>
		<xd:param name="node">The element for which we want any newly in scope namespaces.</xd:param>
		<xd:return>A sequence of namespace URIs which came into scope on this element. In many
		cases this will be an empty sequence</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:new-in-scope-namespaces" as="xs:anyURI*">
		
		<xsl:param name="node" as="element()"/>
		<xsl:variable name="parent-element" select="$node/parent::*"/>
		
		<!-- in scope namespace uris for this node -->
		<xsl:variable name="our-namespaces" select="verbatim:namespace-uris-for-node($node)"/>
		
		<!-- in scope namespace uris for the parent node - don't evaluate if $our-namespaces is empty -->
		<xsl:variable name="parent-namespaces"
			select="if ($parent-element and count($our-namespaces)) 
				then verbatim:namespace-uris-for-node($parent-element) 
				else ()"/>
		
		<!-- the URIs that have just become in scope -->
		<xsl:sequence select="$our-namespaces[not(. = $parent-namespaces)]"/>
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return true() if a node is in the default namespace. Checks by ensuring that the
				element is in a namespace and then checking if the namespace prefix is blank.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:in-default-ns" as="xs:boolean">
		<xsl:param name="node" as="element()"/>
		<xsl:variable name="prefix" select="verbatim:namespace-prefix($node)"/>
		<xsl:value-of select="if (namespace-uri($node) and $prefix = '') then true() else false()"/>
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return the sequence of namespace URIs in scope for a given element</xd:p>
		</xd:desc>
		<xd:param name="node">The element for which we want the namespace URIs.</xd:param>
		<xd:return>A sequence of namespace URIs which are in scope on this element. In many
			cases this will be an empty sequence</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:namespace-uris-for-node" as="xs:anyURI*">
		<xsl:param name="node" as="element()"/>
		<xsl:sequence
			select="for $prefix in in-scope-prefixes($node) return namespace-uri-for-prefix($prefix, $node)"
		/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return a string replicated a given number of times.</xd:p>
		</xd:desc>
		<xd:param name="input">The string to be replicated</xd:param>
		<xd:param name="count">The number of replications required. If zero or less, an
			empty string will be returned.</xd:param>
		<xd:return>A string consisting of the value of <xd:b>input</xd:b> replicated
		<xd:b>count</xd:b> times.</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:replicate-string" as="xs:string*">
		<xsl:param name="input" as="xs:string"/>
		<xsl:param name="count" as="xs:integer"/>
		<xsl:value-of select="string-join(verbatim:replicate($input, $count), '')"/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return a item replicated a given number of times as a sequence.</xd:p>
		</xd:desc>
		<xd:param name="input">The item to be replicated</xd:param>
		<xd:param name="count">The number of replications required. If zero or less, an
		empty sequence will be returned.</xd:param>
		<xd:return>A sequence of items consisting of the value <xd:b>input</xd:b> replicated
		<xd:b>count</xd:b> times.</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:replicate" as="item()*">
		<xsl:param name="input" as="item()"/>
		<xsl:param name="count" as="xs:integer"/>
		<xsl:sequence select="if ($count gt 0) then 
			for $n in 1 to $count return $input
			else ()"/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Create the indent string to be used at any particular point in the processing.
				The calling templates limit the maximum indent level.</xd:p>
		</xd:desc>
		<xd:param name="indent">The indent level. This is multiplied by the indent increment
		to get the number of characters required.</xd:param>
		<xd:param name="indent-string">The character to be used for indents. This is set as 
			a stylesheet parameter (see <xd:b>verbatim:indent-string-default</xd:b>) and
		passed by the calling templates.</xd:param>
		<xd:param name="indent-increment">The number of copies of <xd:b>indent-string</xd:b>
		to be replicated at each indent level. </xd:param>
	</xd:doc>
	
	<xsl:function name="verbatim:indent" as="xs:string">
		<xsl:param name="indent" as="xs:integer"/>
		<xsl:param name="indent-string" as="xs:string"/>
		<xsl:param name="indent-increment" as="xs:integer"/>
		<xsl:value-of select="verbatim:replicate-string($indent-string, $indent * $indent-increment)"/>
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return true if an element has any non whitespace only text children and false
				otherwise. The concept of meaningful text children is used to determine whether
			or not indents and breaks should be inserted in the output. Each child text node
			is examined. If there are none or all of them are whitespace one, the function returns false. 
			If any child text node is not just whitespace (defined by checking if the normalised
			value is empty) then the function returns true. </xd:p>
		</xd:desc>
		<xd:param name="node">The node to be tested.</xd:param>
		<xd:result><xd:b>true()</xd:b> if the node has meaningful text children and <xd:b>false()</xd:b> otherwise.</xd:result>
	</xd:doc>
	<xsl:function name="verbatim:meaningful-text-children" as="xs:boolean">
		<xsl:param name="node" as="element()"/>
		
		<xsl:variable name="text-nodes" select="$node/text()"/>
		
		<xsl:variable name="text" select="replace(string-join($text-nodes, ''), '[\p{Z}\s]','')"/>
		
		<xsl:sequence select="not($text = '')"/>
	
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return true if an element has any non whitespace only text siblings and false
				otherwise. The concept of meaningful text siblings is used to determine whether
				or not indents and breaks should be inserted in the output. Each sibling text node
				is examined. If there are none or all of them are whitespace one, the function returns false. 
				If any sibling text node is not just whitespace (defined by checking if the normalised
				value is empty) then the function returns true. </xd:p>
		</xd:desc>
		<xd:param name="node">The node to be tested.</xd:param>
		<xd:return><xd:b>true()</xd:b> if the node has meaningful text siblings and <xd:b>false()</xd:b> otherwise.</xd:return>		
	</xd:doc>
	<xsl:function name="verbatim:meaningful-text-siblings" as="xs:boolean">
		<xsl:param name="node" as="node()"/>
		
		<xsl:variable name="preceding-text-nodes" select="$node/preceding-sibling::text()"/>
		<xsl:variable name="following-text-nodes" select="$node/following-sibling::text()"/>
		
		<xsl:variable name="preceding-text" select="replace(string-join($preceding-text-nodes, ''), '[\p{Z}\s]','')"/>
		<xsl:variable name="following-text" select="replace(string-join($following-text-nodes, ''), '[\p{Z}\s]','')"/>
		
		<xsl:sequence select="not($preceding-text = '' and $following-text = '')"/>
		
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return true if an element has any non whitespace only following text siblings and false
				otherwise. The concept of meaningful text siblings is used to determine whether
				or not indents and breaks should be inserted in the output. Each following sibling text node
				is examined. If there are none or all of them are whitespace one, the function returns false. 
				If any sibling text node is not just whitespace (defined by checking if the normalised
				value is empty) then the function returns true. </xd:p>
		</xd:desc>
		<xd:param name="node">The node to be tested.</xd:param>
		<xd:return><xd:b>true()</xd:b> if the node has meaningful following text siblings and <xd:b>false()</xd:b> otherwise.</xd:return>		
	</xd:doc>	<xsl:function name="verbatim:meaningful-following-siblings" as="xs:boolean">
		<xsl:param name="node" as="node()"/>
		<xsl:sequence select="not(normalize-space(string-join($node/following-sibling::text(), '')) = '')"/>
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Replace multiple whitespaces with a single space - like normalize but without removing leading
			and trailing space completely.</xd:p>
		</xd:desc>
		<xd:param name="text">The string to be modified</xd:param>
		<xd:return>The modified string</xd:return>
	</xd:doc>
	<xsl:function name="verbatim:normalize-space" as="xs:string">
		<xsl:param name="text" as="xs:string"/>
		<xsl:sequence select="replace($text, '\s+', ' ')"/>
	</xsl:function>
	
</xsl:stylesheet>