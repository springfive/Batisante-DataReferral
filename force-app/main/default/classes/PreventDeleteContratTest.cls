@isTest
private class PreventDeleteContratTest {
    @isTest  static void suppContrat(){
        Account act=new account(name='test suppression',BS_Id_ClientAzur__c='123378924');
        insert act;
        Contract ctr=new Contract(Name='ctr',status='Contrat Terminé',AccountId=act.id, BS_N_contrat__c='2324232');
        insert ctr;
        user co =Test_Data_Factory.getUserWithCoProfile();
        system.runAs(co){
            Test.startTest();
            Database.DeleteResult str = database.delete(ctr,false);
            Test.stopTest();
            System.assert(!str.isSuccess());
            System.assert(str.getErrors().size() > 0);
            System.assertEquals('Vous ne pouvez pas supprimer des contrats', str.getErrors()[0].getMessage());
        }
        
    }
}