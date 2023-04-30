@isTest(isParallel=true)
public class FlowGetOrCreateAccount_Test {
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
    static Contact getTestContact() {
      return [SELECT Id, Name, AccountId FROM Contact LIMIT 1];
    }
    static Account getPrerequisiteAccount() {
      return [SELECT Id, Name, npe01__One2OneContact__c  FROM Account LIMIT 1];
    }
        public static void createTestContact(){
        Contact testContact = new Contact();
        testContact.FirstName = 'prerequisite contact';
        testContact.LastName = 'contact';
        testContact.AccountId = FlowGetOrCreateAccount_Test.getAccountId();
        insert testContact;
    }
     public static void createTestContactWithNullAccountId() {
        Contact testContact = new Contact();
        testContact.FirstName = 'prerequisite contact';
        testContact.LastName = 'contact';
        testContact.AccountId = null;
        insert testContact;
    }
    static Map<String, Object> getPrerequisiteAccountMap() {
      Map<String, Object> params = new Map<String, Object>(); 
      params.put('accountId', null);
      params.put('accountName', null);
      params.put('usePrimaryAccount', false);
      params.put('contact', FlowGetOrCreateAccount_Test.getTestContact());
      return params;
    }    
    static Map<String, Object> getPrerequisiteAccountMapWithNullContactAccountId() {
        //createTestContactWithNullAccountId();
        Contact testContact = FlowGetOrCreateAccount_Test.getTestContact();
        testContact.AccountId = null;
        Map<String, Object> params = new Map<String, Object>(); 
        params.put('accountId', null);
        params.put('accountName', null);
        params.put('usePrimaryAccount', false);
        params.put('contact', testContact);
        return params;
    }

    static String getAccountId() {
      return getPrerequisiteAccount().Id;
    }
    static String getAccountName() {
      return getPrerequisiteAccount().Name;
    }
    static Boolean getUsePrimaryAccount() {
      return true;
    }
    @isTest
    static void testNewAccountSuccess() {
      Map<String, Object> params = FlowGetOrCreateAccount_Test.getPrerequisiteAccountMap(); 
      params.put('usePrimaryAccount', FlowGetOrCreateAccount_Test.getUsePrimaryAccount());
      params.put('accountName', FlowGetOrCreateAccount_Test.getAccountName());
      Test.startTest();
      Flow.Interview.MHGetOrCreateAccount flowTest = new Flow.Interview.MHGetOrCreateAccount(params);
      flowTest.start();
      System.debug('Debug flowTest.account');
      System.debug(flowTest.account);
      System.Assert.isNotNull(flowTest.account.Id); 
      System.Assert.isNotNull(flowTest.account.Name);
      Test.stopTest();
    }
    @isTest
    static void testNewAccountNullName() {
      Map<String, Object> params = FlowGetOrCreateAccount_Test.getPrerequisiteAccountMap(); 
      Test.startTest();
      Flow.Interview.MHGetOrCreateAccount flowTest = new Flow.Interview.MHGetOrCreateAccount(params);
      try {
      flowTest.start();
      }
      catch (FlowException e) {
      System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
      System.Assert(e.getMessage().contains('Name'));
      }
      Test.stopTest();
    }

    @isTest
    static void testAccountIsContactPrimary() {
        Map<String, Object> params = FlowGetOrCreateAccount_Test.getPrerequisiteAccountMap(); 
        params.put('usePrimaryAccount', FlowGetOrCreateAccount_Test.getUsePrimaryAccount());
        params.put('accountId', FlowGetOrCreateAccount_Test.getTestContact().AccountId); 
        Test.startTest();
        Flow.Interview.MHGetOrCreateAccount flowTest = new Flow.Interview.MHGetOrCreateAccount(params); 
        try {
            flowTest.start();
        } catch (FlowException e) {
            System.debug(e.getMessage());
            System.Assert.fail(); 
        } finally {
            // Assert that accountId from the flowTest matches the accountId of the contact
            System.assertEquals(FlowGetOrCreateAccount_Test.getTestContact().AccountId, flowTest.account.Id);
        }
        
        Test.stopTest();
    }
    @isTest
    static void testAccountIdMatchesWhenContactAccountIdIsNull() {
        Map<String, Object> params = FlowGetOrCreateAccount_Test.getPrerequisiteAccountMapWithNullContactAccountId(); 
        params.put('accountId', FlowGetOrCreateAccount_Test.getAccountId()); 
        Test.startTest();
        Flow.Interview.MHGetOrCreateAccount flowTest = new Flow.Interview.MHGetOrCreateAccount(params);
        
        try {
            flowTest.start();
        } catch (FlowException e) {
            System.debug(e.getMessage());
            System.Assert.fail(); 
        } finally {
            System.assertEquals(FlowGetOrCreateAccount_Test.getAccountId(), flowTest.account.Id);
        }
        
        Test.stopTest();
    }
}



