trigger Gestion_Contract_Trigger on Contract  (Before Update,Before Insert) {
    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isBefore){
        
        if(Trigger.isUpdate){
            if(us.Name == 'Automate'){
                
                Gestion_Contract_TriggerHandler.gestion_ContractBeforeUpdate(Trigger.new);
            }
        }
        
        if(Trigger.isInsert){
            if(us.Name == 'Automate'){
                
                Gestion_Contract_TriggerHandler.gestion_ContractBeforeInsert(Trigger.new);
                
            }
        }
    }
}