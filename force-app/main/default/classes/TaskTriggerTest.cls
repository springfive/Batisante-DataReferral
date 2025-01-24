/**
* @author Lucas Magalhaes
* @date 23/08/2023
* @description  :Test TRG_Task
* la classe de test du trigger de l'object Task
*/
@isTest
public class TaskTriggerTest {

    public class testException extends Exception {}
    
    @isTest
    static void test_insert_closed_task() {
        //Init Data
        //RunAs user
        User u = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        u.BS_ByPass_Trigger__c = true;
        update u;
        //Client
        Account act=new account(name='test task insert',BS_Id_ClientAzur__c='123378924');
        insert act;
        //Site
        Schema.Location st= new Schema.Location(name='site',BS_Client__c=act.id);
        insert st;
        //Lists
        List<BS_Devis__c> devisList = new List<BS_Devis__c>();
        List<Task> taskList = new List<Task>();
       
        // Test
        System.runAs(u){
            Test.startTest();
                //Devis
                BS_Devis__c dv=new BS_Devis__c(BS_Nom_Client__c=act.id,BS_Emplacement__c=st.id, name='toto', BS_N_Ope__c='242523',BS_Date_Accord__c=Date.newInstance(2023,30,08));
                insert dv;
            
                //Task
                Id taskrelanceid = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BS_Relance').getRecordTypeId();
                Task tk = new Task(WhatId=dv.id,Status='Fermée',recordtypeId=taskrelanceid);
                insert tk;
            
                devisList = [SELECT Id FROM BS_Devis__c];
                taskList = [SELECT Id FROM Task];
            Test.stopTest();
        }
        
        //Aserts
        System.assertEquals(1, devisList.size(), 'Le devis n\'est pas crée');
        System.assertEquals(1, taskList.size(), 'La Tache n\'est pas crée');
        
    }
    
    @isTest
    static void test_Fail_insert_closed_task() {
        //Init Data
        //RunAs user
        User u = Test_Data_Factory.getUserWithCoProfile();
        //Client
        Account act=new account(name='test task insert',BS_Id_ClientAzur__c='123378924');
        insert act;
        //Site
        Schema.Location st= new Schema.Location(name='site',BS_Client__c=act.id);
        insert st;
        //Lists
        List<BS_Devis__c> devisList = new List<BS_Devis__c>();
        List<Task> taskList = new List<Task>();
        Boolean expectedExceptionThrown;
       
        // Test
        System.runAs(u){
            Test.startTest();
                //Devis
                BS_Devis__c dv=new BS_Devis__c(BS_Nom_Client__c=act.id,BS_Emplacement__c=st.id, name='toto', BS_N_Ope__c='242523',BS_Date_Accord__c=Date.newInstance(2023,30,08));
                insert dv;
            
                //Task
                Id taskrelanceid = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BS_Relance').getRecordTypeId();
                Task tk = new Task(WhatId=dv.id,Status='Fermée',recordtypeId=taskrelanceid);
                try{
                    insert tk;
                    throw new testException('An exception should have been thrown by the trigger but was not.');
                }
                catch(Exception e){
                    expectedExceptionThrown =  e.getMessage().contains('Il est impossible de créer une tâche de relance car le devis est validé.') ? true : false;
                }
            
                devisList = [SELECT Id FROM BS_Devis__c];
                taskList = [SELECT Id FROM Task];
            Test.stopTest();
        }
        
        //Aserts
        System.assertEquals(1, devisList.size(), 'Le devis n\'est pas crée');
        System.assertEquals(true, expectedExceptionThrown, 'Le message d\'erreur n\'est pas bon');
        System.assertEquals(0, taskList.size(), 'Une tache a été crée');

        
    }
}