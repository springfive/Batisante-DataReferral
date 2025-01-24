trigger Gestion_Devis_Trigger on BS_Devis__c (Before insert,Before Update) {
    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            if(us.Name == 'Automate'){
                Gestion_Devis_TriggerHandler.gestion_Devis_BeforeUpdate(Trigger.new);
            }
        }
        
        if(Trigger.isInsert){
            if(us.Name == 'Automate'){
                Gestion_Devis_TriggerHandler.gestion_Devis_BeforeInsert(Trigger.new);
            }
        }
    }
    
}