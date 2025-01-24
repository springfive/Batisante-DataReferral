public class Case_CustomerService_EmailSplit {

    // Invocable method that can be called from Flow
    @InvocableMethod(label='Case_CustomerService_EmailSplit' description='Splits email addresses from OutputEinstein_ContactList__c field into a text collection')
    public static List<List<String>> splitEmails(List<Case> caseInput) {
        List<List<String>> result = new List<List<String>>(); // List to hold the result
        
             // Check if trigger bypass is enabled for the current user
        User currentUser = [SELECT BS_ByPass_Trigger__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        if (currentUser.BS_ByPass_Trigger__c) {
            // If bypass is enabled, return an empty list and exit
            return result;
        }
    
        // Only one Case is passed in, we extract it
        Case c = caseInput[0]; 
        
        List<String> emailList = new List<String>(); // Temporary list to store email addresses
        
        // Check if the OutputEinstein_ContactList__c field is not empty
        if (String.isNotEmpty(c.OutputEinstein_ContactList__c)) {
            // Trim spaces and then check if the email addresses contain commas
            String trimmedEmails = c.OutputEinstein_ContactList__c.trim();
            
            // If there is only one email without commas, add it directly to the list
            if (!trimmedEmails.contains(',')) {
                emailList.add(trimmedEmails);
            } else {
                // If there are multiple emails separated by commas, split them into a list
                emailList = trimmedEmails.split(',');
            }
        }
        
        // Add the email list to the result
        result.add(emailList);
        
        return result; // Return the list of email lists
    }
}