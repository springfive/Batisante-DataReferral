@isTest
public class Test_Data_Factory {
    
    public static User getUserWithCoProfile() {

        Profile pf1 = [select id, Name from Profile p where Name = 'Commercial sédentaire'];

        User user = new User(LastName = 'Test User', Username = 'tuu1@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu1' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',
                             ProfileId = pf1.Id, LanguageLocaleKey = 'fr');

        insert user;
        return user;
    }
    public static User getUserWithProfilAdmin() {

        Profile pf1 = [select id, Name from Profile p where Id = :UserInfo.getProfileId()];

        User user = new User(LastName = 'Test User', Username = 'tuu1@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu1' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',
                             ProfileId = pf1.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true);

        insert user;
        return user;
    }
    public static User getUserWithProfilInterfaceAzur() {

        Profile pf2 = [select id, Name from Profile p where name ='Interfaces Azur'];

        User user = new User(LastName = 'Test User', Username = 'tuu1@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu1' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',
                             ProfileId = pf2.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true);

        insert user;
        return user;
    }
    
    public static User User1() {

        Profile pf2 = [select id, Name from Profile p where name ='System Administrator'];

        User user = new User(LastName = 'Test User1', Username = 'tuu1@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu1' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',IsActive = true,
                             ProfileId = pf2.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true,BS_Trigramme__c = 'ABC');

        Insert user;
        return user;
    }
    
    public static User User2() {

        Profile pf2 = [select id, Name from Profile p where name ='System Administrator'];

        User user = new User(LastName = 'Test User2', Username = 'tuu2@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu2' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',IsActive = true,
                             ProfileId = pf2.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true,BS_Trigramme__c = 'BCD');

        Insert user;
        return user;
    }
    
    public static User User3() {

        Profile pf2 = [select id, Name from Profile p where name ='System Administrator'];

        User user = new User(LastName = 'Test User3', Username = 'tuu3@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu3' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',IsActive = true,
                             ProfileId = pf2.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true,BS_Trigramme__c = 'CDE');

        Insert user;
        return user;
    }
    
    public static User VendeursSTGestionnaire() {

        Profile pf2 = [select id, Name from Profile p where name ='System Administrator'];

        User user = new User(LastName = 'Test User4', Username = 'tuu4@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu4' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',IsActive = true,BS_ByPass_Trigger__c = true,
                             ProfileId = pf2.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true,BS_Trigramme__c = 'ADC');

        Insert user;
        return user;
    }
    
    public static User User4() {

        Profile pf2 = [select id, Name from Profile p where name ='Interfaces Azur'];

        User user = new User(LastName = 'Automate', Username = 'tuu1@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu1' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',IsActive = true,
                             ProfileId = pf2.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true,BS_Trigramme__c = 'ABC');

        Insert user;
        return user;
    }
    public static User User5() {

        Profile pf2 = [select id, Name from Profile p where name ='Interfaces Azur'];

        User user = new User(LastName = 'Automate', Username = 'tuu4@test.com',
                             Email = 'testuser@test.com', Alias = 'tu1' , CommunityNickname = 'tu4' , TimeZoneSidKey = 'Europe/Paris',
                             LocaleSidKey = 'fr', EmailEncodingKey = 'ISO-8859-1',IsActive = true,BS_ByPass_Trigger__c = true,
                             ProfileId = pf2.Id, LanguageLocaleKey = 'fr',BS_ByPass_VR__c =true,BS_Trigramme__c = 'ADC');

        Insert user;
        return user;
    }
    
