@isTest

private class ScheduleLocationBatchForAccountTest {
    @testsetup
    static void setup() {
        
        //Account Record
        Account accountrecord = new Account(Name = 'Acc_1', BS_Id_ClientAzur__c = '1', BS_CA_Diagnotics_controles1__c = 0, BS_Chiffre_affaires_Christal1__c = 0,
                                 BS_Chiffre_affaires_Sagex1__c = 0, BS_Chiffre_affaires_Solutions_technique1__c = 0,
                                 BS_Chiffre_affaires_global1__c = 0, BS_Montant_des_resiliations1__c = 0, BS_Montant_offres_en_cours1__c = 0,
                                 BS_Nb_sites_geres1__c = 0, BS_Nombre_contrats_C_O__c = 0, BS_Nombre_contrats_en_C1__c = 0,
                                 BS_Nombre_sites_en_ponctuel1__c = 0, BS_Portefeuille_Contractuel1__c = 0, NB_sites_factur_s_Diag1__c = 0,
                                 Nb_de_sites_factur_s1__c = 0, Nb_de_sites_factur_s_Hygi_ne1__c = 0, Nb_de_sites_factur_s_MR1__c = 0,
                                 Nb_de_sites_factur_s_Sagex1__c = 0, Nombre_de_Sites_g_r_s_uniquement1__c = 0 ) ;
        
        //Insert the record
        Insert accountrecord ;
         
        //Location Records
        List<Schema.Location> LocationRecordsList = new List<Schema.Location>() ;
        LocationRecordsList.add(new Schema.Location(Name = 'Loc_1', LocationType = 'Site', BS_Client__c = accountrecord.Id,
                        BS_Nombre_de_contrats_en_O__c = 1, BS_Nombre_de_contrats_en_C__c = 2, 
                        BS_CA_Christal__c = 3, BS_CA_Diag__c = 4, BS_CA_Sagex__c = 5, BS_CA_ST__c = 6, 
                        BS_Portfeuille_Contractuel__c = 7, BS_Montant_offres_en_cours__c = 8, 
                        BS_Montant_resiliations_3M__c = 9)) ;
        
        LocationRecordsList.add(new Schema.Location(Name = 'Loc_2', LocationType = 'Lieu', BS_Client__c = accountrecord.Id, 
                        BS_Nombre_de_contrats_en_O__c = 9, BS_Nombre_de_contrats_en_C__c = 8, 
                        BS_CA_Christal__c = 7, BS_CA_Diag__c = 6, BS_CA_Sagex__c = 5, BS_CA_ST__c = 4, 
                        BS_Portfeuille_Contractuel__c = 3, BS_Montant_offres_en_cours__c = 2, 
                        BS_Montant_resiliations_3M__c = 1)) ;
        
        //Insert the records
        Insert LocationRecordsList ;
        
        
    }
    
    @isTest static void schedulertest() {
        Test.startTest() ;
        SchedulableContext SC = null;
        ScheduleLocationBatchForAccount batch = new ScheduleLocationBatchForAccount() ;
		batch.execute(SC) ;

        Test.stopTest() ;
        
    }

}