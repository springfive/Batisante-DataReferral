public class GestionnaireContract implements Database.Batchable<sObject>, Database.Stateful {
	
    public Integer recordsProcessed = 0;
    public Integer recordsPassed = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
    	return Database.getQueryLocator('SELECT AccountId FROM Contract WHERE BS_Gestionnaire__c=null');
    }
    
    public void execute(Database.BatchableContext bc, List<Contract> records){
        // process each batch of records
		List<Contract> contractToUpdate = new List<Contract>();
        for (Contract contract : records) {
            List<Contact> contacts = new List<Contact>([SELECT Id FROM Contact where RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire' AND Accountid=:contract.AccountId LIMIT 1]);
            if (contacts.size() > 0) {
                contract.BS_Gestionnaire__c = contacts[0].id;
                contractToUpdate.add(contract);
                recordsProcessed += 1;
            }
            else {
                recordsPassed += 1;
            }
        }
        update contractToUpdate;
    }
    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug('Contract: ' + recordsProcessed + ' records processed');
        system.debug('Contract: ' + recordsPassed + ' records passed');
    }
}