@isTest
public class AccountTriggerHandlerTest {
    @isTest static void beforeUpdate1(){
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact1(acc.Id);
            Test.startTest();
            AccountTriggerHandler.accountBeforeUpdate(new List<Account>{acc});
        }
        Test.stopTest();
    }
    @isTest static void beforeUpdate2(){
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount1(u2.Id);
            Contact con = Test_Data_Factory.createContact1(acc.Id);
            Test.startTest();
            AccountTriggerHandler.accountBeforeUpdate(new List<Account>{acc});
        }
        Test.stopTest();
    }
    @isTest static void beforeInsert1(){
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact1(acc.Id);
            Test.startTest();
            AccountTriggerHandler.accountBeforeInsert(new List<Account>{acc});
        }
        Test.stopTest();
    }
    
    @isTest static void beforeInsert2(){
        user u = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount1(u2.Id);
            Contact con = Test_Data_Factory.createContact1(acc.Id);
            Test.startTest();
            AccountTriggerHandler.accountBeforeInsert(new List<Account>{acc});
        }
        Test.stopTest();
    }
    @isTest static void afterInsert1(){
        user u = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact1(acc.Id);
            Test.startTest();
            AccountTriggerHandler.accountAfterInsert(new List<Account>{acc});
        }
        Test.stopTest();
    }
    
    @isTest static void afterInsert2(){
        user u = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount1(u2.Id);
            Contact con1 = Test_Data_Factory.createContact1(acc.Id);
            Contact con2 = Test_Data_Factory.createContact1(acc.Id);
            Test.startTest();
            AccountTriggerHandler.accountAfterInsert(new List<Account>{acc});
        }
        Test.stopTest();
    }
}