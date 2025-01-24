/**
* @author Amine SARBOUTE
* @date 11/10/2020
* @description  :Test_WS06_UpsertEngagement
* la classe de test du web service WS06_UpsertEngagement
*/
@isTest(SeeAllData = true)
public class Test_WS06_UpsertEngagement{
    public static Structure_Engagement.EngagementWrapper getEngagementWrapper() {
        Structure_Engagement.EngagementWrapper EngagementWrapper  = new Structure_Engagement.EngagementWrapper();        
        EngagementWrapper.prestation = '5031';
        EngagementWrapper.dateAcceptation = '2019-02-12' ;
        EngagementWrapper.idEngagement = '1234' ;
        EngagementWrapper.dateResiliation = '2019-02-12' ;
        EngagementWrapper.creeLe = '2019-02-12' ;
        EngagementWrapper.modifieLe = '2019-02-12' ;
        EngagementWrapper.prixEstimeHt = '23543' ;
        EngagementWrapper.societe = 'Société' ;
        EngagementWrapper.pole = 'Pôle';
        EngagementWrapper.codeSite = '5678' ;
        EngagementWrapper.dateCreaDevis = '2019-02-12' ;
        EngagementWrapper.dateAcceptDevis = '2019-02-12' ;
        EngagementWrapper.dateRefusDevis = '2019-02-12' ;
        return EngagementWrapper;     
    }
    @isTest static void test_Engagement_exist() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
 @isTest static void test_champs_vides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            eng.dateAcceptation='';
            eng.dateResiliation='';
            eng.creeLe='';
            eng.modifieLe='';
            eng.prixEstimeHt='';
            eng.dateCreaDevis='';
            eng.dateAcceptDevis='';
            eng.dateRefusDevis='';
            eng.codeSite='';
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void Test_CodeSite_Invalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            eng.codeSite='8963';
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
        @isTest static void Test_Exception() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            eng.prixEstimeHt='123456654';
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void Test_Creation_Exception() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            Eng.idEngagement = '3243' ;
            eng.prixEstimeHt='123456654';
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void Test_idEng_Manquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            Eng.idEngagement = '' ;
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.message=='Erreur(s): L\'id Engagement est obligatoire');
            Test.stopTest();
        }
    }
    @isTest static void Test_Creation_succes() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            Eng.idEngagement = '3243' ;
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void Test_Creation_CodeSite_Invalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            Eng.idEngagement = '3243' ;
            eng.codeSite='8963';
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
     @isTest static void Test_CodeSite_vide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Engagement__c newEng = new BS_Engagement__c(name='5031', BS_ID_engagement_Az__c='1234',BS_Client__c=newAccount.id, BS_Site__c=newSite.id);
        insert newEng;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Engagement.EngagementWrapper eng =getEngagementWrapper();
            Eng.idEngagement = '3243' ;
            eng.codeSite='';
            Structure_Engagement.MessageRetour msg= WS06_UpsertEngagement.upsertEngagement(eng);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    

}