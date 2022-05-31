<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="text-id"/>
    <xsl:param name="display-mode"/>
    <xsl:param name="list"/>
    <xsl:param name="sort"/>
    <xsl:output method="html"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="texts">
        <html>
            <head>
                <title>Karuk Dictionary and Texts</title>
                <link rel="stylesheet" type="text/css" href="karuk.css"/>
                <script src="js/prototype.js" type="text/javascript"/>
                <script src="js/sorttable.js"/>
            </head>
            <body>
                <div class="top">
                    <div class="title">Karuk Dictionary and Texts </div>
                    <div class="credit">A collaboration between the <b>Karuk Tribe</b> and the
                            <b>University of California, Berkeley</b></div>
                </div>
                <div class="menu">
                    <ul>
                        <li>
                            <a href="index.php">Dictionary</a>
                        </li>
                        <xsl:choose>
                            <xsl:when test="$list='yes'">
                                <li class="on">Sentences and Texts</li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="karuk-texts.php?list=yes">Sentences and Texts</a>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                        <li>
                            <a href="links.php">Information and Links</a>
                        </li>
                        <!--   <li>
                            <a href="http://karuk.org/form.shtml">Feedback Form</a>
                        </li>  -->
                    </ul>
                </div>
                <div class="content">
                    <xsl:choose>
                        <xsl:when test="$list='yes'">
                            <h2>Karuk Sentences and Texts</h2>
                            <table>
                                <tr>
                                    <td>
                                        <img src="audio-icon.jpg" alt="audio icon"/>
                                    </td>
                                    <td>
                                        <p>The audio icon indicates available audio recordings. To
                                            sort, click on a column header. For example, click on
                                            "Year" to sort by year.</p>
                                    </td>
                                </tr>
                            </table>
                            <hr/>
                            <table class="sortable">
                                <thead>
                                    <tr>
                                        <td/>
                                        <td>
                                            <small>
                                                <a href="#">Year</a>
                                            </small>
                                        </td>
                                        <td>
                                            <small>
                                                <a href="#">Speaker(s)</a>
                                            </small>
                                        </td>
                                        <td>
                                            <small>
                                                <a href="#">Title</a>
                                            </small>
                                        </td>
                                        <td>
                                            <small>
                                                <a href="#">Text ID</a>
                                            </small>
                                        </td>
                                    </tr>
                                </thead>
                                <xsl:apply-templates select="text" mode="list"/>
                            </table>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="text[@id=$text-id]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="text" mode="list">
        <xsl:param name="id" select="@id"/>
        <tr>
            <td>
                <xsl:if test="descendant::s[@audio] or child::metadata/audio">
                    <img src="audio-icon.jpg" alt="audio icon"/>
                </xsl:if>
            </td>
            <td>
                <small><xsl:value-of select="metadata/date"/>&#160;&#160;</small>
            </td>
            <td>
                <small>
                    <xsl:value-of select="metadata/author"/>
                </small>
            </td>
            <td>
                <small>
                    <a href="{concat('karuk-texts.php?text-id=',$id)}">
                        <xsl:choose>
                            <xsl:when test="metadata/title/attribute::shorttitle">
                                <xsl:value-of select="metadata/title/attribute::shorttitle"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="metadata/title"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </small>
            </td>
            <td>
                <small>
                    <xsl:value-of select="$id"/>
                </small>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="text">
        <xsl:variable name="text-audio-filename" select="metadata/audio/@filename"/>
        <xsl:variable name="url"
            select="concat('http://linguistics.berkeley.edu/~karuk/audio-texts/',$text-audio-filename,'.MP3')"/>
        <xsl:variable name="onclick"
            select="concat(document('audio-url-function.xml')/root/url1,$url,document('audio-url-function.xml')/root/url2)"/>
        <div>
            <h2><xsl:value-of select="metadata/author"/>, <xsl:value-of select="metadata/title"/>
                    (<xsl:value-of select="metadata/date"/>)</h2>
            <p>Publication details: <xsl:apply-templates select="metadata/publication"/></p>
            <font size="-1">
                <p>Project identifier: <xsl:value-of select="@id"/></p>
            </font>
            <xsl:if test="metadata/audio">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>Play audio<xsl:if test="metadata/audio/@caption"> (<xsl:value-of
                                    select="metadata/audio/@caption"/>)</xsl:if>:&#160;</td>
                        <td>
                            <div id="{$text-audio-filename}">
                                <a href="#"
                                    onclick="{concat(document('audio-url-function.xml')/root/url1,$text-audio-filename,
                                    document('audio-url-function.xml')/root/url2,$text-audio-filename,
                                    document('audio-url-function.xml')/root/url3,$url,
                                    document('audio-url-function.xml')/root/url4)}">
                                    <img src="download.png" alt="play"/>
                                </a>
                            </div>
                            <!--    <script language="JavaScript" src="http://linguistics.berkeley.edu/~karuk/audio/audio-player.js"/>
                                <object type="application/x-shockwave-flash"
                                    data="http://linguistics.berkeley.edu/~karuk/audio/player.swf"
                                    id="textaudio" height="24" width="290">
                                    <param name="movie"
                                        value="http://linguistics.berkeley.edu/~karuk/audio/player.swf"/>
                                    <param name="FlashVars"
                                        value="{concat('leftbg=FFFFFF&amp;rightbg=FFFFFF&amp;rightbghover=FFFFFF&amp;righticonhover=F87431&amp;righticon=347235&amp;transparentpagebg=yes&amp;initialvolume=100&amp;playerID=textaudio&amp;soundFile=http://linguistics.berkeley.edu/~karuk/audio-texts/',$text-audio-filename,'.MP3')}"/>
                                    <param name="quality" value="high"/>
                                    <param name="menu" value="false"/>
                                    <param name="wmode" value="transparent"/>
                                </object> -->
                        </td>
                    </tr>
                </table>
                <xsl:if test="metadata/audio/@sourcelink">
                    <font size="-1">
                        <p>Audio source: <xsl:apply-templates select="metadata/audio"
                                mode="text-audio-link"/></p>
                    </font>
                </xsl:if>
            </xsl:if>
            <xsl:if test="metadata/pdf">
                <xsl:apply-templates select="metadata/pdf"/>
            </xsl:if>
            <xsl:if test="metadata/note[@publish='yes']">
                <p> Note: <xsl:apply-templates select="metadata/note"/>
                </p>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="data">
                    <hr/>
                    <p>Text display mode: <xsl:choose>
                            <xsl:when test="$display-mode='g'"><a
                                    href="{concat('karuk-texts.php?display-mode=p&amp;text-id=',$text-id)}"
                                    >paragraph</a> | <a
                                    href="{concat('karuk-texts.php?display-mode=s&amp;text-id=',$text-id)}"
                                    >sentence</a> | <a
                                    href="{concat('karuk-texts.php?display-mode=w&amp;text-id=',$text-id)}"
                                    >word</a> | word components</xsl:when>
                            <xsl:when test="$display-mode='w'"><a
                                    href="{concat('karuk-texts.php?display-mode=p&amp;text-id=',$text-id)}"
                                    >paragraph</a> | <a
                                    href="{concat('karuk-texts.php?display-mode=s&amp;text-id=',$text-id)}"
                                    >sentence</a> | word | <a
                                    href="{concat('karuk-texts.php?display-mode=g&amp;text-id=',$text-id)}"
                                    >word components</a></xsl:when>
                            <xsl:when
                                test="$display-mode='s' or (not($display-mode='p') and metadata/genre[@type='elicitation'])"
                                    ><a
                                    href="{concat('karuk-texts.php?display-mode=p&amp;text-id=',$text-id)}"
                                    >paragraph</a> | sentence | <a
                                    href="{concat('karuk-texts.php?display-mode=w&amp;text-id=',$text-id)}"
                                    >word</a> | <a
                                    href="{concat('karuk-texts.php?display-mode=g&amp;text-id=',$text-id)}"
                                    >word components</a></xsl:when>
                            <xsl:otherwise>paragraph | <a
                                    href="{concat('karuk-texts.php?display-mode=s&amp;text-id=',$text-id)}"
                                    >sentence</a> | <a
                                    href="{concat('karuk-texts.php?display-mode=w&amp;text-id=',$text-id)}"
                                    >word</a> | <a
                                    href="{concat('karuk-texts.php?display-mode=g&amp;text-id=',$text-id)}"
                                    >word components</a></xsl:otherwise>
                        </xsl:choose>
                    </p>
                    <xsl:choose>
                        <xsl:when test="$display-mode='g'">
                            <xsl:apply-templates select="data" mode="gloss"/>
                        </xsl:when>
                        <xsl:when test="$display-mode='w'">
                            <xsl:apply-templates select="data" mode="word"/>
                        </xsl:when>
                        <xsl:when
                            test="$display-mode='s' or (not($display-mode='p') and metadata/genre[@type='elicitation'])">
                            <xsl:apply-templates select="data" mode="sentence"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="data" mode="paragraph"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <hr/>
                    <p>This text has not yet been prepared for online presentation.</p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="pdf">
        <xsl:variable name="filename" select="@filename"/>
        <p><xsl:value-of select="@caption"/> (PDF): <a
                href="{concat('http://linguistics.berkeley.edu/~karuk/text-pdfs/',$filename)}">
                <xsl:value-of select="$filename"/></a></p>
    </xsl:template>
    <xsl:template match="publication">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="audio" mode="text-audio-link">
        <xsl:variable name="sourcelink" select="@sourcelink"/>
        <a href="{$sourcelink}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="data" mode="paragraph">
        <hr/>
        <table border="0" cellpadding="0" cellspacing="0">
            <col width="50"/>
            <col/>
            <col width="25"/>
            <col/>
            <xsl:apply-templates select="paragraph" mode="paragraph"/>
        </table>
    </xsl:template>
    <xsl:template match="paragraph" mode="paragraph">
        <xsl:variable name="spkr" select="@spkr"/>
        <xsl:variable name="speaker"
            select="document('karuk-abbreviations.xml')/abbreviations/abbreviation[@reference=$spkr]"/>
        <xsl:choose>
            <xsl:when test="@title">
                <p>
                    <tr>
                        <td align="left" valign="top" class="paragraph-mode">
                            <p>[<xsl:value-of select="count(preceding-sibling::paragraph) + 1"
                                />]</p>
                        </td>
                        <td align="left" valign="top" class="paragraph-mode">
                            <p>
                                <xsl:value-of select="@title"/>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td> </td>
                        <td align="left" valign="top" class="paragraph-mode">
                            <p>
                                <xsl:if test="@spkr">(<xsl:value-of select="$speaker"/>) </xsl:if>
                                <xsl:apply-templates select="s/txt" mode="paragraph"/>
                            </p>
                        </td>
                        <td/>
                        <td align="left" valign="top" class="paragraph-mode">
                            <p>
                                <xsl:apply-templates select="s/trans"/>
                            </p>
                        </td>
                    </tr>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <tr>
                        <td align="left" valign="top" class="paragraph-mode">
                            <p>[<xsl:value-of select="count(preceding-sibling::paragraph) + 1"
                                />]</p>
                        </td>
                        <td align="left" valign="top" class="paragraph-mode">
                            <p>
                                <xsl:if test="@spkr">(<xsl:value-of select="$speaker"/>) </xsl:if>
                                <xsl:apply-templates select="s/txt" mode="paragraph"/>
                            </p>
                        </td>
                        <td/>
                        <td align="left" valign="top" class="paragraph-mode">
                            <p>
                                <xsl:apply-templates select="s/trans"/>
                            </p>
                        </td>
                    </tr>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="txt" mode="paragraph">
        <b>
            <xsl:apply-templates mode="paragraph"/>
            <xsl:text> </xsl:text>
        </b>
    </xsl:template>
    <xsl:template match="w" mode="paragraph">
        <xsl:if test="preceding-sibling::w">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="paragraph"/>
    </xsl:template>
    <xsl:template match="m" mode="paragraph">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="trans">
        <xsl:text> </xsl:text>
        <xsl:apply-templates mode="paragraph"/>
    </xsl:template>
    <xsl:template match="data" mode="sentence">
        <xsl:apply-templates select="paragraph" mode="sentence"/>
    </xsl:template>
    <xsl:template match="paragraph" mode="sentence">
        <xsl:variable name="spkr" select="@spkr"/>
        <xsl:variable name="speaker"
            select="document('karuk-abbreviations.xml')/abbreviations/abbreviation[@reference=$spkr]"/>
        <hr/>
        <xsl:if test="@title or @spkr">
            <p>
                <xsl:value-of select="@title"/>
                <xsl:if test="@title and @spkr"> | </xsl:if>
                <xsl:value-of select="$speaker"/>
            </p>
        </xsl:if>
        <xsl:apply-templates select="s" mode="sentence"/>
    </xsl:template>
    <xsl:template match="s" mode="sentence">
        <xsl:variable name="data-ancestor" select="ancestor::data"/>
        <p>
            <table border="0" cellpadding="0" cellspacing="0">
                <col width="50"/>
                <col/>
                <tr>
                    <td align="left" rowspan="2" valign="top"> [<xsl:value-of
                            select="count(preceding::s[ancestor::data=$data-ancestor]) + 1"/>] </td>
                    <td align="left">
                        <span class="karuk">
                            <xsl:apply-templates select="txt" mode="paragraph"/>
                        </span>
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        <xsl:apply-templates select="trans"/>
                    </td>
                </tr>
            </table>
            <xsl:if test="@audio">
                <xsl:call-template name="audio-clip"/>
            </xsl:if>
            <xsl:if test="note/@publish='yes'">
                <xsl:call-template name="sentence-note"/>
            </xsl:if>
        </p>
    </xsl:template>
    <xsl:template name="audio-clip">
        <xsl:variable name="filename" select="@audio"/>
        <xsl:variable name="spkr" select="@spkr"/>
        <xsl:variable name="speaker"
            select="document('karuk-abbreviations.xml')/abbreviations/abbreviation[@reference=$spkr]"/>
        <xsl:choose>
            <xsl:when test="@audio-folder">
                <xsl:variable name="text-id" select="@audio-folder"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="text-id" select="ancestor::text/attribute::id"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="url"
            select="concat('http://linguistics.berkeley.edu/~karuk/audio-sentences/',$text-id,'/',$filename,'.MP3')"/>
        <xsl:variable name="onclick"
            select="concat(document('audio-url-function.xml')/root/url1,$url,document('audio-url-function.xml')/root/url2)"/>
        <table border="0" cellpadding="0" cellspacing="0">
            <col width="50"/>
            <col/>
            <tr>
                <td/>
                <td class="table-cell-with-padding">
                    <font size="-1"><xsl:if test="@spkr"> Spoken by <xsl:value-of select="$speaker"
                            /> | </xsl:if>
                        <a
                            href="{concat('http://linguistics.berkeley.edu/~karuk/audio-sentences/',
                        $text-id,'/',$filename,'.MP3')}"
                            >Download</a> |&#160;</font>
                </td>
                <td>
                    <div id="{$filename}">
                        <font size="-1">
                            <a href="#"
                                onclick="{concat(document('audio-url-function.xml')/root/url1,$filename,
                        document('audio-url-function.xml')/root/url2,$filename,
                        document('audio-url-function.xml')/root/url3,$url,
                        document('audio-url-function.xml')/root/url4)}"
                                > Play </a>
                        </font>
                    </div>
                </td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="data" mode="word">
        <xsl:apply-templates select="paragraph" mode="word"/>
    </xsl:template>
    <xsl:template match="paragraph" mode="word">
        <xsl:variable name="spkr" select="@spkr"/>
        <xsl:variable name="speaker"
            select="document('karuk-abbreviations.xml')/abbreviations/abbreviation[@reference=$spkr]"/>
        <hr/>
        <xsl:if test="@title or @spkr">
            <p>
                <xsl:value-of select="@title"/>
                <xsl:if test="@title and @spkr"> | </xsl:if>
                <xsl:value-of select="$speaker"/>
            </p>
        </xsl:if>
        <xsl:apply-templates select="s" mode="word"/>
    </xsl:template>
    <xsl:template match="s" mode="word">
        <xsl:variable name="data-ancestor" select="ancestor::data"/>
        <p>
            <table border="0" cellpadding="0" cellspacing="0">
                <col width="50"/>
                <col/>
                <tr>
                    <td align="left" rowspan="2" valign="top"> [<xsl:value-of
                            select="count(preceding::s[ancestor::data=$data-ancestor]) + 1"/>] </td>
                    <xsl:apply-templates select="txt" mode="word-karuk"/>
                </tr>
                <tr>
                    <xsl:apply-templates select="txt" mode="word-english"/>
                </tr>
            </table>
            <table border="0" cellpadding="0" cellspacing="0">
                <col width="50"/>
                <col/>
                <tr>
                    <td/>
                    <td align="left">
                        <xsl:apply-templates select="trans"/>
                    </td>
                </tr>
            </table>
            <xsl:if test="@audio">
                <xsl:call-template name="audio-clip"/>
            </xsl:if>
            <xsl:if test="note/@publish='yes'">
                <xsl:call-template name="sentence-note"/>
            </xsl:if>
        </p>
    </xsl:template>
    <xsl:template name="sentence-note">
        <table border="0" cellpadding="0" cellspacing="0">
            <col width="50"/>
            <col/>
            <tr>
                <td/>
                <td align="left">
                    <font size="-1">(<xsl:apply-templates select="note"/>) </font>
                </td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="txt" mode="word-karuk">
        <xsl:apply-templates select="w" mode="word-karuk"/>
    </xsl:template>
    <xsl:template match="w" mode="word-karuk">
        <td align="left">
            <span class="karuk">
                <b>
                    <xsl:apply-templates mode="word-karuk"/>
                </b>
            </span>
            <xsl:text>&#160;&#160;&#160;</xsl:text>
        </td>
    </xsl:template>
    <xsl:template match="m" mode="word-karuk">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="txt" mode="word-english">
        <xsl:apply-templates select="w" mode="word-english"/>
    </xsl:template>
    <xsl:template match="w" mode="word-english">
        <td align="left">
            <xsl:choose>
                <xsl:when test="count(m)=1">
                    <xsl:apply-templates select="m" mode="word-english"/>
                </xsl:when>
                <xsl:when test="@gl">
                    <xsl:value-of select="translate(@gl,' ','.')"/>
                </xsl:when>
                <xsl:when test="@language='english' or @language='yurok' or @language='nonsense'">
                    <i>
                        <xsl:value-of select="."/>
                    </i>
                </xsl:when>
            </xsl:choose>
            <xsl:text>&#160;&#160;&#160;</xsl:text>
        </td>
    </xsl:template>
    <xsl:template match="m" mode="word-english">
        <xsl:variable name="gloss-id" select="@id"/>
        <xsl:choose>
            <xsl:when test="@language='english' or @language='yurok' or @language='nonsense'">
                <i>
                    <xsl:value-of select="."/>
                </i>
            </xsl:when>
            <xsl:when test="contains(@gl,';')">
                <xsl:value-of
                    select="translate(translate(substring-before(@gl,';'),'_–—','.::'),' ','')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(translate(@gl,'_–—','.::'),' ','')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="data" mode="gloss">
        <xsl:apply-templates select="paragraph" mode="gloss"/>
    </xsl:template>
    <xsl:template match="paragraph" mode="gloss">
        <xsl:variable name="spkr" select="@spkr"/>
        <xsl:variable name="speaker"
            select="document('karuk-abbreviations.xml')/abbreviations/abbreviation[@reference=$spkr]"/>
        <hr/>
        <xsl:if test="@title or @spkr">
            <p>
                <xsl:value-of select="@title"/>
                <xsl:if test="@title and @spkr"> | </xsl:if>
                <xsl:value-of select="$speaker"/>
            </p>
        </xsl:if>
        <xsl:apply-templates select="s" mode="gloss"/>
    </xsl:template>
    <xsl:template match="s" mode="gloss">
        <xsl:variable name="data-ancestor" select="ancestor::data"/>
        <xsl:variable name="filename" select="@audio"/>
        <xsl:variable name="text-id" select="ancestor::text/attribute::id"/>
        <xsl:variable name="url"
            select="concat('http://linguistics.berkeley.edu/~karuk/audio-sentences/',$text-id,'/',$filename,'.MP3')"/>
        <p>
            <table border="0" cellpadding="0" cellspacing="0">
                <col width="50"/>
                <col/>
                <tr>
                    <td align="left" rowspan="2" valign="top"> [<xsl:value-of
                            select="count(preceding::s[ancestor::data=$data-ancestor]) + 1"/>] </td>
                    <xsl:apply-templates select="txt" mode="gloss-karuk"/>
                </tr>
                <tr>
                    <xsl:apply-templates select="txt" mode="gloss-english"/>
                </tr>
            </table>
            <table border="0" cellpadding="0" cellspacing="0">
                <col width="50"/>
                <col/>
                <tr>
                    <td/>
                    <td align="left">
                        <xsl:apply-templates select="trans"/>
                    </td>
                </tr>
            </table>
            <xsl:if test="@audio">
                <xsl:call-template name="audio-clip"/>
            </xsl:if>
            <xsl:if test="note/@publish='yes'">
                <xsl:call-template name="sentence-note"/>
            </xsl:if>
        </p>
    </xsl:template>
    <xsl:template match="txt" mode="gloss-karuk">
        <xsl:apply-templates select="w" mode="gloss-karuk"/>
    </xsl:template>
    <xsl:template match="txt" mode="gloss-english">
        <xsl:apply-templates select="w" mode="gloss-english"/>
    </xsl:template>
    <xsl:template match="w" mode="gloss-karuk">
        <td align="left">
            <b>
                <xsl:apply-templates mode="gloss-karuk"/>&#160;&#160;&#160;</b>
        </td>
    </xsl:template>
    <xsl:template match="m" mode="gloss-karuk">
        <xsl:choose>
            <xsl:when test="not(@lemma) or (@lemma='0')">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <a href="{concat('karuk-dictionary.php?lxGroup-id=',@lemma)}">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::m and not(starts-with(following-sibling::m,'-'))"
            >-</xsl:if>
    </xsl:template>
    <xsl:template match="w" mode="gloss-english">
        <td align="left">
            <xsl:apply-templates mode="gloss-english"/>&#160;&#160;&#160;</td>
    </xsl:template>
    <xsl:template match="m" mode="gloss-english">
        <xsl:variable name="gloss-id" select="@lemma"/>
        <xsl:variable name="gloss" select="@gl"/>
        <xsl:choose>
            <xsl:when test="@language='english' or @language='yurok' or @language='nonsense'">
                <i>
                    <xsl:value-of select="."/>
                </i>
            </xsl:when>
            <xsl:when test="not(@lemma)">
                <xsl:text>?</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="contains(@gl,';')">
                        <xsl:value-of
                            select="translate(translate(substring-before(@gl,';'),'_–—','.::'),' ','')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(translate(@gl,'_–—','.::'),' ','')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::m">-</xsl:if>
    </xsl:template>
    <xsl:template match="trans">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="em">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template match="sup">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="note">
        <xsl:if test="@publish='yes'">
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="url">
        <xsl:variable name="href" select="@href"/>
        <a href="{$href}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="text-plain"/>
</xsl:stylesheet>
