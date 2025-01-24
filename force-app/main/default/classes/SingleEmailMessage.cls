public class SingleEmailMessage {
    
    String classname = LocationBatchForAccount.class.getName(); // Helps to identify the class for which the mail is sent
    List<Id> successrecordslist = new List<Id>() ;
    List<LocationBatchForAccount.Result> errorrecordslist = new List<LocationBatchForAccount.Result>() ;
    Integer totalProcessedRecords ;
    Integer totalUpdatedAccounts ;
    Integer countSuccessRecords ;
    Integer countErrorRecords ;
    
    
    public SingleEmailMessage(List<Id> success, List<LocationBatchForAccount.Result> error, Integer totalLocRecords, 
                              Integer totalAccRecords, Integer successRecords, Integer errorRecords) {
    
        this.successrecordslist = success ;
        this.errorrecordslist = error ;
        this.totalProcessedRecords = totalLocRecords ;
		this.totalUpdatedAccounts = totalAccRecords ;
        this.countSuccessRecords = successRecords ;
        this.countErrorRecords = errorRecords ;                      
        
 
        List<String> toAddresses = new List<String>() ; //The recipients may vary for the future use cases
       	toAddresses.addAll((System.Label.EMail_ToAddress).split(';')) ;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(System.Label.EMail_Subject); //The subject can be custom-defined according to the usecase
        mail.setPlainTextBody('The batch class ' + classname + ' is completed successfully. \nThe accounts associated to the upserted location records are updated. \n\nNumber of Location Records: ' + totalProcessedRecords + '\nNumber of Account Records Updated : ' + totalUpdatedAccounts + '\nNumber of Successful Records : ' + countSuccessRecords + '\nNumber of Error Records : ' + countErrorRecords + '\n\nList of records of the Account Object: \nList of Successful Records: ' +  successrecordslist + '\nList of Error Records: ' +  errorrecordslist + '\n\nThank you, \nSalesforce Admin. \n\nThis is a system generated mail. Do not respond.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        }
       
}