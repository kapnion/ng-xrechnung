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

      const secondStylesheetUrl = '/xrechnung-html.uni.sef.json';
      const secondStylesheet = await this.http.get(secondStylesheetUrl, { responseType: 'text' }).toPromise();

      const secondResult = await SaxonJS.transform({
        stylesheetText: secondStylesheet,
        sourceText: xrXML,
        destination: 'serialized',
        stylesheetParams: {
          "isOrder": false, // Update this based on your logic
          "showIds": false, // Update this based on your logic
          "Q{}i18n": {} // Update this based on your logic
        }
      }, 'async');

      this.transformedContent = this.sanitizer.bypassSecurityTrustHtml(secondResult.principalResult);
      debugger;
    } catch (error) {
      console.error('Error transforming XML:', error);
    }
  }

  displayError(message: string, detail: string): void {
    console.error(`${message}: ${detail}`);
  }
}
