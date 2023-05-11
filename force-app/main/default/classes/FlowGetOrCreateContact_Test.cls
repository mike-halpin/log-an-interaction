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
      testContact.Phone = '1234567890';
      testContact.AccountId = FlowGetOrCreateContact_Test.getPrerequisiteAccount().Id;
      insert testContact;
    }
    static Contact getTestContact() {
      return [SELECT Id, FirstName, LastName, Email, Phone, AccountId FROM Contact LIMIT 1];
    }
    static Map<String, Object> getTestContactMap() {
      Map<String, Object> params = new Map<String, Object>(); 
      params.put('newEmail', null);
      params.put('finalContactId', null);
      params.put('newFirstName', null);
      params.put('newLastName', null);
      params.put('newPhone', null);
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
      return getTestContact().Phone;
    }
    static String getContactId() {
      return getTestContact().Id;
    }

    @isTest
    static void testNewContactSuccess() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('newFirstName', FlowGetOrCreateContact_Test.getContactFirstname());
      params.put('newLastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('newPhone', FlowGetOrCreateContact_Test.getContactPhone());
      params.put('newEmail', FlowGetOrCreateContact_Test.getContactEmail());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      flowTest.start();
      Test.stopTest();
      System.Assert.isNotNull(flowTest.contact.Id); 
      System.Assert.isNotNull(flowTest.contact.FirstName);
      System.Assert.isNotNull(flowTest.contact.LastName);
      System.Assert.isNotNull(flowTest.contact.Email);
      System.Assert.isNotNull(flowTest.contact.Phone);
    }
    @isTest
    static void testNewContactNullFirstName() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('newLastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('newPhone', FlowGetOrCreateContact_Test.getContactPhone());
      params.put('newEmail', FlowGetOrCreateContact_Test.getContactEmail());
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
      params.put('newFirstName', FlowGetOrCreateContact_Test.getContactFirstName());
      params.put('newPhone', FlowGetOrCreateContact_Test.getContactPhone());
      params.put('newEmail', FlowGetOrCreateContact_Test.getContactEmail());
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
      params.put('newLastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('newFirstName', FlowGetOrCreateContact_Test.getContactFirstName());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      flowTest.start(); 
      System.Assert.isNull(flowTest.contact.Phone);
      Test.stopTest();
    }
    @isTest
    static void testNewContactNullEmail() {
      Map<String, Object> params = FlowGetOrCreateContact_Test.getTestContactMap(); 
      params.put('newLastName', FlowGetOrCreateContact_Test.getContactLastname());
      params.put('newFirstName', FlowGetOrCreateContact_Test.getContactFirstName());
      Test.startTest();
      Flow.Interview.MHGetOrCreateContact flowTest = new Flow.Interview.MHGetOrCreateContact(params);
      flowTest.start(); 
      System.Assert.isNull(flowTest.contact.Email);
      Test.stopTest();
      }
}




