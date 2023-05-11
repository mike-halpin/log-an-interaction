@isTest(isParallel=true)
public class MHLogInteractionOpportunitySubflow_Test {
  @TestSetup
  public static void makePrerequisiteData() {
    createTestAccount();
    createTestContact();
    createTestOpportunities();
  }
  public static void createTestAccount() {
    Account testAccount = new Account();
    testAccount.Name = 'prerequisite account';
    insert testAccount;
  }
  public static void createTestContact() {
    Contact testContact = new Contact();
    testContact.FirstName = 'prerequisite contact';
    testContact.LastName = 'contact';
    testContact.AccountId = getAccountId();
    insert testContact;
  }
  public static void createTestOpportunities() {
    Account testAccount = getPrerequisiteAccount();
    List<Opportunity> oppList = new List<Opportunity>();

    for (Integer i = 0; i < 5; i++) {
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity ' + i;
        opp.AccountId = testAccount.Id;
        opp.npsp__Primary_Contact__c = getPrerequisiteContact().Id;
        opp.CloseDate = Date.today().addMonths(1);
        opp.Amount = 1000.00;
        opp.isClosed = false;
        opp.StageName = 'Prospecting';
        if (i % 2 == 0) {
            opp.OwnerId = UserInfo.getUserId();
        }
        oppList.add(opp);
    }
    insert oppList;
  }
  static Account getPrerequisiteAccount() {
    return [SELECT Id, Name FROM Account LIMIT 1];
  }
  static Opportunity getOwnedOpportunity() {
    return [SELECT Id, Name, OwnerId FROM Opportunity WHERE OwnerId = :UserInfo.getUserId() LIMIT 1];
  }
  static Opportunity getNotOwnedOpportunity() {
    return [SELECT Id, Name, OwnerId FROM Opportunity WHERE OwnerId != :UserInfo.getUserId() LIMIT 1];
  }
  static Contact getPrerequisiteContact() {
    return [SELECT Id, FirstName, LastName, AccountId FROM Contact LIMIT 1];
  }
  static String getAccountId() {
    return getPrerequisiteAccount().Id;
  }
  @isTest
  static void Test() {
    // Prepare test data
    Account testAccount = getPrerequisiteAccount();
    Contact testContact = getPrerequisiteContact();
    
    Map<String, Object> params = new Map<String, Object>(); 
    params.put('AccountRecord', testAccount);
    params.put('ContactRecord', testContact);

    // Start test
    Test.startTest();
    Flow.Interview.MHLogInteractionOpportunitySubflow flowTest = new Flow.Interview.MHLogInteractionOpportunitySubflow(params);
    flowTest.start();
    Test.stopTest();

    // Assert the outputs
    System.Assert.isNotNull(flowTest.isOpportunityOwnedByUserCount);
    System.Assert.isNotNull(flowTest.notIsOpportunityOwnedByUserCount);
    System.Assert.isNotNull(flowTest.notUserOwnedOpportunitiesForScreen);
    System.Assert.isNotNull(flowTest.userOwnedOpportunitiesForScreen);
  }
  @isTest
  static void TestOutputCounts() {
    // Prepare test data
    Account testAccount = getPrerequisiteAccount();
    Contact testContact = getPrerequisiteContact();
    
    Map<String, Object> params = new Map<String, Object>(); 
    params.put('AccountRecord', testAccount);
    params.put('ContactRecord', testContact);

    // Start test
    Test.startTest();
    Flow.Interview.MHLogInteractionOpportunitySubflow flowTest = new Flow.Interview.MHLogInteractionOpportunitySubflow(params);
    flowTest.start();
    Test.stopTest();

    // Assert the output counts
    System.assertEquals(3, flowTest.isOpportunityOwnedByUserCount);
    System.assertEquals(2, flowTest.notIsOpportunityOwnedByUserCount);
    System.assertEquals(2, flowTest.notUserOwnedOpportunitiesForScreen.size());
    System.assertEquals(3, flowTest.userOwnedOpportunitiesForScreen.size());
  }
  @isTest
  static void TestNoOpportunities() {
        // Prepare test data
        Account testAccount = new Account();
        testAccount.Name = 'Test Account No Opp';
        insert testAccount;

        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact No Opp';
        testContact.AccountId = testAccount.Id;
        insert testContact;

        Map<String, Object> params = new Map<String, Object>(); 
        params.put('AccountRecord', testAccount);
        params.put('ContactRecord', testContact);

        // Start test
        Test.startTest();
        Flow.Interview.MHLogInteractionOpportunitySubflow flowTest = new Flow.Interview.MHLogInteractionOpportunitySubflow(params);
        flowTest.start();
        Test.stopTest();

        // Assert the output counts
        System.assertEquals(0, flowTest.isOpportunityOwnedByUserCount);
        System.assertEquals(0, flowTest.notIsOpportunityOwnedByUserCount);
        System.assertEquals(0, flowTest.notUserOwnedOpportunitiesForScreen.size());
        System.assertEquals(0, flowTest.userOwnedOpportunitiesForScreen.size());
    }
    @isTest
    static void TestNullAccount(){
    // Prepare test data
        Contact testContact = getPrerequisiteContact();
        
        Map<String, Object> params = new Map<String, Object>(); 
        params.put('AccountRecord', null);
        params.put('ContactRecord', testContact);

        // Start test
        Test.startTest();
        Flow.Interview.OpportunityOwnershipFlow flowTest = new Flow.Interview.OpportunityOwnershipFlow(params);

        // Assert that a FlowException is thrown with the expected error message
        try {
            flowTest.start();
        } catch (FlowException e) {
            System.assert(e.getMessage().contains('The AccountRecord input is required'));
        } finally {
            Test.stopTest();
        }

    }
    @isTest
    static void TestNullContact(){
        Account testAccount = getPrerequisiteAccount();
        
        Map<String, Object> params = new Map<String, Object>(); 
        params.put('AccountRecord', testAccount);
        params.put('ContactRecord', null);

        // Start test
        Test.startTest();
        Flow.Interview.OpportunityOwnershipFlow flowTest = new Flow.Interview.OpportunityOwnershipFlow(params);

        // Assert that a FlowException is thrown with the expected error message
        try {
            flowTest.start();
        } catch (FlowException e) {
            System.assert(e.getMessage().contains('The ContactRecord input is required'));
        } finally {
            Test.stopTest();
        }
    }
}
