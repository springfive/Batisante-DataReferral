global class CaClientsHistory implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID,Name, BS_Chiffre_affaires_global__c, BS_CA_Diagnotics_controles__c, BS_Chiffre_affaires_Christal__c, ' +
            'BS_Chiffre_affaires_Solutions_techniques__c,BS_Chiffre_affaires_Sagex__c, OwnerId, RecordType.name, '+ 
            'BS_Activite_ADB__c, BS_Activite__c, BS_Client_reserve__c, BS_Client_a_risque_SF__c, BS_Code_client__c,'+
            'BS_Gestionnaire_de_clientele__c, BS_Groupe__c, BS_Montant_des_avoirs__c, BS_Montant_des_devis_en_cours__c,'+
            'BS_Montant_des_durites_en_cours__c, BS_Montant_des_impayes__c, BS_Montant_offres_en_cours__c,'+
            'BS_Montant_des_resiliations__c, BS_Motif_CAR__c, BS_Nb_de_salaries__c, BS_Nombre_sites_en_ponctuel__c,'+
            'BS_Nb_sites_geres__c, BS_Nb_gardiens_employes_immeuble__c, BS_N_SIRET__c, BS_PDS__c, '+
            'BS_Portefeuille_Contractuel__c, BS_Region__c, BS_Segment__c,BS_Taux_de_transformation_contrat__c,'+
            'BS_Taux_transformation_devis__c, Type, BS_Vendeur_Solution_technique__c, BS_Vendeur_PE__c '+
            'FROM Account'
        ); 
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
        List<BS_CA_client_History__c> clientsHistory = new List<BS_CA_client_History__c>();
        for (Account account : scope) {
            BS_CA_client_History__c clientHistory= new BS_CA_client_History__c();
            clientHistory.BS_Annee__c=System.Today().year()-1;
            clientHistory.BS_Nom_client__c = account.id;
            clientHistory.BS_CA_Global__c = account.BS_Chiffre_affaires_global__c;
            clientHistory.BS_CA_Diagnotics_controles__c = account.BS_CA_Diagnotics_controles__c;
            clientHistory.BS_CA_Hygiene__c = account.BS_Chiffre_affaires_Christal__c;
            clientHistory.BS_CA_Maintenance_reseaux__c = account.BS_Chiffre_affaires_Solutions_techniques__c;
            clientHistory.BS_CA_Securite_incendie__c = account.BS_Chiffre_affaires_Sagex__c;
            clientHistory.BS_Vendeur_MP__c = account.OwnerId;
            clientHistory.BS_Type_client__c= account.RecordType.name;
            clientHistory.BS_Activite_ADB__c = account.BS_Activite_ADB__c;
            clientHistory.BS_Activite_CFE__c = account.BS_Activite__c;
            clientHistory.BS_Client_reserve__c = account.BS_Client_reserve__c;
            clientHistory.BS_Client_risque__c = account.BS_Client_a_risque_SF__c;
            clientHistory.BS_Code_client__c = account.BS_Code_client__c;
            clientHistory.BS_Gestionnaire_de_clientele__c = account.BS_Gestionnaire_de_clientele__c;
            clientHistory.BS_Groupe__c = account.BS_Groupe__c;
            clientHistory.BS_Montant_des_avoirs__c = account.BS_Montant_des_avoirs__c;
            clientHistory.BS_Montant_des_devis_en_cours__c = account.BS_Montant_des_devis_en_cours__c;
            clientHistory.BS_Montant_des_durites_en_cours__c = account.BS_Montant_des_durites_en_cours__c;
            clientHistory.BS_Montant_des_impayes__c = account.BS_Montant_des_impayes__c;
            clientHistory.BS_Montant_des_offres_en_cours__c = account.BS_Montant_offres_en_cours__c;
            clientHistory.BS_Montant_des_resiliations__c = account.BS_Montant_des_resiliations__c;
            clientHistory.BS_Motif_CAR__c = account.BS_Motif_CAR__c;
            clientHistory.BS_Nb_de_salaries__c = account.BS_Nb_de_salaries__c;
            clientHistory.BS_Nombre_de_sites_en_ponctuel__c = account.BS_Nombre_sites_en_ponctuel__c;
            clientHistory.BS_Nombre_de_sites_geres__c = account.BS_Nb_sites_geres__c;
            clientHistory.BS_Nombre_gardiens_employes_immeuble__c = account.BS_Nb_gardiens_employes_immeuble__c;
            clientHistory.BS_N_Siret__c = account.BS_N_SIRET__c;
            clientHistory.BS_PDS__c = account.BS_PDS__c;
            clientHistory.BS_Portefeuille_Contractuel__c = account.BS_Portefeuille_Contractuel__c;
            clientHistory.BS_Region__c = account.BS_Region__c;
            clientHistory.BS_Segment__c = account.BS_Segment__c;
            clientHistory.BS_Taux_de_transformation_contrat__c = account.BS_Taux_de_transformation_contrat__c;
            clientHistory.BS_Taux_de_transformation_devis__c = account.BS_Taux_transformation_devis__c;
            clientHistory.Type__c = account.Type;
            clientHistory.BS_Vendeur_MR__c = account.BS_Vendeur_Solution_technique__c;
            clientHistory.BS_Vendeur_PE__c = account.BS_Vendeur_PE__c;
            // add clientHistory to list to be inserted
            clientsHistory.add(clientHistory);
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
        }
        system.debug('records Processed: '+recordsProcessed);
        insert clientsHistory;
    }    
    global void finish(Database.BatchableContext bc){
        
    }    
}