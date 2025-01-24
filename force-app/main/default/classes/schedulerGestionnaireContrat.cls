global class schedulerGestionnaireContrat implements Schedulable {
    global static void execute(SchedulableContext SC) {
       GestionnaireContrat(); 
    }
    public static void GestionnaireContrat() {
        list<Contact> Accounts=[select AccountId from Contact where BS_Typologie__c='Gestionnaire' and BS_Principal__c =true and AccountId in (select AccountId from Contract where  
 BS_Gestionnaire__c =null)];
        
        
Set<Id> ids = new Set<Id>();
        
        for(contact a: accounts){
            ids.add(a.AccountId);
        }
System.debug('Account Ids as Set<Id>: ' + ids.size());

        list<account> Listecount=[SELECT Id,Name,(select id  , name FROM contacts  where BS_Typologie__c='gestionnaire' and BS_Principal__c=true) ,(SELECT Id,Name,BS_Gestionnaire__c FROM contracts)  
                     FROM account WHERE id IN:ids];
system.debug(Listecount);
    list<Contract> contractToUpdate=new List<Contract>();

 for(Account a : Listecount) { 
        Contact[] relatedgestionaire = a.contacts; 
     contract[] relatedContract=a.contracts;
        // Do some other processing
        //System.debug('Gestionnaire Contact'+relatedgestionaire[0].id);
     for( Contract contratB:relatedContract){
          //System.debug('gestionnaire contrat'+relatedgestionaire.size());
         if(relatedgestionaire.size()!=0){
         if(contratB.BS_Gestionnaire__c!=relatedgestionaire[0].id ){
            contratB.BS_Gestionnaire__c=relatedgestionaire[0].id; 
             contractToUpdate.add(contratB);
             // System.debug('add');
         }
         }
         
         
     }
    }
  //System.debug('Correction lynda');  
update contractToUpdate;
        
    }
    
}