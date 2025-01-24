trigger WorkOrderLineItemTrigger on WorkOrderLineItem (after insert) {
    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            if(us.Name == 'Automate'){
                WorkOrderLineItemTriggerHandler.woliAfterInsert(Trigger.new);
            }
        }
    }
}