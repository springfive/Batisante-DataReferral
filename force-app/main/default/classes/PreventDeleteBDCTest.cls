@isTest
private class PreventDeleteBDCTest {
    @isTest  static void suppBDC(){
        Account act=new account(name='test suppression',BS_Id_ClientAzur__c='123378924');
        insert act;
        BS_BDC__c bdc=new BS_BDC__c(Name='bdc', BS_N_BDC__c='2425434',BS_Client__c=act.id);
        insert bdc;
        user co =Test_Data_Factory.getUserWithCoProfile();
        system.runAs(co){
        Test.startTest();
        Database.DeleteResult str = database.delete(bdc,false);
        Test.stopTest();
        System.assert(!str.isSuccess());
        System.assert(str.getErrors().size() > 0);
        System.assertEquals('Vous ne pouvez pas supprimer des BDC',
                             str.getErrors()[0].getMessage());
        }
    }
}