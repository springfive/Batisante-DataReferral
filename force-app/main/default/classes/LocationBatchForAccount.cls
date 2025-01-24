global class LocationBatchForAccount implements Database.Batchable<SObject>, Database.Stateful {
    
    // Stateful variable to store consolidated account data
    private Map<Id, AccountData> accountDataMap = new Map<Id, AccountData>();
    
    // Counters for logging
    private Integer totalProcessedRecords = 0;
    private Integer totalUpdatedAccounts = 0;
    private Integer countSuccessRecords = 0;
    private Integer countErrorRecords = 0;
         
    public class Result {
        
        Id recordid ;
        StatusCode statusCode ;
        String errorMsg ;
        List<String> fieldnames = new List<String>() ;
        
        public Result(Id recordId, StatusCode  stCode, String msg, List<String> nameList) {
            this.recordid = recordId ; 
            this.statusCode = stCode;
            this.errorMsg = msg;
            this.fieldnames = nameList;
        }
        
    }
    


    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        // Query to retrieve Location records modified in the last day
        return Database.getQueryLocator([
            SELECT Id, BS_Nombre_contrats_C_et_O__c, BS_Nb_devis_en_cours__c, Nombre_de_Site_factur__c,
            BS_CA_Sagex__c, BS_CA_ST__c, BS_CA_Christal__c, BS_CA_Diag__c, LocationType, BS_Montant_offres_en_cours__c, 
            BS_Montant_resiliations_3M__c, BS_Nombre_de_contrats_en_C__c, BS_Portfeuille_Contractuel__c, BS_Chiffre_affaires_global__c,
            BS_Client__c
            FROM Location 
            WHERE (LocationType IN ('Site', 'Lieu') AND BS_Client__c != NULL)
            AND (BS_Nombre_contrats_C_et_O__c != NULL OR BS_Nombre_de_contrats_en_C__c != NULL OR BS_Nb_devis_en_cours__c != NULL OR 
                Nombre_de_Site_factur__c != NULL OR BS_CA_Christal__c != NULL OR BS_CA_Diag__c != NULL OR BS_CA_Sagex__c != NULL OR 
                BS_CA_ST__c != NULL OR BS_Chiffre_affaires_global__c != NULL OR BS_Portfeuille_Contractuel__c != NULL OR 
                BS_Montant_offres_en_cours__c != NULL OR BS_Montant_resiliations_3M__c != NULL)
            AND LastModifiedDate = LAST_N_DAYS : 1 
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Schema.Location> scope) {
        // Process each Location record in the batch
        for (Schema.Location l : scope) {
            
            // Get or create AccountData for this location's account
            AccountData accdata = accountDataMap.containsKey(l.BS_Client__c) ? accountDataMap.get(l.BS_Client__c) : new AccountData();
            
            // Update AccountData with this location's information
            accdata.updateFromLocation(l);
            
            // Put updated AccountData back into the map
            accountDataMap.put(l.BS_Client__c, accdata);
            
            totalProcessedRecords++;
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Prepare list of accounts to update
        List<Account> accountsToUpdatelist = new List<Account>();
        
        // Update Account records with consolidated data
        for (Id accountId : accountDataMap.keySet()) {
            
            Account accObj = new Account(Id = accountId);
            if (accObj != null) 
            {
                AccountData accdata = accountDataMap.get(accountId);
                accdata.updateAccount(accObj);
                accountsToUpdatelist.add(accObj);
            }
        }
        
        List<Id> successfulrecords = new List<Id>() ;
        List<LocationBatchForAccount.Result> errorrecords = new List<LocationBatchForAccount.Result>() ;
        
        
        // Update Account records in the database
        if (!accountsToUpdatelist.isEmpty()) {
            Database.SaveResult[] srList = Database.update(accountsToUpdatelist, false) ;
            
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    successfulrecords.add(sr.getId()) ;
                }
                else {
                    //errorrecords.add(sr.getId()) ;
                    for(Database.Error err :sr.getErrors()) {
                        
                        LocationBatchForAccount.Result res = new LocationBatchForAccount.Result(sr.getId(), err.getStatusCode(), err.getMessage(), err.getFields()); 
                        
                        errorrecords.add(res) ;
                    }
                }
            }
            totalUpdatedAccounts = accountsToUpdatelist.size();
            countSuccessRecords = successfulrecords.size() ;
            countErrorRecords = errorrecords.size() ;
        }
        
        // Log final summary of the batch process
        System.debug('LocationBatchForAccount: Batch process completed. ' +
                     'Total processed Location records: ' + totalProcessedRecords + 
                     ', Total updated Accounts: ' + totalUpdatedAccounts);
        
           
        SingleEmailMessage mail = new SingleEmailMessage(successfulrecords, errorrecords, totalProcessedRecords, 
                                                         totalUpdatedAccounts, countSuccessRecords, countErrorRecords) ;
    
    }



    
    // Inner class to hold consolidated data for each account
    private class AccountData 
    {
        Decimal caG = 0; 
        Decimal caH = 0; 
        Decimal caMR = 0; 
        Decimal caDC = 0; 
        Decimal caSi = 0; 
        Decimal mtOffreenCours = 0; 
        Decimal mtResilEnr = 0; 
        Decimal nbContractC = 0; 
        Decimal porteFeuilleContractuel = 0; 
        Decimal nbContractCO = 0;
        Integer countCandO = 0; 
        Integer countSitePonctuels = 0; 
        Integer countSiteFacture = 0; 
        Integer countSiteSagex = 0;
        Integer countSiteMR = 0; 
        Integer countSiteHygiene = 0; 
        Integer countSiteFactureDiag = 0; 
        Integer countSiteGereUniquement = 0;
        Integer countSite = 0;
        
        public void updateFromLocation(Schema.Location l) 
        {
            if (l.LocationType == 'Site' || l.LocationType == 'Lieu') 
                countSite++;
            if (l.BS_Nombre_contrats_C_et_O__c > 0) 
                countCandO++;
            if (l.BS_Nb_devis_en_cours__c >= 1) 
                countSitePonctuels++;
            if (l.Nombre_de_Site_factur__c == 1) 
                countSiteFacture++;
            if (l.BS_CA_Sagex__c > 0) 
                countSiteSagex++;
            if (l.BS_CA_ST__c > 0) 
                countSiteMR++;
            if (l.BS_CA_Christal__c > 0) 
                countSiteHygiene++;
            if (l.BS_CA_Diag__c > 0) 
                countSiteFactureDiag++;
            if (l.LocationType == 'Site') 
                countSiteGereUniquement++;

            caG                     += l.BS_Chiffre_affaires_global__c != null ? l.BS_Chiffre_affaires_global__c : 0;
            caH                     += l.BS_CA_Christal__c != null ? l.BS_CA_Christal__c : 0;
            caMR                    += l.BS_CA_ST__c != null ? l.BS_CA_ST__c : 0;
            caDC                    += l.BS_CA_Diag__c != null ? l.BS_CA_Diag__c : 0;
            caSi                    += l.BS_CA_Sagex__c != null ? l.BS_CA_Sagex__c : 0;
            mtOffreenCours          += l.BS_Montant_offres_en_cours__c != null ? l.BS_Montant_offres_en_cours__c : 0;
            mtResilEnr              += l.BS_Montant_resiliations_3M__c != null ? l.BS_Montant_resiliations_3M__c : 0;
            nbContractC             += l.BS_Nombre_de_contrats_en_C__c != null ? l.BS_Nombre_de_contrats_en_C__c : 0;
            porteFeuilleContractuel += l.BS_Portfeuille_Contractuel__c != null ? l.BS_Portfeuille_Contractuel__c : 0;
            nbContractCO            += l.BS_Nombre_contrats_C_et_O__c != null ? l.BS_Nombre_contrats_C_et_O__c : 0;
        }
        
        public void updateAccount(Account accObj) 
        {
            accObj.BS_CA_Diagnotics_controles1__c = caDC;
            accObj.BS_Chiffre_affaires_Christal1__c = caH;
            accObj.BS_Chiffre_affaires_Sagex1__c = caSi;
            accObj.BS_Chiffre_affaires_Solutions_technique1__c = caMR;
            accObj.BS_Chiffre_affaires_global1__c = caG;
            accObj.BS_Montant_des_resiliations1__c = mtResilEnr;
            accObj.BS_Montant_offres_en_cours1__c = mtOffreenCours;
            accObj.BS_Portefeuille_Contractuel1__c = porteFeuilleContractuel;
            accObj.BS_Nb_sites_geres1__c = countSite;
            accObj.BS_Nombre_contrats_C_O__c = nbContractCO;
            accObj.BS_Nombre_contrats_en_C1__c = nbContractC;
            accObj.BS_Nombre_sites_en_ponctuel1__c = countSitePonctuels;
            accObj.NB_sites_factur_s_Diag1__c = countSiteFactureDiag;
            accObj.Nb_de_sites_factur_s1__c = countSiteFacture;
            accObj.Nb_de_sites_factur_s_Hygi_ne1__c = countSiteHygiene;
            accObj.Nb_de_sites_factur_s_MR1__c = countSiteMR;
            accObj.Nb_de_sites_factur_s_Sagex1__c = countSiteSagex;
            accObj.Nombre_de_Sites_g_r_s_uniquement1__c = countSiteGereUniquement;
        }
    }
}