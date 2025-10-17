public with sharing class QuoteRetrieverDmo {
  @AuraEnabled(cacheable=true)
  public static List<Map<String, Object>> getQuotes(
    String productType,
    Decimal maxDeposit
  ) {
    if (String.isBlank(productType))
      return new List<Map<String, Object>>();

    List<Financial_Rate_Quote__dlm> rows;

    if (maxDeposit != null) {
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
          Product_Type__c = :productType
          AND Minimum_Deposit__c <= :maxDeposit
        ORDER BY Interest_Rate__c DESC NULLS LAST
        LIMIT 10
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
        WHERE Product_Type__c = :productType
        ORDER BY Interest_Rate__c DESC NULLS LAST
        LIMIT 10
      ];
    }

    List<Map<String, Object>> out = new List<Map<String, Object>>();
    for (Financial_Rate_Quote__dlm r : rows) {
      out.add(
        new Map<String, Object>{
          'Quote_Reference' => r.Quote_Reference__c,
          'Product_Type' => r.Product_Type__c,
          'Term' => r.Term__c,
          'Branch_City' => r.Branch_City__c,
          'Currency' => r.Currency__c,
          'Minimum_Deposit' => r.Minimum_Deposit__c,
          'Interest_Rate' => r.Interest_Rate__c,
          'Promotional_Description' => r.Promotional_Description__c,
          'Valid_Until' => r.Valid_Until__c
        }
      );
    }
    return out;
  }
}