    public static Account createAccount(Id user_Id,Id uId){
      Id recordtypeId =  [select Id,Name,SobjectType  from RecordType  where SobjectType = 'Account' AND Name = 'ADB'].Id;
        Account ac = new Account(BS_Id_ClientAzur__c = '42249',BS_Code_client__c = 'POOM9',Name = 'POINT OMEGA',BS_PDS__c = false,RecordTypeId = recordtypeId,
                    BS_Activite__c = 'Clients Multisites',BS_Groupe__c = 'LPCR',BS_Region__c = 'IDF',ShippingStreet = '6 All仔 JEAN PROUVE',ShippingPostalCode = '92110',
                    ShippingCity = 'CLICHY',Phone = '0141408181',BS_N_SIRET__c = '00000000000000',BS_Client_a_risque_SF__c = false,BS_Code_Vendeur__c = 'AUJ',
                    BS_Vendeur_Solution_technique__c = user_Id,BS_Cree_le_Azur__c = Date.valueOf('2015-07-08'),BS_Modifie_le_Azur__c = Date.valueOf('2022-05-12'),BS_Vendeur_PE__c = uId,
                    BS_Montant_des_avoirs__c = Decimal.valueOf('0'),BS_Montant_des_impayes__c = Decimal.valueOf('102622.53'),BS_Date_convention_PE_signee__c = Date.Today(),BS_Client_reserve__c = 'F'
   /* BS_Telephone_2__c = '',
    BS_Vendeur_PE__c = '',
    BS_Fax__c = '',
    BS_Adresse_mail__c = '',
    BillingStreet = '',
    BillingPostalCode = '',
    BillingCity = '',
    BS_Date_resiliation_convention_ASS__c = '',
    BS_Date_convention_ASS_signee__c = '',
    BS_Date_resiliation_convention_PE__c = ''*/
        );
        insert ac;
        return ac;
    }
    public static Account createAccount1(Id uId){
      Id recordtypeId =  [select Id,Name,SobjectType  from RecordType  where SobjectType = 'Account' AND Name = 'CFE'].Id;
        Account ac = new Account(BS_Id_ClientAzur__c = '42249',BS_Code_client__c = 'POOM9',Name = 'POINT OMEGA',BS_PDS__c = false,RecordTypeId = recordtypeId,
                    BS_Activite__c = 'Santé',BS_Groupe__c = 'LPCR',BS_Region__c = 'IDF',ShippingStreet = '6 All仔 JEAN PROUVE',ShippingPostalCode = '92110',
                    ShippingCity = 'CLICHY',Phone = '0141408181',BS_N_SIRET__c = '00000000000000',BS_Client_a_risque_SF__c = false,/*BS_Code_Vendeur__c = 'AUJ',*/
                    BS_Cree_le_Azur__c = Date.valueOf('2015-07-08'),BS_Modifie_le_Azur__c = Date.valueOf('2022-05-12'),/*BS_Vendeur_PE__c = uId,*/
                    BS_Montant_des_avoirs__c = Decimal.valueOf('0'),BS_Montant_des_impayes__c = Decimal.valueOf('102622.53'),BS_Date_convention_PE_signee__c = Date.Today(),BS_Client_reserve__c = 'U'
   /* BS_Telephone_2__c = '',
    BS_Vendeur_PE__c = '',
    BS_Fax__c = '',
    BS_Client_reserve__c = '',
    BS_Adresse_mail__c = '',
    BillingStreet = '',
    BillingPostalCode = '',
    BillingCity = '',
    BS_Date_resiliation_convention_ASS__c = '',
    BS_Date_convention_ASS_signee__c = '',
    BS_Date_resiliation_convention_PE__c = ''*/
        );
        insert ac;
        return ac;
    }
    
