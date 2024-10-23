import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';


declare const SaxonJS: any;

@Component({
  selector: 'app-file-upload',
  templateUrl: './file-upload.component.html',
  standalone: true,
  styleUrls: ['./file-upload.component.scss']
})
export class FileUploadComponent {
  transformedContent: SafeHtml | null = null;

  constructor(private http: HttpClient, private sanitizer: DomSanitizer) {}

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      const reader = new FileReader();
      reader.onload = () => {
        const content = reader.result as string;
        this.loadAndTransformXML(content);
      };
      reader.readAsText(file);
    }
  }

  loadAndTransformXML(content: string): void {
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(content, "application/xml");
    const rootElement = xmlDoc.documentElement.nodeName;

    let stylesheetUrl = '';
    if (rootElement.includes("CrossIndustryInvoice")) {
      stylesheetUrl = '/cii-xr.sef.json';
    } else if (rootElement.includes("SCRDMCCBDACIOMessageStructure")) {
      stylesheetUrl = '/cio-xr.sef.json';
    } else if (rootElement.includes("Invoice")) {
      stylesheetUrl = '/ubl-xr.sef.json';
    } else if (rootElement.includes("CreditNote")) {
      stylesheetUrl = '/ubl-creditnote-xr.sef.json';
    } else {
      this.displayError(
        "File format not recognized",
        "Is it a UBL 2.1 or UN/CEFACT 2016b XML file or PDF you are trying to open?"
      );
      return;
    }

    this.http.get(stylesheetUrl, { responseType: 'text' }).subscribe(
      (stylesheet) => {
        this.transformXML(content, stylesheet);
      },
      (error) => {
        console.error('Error loading stylesheet:', error);
      }
    );
  }

  async transformXML(content: string, stylesheet: string): Promise<void> {
    try {
      const firstResult = await SaxonJS.transform({
        stylesheetText: stylesheet,
        sourceText: content,
        destination: 'serialized'
      }, 'async');

      const xrXML = firstResult.principalResult;

      const secondStylesheetUrl = '/xrechnung-html.uni.sef.2.json';
      const secondStylesheet = await this.http.get(secondStylesheetUrl, { responseType: 'text' }).toPromise();

      // Translations JSON
      const translations = {
        "File": "Datei",
        "Print": "Drucken",
        "Exit": "Beenden",
        "Edit": "Bearbeiten",
        "Help": "Hilfe",
        "About": "Info",
        "Open File": "Datei öffnen",
        "Language": "Sprachen",
        "English": "Englisch ",
        "Cut": "Ausschneiden",
        "Copy": "Kopieren",
        "Paste": "Einfügen",
        "Delete": "Löschen",
        "Select all": "Alle auswählen",
        "appName": "E-Rechnungs-Viewer",
        "Login": "Anmeldung",
        "Logout": "Abmeldung",
        "Validate": "Validieren",
        "Demo User": "Demo-Benutzer",
        "Username": "Benutzername",
        "Password": "Passwort",
        "Privacy Policy": "Datenschutzbestimmungen",
        "Subscription": "Abonnement",
        "Accept": "Akzeptieren",
        "en": "Englisch",
        "de": "Deutsch",
        "fr": "Französisch",
        "privacyPolicyText": "Bitte validieren Sie nur anonymisierte Testdaten ohne Angaben zur Person (Absender, Empfänger, Bankverbindung), es sei denn, Sie haben ein Abonnement mit Vertrag zur Auftragsdatenverarbeitung.",
        "version": "Version",
        "Show IDs": "Zeige IDs",
        "bt10": "Leitweg-ID",
        "bt44": "Name",
        "title": "XRechnung",
        "overview": "Übersicht",
        "items": "Positionen",
        "information": "Informationen",
        "attachments": "Anhänge",
        "history": "Bearbeitungshistorie",
        "disclaimer": "Wir übernehmen keine Haftung für die Richtigkeit der Daten.",
        "recipientInfo": "Informationen zum Käufer",
        "bt51": "Postfach",
        "bt50": "Straße / Haus-Nr.",
        "bt163": "Adresszusatz",
        "bt53": "PLZ",
        "bt52": "Ort",
        "bt54": "Bundesland",
        "bt55": "Land",
        "bt46": "Kennung / Kunden-Nr.",
        "bt46-id": "Schema der Kennung",
        "bt56": "Name",
        "bt57": "Telefon",
        "bt58": "E-Mail-Adresse",
        "bt27": "Firmenname",
        "bt35": "Straße / Haus-Nr.",
        "bt36": "Postfach",
        "bt162": "Adresszusatz",
        "bt38": "PLZ",
        "bt37": "Ort",
        "bt39": "Bundesland",
        "bt40": "Ländercode",
        "bt29": "Kennung",
        "bt29-id": "Schema der Kennung",
        "bt41": "Name",
        "bt42": "Telefon",
        "bt43": "E-Mail-Adresse",
        "bt1": "Rechnungsnummer",
        "bt1_order": "Bestellnummer",
        "bt2": "Rechnungsdatum",
        "bt2_order": "Bestelldatum",
        "details": "Rechnungsdaten",
        "details_order": "Bestelldaten",
        "period": "Abrechnungszeitraum",
        "bt3": "Rechnungsart",
        "bt3_order": "Dokumentart",
        "bt5": "Währung",
        "bt73": "von",
        "bt74": "bis",
        "bt11": "Projektnummer",
        "bt12": "Vertragsnummer",
        "bt13": "Bestellnummer",
        "bt14": "Auftragsnummer",
        "bt25": "Rechnungsnummer",
        "bt25_order": "Bestellnummer",
        "bt26": "Rechnungsdatum",
        "bt26_order": "Bestelldatum",
        "bg22": "Gesamtbeträge der Rechnung",
        "bg22_order": "Gesamtbeträge der Bestellung",
        "bt106": "Summe aller Positionen",
        "bt107": "Summe Nachlässe",
        "bt108": "Summe Zuschläge",
        "bt109": "Gesamtsumme",
        "bt110": "Summe Umsatzsteuer",
        "bt111": "Summe Umsatzsteuer in Abrechnungswährung",
        "bt112": "Gesamtsumme",
        "bt113": "Gezahlter Betrag",
        "bt114": "Rundungsbetrag",
        "bt115": "Fälliger Betrag",
        "bg23": "Aufschlüsselung der Umsatzsteuer auf Ebene der Rechnung",
        "bt118": "Umsatzsteuerkategorie",
        "bt116": "Gesamtsumme",
        "bt119": "Umsatzsteuersatz",
        "bt117": "Umsatzsteuerbetrag",
        "bt120": "Befreiungsgrund",
        "bt121": "Kennung für den Befreiungsgrund",
        "bg20": "Nachlass auf Ebene der Rechnung",
        "bt95": "Umsatzsteuerkategorie des Nachlasses",
        "bt93": "Grundbetrag",
        "bt94": "Prozentsatz",
        "bt92": "Nachlass",
        "bt96": "Umsatzsteuersatz des Nachlasses",
        "bt97": "Grund für den Nachlass",
        "bt98": "Document level allowance reason code",
        "bg21": "Zuschlag auf Ebene der Rechnung",
        "bt102": "Umsatzsteuerkategorie des Zuschlages",
        "bt100": "Grundbetrag",
        "bt101": "Prozentsatz",
        "bt99": "Zuschlag",
        "bt103": "Umsatzsteuersatz des Zuschlages",
        "bt104": "Grund für den Zuschlag",
        "bt105": "Document level charge reason code",
        "bt20": "Skonto; weitere Zahlungsbed.",
        "bt9": "Fälligkeitsdatum",
        "bt81": "Code für das Zahlungsmittel",
        "bt82": "Zahlungsmittel",
        "bt83": "Verwendungszweck",
        "bg18": "Karteninformation",
        "bt87": "Kartennummer",
        "bt88": "Karteninhaber",
        "bg19": "Lastschrift",
        "bt89": "Mandatsreferenznr.",
        "bt91": "IBAN",
        "bt90": "Gläubiger-ID",
        "bg17": "Überweisung",
        "bt85": "Kontoinhaber",
        "bt84": "IBAN",
        "bt86": "BIC",
        "bg1": "Bemerkung zur Rechnung",
        "bt21": "Betreff",
        "bt22": "Bemerkung",
        "bt126": "Position",
        "bt127": "Freitext",
        "bt128": "Objektkennung",
        "bt128-id": "Schema der Objektkennung",
        "bt132": "Nummer der Auftragsposition",
        "bt133": "Kontierungshinweis /Kostenstelle",
        "bg26": "Abrechnungszeitraum",
        "bt134": "von",
        "bt135": "bis",
        "bg29": "Preiseinzelheiten",
        "bt129": "Menge",
        "bt130": "Einheit",
        "bt146": "Preis pro Einheit (netto)",
        "bt131": "Gesamtpreis (netto)",
        "bt147": "Rabatt (netto)",
        "bt148": "Listenpreis (brutto)",
        "bt149": "Anzahl der Einheit",
        "bt150": "Code der Maßeinheit",
        "bt151": "Umsatzsteuer",
        "bt152": "Umsatzsteuersatz in %",
        "bg27": "Nachlässe auf Ebene der Rechnungsposition",
        "bt137": "Grundbetrag (netto)",
        "bt138": "Prozentsatz",
        "bt136": "Nachlass",
        "bt139": "Grund des Nachlasses",
        "bt140": "Code für den Nachlassgrund",
        "bg28": "Zuschläge auf Ebene der Rechnungsposition",
        "bt142": "Grundbetrag (netto)",
        "bt143": "Prozentsatz",
        "bt141": "Zuschlag (netto)",
        "bt144": "Grund des Zuschlags",
        "bt145": "Code für den Zuschlagsgrund",
        "bg31": "Artikelinformationen",
        "bt153": "Bezeichnung",
        "bt154": "Beschreibung",
        "bt155": "Artikelnummer",
        "bt156": "Kunden-Material-Nr.",
        "bg32": "Eigenschaften des Artikels",
        "bt157": "Artikelkennung (EAN)",
        "bt157-id": "Schema der Artikelkennung",
        "bt158": "Code der Artikelklassifizierung",
        "bt158-id": "Kennung zur Bildung des Schemas",
        "bt157-vers-id": "Version zur Bildung des Schemas",
        "bt159": "Code des Herkunftslandes",
        "bg4": "Informationen zum Verkäufer",
        "bt28": "Abweichender Handelsname",
        "bt34": "Elektronische Adresse",
        "bt34-id": "Schema der elektronischen Adresse",
        "bt30": "Register-/Registriernummer",
        "bt31": "Umsatzsteuer-ID",
        "bt32": "Steuernummer",
        "bt32-schema": "Schema der Steuernummer",
        "bt33": "Weitere rechtliche Informationen",
        "bt6": "Code der Umsatzsteuerwährung",
        "bg11": "Steuervertreter des Verkäufers",
        "bt62": "Name",
        "bt64": "Straße / Hausnummer",
        "bt65": "Postfach",
        "bt164": "Adresszusatz",
        "bt67": "PLZ",
        "bt66": "Ort",
        "bt68": "Bundesland",
        "bt69": "Ländercode",
        "bt63": "Umsatzsteuer-ID",
        "bg7": "Informationen zum Käufer",
        "bt45": "Abweichender Handelsname",
        "bt49": "Elektronische Adresse",
        "bt49-id": "Schema der elektronischen Adresse",
        "bt47": "Register-/Registriernummer",
        "bt47-id": "Schema der Register-/Registriernummer",
        "bt48": "Umsatzsteuer-ID",
        "bt7": "Abrechnungsdatum der Umsatzsteuer",
        "bt8": "Code des Umsatzsteuer-Abrechnungsdatums",
        "bt19": "Kontierungsinformation / Kostenstelle",
        "bg13": "Lieferinformationen",
        "bt71": "Kennung des Lieferorts",
        "bt71-id": "Schema der Kennung",
        "bt72": "Lieferdatum",
        "bt70": "Name des Empfängers",
        "bt75": "Straße / Haus-Nr.",
        "bt76": "Postfach",
        "bt165": "Adresszusatz",
        "bt78": "PLZ",
        "bt77": "Ort",
        "bt79": "Bundesland",
        "bt80": "Land",
        "bt17": "Vergabenummer",
        "bt15": "Kennung der Empfangsbestätigung",
        "bt16": "Kennung der Versandanzeige",
        "bt23": "Prozesskennung",
        "bt24": "Spezifikationskennung",
        "bt18": "Objektkennung",
        "bt18-id": "Schema der Objektkennung",
        "bg10": "Vom Verkäufer abweichender Zahlungsempfänger",
        "bt59": "Name",
        "bt60": "Kennung",
        "bt60-id": "Schema der Kennung",
        "bt61": "Register-/Registriernummer",
        "bt61-id": "Schema der Register-/Registriernummer",
        "bg24": "Rechnungsbegründende Unterlagen",
        "bt122": "Kennung",
        "bt123": "Beschreibung",
        "bt124": "Verweis (z.B. Internetadresse)",
        "bt125": "Anhangsdokument",
        "bt125-format": "Format des Anhangdokuments",
        "bt125-name": "Name des Anhangdokuments",
        "historyDate": "Datum/Uhrzeit",
        "historySubject": "Betreff",
        "historyText": "Text",
        "historyDetails": "Details",
        "licenseText": "Apache 2 Lizenz",
        "payment": "Zahlungsdaten",
        "contract_information": "Vertragsdaten",
        "preceding_invoice_reference": "Vorausgegangene Rechnungen"
      };

      const isOrder = false; // Update this based on your logic

      if (isOrder) {
        translations["bt1"] = "Bestellnummer";
        translations["bt2"] = "Bestelldatum";
        translations["bt3"] = "Dokumentart";
        translations["bg22"] = "Gesamtbeträge der Bestellung";
        translations["bt25"] = "Bestellnummer";
        translations["bt26"] = "Bestelldatum";
        translations["details"] = "Bestelldaten";
      }

      const secondResult = await SaxonJS.transform({
        stylesheetText: secondStylesheet,
        sourceText: xrXML,
        destination: 'serialized',
        stylesheetParams: {
          "isOrder": isOrder,
          "showIds": false, // Update this based on your logic
          "Q{}i18n": translations
        }
      }, 'async');

      this.transformedContent = this.sanitizer.bypassSecurityTrustHtml(secondResult.principalResult);
    } catch (error) {
      console.error('Error transforming XML:', error);
    }
  }

  displayError(message: string, detail: string): void {
    console.error(`${message}: ${detail}`);
  }
}
