import { LightningElement, wire, track } from "lwc";
import getFaqs from "@salesforce/apex/KnowledgeFaqController.getFaqs";

export default class KnowledgeFaqViewer extends LightningElement {
  @track faqs = [];
  @track error;

  @wire(getFaqs)
  wiredFaqs({ data, error }) {
    if (data) this.faqs = data;
    if (error) this.error = error;
  }
}
