@isTest
public class Gestion_BDC_TriggerHandlerTest {

    @isTest static void beforeUpdateTest() {
        
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            
            BS_BDC__c bdc = Test_Data_Factory.createBDC(acc.Id);
            
            Test.startTest();
			bdc.BS_Prestation__c = 'BL124';
			Update bdc;
            Gestion_BDC_TriggerHandler.gestion_BDC_BeforeUpdate(new List<BS_BDC__c>{bdc});
        }
        Test.stopTest();

    }
    
    @isTest static void beforeInsertTest() {
        
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            
            BS_BDC__c bdc = Test_Data_Factory.createBDC(acc.Id);
            
            Test.startTest();
            Gestion_BDC_TriggerHandler.gestion_BDC_BeforeInsert(new List<BS_BDC__c>{bdc});
        }
        Test.stopTest();

    }
}