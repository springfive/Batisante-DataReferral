trigger ContactTrigger on Contact (Before insert,Before Update) {
    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isBefore){
        
        if(Trigger.isUpdate){
            if(us.Name == 'Automate'){
                ContactTriggerHandler.contactBeforeUpdate(Trigger.new);
            }
        }
        
        if(Trigger.isInsert){
            if(us.Name == 'Automate'){
                ContactTriggerHandler.contactBeforeInsert(Trigger.new);
            }
        }
    }
    
}