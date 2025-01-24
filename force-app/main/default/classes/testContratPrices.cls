@isTest
public class testContratPrices {
    static BS_Devis_from_Lead__c insertProp() {
        BS_Devis_from_Lead__c dp = new BS_Devis_from_Lead__c();
        dp.Email_Prospect__c = 'test@test.com';
        dp.Contact_Soci_t__c = 'test';
        dp.Adresse_Site__c = '666 av Test';
        dp.Devis_g_n_r__c = false;
        dp.Name = 'Eloïse GUERIN - Devis Lead - n°201';
        dp.Etat2__c = 'Transmis';
        dp.Statut__c = 'Devis';
        dp.Contact_Soci_t__c = 'contact TEST';
        dp.RecordTypeId = Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId();
        insert dp;
        return dp;
    }
    
    static Dictionnaire_Prestations__c insertDict(String name) {
        Dictionnaire_Prestations__c dictionnaire = new Dictionnaire_Prestations__c();
        dictionnaire.Name = name;
        insert dictionnaire;
        return dictionnaire;
    }
    
    static Prestation__c insertPrestationContrat(Dictionnaire_Prestations__c dict) {
        Prestation__c presta = new Prestation__c();
        presta.Coefficient__c = 1;
        presta.Name = 'Prestation - Contrat - Test';
        presta.Dictionnaire_Prestations__c = dict.id;
        presta.Libell__c = dict.Name;
        if (dict.Name.contains('2923'))
        	presta.Nombre_de_passages_annuels__c = 2;
        else
            presta.Nombre_de_passages_annuels__c = 1;
        presta.P_le__c = 'Hygiène';
        presta.Devis_Pistes__c = insertProp().Id;
        presta.RecordTypeId = Schema.SObjectType.Prestation__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId();
        presta.Prix_Unitaire_HT__c = 0;
        insert presta;
        return presta;
    }
    
    static List<Parametre_de_lot__c> insertParamLot2105(Dictionnaire_Prestations__c dict) {
        Parametre_de_lot__c lotCage = new Parametre_de_lot__c();
        lotCage.Dictionnaire_Prestations__c = dict.id;
        lotCage.Equivalent_en_lots__c = 1;
        lotCage.Name = 'Cage';
        lotCage.Niveau_contrat__c = False;
        insert lotCage;
        
        Parametre_de_lot__c lotParking = new Parametre_de_lot__c();
        lotParking.Dictionnaire_Prestations__c = dict.id;
        lotParking.Equivalent_en_lots__c = 1;
        lotParking.Name = 'Boîtier supplémentaire niveau parking';
        lotParking.Niveau_contrat__c = False;
        insert lotParking;
        
        Parametre_de_lot__c lotEtage = new Parametre_de_lot__c();
        lotEtage.Dictionnaire_Prestations__c = dict.id;
        lotEtage.Equivalent_en_lots__c = 1;
        lotEtage.Name = 'Boîtier supplémentaire étage supérieur';
        lotEtage.Niveau_contrat__c = False;
        insert lotEtage;
        
        List<Parametre_de_lot__c> params = new List<Parametre_de_lot__c> {lotCage, lotParking, lotEtage};
        return params;
    }
    
    static List<Parametre_de_lot__c> insertParamLot2322(Dictionnaire_Prestations__c dict) {
        Parametre_de_lot__c lotChambre = new Parametre_de_lot__c();
        lotChambre.Dictionnaire_Prestations__c = dict.id;
        lotChambre.Equivalent_en_lots__c = 1;
        lotChambre.Name = 'Chambre';
        lotChambre.Niveau_contrat__c = True;
        insert lotChambre;
        
        Parametre_de_lot__c local = new Parametre_de_lot__c();
        local.Dictionnaire_Prestations__c = dict.id;
        local.Equivalent_en_lots__c = 1;
        local.Name = 'Local Commercial';
        local.Niveau_contrat__c = True;
        insert local;
        
        List<Parametre_de_lot__c> params = new List<Parametre_de_lot__c> {local, lotChambre};
        return params;
    }

