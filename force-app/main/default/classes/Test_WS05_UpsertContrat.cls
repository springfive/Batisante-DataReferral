/**
* @author Amine SARBOUTE
* @date 10/10/2020
* @description  :Test_WS05_UpsertContrat
* la classe de test du web service WS05_UpsertContrat
*/
@isTest(SeeAllData = true)
public class Test_WS05_UpsertContrat{
    public static Structure_Contrat.ContratWrapper getContratWrapper() {
        Structure_Contrat.ContratWrapper contratWrapper  = new Structure_Contrat.ContratWrapper();        
        contratWrapper.creeLe = '2019-02-12';
        contratWrapper.noContrat = '2005' ;
        contratWrapper.noPosition = '1234' ;
        contratWrapper.libelleContrat = 'test' ;
        contratWrapper.montantHT = '3421' ;
        contratWrapper.statut = 'O' ;
        contratWrapper.dateInsertion = '2019-02-12' ;
        contratWrapper.dateAcception = '2019-02-12' ;
        contratWrapper.dateEffet = '2019-02-12';
        contratWrapper.dateInsertResil = '2019-02-12' ;
        contratWrapper.societe = 'société' ;
        contratWrapper.pole = 'pole' ;
        contratWrapper.codeSite = '1234' ;
        contratWrapper.dateEffetResil = '2019-02-12' ;
        contratWrapper.dateSuspension = '2019-02-12' ;
        contratWrapper.DatePropo = '2019-02-12' ;
        return contratWrapper;     
    }
    @isTest static void test_Contrat_exist() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        BS_Devis_from_Lead__c propo = new BS_Devis_from_Lead__c(Name = 'propTest',  Contact_Soci_t__c='test');
        insert propo;
        String nProp = [Select Id, BS_N_Devis__c from BS_Devis_from_Lead__c where Id =: propo.Id limit 1].BS_N_Devis__c;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.idLeadCRM = nProp;
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            //system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_champs_invalides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.codeSite='1424';
            contrat.statut='Z';
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
     @isTest static void test_Exceptions() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.dateEffetResil = '1209-02-12' ;
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_champs_vides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.creeLe='';
            contrat.montantHT='';
            contrat.dateInsertion='';
            contrat.statut='';
            contrat.dateAcception='';
            contrat.dateEffet='';
            contrat.dateInsertResil='';
            contrat.dateEffetResil='';
            contrat.dateSuspension='';
            contrat.DatePropo='';
            contrat.dateEffetResil='';
            contrat.codeSite='';
            
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_creation_succes() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        BS_Devis_from_Lead__c propo = new BS_Devis_from_Lead__c(Name = 'propTest',  Contact_Soci_t__c='test');
        insert propo;
        String nProp = [Select Id, BS_N_Devis__c from BS_Devis_from_Lead__c where Id =: propo.Id limit 1].BS_N_Devis__c;
        System.debug('#nProp = '+nProp);
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.noPosition='23543';
            contrat.idLeadCRM = nProp;
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
           // system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_creation_exception() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.noPosition='23543';
            contrat.dateEffetResil = '1209-02-12' ;
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_creation_champsInvalides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.noPosition='23543';
            contrat.codeSite='1424';
            contrat.statut='V';
            contrat.dateEffetResil = '1209-02-12' ;
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_creation_champsMaquants() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.noPosition='23543';
            contrat.codeSite='';
            contrat.statut = '' ;
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_Ncontrat_manquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        Contract newContrat = new Contract(Status='Contrat Suspendu',name='1234',BS_N_Contrat__c='1234',AccountId=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newContrat;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contrat.ContratWrapper contrat =getContratWrapper();
            contrat.noPosition='';
            Structure_Contrat.MessageRetour msg= WS05_UpsertContrat.upsertContrat(contrat);
            system.debug(msg.message);
            system.assert( msg.message=='Erreur(s): Le N de contrat est obligatoire');
            Test.stopTest();
        }
    }
}