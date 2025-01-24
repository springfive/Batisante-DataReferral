trigger TRG_Task on Task (after insert, before insert, before update) {
     User u = [SELECT Id, ProfileId, BS_ByPass_Trigger__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
     Profile userProfile = [SELECT Name FROM Profile WHERE Id = :u.ProfileId];
     Boolean isByPassTrigger = u.BS_ByPass_Trigger__c;
            
    if (trigger.isAfter && trigger.isInsert) {
        List<Task> Task=trigger.new;
        List<Task> EmailTask=new List<Task>();
        List<Task> NewTask=new List<Task>();
        
        if(Task.size()>0){
            for(integer i=0;i<Task.size();i++){
                try {
                  //  BS_Devis_from_Lead__c devisLead = [SELECT id FROM BS_Devis_from_Lead__c WHERE Id=:task[i].WhatId];
                    If((task[i].subject.startsWith('Email')||task[i].subject.startsWith('E-mail'))){
                        EmailTask.add(Task[i]);
                    }
                    
                }
                catch(Exception e) {
                    return;
                }
            }
        }
        for(Integer i=0;i<EmailTask.size();i++){
            DateTime firstWorkedDay = EmailTask[i].ActivityDate.addDays(2);
            
            
            while (firstWorkedDay.format('E') == 'Sun' || firstWorkedDay.format('E') == 'Sat') {
                firstWorkedDay = firstWorkedDay.addDays(1);
            }
            
            System.debug(firstWorkedDay);
            
          /*  Task TaskToCreate=new Task();
            TaskToCreate.ActivityDate= firstWorkedDay.date();
            TaskToCreate.Subject='Relance Devis-Propect après envoi du devis';
            TaskToCreate.Status='Ouvert';
            TaskToCreate.OwnerId=EmailTask[i].OwnerId;
            TaskToCreate.Priority='Normale';
            TaskToCreate.N_Relance__c='1';
            TaskToCreate.Type='Appel Sortant';
            TaskToCreate.RecordTypeId='0123X000000SP4sQAG'; //FOR PROD
          //  TaskToCreate.RecordTypeId='0127Z000001Iu1LQAS'; //FOR SANDBOX
            
            TaskToCreate.WhatId=EmailTask[i].WhatId;
            NewTask.add(TaskToCreate);*/
        }
        Database.insert(NewTask);
    }
    else if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        List<Task> tasks = trigger.new;
        for (Task task : tasks) {
            if (task.WhatId != null && task.WhatID.getSObjectType() == BS_Devis__c.sObjectType && Schema.SObjectType.Task.getRecordTypeInfosById().get(task.RecordTypeId).getName() == 'Relance') {
                BS_Devis__c devis = [Select BS_Date_Accord__c, MaJ_statut_t_che__c from BS_Devis__c where id=:task.WhatId Limit 1];
                if (devis.BS_Date_Accord__c != null && isByPassTrigger == false) { //LMS add Bypass check for inserted task (devis cannot be inserted)
                    if (trigger.isInsert)
                        task.addError('Il est impossible de créer une tâche de relance car le devis est validé.');
                    else {
                        //if (task.status == 'Ouvert') {
                        if (devis.MaJ_statut_t_che__c){
                           // if (devis.BS_Date_Accord__c < task.LastModifiedDate)
                             //   task.Status = 'Erreur';
                            //else
                                task.Status = 'Fermée';
                            
                        }
                        else if (userProfile.Name != 'System Administrator' && userProfile.Name != 'Administrateur système')
                            task.addError('Impossible de modifier cette tâche de relance car le devis est validé.');
                    }
                }
            }
        }
    }
}