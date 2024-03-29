@isTest(isParallel=true)
public class FlowGetOrCreateOpportunity_Test {
    @TestSetup
    public static void makePrerequisiteData() {
      createTestAccount();
      createTestContact();
      createTestOpportunity();
    }
    public static void createTestAccount() {
      Account testAccount = new Account();
      testAccount.Name = 'prerequisite account';
      insert testAccount;
    }
    static Account getTestAccount() {
      return [SELECT Id, Name FROM Account LIMIT 1];
    }
    public static void createTestContact(){
        Contact testContact = new Contact();
        testContact.FirstName = 'prerequisite contact';
        testContact.LastName = 'contact';
        testContact.AccountId = FlowGetOrCreateOpportunity_Test.getTestAccount().Id;
        insert testContact;
    }
    static Contact getTestContact() {
      return [SELECT Id, FirstName, LastName FROM Contact LIMIT 1];
    }
    public static void createTestOpportunity() {
      Opportunity testOpportunity = new Opportunity();
      testOpportunity.Name = 'prerequisite opportunity';
      testOpportunity.CloseDate = Date.today();
      testOpportunity.StageName = 'Qualified';
      insert testOpportunity;
    }
    static Opportunity getPrerequisiteOpportunity() {
      return [SELECT Id, Name, CloseDate, StageName FROM Opportunity LIMIT 1];
    }
    static Opportunity getOpportunityCreateByTest() {
      return [SELECT Id, Name, CloseDate, StageName FROM Opportunity ORDER BY CreatedDate DESC];
    }
    static Map<String, Object> getPrerequisiteOpportunityMap() {
      Map<String, Object> params = new Map<String, Object>(); 
      params.put('newOpportunityCloseDate', null); 
      params.put('newOpportunityName', null); 
      params.put('newOpportunityStage', null);
      params.put('notUserOwnedId', null);
      params.put('userOwnedId', null);
      params.put('contact', FlowGetOrCreateOpportunity_Test.getTestContact());
      params.put('account', FlowGetOrCreateOpportunity_Test.getTestAccount());
      return params;
    }    
    static String getOpportunityStage() {
      String stage = getPrerequisiteOpportunity().StageName;
      System.debug('Stage Name is ' + stage); 
      return stage; 
    }
    static String getOpportunityId() {
      return getPrerequisiteOpportunity().Id;
    }
    static String getOpportunityName() {
      return getPrerequisiteOpportunity().Name;
    }
    static Date getOpportunityCloseDate() {
      return getPrerequisiteOpportunity().CloseDate;
    }
    @isTest
    static void testNewOpportunitySuccess() {
      Map<String, Object> params = FlowGetOrCreateOpportunity_Test.getPrerequisiteOpportunityMap(); 
      params.put('newOpportunityCloseDate', FlowGetOrCreateOpportunity_Test.getOpportunityCloseDate());
      params.put('newOpportunityName', FlowGetOrCreateOpportunity_Test.getOpportunityName());
      params.put('newOpportunityStage', FlowGetOrCreateOpportunity_Test.getOpportunityStage());
      System.debug(params);
      Test.startTest();
      Flow.Interview.MHGetOrCreateOpportunity flowTest = new Flow.Interview.MHGetOrCreateOpportunity(params);
      flowTest.start();
      Test.stopTest();  
      System.debug('Debug flowTest.opportunity');
      System.debug(flowTest.opportunity);
      System.Assert.isNotNull(flowTest.opportunity.CloseDate); 
      System.Assert.isNotNull(flowTest.opportunity.Name);
      System.Assert.isNotNull(flowTest.opportunity.StageName);
    }
    @isTest
    static void testNewOpportunityNullName() {
      Map<String, Object> params = FlowGetOrCreateOpportunity_Test.getPrerequisiteOpportunityMap(); 
      params.put('newOpportunityCloseDate', FlowGetOrCreateOpportunity_Test.getOpportunityCloseDate());
      params.put('newOpportunityStage', FlowGetOrCreateOpportunity_Test.getOpportunityStage());
      Test.startTest();
      Flow.Interview.MHGetOrCreateOpportunity flowTest = new Flow.Interview.MHGetOrCreateOpportunity(params);
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
    static void testNewOpportunityNullCloseDate() {
      Map<String, Object> params = FlowGetOrCreateOpportunity_Test.getPrerequisiteOpportunityMap(); 
      params.put('newOpportunityName', FlowGetOrCreateOpportunity_Test.getOpportunityName());
      params.put('newOpportunityStage', FlowGetOrCreateOpportunity_Test.getOpportunityStage());
      Test.startTest();
      Flow.Interview.MHGetOrCreateOpportunity flowTest = new Flow.Interview.MHGetOrCreateOpportunity(params);
       try {
      flowTest.start();
      }
      catch (FlowException e) {
      System.debug(e.getMessage());
      System.Assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
      System.Assert(e.getMessage().contains('CloseDate'));
      }
      Test.stopTest();
    }

    @isTest
    static void testExistingOpportunitySuccess() {
      Map<String, Object> params = FlowGetOrCreateOpportunity_Test.getPrerequisiteOpportunityMap(); 
      params.put('opportunityId', FlowGetOrCreateOpportunity_Test.getOpportunityId());
      Test.startTest();
      Flow.Interview.MHGetOrCreateOpportunity flowTest = new Flow.Interview.MHGetOrCreateOpportunity(params);
            try {
      flowTest.start();
      }
      catch (FlowException e) {
            System.debug(e.getMessage());
            System.Assert.fail(); 
}       finally {
      System.Assert.isNotNull(flowTest.opportunity.CloseDate); 
      System.Assert.isNotNull(flowTest.opportunity.Name);
      System.Assert.isNotNull(flowTest.opportunity.StageName);

     }
      Test.stopTest();
  }
}

