@isTest
private class PreventDeleteAccountTest {
    @isTest  static void suppClient(){
        Account act=new account(name='test suppression',BS_Id_ClientAzur__c='123378924');
        insert act;
        user co =Test_Data_Factory.getUserWithCoProfile();
        system.runAs(co){
            Test.startTest();
            Database.DeleteResult str = database.delete(act,false);
            Test.stopTest();
            System.assert(!str.isSuccess());
            System.assert(str.getErrors().size() > 0);
            System.assertEquals('Vous ne pouvez pas supprimer des clients',
                                str.getErrors()[0].getMessage());        }
    }
}