    public static Account createAccount2(Id uId){
      Id recordtypeId =  [select Id,Name,SobjectType  from RecordType  where SobjectType = 'Account' AND Name = 'CFE'].Id;
        Account ac = new Account(BS_Id_ClientAzur__c = '777TestSite777',BS_Code_client__c = 'POOM9',Name = 'POINT OMEGA',BS_PDS__c = false,RecordTypeId = recordtypeId,
                    BS_Activite__c = 'Santé',BS_Groupe__c = 'LPCR',BS_Region__c = 'IDF',ShippingStreet = '6 All仔 JEAN PROUVE',ShippingPostalCode = '92110',
                    ShippingCity = 'CLICHY',Phone = '0141408181',BS_N_SIRET__c = '00000000000000',BS_Client_a_risque_SF__c = false,/*BS_Code_Vendeur__c = 'AUJ',*/
                    BS_Cree_le_Azur__c = Date.valueOf('2015-07-08'),BS_Modifie_le_Azur__c = Date.valueOf('2022-05-12'),/*BS_Vendeur_PE__c = uId,*/
                    BS_Montant_des_avoirs__c = Decimal.valueOf('0'),BS_Montant_des_impayes__c = Decimal.valueOf('102622.53'),BS_Date_convention_PE_signee__c = Date.Today(),BS_Client_reserve__c = 'U'
   /* BS_Telephone_2__c = '',
    BS_Vendeur_PE__c = '',
    BS_Fax__c = '',
    BS_Client_reserve__c = '',
    BS_Adresse_mail__c = '',
    BillingStreet = '',
    BillingPostalCode = '',
    BillingCity = '',
    BS_Date_resiliation_convention_ASS__c = '',
    BS_Date_convention_ASS_signee__c = '',
    BS_Date_resiliation_convention_PE__c = ''*/
        );
        insert ac;
        return ac;
    }
    public static Contact createContact(Id accountID){
        Id recordtypeId = [select Id,Name,SobjectType  from RecordType  where SobjectType = 'Contact' AND Name = 'Contact Site'].Id;
        Contact con = new Contact(AccountId = accountID,RecordTypeId = recordtypeId,LastName = 'testContact',BS_Id_Contact_Azur__c = '12345',BS_Id_Source__c='777TestSite777');
        insert con;
        return con;
    }
    public static Contact createContact1(Id accountID){
        Id recordtypeId = [select Id,Name,SobjectType  from RecordType  where SobjectType = 'Contact' AND Name = 'Contact Client'].Id;
        Contact con = new Contact(AccountId = accountID,RecordTypeId = recordtypeId,LastName = 'testContact',BS_Id_Contact_Azur__c = '12345',BS_Principal__c = true,title='Gestionnaire',BS_Id_Source__c='777TestSite777');
        insert con;
        return con;
    }
    public static Schema.Location createSite(Id accountID){
        Id recordtypeId = [select Id,Name,SobjectType  from RecordType  where SobjectType = 'Location' AND Name = 'Lieu'].Id;
        
        Schema.Location site = new Schema.Location(RecordTypeId = recordtypeId,BS_Client__c = accountID,Name = '777TestSite777',BS_Id_Client_Azur__c = '42249',BS_Code_Site__c = '777TestSite777',
                            BS_N__c = '362 BIS',BS_Type_voie__c = 'rue de',BS_Nom_voie__c = 'VAUGIRARD',BS_Code_Postal__c = Decimal.valueOf('75015'),BS_Ville__c = 'PARIS',BS_HAB__c = false,BS_ERT__c = false,BS_IGH__c = false,BS_ZAR__c = false,BS_Acces__c = '3691A',
                            BS_Date_changement_Syndic__c = Date.valueOf('2018-03-26'),BS_Ancien_client__c = 'MILLON ST LAMBERT',BS_nb_cages_escaliers__c = Decimal.valueOf('1'),BS_LOT__c = Decimal.valueOf('22'),
                            BS_Niveau__c = Decimal.valueOf('0'),BS_Nb_places_parking__c = Decimal.valueOf('0'),BS_Nb_ascenseurs__c = Decimal.valueOf('0'),BS_Nombre_de_contrats_en_O__c = Decimal.valueOf('0'),BS_Montant_offres_en_cours__c = Decimal.valueOf('0'),
                            BS_Nombre_de_contrats_en_C__c = Decimal.valueOf('0'),BS_Nombre_de_contrats_en_S__c = Decimal.valueOf('0'),BS_Nombre_de_contrats_en_K__c = Decimal.valueOf('0'),BS_Portfeuille_Contractuel__c = Decimal.valueOf('16.17'),
                            BS_Nombre_de_contrats_en_R__c = Decimal.valueOf('0'),BS_Montant_resiliations_3M__c = Decimal.valueOf('0'),BS_CA_Diag__c = Decimal.valueOf('0'),BS_CA_Christal__c = Decimal.valueOf('0'),BS_CA_Sagex__c = Decimal.valueOf('0'),
                            BS_CA_ST__c = Decimal.valueOf('0')/*IdAzur__c = '777TestSite777',LocationType = 'Site',BS_Date_creation_visite__c = '',BS_Complement__c = '',BS_Date_prevue_visite__c = '',BS_Date_visite__c = '',BS_Nom_residence__c = '',BS_Ref_Client__c = '',BS_ERP__c = ''*/);
        insert site;
        return site;
    }
    
