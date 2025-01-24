trigger ServiceAppointmentTrigger on ServiceAppointment (after update,after insert, before update) {

    User us = [select Id, Name, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    
    if(Trigger.isAfter){           
        if(Trigger.isUpdate){
            System.debug(us);
            if( (us.Name == 'Mulesoft User' || us.Name == 'Automate')){
 
                ServiceAppointmentTriggerHandler.serviceappointmentAfterUpdate(Trigger.new,Trigger.oldMap);
     
            }
        }         
        
        if(Trigger.isInsert){
			System.debug(us);
            if( (us.Name == 'Mulesoft User' || us.Name == 'Automate')){
             
                ServiceAppointmentTriggerHandler.serviceappointmentAfterInsert(Trigger.new);
            }
        }
    }

}