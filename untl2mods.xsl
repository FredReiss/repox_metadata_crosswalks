<?xml version="1.0" encoding="UTF-8"?>	
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
	xmlns:untl="http://digital2.library.unt.edu/untl/"
    xmlns:sru_dc="info:srw/schema/1/dc-schema" 
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.loc.gov/mods/v3" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="sru_dc oai_dc dc" 
    version="2.0">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <!-- ws 2.1 -->
    <xsl:include href="http://localhost/xsl/dcmiType.xsl"/>
    <xsl:include href="http://localhost/xsl/mimeType.xsl"/>
    <xsl:include href="http://localhost/xsl/csdgm.xsl"/>
    <xsl:include href="http://localhost/xsl/forms.xsl"/>
    <xsl:include href="http://localhost/xsl/iso3166-1.xsl"/>
    <xsl:include href="http://localhost/xsl/iso639-2.xsl"/>
    <!-- Do you have a Handle server?  If so, specify the base URI below including the trailing slash a la: http://hdl.loc.gov/ -->
    <xsl:variable name="handleServer">
		<xsl:text>http://hdl.loc.gov/</xsl:text>
    </xsl:variable>
    <xsl:template match="*[not(node())]" priority="2"/> <!-- strip empty DC elements that are output by tools like ContentDM -->
    <xsl:template match="/">
            <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="untl:metadata">
        <mods version="3.5" xmlns="http://www.loc.gov/mods/v3" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
			<xsl:call-template name="untlMain"/>
        </mods>
    </xsl:template>
    <xsl:template name="untlMain">
        <xsl:apply-templates select="untl:title"/>
        <xsl:apply-templates select="untl:creator"/>
        <xsl:apply-templates select="untl:contributor"/>
        <xsl:apply-templates select="untl:date"/>
        <xsl:apply-templates select="untl:language"/>
        <xsl:apply-templates select="untl:description"/>
        <xsl:apply-templates select="untl:subject | untl:coverage"/>
        <xsl:apply-templates select="untl:source"/>
		<xsl:apply-templates select="untl:collection"/>
		<xsl:apply-templates select="untl:institution"/>
        <xsl:apply-templates select="untl:rights"/>
		<xsl:apply-templates select="untl:resourceType"/>
        <xsl:apply-templates select="untl:format"/>
        <xsl:apply-templates select="untl:identifier"/>
        <!-- <xsl:apply-templates select="dc:relation | dc:source"/> -->


		<xsl:apply-templates select="untl:note"/>
        <xsl:apply-templates select="untl:meta"/>
    </xsl:template>
    <xsl:template match="untl:title">

      <xsl:choose>
	    <xsl:when test="@qualifier = 'seriestitle' or @qualifier = 'serialtitle'">
		   <relatedItem type="series">
		      <titleInfo><title><xsl:apply-templates/></title></titleInfo>
		   </relatedItem>
		</xsl:when>
		<xsl:otherwise>
          <titleInfo>
			<xsl:choose>
				<xsl:when test="@qualifier != 'officialtitle'">
					<xsl:attribute name="type">alternative</xsl:attribute>
				</xsl:when>
			</xsl:choose>
            <title>
                <xsl:apply-templates/>
            </title>
          </titleInfo>
		</xsl:otherwise>
	  </xsl:choose>
		
    </xsl:template>
    <xsl:template match="untl:creator">
        <name>
            <namePart>
			    <xsl:for-each select="untl:name">
				   <xsl:value-of select="."/>
				   <xsl:text> </xsl:text>
			    </xsl:for-each>
            </namePart>
            <role>
                <roleTerm type="text">
				    <xsl:choose>
				        <xsl:when test="@qualifier = 'pht'">
					       <xsl:text>photographer</xsl:text>
				        </xsl:when>
						<xsl:otherwise>
						   <xsl:text>creator</xsl:text>
						</xsl:otherwise>
			        </xsl:choose>
                </roleTerm>
            </role>
            <!--<displayForm>
                <xsl:value-of select="."/>
            </displayForm>-->
        </name>
    </xsl:template>
    <xsl:template match="untl:subject">
	   <xsl:if test="@qualifier != 'OPUBCO'">
          <subject>
            <topic>
                <xsl:apply-templates/>
            </topic>
          </subject>
	   </xsl:if>
    </xsl:template>
    <xsl:template match="untl:description">
        <!--<abstract>
            <xsl:apply-templates/>
            </abstract>-->
       <xsl:choose>
	      <xsl:when test="@qualifier = 'physical'">
		     <physicalDescription>
		        <note>
		           <xsl:apply-templates/>
                </note>
		     </physicalDescription>
		  </xsl:when>
		  <xsl:otherwise>
		     <note type="content">
                <xsl:apply-templates/>
             </note>
		  </xsl:otherwise>
       </xsl:choose>
        <!--<tableOfContents>
            <xsl:apply-templates/>
            </tableOfContents>-->
    </xsl:template>
    <xsl:template match="untl:source">
        <originInfo>
            <publisher>
                <xsl:apply-templates/>
            </publisher>
        </originInfo>
    </xsl:template>
	<xsl:template match="untl:collection">
		   <relatedItem type="host">
		   <xsl:if test="string(text()) = 'OKPCP'">
		      <titleInfo><title>Oklahoma Publishing Company Photography Collection</title></titleInfo>
		      <location><url>http://gateway.okhistory.org/explore/collections/OKPCP/</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'OHSPC'">
		      <titleInfo><title>Oklahoma Historical Society Photography Collection</title></titleInfo>
		      <location><url>http://gateway.okhistory.org/explore/collections/OHSPC/</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'OKHSM'">
		      <titleInfo><title>Oklahoma Historical Society Monographs</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:OKHSM</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'CFIM'">
		      <titleInfo><title>Clarkson Fire Insurance Maps</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:CFIM</url></location>
		   </xsl:if>
		    <xsl:if test="string(text()) = 'MHPC'">
		      <titleInfo><title>Z.P. Meyers/Barney Hillerman Photographic Collection</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:MHPC</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'ALBERT'">
		      <titleInfo><title>Albertype Collection</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:ALBERT</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'WMPRCL'">
		      <titleInfo><title>William Parker Campbell Collection</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:WMPRCL</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'WEPC'">
		      <titleInfo><title>William Edison Photograph Collection</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:WEPC</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'TBFRGH'">
		      <titleInfo><title>T.B. Ferguson Home Collection</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:TBFRGH</url></location>
		   </xsl:if>
		   <xsl:if test="string(text()) = 'MELTON'">
		      <titleInfo><title>Melton Collection</title></titleInfo>
		      <location><url>https://gateway.okhistory.org/search/?fq=untl_collection:MELTON</url></location>
		   </xsl:if>
		   </relatedItem>
    </xsl:template>
	<xsl:template match="untl:institution">
	    <xsl:if test="string(text()) = 'OKHS'">
		    <note type="ownership">
			   Oklahoma Historical Society
			</note>
		</xsl:if>
	</xsl:template>
    <xsl:template match="untl:contributor">
        <name>
            <namePart>
			    <xsl:for-each select="untl:name">
				   <xsl:value-of select="."/>
				   <xsl:text> </xsl:text>
			    </xsl:for-each>
            </namePart>
            <role>
                <roleTerm type="text">
                <xsl:text>Contributor</xsl:text>
                </roleTerm>
            </role>
        </name>
    </xsl:template>
    <xsl:template match="untl:date">
        <originInfo>
            <!--<dateIssued>
                <xsl:apply-templates/>
                </dateIssued>-->
			<xsl:choose>
			   <xsl:when test="@qualifier = 'creation'">
			       <dateCreated>
                      <xsl:apply-templates/>
                   </dateCreated>
			   </xsl:when>
			   <xsl:otherwise>
                  <dateOther>
                     <xsl:apply-templates/>
                  </dateOther>
			   </xsl:otherwise>
			</xsl:choose>
        </originInfo>
    </xsl:template>
    <xsl:template match="untl:format">
        <physicalDescription>
            <xsl:choose>
                <xsl:when test="contains(text(), '/')">
                    <xsl:variable name="mime" select="substring-before(text(), '/')"/>
                    <xsl:choose>
                        <xsl:when test="contains($mimeTypeDirectories, $mime)">
                        <internetMediaType>
                            <xsl:apply-templates/>
                        </internetMediaType>
                        </xsl:when>
                        <xsl:otherwise>
                            <note>
                                <xsl:apply-templates/>
                            </note>
                        </xsl:otherwise>
                    </xsl:choose>                    
                </xsl:when>
                <!-- 2.0: added regex to test for numeric data at the begining of the element -->
                <xsl:when test="matches(.,'^\d')">
                    <extent>
                        <xsl:apply-templates/>
                    </extent>
                </xsl:when>
                <xsl:when test="contains($forms, text())">
                    <form>
                        <xsl:apply-templates/>
                    </form>
                </xsl:when>
                <xsl:otherwise>
                    <note>
                        <xsl:apply-templates/>
                    </note>
                </xsl:otherwise>
            </xsl:choose>
        </physicalDescription>
    </xsl:template>
    <xsl:template match="untl:language">
        <xsl:if test="string-length(text()) = 3 and contains($iso639-2, text())">
			<language>
                <languageTerm type="code" authority="iso639-2b">
                    <xsl:apply-templates/>
                </languageTerm>
			</language>
        </xsl:if>
    </xsl:template>
    <!-- <xsl:template match="dc:relation">
        <relatedItem>
			<xsl:choose>
				<xsl:when test="starts-with(text(), 'http://')">
					<location>
						<url>
							<xsl:value-of select="."/>
						</url>
					</location>
				    <identifier type="uri">
						<xsl:apply-templates/>
				    </identifier>
				</xsl:when>
				<xsl:otherwise>
					<titleInfo>
						<title>
							<xsl:apply-templates/>
						</title>
					</titleInfo>
				</xsl:otherwise>
			</xsl:choose>            
        </relatedItem>
    </xsl:template> -->
	
	<xsl:template match="untl:coverage">
	    <xsl:if test="@qualifier = 'placeName' or @qualifier = 'historicPlaceName'">
		    <subject>
                <geographic>
                    <xsl:apply-templates/>
                </geographic>
            </subject>
		</xsl:if>
		<xsl:if test="@qualifier='placePoint'">
		  <xsl:variable name="coord1" select="replace(lower-case(text()), 'north=', '')"/>
		  <xsl:variable name="coord2" select="replace($coord1, '; east=', ', ')"/>
		  <xsl:variable name="coord3" select="replace($coord2, ';', '')"/>
		    <subject>
                <cartographics>
                    <coordinates>
                        <xsl:value-of select="$coord3"/>
                    </coordinates>
                </cartographics>
            </subject>
		</xsl:if>
		<xsl:if test="@qualifier='date'">
		    <subject>
                <temporal>
                    <xsl:apply-templates/>
                </temporal>
            </subject>
		</xsl:if>
	</xsl:template>
	
    <xsl:template match="untl:rights">
        <accessCondition type="local rights statement">
            <xsl:apply-templates/>
        </accessCondition>
    </xsl:template>
	
    <xsl:template match="untl:note">
        <note>
            <xsl:apply-templates/>
        </note>
    </xsl:template>
	
	<xsl:template match="untl:meta">
	    <xsl:if test="@qualifier='metadataCreationDate'">
        <recordInfo>
		   <recordCreationDate>
            <xsl:apply-templates/>
		   </recordCreationDate>
        </recordInfo>
		</xsl:if>
    </xsl:template>
    <xsl:template match="untl:resourceType">
        <!--2.0: Variable test for any dc:type with value of collection for mods:typeOfResource -->
        <xsl:variable name="collection">
            <xsl:if test="../untl:resourceType[string(text()) = 'collection' or string(text()) = 'Collection']">true</xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains(text(), 'Collection') or contains(text(), 'collection')">
                <genre authority="dct">
                    <xsl:text>collection</xsl:text>
                </genre>
            </xsl:when>
            <xsl:otherwise>
                <!-- based on DCMI Type Vocabulary as of 2012-08-09 at http://dublincore.org/documents/dcmi-type-vocabulary/ ...  see also the included dcmiType.xsl serving as variable $types -->
                <xsl:choose>
                    <xsl:when test="string(text()) = 'Dataset' or string(text()) = 'dataset'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>	
                            <!-- 2.0: changed software to software, multimedia re: mappings 2012-08-09 -->
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <!-- 2.0: chanded dataset to database, re: mappings 2012-08-09 -->
                            <xsl:text>database</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Event' or string(text()) = 'event'">
                        <genre authority="dct">
                            <xsl:text>event</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Image' or string(text()) = 'image' or string(text()) = 'image_photo'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>still image</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>image</xsl:text>
                        </genre>
                    </xsl:when>
					<xsl:when test="string(text()) = 'image_map' or string(text()) = 'map'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>cartographic</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>map</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'InteractiveResource' or string(text()) = 'interactiveresource' or string(text()) = 'Interactive Resource' or string(text()) = 'interactive resource' or string(text()) = 'interactiveResource'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>interactive resource</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'MovingImage' or string(text()) = 'movingimage' or string(text()) = 'Moving Image' or string(text()) = 'moving image' or string(text()) = 'movingImage'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>moving image</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>moving image</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'PhysicalObject' or string(text()) = 'physicalobject' or string(text()) = 'Physical Object' or string(text()) = 'physical object' or string(text()) = 'physicalObject'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>three dimensional object</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>physical object</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Service' or string(text()) = 'service'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <!-- WS: chanded service to online system or service, re: mappings 2012-08-09 -->
                            <xsl:text>online system or service</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Software' or string(text()) = 'software'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>software, multimedia</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>software</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Sound' or string(text()) = 'sound'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>sound recording</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>sound</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'StillImage' or string(text()) = 'stillimage' or string(text()) = 'Still Image' or string(text()) = 'still image' or string(text()) = 'stillImage'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>still image</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>still image</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:when test="string(text()) = 'Text' or string(text()) = 'text'">
                        <typeOfResource>
                            <xsl:if test="$collection='true'">
                                <xsl:attribute name="collection">
                                    <xsl:text>yes</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:text>text</xsl:text>
                        </typeOfResource>
                        <genre authority="dct">
                            <xsl:text>text</xsl:text>
                        </genre>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(string($types) = text())">
                            <!--<typeOfResource>
                                <xsl:text>mixed material</xsl:text>
                                </typeOfResource>-->
                            <genre>
                                <xsl:value-of select="lower-case(.)"/>
                            </genre>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="untl:identifier">  
      <xsl:choose>
		<xsl:when test="starts-with(text(), 'http') and @qualifier = 'itemURL'">
            <location>
                <url usage="primary display" access="object in context">
                    <xsl:value-of select="."/>
                </url>
            </location>
        </xsl:when> 
		<xsl:when test="starts-with(text(), 'http') and @qualifier = 'thumbnailURL'">
            <location>
                <url access="preview">
                    <xsl:value-of select="."/>
                </url>
            </location>
        </xsl:when> 
	    <xsl:otherwise>
          <xsl:variable name="iso-3166Check">
            <xsl:value-of select="substring(text(), 1, 2)"/>
          </xsl:variable>
          <identifier>
            <xsl:attribute name="type">
                <xsl:choose>
                    <!-- handled by location/url -->
                    <xsl:when test="starts-with(text(), 'http') and not(contains(text(), $handleServer)) and not(contains(text(), 'thumbnail')) and not(contains(substring-after(text(), 'http://'), 'hdl'))">
                        <xsl:text>uri</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(),'urn:hdl') or starts-with(text(),'hdl') or starts-with(text(),'http://hdl.')">
                        <xsl:text>hdl</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'doi')">
                        <xsl:text>doi</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'ark')">
                        <xsl:text>ark</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(text(), 'purl')">
                        <xsl:text>purl</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'tag')">
                        <xsl:text>tag</xsl:text>
                    </xsl:when>
                    <!--NOTE:  will need to update for ISBN 13 as of January 1, 2007, see XSL tool at http://isbntools.com/ -->
                    <xsl:when test="(starts-with(text(), 'ISBN')  or starts-with(text(), 'isbn'))  or ((string-length(text()) = 13) and contains(text(), '-') and (starts-with(text(), '0') or starts-with(text(), '1'))) or ((string-length(text()) = 10) and (starts-with(text(), '0') or starts-with(text(), '1')))">
                        <xsl:text>isbn</xsl:text>
                    </xsl:when>
                    <xsl:when test="(starts-with(text(), 'ISRC') or starts-with(text(), 'isrc')) or ((string-length(text()) = 12) and (contains($iso3166-1, $iso-3166Check))) or ((string-length(text()) = 15) and (contains(text(), '-') or contains(text(), '/')) and contains($iso3166-1, $iso-3166Check))">
                        <xsl:text>isrc</xsl:text>
                    </xsl:when>
                    <xsl:when test="(starts-with(text(), 'ISMN') or starts-with(text(), 'ismn')) or starts-with(text(), 'M') and ((string-length(text()) = 11) and contains(text(), '-') or string-length(text()) = 9)">
                        <xsl:text>ismn</xsl:text>
                    </xsl:when>
                    <xsl:when test="(starts-with(text(), 'ISSN') or starts-with(text(), 'issn')) or ((string-length(text()) = 9) and contains(text(), '-') or string-length(text()) = 8)">
                        <xsl:text>issn</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'ISTC') or starts-with(text(), 'istc')">
                        <xsl:text>istc</xsl:text>
                    </xsl:when>
                    <xsl:when test="(starts-with(text(), 'UPC') or starts-with(text(), 'upc')) or (string-length(text()) = 12 and not(contains(text(), ' ')) and not(contains($iso3166-1, $iso-3166Check)))">
                        <xsl:text>upc</xsl:text>
                    </xsl:when>
                    <xsl:when test="(starts-with(text(), 'SICI') or starts-with(text(), 'sici')) or ((starts-with(text(), '0') or starts-with(text(), '1')) and (contains(text(), ';') and contains(text(), '(') and contains(text(), ')') and contains(text(), '&lt;') and contains(text(), '&gt;')))">
                        <xsl:text>sici</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(text(), 'LCCN') or starts-with(text(), 'lccn')">
                        <!-- probably can't do this quickly or easily without regexes and XSL 2.0 -->
                        <xsl:text>lccn</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>local</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
          		<xsl:when test="starts-with(text(),'urn:hdl') or starts-with(text(),'hdl') or starts-with(text(),$handleServer)">
          			<xsl:value-of select="concat('hdl:',substring-after(text(),$handleServer))"/>
          		</xsl:when>
          		<xsl:otherwise>
          			<xsl:apply-templates/>
          		</xsl:otherwise>
            </xsl:choose>
        </identifier>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
