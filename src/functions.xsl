<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xs xd"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim"
	version="2.0">

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
		
		<xsl:variable name="words" select="tokenize($text, '\s+')" as="xs:string*"/>
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
				with entities. If the <xd:i>with-attrs</xd:i> parameter is set then the value is
				assumed to an attribute value and quotes are replaced as well. </xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:html-replace-entities">
		<xsl:param name="value"/>
		<xsl:param name="with-attrs"/>
		<xsl:variable name="tmp"
			select="
			replace(replace(replace($value, '&amp;', '&amp;amp;'),'&lt;', '&amp;lt;'),'&gt;', '&amp;gt;')"/>
		<xsl:value-of
			select="if ($with-attrs) then replace(replace($tmp, '&quot;', '&amp;quot;'), '&#xA;', '&amp;#xA;') else $tmp"
		/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Defaulted version of above which never replaces in attributes.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:html-replace-entities" as="xs:string">
		<xsl:param name="value"/>
		<xsl:sequence select="verbatim:html-replace-entities($value, false())"/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return the namespace prefix for a node if known and it has one.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:namespace-prefix" as="xs:string">
		
		<xsl:param name="node" as="item()"/>
		<xsl:param name="ns-source" as="element()"/>
		<xsl:variable name="uri" select="namespace-uri($node)" as="xs:anyURI"/>
		<xsl:variable name="prefixes" select="in-scope-prefixes($ns-source)" as="xs:string*"/>
		<xsl:variable name="prefixes"
			select="if (exists($uri) ) 
			then for $ns in $prefixes 
			return 
			(if (namespace-uri-for-prefix($ns, $ns-source) = $uri) then $ns else ())
			else ()"/>
		
		<xsl:sequence select="if (exists($prefixes)) then $prefixes[1] else ''"/>
		
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>As above but with the second parameter defaulted.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:namespace-prefix" as="xs:string">
		
		<xsl:param name="node" as="item()"/>
		<xsl:sequence select="verbatim:namespace-prefix($node, $node)"/>
		
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
	</xd:doc>
	<xsl:function name="verbatim:new-in-scope-namespaces" as="xs:anyURI*">
		
		<xsl:param name="node" as="element()"/>
		<xsl:variable name="parent-element" select="$node/parent::*"/>
		
		<!-- in scope namespace uris for this node -->
		<xsl:variable name="our-namespaces" select="verbatim:namespace-uris-for-node($node)"/>
		
		<!-- in scope namespace uris for the parent node -->
		<xsl:variable name="parent-namespaces"
			select="if ($parent-element) then verbatim:namespace-uris-for-node($parent-element) else ()"/>
		
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
	</xd:doc>
	<xsl:function name="verbatim:replicate" as="xs:string">
		<xsl:param name="input" as="xs:string"/>
		<xsl:param name="count" as="xs:integer"/>
		<xsl:value-of
			select="if ($count = 0) then '' else string-join((for $n in 1 to $count return $input), '')"
		/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>
			<xd:p>Create the indent string to be used at any particular point in the processing.
				Never creates an indent string longer than that defined by max-increment.</xd:p>
		</xd:desc>
	</xd:doc>
	
	<xsl:function name="verbatim:indent" as="xs:string">
		<xsl:param name="indent" as="xs:integer"/>
		<xsl:param name="indent-string" as="xs:string"/>
		<xsl:param name="indent-increment" as="xs:integer"/>
		<xsl:value-of select="verbatim:replicate($indent-string, $indent * $indent-increment)"/>
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return true if an element has any non whitespace only text children and false
				otherwise.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:meaningful-text-children" as="xs:boolean">
		<xsl:param name="node" as="element()"/>
		<xsl:value-of
			select="if ($node/text()) then some $x in $node/child::text() satisfies not(normalize-space($x) = '') else false()"
		/>
	</xsl:function>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Return true if an element has any text siblings that do not contain whitespace and
				false otherwise.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:meaningful-text-siblings" as="xs:boolean">
		<xsl:param name="node" as="node()"/>
		<xsl:value-of
			select="some $sib in ($node/preceding-sibling::text(), $node/following-sibling::text()) satisfies (normalize-space($sib) != '')"
		/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc>Return if and only if the are meaningful sibling nodes following the current node. That 
		means any PI, comment, or element or any non WS text node.</xd:desc>
	</xd:doc>
	<xsl:function name="verbatim:meaningful-following-siblings" as="xs:boolean">
		<xsl:param name="node" as="node()"/>
		<xsl:value-of
			select="some $sib in ($node/following-sibling::node()) satisfies not($sib[self::text()] and normalize-space($sib) = '')"/>
	</xsl:function>
	
	<xd:doc>
		<xd:desc/>
	</xd:doc>
</xsl:stylesheet>