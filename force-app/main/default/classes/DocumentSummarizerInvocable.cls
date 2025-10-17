public with sharing class DocumentSummarizerInvocable {
  @InvocableMethod(
    label='Summarize Document by Title'
    description='Finds the most recent ContentVersion by Title and returns a safe, dev-org-friendly summary placeholder.'
    category='Documents'
  )
  public static List<OutputParameters> summarizeByTitle(
    List<InputParameters> inputs
  ) {
    List<OutputParameters> results = new List<OutputParameters>();

    for (InputParameters input : inputs) {
      OutputParameters out = new OutputParameters();

      if (String.isBlank(input.documentTitle)) {
        out.summary = 'No title provided.';
        results.add(out);
        continue;
      }

      ContentVersion v = [
        SELECT Title
        FROM ContentVersion
        WHERE Title = :input.documentTitle
        ORDER BY CreatedDate DESC
        LIMIT 1
      ];

      // Dev-edition-safe placeholder. Replace with real parsing/LLM later if desired.
      out.summary =
        'Summary for "' +
        v.Title +
        '": (demo) key points extracted.';
      results.add(out);
    }
    return results;
  }

  public class InputParameters {
    @InvocableVariable(
      label='Document Title'
      description='Title of the file to summarize (matches ContentVersion.Title).'
      required=true
    )
    public String documentTitle;
  }

  public class OutputParameters {
    @InvocableVariable(
      label='Summary'
      description='A concise, human-readable summary of the document content.'
    )
    public String summary;
  }
}
