@isTest
private class PreventDeleteEngTest {
    @isTest  static void suppEng(){
        Account act=new account(name='test suppression',BS_Id_ClientAzur__c='123378924');
        insert act;
        BS_Engagement__c eng=new BS_Engagement__c(Name='eng', BS_ID_engagement_Az__c='2425434',BS_client__c=act.id);
        insert eng;
        user co =Test_Data_Factory.getUserWithCoProfile();
        system.runAs(co){
            Test.startTest();
            Database.DeleteResult str = database.delete(eng,false);
            Test.stopTest();
            System.assert(!str.isSuccess());
            System.assert(str.getErrors().size() > 0);
            System.assertEquals('Vous ne pouvez pas supprimer des engagements',
                                str.getErrors()[0].getMessage());
        }
    }
}