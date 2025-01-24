@isTest
private class PreventDeleteDevisTest {

    @isTest  static void suppDevis(){
        Account act=new account(name='test suppression',BS_Id_ClientAzur__c='123378924');
        insert act;
        Schema.Location st= new Schema.Location(Name='site',BS_Client__c=act.id);
        insert st;
        BS_Devis__c dv=new BS_Devis__c(BS_Nom_Client__c=act.id,BS_Emplacement__c=st.id, name='toto', BS_N_Ope__c='242523');
        insert dv;
        Id taskrelanceid = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BS_Relance').getRecordTypeId();
        Task tk = new Task(WhatId=dv.id,Status='Ouvert',recordtypeId=taskrelanceid);
        insert tk;
        System.debug(tk.RecordType.DeveloperName);
        user co =Test_Data_Factory.getUserWithCoProfile();
        system.runAs(co){
            Test.startTest();
            Database.DeleteResult str = database.delete(dv,false);
            dv.BS_Date_Accord__c = system.today();
            update dv;
            Test.stopTest();
            System.assert(!str.isSuccess());
            System.assert(str.getErrors().size() > 0);
            System.assertEquals('Vous ne pouvez pas supprimer des devis', str.getErrors()[0].getMessage());
        }
    }

}