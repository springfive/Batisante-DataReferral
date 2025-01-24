public class GestionnaireBDC implements Database.Batchable<sObject>, Database.Stateful {
	
    public Integer recordsProcessed = 0;
    public Integer recordsPassed = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT BS_Client__c FROM BS_BDC__c WHERE BS_Contact__c=null');
    }
    
    public void execute(Database.BatchableContext bc, List<BS_BDC__c> records){
        // process each batch of records
        List<BS_BDC__c> bdcToUpdate = new List<BS_BDC__c>();
        for (BS_BDC__c bdc : records) {
            List<Contact> contacts = new List<Contact>([SELECT Id FROM Contact where RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire' AND Accountid=:bdc.BS_Client__c LIMIT 1]);
            if (contacts.size() > 0) {
                bdc.BS_Contact__c = contacts[0].Id;
                bdcToUpdate.add(bdc);
                recordsProcessed += 1;
            }
            else {
                recordsPassed += 1;
            }
        }
        update bdcToUpdate;
    }
    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug('BDC: ' + recordsProcessed + ' records processed');
        system.debug('BDC: ' + recordsPassed + ' records passed');
    }
}