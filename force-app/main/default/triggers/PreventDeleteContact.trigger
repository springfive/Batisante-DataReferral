trigger PreventDeleteContact on Contact (before Delete) {
    User u = [select Id, BS_ByPass_Trigger__c from User where Id = :UserInfo.getUserId() limit 1];
    if(!u.BS_ByPass_Trigger__c){
        for(Contact a : trigger.old){
            a.addError('Vous ne pouvez pas supprimer des contacts' );
        }   
    }
}