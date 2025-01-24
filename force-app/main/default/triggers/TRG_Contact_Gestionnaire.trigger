trigger TRG_Contact_Gestionnaire on Contact (after insert,after update) {
    
    // All trigger logic has been converted into flow
    
   /*
                 
    //List<Contract> ContractRelated = [SELECT Id,Name FROM contract
      //  WHERE AccountId IN (select  AccountId from Contact where id in:Trigger.new)];
    
    
    list<account> Listecount=[SELECT Id,Name,(select id  , name FROM contacts  where BS_Typologie__c='gestionnaire' and BS_Principal__c=true) ,(SELECT Id,Name,BS_Gestionnaire__c FROM contracts)  
                     , (select id, BS_Contact__c FROM Devis__r),(select id,BS_Contact__c from Engagements__r),(select id,BS_Contact__c from BDC__r) FROM account WHERE id IN (select  AccountId from Contact where id in:Trigger.new ) ];
system.debug(Listecount);
    list<Contract> contractToUpdate=new List<Contract>();
    list <BS_Devis__c> devisToUpdate=new list<BS_Devis__c>();
    list<BS_Engagement__c> engagementToUpdate=new list<BS_Engagement__c>();
    list<BS_BDC__c> bdcToupdate=new list<BS_BDC__c>();
    

 for(Account a : Listecount) { 
        Contact[] relatedgestionaire = a.contacts; 
     contract[] relatedContract=a.contracts;
     BS_Devis__c[] relatedDevis=a.Devis__r;
     BS_Engagement__c[] relatedEngagement=a.Engagements__r;
     BS_BDC__c[] relatedBdc=a.BDC__r;
        // Do some other processing
        //System.debug('Gestionnaire Contact'+relatedgestionaire[0].id);
        //
     // ------------------------------MISE A JOUR CONTRATS AVEC LE GESTIONNAIRE
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
     
     
     // mise a jour des devis avec le contact ---------------------------------------------------------------
     for( BS_Devis__c devisB:relatedDevis){
          //System.debug('gestionnaire contrat'+relatedgestionaire.size());
         if(relatedgestionaire.size()!=0){
         if(devisB.BS_Contact__c!=relatedgestionaire[0].id ){
            devisB.BS_Contact__c=relatedgestionaire[0].id; 
            devisToUpdate.add(devisB);
             // System.debug('add');
         }
         }
         
         
     }
     
     
     // mise a jour engagement--------------------------------
     for( BS_Engagement__c engagementB:relatedEngagement){
          //System.debug('gestionnaire contrat'+relatedgestionaire.size());
         if(relatedgestionaire.size()!=0){
         if(engagementB.BS_Contact__c!=relatedgestionaire[0].id ){
          engagementB.BS_Contact__c=relatedgestionaire[0].id; 
            engagementToUpdate.add(engagementB);
             // System.debug('add');
         }
         }
         
         
     }
     
     // mise a jour bdc -------------------------------
     
     for( BS_BDC__c bdcB:relatedBdc){
          //System.debug('gestionnaire contrat'+relatedgestionaire.size());
         if(relatedgestionaire.size()!=0){
         if(bdcB.BS_Contact__c!=relatedgestionaire[0].id ){
            bdcB.BS_Contact__c=relatedgestionaire[0].id; 
           bdcToupdate.add(bdcB);
             // System.debug('add');
         }
         }
         
         
     }
     
     
    }
  //System.debug('Correction lynda'); 
   
    upsert contractToUpdate;
    upsert devisToUpdate;
    upsert engagementToUpdate;
    upsert bdcToupdate;
*/
    
}