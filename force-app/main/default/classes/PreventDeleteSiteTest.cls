@isTest
private class PreventDeleteSiteTest {
    @isTest  static void suppSite(){
        Account act=new account(name='test suppression',BS_Id_ClientAzur__c='123378924');
        insert act;
        BS_Site__c st=new BS_Site__c(Name='site',BS_Client__c=act.id);
        insert st;
        user co =Test_Data_Factory.getUserWithCoProfile();
        system.runAs(co){
            Test.startTest();
            Database.DeleteResult str = database.delete(st,false);
            Test.stopTest();
            System.assert(!str.isSuccess());
            System.assert(str.getErrors().size() > 0);
            System.assertEquals('Vous ne pouvez pas supprimer des sites/Lieux',
                                str.getErrors()[0].getMessage());
        }        
    }
}