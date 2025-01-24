@isTest
public class Gestion_Engagements_TriggerHandlerTest {
    @isTest static void beforeUpdate(){
        
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            BS_Engagement__c eng = Test_Data_Factory.createBS_Engagement(acc.Id,site.Id);
            
            Test.startTest();
            eng.Name = '433402';
			Update eng;
                Gestion_Engagements_TriggerHandler.gestion_EngagementsBeforeUpdate(new List<BS_Engagement__c>{eng});
        }
        Test.stopTest();
    }
    
    @isTest static void beforeInsert(){
        
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            BS_Engagement__c eng = Test_Data_Factory.createBS_Engagement(acc.Id,site.Id);
            
            Test.startTest();
            Gestion_Engagements_TriggerHandler.gestion_EngagementsBeforeInsert(new List<BS_Engagement__c>{eng});
        }
        Test.stopTest();
    }
}