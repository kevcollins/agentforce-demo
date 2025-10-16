public with sharing class KnowledgeFaqController {
  @AuraEnabled(cacheable=true)
  public static List<Knowledge__kav> getFaqs() {
    return [
      SELECT Id, Title, UrlName, LastPublishedDate, Summary, Body__c
      FROM Knowledge__kav
      WHERE PublishStatus = 'Online' AND Language = 'en_US'
      ORDER BY LastPublishedDate DESC
      LIMIT 20
    ];
  }
}
