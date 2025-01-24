public class GestionnaireDevis implements Database.Batchable<sObject>, Database.Stateful {
	
    public Integer recordsProcessed = 0;
    public Integer recordsPassed = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
    	return Database.getQueryLocator('SELECT BS_Nom_Client__c FROM BS_Devis__c WHERE BS_Contact__c=null');
    }
    
    public void execute(Database.BatchableContext bc, List<BS_Devis__c> records){
        // process each batch of records
        List<BS_Devis__c> devisToUpdate = new List<BS_Devis__c>();
        for (BS_Devis__c devis : records) {
            List<Contact> contacts = new List<Contact>([SELECT Id FROM Contact where RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire' AND Accountid=:devis.BS_Nom_Client__c LIMIT 1]);
            if (contacts.size() > 0) {
                devis.BS_Contact__c = contacts[0].id;
                devisToUpdate.add(devis);
                recordsProcessed += 1;
            }
            else {
                recordsPassed += 1;
            }
        }
        update devisToUpdate;
    }
    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug('Devis: ' + recordsProcessed + ' records processed');
        system.debug('Devis: ' + recordsPassed + ' records passed');
    }
}