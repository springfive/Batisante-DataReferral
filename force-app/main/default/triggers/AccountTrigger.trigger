trigger AccountTrigger on Account (Before Update,Before Insert,After Insert) {
    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isBefore){
        
        if(Trigger.isUpdate){
            if(us.Name == 'Automate'){
                AccountTriggerHandler.accountBeforeUpdate(Trigger.new);
            }
        }
        
        if(Trigger.isInsert){
            if( us.Name == 'Automate'){
                AccountTriggerHandler.accountBeforeInsert(Trigger.new);
            }
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            if(us.Name == 'Automate'){
                AccountTriggerHandler.accountAfterInsert(Trigger.new);
            }
        }
    }
}