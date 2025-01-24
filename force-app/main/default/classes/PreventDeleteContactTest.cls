@isTest
private class PreventDeleteContactTest {
    @isTest  static void suppContact(){
        Account act=new account(name='test suppression',BS_Id_ClientAzur__c='123378924');
        insert act;
        Contact ct=new Contact(lastname='Am',accountId=act.id, BS_Id_Contact_Azur__c='12345432');
        insert ct;
        user co =Test_Data_Factory.getUserWithCoProfile();
        system.runAs(co){
            Test.startTest();
            Database.DeleteResult str = database.delete(ct,false);
            Test.stopTest();
            System.assert(!str.isSuccess());
            System.assert(str.getErrors().size() > 0);
            System.assertEquals('Vous ne pouvez pas supprimer des contacts',
                                str.getErrors()[0].getMessage());
        }
    }
}