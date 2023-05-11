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
      params.put('newAccountName', null);
      params.put('existingAccountName', null);
      params.put('usePrimaryAccount', false);
      params.put('contact', FlowGetOrCreateAccount_Test.getTestContact());
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
      params.put('newAccountName', FlowGetOrCreateAccount_Test.getAccountName());
      Test.startTest();
      Flow.Interview.MHGetOrCreateAccount flowTest = new Flow.Interview.MHGetOrCreateAccount(params);
      flowTest.start();
      System.Assert.isNotNull(flowTest.account.Id);
      System.Assert.areEqual(FlowGetOrCreateAccount_Test.getAccountName(), flowTest.account.Name);
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
        // The Contact.AccountId is should be used as the Account.Id
        Map<String, Object> params = FlowGetOrCreateAccount_Test.getPrerequisiteAccountMap(); 
        params.put('usePrimaryAccount', FlowGetOrCreateAccount_Test.getUsePrimaryAccount());
        Flow.Interview.MHGetOrCreateAccount flowTest = new Flow.Interview.MHGetOrCreateAccount(params); 
        try {
                Test.startTest();
            flowTest.start();
                    Test.stopTest();

        } catch (FlowException e) {
            System.debug(e.getMessage());
            System.Assert.fail(); 
        } finally {
            // Assert that accountId from the flowTest matches the accountId of the contact
            System.Assert.areEqual(FlowGetOrCreateAccount_Test.getTestContact().AccountId, flowTest.account.Id);
        }
        
    }
    @isTest
    static void testAccountIdMatchesAccountId() {
        Map<String, Object> params = FlowGetOrCreateAccount_Test.getPrerequisiteAccountMap(); 
        params.put('accountId', FlowGetOrCreateAccount_Test.getAccountId());
        params.put('existingAccountName', FlowGetOrCreateAccount_Test.getAccountName());

        Test.startTest();
        Flow.Interview.MHGetOrCreateAccount flowTest = new Flow.Interview.MHGetOrCreateAccount(params);
        
        try {
            flowTest.start();
        } catch (FlowException e) {
            System.debug(e.getMessage());
            System.Assert.fail(); 
        } finally {
            System.Assert.areEqual(FlowGetOrCreateAccount_Test.getAccountId(), flowTest.account.Id);
        }
        
        Test.stopTest();
    }
}



