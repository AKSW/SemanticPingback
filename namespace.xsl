<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns:ver="http://www.ldodds.com/ns/ver/"
         xmlns:owl="http://www.w3.org/2002/07/owl#"
         xmlns:foaf="http://xmlns.com/foaf/0.1/"
         xmlns:dc="http://purl.org/dc/elements/1.1/">

<xsl:output method="html" indent="yes"/>
<xsl:strip-space elements="*"/>

    <xsl:template match='rdf:RDF'>
    <html>
        <head>
            <title><xsl:value-of select="owl:Ontology/rdfs:label"/></title>
            <link rel="stylesheet" href="namespace.css" type="text/css" />
        </head>

        <body>

        <xsl:apply-templates select="owl:Ontology"/>
        
        <hr />

        <div class="summary-box">
        <p>
            Classes:
            <xsl:for-each select="owl:Class">
                <xsl:sort select="@rdf:about"/>
                <xsl:apply-templates select="." mode="summary"/>
            </xsl:for-each>
        </p>

        <p>
            Properties:
            <xsl:for-each select="owl:ObjectProperty">
                <xsl:sort select="@rdf:about"/>
                <xsl:apply-templates select="." mode="summary"/>
            </xsl:for-each>
        </p>
        </div>

        <a name="class-detail"/>
        <h2 class="title">Classes</h2>
        <xsl:for-each select="owl:Class">
            <xsl:sort select="@rdf:about"/>
            <div class="detail-box">
            <xsl:apply-templates select="."/>
            </div>
        </xsl:for-each>

        <a name="class-detail"/>
        <h2 class="title">Properties</h2>
        <xsl:for-each select="owl:ObjectProperty">
            <xsl:sort select="@rdf:about"/>
            <div class="detail-box">
            <xsl:apply-templates select="."/>
            </div>
        </xsl:for-each>
        </body>
    </html>
    </xsl:template>


    <!-- OWL stuff -->
    <xsl:template match="owl:Ontology">
        <h1><xsl:value-of select="rdfs:label"/></h1>
        <h2><xsl:value-of select="dc:date"/></h2>

        <dt>Authors:</dt>
        <dd>
        <xsl:for-each select="foaf:maker">
            <xsl:call-template name="anchor-rdf-resource">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="following-sibling::foaf:maker">,<br /></xsl:when>
            </xsl:choose>
        </xsl:for-each>
        </dd>

        <p><xsl:value-of select="dc:description"/></p>
    </xsl:template>

    <xsl:template match="owl:Class" mode="summary">
        <xsl:variable name="anchor">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:variable>
            <a href="#{$anchor}">
                <xsl:choose>
                    <xsl:when test="rdfs:label">
                        <xsl:value-of select="rdfs:label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="substring-after-last">
                             <xsl:with-param name="input" select="@rdf:about" />
                             <xsl:with-param name="marker" select="'/'" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
            <xsl:choose>
                <xsl:when test="following-sibling::owl:Class">, </xsl:when>
            </xsl:choose>
    </xsl:template>

    <xsl:template match="owl:ObjectProperty" mode="summary">
        <xsl:variable name="anchor">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:variable>
            <a href="#{$anchor}">
                <xsl:choose>
                    <xsl:when test="rdfs:label">
                        <xsl:value-of select="rdfs:label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="substring-after-last">
                             <xsl:with-param name="input" select="@rdf:about" />
                             <xsl:with-param name="marker" select="'/'" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
            <xsl:choose>
                <xsl:when test="following-sibling::owl:ObjectProperty">, </xsl:when>
            </xsl:choose>
    </xsl:template>

    <xsl:template match="owl:Class">
        <h3>
            <a name="{generate-id(.)}"></a>
            <xsl:choose>
                <xsl:when test="rdfs:label">
                    <xsl:value-of select="rdfs:label"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="substring-after-last">
                         <xsl:with-param name="input" select="@rdf:about" />
                         <xsl:with-param name="marker" select="'/'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <code><xsl:value-of select="@rdf:about"/></code>
        
        <p>
        <xsl:choose>
        <xsl:when test="rdfs:subClassOf">
        <span class="bold">Subclass Of: </span>
            <xsl:for-each select="rdfs:subClassOf">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:subClassOf">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        <br />
        </xsl:when>
        </xsl:choose>
        
        <xsl:choose>
        <xsl:when test="rdfs:isDefinedBy">
        <span class="bold">Is defined by: </span>
            <xsl:for-each select="rdfs:isDefinedBy">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:isDefinedBy">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        <br />
        </xsl:when>
        </xsl:choose>
        <xsl:choose>
        <xsl:when test="rdfs:seeAlso">
        <span class="bold">See also: </span>
            <xsl:for-each select="rdfs:seeAlso">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:seeAlso">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:when>
        </xsl:choose>
        
        <xsl:choose>
        <xsl:when test="owl:disjointWith">
        <dl>
            <dt>Disjoint With:</dt>
            <dd>
            <xsl:for-each select="owl:disjointWith">
                <xsl:variable name="anchor-text">
                    <xsl:choose>
                        <xsl:when test="starts-with(@rdf:resource, /owl:Ontology/@rdf:about)">
                            <xsl:call-template name="substring-after-last">
                                 <xsl:with-param name="input" select="@rdf:resource" />
                                 <xsl:with-param name="marker" select="'/'" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@rdf:resource"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="anchor-href">
                    <xsl:choose>
                        <xsl:when test="starts-with(@rdf:resource, /owl:Ontology/@rdf:about)">
                            <xsl:variable name="res" select="@rdf:resource"/>
                            <xsl:value-of select="concat('#', generate-id(//rdfs:Class/@rdf:about[. = $res]/..) )"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@rdf:resource"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <a href="{$anchor-href}"><xsl:value-of select="$anchor-text"/></a>
                <xsl:choose>
                    <xsl:when test="following-sibling::owl:disjointWith">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            </dd>
        </dl>
        </xsl:when>
        </xsl:choose>
        
        </p>
        
        <p>
        <xsl:value-of select="rdfs:comment"/>
        </p>

    </xsl:template>

    <xsl:template match="owl:ObjectProperty">
    
        <h3>
            <a name="{generate-id(.)}"></a>
            <xsl:choose>
                <xsl:when test="rdfs:label">
                    <xsl:value-of select="rdfs:label"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="substring-after-last">
                         <xsl:with-param name="input" select="@rdf:about" />
                         <xsl:with-param name="marker" select="'/'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <code><xsl:value-of select="@rdf:about"/></code>
        
        <p>
        <xsl:choose>
        <xsl:when test="rdfs:subPropertyOf">
        <span class="bold">Subproperty Of: </span>
            <xsl:for-each select="rdfs:subPropertyOf">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:subPropertyOf">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        <br />
        </xsl:when>
        </xsl:choose>
        
        <xsl:choose>
        <xsl:when test="rdfs:domain">
        <span class="bold">Domain: </span>
            <xsl:for-each select="rdfs:domain">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:domain">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        <br />
        </xsl:when>
        </xsl:choose>
       
        <xsl:choose>
        <xsl:when test="rdfs:range">
        <span class="bold">Range: </span>
            <xsl:for-each select="rdfs:range">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:range">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        <br />
        </xsl:when>
        </xsl:choose>
        
        <xsl:choose>
        <xsl:when test="rdfs:isDefinedBy">
        <span class="bold">Is defined by: </span>
            <xsl:for-each select="rdfs:isDefinedBy">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:isDefinedBy">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        <br />
        </xsl:when>
        </xsl:choose>
        
        <xsl:choose>
        <xsl:when test="rdfs:seeAlso">
        <span class="bold">See also: </span>
            <xsl:for-each select="rdfs:seeAlso">
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="following-sibling::rdfs:seeAlso">, </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:when>
        </xsl:choose>
        
        </p>
        
        <p>
         <xsl:value-of select="rdfs:comment"/>
        </p>        
    </xsl:template>


    <!-- UTILITY TEMPLATES -->

    <!-- See: http://www.dpawson.co.uk/xsl/sect2/N7240.html#d7594e463 -->
    <xsl:template name="substring-after-last">
        <xsl:param name="input" />
        <xsl:param name="marker" />

        <xsl:choose>
          <xsl:when test="contains($input,$marker)">
            <xsl:call-template name="substring-after-last">
              <xsl:with-param name="input"
                  select="substring-after($input,$marker)" />
              <xsl:with-param name="marker" select="$marker" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
           <xsl:value-of select="$input" />
          </xsl:otherwise>
         </xsl:choose>

    </xsl:template>

    <xsl:template name="anchor-rdf-resources">
        <xsl:param name="nodes"/>
        <xsl:param name="div-class"/>

        <xsl:for-each select="$nodes">
            <div>
                <xsl:choose>
                    <xsl:when test="$div-class">
                        <xsl:attribute name="id"><xsl:value-of select="$div-class"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <xsl:call-template name="anchor-rdf-resource">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
            </div>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="anchor-rdf-resource">
        <xsl:param name="node"/>
        <xsl:param name="anchor-text"/>

        <xsl:variable name="text">
            <xsl:choose>
                <xsl:when test="$anchor-text">
                    <xsl:value-of select="$anchor-text"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="//foaf:Person[@rdf:about=$node/@rdf:resource]/foaf:name">
                            <xsl:value-of select="//foaf:Person[@rdf:about=$node/@rdf:resource]/foaf:name"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$node/@rdf:resource"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$node/@rdf:resource">
                <a href="{$node/@rdf:resource}"><xsl:value-of select="$text"/></a>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
