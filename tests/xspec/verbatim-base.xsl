<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:__x="http://www.w3.org/1999/XSL/TransformAliasAlias"
                xmlns:pkg="http://expath.org/ns/pkg"
                xmlns:impl="urn:x-xspec:compile:xslt:impl"
                xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim"
                version="2.0">
   <xsl:import href="file:/Users/nicg/Projects/xmlverbatim/src/verbatim-base.xsl"/>
   <xsl:import href="file:/Applications/oxygen/frameworks/xspec/src/compiler/generate-tests-utils.xsl"/>
   <xsl:namespace-alias stylesheet-prefix="__x" result-prefix="xsl"/>
   <xsl:variable name="x:stylesheet-uri"
                 as="xs:string"
                 select="'file:/Users/nicg/Projects/xmlverbatim/src/verbatim-base.xsl'"/>
   <xsl:output name="x:report" method="xml" indent="yes"/>
   <xsl:template name="x:main">
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('xsl:product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:message>
      <xsl:result-document format="x:report">
         <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="file:/Applications/oxygen/frameworks/xspec/src/compiler/format-xspec-report.xsl"</xsl:processing-instruction>
         <x:report stylesheet="{$x:stylesheet-uri}" date="{current-dateTime()}">
            <xsl:call-template name="x:d5e2"/>
            <xsl:call-template name="x:d5e22"/>
            <xsl:call-template name="x:d5e35"/>
            <xsl:call-template name="x:d5e54"/>
         </x:report>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="x:d5e2">
      <xsl:message>Element names</xsl:message>
      <x:scenario>
         <x:label>Element names</x:label>
         <xsl:call-template name="x:d5e3"/>
         <xsl:call-template name="x:d5e9"/>
         <xsl:call-template name="x:d5e15"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e3">
      <xsl:message>..Element with no namespace</xsl:message>
      <x:scenario>
         <x:label>Element with no namespace</x:label>
         <x:context mode="verbatim:name" select="/">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:name">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e7">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e7">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>element name (foo)</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>foo</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>element name (foo)</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e9">
      <xsl:message>..Element with default namespace</xsl:message>
      <x:scenario>
         <x:label>Element with default namespace</x:label>
         <x:context mode="verbatim:name" select="/">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo xmlns="http://www.corbas.co.uk/ns/dummy"/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo xmlns="http://www.corbas.co.uk/ns/dummy"/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:name">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e13">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e13">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>element name without prefix (foo)</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>foo</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>element name without prefix (foo)</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e15">
      <xsl:message>..Element with non default namespace</xsl:message>
      <x:scenario>
         <x:label>Element with non default namespace</x:label>
         <x:context mode="verbatim:name" select="/*/*">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo xmlns="http://www.corbas.co.uk/ns/dummy"
                 xmlns:test="http://www.corbas.co.uk/ns/test">
               <test:bar/>
            </foo>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo xmlns="http://www.corbas.co.uk/ns/dummy"
                       xmlns:test="http://www.corbas.co.uk/ns/test">
                     <test:bar/>
                  </foo>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/*/*)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:name">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e20">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e20">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>element name with prefix (test:bar)</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>test:bar</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>element name with prefix (test:bar)</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e22">
      <xsl:message>Attributes</xsl:message>
      <x:scenario>
         <x:label>Attributes</x:label>
         <xsl:call-template name="x:d5e23"/>
         <xsl:call-template name="x:d5e29"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e23">
      <xsl:message>..simple attribute</xsl:message>
      <x:scenario>
         <x:label>simple attribute</x:label>
         <x:context mode="verbatim:node" select="/foo/@bar">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',      'http://www.w3.org/2001/XMLSchema',     'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',     'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',     'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo bar="1"/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo bar="1"/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/foo/@bar)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',      'http://www.w3.org/2001/XMLSchema',     'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',     'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',     'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:node">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e27">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e27">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>attribute name/value (bar="1")</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text> bar="1"</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>attribute name/value (bar="1")</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e29">
      <xsl:message>..namespaced attribute</xsl:message>
      <x:scenario>
         <x:label>namespaced attribute</x:label>
         <x:context mode="verbatim:node" select="/foo/@*:bar">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo xmlns:bar="http://www.corbas.co.uk/ns/test" bar:bar="sheep"/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo xmlns:bar="http://www.corbas.co.uk/ns/test" bar:bar="sheep"/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/foo/@*:bar)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:node">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e33">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e33">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>attribute name/value (bar="1")</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text> bar:bar="sheep"</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>attribute name/value (bar="1")</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e35">
      <xsl:message>Processing instructions</xsl:message>
      <x:scenario>
         <x:label>Processing instructions</x:label>
         <xsl:call-template name="x:d5e36"/>
         <xsl:call-template name="x:d5e42"/>
         <xsl:call-template name="x:d5e48"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e36">
      <xsl:message>..Full PI rendering</xsl:message>
      <x:scenario>
         <x:label>Full PI rendering</x:label>
         <x:context mode="verbatim:node" select="//processing-instruction()">
            <dummy>
               <xsl:processing-instruction name="testpi">x="y"</xsl:processing-instruction>
            </dummy>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <dummy>
                     <xsl:processing-instruction name="testpi">x="y"</xsl:processing-instruction>
                  </dummy>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context"
                          select="$impl:context-doc/(//processing-instruction())"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:node"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e40">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e40">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>escaped processing instruction (&lt;?testpi x="y"?&gt;)</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>&lt;?testpi x="y"?&gt;</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>escaped processing instruction (&lt;?testpi x="y"?&gt;)</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e42">
      <xsl:message>..Processing instruction name</xsl:message>
      <x:scenario>
         <x:label>Processing instruction name</x:label>
         <x:context mode="verbatim:name" select="//processing-instruction()">
            <dummy>
               <xsl:processing-instruction name="testpi">x="y"</xsl:processing-instruction>
            </dummy>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <dummy>
                     <xsl:processing-instruction name="testpi">x="y"</xsl:processing-instruction>
                  </dummy>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context"
                          select="$impl:context-doc/(//processing-instruction())"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:name"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e46">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e46">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>just the pi name (testip)</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>testpi</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>just the pi name (testip)</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e48">
      <xsl:message>..Processing instruction value</xsl:message>
      <x:scenario>
         <x:label>Processing instruction value</x:label>
         <x:context mode="verbatim:content" select="//processing-instruction()">
            <dummy>
               <xsl:processing-instruction name="testpi">x="y"</xsl:processing-instruction>
            </dummy>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <dummy>
                     <xsl:processing-instruction name="testpi">x="y"</xsl:processing-instruction>
                  </dummy>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context"
                          select="$impl:context-doc/(//processing-instruction())"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim:content"/>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e52">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e52">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>just the pi content (x="y")</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>x="y"</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>just the pi content (x="y")</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e54">
      <xsl:message>Simple inputs against the base verbatim conversion with default parameters.</xsl:message>
      <x:scenario>
         <x:label>Simple inputs against the base verbatim conversion with default parameters.</x:label>
         <xsl:call-template name="x:d5e55"/>
         <xsl:call-template name="x:d5e61"/>
         <xsl:call-template name="x:d5e67"/>
         <xsl:call-template name="x:d5e73"/>
         <xsl:call-template name="x:d5e79"/>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e55">
      <xsl:message>..Empty element with no namespace</xsl:message>
      <x:scenario>
         <x:label>Empty element with no namespace</x:label>
         <x:context mode="verbatim" select="/">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e59">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e59">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Escaped foo</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>&lt;foo/&gt;</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Escaped foo</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e61">
      <xsl:message>..Empty element with default namespace</xsl:message>
      <x:scenario>
         <x:label>Empty element with default namespace</x:label>
         <x:context mode="verbatim" select="/">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo xmlns="http://www.corbas.co.uk/ns/dummy"/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo xmlns="http://www.corbas.co.uk/ns/dummy"/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e65">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e65">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Escaped foo</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>&lt;foo xmlns="http://www.corbas.co.uk/ns/dummy"/&gt;</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Escaped foo</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e67">
      <xsl:message>..Empty element with no namespace and one attribute</xsl:message>
      <x:scenario>
         <x:label>Empty element with no namespace and one attribute</x:label>
         <x:context mode="verbatim" select="/">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo bar="1"/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo bar="1"/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e71">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e71">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Escaped foo</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>&lt;foo bar="1"/&gt;</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Escaped foo</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e73">
      <xsl:message>..Empty element with default namespace and one attribute</xsl:message>
      <x:scenario>
         <x:label>Empty element with default namespace and one attribute</x:label>
         <x:context mode="verbatim" select="/">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo xmlns="http://www.corbas.co.uk/ns/dummy" bar="1"/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo xmlns="http://www.corbas.co.uk/ns/dummy" bar="1"/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e77">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e77">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Escaped foo</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>&lt;foo xmlns="http://www.corbas.co.uk/ns/dummy" bar="1"/&gt;</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Escaped foo</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
   <xsl:template name="x:d5e79">
      <xsl:message>..Empty element with default namespace and multiples attributes</xsl:message>
      <x:scenario>
         <x:label>Empty element with default namespace and multiples attributes</x:label>
         <x:context mode="verbatim" select="/">
            <x:param name="suppressed-namespaces"
                     as="xs:anyURI*"
                     select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <foo xmlns="http://www.corbas.co.uk/ns/dummy" bar="1" baz="2"/>
         </x:context>
         <xsl:variable name="x:result" as="item()*">
            <xsl:variable name="impl:context-doc" as="document-node()">
               <xsl:document>
                  <foo xmlns="http://www.corbas.co.uk/ns/dummy" bar="1" baz="2"/>
               </xsl:document>
            </xsl:variable>
            <xsl:variable name="impl:context" select="$impl:context-doc/(/)"/>
            <xsl:variable name="suppressed-namespaces"
                          select="for $u in ('http://www.w3.org/1999/XSL/Transform',       'http://www.w3.org/2001/XMLSchema',      'http://www.jenitennison.com/xslt/unit-test', 'http://www.jenitennison.com/xslt/xspec',      'http://expath.org/ns/pkg', 'urn:x-xspec:compile:xslt:impl',      'http://www.corbas.co.uk/ns/verbatim') return xs:anyURI($u)"/>
            <xsl:apply-templates select="$impl:context" mode="verbatim">
               <xsl:with-param name="suppressed-namespaces"
                               select="$suppressed-namespaces"
                               as="xs:anyURI*"/>
            </xsl:apply-templates>
         </xsl:variable>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$x:result"/>
            <xsl:with-param name="wrapper-name" select="'x:result'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
         <xsl:call-template name="x:d5e83">
            <xsl:with-param name="x:result" select="$x:result"/>
         </xsl:call-template>
      </x:scenario>
   </xsl:template>
   <xsl:template name="x:d5e83">
      <xsl:param name="x:result" required="yes"/>
      <xsl:message>Escaped foo</xsl:message>
      <xsl:variable name="impl:expected-doc" as="document-node()">
         <xsl:document>
            <xsl:text>&lt;foo xmlns="http://www.corbas.co.uk/ns/dummy" bar="1" baz="2"/&gt;</xsl:text>
         </xsl:document>
      </xsl:variable>
      <xsl:variable name="impl:expected" select="$impl:expected-doc/node()"/>
      <xsl:variable name="impl:successful"
                    as="xs:boolean"
                    select="test:deep-equal($impl:expected, $x:result, 2)"/>
      <xsl:if test="not($impl:successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <x:test successful="{$impl:successful}">
         <x:label>Escaped foo</x:label>
         <xsl:call-template name="test:report-value">
            <xsl:with-param name="value" select="$impl:expected"/>
            <xsl:with-param name="wrapper-name" select="'x:expect'"/>
            <xsl:with-param name="wrapper-ns" select="'http://www.jenitennison.com/xslt/xspec'"/>
         </xsl:call-template>
      </x:test>
   </xsl:template>
</xsl:stylesheet>
