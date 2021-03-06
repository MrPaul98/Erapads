<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:variable name="initial_bottom_pos">20.5</xsl:variable>
    <xsl:variable name="initial_left_pos">1</xsl:variable>
    <xsl:variable name="height_increment">5</xsl:variable>
    <xsl:variable name="width_increment">10</xsl:variable>
    <xsl:variable name="frame_height">5.5cm</xsl:variable>
    <xsl:variable name="frame_width">10cm</xsl:variable>
    <xsl:variable name="number_columns">2</xsl:variable>
    <xsl:variable name="max_frames">10</xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="addresses"/>
    </xsl:template>

    <xsl:template match="addresses">
        <document>
            <template leftMargin="2.0cm" rightMargin="2.0cm" topMargin="2.0cm"
                            bottomMargin="2.0cm" title="Address list" author="Generated by Serpent Consulting Services">
                <pageTemplate id="all">
                    <pageGraphics/>
                    <xsl:apply-templates select="address_id" mode="frames"/>
                </pageTemplate>
            </template>
            <stylesheet>
                <paraStyle name="nospace" fontName="Courier" fontSize="10" spaceBefore="0" spaceAfter="0"/>
            </stylesheet>
            <story>
                <xsl:apply-templates select="address_id" mode="story">
                   <xsl:sort select="contact/country"/>
                   <xsl:sort select="contact/zip"/>
                   <xsl:sort select="company-name"/>
                </xsl:apply-templates>
            </story>
        </document>
    </xsl:template>

    <xsl:template match="address_id" mode="frames">
        <xsl:if test="position() &lt; $max_frames + 1">
            <frame>
                <xsl:attribute name="width">
                    <xsl:value-of select="$frame_width"/>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="$frame_height"/>
                </xsl:attribute>
                <xsl:attribute name="x1">
                    <xsl:value-of select="$initial_left_pos + ((position()-1) mod $number_columns) * $width_increment"/>
                    <xsl:text>cm</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="y1">
                    <xsl:value-of select="$initial_bottom_pos - floor((position()-1) div $number_columns) * $height_increment"/>
                    <xsl:text>cm</xsl:text>
                </xsl:attribute>
            </frame>
        </xsl:if>
    </xsl:template>

    <xsl:template match="address_id" mode="story">
        <xsl:choose>
            <xsl:when test="count(contact[type='default']) >= 1">
                <para style="nospace"><xsl:value-of select="origin"/><xsl:text> / </xsl:text><xsl:value-of select="name"/></para>
                <xsl:apply-templates select="contact[1]"/>
                <para style="nospace">
                    <xsl:choose>
                        <xsl:when test="count(movelines) >= 1">
                            <xsl:apply-templates select="movelines"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="movelines"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="position() &lt; last()">
                        <nextFrame/>
                    </xsl:if>
                </para>

                <para style="nospace"><xsl:value-of select="total"/></para>
            </xsl:when>
            <xsl:when test="count(contact[type='']) >= 1">
                <barCode><xsl:value-of select="origin"/></barCode>
                <para style="nospace"><xsl:value-of select="origin"/><xsl:text> / </xsl:text><xsl:value-of select="name"/></para>
                <xsl:apply-templates select="contact[1]"/>

                <para style="nospace">
                    <xsl:choose>
                        <xsl:when test="count(movelines) >= 1">
                            <xsl:apply-templates select="movelines"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="movelines"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="position() &lt; last()">
                        <nextFrame/>
                    </xsl:if>
                </para>

                <para style="nospace"><xsl:value-of select="total"/></para>
            </xsl:when>
            <xsl:otherwise>
                <para style="nospace"><xsl:value-of select="origin"/><xsl:text> / </xsl:text><xsl:value-of select="name"/></para>
                <xsl:apply-templates select="contact[1]"/>
                <para style="nospace">
                    <xsl:choose>
                        <xsl:when test="count(movelines) >= 1">
                            <xsl:apply-templates select="movelines"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="movelines"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="position() &lt; last()">
                        <nextFrame/>
                    </xsl:if>
                </para>
		<para style="nospace">
		<!--added by jd for mob. phn. remark--> 
		<xsl:if test="mobile!=''">Mob:<xsl:value-of select="mobile" /><xsl:text>,</xsl:text></xsl:if><xsl:if test="phone!=''">Tel:<xsl:value-of select="phone" /> </xsl:if>	
		</para>
		<xsl:if test="remark!=''">
			<para style="nospace">Remark: <xsl:value-of select="remark"/></para>	
		</xsl:if>
                <para style="nospace">TOTAL RS. <xsl:value-of select="total"/></para>
                <barCode><xsl:value-of select="origin"/></barCode>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() &lt; last()">
            <nextFrame/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="contact">
        <para style="nospace"><xsl:value-of select="name"/><xsl:text>,</xsl:text><xsl:value-of select="street"/><xsl:text>,</xsl:text><xsl:value-of select="street2"/></para>
        <para style="nospace"><xsl:text>,</xsl:text><xsl:value-of select="area"/><xsl:text> - </xsl:text><xsl:value-of select="city"/><xsl:text>.</xsl:text></para>
    </xsl:template>

    <xsl:template match="movelines">
        <xsl:value-of select="references"/><xsl:text>(</xsl:text><xsl:value-of select="qty"/><xsl:text>), </xsl:text>
    </xsl:template>

</xsl:stylesheet>