    public static Contract createContract(Id accountID,Id siteId){
        Contract cont = new Contract(AccountId = accountID,BS_N_contrat__c  = '1006110',BS_Code_site__c  = '777TestSite777',BS_Prestation__c = '2802',BS_Libelle_du_contrat__c = 'Contrat de vŽrif. EXTINCTEURS FNCN',BS_Societe__c = 'SAGEX',BS_Pole__c = 'SŽcu inc.',BS_Emplacement__c = siteId,
                                     BS_Date_insertion__c  = Date.valueOf('2022-06-09'),BS_Date_propo__c  = Date.valueOf('2022-06-09'),BS_Date_acceptation__c  = Date.valueOf('2022-06-09'),BS_Date_effet__c  = Date.valueOf('2022-01-01'),/*BS_date_insertion_resiliation__c  = ,BS_Date_suspension__c  = ,*/Status  = 'Contrat en cours',BS_Montant_total_HT__c  = Decimal.valueOf('139.08'),BS_Date_creation_Azur__c  = Date.valueOf('2022-06-09'));
        insert cont;
        return cont;
    }
    public static BS_Engagement__c createBS_Engagement(Id accountID,Id siteId){
        BS_Engagement__c eng = new BS_Engagement__c(BS_Client__c =  accountID,BS_Emplacement__c = siteId,Name =  '433401',BS_ID_engagement_Az__c =  '433401',BS_Code_site__c =  siteId,
                                    BS_Prestation__c =  '4302',BS_Societe__c =  'D. E. P.',BS_Pole__c =  'Contr™le',BS_Date_creation_devis_Az__c = Date.valueOf('2023-07-06'),BS_Date_creation_Az__c =  Date.valueOf('2023-07-06'),
                                    BS_Date_modification_Az__c =  Date.valueOf('2023-07-06'),BS_Prix_estime_HT__c =  Decimal.valueOf('230.14'));
    /*BS_Date_acceptation__c =  ,
    BS_Date_de_resiliation__c =  ,
    BS_Date_acceptation_Devis__c =  ,
    BS_Date_refus_devis__c =  ,*/
        insert eng;
        return eng;
    }
    
    public static BS_BDC__c createBDC(Id accountID){
        BS_BDC__c bdc = new BS_BDC__c(BS_Client__c =  accountID,BS_N_element__c =  '386778',BS_Code_Site__c =  '777TestSite777',BS_Prestation__c =  'EL100',BS_N_BDC__c = '52123',
                                  BS_LiBelle__c =  'VŽrifications rŽglementaires pŽriodiques des Appareils de levage',BS_Societe__c =  '01 CONTROLE',BS_Pole__c =  'Contr™le',BS_Date_insertion__c =  Date.valueOf('2023-07-26'),
                                  BS_Date_acceptation__c =  Date.valueOf('2023-07-26'),BS_Date_effet__c =  Date.valueOf('2023-01-01'),BS_Date_de_fin__c =  Date.valueOf('2023-12-31'),
                                  BS_Date_insertion_resiliation__c =  Date.valueOf('2023-12-31'),BS_Date_effet_resiliation__c =  Date.valueOf('2023-12-31'),
                                  BS_Statut__c =  'Contrat en cours',BS_Prix_HT__c =  Decimal.valueOf('3445.2'),name =  '52123');
        insert bdc;
        return bdc;
    }
    
