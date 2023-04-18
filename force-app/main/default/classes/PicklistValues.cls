public class PicklistValues {
    public class InputParameters {
        @InvocableVariable(label='Object Name' required=true)
        public String objectName;

        @InvocableVariable(label='Field Name' required=true)
        public String fieldName;
    }

    public class OutputParameters {
        @InvocableVariable(label='Picklist Values')
        public List<String> picklistValues;
    }

    @InvocableMethod(label='Get Picklist Values' description='Returns the picklist values as a list of strings')
    public static List<OutputParameters> getPicklistValues(List<InputParameters> inputList) {
        InputParameters input = inputList[0];
        String objectName = input.objectName;
        String fieldName = input.fieldName;

        List<String> picklistValues = new List<String>();
        Schema.SObjectType objectSchema = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult objectDescribe = objectSchema.getDescribe();
        Schema.SObjectField field = objectDescribe.fields.getMap().get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

        for (Schema.PicklistEntry entry : fieldDescribe.getPicklistValues()) {
            picklistValues.add(entry.getLabel());
        }

        OutputParameters output = new OutputParameters();
        output.picklistValues = picklistValues;
        return new List<OutputParameters>{output};
    }
}