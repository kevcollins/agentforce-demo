public with sharing class QuoteRetriever {
  @AuraEnabled(cacheable=true)
  public static List<Map<String, Object>> getQuotes(String productType) {
    return QuoteService.getQuotes(productType);
  }
}
