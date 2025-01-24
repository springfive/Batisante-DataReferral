/**
* @author Amine SARBOUTE
* @date 10/10/2020
* @description  :Test_WS04_UpsertDevis
* la classe de test du web service WS04_UpsertDevis
*/
@isTest(SeeAllData = true)
public class Test_WS04_UpsertDevis{

    public static Structure_Devis.DevisWrapper getDevisWrapper() {
        Structure_Devis.DevisWrapper devisWrapper  = new Structure_Devis.DevisWrapper();        
        devisWrapper.nOpe = '2345';
        devisWrapper.typeOpe = '3D_14' ;
        devisWrapper.nTicket = 'ticket' ;
        devisWrapper.societe = 'société' ;
        devisWrapper.pole = 'Hygiène' ;
        devisWrapper.origine = 'Client_DET' ;
        devisWrapper.tech = 'tech' ;
        devisWrapper.managerTech = 'manager' ;
        devisWrapper.societeTech = 'societeTech';
        devisWrapper.creeLe = '2019-02-12' ;
        devisWrapper.modifieLe = '2019-02-12' ;
        devisWrapper.dateAnnul = '2019-02-12' ;
        devisWrapper.datePerdu = '2019-02-12' ;
        devisWrapper.dateAccord = '2019-02-12' ;
        devisWrapper.montantTotal = '12345' ;
        devisWrapper.designation = 'Désinsectisation Générale - Ponctuelle' ;
        devisWrapper.codeSite = '1234' ;
        devisWrapper.creePar = '2019-02-12' ;
        devisWrapper.InfoCom = 'info' ;
        devisWrapper.AuteurRapport = 'FRA' ;
        return devisWrapper;     
    }
    @isTest static void test_devis_exist() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location (name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Devis__c newDevis = new BS_Devis__c (name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        BS_Devis_from_Lead__c propo = new BS_Devis_from_Lead__c(Name = 'propTest',  Contact_Soci_t__c='test');
        insert propo;
        String nProp = [Select Id, BS_N_Devis__c from BS_Devis_from_Lead__c where Id =: propo.Id limit 1].BS_N_Devis__c;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.IdLeadCRM = nProp;
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void codeSite_invalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.codeSite='8767';
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_champs_manquants_invalides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5766', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.creeLe='';
            devis.creePar='';
            devis.modifieLe='';
            devis.dateAnnul='';
            devis.datePerdu='';
            devis.dateAccord='';
            devis.montantTotal='';
            devis.codeSite = '' ;
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
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
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.InfoCom = 'infocom' ;
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_Nope_manquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.nope='';
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.message=='Erreur(s): Le n° Opé est obligatoire');
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
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        BS_Devis_from_Lead__c propo = new BS_Devis_from_Lead__c(Name = 'propTest',  Contact_Soci_t__c='test');
        insert propo;
        String nProp = [Select Id, BS_N_Devis__c from BS_Devis_from_Lead__c where Id =: propo.Id limit 1].BS_N_Devis__c;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.nope='5876';
            devis.idLeadCRM = nProp;
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_creation_OwnerDevis() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        Profile pf = [select id, Name from Profile p where name='Commercial sédentaire'];
        User ownerDevis = new User(LastName = 'Test User', Username = 'asatest@test12.com',
                             Email = 'test@test.com', Alias = 'TT' , CommunityNickname = 'TT' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1', BS_Trigramme__c='ASA',
                             ProfileId = pf.Id, LanguageLocaleKey = 'fr');
        insert ownerDevis;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.nope='5876';
            devis.creePar='ASA';
            devis.codeSite='56868';
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
     @isTest static void test_creation_exceptions() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.nope='5876';
            devis.InfoCom = 'infocom' ;
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
     @isTest static void test_creation_codeSite_manquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='1234', BS_Code_Postal__c=75008);
        insert newSite;
        BS_Devis__c newDevis = new BS_Devis__c(name='test',BS_N_Ope__c='2345',BS_Nom_Client__c=newAccount.id, BS_Emplacement__c=newSite.id);
        insert newDevis;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Devis.DevisWrapper devis =getDevisWrapper();
            devis.nope='5876';
            devis.codeSite='';
            Structure_Devis.MessageRetour msg= WS04_UpsertDevis.upsertDevis(devis);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }

}