public with sharing class HelloWorld {
  @InvocableMethod(
    label='Hello World'
    description='Takes a name and returns a greeting message'
  )
  public static List<OutputParameters> sayHello(List<InputParameters> inputs) {
    List<OutputParameters> outputs = new List<OutputParameters>();

    for (InputParameters input : inputs) {
      OutputParameters output = new OutputParameters();
      output.greeting = 'Hello, ' + input.name + '!';
      outputs.add(output);
    }

    return outputs;
  }

  public class InputParameters {
    @InvocableVariable(
      required=true
      label='Name'
      description='The name of the person to greet'
    )
    public String name;
  }

  public class OutputParameters {
    @InvocableVariable(label='Greeting' description='The greeting message')
    public String greeting;
  }
}