    public static BS_Devis__c createDevis(Id accountID,Id siteId){
        BS_Devis__c dev = new BS_Devis__c(BS_Nom_Client__c = accountID,BS_Emplacement__c = siteId,
    BS_N_Ope__c = '7313847',BS_Code_Site__c = '777TestSite777',BS_Origine1__c = 'Suite maintenance',BS_Type_Ope__c = 'DEVBPB',
    Name = 'Devis Equipement(s) Bloc(s) Porte(s) coupe-feu GRI',BS_Societe__c = 'GRI',BS_Pole__c = 'SŽcu inc.',BS_N_Ticket__c = '508168',
    BS_Cree_le_Azur__c = Date.valueOf('2023-07-21'),BS_Cree_par_Azur__c = 'SMY',BS_Modifie_le_Azur__c = Date.valueOf('2023-08-28'),
    BS_Date_Accord__c = Date.valueOf('2023-07-21'),BS_Total_HT__c = Decimal.valueOf('68.85')/*    BS_Tech__c = '',
        BS_Date_Annul__c = '',
    BS_Date_Perdu__c = '',
    BS_Manager_Tech__c = '',
    BS_Societe_Tech__c = '',
    BS_Info_Com__c = '',
    Auteur_Rapport__c = '',*/);
        insert dev;
        return dev;
    }
    public static WorkOrder createWorkOrder(Id account_Id,Id siteId,Id contact_Id){
        WorkOrder wo = new WorkOrder(AccountId = account_Id,LocationID = siteId,ContactId = contact_Id,AzurItentionId__c = '12987',Street = '104Rue duGENERAL LECLERC',
                            City = 'BRIE COMTE ROBERT',PostalCode = '77170.0',Country = 'France',Subject = '3DCS 75006PARIS',duration = Decimal.valueOf('0.5'),
                            DurationType = 'Hours',StartDate = Date.valueOf('2023-10-17'),EndDate = Date.valueOf('2023-10-30'),
                            SiteCode__c = '777TestSite777',RdvStatus__c = 'SANS RDV');
        insert wo;
        return wo;
    }
    
    public static WorkOrder createWorkOrder1(Id account_Id,Id siteId,Id contact_Id){
        WorkOrder wo1 = new WorkOrder(AccountId = account_Id,LocationID = siteId,ContactId = contact_Id,AzurItentionId__c = '12988',Street = '104Rue duGENERAL LECLERC',
                            City = 'BRIE COMTE ROBERT',PostalCode = '77170.0',Country = 'France',Subject = '3DCS 75006PARIS',duration = Decimal.valueOf('0.5'),
                            DurationType = 'Hours',StartDate = Date.valueOf('2023-10-17'),EndDate = Date.valueOf('2023-10-30'),
                            SiteCode__c = '777TestSite77',RdvStatus__c = 'SANS RDV');
        insert wo1;
        return wo1;
    }
    public static SchedulingConstraint createSC(){  
        SchedulingConstraint sc = new SchedulingConstraint(Name = 'TestSC');
            insert sc;
            return sc;
    }
    
    public static ServiceResource createSR(Id user_Id, Id scId){    
        ServiceResource sc = new ServiceResource(Name = 'TestSR',RelatedRecordId = user_Id,ResourceType='T',SchedulingConstraintId = scId,IsActive = true);
            insert sc;
            return sc;
    }
    public static OperatingHours createOH(){
        OperatingHours oh = new OperatingHours(Name = 'nine to five', TimeZone = 'Europe/Paris');
        insert oh;
        return oh;
    }
    public static ServiceTerritory createST(Id ohId, Id scId){
        ServiceTerritory st = new ServiceTerritory(Name = 'Test',OperatingHoursId = ohId,SchedulingConstraintId = scId,IsActive = true);
        insert st;
        return st;
    }
    public static ServiceTerritoryMember createSTM(Id srId,Id stId,Id ohId){
        ServiceTerritoryMember stm = new ServiceTerritoryMember(TerritoryType = 'p',ServiceResourceId = srId,ServiceTerritoryId = stId,OperatingHoursId = ohId,EffectiveStartDate = Date.valueOf('2023-10-16'));
        insert stm;
        return stm;
    }
    public static AssignedResource createAR(Id srId, Id saId){
        AssignedResource ar = new AssignedResource(ServiceAppointmentId = saId,ServiceResourceId = srId);
        insert ar;
        return ar;
    }
    
