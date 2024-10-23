<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
                xmlns:xrv="http://www.example.org/XRechnung-Viewer">
    <xsl:param name="i18n" as="map(*)"/>
    <xsl:param name="isOrder" as="xs:boolean"/>
    <xsl:param name="showIds" as="xs:boolean"/>

    <xsl:output indent="yes" method="html" encoding="UTF-8" />
    <xsl:decimal-format name="decimal" decimal-separator="," grouping-separator="." NaN="" />


    <!-- MAIN HTML -->
    <xsl:template match="/xr:invoice">

        <html lang="de">
            <head>
                <meta charset="UTF-8"/>
                <title><xsl:value-of select="$i18n?title"/></title>
                <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0"/>
                 <style>
                    /* Base Styles */
                    * {
                        box-sizing: border-box;
                        margin: 0;
                        padding: 0;
                    }

                    body {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        background-color: #f3f2f1;
                        color: #323130;
                        padding: 20px;
                    }

                    h2, h3 {
                        color: #009bf0;
                    }

                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 20px;
                        background-color: #ffffff;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .menue {
                        display: flex;
                        justify-content: space-around;
                        margin-bottom: 20px;
                        background-color: #009bf0;
                        padding: 10px;
                        border-radius: 4px;
                    }

                    .menue button {
                        background-color: transparent;
                        color: #ffffff;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 4px;
                        cursor: pointer;
                        transition: background-color 0.3s;
                        font-size: 16px;
                    }

                    .menue button:hover {
                        background-color: #0078d4;
                    }

                    .menue .btnAktiv {
                        background-color: #82cd28;
                    }

                    .inhalt {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        margin-bottom: 30px;
                    }

                    .haftungausschluss {
                        color: #000;
                        text-align: center;
                        padding: 7px;
                        margin-bottom: 30px;
                        width: 100%;
                        border: 1px solid #82cd28;
                        background-color: #ffffff;
                    }

                    .box {
                        position: relative;
                        display: table-cell;
                        padding: 0;
                        border: 1px solid rgba(4, 101, 161, 0.2);
                        background-color: #ffffff;
                        margin-bottom: 20px;
                        border-radius: 4px;
                    }

                    .boxtitel {
                        display: inline-block;
                        background-color: #009bf0;
                        padding: 7px 10px;
                        color: #ffffff;
                        font-weight: bold;
                        border-top-left-radius: 4px;
                        border-top-right-radius: 4px;
                    }

                    .boxtitelSub {
                        color: #000;
                        background-color: rgba(4, 101, 161, 0.1);
                        border-right: 1px solid rgba(4, 101, 161, 0.2);
                        border-bottom: 1px solid rgba(4, 101, 161, 0.2);
                    }

                    .boxinhalt {
                        padding: 15px 20px;
                    }

                    .boxtabelle {
                        display: table;
                        width: 100%;
                    }

                    .boxzeile {
                        display: table-row;
                    }

                    .boxdaten {
                        display: table-cell;
                        padding: 5px 10px;
                        vertical-align: middle;
                        height: 38px;
                    }

                    .boxdaten.wert {
                        background-color: rgba(4, 101, 161, 0.03);
                    }

                    .legende {
                        color: rgba(0, 0, 0, 0.6);
                        width: 170px;
                        font-size: 13px;
                        line-height: 16px;
                        padding-right: 5px;
                    }

                    .wert {
                        background-color: rgba(4, 101, 161, 0.03);
                    }

                    .rechnungsZeile {
                        display: table-row;
                    }

                    .rechnungsZeile .boxdaten {
                        height: auto;
                    }

                    .rechnungSp1 {
                        width: 65%;
                        font-size: 16px;
                    }

                    .rechnungSp2 {
                        width: 10%;
                    }

                    .rechnungSp3 {
                        width: 25%;
                        font-size: 16px;
                        text-align: right;
                    }

                    .line1Bottom {
                        border-bottom: 1px solid #000;
                    }

                    .line1BottomLight {
                        padding-bottom: 5px;
                        border-bottom: 1px solid #f0f0f0;
                        margin-bottom: 5px;
                    }

                    .line2Bottom {
                        border-bottom: 2px solid #000;
                    }

                    .paddingTop {
                        padding-top: 10px;
                    }

                    .paddingBottom {
                        padding-bottom: 10px;
                    }

                    .bold {
                        font-weight: bold;
                    }

                    @media (max-width: 768px) {
                        .menue {
                            flex-direction: column;
                        }

                        .menue button {
                            margin-bottom: 10px;
                        }

                        .box {
                            padding: 10px;
                        }

                        .box table th, .box table td {
                            padding: 5px;
                        }

                        .boxdaten {
                            display: block;
                            width: 100%;
                            padding: 10px;
                        }

                        .legende {
                            width: 100%;
                            padding: 5px 0;
                        }

                        .wert {
                            width: 100%;
                            padding: 10px;
                        }

                        .rechnungSp1, .rechnungSp2, .rechnungSp3 {
                            width: 100%;
                            text-align: left;
                            font-size: 14px;
                        }
                    }

                    @media (max-width: 450px) {
                        html, body {
                            font-size: 12px;
                        }

                        .menue {
                            margin-bottom: 20px;
                        }

                        .menue button {
                            font-size: 14px;
                            height: 35px;
                        }

                        .boxdaten {
                            padding: 5px;
                        }

                        .legende {
                            font-size: 12px;
                        }

                        .wert {
                            font-size: 12px;
                        }

                        .rechnungSp1, .rechnungSp2, .rechnungSp3 {
                            font-size: 12px;
                        }
                    }
                </style>
            </head>
            <body>
                <form>
                    <div class="menue">
                        <div class="innen">
                            <button type="button" class="tab" id="menueUebersicht" onclick="show(this);"><xsl:value-of select="$i18n?overview"/></button>
                            <button type="button" class="tab" id="menueDetails" onclick="show(this);"><xsl:value-of select="$i18n?items"/></button>
                            <button type="button" class="tab" id="menueZusaetze" onclick="show(this)"><xsl:value-of select="$i18n?information"/></button>
                            <button type="button" class="tab" id="menueAnlagen" onclick="show(this)"><xsl:value-of select="$i18n?attachments"/></button>
                            <button type="button" class="tab" id="menueLaufzettel" onclick="show(this)"><xsl:value-of select="$i18n?history"/></button>
                        </div>
                    </div>
                </form>
                <div class="inhalt">
                    <div class="innen">
                        <xsl:call-template name="uebersicht"/>
                        <xsl:call-template name="details"/>
                        <xsl:call-template name="zusaetze"/>
                        <xsl:call-template name="anlagen"/>
                        <xsl:call-template name="laufzettel"/>
                    </div>
                </div>
            </body>
            <script>
                //<![CDATA[

/* Tab-Container aufbauen **************************************************/

var a = new Array("uebersicht", "details", "zusaetze", "anlagen", "laufzettel");
var b = new Array("menueUebersicht", "menueDetails", "menueZusaetze", "menueAnlagen", "menueLaufzettel");

function show(e) {
  var i = 0;
  var j = 1;
  for (var t = 0; t < b.length; t++) {
    if (b[t] === e.id) {
      i = t;
      if (i > 0) {
        j = 0;
      } else {
        j = i + 1;
      }
      break;
    }
  }
  e.setAttribute("class", "btnAktiv");
  for (var k = 0; k < b.length; k++) {
    if (k === i && (document.getElementById(a[k]) != null)) {
      document.getElementById(a[k]).style.display = "block";
      if (i === j)
      j = i + 1;
    } else {
      if (document.getElementById(a[k]) != null) {
        document.getElementById(a[j]).style.display = "none";
        document.getElementById(b[j]).setAttribute("class", "btnInaktiv");
        j += 1;
      }
    }
  }
}
window.onload = function () {
  document.getElementById(b[0]).setAttribute("class", "btnAktiv");
}

/* Eingebettete Binaerdaten runterladen   ************************************/


