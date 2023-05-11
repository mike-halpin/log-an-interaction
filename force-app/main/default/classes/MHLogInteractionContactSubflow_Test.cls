@isTest(isParallel=true)
public class MHLogInteractionContactSubflow_Test {

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

    public static void createTestContact() {
        Contact testContact = new Contact();
        testContact.FirstName = 'prerequisite contact';
        testContact.LastName = 'contact';
        testContact.AccountId = getAccountId();
        testContact.Email = 'test@test.com';
        testContact.Phone = '1234567890';
        insert testContact;
    }

    static Account getPrerequisiteAccount() {
        return [SELECT Id, Name FROM Account LIMIT 1];
    }

    static Contact getPrerequisiteContact() {
        return [SELECT Id, FirstName, LastName, AccountId, Email, Phone FROM Contact LIMIT 1];
    }

    static String getAccountId() {
        return getPrerequisiteAccount().Id;
    }

    @isTest
    static void testCreateNewContact() {
        Map<String, Object> params = new Map<String, Object>(); 
        params.put('newContactName', 'New Contact');
        params.put('newContactEmail', 'new_contact@test.com');
        params.put('newContactFirstName', 'New');
        params.put('newContactLastName', 'Contact');
        params.put('newContactPhone', '0987654321');

        // Start test
        Test.startTest();
        Flow.Interview.MHLogInteractionContactSubflow flowTest = new Flow.Interview.MHLogInteractionContactSubflow(params);
        flowTest.start();
        Test.stopTest();

        // Assert the outputs
        System.Assert.isNotNull(flowTest.contact);
        System.Assert.isNotNull(flowTest.contact.Id);
        System.assertEquals(true, flowTest.isNewContact);
    }

    @isTest
    static void testUpdateExistingContact() {
        // Prepare test data
        Contact testContact = getPrerequisiteContact();

        Map<String, Object> params = new Map<String, Object>(); 
        params.put('contact', testContact);

        // Start test
        Test.startTest();
        Flow.Interview.MHLogInteractionContactSubflow flowTest = new Flow.Interview.MHLogInteractionContactSubflow(params);
        flowTest.start();
        Test.stopTest();

        // Assert the outputs
        System.Assert.isNotNull(flowTest.contact);
        System.assertEquals(testContact.Id, flowTest.contact.Id);
        System.assertEquals(false, flowTest.isNewContact);
    }
}

