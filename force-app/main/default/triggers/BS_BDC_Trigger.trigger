trigger BS_BDC_Trigger on BS_BDC__c (Before Update,Before Insert) {
    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isBefore){           
        if(Trigger.isUpdate){
            if(us.Name == 'Automate'){
                Gestion_BDC_TriggerHandler.gestion_BDC_BeforeUpdate(Trigger.new);
            }
        }
        
        if(Trigger.isInsert){
            if(us.Name == 'Automate'){
                Gestion_BDC_TriggerHandler.gestion_BDC_BeforeInsert(Trigger.new);
            }
        }
    }
}