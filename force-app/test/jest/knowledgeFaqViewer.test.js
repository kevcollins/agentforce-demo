import { createElement } from "lwc";
import KnowledgeFaqViewer from "c/knowledgeFaqViewer";
import getFaqs from "@salesforce/apex/KnowledgeFaqController.getFaqs";
import { registerApexTestWireAdapter } from "@salesforce/sfdx-lwc-jest";

const getFaqsAdapter = registerApexTestWireAdapter(getFaqs);

const MOCK_FAQS = [
  {
    id: "1",
    question: "What is AgentForce?",
    answer: "<p>AgentForce is a demo app.</p>"
  },
  {
    id: "2",
    question: "How do I get started?",
    answer: "<p>Install and run the app.</p>"
  }
];

describe("c-knowledge-faq-viewer", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  it("renders accordion sections when Apex returns data", async () => {
    const element = createElement("c-knowledge-faq-viewer", {
      is: KnowledgeFaqViewer
    });
    document.body.appendChild(element);

    getFaqsAdapter.emit(MOCK_FAQS);
    await Promise.resolve();

    const sections = element.shadowRoot.querySelectorAll(
      "lightning-accordion-section"
    );
    expect(sections.length).toBe(MOCK_FAQS.length);

    // lightning base components don't always reflect attributes or labels in the
    // test DOM. Verify the DOM contains the per-item container where the answer
    // would be inserted.
    const itemContainer = element.shadowRoot.querySelector('[data-id="1"]');
    expect(itemContainer).not.toBeNull();
  });

  it("renders empty state when Apex returns an empty array", async () => {
    const element = createElement("c-knowledge-faq-viewer", {
      is: KnowledgeFaqViewer
    });
    document.body.appendChild(element);

    getFaqsAdapter.emit([]);
    await Promise.resolve();

    const noFaqHeading = element.shadowRoot.querySelector("h3");
    expect(noFaqHeading).not.toBeNull();
    expect(noFaqHeading.textContent).toContain("No FAQs found");
  });

  it("shows an error message when Apex returns an error", async () => {
    const element = createElement("c-knowledge-faq-viewer", {
      is: KnowledgeFaqViewer
    });
    document.body.appendChild(element);

    getFaqsAdapter.error();
    await Promise.resolve();

    const errorDiv = element.shadowRoot.querySelector(
      ".slds-notify.slds-theme_error"
    );
    expect(errorDiv).not.toBeNull();
    expect(errorDiv.textContent).toContain("An error occurred loading FAQs.");
  });
});
