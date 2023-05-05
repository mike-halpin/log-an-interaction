@isTest(isParallel=true)
public class FlowGetOrCreateContact_Test {
    @TestSetup
    public static void makePrerequisiteData() {
      createTestAccount();
      createTestContact();
    }
    public static void createTestAccount() {
      Account testAccount = new Account();
      testAccount.Name = 'prerequisite account';
      insert testAccount;
    }
    static Account getPrerequisiteAccount() {
      return [SELECT Id, Name, npe01__One2OneContact__c  FROM Account LIMIT 1];
    }
    public static void createTestContact(){
      Contact testContact = new Contact();
      testContact.FirstName = 'prerequisite contact';
      testContact.LastName = 'contact';
      testContact.Email = 'email@email.com';
      testContact.OtherPhone = '1234567890';
      testContact.AccountId = FlowGetOrCreateContact_Test.getPrerequisiteAccount().Id;
      insert testContact;
    }
    static Contact getTestContact() {
      return [SELECT Id, FirstName, LastName, Email, OtherPhone, AccountId FROM Contact LIMIT 1];
    }
    static Map<String, Object> getTestContactMap() {
      Map<String, Object> params = new Map<String, Object>(); 
      params.put('email', null);
      params.put('finalContactId', null);
      params.put('firstName', null);
      params.put('lastName', null);
      params.put('phone', null);
      return params;
    }    
    static String getContactEmail() {
      return getTestContact().Email;
    }
    static String getContactFirstName() {
      return getTestContact().FirstName;
    }
    static String getContactLastName() {
      return getTestContact().LastName;
    }
    static String getContactPhone() {
      return getTestContact().OtherPhone;
    }
    static String getContactId() {
      return getTestContact().Id;
    }

    @isTest
    static void testNewContactSuccess() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('firstName', FlowGetOrCreateContact_Test.getContactFirstname());
      params.put('lastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('phone', FlowGetOrCreateContact_Test.getContactPhone());
      params.put('email', FlowGetOrCreateContact_Test.getContactEmail());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      flowTest.start();
      Test.stopTest();
      System.Assert.isNotNull(flowTest.contact.Id); 
      System.Assert.isNotNull(flowTest.contact.FirstName);
      System.Assert.isNotNull(flowTest.contact.LastName);
      System.Assert.isNotNull(flowTest.contact.Email);
      System.Assert.isNotNull(flowTest.contact.OtherPhone);
    }
    @isTest
    static void testNewContactNullFirstName() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('lastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('phone', FlowGetOrCreateContact_Test.getContactPhone());
      params.put('email', FlowGetOrCreateContact_Test.getContactEmail());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      try {
        flowTest.start();
      }
      catch (FlowException e) {
      System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
      System.Assert(e.getMessage().contains('FirstName'));
      }
      Test.stopTest();
    }
    @isTest
    static void testNewContactNullLastName() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('firstName', FlowGetOrCreateContact_Test.getContactFirstName());
      params.put('phone', FlowGetOrCreateContact_Test.getContactPhone());
      params.put('email', FlowGetOrCreateContact_Test.getContactEmail());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      try {
        flowTest.start();
      }
      catch (FlowException e) {
      System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
      System.Assert(e.getMessage().contains('LastName'));
      }
      Test.stopTest();
    }
    @isTest
    static void testNewContactNullPhone() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('lastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('firstName', FlowGetOrCreateContact_Test.getContactFirstName());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      flowTest.start(); 
      System.Assert.isNull(flowTest.contact.OtherPhone);
      Test.stopTest();
    }
    @isTest
    static void testNewContactNullEmail() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('lastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('firstName', FlowGetOrCreateContact_Test.getContactFirstName());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      flowTest.start(); 
      System.Assert.isNull(flowTest.contact.Email);
      Test.stopTest();
      }
}