function base64_to_binary (data) {
  var chars = atob(data);
  var bytes = new Array(chars.length);
  for (var i = 0; i < chars.length; i++) {
    bytes[i] = chars.charCodeAt(i);
  }
  return new Uint8Array(bytes);
}

function downloadData (element_id) {
  var data_element = document.getElementById(element_id);
  var mimetype = data_element.getAttribute('mimeType');
  var filename = data_element.getAttribute('filename');
  var text = data_element.innerHTML;
  var binary = base64_to_binary(text);
  var blob = new Blob([binary], {
    type: mimetype, size: binary.length
  });

  if (window.navigator && window.navigator.msSaveOrOpenBlob) {
    // IE
    window.navigator.msSaveOrOpenBlob(blob, filename);
  } else {
    // Non-IE
    var url = window.URL.createObjectURL(blob);
    window.open(url);
  }
}


/* Polyfill IE atob/btoa   ************************************/

(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define([], function () {
      factory(root);
    });
  } else factory(root);
  // node.js has always supported base64 conversions, while browsers that support
  // web workers support base64 too, but you may never know.
})(typeof exports !== "undefined" ? exports: this, function (root) {
  if (root.atob) {
    // Some browsers' implementation of atob doesn't support whitespaces
    // in the encoded string (notably, IE). This wraps the native atob
    // in a function that strips the whitespaces.
    // The original function can be retrieved in atob.original
    try {
      root.atob(" ");
    }
    catch (e) {
      root.atob = (function (atob) {
        var func = function (string) {
          return atob(String(string).replace(/[\t\n\f\r ]+/g, ""));
        };
        func.original = atob;
        return func;
      })(root.atob);
    }
    return;
  }

  // base64 character set, plus padding character (=)
  var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
  // Regular expression to check formal correctness of base64 encoded strings
  b64re = /^(?:[A-Za-z\d+\/]{4})*?(?:[A-Za-z\d+\/]{2}(?:==)?|[A-Za-z\d+\/]{3}=?)?$/;

  root.btoa = function (string) {
    string = String(string);
    var bitmap, a, b, c,
    result = "", i = 0,
    rest = string.length % 3; // To determine the final padding

    for (; i < string.length;) {
      if ((a = string.charCodeAt(i++)) > 255 || (b = string.charCodeAt(i++)) > 255 || (c = string.charCodeAt(i++)) > 255)
      throw new TypeError("Failed to execute 'btoa' on 'Window': The string to be encoded contains characters outside of the Latin1 range.");

      bitmap = (a << 16) | (b << 8) | c;
      result += b64.charAt(bitmap >> 18 & 63) + b64.charAt(bitmap >> 12 & 63) + b64.charAt(bitmap >> 6 & 63) + b64.charAt(bitmap & 63);
    }

    // If there's need of padding, replace the last 'A's with equal signs
    return rest ? result.slice(0, rest - 3) + "===".substring(rest): result;
  };

  root.atob = function (string) {
    // atob can work with strings with whitespaces, even inside the encoded part,
    // but only \t, \n, \f, \r and ' ', which can be stripped.
    string = String(string).replace(/[\t\n\f\r ]+/g, "");
    if (! b64re.test(string))
    throw new TypeError("Failed to execute 'atob' on 'Window': The string to be decoded is not correctly encoded.");

    // Adding the padding if missing, for semplicity
    string += "==".slice(2 - (string.length & 3));
    var bitmap, result = "", r1, r2, i = 0;
    for (; i < string.length;) {
      bitmap = b64.indexOf(string.charAt(i++)) << 18 | b64.indexOf(string.charAt(i++)) << 12 | (r1 = b64.indexOf(string.charAt(i++))) << 6 | (r2 = b64.indexOf(string.charAt(i++)));

      result += r1 === 64 ? String.fromCharCode(bitmap >> 16 & 255): r2 === 64 ? String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255): String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255, bitmap & 255);
    }
    return result;
  };
});
//]]>

            </script>
        </html>
    </xsl:template>


    <xsl:template name="uebersicht">
        <div id="uebersicht" class="divShow">
            <div class="haftungausschluss"><xsl:value-of select="$i18n?disclaimer"/></div>
            <div class="boxtabelle boxtabelleZweispaltig">
                <div class="boxzeile">

                    <xsl:apply-templates select="./xr:BUYER"/>

                    <div class="boxabstand"></div>

                    <xsl:apply-templates select="./xr:SELLER"/>

                </div>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:call-template name="uebersichtRechnungsinfo"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:call-template name="uebersichtRechnungsuebersicht"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:apply-templates select="./xr:VAT_BREAKDOWN"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:apply-templates select="./xr:DOCUMENT_LEVEL_ALLOWANCES"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:apply-templates select="./xr:DOCUMENT_LEVEL_CHARGES"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig first">
                <div class="boxzeile">
                    <xsl:call-template name="uebersichtZahlungsinformationen"/>
                    <xsl:call-template name="uebersichtCard"/>
                </div>
            </div>

            <div class="boxtabelle">
                <div class="boxzeile">
                    <xsl:call-template name="uebersichtLastschrift"/>
                    <xsl:call-template name="uebersichtUeberweisung"/>
                </div>
            </div>

            <div class="boxtabelle boxabstandtop">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:INVOICE_NOTE"/>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtKaeufer" match="xr:BUYER">
        <div id="uebersichtKaeufer" class="box boxZweispaltig">
            <div id="BG-7" title="BG-7" class="boxtitel"><xsl:value-of select="$i18n?recipientInfo"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt10"/><xsl:if test="$showIds"> BT-10</xsl:if>:</div>
                    <div id="BT-10" title="BT-10" class="boxdaten wert"><xsl:value-of select="../xr:Buyer_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt44"/><xsl:if test="$showIds"> BT-44</xsl:if>:</div>
                    <div id="BT-44" title="BT-44" class="boxdaten wert"><xsl:value-of select="xr:Buyer_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt50"/><xsl:if test="$showIds"> BT-50</xsl:if>:</div>
                    <div id="BT-50" title="BT-50" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt51"/><xsl:if test="$showIds"> BT-51</xsl:if>:</div>
                    <div id="BT-51" title="BT-51" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt163"/><xsl:if test="$showIds"> BT-163</xsl:if>:</div>
                    <div id="BT-163" title="BT-163" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt53"/><xsl:if test="$showIds"> BT-53</xsl:if>:</div>
                    <div id="BT-53" title="BT-53" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt52"/><xsl:if test="$showIds"> BT-52</xsl:if>:</div>
                    <div id="BT-52" title="BT-52" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt54"/><xsl:if test="$showIds"> BT-54</xsl:if>:</div>
                    <div id="BT-54" title="BT-54" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt55"/><xsl:if test="$showIds"> BT-55</xsl:if>:</div>
                    <div id="BT-55" title="BT-55" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt46"/><xsl:if test="$showIds"> BT-46</xsl:if>:</div>
                    <div id="BT-46" title="BT-46" class="boxdaten wert"><xsl:value-of select="xr:Buyer_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt46-id"/><xsl:if test="$showIds"> BT-46</xsl:if>:</div>
                    <div id="BT-46-scheme-id" title="BT-46-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Buyer_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt56"/><xsl:if test="$showIds"> BT-56</xsl:if>:</div>
                    <div id="BT-56" title="BT-56" class="boxdaten wert"><xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_point"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt57"/><xsl:if test="$showIds"> BT-57</xsl:if>:</div>
                    <div id="BT-57" title="BT-57" class="boxdaten wert"><xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_telephone_number"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt58"/><xsl:if test="$showIds"> BT-58</xsl:if>:</div>
                    <div id="BT-58" title="BT-58" class="boxdaten wert"><xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_email_address"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtVerkaeufer" match="xr:SELLER">
        <div id="uebersichtVerkaeufer" class="box boxZweispaltig">
            <div id="BG-4" title="BG-4" class="boxtitel"><xsl:value-of select="$i18n?bg4"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"> </div>
                    <div class="boxdaten wert" style="background-color: white;"> </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt27"/><xsl:if test="$showIds"> BT-27</xsl:if>:</div>
                    <div id="BT-27" title="BT-27" class="boxdaten wert"><xsl:value-of select="xr:Seller_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt35"/><xsl:if test="$showIds"> BT-35</xsl:if>:</div>
                    <div id="BT-35" title="BT-35" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt36"/><xsl:if test="$showIds"> BT-36</xsl:if>:</div>
                    <div id="BT-36" title="BT-36" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt162"/><xsl:if test="$showIds"> BT-162</xsl:if>:</div>
                    <div id="BT-162" title="BT-162" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt38"/><xsl:if test="$showIds"> BT-38</xsl:if>:</div>
                    <div id="BT-38" title="BT-38" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt37"/><xsl:if test="$showIds"> BT-37</xsl:if>:</div>
                    <div id="BT-37" title="BT-37" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt39"/><xsl:if test="$showIds"> BT-39</xsl:if>:</div>
                    <div id="BT-39" title="BT-39" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt40"/><xsl:if test="$showIds"> BT-40</xsl:if>:</div>
                    <div id="BT-40" title="BT-40" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt29"/><xsl:if test="$showIds"> BT-29</xsl:if>:</div>
                    <div id="BT-29" title="BT-29" class="boxdaten wert"><xsl:value-of select="xr:Seller_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt29-id"/><xsl:if test="$showIds"> BT-29-ID</xsl:if>:</div>
                    <div id="BT-29-scheme-id" title="BT-29-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Seller_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt41"/><xsl:if test="$showIds"> BT-41</xsl:if>:</div>
                    <div id="BT-41" title="BT-41" class="boxdaten wert"><xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_point"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt42"/><xsl:if test="$showIds"> BT-42</xsl:if>:</div>
                    <div id="BT-42" title="BT-42" class="boxdaten wert"><xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_telephone_number"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt43"/><xsl:if test="$showIds"> BT-43</xsl:if>:</div>
                    <div id="BT-43" title="BT-43" class="boxdaten wert"><xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_email_address"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtRechnungsinfo">
        <div class="boxzeile">
            <div id="uebersichtRechnungsinfo" class="box box1v2">
                <div class="boxtitel"><xsl:value-of select="$i18n?details"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="boxcell boxZweispaltig">
                        <div class="boxtabelle borderSpacing">
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt1"/><xsl:if test="$showIds"> BT-1</xsl:if>:</div>
                                <div id="BT-1" title="BT-1" class="boxdaten wert"><xsl:value-of select="xr:Invoice_number"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt2"/><xsl:if test="$showIds"> BT-2</xsl:if>:</div>
                                <div id="BT-2" title="BT-2" class="boxdaten wert"><xsl:value-of select="format-date(xr:Invoice_issue_date,'[D].[M].[Y]')"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt3"/><xsl:if test="$showIds"> BT-3</xsl:if>:</div>
                                <div id="BT-3" title="BT-3" class="boxdaten wert"><xsl:value-of select="xr:Invoice_type_code"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt5"/><xsl:if test="$showIds"> BT-5</xsl:if>:</div>
                                <div id="BT-5" title="BT-5" class="boxdaten wert"><xsl:value-of select="xr:Invoice_currency_code"/></div>
                            </div>
                        </div>
                        <h4><xsl:value-of select="$i18n?period"/>:</h4>
                        <div class="boxtabelle borderSpacing">
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt73"/><xsl:if test="$showIds"> BT-73</xsl:if>:</div>
                                <div id="BT-73" title="BT-73" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_start_date,'[D].[M].[Y]')"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt74"/><xsl:if test="$showIds"> BT-74</xsl:if>:</div>
                                <div id="BT-74" title="BT-74" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_end_date,'[D].[M].[Y]')"/></div>
                            </div>
                        </div>
                    </div>
                    <div class="boxabstand"></div>
                    <div class="boxcell boxZweispaltig">
                        <div class="boxtabelle borderSpacing">
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt11"/><xsl:if test="$showIds"> BT-11</xsl:if>:</div>
                                <div id="BT-11" title="BT-11" class="boxdaten wert"><xsl:value-of select="xr:Project_reference"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt12"/><xsl:if test="$showIds"> BT-12</xsl:if>:</div>
                                <div id="BT-12" title="BT-12" class="boxdaten wert"><xsl:value-of select="xr:Contract_reference"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt13"/><xsl:if test="$showIds"> BT-13</xsl:if>:</div>
                                <div id="BT-13" title="BT-13" class="boxdaten wert"><xsl:value-of select="xr:Purchase_order_reference"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt14"/><xsl:if test="$showIds"> BT-14</xsl:if>:</div>
                                <div id="BT-14" title="BT-14" class="boxdaten wert"><xsl:value-of select="xr:Sales_order_reference"/></div>
                            </div>
                        </div>
                        <h4><xsl:value-of select="$i18n?preceding_invoice_reference"/>:</h4>
                        <xsl:apply-templates select="./xr:PRECEDING_INVOICE_REFERENCE"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xr:PRECEDING_INVOICE_REFERENCE">
        <div class="boxtabelle borderSpacing">
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt25"/><xsl:if test="$showIds"> BT-25</xsl:if>:</div>
                <div id="BT-25" title="BT-25" class="boxdaten wert"><xsl:value-of select="xr:Preceding_Invoice_reference"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt26"/><xsl:if test="$showIds"> BT-26</xsl:if>:</div>
                <div id="BT-26" title="BT-26" class="boxdaten wert"><xsl:value-of select="(format-date,xr:Preceding_Invoice_issue_date,'[D].[M].[Y]')"/></div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtRechnungsuebersicht">
        <div class="boxzeile">
            <div id="uebersichtRechnungsuebersicht" class="box">
                <div id="BG-22" title="BG-22" class="boxtitel"><xsl:value-of select="$i18n?bg22"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt106"/><xsl:if test="$showIds"> BT-106</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-106" title="BT-106" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_Invoice_line_net_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt107"/><xsl:if test="$showIds"> BT-107</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-107" title="BT-107" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_allowances_on_document_level,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingBottom line1Bottom"><xsl:value-of select="$i18n?bt108"/><xsl:if test="$showIds"> BT-108</xsl:if></div>
                        <div class="boxdaten rechnungSp2 paddingBottom line1Bottom color2">netto</div>
                        <div id="BT-108" title="BT-108" class="boxdaten rechnungSp3 paddingBottom line1Bottom"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_charges_on_document_level,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingTop"><xsl:value-of select="$i18n?bt109"/><xsl:if test="$showIds"> BT-109</xsl:if></div>
                        <div class="boxdaten rechnungSp2 paddingTop color2">netto</div>
                        <div id="BT-109" title="BT-109" class="boxdaten rechnungSp3 paddingTop"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_without_VAT,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt110"/><xsl:if test="$showIds"> BT-110</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-110" title="BT-110" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingBottom line1Bottom"><xsl:value-of select="$i18n?bt111"/><xsl:if test="$showIds"> BT-111</xsl:if></div>
                        <div class="boxdaten rechnungSp2 paddingBottom line1Bottom color2"></div>
                        <div id="BT-111" title="BT-111" class="boxdaten rechnungSp3 paddingBottom line1Bottom"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount_in_accounting_currency,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingTop"><xsl:value-of select="$i18n?bt112"/><xsl:if test="$showIds"> BT-112</xsl:if></div>
                        <div class="boxdaten rechnungSp2 paddingTop color2">brutto</div>
                        <div id="BT-112" title="BT-112" class="boxdaten rechnungSp3 paddingTop"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_with_VAT,'###.##0,00','decimal')"/></div>
                    </div>
                    <xsl:if test="fn:not($isOrder)">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt113"/><xsl:if test="$showIds"> BT-113</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">brutto</div>
                        <div id="BT-113" title="BT-113" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Paid_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    </xsl:if>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingBottom line2Bottom"><xsl:value-of select="$i18n?bt114"/><xsl:if test="$showIds"> BT-114</xsl:if></div>
                        <div class="boxdaten rechnungSp2 paddingBottom line2Bottom color2">brutto</div>
                        <div id="BT-114" title="BT-114" class="boxdaten rechnungSp3 paddingBottom line2Bottom"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Rounding_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingTop bold"><xsl:value-of select="$i18n?bt115"/><xsl:if test="$showIds"> BT-115</xsl:if></div>
                        <div class="boxdaten rechnungSp2 paddingTop color2">brutto</div>
                        <div id="BT-115" title="BT-115" class="boxdaten rechnungSp3 paddingTop bold"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Amount_due_for_payment,'###.##0,00','decimal')"/></div>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtUmsatzsteuer" match="xr:VAT_BREAKDOWN">
        <div class="boxzeile">
            <div id="uebersichtUmsatzsteuer" class="box">
                <div id="BG-23" title="BG-23" class="boxtitel"><xsl:value-of select="$i18n?bg23"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 bold"><xsl:value-of select="$i18n?bt118"/><xsl:if test="$showIds"> BT-118</xsl:if>: <span id="BT-118" title="BT-118"><xsl:value-of select="xr:VAT_category_code"/></span></div>
                        <div class="boxdaten rechnungSp2"></div>
                        <div class="boxdaten rechnungSp3"></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt116"/><xsl:if test="$showIds"> BT-116</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-116" title="BT-116" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:VAT_category_taxable_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 line1Bottom"><xsl:value-of select="$i18n?bt119"/><xsl:if test="$showIds"> BT-119</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2 line1Bottom"></div>
                        <div id="BT-119" title="BT-119" class="boxdaten rechnungSp3 line1Bottom"><xsl:value-of select="xr:VAT_category_rate"/>%</div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt117"/><xsl:if test="$showIds"> BT-117</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-117" title="BT-117" class="boxdaten rechnungSp3 bold"><xsl:value-of select="format-number(xr:VAT_category_tax_amount,'###.##0,00','decimal')"/></div>
                    </div>
                </div>

                <div class="grund">
                    <div><xsl:value-of select="$i18n?bt120"/><xsl:if test="$showIds"> BT-120</xsl:if>: <span id="BT-120" title="BT-120" class="bold"><xsl:value-of select="xr:VAT_exemption_reason_text"/></span></div>
                    <div><xsl:value-of select="$i18n?bt121"/><xsl:if test="$showIds"> BT-121</xsl:if>: <span id="BT-121"  title="BT-121" class="bold"><xsl:value-of select="xr:VAT_exemption_reason_code"/></span></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtNachlass" match="xr:DOCUMENT_LEVEL_ALLOWANCES">
        <div class="boxzeile">
            <div id="uebersichtNachlass" class="box">
                <div id="BG-20" title="BG-20" class="boxtitel"><xsl:value-of select="$i18n?bg20"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 bold"><xsl:value-of select="$i18n?bt95"/><xsl:if test="$showIds"> BT-95</xsl:if>: <span title="BT-95"><xsl:value-of select="xr:Document_level_allowance_VAT_category_code"/></span></div>
                        <div class="boxdaten rechnungSp2"></div>
                        <div class="boxdaten rechnungSp3"></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt93"/><xsl:if test="$showIds"> BT-93</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-93" title="BT-93" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:Document_level_allowance_base_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 line1Bottom"><xsl:value-of select="$i18n?bt94"/><xsl:if test="$showIds"> BT-94</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2 line1Bottom"></div>
                        <div id="BT-94" title="BT-94" class="boxdaten rechnungSp3 line1Bottom"><xsl:value-of select="xr:Document_level_allowance_percentage"/>%</div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt92"/><xsl:if test="$showIds"> BT-92</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-92" title="BT-92" class="boxdaten rechnungSp3 bold"><xsl:value-of select="format-number(xr:Document_level_allowance_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt96"/><xsl:if test="$showIds"> BT-96</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-96" title="BT-96" class="boxdaten rechnungSp3"><xsl:value-of select="xr:Document_level_allowance_VAT_rate"/></div>
                    </div>
                </div>
                <div class="grund">
                    <div><xsl:value-of select="$i18n?bt97"/><xsl:if test="$showIds"> BT-97</xsl:if>: <span id="BT-97" title="BT-97" class="bold"><xsl:value-of select="xr:Document_level_allowance_reason"/></span></div>
                    <div><xsl:value-of select="$i18n?bt98"/><xsl:if test="$showIds"> BT-98</xsl:if>: <span id="BT-98" title="BT-98" class="bold"><xsl:value-of select="xr:Document_level_allowance_reason_code"/></span></div>
                </div>
            </div>
        </div>
        <div class="boxabstand"></div>
    </xsl:template>


    <xsl:template name="uebersichtZuschlaege" match="xr:DOCUMENT_LEVEL_CHARGES">
        <div class="boxzeile">
            <div id="uebersichtZuschlaege" class="box">
                <div id="BG-21" title="BG-21" class="boxtitel"><xsl:value-of select="$i18n?bg21"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 bold"><xsl:value-of select="$i18n?bt102"/><xsl:if test="$showIds"> BT-102</xsl:if>: <span title="BT-102"><xsl:value-of select="xr:Document_level_charge_VAT_category_code"/></span></div>
                        <div class="boxdaten rechnungSp2"></div>
                        <div class="boxdaten rechnungSp3"></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt100"/><xsl:if test="$showIds"> BT-100</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-100" title="BT-100" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:Document_level_charge_base_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 line1Bottom"><xsl:value-of select="$i18n?bt101"/><xsl:if test="$showIds"> BT-101</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2 line1Bottom"></div>
                        <div id="BT-101" title="BT-101" class="boxdaten rechnungSp3 line1Bottom"><xsl:value-of select="xr:Document_level_charge_percentage"/>%</div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt99"/><xsl:if test="$showIds"> BT-99</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-99" title="BT-99" class="boxdaten rechnungSp3 bold"><xsl:value-of select="format-number(xr:Document_level_charge_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n?bt103"/><xsl:if test="$showIds"> BT-103</xsl:if></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-103" title="BT-103" class="boxdaten rechnungSp3"><xsl:value-of select="xr:Document_level_charge_VAT_rate"/></div>
                    </div>
                </div>
                <div class="grund">
                    <div><xsl:value-of select="$i18n?bt104"/><xsl:if test="$showIds"> BT-104</xsl:if>: <span id="BT-104" title="BT-104" class="bold"><xsl:value-of select="xr:Document_level_charge_reason"/></span></div>
                    <div><xsl:value-of select="$i18n?bt105"/><xsl:if test="$showIds"> BT-105</xsl:if>: <span id="BT-105" title="BT-105" class="bold"><xsl:value-of select="xr:Document_level_charge_reason_code"/></span></div>
                </div>
            </div>
        </div>
        <div class="boxabstand"></div>
    </xsl:template>


    <xsl:template name="uebersichtZahlungsinformationen">
        <xsl:if test="fn:not($isOrder)">
        <div id="uebersichtZahlungsinformationen" class="box subBox">
            <div title="" class="boxtitel"><xsl:value-of select="$i18n?payment"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt20"/><xsl:if test="$showIds"> BT-20</xsl:if>:</div>
                    <div id="BT-20" title="BT-20" class="boxdaten wert">
                        <xsl:for-each select="tokenize(xr:Payment_terms,';')">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt9"/><xsl:if test="$showIds"> BT-9</xsl:if>:</div>
                    <div id="BT-9" title="BT-9" class="boxdaten wert">
                        <xsl:for-each select="tokenize(xr:Payment_due_date,';')">
                            <xsl:value-of select="format-date(xs:date(.),'[D].[M].[Y]')"/>
                            <xsl:if test="position() != last()">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt81"/><xsl:if test="$showIds"> BT-81</xsl:if>:</div>
                    <div id="BT-81" title="BT-81" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_type_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt82"/><xsl:if test="$showIds"> BT-82</xsl:if>:</div>
                    <div id="BT-82" title="BT-82" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_text"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt83"/><xsl:if test="$showIds"> BT-83</xsl:if>:</div>
                    <div id="BT-83" title="BT-83" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Remittance_information"/></div>
                </div>
            </div>
        </div>
        </xsl:if>

    </xsl:template>


    <xsl:template name="uebersichtCard">
        <xsl:if test="fn:not($isOrder)">
        <div id="uebersichtCard" class="box subBox">
            <div id="BG-18" title="BG-18" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n?bg18"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt87"/><xsl:if test="$showIds"> BT-87</xsl:if>:</div>
                    <div id="BT-87" title="BT-87" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_primary_account_number"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt88"/><xsl:if test="$showIds"> BT-88</xsl:if>:</div>
                    <div id="BT-88" title="BT-88" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_holder_name"/></div>
                </div>
            </div>
        </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="uebersichtLastschrift">
        <xsl:if test="fn:not($isOrder)">
        <div id="uebersichtLastschrift" class="box subBox">
            <div id="BG-19" title="BG-19" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n?bg19"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt89"/><xsl:if test="$showIds"> BT-89</xsl:if>:</div>
                    <div id="BT-89" title="BT-89" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Mandate_reference_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt91"/><xsl:if test="$showIds"> BT-91</xsl:if>:</div>
                    <div id="BT-91" title="BT-91" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Debited_account_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt90"/><xsl:if test="$showIds"> BT-90</xsl:if>:</div>
                    <div id="BT-90" title="BT-90" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Bank_assigned_creditor_identifier"/></div>
                </div>
            </div>
        </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="uebersichtUeberweisung">
        <xsl:if test="fn:not($isOrder)">
        <div id="uebersichtUeberweisung" class="box subBox">
            <div id="BG-17" title="BG-17" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n?bg17"/></div>
            <xsl:for-each select="xr:PAYMENT_INSTRUCTIONS/xr:CREDIT_TRANSFER">
                <div class="boxtabelle boxinhalt borderSpacing">
                    <div class="boxzeile">
                        <div class="boxdaten legende"><xsl:value-of select="$i18n?bt85"/><xsl:if test="$showIds"> BT-85</xsl:if>:</div>
                        <div id="BT-85" title="BT-85" class="boxdaten wert"><xsl:value-of select="xr:Payment_account_name"/></div>
                    </div>
                    <div class="boxzeile">
                        <div class="boxdaten legende"><xsl:value-of select="$i18n?bt84"/><xsl:if test="$showIds"> BT-84</xsl:if>:</div>
                        <div id="BT-84" title="BT-84" class="boxdaten wert"><xsl:value-of select="xr:Payment_account_identifier"/></div>
                    </div>
                    <div class="boxzeile">
                        <div class="boxdaten legende"><xsl:value-of select="$i18n?bt86"/><xsl:if test="$showIds"> BT-86</xsl:if>:</div>
                        <div id="BT-86" title="BT-86" class="boxdaten wert"><xsl:value-of select="xr:Payment_service_provider_identifier"/></div>
                    </div>
                </div>
            </xsl:for-each>
        </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="uebersichtBemerkungen" match="xr:INVOICE_NOTE">
        <div id="uebersichtBemerkungen" class="box">
            <div id="BG-1" title="BG-1" class="boxtitel"><xsl:value-of select="$i18n?bg1"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt21"/><xsl:if test="$showIds"> BT-21</xsl:if>:</div>
                    <div id="BT-21" title="BT-21" class="boxdaten wert"><xsl:value-of select="xr:Invoice_note_subject_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt22"/><xsl:if test="$showIds"> BT-22</xsl:if>:</div>
                    <div id="BT-22" title="BT-22" class="boxdaten wert"><xsl:value-of select="xr:Invoice_note"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="details">
        <div id="details" class="divHide">
            <h2 class="printHeading"><xsl:value-of select="$i18n?items"/></h2>
            <div class="haftungausschluss"><xsl:value-of select="$i18n?disclaimer"/></div>
            <xsl:apply-templates select="./xr:INVOICE_LINE"/> <!-- many -->
        </div>
    </xsl:template>


    <xsl:template match="xr:INVOICE_LINE | xr:SUB_INVOICE_LINE">
        <div class="boxtabelle boxabstandtop boxtabelleZweispaltig first">
            <div class="boxzeile">
                <div class="box subBox">
                    <div id="BT-126" title="BT-126" class="boxtitel"><xsl:value-of select="$i18n?bt126"/><xsl:if test="$showIds"> BT-126</xsl:if> <xsl:value-of select="xr:Invoice_line_identifier"/></div>
                    <div class="boxtabelle boxinhalt borderSpacing">
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n?bt127"/><xsl:if test="$showIds"> BT-127</xsl:if>:</div>
                            <div id="BT-127" title="BT-127" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_note"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n?bt128"/><xsl:if test="$showIds"> BT-128</xsl:if>:</div>
                            <div id="BT-128" title="BT-128" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_object_identifier"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n?bt128-id"/><xsl:if test="$showIds"> BT-128-ID</xsl:if>:</div>
                            <div id="BT-128-scheme-id" title="BT-128-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_object_identifier/@scheme_identifier"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n?bt132"/><xsl:if test="$showIds"> BT-132</xsl:if>:</div>
                            <div id="BT-132" title="BT-132" class="boxdaten wert"><xsl:value-of select="xr:Referenced_purchase_order_line_reference"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n?bt133"/><xsl:if test="$showIds"> BT-133</xsl:if>:</div>
                            <div id="BT-133" title="BT-133" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_Buyer_accounting_reference"/></div>
                        </div>
                        <h4 id="BG-26" title="BG-26"><xsl:value-of select="$i18n?bg26"/><xsl:if test="$showIds"> BT-26</xsl:if>:</h4>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n?bt134"/><xsl:if test="$showIds"> BT-134</xsl:if>:</div>
                            <div id="BT-134" title="BT-134" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date,'[D].[M].[Y]')"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n?bt135"/><xsl:if test="$showIds"> BT-135</xsl:if>:</div>
                            <div id="BT-135" title="BT-135" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date,'[D].[M].[Y]')"/></div>
                        </div>
                    </div>
                </div>
                <div class="box subBox">
                    <div id="BG-29" title="BG-29" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n?bg29"/></div>
                    <div class="boxtabelle boxinhalt">
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n?bt129"/><xsl:if test="$showIds"> BT-129</xsl:if></div>
                            <div id="BT-129" title="BT-129" class="boxdaten detailSp2"><xsl:value-of select="xr:Invoiced_quantity"/></div>
                        </div>
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n?bt130"/><xsl:if test="$showIds"> BT-130</xsl:if></div>
                            <div id="BT-130" title="BT-130" class="boxdaten detailSp2"><xsl:value-of select="xr:Invoiced_quantity_unit_of_measure_code"/></div>
                        </div>
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 line1Bottom color2"><xsl:value-of select="$i18n?bt146"/><xsl:if test="$showIds"> BT-146</xsl:if></div>
                            <div id="BT-146" title="BT-146" class="boxdaten detailSp2 line1Bottom"><xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_net_price,'###.##0,00','decimal')"/></div>
                        </div>
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n?bt131"/><xsl:if test="$showIds"> BT-131</xsl:if></div>
                            <div id="BT-131" title="BT-131" class="boxdaten detailSp2 bold"><xsl:value-of select="format-number(xr:Invoice_line_net_amount,'###.##0,00','decimal')"/></div>
                        </div>
                    </div>
                    <div class="boxtabelle boxinhalt noPaddingTop borderSpacing">
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n?bt147"/><xsl:if test="$showIds"> BT-147</xsl:if>:</div>
                            <div id="BT-147" title="BT-147" class="boxdaten wert"><xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_price_discount,'###.##0,00','decimal')"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n?bt148"/><xsl:if test="$showIds"> BT-148</xsl:if>:</div>
                            <div id="BT-148" title="BT-148" class="boxdaten wert"><xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_gross_price,'###.##0,00','decimal')"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n?bt149"/><xsl:if test="$showIds"> BT-149</xsl:if>:</div>
                            <div id="BT-149" title="BT-149" class="boxdaten wert"><xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n?bt150"/><xsl:if test="$showIds"> BT-150</xsl:if>:</div>
                            <div id="BT-150" title="BT-150" class="boxdaten wert"><xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity_unit_of_measure"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n?bt151"/><xsl:if test="$showIds"> BT-151</xsl:if>:</div>
                            <div id="BT-151" title="BT-151" class="boxdaten wert"><xsl:value-of select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_category_code"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n?bt152"/><xsl:if test="$showIds"> BT-152</xsl:if>:</div>
                            <div id="BT-152" title="BT-152" class="boxdaten wert"><xsl:value-of select="format-number(xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_rate,'##0,##','decimal')"/>%</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="boxtabelle">
            <div class="boxzeile">
                <div class="box subBox">
                    <div id="BG-27" title="BG-27" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n?bg27"/></div>
                    <xsl:for-each select = "xr:INVOICE_LINE_ALLOWANCES">
                        <div class="boxtabelle boxinhalt ">
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n?bt137"/><xsl:if test="$showIds"> BT-137</xsl:if></div>
                                <div id="BT-137" title="BT-137" class="boxdaten detailSp2"><xsl:value-of select="format-number(xr:Invoice_line_allowance_base_amount,'###.##0,00','decimal')"/></div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 line1Bottom color2"><xsl:value-of select="$i18n?bt138"/><xsl:if test="$showIds"> BT-138</xsl:if></div>
                                <div id="BT-138" title="BT-138" class="boxdaten detailSp2 line1Bottom"><xsl:value-of select="format-number(xr:Invoice_line_allowance_percentage,'##0,00','decimal')"/>%</div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n?bt136"/><xsl:if test="$showIds"> BT-136</xsl:if></div>
                                <div id="BT-136" title="BT-136" class="boxdaten detailSp2 bold"><xsl:value-of select="format-number(xr:Invoice_line_allowance_amount,'###.##0,00','decimal')"/></div>
                            </div>
                        </div>
                        <div class="grundDetail">
                            <div class="color2"><xsl:value-of select="$i18n?bt139"/><xsl:if test="$showIds"> BT-139</xsl:if>: <span id="BT-139" title="BT-139" class="bold"><xsl:value-of select="xr:Invoice_line_allowance_reason"/></span></div>
                            <div class="color2"><xsl:value-of select="$i18n?bt140"/><xsl:if test="$showIds"> BT-140</xsl:if>: <span id="BT-140" title="BT-140" class="bold"><xsl:value-of select="xr:Invoice_line_allowance_reason_code"/></span></div>
                        </div>
                    </xsl:for-each>
                </div>
                <div class="box subBox">
                    <div id="BG-28" title="BG-28" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n?bg28"/></div>
                    <xsl:for-each select = "xr:INVOICE_LINE_CHARGES">
                        <div class="boxtabelle boxinhalt ">
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n?bt142"/><xsl:if test="$showIds"> BT-142</xsl:if></div>
                                <div id="BT-142" title="BT-142" class="boxdaten detailSp2"><xsl:value-of select="format-number(xr:Invoice_line_charge_base_amount,'###.##0,00','decimal')"/></div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 line1Bottom color2"><xsl:value-of select="$i18n?bt143"/><xsl:if test="$showIds"> BT-143</xsl:if></div>
                                <div id="BT-143" title="BT-143" class="boxdaten detailSp2 line1Bottom"><xsl:value-of select="format-number(xr:Invoice_line_charge_percentage,'##0,00','decimal')"/>%</div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n?bt141"/><xsl:if test="$showIds"> BT-141</xsl:if></div>
                                <div id="BT-141" title="BT-141" class="boxdaten detailSp2 bold"><xsl:value-of select="format-number(xr:Invoice_line_charge_amount,'###.##0,00','decimal')"/></div>
                            </div>
                        </div>
                        <div class="grundDetail">
                            <div class="color2"><xsl:value-of select="$i18n?bt144"/><xsl:if test="$showIds"> BT-144</xsl:if>: <span id="BT-144" title="BT-144" class="bold"><xsl:value-of select="xr:Invoice_line_charge_reason"/></span></div>
                            <div class="color2"><xsl:value-of select="$i18n?bt145"/><xsl:if test="$showIds"> BT-145</xsl:if>: <span id="BT-145" title="BT-145" class="bold"><xsl:value-of select="xr:Invoice_line_charge_reason_code"/></span></div>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </div>
        <div class="boxtabelle">
            <div class="boxzeile">
                <div class="box subBox">
                    <div id="BG-31" title="BG-31" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n?bg31"/></div>
                    <div class="boxtabelle boxinhalt ">
                        <div class="boxzeile">
                            <div class="boxcell boxZweispaltig">
                                <div class="boxtabelle borderSpacing">
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt153"/><xsl:if test="$showIds"> BT-153</xsl:if>:</div>
                                        <div id="BT-153" title="BT-153" class="boxdaten wert bold"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_name"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt154"/><xsl:if test="$showIds"> BT-154</xsl:if>:</div>
                                        <div id="BT-154" title="BT-154" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_description"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt155"/><xsl:if test="$showIds"> BT-155</xsl:if>:</div>
                                        <div id="BT-155" title="BT-155" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt156"/><xsl:if test="$showIds"> BT-156</xsl:if>:</div>
                                        <div id="BT-156" title="BT-156" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Buyers_identifier"/></div>
                                    </div>
                                    <h4 id="BG-32" title="BG-32"><xsl:value-of select="$i18n?bg32"/>:</h4>
                                    <xsl:apply-templates select="xr:ITEM_INFORMATION/xr:ITEM_ATTRIBUTES" />
                                </div>
                            </div>
                            <div class="boxabstand"></div>
                            <div class="boxcell boxZweispaltig">
                                <div class="boxtabelle borderSpacing">
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt157"/><xsl:if test="$showIds"> BT-157</xsl:if>:</div>
                                        <div id="BT-157" title="BT-157" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_standard_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt157-id"/><xsl:if test="$showIds"> BT-157-ID</xsl:if>:</div>
                                        <div id="BT-157-scheme-id" title="BT-157-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_standard_identifier/@scheme_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt158"/><xsl:if test="$showIds"> BT-158</xsl:if>:</div>
                                        <div id="BT-158" title="BT-158" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_classification_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt158-id"/><xsl:if test="$showIds"> BT-158-ID</xsl:if>:</div>
                                        <div id="BT-158-scheme-id" title="BT-158-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_classification_identifier/@scheme_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt157-vers-id"/><xsl:if test="$showIds"> BT-157-VERS-ID</xsl:if>:</div>
                                        <div id="BT-158-scheme-version-id" title="BT-158-scheme-version-id" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_classification_identifier/@scheme_version_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n?bt159"/><xsl:if test="$showIds"> BT-159</xsl:if>:</div>
                                        <div id="BT-159" title="BT-159" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_country_of_origin"/></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <xsl:apply-templates select="xr:SUB_INVOICE_LINE"/>
    </xsl:template>

    <xsl:template name="eigenschaft" match="xr:ITEM_ATTRIBUTES">
        <div class="boxzeile">
            <div id="BT-160" title="BT-160" class="boxdaten legende "><xsl:if test="$showIds"> BT-160</xsl:if><xsl:value-of select="xr:Item_attribute_name"/></div>
            <div id="BT-161" title="BT-161" class="boxdaten wert"><xsl:if test="$showIds"> BT-161</xsl:if><xsl:value-of select="xr:Item_attribute_value"/></div>
        </div>
    </xsl:template>

    <xsl:template name="sub_invoice_eigenschaft" match="xr:SUB_INVOICE_ITEM_ATTRIBUTES">
        <div class="boxzeile">
            <div id="BT-160" title="BT-160" class="boxdaten legende "><xsl:if test="$showIds"> BT-160</xsl:if><xsl:value-of select="xr:Item_attribute_name"/></div>
            <div id="BT-161" title="BT-161" class="boxdaten wert"><xsl:if test="$showIds"> BT-161</xsl:if><xsl:value-of select="xr:Item_attribute_value"/></div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetze">
        <div id="zusaetze" class="divHide">
            <h2 class="printHeading"><xsl:value-of select="$i18n?information"/></h2>
            <div class="haftungausschluss"><xsl:value-of select="$i18n?disclaimer"/></div>
            <div class="boxtabelle boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:SELLER" mode="zusaetze"/>
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:SELLER_TAX_REPRESENTATIVE_PARTY"/>
                </div>
            </div>
            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:BUYER" mode="zusaetze"/>
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:DELIVERY_INFORMATION"/>
                </div>
            </div>
            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:call-template name="zusaetzeVertrag"/>
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:PAYEE"/>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeVerkaeufer" match="xr:SELLER" mode="zusaetze">
        <div id="zusaetzeVerkaeufer" class="box boxZweispaltig">
            <div id="BG-4" title="BG-4" class="boxtitel"><xsl:value-of select="$i18n?bg4"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt28"/><xsl:if test="$showIds"> BT-28</xsl:if>:</div>
                    <div id="BT-28" title="BT-28" class="boxdaten wert"><xsl:value-of select="xr:Seller_trading_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt39"/><xsl:if test="$showIds"> BT-39</xsl:if>:</div>
                    <div id="BT-39" title="BT-39" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt34"/><xsl:if test="$showIds"> BT-34</xsl:if>:</div>
                    <div id="BT-34" title="BT-34" class="boxdaten wert"><xsl:value-of select="xr:Seller_electronic_address"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt34-id"/><xsl:if test="$showIds"> BT-34-ID</xsl:if>:</div>
                    <div id="BT-34-scheme-id" title="BT-34-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Seller_electronic_address/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt30"/><xsl:if test="$showIds"> BT-30</xsl:if>:</div>
                    <div id="BT-30" title="BT-30" class="boxdaten wert"><xsl:value-of select="xr:Seller_legal_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt31"/><xsl:if test="$showIds"> BT-31</xsl:if>:</div>
                    <div id="BT-31" title="BT-31" class="boxdaten wert"><xsl:value-of select="xr:Seller_VAT_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt32"/><xsl:if test="$showIds"> BT-32</xsl:if>:</div>
                    <div id="BT-32" title="BT-32" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt32-schema"/><xsl:if test="$showIds"> BT-32-SCHEMA</xsl:if>:</div>
                    <div id="BT-32-scheme" title="BT-32-scheme" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_registration_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt33"/><xsl:if test="$showIds"> BT-33</xsl:if>:</div>
                    <div id="BT-33" title="BT-33" class="boxdaten wert"><xsl:value-of select="xr:Seller_additional_legal_information"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt6"/><xsl:if test="$showIds"> BT-6</xsl:if>:</div>
                    <div id="BT-6" title="BT-6" class="boxdaten wert"><xsl:value-of select="../xr:VAT_accounting_currency_code"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeSteuervertreter" match="xr:SELLER_TAX_REPRESENTATIVE_PARTY">
        <div id="zusaetzeSteuervertreter" class="box boxZweispaltig">
            <div id="BG-11" title="BG-11" class="boxtitel"><xsl:value-of select="$i18n?bg11"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt62"/><xsl:if test="$showIds"> BT-62</xsl:if>:</div>
                    <div id="BT-62" title="BT-62" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_representative_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt64"/><xsl:if test="$showIds"> BT-64</xsl:if>:</div>
                    <div id="BT-64" title="BT-64" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt65"/><xsl:if test="$showIds"> BT-65</xsl:if>:</div>
                    <div id="BT-65" title="BT-65" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt164"/><xsl:if test="$showIds"> BT-164</xsl:if>:</div>
                    <div id="BT-164" title="BT-164" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt67"/><xsl:if test="$showIds"> BT-67</xsl:if>:</div>
                    <div id="BT-67" title="BT-67" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt66"/><xsl:if test="$showIds"> BT-66</xsl:if>:</div>
                    <div id="BT-66" title="BT-66" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt68"/><xsl:if test="$showIds"> BT-68</xsl:if>:</div>
                    <div id="BT-68" title="BT-68" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt69"/><xsl:if test="$showIds"> BT-69</xsl:if>:</div>
                    <div id="BT-69" title="BT-69" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt63"/><xsl:if test="$showIds"> BT-63</xsl:if>:</div>
                    <div id="BT-63" title="BT-63" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_representative_VAT_identifier"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeKaeufer" match="xr:BUYER" mode="zusaetze">
        <div id="zusaetzeKaeufer" class="box boxZweispaltig">
            <div id="BG-7" title="BG-7" class="boxtitel"><xsl:value-of select="$i18n?bg7"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt45"/><xsl:if test="$showIds"> BT-45</xsl:if>:</div>
                    <div id="BT-45" title="BT-45" class="boxdaten wert"><xsl:value-of select="xr:Buyer_trading_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt54"/><xsl:if test="$showIds"> BT-54</xsl:if>:</div>
                    <div id="BT-54" title="BT-54" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt49"/><xsl:if test="$showIds"> BT-49</xsl:if>:</div>
                    <div id="BT-49" title="BT-49" class="boxdaten wert"><xsl:value-of select="xr:Buyer_electronic_address"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt49-id"/><xsl:if test="$showIds"> BT-49-ID</xsl:if>:</div>
                    <div id="BT-49-scheme-id" title="BT-49-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Buyer_electronic_address/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt47"/><xsl:if test="$showIds"> BT-47</xsl:if>:</div>
                    <div id="BT-47" title="BT-47" class="boxdaten wert"><xsl:value-of select="xr:Buyer_legal_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt47-id"/><xsl:if test="$showIds"> BT-47-ID</xsl:if>:</div>
                    <div id="BT-47-scheme-id" title="BT-47-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Buyer_legal_registration_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt48"/><xsl:if test="$showIds"> BT-48</xsl:if>:</div>
                    <div id="BT-48" title="BT-48" class="boxdaten wert"><xsl:value-of select="xr:Buyer_VAT_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt7"/><xsl:if test="$showIds"> BT-7</xsl:if>:</div>
                    <div id="BT-7" title="BT-7" class="boxdaten wert">
                        <xsl:for-each select="tokenize(../xr:Value_added_tax_point_date,';')">
                            <xsl:value-of select="format-date(xs:date(.),'[D].[M].[Y]')"/>
                            <xsl:if test="position() != last()">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt8"/><xsl:if test="$showIds"> BT-8</xsl:if>:</div>
                    <div id="BT-8" title="BT-8" class="boxdaten wert"><xsl:value-of select="../xr:Value_added_tax_point_date_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt19"/><xsl:if test="$showIds"> BT-19</xsl:if>:</div>
                    <div id="BT-19" title="BT-19" class="boxdaten wert"><xsl:value-of select="../xr:Buyer_accounting_reference"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeLieferung" match="xr:DELIVERY_INFORMATION">
        <div id="zusaetzeLieferung" class="box boxZweispaltig">
            <div id="BG-13" title="BG-13" class="boxtitel"><xsl:value-of select="$i18n?bg13"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt71"/><xsl:if test="$showIds"> BT-71</xsl:if>:</div>
                    <div id="BT-71" title="BT-71" class="boxdaten wert"><xsl:value-of select="xr:Deliver_to_location_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt71-id"/><xsl:if test="$showIds"> BT-71-ID</xsl:if>:</div>
                    <div id="BT-71-scheme-id" title="BT-71-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Deliver_to_location_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt72"/><xsl:if test="$showIds"> BT-72</xsl:if>:</div>
                    <div id="BT-72" title="BT-72" class="boxdaten wert"><xsl:value-of select="format-date(xr:Actual_delivery_date,'[D].[M].[Y]')"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt70"/><xsl:if test="$showIds"> BT-70</xsl:if>:</div>
                    <div id="BT-70" title="BT-70" class="boxdaten wert"><xsl:value-of select="xr:Deliver_to_party_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt75"/><xsl:if test="$showIds"> BT-75</xsl:if>:</div>
                    <div id="BT-75" title="BT-75" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt76"/><xsl:if test="$showIds"> BT-76</xsl:if>:</div>
                    <div id="BT-76" title="BT-76" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt165"/><xsl:if test="$showIds"> BT-165</xsl:if>:</div>
                    <div title="BT-165" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt78"/><xsl:if test="$showIds"> BT-78</xsl:if>:</div>
                    <div id="BT-78" title="BT-78" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt77"/><xsl:if test="$showIds"> BT-77</xsl:if>:</div>
                    <div id="BT-77" title="BT-77" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt79"/><xsl:if test="$showIds"> BT-79</xsl:if>:</div>
                    <div id="BT-79" title="BT-79" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt80"/><xsl:if test="$showIds"> BT-80</xsl:if>:</div>
                    <div id="BT-80" title="BT-80" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_code"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeVertrag">
        <div id="zusaetzeVertrag" class="box boxZweispaltig">
            <div class="boxtitel"><xsl:value-of select="$i18n?contract_information"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt17"/><xsl:if test="$showIds"> BT-17</xsl:if>:</div>
                    <div id="BT-17" title="BT-17" class="boxdaten wert"><xsl:value-of select="xr:Tender_or_lot_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt15"/><xsl:if test="$showIds"> BT-15</xsl:if>:</div>
                    <div id="BT-15" title="BT-15" class="boxdaten wert"><xsl:value-of select="xr:Receiving_advice_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt16"/><xsl:if test="$showIds"> BT-16</xsl:if>:</div>
                    <div id="BT-16" title="BT-16" class="boxdaten wert"><xsl:value-of select="xr:Despatch_advice_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt23"/><xsl:if test="$showIds"> BT-23</xsl:if>:</div>
                    <div id="BT-23" title="BT-23" class="boxdaten wert"><xsl:value-of select="xr:PROCESS_CONTROL/xr:Business_process_type"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt24"/><xsl:if test="$showIds"> BT-24</xsl:if>:</div>
                    <div id="BT-24" title="BT-24" class="boxdaten wert"><xsl:value-of select="xr:PROCESS_CONTROL/xr:Specification_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt18"/><xsl:if test="$showIds"> BT-18</xsl:if>:</div>
                    <div id="BT-18" title="BT-18" class="boxdaten wert"><xsl:value-of select="xr:Invoiced_object_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt18-id"/><xsl:if test="$showIds"> BT-18-ID</xsl:if>:</div>
                    <div id="BT-18-scheme-id" title="BT-18-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Invoiced_object_identifier/@scheme_identifier"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeZahlungsempfaenger" match="xr:PAYEE">
        <div id="zusaetzeZahlungsempfaenger" class="box boxZweispaltig">
            <div id="BG-10" title="BG-10" class="boxtitel"><xsl:value-of select="$i18n?bg10"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt59"/><xsl:if test="$showIds"> BT-59</xsl:if>:</div>
                    <div id="BT-59" title="BT-59" class="boxdaten wert"><xsl:value-of select="xr:Payee_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt60"/><xsl:if test="$showIds"> BT-60</xsl:if>:</div>
                    <div id="BT-60" title="BT-60" class="boxdaten wert"><xsl:value-of select="xr:Payee_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt60-id"/><xsl:if test="$showIds"> BT-60-ID</xsl:if>:</div>
                    <div id="BT-60-scheme-id" title="BT-60-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Payee_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt61"/><xsl:if test="$showIds"> BT-61</xsl:if>:</div>
                    <div id="BT-61" title="BT-61" class="boxdaten wert"><xsl:value-of select="xr:Payee_legal_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n?bt61-id"/><xsl:if test="$showIds"> BT-61-ID</xsl:if>:</div>
                    <div id="BT-61-scheme-id" title="BT-61-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Payee_legal_registration_identifier/@scheme_identifier"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="anlagen">
        <div id="anlagen" class="divHide">
            <h2 class="printHeading"><xsl:value-of select="$i18n?attachments"/></h2>
            <div class="haftungausschluss"><xsl:value-of select="$i18n?disclaimer"/></div>
            <div class="boxtabelle boxabstandtop">
                <div class="boxzeile">
                    <div id="anlagenListe" class="box">
                        <div id="BG-24" title="BG-24" class="boxtitel"><xsl:value-of select="$i18n?bg24"/></div>
                        <xsl:apply-templates select="./xr:ADDITIONAL_SUPPORTING_DOCUMENTS"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template match="xr:ADDITIONAL_SUPPORTING_DOCUMENTS">
        <div class="boxtabelle boxinhalt borderSpacing">
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt122"/><xsl:if test="$showIds"> BT-122</xsl:if>:</div>
                <div id="BT-122" title="BT-122" class="boxdaten wert"><xsl:value-of select="xr:Supporting_document_reference"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt123"/><xsl:if test="$showIds"> BT-123</xsl:if>:</div>
                <div id="BT-123" title="BT-123" class="boxdaten wert"><xsl:value-of select="xr:Supporting_document_description"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt124"/><xsl:if test="$showIds"> BT-124</xsl:if>:</div>
                <div id="BT-124" title="BT-124" class="boxdaten wert"><a href="{xr:External_document_location}"><xsl:value-of select="xr:External_document_location"/></a></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt125"/><xsl:if test="$showIds"> BT-125</xsl:if>:</div>
                <div id="BT-125" title="BT-125" class="boxdaten wert">
                    <a href="#"
                       onClick="downloadData('{xr:Supporting_document_reference}')">Öffnen</a>
                </div>
                <div id="{xr:Supporting_document_reference}"
                     mimetype="{xr:Attached_document/@mime_code}"
                     filename="{xr:Attached_document/@filename}"
                     style="display:none;"
                ><xsl:value-of select="xr:Attached_document"/></div>

            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt125-format"/><xsl:if test="$showIds"> BT-125</xsl:if>:</div>
                <div id="BT-125" title="BT-125" class="boxdaten wert"><xsl:value-of select="xr:Attached_document/@mime_code"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?bt125-name"/><xsl:if test="$showIds"> BT-125</xsl:if>:</div>
                <div id="BT-125" title="BT-125" class="boxdaten wert"><xsl:value-of select="xr:Attached_document/@filename"/></div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="laufzettel">
        <div id="laufzettel" class="divHide">
            <h2 class="printHeading"><xsl:value-of select="$i18n?history"/></h2>
            <div class="boxtabelle boxabstandtop">
                <div class="boxzeile">
                    <div id="laufzettelHistorie" class="box">
                        <div class="boxtitel"><xsl:value-of select="$i18n?history"/></div>
                        <xsl:apply-templates select="./xrv:laufzettel/xrv:laufzettelEintrag"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template match="xrv:laufzettelEintrag">
        <div class="boxtabelle boxinhalt borderSpacing">
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?historyDate"/></div>
                <div class="boxdaten wert"><xsl:value-of select="format-dateTime(xrv:zeitstempel,'[D].[M].[Y] [H]:[m]:[s]')"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?historySubject"/>:</div>
                <div class="boxdaten wert"><xsl:value-of select="xrv:betreff"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?historyText"/>:</div>
                <div class="boxdaten wert"><xsl:value-of select="xrv:text"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n?historyDetails"/>:</div>
                <div class="boxdaten wert"><xsl:value-of select="xrv:details"/></div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
