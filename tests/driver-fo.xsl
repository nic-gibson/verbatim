<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:verbatim="http://www.corbas.co.uk/ns/verbatim"  version="2.0">
	
	<xsl:import href="../src/verbatim-fo.xsl"/>

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="/">
		
		<fo:root>
			
			<!-- Define the page master for the output document -->
			<fo:layout-master-set>				
				<fo:simple-page-master 
					margin-right="2cm" 
					margin-bottom="2cm" 
					margin-left="2cm" 
					margin-top="2cm" 
					page-width="210mm" 
					page-height="297mm" 
					master-name="a4">
					<fo:region-body/>
					<fo:region-after extent="1.5cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			
		
			<fo:page-sequence master-reference="a4">
				<fo:flow flow-name="xsl-region-body">
					<fo:block font-size="18pt" font-weight="bold" text-align="center">Verbatim: FO Output Demo</fo:block>
					<fo:block padding-top="1cm">
						<xsl:apply-templates select="." mode="verbatim">
							<xsl:with-param name="indent-elements" select="true()"/>
						</xsl:apply-templates>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	
	</xsl:template>


</xsl:stylesheet>