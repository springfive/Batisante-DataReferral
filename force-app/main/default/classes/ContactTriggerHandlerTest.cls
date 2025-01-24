@isTest
public class ContactTriggerHandlerTest {
    
    @isTest
    static void beforeInsert(){
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount2(u2.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Test.startTest();
            con.LastName = 'TestName';
            Update con;
            ContactTriggerHandler.contactBeforeInsert(new List<Contact>{con});
        }
        Test.stopTest();
    }
    
    @isTest
    static void beforeUpdate(){
        user u = Test_Data_Factory.User5();
        User u2 = Test_Data_Factory.User4();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount2(u2.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Test.startTest();
            ContactTriggerHandler.contactBeforeUpdate(new List<Contact>{con});
        }
        Test.stopTest();
    }
}