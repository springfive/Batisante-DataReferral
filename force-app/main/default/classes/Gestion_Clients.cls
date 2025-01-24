/**
* @author Amine SARBOUTE
* @date 01/06/2020
* @description Gestion_Clients :Gestion du flux Clients AZUR=>SFDC
*/
global with sharing class Gestion_Clients {
    
    // Gestion transco Activite dans azur => activité et segment dans SFDC
    public static Structure_Client.MessageRetour CheckAccountExistWithExternalID(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour= new Structure_Client.MessageRetour();
        Structure_Client.MessageRetour messageRetourindiv= new Structure_Client.MessageRetour();
        integer nbErr=0;
        messageRetour.message ='Erreur(s): ';
        boolean isValidPhone;
        //Gestion_Clients.MessageRetour mr = new Gestion_Clients.MessageRetour();
        List<Account> compteForUpsert=new List<Account>();
        /* AccountTeamMember acctmemGest = new AccountTeamMember();
AccountTeamMember acctmemCoPE = new AccountTeamMember();*/
        
        
        List<Account> comptes=Structure_Client.getClientByIdClientAzur(cpte);
        
        //A supp
        //Récupérer le client s'il existe dans SFDC
        
        
        //Récupérer le vendeur multipôle et son gestionnaire de clientèle à partir du Trigramme pour alimenter le champ Owner du client
        List<user> VendeursMP=Structure_Client.getVendeurMPByTrigramme(cpte.VendeurMP);
        
        //Récupérer le vendeur Produit d'entretien
        List<user> VendeursPE=Structure_Client.getVendeurPEByTrigramme(cpte);
        
        //Récupérer le vendeur Solutions techniques
        List<user> VendeursST=Structure_Client.getVendeurSTByTrigramme(cpte);
        
        //Récupérer le gestionnaire du vendeur Solutions techniques
        List<user> VendeursSTGestionnaire=Structure_Client.getVendeurSTGestinnaireByTrigramme(cpte);
      
        
        //Récupérer les valeurs Activité et segment transcodées dans la métadonné "ActivitesSegments__mdt"
        List<ActivitesSegments__mdt> mdtActivSeg=Structure_Client.transcoFromActiviteAzur(cpte);
        
        //Préparation équipe du compte (pour le Vendeur MR)
        AccountTeamMember acctmemMR = new AccountTeamMember();
        /********************************************************************************************************************
* DEBUT MAJ
*********************************************************************************************************************/
       system.debug('Nombre de client');
        system.debug(comptes.size());
        if (comptes.size()>0 && Cpte.IdClientAzur!=null && Cpte.IdClientAzur!='' ){
            //Vendeur Multi-Pôles + gestionnaire clientèle associé
            if(Cpte.VendeurMP!=null && cpte.VendeurMP!='' && VendeursMP.size()>0){				
                comptes[0].BS_Code_Vendeur__c =cpte.VendeurMP;
                comptes[0].OwnerId =VendeursMP[0].id; 
                comptes[0].BS_Gestionnaire_de_clientele__c =VendeursMP[0].BS_Gestionnaire_de_clientele__c;                    
            }else{
                //Msg d'erreur: Code vendeur non reconnu ou vide
                comptes[0].BS_Code_Vendeur__c =cpte.VendeurMP;
                comptes[0].OwnerId =System.Label.BS_Automate_ID; 
                comptes[0].BS_Gestionnaire_de_clientele__c =System.Label.BS_Automate_ID;	                   
            }
            
            //Vendeur Solutions technique
            if(Cpte.VendeurSolutionTech!=null && cpte.VendeurSolutionTech!='' && VendeursST.size()>0){
                //Evol ASA : 13/11/20 => partage du client avec le vendeur MR
                //Evol LMS : 18/01 => Transfert de la logique en flow
                //Si le vendeur MR change dans Azur on met à jour l'équipe du client
                /*
                List<AccountTeamMember> actm=[SELECT id, AccountId, TeamMemberRole, UserId 
												  FROM AccountTeamMember 
												  WHERE AccountId= :comptes[0].id AND TeamMemberRole='Commercial MR'];
                
                if(actm.size()<=0 && VendeursST.size()>0){
                    acctmemMR.AccountId=comptes[0].id;
                    acctmemMR.TeamMemberRole='Commercial MR';
                    acctmemMR.UserId=VendeursST[0].id;
                    acctmemMR.OpportunityAccessLevel='Edit';
                    acctmemMR.AccountAccessLevel='Edit';
                    insert acctmemMR;
                }else if(actm.size()>0 && actm[0].userId !=VendeursST[0].id ){
                    //Supprimer l'ancien commercial MR
                    delete actm;
                	//Ajouter le nouveau MR
                    acctmemMR.AccountId=comptes[0].id;
                    acctmemMR.TeamMemberRole='Commercial MR';
                    acctmemMR.UserId=VendeursST[0].id;
                    acctmemMR.OpportunityAccessLevel='Edit';
                    acctmemMR.AccountAccessLevel='Edit';
                    insert acctmemMR;
                }
*/
                comptes[0].BS_Vendeur_Solution_technique__c =VendeursST[0].id;
            }else{
                //attribué à Automate
                comptes[0].BS_Vendeur_Solution_technique__c =System.Label.BS_Automate_ID; 
            }
            
            //Gestionnaire clientele du vendeur indispensable
                       
       // system.debug('voila'+VendeursSTGestionnaire[0].BS_Gestionnaire_de_clientele__c);
            if(Cpte.VendeurSolutionTech!=null && cpte.VendeurSolutionTech!='' && VendeursSTGestionnaire.size()!=0){				
                
                comptes[0].Gestionnaire_de_client_le_Indisp__c =VendeursSTGestionnaire[0].BS_Gestionnaire_de_clientele__c;                    
            }else{
                system.debug('ligne faite');
              
                comptes[0].Gestionnaire_de_client_le_Indisp__c =System.Label.BS_Automate_ID;	                   
            }
 
            
            //Vendeur PE
            if(Cpte.VendeurPE!=null && cpte.VendeurPE!='' && VendeursPE.size()>0){ 
                comptes[0].BS_Vendeur_PE__c =VendeursPE[0].id;
            }else{
                comptes[0].BS_Vendeur_PE__c =System.Label.BS_ManagerCoPE;
            }
            
            if(cpte.codeClient!=null && cpte.codeClient!=''){
                comptes[0].BS_Code_client__c=cpte.codeClient;
            } 
            if(cpte.TypeClient!=null && cpte.TypeClient!=''){
                //Si le client est de type ADB, récupération de la valeur telle quelle
                if(cpte.TypeClient=='ADB'){
                    comptes[0].RecordTypeId=System.Label.BS_nom_recordtype_ADB;
                    if(cpte.ActiviteADB!=null && cpte.ActiviteADB!=''){ 
                        comptes[0].BS_Activite_ADB__c =cpte.ActiviteADB;                       
                    }
                }
                
                //Si le client est de type CFE ou CFImmo, transcodage de la valeur activité et calcul segment associé
                else if(cpte.TypeClient=='CFE' || cpte.TypeClient=='CFE IMMO'){
                    comptes[0].RecordTypeId=System.Label.BS_nom_recordtype_CFE;
                    if(cpte.ActiviteCFE!=null && cpte.ActiviteCFE!=''){ 
                        
                        if(mdtActivSeg.size()>0){
                            comptes[0].BS_Activite__c =mdtActivSeg[0].Activite_SFDC__c;
                            if(mdtActivSeg[0].Segment_SFDC__c!=null && mdtActivSeg[0].Segment_SFDC__c!='') comptes[0].BS_Segment__c=mdtActivSeg[0].Segment_SFDC__c;
                        }Else{
                            //Si l'activité reçu d'azur ne correspond à rien dans sfdc(pas de correspondance dans les métadata,
                            // on fait quoi?
                        }
                    } 
                }else{
                    nbErr++;
                    messageRetourindiv=Structure_Client.typeClientInvalide(cpte);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }
            }else{
                nbErr++;
                messageRetourindiv=Structure_Client.typeClientManquant(cpte);
                messageRetour.message+=nbErr+') '+messageRetourindiv.message;
            } 
            
            if(cpte.nomClient!=null && cpte.nomClient!=''){
                comptes[0].name=cpte.nomClient;
            }else{
                nbErr++;
                messageRetourindiv=Structure_Client.nomClientmanquant(cpte);
                messageRetour.message+=nbErr+') '+messageRetourindiv.message;
            }
            
            if(cpte.ClientReserve!=null && cpte.ClientReserve!='' && cpte.TypeClient=='ADB') { 
                if(cpte.ClientReserve=='F'){
                    comptes[0].BS_Client_reserve__c='FNAIM';
                }else if(cpte.ClientReserve=='U'){
                    comptes[0].BS_Client_reserve__c='UNIS';
                }else{
                    nbErr++;
                    messageRetourindiv=Structure_Client.codeClientReserveInvalide(cpte);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }
            }
            
            if(cpte.Mobile!=null /*&& cpte.Mobile!='' && Pattern.matches('[0-9]{10}', cpte.Mobile)*/){
                comptes[0].Phone =cpte.Mobile;
            }  			
            if(cpte.Telephone!=null /* && cpte.Telephone!='' && Pattern.matches('[0-9]{10}', cpte.Mobile)*/){
                comptes[0].BS_Telephone_2__c =cpte.Telephone;
            }     
            if(cpte.Fax!=null)            comptes[0].BS_Fax__c =cpte.Fax;
            if(cpte.AdresseMail	!=null /* && cpte.AdresseMail!='' && Pattern.matches('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})', cpte.AdresseMail)*/){
                comptes[0].BS_Adresse_mail__c =cpte.AdresseMail	;
            }
            if(cpte.Groupe!=null)           			comptes[0].BS_Groupe__c =cpte.Groupe;
            if(cpte.PDS!=null)                          comptes[0].BS_PDS__c =cpte.PDS;
            if(cpte.NSiret!=null)   					comptes[0].BS_N_SIRET__c= cpte.NSiret;
            if(cpte.ClientARisque!=null) {
                comptes[0].BS_Client_a_risque__c= Boolean.valueOf(cpte.ClientARisque);
            }else{
                comptes[0].BS_Client_a_risque__c= false;
            }
            // transco valeurs Azur<=>SFDC ====> 0:IDF  1:Nord  2:Sud
            if(cpte.Region!=null && cpte.Region!='') { 
                if(cpte.Region=='0'){
                    comptes[0].BS_Region__c='IDF';
                }else if(cpte.Region=='1'){
                    comptes[0].BS_Region__c='Nord';
                }else if(cpte.Region=='2'){
                    comptes[0].BS_Region__c='Sud';
                }else if(cpte.Region=='3'){
                    comptes[0].BS_Region__c='Ouest';
                }else{
                    nbErr++;
                    messageRetourindiv=Structure_Client.codeRegionInvalide(cpte);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }
            }
            if(cpte.idAdresse!=null){
                comptes[0].BS_ID_Adresse__c =cpte.idAdresse;
            }
            //Rue d'expédition (postal)
            if(cpte.Adr1AP!=null){
                comptes[0].ShippingStreet =cpte.Adr1AP;
            }
            //Le complément concaténé avec Rue de d'expédtion
            if(cpte.Adr2AP!=null){
                comptes[0].ShippingStreet+='\n'+cpte.Adr2AP;
            }
            //Rue de facturation 
            if(cpte.Adr1AF!=null){
                comptes[0].BillingStreet =cpte.Adr1AF;
            }
            //Le complément concaténé avec Rue de facturation
            if(cpte.Adr2AF!=null){
                comptes[0].BillingStreet+='\n'+cpte.Adr2AF;
            }  
            if(cpte.CodePostalAP!=null){
                comptes[0].ShippingPostalCode=cpte.CodePostalAP;
            }
            if(cpte.CodePostalAF!=null){
                comptes[0].BillingPostalCode=cpte.CodePostalAF;
            }
            if(cpte.VilleAP!=null){
                comptes[0].ShippingCity=cpte.VilleAP;
            }
            if(cpte.VilleAF!=null){
                comptes[0].BillingCity=cpte.VilleAF;
            }
             // LMS Ajout vendeur ind
            if(cpte.VendeurSolutionTech!=null){
                comptes[0].BS_Code_Vendeur_ind__c=cpte.VendeurSolutionTech;
            }
            
            if(cpte.CreeLeAzur!=null && cpte.CreeLeAzur!=''){
                comptes[0].BS_Cree_le_Azur__c=date.ValueOf(cpte.CreeLeAzur);
            }else if(cpte.CreeLeAzur!=null && cpte.CreeLeAzur==''){
                comptes[0].BS_Cree_le_Azur__c=null;
            }
            
            if(cpte.ModifieLeAzur!=null && cpte.ModifieLeAzur!=''){
                comptes[0].BS_Modifie_le_Azur__c=date.ValueOf(cpte.ModifieLeAzur);
            }else if(cpte.ModifieLeAzur!=null && cpte.ModifieLeAzur==''){
                comptes[0].BS_Modifie_le_Azur__c=null;
            }
            
            if(cpte.DateconvPEsignee!=null && cpte.DateconvPEsignee!=''){
                
                //création tâche relance si date conv renseigné et supérieur à J-15
                if(Date.ValueOf(cpte.DateconvPEsignee)>system.today().addDays(-15) && Date.ValueOf(cpte.DateconvPEsignee)!= comptes[0].BS_Date_convention_PE_signee__c ){
                    system.debug('$$$$$$$$$ 1)dateConv : '+Date.ValueOf(cpte.DateconvPEsignee)+' 2)Date j-15 :'+ system.today().addDays(-15));
                    task relanceGardien= new task();
                    relanceGardien.Priority='Normale';
                    relanceGardien.recordtypeid=[Select Id,SobjectType,Name From RecordType where Name ='Relance Gardiens' and SobjectType ='Task'  limit 1].Id;
                    relanceGardien.Subject='Relance Gardiens';
                    relanceGardien.WhatId=comptes[0].id;
                    relanceGardien.status='Ouvert';
                    relanceGardien.ActivityDate=Date.ValueOf(cpte.DateconvPEsignee).addMonths(1);
                    //Nom et prénom du contact
                    id contactClientRtId=[Select Id,SobjectType,Name From RecordType where Name ='Contact Client' and SobjectType ='Contact'  limit 1].Id;
                    List<contact> contactsPrincipaux=[select id, BS_Principal__c, title, recordtypeId from contact where accountid= :comptes[0].id and BS_Principal__c=true and recordtypeId= :contactClientRtId ];
                    if(contactsPrincipaux.size()==1){
                        relanceGardien.WhoId= contactsPrincipaux[0].id;
                    }else if(contactsPrincipaux.size()>1){
                        List<contact> contactsGestionnaires=[select id, BS_Principal__c, title, recordtypeId from contact where accountid= :comptes[0].id and BS_Principal__c=true and title='Gestionnaire' and recordtypeId= :contactClientRtId];
                        if(contactsGestionnaires.size()>0){
                            relanceGardien.WhoId= contactsGestionnaires[0].id;
                        }else{
                            relanceGardien.WhoId= contactsPrincipaux[0].id;
                        }
                    }
                    //Fin contact
                    /* 
//Date de convention + 1 mois (jours ouvrés)
date dateconv=Date.ValueOf(cpte.DateconvPEsignee);
DateTime dt = DateTime.newInstance(dateconv.year(),dateconv.month(),dateconv.day(),0,0,0);

if(dt.addMonths(1).format('EEE')=='Sat'){
system.debug('$$$$$$$$$ valeur en attente:Samedi <===> valeur reçu +1 mois: '+dt.addMonths(1)+' '+ dt.addMonths(1).format('EEE'));
relanceGardien.ActivityDate=Date.ValueOf(dt.addMonths(1).adddays(3));
system.debug('Résultats traitement jour ouvré: '+Date.ValueOf(dt.addMonths(1).adddays(3)));
system.debug('$$$$$$$$$ valeur stockée'+ Date.ValueOf(dt.addMonths(1).adddays(2)));
}else if(dt.addMonths(1).format('EEE')=='Sun'){
system.debug('$$$$$$$$$ valeur en attente:Dimanche <===> valeur reçu: '+ dt.addMonths(1).format('EEE'));
relanceGardien.ActivityDate=Date.ValueOf(dt.addMonths(1).adddays(2));
system.debug('$$$$$$$$$ valeur calculé(sans traitement)'+ dt.addMonths(2)+ 'date du jour: '+ datetime.NOW().format('EEE'));
system.debug('Résultats traitement jour ouvré: '+Date.ValueOf(dt.addMonths(1).adddays(1)));

}else{
relanceGardien.ActivityDate=Date.ValueOf(dt).addMonths(1);
system.debug('Jour ouvré'+dt.addMonths(1).format('EEE')+' '+dt.addMonths(1));
}
//Fin date conv
*/
                    if(Cpte.VendeurPE!=null && cpte.VendeurPE!='' && VendeursPE.size()>0){ 
                        system.debug('ID vendeur PE '+ VendeursPE[0].id);
                        relanceGardien.ownerid =VendeursPE[0].id;
                        
                    }else{
                        relanceGardien.ownerid =System.Label.BS_ManagerCoPE;
                    }
                    insert relanceGardien;
                }
                comptes[0].BS_Date_convention_PE_signee__c=Date.ValueOf(cpte.DateconvPEsignee);
            }else if(cpte.DateconvPEsignee!=null && cpte.DateconvPEsignee==''){
                comptes[0].BS_Date_convention_PE_signee__c=null;
            }
            
            if(cpte.DateResiliationConvPE!=null && cpte.DateResiliationConvPE!=''){
                comptes[0].BS_Date_resiliation_convention_PE__c=Date.ValueOf(cpte.DateResiliationConvPE);
            }else if(cpte.DateResiliationConvPE!=null && cpte.DateResiliationConvPE==''){
                comptes[0].BS_Date_resiliation_convention_PE__c=null;
            }
            
            if(cpte.DateConvASSsignee!=null && cpte.DateConvASSsignee!=''){
                comptes[0].BS_Date_convention_ASS_signee__c=Date.ValueOf(cpte.DateConvASSsignee);
            }else if(cpte.DateConvASSsignee!=null && cpte.DateConvASSsignee==''){
                comptes[0].BS_Date_convention_ASS_signee__c=null;
            }
            
            if(cpte.DateResiliationConvASS!=null && cpte.DateResiliationConvASS!=''){
                comptes[0].BS_Date_resiliation_convention_ASS__c=date.valueof(cpte.DateResiliationConvASS);
            }else if(cpte.DateResiliationConvASS!=null && cpte.DateResiliationConvASS==''){
                comptes[0].BS_Date_resiliation_convention_ASS__c=null;
            }
            
            if(cpte.MontantImpayes!=null && cpte.MontantImpayes!=''){
                comptes[0].BS_Montant_des_impayes__c=Decimal.valueof(cpte.MontantImpayes);
            }else if(cpte.MontantImpayes!=null && cpte.MontantImpayes==''){
                comptes[0].BS_Montant_des_impayes__c=0;
            }
            
            if(cpte.MontantAvoirs!=null && cpte.MontantAvoirs!=''){
                comptes[0].BS_Montant_des_avoirs__c=Decimal.valueof(cpte.MontantAvoirs);
            }else if(cpte.MontantAvoirs!=null && cpte.MontantAvoirs==''){
                comptes[0].BS_Montant_des_avoirs__c=0;
            }
            
            /*if(cpte.MontantResil!=null && cpte.MontantResil!=''){
comptes[0].BS_Montant_des_resiliations__c=Decimal.valueof(cpte.MontantResil);
}

if(cpte.caChristal!=null && cpte.caChristal!=''){
comptes[0].BS_Chiffre_affaires_Christal__c=Decimal.valueof(cpte.caChristal);
}
if(cpte.caSagex!=null && cpte.caSagex!=''){
comptes[0].BS_Chiffre_affaires_Sagex__c=Decimal.valueof(cpte.caSagex);
}
if(cpte.caStech!=null && cpte.caStech!=''){
comptes[0].BS_Chiffre_affaires_Solutions_techniques__c=Decimal.valueof(cpte.caStech);
}
if(cpte.caDiag!=null && cpte.caDiag!=''){
comptes[0].BS_CA_Diagnotics_controles__c=Decimal.valueof(cpte.caDiag);
}
if(cpte.caGlobal!=null && cpte.caGlobal!=''){
comptes[0].BS_Chiffre_affaires_global__c=Decimal.valueof(cpte.caGlobal);
}*/
            
            compteForUpsert.add(comptes[0]);
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.IdClientAZ=cpte.IdClientAzur;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    update compteForUpsert;
                }catch(System.DmlException e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le client avec l\'id Azur '+cpte.IdClientAzur+' existe déjà et n\'a pa été mis à jour \n Raisons: '+e.getMessage();
                    messageRetour.IdClientAZ=cpte.IdClientAzur;
                    messageRetour.IdSFDC=Comptes[0].id;
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            messageRetour.message = 'Le client avec l\'id Azur '+Comptes[0].BS_Id_ClientAzur__c+' Existe déjà et a été mis à jour';
            messageRetour.IdClientAZ=comptes[0].BS_Id_ClientAzur__c;
            messageRetour.IdSFDC=Comptes[0].id;
            messageRetour.codeErreur = 200;
            return messageRetour;
        }
        /********************************************************************************************************************
* FIN MAJ
*********************************************************************************************************************/        
        
        
        /********************************************************************************************************************
* DEBUT CREATION
/********************************************************************************************************************/        
        else if(comptes.size()<=0 && Cpte.IdClientAzur!=null && Cpte.IdClientAzur!=''){
            
            Account NewAccount= New Account();
            NewAccount.BS_Code_client__c=cpte.codeClient;
            NewAccount.BS_Id_ClientAzur__c=cpte.IdClientAzur;
            NewAccount.BS_Fax__c =cpte.Fax;
            NewAccount.BS_ID_Adresse__c =cpte.idAdresse;
            NewAccount.ShippingStreet =cpte.Adr1AP;
            if(cpte.Adr2AP!=null && cpte.Adr2AP!='') NewAccount.ShippingStreet+='\n'+cpte.Adr2AP;
            NewAccount.BillingStreet =cpte.Adr1AF;
            if(cpte.Adr2AF!=null && cpte.Adr2AF!='') NewAccount.BillingStreet+='\n'+cpte.Adr2AF;
            NewAccount.ShippingPostalCode=cpte.CodePostalAP;
            NewAccount.BillingPostalCode=cpte.CodePostalAF;
            NewAccount.ShippingCity=cpte.VilleAP;
            NewAccount.BillingCity=cpte.VilleAF;
            NewAccount.BS_N_SIRET__c= cpte.NSiret;
            if(cpte.PDS!=null)NewAccount.BS_PDS__c=Boolean.valueOf(cpte.PDS);
            if(cpte.ClientARisque!= null && cpte.ClientARisque!='') NewAccount.BS_Client_a_risque__c= Boolean.valueOf(cpte.ClientARisque);
            NewAccount.BS_Groupe__c =cpte.Groupe;
            // LMS Ajout vendeur ind
            NewAccount.BS_Code_Vendeur_ind__c=cpte.VendeurSolutionTech;
            
            /************************************************************************************
Vendeur MP, Vendeur PE, Vendeur ST, Gestionnaire clientèle   
*************************************************************************************/            
            //Vendeur Multi-Pôles + gestionnaire clientèle associé
            if(Cpte.VendeurMP!=null && cpte.VendeurMP!='' && VendeursMP.size()>0){				
                NewAccount.BS_Code_Vendeur__c =cpte.VendeurMP;
                NewAccount.OwnerId =VendeursMP[0].id; 
                NewAccount.BS_Gestionnaire_de_clientele__c =VendeursMP[0].BS_Gestionnaire_de_clientele__c;                    
            }else{
                //Msg d'erreur: Code vendeur non reconnu ou vide
                NewAccount.BS_Code_Vendeur__c =cpte.VendeurMP;
                NewAccount.OwnerId =System.Label.BS_Automate_ID; 
                NewAccount.BS_Gestionnaire_de_clientele__c =System.Label.BS_Automate_ID;	                   
            }
            
            //Vendeur Solutions technique
            if(Cpte.VendeurSolutionTech!=null && cpte.VendeurSolutionTech!='' && VendeursST.size()>0){
                NewAccount.BS_Vendeur_Solution_technique__c =VendeursST[0].id;   
            }else{
                //Msg d'erreur: Code vendeur non reconnu ou vide
                NewAccount.BS_Vendeur_Solution_technique__c =System.Label.BS_Automate_ID; 
            }
            
            //Gestionnaire clientele du vendeur indispensable creation
                       
        
            if(Cpte.VendeurSolutionTech!=null && cpte.VendeurSolutionTech!='' && VendeursSTGestionnaire.size()!=0){				
                
                NewAccount.Gestionnaire_de_client_le_Indisp__c =VendeursSTGestionnaire[0].BS_Gestionnaire_de_clientele__c;                    
            }else{
              
                NewAccount.Gestionnaire_de_client_le_Indisp__c =System.Label.BS_Automate_ID;	                   
            }
            
            //Vendeur PE
            if(cpte.VendeurPE!=null && cpte.VendeurPE!='' && VendeursPE.Size()>0){  
                NewAccount.BS_Vendeur_PE__c=VendeursPE[0].Id;
                
            }else{
                /*Si le vendeur n'est pas renseigné dans le flux ou le trigramme ne correspond à aucun user dans SFDC,mettre le manager CO PE par défaut */
                NewAccount.BS_Vendeur_PE__c=System.Label.BS_ManagerCoPE; 
            }
            
            
            /****************************************************************************************
*****************************************************************************************/            
            
            if(cpte.nomClient!=null && cpte.nomClient!=''){
                NewAccount.name=cpte.nomClient;
            }else{
                nbErr++;
                messageRetourindiv=Structure_Client.nomClientmanquant(cpte);
                messageRetour.message+=nbErr+') '+messageRetourindiv.message;
            }
            
            if(cpte.TypeClient!=null && cpte.TypeClient!=''){
                if(cpte.TypeClient=='ADB'){
                    NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
                    NewAccount.BS_Activite_ADB__c=cpte.ActiviteADB;
                    
                }else if(cpte.TypeClient=='CFE' || cpte.TypeClient=='CFE IMMO'){
                    NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_CFE;
                    
                    if(mdtActivSeg.size()>0){
                        NewAccount.BS_Activite__c =mdtActivSeg[0].Activite_SFDC__c;
                        if(mdtActivSeg[0].Segment_SFDC__c!=null && mdtActivSeg[0].Segment_SFDC__c!=''){
                            NewAccount.BS_Segment__c=mdtActivSeg[0].Segment_SFDC__c;
                        }
                    } 
                }else{
                    nbErr++;
                    messageRetourindiv=Structure_Client.typeClientInvalide(cpte);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }
            }
            //Si le type d'enregistrement est null
            Else{
                nbErr++;
                messageRetourindiv=Structure_Client.typeClientManquant(cpte);
                messageRetour.message+=nbErr+') '+messageRetourindiv.message;
            }  
            
            
            NewAccount.Phone=cpte.Mobile;
            NewAccount.BS_Telephone_2__c =cpte.Telephone;
            NewAccount.BS_Adresse_mail__c =cpte.AdresseMail;
            /*if( cpte.Mobile==null || cpte.Mobile=='' || Pattern.matches('[0-9]{10}', cpte.Mobile)){
NewAccount.Phone=cpte.Mobile;
}else{
nbErr++;
messageRetourindiv=Structure_Client.formatMobileInvalide(cpte);
messageRetour.message+=nbErr+') '+messageRetourindiv.message;
}

if( cpte.Telephone==null || cpte.Telephone=='' || Pattern.matches('[0-9]{10}', cpte.Telephone)){
NewAccount.BS_Telephone_2__c =cpte.Telephone;
}else{
nbErr++;
messageRetourindiv=Structure_Client.formatTelephoneInvalide(cpte);
messageRetour.message+=nbErr+') '+messageRetourindiv.message;
}
if(cpte.AdresseMail==null || cpte.AdresseMail==''||Pattern.matches('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})', cpte.AdresseMail)){
NewAccount.BS_Adresse_mail__c =cpte.AdresseMail;
}else{
nbErr++;
messageRetourindiv=Structure_Client.formatEmailInvalide(cpte);
messageRetour.message+=nbErr+') '+messageRetourindiv.message;	                    
} */
            
            if(cpte.ClientReserve!=null && cpte.ClientReserve!='') { 
                if(cpte.ClientReserve=='F'){
                    NewAccount.BS_Client_reserve__c='FNAIM';
                }else if(cpte.ClientReserve=='U'){
                    NewAccount.BS_Client_reserve__c='UNIS';
                }else{
                    nbErr++;
                    messageRetourindiv=Structure_Client.codeClientReserveInvalide(cpte);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }
            }
            
            if(cpte.Region!=null && cpte.Region!='') { 
                if(cpte.Region=='0'){
                    NewAccount.BS_Region__c='IDF';		
                }else if(cpte.Region=='1'){
                    NewAccount.BS_Region__c='Nord';
                }else if(cpte.Region=='2'){
                    NewAccount.BS_Region__c='Sud';
                }else if(cpte.Region=='3'){
                    comptes[0].BS_Region__c='Ouest';
                }else{
                    nbErr++;
                    messageRetourindiv=Structure_Client.codeRegionInvalide(cpte);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }
            }
            
            if(cpte.CreeLeAzur!=null && cpte.CreeLeAzur!='' ){
                NewAccount.BS_Cree_le_Azur__c=date.ValueOf(cpte.CreeLeAzur);
            }
            if(cpte.ModifieLeAzur!=null && cpte.ModifieLeAzur!=''){
                NewAccount.BS_Modifie_le_Azur__c=date.ValueOf(cpte.ModifieLeAzur);
            }
            if(cpte.DateconvPEsignee!=null && cpte.DateconvPEsignee!=''){
                NewAccount.BS_Date_convention_PE_signee__c=Date.ValueOf(cpte.DateconvPEsignee);
            }
            if(cpte.DateResiliationConvPE!=null && cpte.DateResiliationConvPE!=''){
                NewAccount.BS_Date_resiliation_convention_PE__c=Date.ValueOf(cpte.DateResiliationConvPE);
            }
            if(cpte.DateConvASSsignee!=null && cpte.DateConvASSsignee!=''){
                NewAccount.BS_Date_convention_ASS_signee__c=Date.ValueOf(cpte.DateConvASSsignee);
            }
            if(cpte.DateResiliationConvASS!=null && cpte.DateResiliationConvASS!=''){
                NewAccount.BS_Date_resiliation_convention_ASS__c=date.valueof(cpte.DateResiliationConvASS);
            }
            if(cpte.MontantImpayes!=null && cpte.MontantImpayes!=''){
                NewAccount.BS_Montant_des_impayes__c=Decimal.valueof(cpte.MontantImpayes);
            }
            if(cpte.MontantAvoirs!=null && cpte.MontantAvoirs!=''){
                NewAccount.BS_Montant_des_avoirs__c=Decimal.valueof(cpte.MontantAvoirs);
            }
            /*if(cpte.MontantResil!=null && cpte.MontantResil!=''){
NewAccount.BS_Montant_des_resiliations__c=Decimal.valueof(cpte.MontantResil);
}
if(cpte.caChristal!=null && cpte.caChristal!=''){
NewAccount.BS_Chiffre_affaires_Christal__c=Decimal.valueof(cpte.caChristal);
}
if(cpte.caSagex!=null && cpte.caSagex!=''){
NewAccount.BS_Chiffre_affaires_Sagex__c=Decimal.valueof(cpte.caSagex);
}
if(cpte.caStech!=null && cpte.caStech!=''){
NewAccount.BS_Chiffre_affaires_Solutions_techniques__c=Decimal.valueof(cpte.caStech);
}
if(cpte.caDiag!=null && cpte.caDiag!=''){
NewAccount.BS_CA_Diagnotics_controles__c=Decimal.valueof(cpte.caDiag);
}
if(cpte.caGlobal!=null && cpte.caGlobal!=''){
NewAccount.BS_Chiffre_affaires_global__c=Decimal.valueof(cpte.caGlobal);
}*/
            
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.IdClientAZ=cpte.IdClientAzur;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    Database.insert(NewAccount);
                }catch(System.Exception e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message =e.getMessage();
                    messageRetour.IdClientAZ=cpte.IdClientAzur;
                    messageRetour.IdSFDC='';
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            
            list<Account> idCompte = [Select id, BS_Id_ClientAzur__c From Account Where id= :NewAccount.id];
            //Insertion du vendeur MR dans l'équipe du client si le trigramme correspond à un user dans SFDC
            // EVOL LMS : 18/01 => Transfert de la logique en flow
            /*
            if(VendeursST.size()>0){
                acctmemMR.AccountId=idCompte[0].id;
                acctmemMR.TeamMemberRole='Commercial MR';
                acctmemMR.UserId=VendeursST[0].id;
                acctmemMR.OpportunityAccessLevel='Edit';
                acctmemMR.AccountAccessLevel='Edit';
                insert acctmemMR;
            }
*/
            //création tâche relance si date conv renseigné et supérieur à J-15
            if(cpte.DateconvPEsignee!=null && cpte.DateconvPEsignee!=''){
                if(Date.ValueOf(cpte.DateconvPEsignee)>system.today().addDays(-15)){
                    system.debug('$$$$$$$$$ 1)dateConv : '+Date.ValueOf(cpte.DateconvPEsignee)+' 2)Date j-15 :'+ system.today().addDays(-15));
                    task relanceGardien= new task();
                    relanceGardien.Priority='Normale';
                    relanceGardien.recordtypeid=[Select Id,SobjectType,Name From RecordType where Name ='Relance Gardiens' and SobjectType ='Task'  limit 1].Id;
                    relanceGardien.Subject='Relance Gardiens';
                    relanceGardien.WhatId=idCompte[0].id;
                    relanceGardien.status='Ouvert';
                    relanceGardien.ActivityDate=Date.ValueOf(cpte.DateconvPEsignee).addMonths(1);
                    //Nom et prénom du contact
                    id contactClientRtId=[Select Id,SobjectType,Name From RecordType where Name ='Contact Client' and SobjectType ='Contact'  limit 1].Id;
                    List<contact> contactsPrincipaux=[select id, BS_Principal__c, title, recordtypeId from contact where accountid= :idCompte[0].id and BS_Principal__c=true and recordtypeId= :contactClientRtId ];
                    if(contactsPrincipaux.size()==1){
                        relanceGardien.WhoId= contactsPrincipaux[0].id;
                    }else if(contactsPrincipaux.size()>1){
                        List<contact> contactsGestionnaires=[select id, BS_Principal__c, title, recordtypeId from contact where accountid= :idCompte[0].id and BS_Principal__c=true and title='Gestionnaire' and recordtypeId= :contactClientRtId];
                        if(contactsGestionnaires.size()>0){
                            relanceGardien.WhoId= contactsGestionnaires[0].id;
                        }else{
                            relanceGardien.WhoId= contactsPrincipaux[0].id;
                        }
                        
                    }
                    //Fin contact
                    /*
                    //Date de convention + 1 mois (jours ouvrés)
                    date dateconv=Date.ValueOf(cpte.DateconvPEsignee);
                    DateTime dt = DateTime.newInstance(dateconv.year(),dateconv.month(),dateconv.day(),0,0,0);
                    
                    if(dt.addMonths(1).format('EEE')=='Sat'){
                        system.debug('$$$$$$$$$ valeur en attente:Samedi <===> valeur reçu: '+dt+' '+ dt.addMonths(1).format('EEE'));
                        relanceGardien.ActivityDate=Date.ValueOf(dt.addMonths(1).adddays(2));
                        system.debug('$$$$$$$$$ valeur stockée'+ Date.ValueOf(dt.addMonths(1).adddays(2)));
                    }else if(dt.addMonths(1).format('EEE')=='Sun'){
                        system.debug('$$$$$$$$$ valeur en attente:Dimanche <===> valeur reçu: '+ dt.addMonths(1).format('EEE'));
                        relanceGardien.ActivityDate=Date.ValueOf(dt.addMonths(1).adddays(1));
                        system.debug('$$$$$$$$$ valeur stockée'+ Date.ValueOf(dt.addMonths(1).adddays(1)));
                    }else{
                        relanceGardien.ActivityDate=Date.ValueOf(dt).addMonths(1);
                        system.debug('Jour ouvré'+dt.addMonths(1).format('EEE')+' '+dt.addMonths(1));
                    }
                    //Fin date conv
                    */
                    if(Cpte.VendeurPE!=null && cpte.VendeurPE!='' && VendeursPE.size()>0){ 
                        system.debug('ID vendeur PE '+ VendeursPE[0].id);
                        relanceGardien.ownerid =VendeursPE[0].id;
                        
                    }else{
                        relanceGardien.ownerid =System.Label.BS_ManagerCoPE;
                    }
                    insert relanceGardien;
                }
            }
            if(messageRetour.codeErreur !=401){
                messageRetour.message='Le client avec le code '+ cpte.IdClientAzur+' a été créé' ;
                messageRetour.IdClientAZ=cpte.IdClientAzur;
                messageRetour.IdSFDC=idCompte[0].id;
                messageRetour.codeErreur=200;
                return messageRetour;
            }
            return messageRetour;
        }
        
        /********************************************************************************************************************
* FIN CREATION
/********************************************************************************************************************/         
        
        else{
            messageRetourindiv=Structure_Client.idClientAzurManquant(cpte);
            messageRetour.message+=messageRetourindiv.message;
            return messageRetour;
        }
        
        
    }
    
    
    
}