    public static ServiceAppointment createSA(Id workOrder_Id,Id contact_Id ){
        ServiceAppointment sa =  new ServiceAppointment(ParentRecordId = workOrder_Id,ContactId = contact_Id,Subject = '3DCS 75006PARIS',
                                    AZURIntentionId__c = '12987',Intervenant__c = 'ABC/BCD',Street = '104Rue duGENERAL LECLERC',City = 'BRIE COMTE ROBERT',
                                    PostalCode = '77170.0',Duration = Decimal.valueOf('0.5'),Country = 'France',DurationType = 'Hours',EarliestStartTime = Date.valueOf('2023-10-17'),
                                    DueDate = Date.valueOf('2023-10-30'),SchedStartTime = Date.valueOf('2023-10-17'),SchedEndTime = Date.valueOf('2023-10-30'),
                                    RdvStatus__c = 'SANS RDV');
        insert sa;
        return sa;
    } 
    public static ServiceAppointment createSA1(Id workOrder_Id,Id contact_Id ){
        ServiceAppointment sa =  new ServiceAppointment(ParentRecordId = workOrder_Id,ContactId = contact_Id,Subject = '3DCS 75006PARIS',
                                    AZURIntentionId__c = '12987',Intervenant__c = '',Status = 'Aucun',Street = '104Rue duGENERAL LECLERC',City = 'BRIE COMTE ROBERT',
                                    PostalCode = '77170.0',Duration = Decimal.valueOf('0.5'),Country = 'France',DurationType = 'Hours',EarliestStartTime = Date.valueOf('2023-10-17'),
                                    DueDate = Date.valueOf('2023-10-30'),SchedStartTime = Date.valueOf('2023-10-17'),SchedEndTime = Date.valueOf('2023-10-30'),
                                    RdvStatus__c = 'SANS RDV');
        insert sa;
        return sa;
    } 
    
    public static ServiceAppointment createSA2(Id workOrder_Id,Id contact_Id ){
        ServiceAppointment sa =  new ServiceAppointment(ParentRecordId = workOrder_Id,ContactId = contact_Id,Subject = '3DCS 75006PARIS',
                                    AZURIntentionId__c = '12987',Status = 'Aucun',Street = '104Rue duGENERAL LECLERC',City = 'BRIE COMTE ROBERT',
                                    PostalCode = '77170.0',Duration = Decimal.valueOf('0.5'),Country = 'France',DurationType = 'Hours',EarliestStartTime = Date.valueOf('2023-10-17'),
                                    DueDate = Date.valueOf('2023-10-30'),SchedStartTime = Date.valueOf('2023-10-17'),SchedEndTime = Date.valueOf('2023-10-30'),
                                    RdvStatus__c = 'SANS RDV');
        insert sa;
        return sa;
    }
    public static ServiceAppointment createSA3(Id workOrder_Id,Id contact_Id ){
        ServiceAppointment sa =  new ServiceAppointment(ParentRecordId = workOrder_Id,ContactId = contact_Id,Subject = '3DCS 75006PARIS',
                                    AZURIntentionId__c = '12987',Intervenant__c = '',Street = '104Rue duGENERAL LECLERC',City = 'BRIE COMTE ROBERT',
                                    PostalCode = '77170.0',Duration = Decimal.valueOf('0.5'),Country = 'France',DurationType = 'Hours',EarliestStartTime = Date.valueOf('2023-10-17'),
                                    DueDate = Date.valueOf('2023-10-30'),SchedStartTime = Date.valueOf('2023-10-17'),SchedEndTime = Date.valueOf('2023-10-30'),
                                    RdvStatus__c = 'SANS RDV');
        insert sa;
        return sa;
    }
    public static ServiceAppointment createSA4(Id workOrder_Id,Id contact_Id ){
        ServiceAppointment sa =  new ServiceAppointment(ParentRecordId = workOrder_Id,ContactId = contact_Id,Subject = '3DCS 75006PARIS',
                                    AZURIntentionId__c = '12987',Intervenant__c = 'ADC',Status = 'Expédié', Street = '104Rue duGENERAL LECLERC',City = 'BRIE COMTE ROBERT',
                                    PostalCode = '77170.0',Duration = Decimal.valueOf('0.5'),Country = 'France',DurationType = 'Hours',EarliestStartTime = Date.valueOf('2023-10-17'),
                                    DueDate = Date.valueOf('2023-10-30'),SchedStartTime = Date.valueOf('2023-10-17'),SchedEndTime = Date.valueOf('2023-10-30'),
                                    RdvStatus__c = 'SANS RDV');
        insert sa;
        return sa;
    }
    
