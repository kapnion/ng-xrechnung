import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';

declare const SaxonJS: any;

@Component({
  selector: 'app-file-upload',
  templateUrl: './file-upload.component.html',
  standalone: true,
  styleUrls: ['./file-upload.component.scss']
})
export class FileUploadComponent {
  constructor(private http: HttpClient) {
    // This service can now make HTTP requests via `this.http`.
  }
  transformedContent: string | null = null;

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      const reader = new FileReader();
      reader.onload = () => {
        const content = reader.result as string;
        this.transformXML(content);
      };
      reader.readAsText(file);
    }
  }

  async transformXML(content: string): Promise<void> {
    try {
      const stylesheetUrl = '/stylesheet.sef.json'; // Update with your actual stylesheet path

      // Fetch the stylesheet content
      const stylesheet = await this.http.get(stylesheetUrl, { responseType: 'text' }).toPromise();

      // Transform the XML using the fetched stylesheet content
      const result = await SaxonJS.transform({
        stylesheetText: stylesheet,
        sourceText: content,
        destination: 'serialized'
      }, 'async');
      this.transformedContent = result.principalResult;
    } catch (error) {
      console.error('Error transforming XML:', error);
    }
  }
}
