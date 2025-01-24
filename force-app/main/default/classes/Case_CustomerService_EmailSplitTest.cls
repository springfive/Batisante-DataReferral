@IsTest
public class Case_CustomerService_EmailSplitTest {
    @isTest
    public static void testSplitEmailsWithMultipleEmails() {
        // Create a test Case record with multiple emails
        Case testCase = new Case(
            Subject = 'Test Case with Multiple Emails',
            OutputEinstein_ContactList__c = 'xavier.mlynek@ohana-conseil.fr,kaoutarms@gmail.com,kaoutar.mussaoui@springfive.com'
        );
        insert testCase;
        
        // Call the Case_CustomerService_EmailSplit method to process the case
        Test.startTest();
        
        List<Case> caseInput = new List<Case>{testCase};
        List<List<String>> result = Case_CustomerService_EmailSplit.splitEmails(caseInput);
        
        Test.stopTest();
        
        // Assert that the result is not null
        System.assertNotEquals(result, null, 'The result should not be null.');
        
        // Assert that the result contains one list
        System.assertEquals(result.size(), 1, 'There should be one list of emails in the result.');
        
        // Assert that the result contains the correct number of emails
        List<String> emailList = result[0];
        System.assertEquals(emailList.size(), 3, 'There should be 3 email addresses.');
        
        // Assert that the emails are correctly split
        System.assertEquals(emailList[0], 'xavier.mlynek@ohana-conseil.fr', 'First email address is incorrect.');
        System.assertEquals(emailList[1], 'kaoutarms@gmail.com', 'Second email address is incorrect.');
        System.assertEquals(emailList[2], 'kaoutar.mussaoui@springfive.com', 'Third email address is incorrect.');
    }
    
    @isTest
    public static void testSplitEmailsWithSingleEmail() {
        // Create a test Case record with a single email
        Case testCase = new Case(
            Subject = 'Test Case with Single Email',
            OutputEinstein_ContactList__c = 'xavier.mlynek@ohana-conseil.fr'
        );
        insert testCase;
        
        // Call the EmailSplitter method to process the case
        Test.startTest();
        
        List<Case> caseInput = new List<Case>{testCase};
        List<List<String>> result = Case_CustomerService_EmailSplit.splitEmails(caseInput);
        
        Test.stopTest();
        
        // Assert that the result is not null
        System.assertNotEquals(result, null, 'The result should not be null.');
        
        // Assert that the result contains one list
        System.assertEquals(result.size(), 1, 'There should be one list of emails in the result.');
        
        // Assert that the result contains the correct number of emails
        List<String> emailList = result[0];
        System.assertEquals(emailList.size(), 1, 'There should be 1 email address.');
        
        // Assert that the email is correct
        System.assertEquals(emailList[0], 'xavier.mlynek@ohana-conseil.fr', 'Email address is incorrect.');
    }
}