    public static WorkOrderLineItem createwoli(Id woId,Id siteId,Id contactId,Id contract_Id){
          Id recordtypeId = [Select Id,SobjectType, Name from RecordType where SobjectType = 'WorkOrderLineItem' AND Name = '3D_Lot'].Id;
        WorkOrderLineItem woli = new WorkOrderLineItem(
            AzurOperationId__c = '133311',
    SourceCode__c = Decimal.valueOf('1'),
    LocationID = siteId,
    RecordTypeId = recordtypeId,
    Contact__c = contactId,
    Subject = '3DCS 75006PARIS',
    WorkOrderId = woId,
    Description = ' le 30/01/20: info gardienne 8h-12h-16h les coordonnées téléphoniques  de M Huguenin sont maintenant dans la base ',
    InternalComments__c = 'ibo le 30/01/20: info gardienne 8h-12h-16h les coordonnées téléphoniques  de M Huguenin sont maintenant dans la base ',
    OperationType__c = 'SO_PI',
    Street = '104Rue duGENERAL LECLERC',
    City = 'BRIE COMTE ROBERT',
    PostalCode = '77170.0',
    Country = 'France',
    ContractId__c = '1006111',
    Contract__c = contract_Id,
    //BDC__c = '',
    //ServiceReportTemplateId = '0SL1l00000002iPGAQ',
    AssociatedOperationId__c = '0',
    //OpePrec__c = '',
    Duration = Decimal.valueOf('0.5'),
    DurationType = 'Hours',
    StartDate = Date.valueOf('2023-10-14'),
    EndDate = Date.valueOf('2023-10-14'),
    NbEquipement__c = Decimal.valueOf('77'),
    AgenceCode__c = '1',
    LastVisitDate__c = Date.valueOf('2023-08-01'),
            Status = 'InProgress'
        );
        
        insert woli;
        return woli;        
    }
    
    public static WorkOrderLineItem createwoli1(Id woId,Id siteId,Id contactId,Id contract_Id,Id woliId){
          Id recordtypeId = [Select Id,SobjectType, Name from RecordType where SobjectType = 'WorkOrderLineItem' AND Name = '3D_Lot'].Id;
        WorkOrderLineItem woli = new WorkOrderLineItem(
            AzurOperationId__c = '133311',
    SourceCode__c = Decimal.valueOf('1'),
    LocationID = siteId,
    RecordTypeId = recordtypeId,
    Contact__c = contactId,
    Subject = '3DCS 75006PARIS',
    WorkOrderId = woId,
    Description = ' le 30/01/20: info gardienne 8h-12h-16h les coordonnées téléphoniques  de M Huguenin sont maintenant dans la base ',
    InternalComments__c = 'ibo le 30/01/20: info gardienne 8h-12h-16h les coordonnées téléphoniques  de M Huguenin sont maintenant dans la base ',
    OperationType__c = 'SO_PI',
    Street = '104Rue duGENERAL LECLERC',
    City = 'BRIE COMTE ROBERT',
    PostalCode = '77170.0',
    Country = 'France',
    ContractId__c = '1006111',
    Contract__c = contract_Id,
    //BDC__c = '',
    //ServiceReportTemplateId = '0SL1l00000002iPGAQ',
    AssociatedOperationId__c = '0',
    OpePrec__c = woliId,
    Duration = Decimal.valueOf('0.5'),
    DurationType = 'Hours',
    StartDate = Date.valueOf('2023-10-14'),
    EndDate = Date.valueOf('2023-10-14'),
    NbEquipement__c = Decimal.valueOf('77'),
    AgenceCode__c = '1',
    LastVisitDate__c = Date.valueOf('2023-08-01'),
            Status = 'InProgress'
        );
        
        insert woli;
        return woli;        
    }
    public static Lot1__c createLot1(Id woliId){
        Lot1__c lot = new Lot1__c(WOLI__c =woliId,LotStatus__c ='Refus');
        insert lot;
        return lot;
    }
    
    public static AffectedEquipmentsProducts__c createAEP(Id woliId){
        AffectedEquipmentsProducts__c aep = new AffectedEquipmentsProducts__c(WOLI__c =woliId);
        insert aep;
        return aep;
    }
    
    public static ActionPlan__c createAP(Id woliId){
        ActionPlan__c ap = new ActionPlan__c(WOLI__c =woliId);
        insert ap;
        return ap;
    }
}