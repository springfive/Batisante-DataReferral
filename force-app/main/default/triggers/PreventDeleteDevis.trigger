trigger PreventDeleteDevis on BS_Devis__c (before Delete, before update) {
    if (trigger.isBefore) {
        
        //PreventDeleteDevis
        if (trigger.isDelete) {
                User u = [select Id, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
                if(!u.BS_ByPass_Trigger__c){
                    for(BS_Devis__c a : trigger.old){
                        a.addError('Vous ne pouvez pas supprimer des devis' );
                    }   
                }
        }
        
        //Update relance task status linked to devis where accord date is set
        /*else if (trigger.isUpdate) {
            for (BS_Devis__c devis : trigger.new) {
                BS_Devis__c oldDevis = Trigger.oldMap.get(devis.Id);
                if ((oldDevis.BS_Date_Accord__c == null && devis.BS_Date_Accord__c != null) || devis.BS_Statut__c != 'En cours') {
                    List<task> taskRelance = [Select id, status, LastModifiedDate, BS_Etat__c From task where whatId=:oldDevis.Id and recordtype.developerNAme = 'BS_Relance'];
                    for (Task t : taskRelance) {
                        //Date modification = Date.newInstance(t.LastModifiedDate.year(), t.LastModifiedDate.month(), t.LastModifiedDate.day());
                       // if (modification > devis.BS_Date_Accord__c) {
                         //   t.Status = 'Erreur';
                            devis.MaJ_statut_t_che__c = true;
                        //}
                        //else
                            t.Status = 'Fermée';
                        	t.BS_Etat__c = devis.BS_Statut__c;
                    }
                    update taskRelance;
                }
            }
          
        }*/ 
    }
}