
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:p="http://www.evolus.vn/Namespace/Pencil" xmlns:html="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml"
    media-type="text/html"
    doctype-public="html"
    cdata-section-elements="script style"
    indent="yes"
    encoding="ISO-8859-1"/>
    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <title>
                    
                </title>
                <LINK rel="stylesheet" type="text/css" href="Resources/Style.css"><xsl:text> </xsl:text></LINK>
                <SCRIPT type="text/javascript" src="Resources/jquery.js"></SCRIPT>
                <SCRIPT type="text/javascript">
                	var title = '<xsl:value-of select="/p:Document/p:Properties/p:Property[@name='fileName']/text()"/>';
                	function showPage(id) {
                		$('div.Page:visible').addClass('hidden');
                		$(id).removeClass('hidden');
                	}
                	$(document).ready(function() {
                		var extension = title.indexOf('.ep');
                		extension = extension == -1 ? title.length : extension;
                		document.title = 'Wireframes for ' + title.substring(0, extension);
                		$('div.Page:hidden').first().removeClass('hidden');
                	});
                </SCRIPT>
            </head>
            <body>
                <div id="leftpanel">
                        <xsl:for-each select="/p:Document/p:Pages/p:Page">
                            <div class="ThumbContainer">
                                <a href="javascript:showPage('#{p:Properties/p:Property[@name='fid']/text()}_page')" title="Go to page '{p:Properties/p:Property[@name='name']/text()}'">
                                    <img src="{@rasterized}" />
                                    <hr/>
                                    <span class="number">
                                        <xsl:number value="position()" format="1"/>/<xsl:number value="last()" format="1"/>
                                    </span> -
                                    <xsl:value-of select="p:Properties/p:Property[@name='name']/text()"/>
                                </a>
                            </div>
                        </xsl:for-each>
                </div>
                <div id="main">
                        <xsl:apply-templates select="/p:Document/p:Pages/p:Page" />
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="p:Page">
        <div class="Page hidden" id="{p:Properties/p:Property[@name='fid']/text()}_page">
            <div class="pageTitle">
                <xsl:value-of select="p:Properties/p:Property[@name='name']/text()"/>
                <div class="MainNumber">
                    Page <xsl:number value="position()" format="1"/>/<xsl:number value="last()" format="1"/>
                </div>
            </div>
            <div class="ImageContainer">
                <img class="raster" style="max-width:{p:Properties/p:Property[@name='width']/text()}px" src="{@rasterized}" usemap="#map_{p:Properties/p:Property[@name='fid']/text()}"/>
            </div>
            <xsl:if test="p:Note">
                <p class="Notes">
                    <xsl:apply-templates select="p:Note/node()" mode="processing-notes"/>
                </p>
            </xsl:if>
            <map name="map_{p:Properties/p:Property[@name='fid']/text()}">
                <xsl:apply-templates select="p:Links/p:Link" />
            </map>
        </div>
    </xsl:template>
    <xsl:template match="p:Link">
        <area shape="rect" coords="{@x},{@y},{@x+@w},{@y+@h}" href="javascript:showPage('#{@targetFid}_page')" title="Go to page '{@targetName}'"/>
    </xsl:template>

    <xsl:template match="html:*" mode="processing-notes">
        <xsl:copy>
            <xsl:copy-of select="@*[local-name() != '_moz_dirty']"/>
            <xsl:apply-templates mode="processing-notes"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="html:a[@page-fid]" mode="processing-notes">
        <a href="javascript:showPage('#{@page-fid}_page')" title="Go to page '{@page-name}'">
            <xsl:copy-of select="@class|@style"/>
            <xsl:apply-templates mode="processing-notes"/>
        </a>
    </xsl:template>
</xsl:stylesheet>
