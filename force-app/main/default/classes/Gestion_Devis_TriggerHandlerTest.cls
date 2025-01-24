@isTest
public class Gestion_Devis_TriggerHandlerTest {
    
    @isTest static void beforeUpdate(){
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            BS_Devis__c dev = Test_Data_Factory.createDevis(acc.Id,site.Id);
            
            Test.startTest();
            dev.Name = 'Devis Equipement(s) Bloc(s) Porte(s) coupe-feu';
            Update dev;
            TriggerHelper.hasDevisTriggerRun = false;
            Gestion_Devis_TriggerHandler.gestion_Devis_BeforeUpdate(new List<BS_Devis__c>{dev});
        }
        Test.stopTest();
    }
    
    @isTest static void beforeInsert(){
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            BS_Devis__c dev = Test_Data_Factory.createDevis(acc.Id,site.Id);
            
            Test.startTest();
            TriggerHelper.hasDevisTriggerRun = false;
            Gestion_Devis_TriggerHandler.gestion_Devis_BeforeInsert(new List<BS_Devis__c>{dev});
        }
        Test.stopTest();
    }
}