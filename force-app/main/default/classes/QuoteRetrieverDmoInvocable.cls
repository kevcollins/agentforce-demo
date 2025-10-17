public with sharing class QuoteRetrieverDmoInvocable {
  @InvocableMethod(
    label='Retrieve Financial Quotes (Enhanced DMO)'
    description='Retrieves financial rate quotes from Data Cloud based on product type, state address, and optional maximum deposit.'
    category='Financial Services'
  )
  public static List<OutputParameters> getFinancialQuotes(
    List<InputParameters> inputs
  ) {
    List<OutputParameters> results = new List<OutputParameters>();

    for (InputParameters input : inputs) {
      if (String.isBlank(input.productType)) {
        continue;
      }

      List<Financial_Rate_Quote__dlm> rows;

      if (input.maxDeposit != null) {
        rows = [
          SELECT
            Quote_Reference__c,
            Product_Type__c,
            Term__c,
            Branch_City__c,
            Currency__c,
            Minimum_Deposit__c,
            Interest_Rate__c,
            Promotional_Description__c,
            Valid_Until__c
          FROM Financial_Rate_Quote__dlm
          WHERE
            Product_Type__c = :input.productType
            AND Minimum_Deposit__c <= :input.maxDeposit
          ORDER BY Interest_Rate__c DESC NULLS LAST
          LIMIT 5
        ];
      } else {
        rows = [
          SELECT
            Quote_Reference__c,
            Product_Type__c,
            Term__c,
            Branch_City__c,
            Currency__c,
            Minimum_Deposit__c,
            Interest_Rate__c,
            Promotional_Description__c,
            Valid_Until__c
          FROM Financial_Rate_Quote__dlm
          WHERE Product_Type__c = :input.productType
          ORDER BY Interest_Rate__c DESC NULLS LAST
          LIMIT 5
        ];
      }

      for (Financial_Rate_Quote__dlm r : rows) {
        OutputParameters o = new OutputParameters();
        o.quoteReference = r.Quote_Reference__c;
        o.productType = r.Product_Type__c;
        o.term = r.Term__c;
        o.branchCity = r.Branch_City__c;
        o.quoteCurrency = r.Currency__c;
        o.minimumDeposit = r.Minimum_Deposit__c;
        o.interestRate = r.Interest_Rate__c;
        o.validUntil = r.Valid_Until__c;
        o.summary =
          'For ' +
          r.Product_Type__c +
          ' (' +
          r.Promotional_Description__c +
          ') ' +
          ' in ' +
          r.Branch_City__c +
          ', rate is ' +
          r.Interest_Rate__c +
          '% with min deposit ' +
          r.Minimum_Deposit__c +
          ' ' +
          r.Currency__c +
          ' valid until ' +
          r.Valid_Until__c.format();
        results.add(o);
      }
    }
    return results;
  }

  public class InputParameters {
    @InvocableVariable(
      label='Product Type'
      description='Indicates which financial product category the quote belongs to (Checking, Savings, CD, Loan). The agent can use this value to filter or summarize results.'
      required=true
    )
    public String productType;

    @InvocableVariable(
      label='State Address'
      description='Represents the state where the user is located or interested in. The U.S. state abbreviation (e.g., "TX", "CA") to filter quotes by branch location.'
      required=true
    )
    public Decimal stateAddress;

    @InvocableVariable(
      label='Maximum Deposit'
      description='Optional maximum deposit amount to filter results.'
      required=false
    )
    public Decimal maxDeposit;
  }

  public class OutputParameters {
    @InvocableVariable(
      label='Quote Reference'
      description='Represents the Unique Identifier of the Quote. Should be used by the agent to reference specific quotes when communicating with users.'
    )
    public String quoteReference;

    @InvocableVariable(
      label='Product Type'
      description='Indicates which financial product category the quote belongs to (Checking, Savings, CD, Loan). The agent can use this value to filter or summarize results.'
    )
    public String productType;

    @InvocableVariable(
      label='Summary'
      description='Free-text explanation of promotional terms or limited-time offers attached to the quote. Example: “3-Month introductory rate for new customers.”'
    )
    public String promotionalDescription;

    @InvocableVariable(
      label='Branch City'
      description='Specifies the branch city where the quote originates or applies. Useful when presenting region-specific rates. Format as plain city names (“Houston”, “Dallas”).'
    )
    public String branchCity;

    @InvocableVariable(
      label='Interest Rate'
      description='The percentage rate offered for the product. Show as a numeric value with up to two decimals (e.g., 3.25 %). The agent can verbalize this as “3.25 percent interest.”'
    )
    public Decimal interestRate;

    @InvocableVariable(
      label='Term'
      description='Shows the duration or maturity period for the quoted product. Express in months or years (for example, “12 Months” or “5 Years”).'
    )
    public String term;

    @InvocableVariable(
      label='Currency'
      description='Denotes the currency in which the quote values are expressed. Use standard ISO codes such as USD, CAD, GBP.'
    )
    public String quoteCurrency;

    @InvocableVariable(
      label='Minimum Deposit'
      description='Monetary value indicating the minimum deposit or balance required to qualify for the rate. Display as currency with two decimal places (e.g., $5,000.00).'
    )
    public Decimal minimumDeposit;

    @InvocableVariable(
      label='Valid Until'
      description='Represents the expiration date of the quote or offer. Display as a formatted date (MM/DD/YYYY). Example: “Valid until 12/31/2025.”'
    )
    public Date validUntil;

    @InvocableVariable(
      label='Summary'
      description='A concise summary of the quote combining key details for easy reference by the agent.'
    )
    public String summary;
  }
}
