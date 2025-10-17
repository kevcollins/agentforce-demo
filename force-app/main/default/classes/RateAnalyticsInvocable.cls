public with sharing class RateAnalyticsInvocable {
  @InvocableMethod(
    label='Analyze Rate Trends by City'
    description='Calculates the average Interest_Rate__c in the Financial_Rate_Quote__dlm DMO for a given branch city.'
    category='Analytics'
  )
  public static List<OutputParameters> analyzeByCity(
    List<InputParameters> inputs
  ) {
    List<OutputParameters> results = new List<OutputParameters>();

    for (InputParameters input : inputs) {
      OutputParameters out = new OutputParameters();

      if (String.isBlank(input.city)) {
        out.insight = 'No city provided.';
        out.averageRate = null;
        results.add(out);
        continue;
      }

      List<AggregateResult> ar = [
        SELECT AVG(Interest_Rate__c) a
        FROM Financial_Rate_Quote__dlm
        WHERE Branch_City__c = :input.city
      ];

      Decimal avg = (ar.isEmpty() ? null : (Decimal) ar[0].get('a'));
      out.averageRate = avg;
      out.insight = (avg == null)
        ? 'No rate data found for ' + input.city + '.'
        : 'Average interest rate in ' +
          input.city +
          ' is ' +
          String.valueOf(avg) +
          '%.';

      results.add(out);
    }
    return results;
  }

  public class InputParameters {
    @InvocableVariable(
      label='City'
      description='Branch city to use when aggregating interest rates (for example, "Houston").'
      required=true
    )
    public String city;
  }

  public class OutputParameters {
    @InvocableVariable(
      label='Insight'
      description='Readable sentence summarizing the average rate for the requested city.'
    )
    public String insight;

    @InvocableVariable(
      label='Average Rate'
      description='Numeric average of Interest_Rate__c for the requested city.'
    )
    public Decimal averageRate;
  }
}
