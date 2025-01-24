@isTest
public class Gestion_Contract_TriggerHandlerTest {
    @isTest static void beforeUpdate(){

        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            Contract cont = Test_Data_Factory.createContract(acc.Id,site.Id);
            
            Test.startTest();
			cont.BS_Prestation__c = '1234';
			Update cont;
            Gestion_Contract_TriggerHandler.gestion_ContractBeforeUpdate(new List<Contract>{cont});
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
            Contract cont = Test_Data_Factory.createContract(acc.Id,site.Id);
            
            Test.startTest();
            Gestion_Contract_TriggerHandler.gestion_ContractBeforeInsert(new List<Contract>{cont});
        }
        Test.stopTest();
    }
}