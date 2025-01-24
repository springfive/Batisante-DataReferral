trigger BS_Engagement_Trigger on BS_Engagement__c (Before Update,Before Insert) {
    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isBefore){
        
        if(Trigger.isUpdate){
            System.debug('UserName : ' + us.Name);
            if(us.Name == 'Automate'){
                Gestion_Engagements_TriggerHandler.gestion_EngagementsBeforeUpdate(Trigger.new);
            }
        }
        
        if(Trigger.isInsert){
        System.debug('UserName : ' + us.Name);
            if(us.Name == 'Automate'){
                Gestion_Engagements_TriggerHandler.gestion_EngagementsBeforeInsert(Trigger.new);
            }
        }
    }
}