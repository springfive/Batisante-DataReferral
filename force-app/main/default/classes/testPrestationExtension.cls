@isTest
public class testPrestationExtension {
    
    @isTest static void testConfirmationPage() {
        ID dpID = TestsAvantMEP.insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        List<Dictionnaire_Prestations__c> dicos = TestsAvantMEP.insertDicos();
        
        ID nullDP = TestsAvantMEP.insertDpNull(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id;//0127a000001UsahAAC
        Prestation__c presta = new Prestation__c();
        presta.Prix_Unitaire_HT__c = 110;
        presta.Libell__c = '2103 - Dératisation parties communes';
        presta.Devis_Pistes__c = dpID;
		presta.P_le__c = 'Hygiène';
        presta.Nombre_de_passages_annuels__c = 1;
        presta.Dictionnaire_Prestations__c = dicos[0].Id;
        
        insert presta;
        
        ApexPages.StandardController prestaControll = new ApexPages.StandardController(presta);
        prestationExtension pe = new prestationExtension(prestaControll);
        
        pe.getPrestationId();
        pe.initCheck();
        pe.confirmContract();
        pe.getLotEmpty();
    }
    
    @isTest static void testContrat2103() {   
        ID dpID = TestsAvantMEP.insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        List<Dictionnaire_Prestations__c> dicos = TestsAvantMEP.insertDicos();
        
        ID nullDP = TestsAvantMEP.insertDpNull(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id;//0127a000001UsahAAC
        Prestation__c presta = new Prestation__c();
        presta.Prix_Unitaire_HT__c = 110;
        presta.Libell__c = '2103 - Dératisation parties communes';
        presta.Devis_Pistes__c = dpID;
		presta.P_le__c = 'Hygiène';
        presta.Nombre_de_passages_annuels__c = 1;
        presta.Dictionnaire_Prestations__c = dicos[0].Id;
        presta.Coefficient__c = 1;
        presta.Prix_deplacement__c = 0;
        
        insert presta;
        Lot__c lot = new Lot__c();
        lot.Parametre_de_lot__c = [SELECT Id FROM Parametre_de_lot__c WHERE Dictionnaire_Prestations__c = :dicos[0].Id AND Name='Cage' LIMIT 1].Id;
        lot.Prestation__c = presta.Id;
        lot.Quantite__c = 2;
        lot.Prix_du_lot__c = 100;
       insert lot;
        
         Lot__c lot2 = new Lot__c();
        lot2.Parametre_de_lot__c = [SELECT Id FROM Parametre_de_lot__c WHERE Dictionnaire_Prestations__c = :dicos[0].Id AND Name='Chambre' LIMIT 1].Id;
        lot2.Prestation__c = presta.Id;
        lot2.Quantite__c = 2;
        lot2.Prix_du_lot__c = 100;
       insert lot2;
        
        Test.startTest();
        ApexPages.StandardController prestaControll = new ApexPages.StandardController(presta);
        prestationExtension pe = new prestationExtension(prestaControll);
        
        pe.getCompletePrestaName();
        pe.getContactName();
        pe.getCanceled();
        pe.getLotEmpty();
        pe.getAttestationType();
        pe.getTvaAttestation();
        pe.getCompagnyName();
        pe.getSiteAdress();
        pe.getCompetitorAdress();
        pe.getCompetitorName();
        pe.getPassageFrequencyName();
        pe.getShortDict();
        pe.getPassageFrequency();
        pe.getLotsQuantity();
        pe.getTotalPrice();
        pe.getPole();
        pe.getPrestaProposition();
        pe.getCodeDict();
        pe.getInstallPrice();
        pe.getLotsDetailPCPP();
        pe.getPrestationArray();
        pe.getNbMounthLabel(24);
        pe.getNbMounthLabel(12);
        pe.getNbMounthLabel(36);
        pe.getValueOfColumn('PERIODICITE');
        pe.getValueOfColumn('NB DE PASSAGES');
        pe.getValueOfColumn('GARANTIE');
        pe.getValueOfColumn('DATE d\'EFFET');
       // pe.buildHTMLArrayRows();
        
        pe.getPrimeName(1);
        pe.getPrimeName(2);
        pe.getPrimeName(3);
        pe.getPrimeName(4);
        pe.getPrimeName(5);
        pe.getPrimeName(6);
        pe.getPrimeName(12);
        pe.getPrimeName(13);
        pe.getFirstLetters('Test Prestation Extension');
        pe.getAttestationPoliceSize();
        pe.getChiffrageNameBlocage();
        pe.getSiteAdresseAvailable();
        pe.getCompagnyAdressAvailable();
        Pe.splitCity('adress');
        pe.getCageQuantity();
        pe.getPoliceSize();
        pe.getLotsAsStringNoCage();
        pe.getDepCoefAsString();
        pe.findPalierOfLot(lot2.Parametre_de_lot__r.Name, lot2.Parametre_de_lot__r.Dictionnaire_Prestations__r.Name);
		pe.getInstallationArray();    
        pe.getNbMounthLabelOfPrestation();
        pe.getDescriptifPrestation();
        pe.getNumberOfObjectArticle();
        pe.getLegalText();
        pe.getTitle();
        pe.getExclusions();
        pe.getAvantages();
        pe.getPhrasePrix();
        pe.getPrestataire();
        
        savePrestationContratPDF save = new savePrestationContratPDF(prestaControll);
        save.saveContratPDF();
        save.getContratId();
        save.saveContratResiliationPDF();
        save.saveContratTVAPDF();
       
        Test.stopTest();
    }
    
    @isTest static void testContrat2104() {   
        ID dpID = TestsAvantMEP.insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        List<Dictionnaire_Prestations__c> dicos = TestsAvantMEP.insertDicos();
        
        ID nullDP = TestsAvantMEP.insertDpNull(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id;//0127a000001UsahAAC
        Prestation__c presta = new Prestation__c();
            
        presta.Libell__c = '2104 - Prévention rongeurs';
        presta.Prix_Unitaire_HT__c = 110;
        presta.Devis_Pistes__c = nullDP;
		presta.P_le__c = 'Hygiène';
        presta.Nombre_de_passages_annuels__c = 1;
        presta.Dictionnaire_Prestations__c = dicos[0].Id;
        insert presta;
        Test.startTest();
        ApexPages.StandardController prestaControll = new ApexPages.StandardController(presta);
        prestationExtension pe = new prestationExtension(prestaControll);
        
        pe.getPoliceSize();
        pe.getCompletePrestaName();
        
        savePrestationContratPDF save = new savePrestationContratPDF(prestaControll);
        save.saveContratPDF();
        Test.stopTest();
    }
    
    @isTest static void testContrat2105() {
        ID dpID = TestsAvantMEP.insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        List<Dictionnaire_Prestations__c> dicos = TestsAvantMEP.insertDicos();
        
        ID nullDP = TestsAvantMEP.insertDpNull(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id;//0127a000001UsahAAC
        Prestation__c presta = new Prestation__c();
        presta.Libell__c = '2105 - Prévention - Surveillance rongeurs avec poste(s) d\'appâtage connecté(s)';
        presta.Prix_Unitaire_HT__c = 110;
        presta.Devis_Pistes__c = dpID;
		presta.P_le__c = 'Hygiène';
        presta.Nombre_de_passages_annuels__c = 1;
        presta.Prix_lots__c = 1;
        presta.Coefficient__c=1;
        presta.Dictionnaire_Prestations__c = dicos[1].Id;
        insert presta;
        Test.startTest();
        
        ApexPages.StandardController prestaControll = new ApexPages.StandardController(presta);
        prestationExtension pe = new prestationExtension(prestaControll);
        
        pe.getPoliceSize();
        pe.getCompletePrestaName();
        pe.getLotsQuantityDetails();
        
        pe.getPassagePrice();
        Test.stopTest();
    }
    
    @isTest static void testContrat2252() {
        ID dpID = TestsAvantMEP.insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        List<Dictionnaire_Prestations__c> dicos = TestsAvantMEP.insertDicos();
        
        ID nullDP = TestsAvantMEP.insertDpNull(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id;//0127a000001UsahAAC
        Prestation__c presta = new Prestation__c();
        presta.Libell__c = '2252 - Dessourisation parties communes et parties privatives';
        presta.Prix_Unitaire_HT__c = 110;
        presta.Devis_Pistes__c = dpID;
		presta.P_le__c = 'Hygiène';
        presta.Nombre_de_passages_annuels__c = 1;
        presta.Dictionnaire_Prestations__c = dicos[1].Id;
        insert presta;
        Test.startTest();
        
        ApexPages.StandardController prestaControll = new ApexPages.StandardController(presta);
        prestationExtension pe = new prestationExtension(prestaControll);
        
        pe.getPoliceSize();
        pe.getLotsQuantityOrderedByName();
        pe.getLotsDetailPCPP();
        pe.getCompletePrestaName();
        Test.StopTest();
    }
    
    @isTest static void testContrat2410() {
        
        ID dpID = TestsAvantMEP.insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        List<Dictionnaire_Prestations__c> dicos = TestsAvantMEP.insertDicos();
        
        ID nullDP = TestsAvantMEP.insertDpNull(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id;//0127a000001UsahAAC
        Prestation__c presta = new Prestation__c();
        presta.Libell__c = '2410 - Désinfection nettoyage des colonnes vide-ordures';
        presta.Prix_Unitaire_HT__c = 110;
        presta.Devis_Pistes__c = dpID;
		presta.P_le__c = 'Hygiène';
        presta.Nombre_de_passages_annuels__c = 1;
        presta.Dictionnaire_Prestations__c = dicos[1].Id;
        insert presta;
        Test.startTest();
        
        ApexPages.StandardController prestaControll = new ApexPages.StandardController(presta);
        prestationExtension pe = new prestationExtension(prestaControll);

        pe.getMissingInfos();
        pe.getCompletePrestaName();
        pe.getLotsAsString();
        pe.getDeplacementPrice();
        pe.getLotsPrice();
        pe.getCoefAsString();
        Test.stopTest();
    }
    
     
    
}