    static List<Parametre_de_lot__c> insertParamLot2923(Dictionnaire_Prestations__c dict) {
        Parametre_de_lot__c pelle = new Parametre_de_lot__c();
        pelle.Dictionnaire_Prestations__c = dict.id;
        pelle.Equivalent_en_lots__c = 1;
        pelle.Name = 'Pelle';
        pelle.Niveau_contrat__c = False;
        insert pelle;
        
        Parametre_de_lot__c colonne = new Parametre_de_lot__c();
        colonne.Dictionnaire_Prestations__c = dict.id;
        colonne.Equivalent_en_lots__c = 5;
        colonne.Name = 'Colonne';
        colonne.Niveau_contrat__c = False;
        insert colonne;
        
        Parametre_de_lot__c niveau = new Parametre_de_lot__c();
        niveau.Dictionnaire_Prestations__c = dict.id;
        niveau.Equivalent_en_lots__c = 5;
        niveau.Name = 'Niveau';
        niveau.Niveau_contrat__c = False;
        insert niveau;
        
        List<Parametre_de_lot__c> params = new List<Parametre_de_lot__c> {pelle, colonne, niveau};
        return params;
    }
    
    static void insertPalier(List<Parametre_de_lot__c> params) {
        for (Parametre_de_lot__c param : params) {
            Palier__c palier = new Palier__c();
            palier.Parametre_de_lot__c = param.id;
            palier.Minimum__c = 0;
            palier.Maximum__c = 5000;
            palier.Prix_forfait__c = 117;
            palier.Prix_par_lot__c = 120;
            insert palier;
        }
    }
    
    @isTest
    static void lotPriceUpdateLotLevel() {
        String name = '2105 - Prévention - Surveillance rongeurs avec poste(s) d\'appâtage connecté(s)';
        Dictionnaire_Prestations__c dict = insertDict(name);
        Prestation__c presta = insertPrestationContrat(dict);
        List<Parametre_de_lot__c> params = insertParamLot2105(dict);
        insertPalier(params);
        for (Parametre_de_lot__c param : params) {
            Lot__c lot = new Lot__c();
            lot.Parametre_de_lot__c = param.id;
            lot.Prestation__c = presta.Id;
            lot.Quantite__c = 7;
            insert lot;
        }
    }
    
    @isTest
    static void lotPriceUpdateContratLevel() {
        String name = '2322 - Désinsectisation parties communes et parties privatives';
        Dictionnaire_Prestations__c dict = insertDict(name);
        Prestation__c presta = insertPrestationContrat(dict);
        List<Parametre_de_lot__c> params = insertParamLot2322(dict);
        insertPalier(params);
        for (Parametre_de_lot__c param : params) {
            Lot__c lot = new Lot__c();
            lot.Parametre_de_lot__c = param.id;
            lot.Prestation__c = presta.Id;
            lot.Quantite__c = 7;
            insert lot;
        }
    }
    
    @isTest
    static void lotPriceUpdateContrat2923() {
        String name = '2923 - Désinfection - Nettoyage des colonnes vide-ordures et des pelles palières';
        Dictionnaire_Prestations__c dict = insertDict(name);
        Prestation__c presta = insertPrestationContrat(dict);
        List<Parametre_de_lot__c> params = insertParamLot2923(dict);
        insertPalier(params);
        for (Parametre_de_lot__c param : params) {
            Lot__c lot = new Lot__c();
            lot.Parametre_de_lot__c = param.id;
            lot.Prestation__c = presta.Id;
            lot.Quantite__c = 7;
            insert lot;
        }
    }
    
    @isTest
    static void addDictionnairePrestation() {
        String firstName = '2322 - Désinsectisation parties communes et parties privatives';
        String secondName = '2105 - Prévention - Surveillance rongeurs avec poste(s) d\'appâtage connecté(s)';
        String thirdName = '2923 - Désinfection - Nettoyage des colonnes vide-ordures et des pelles palières';
        insertDict(firstName);
        insertDict(secondName);
        insertDict(thirdName);
    }
}