/**
* @author Amine SARBOUTE
* @date 15/07/2020
* @description Gestion_Sites :Gestion du flux Sites AZUR=>SFDC
*/
global with sharing class Gestion_Sites {
    
    public static Structure_Site.MessageRetour CheckSiteExistWithExternalID(Structure_Site.SiteWrapper ste) {
        Structure_Site.MessageRetour messageRetour= new Structure_Site.MessageRetour();
        Structure_Site.MessageRetour messageRetourindiv= new Structure_Site.MessageRetour();
        integer nbErr=0;
        messageRetour.message ='Erreur(s): ';
        List<BS_Site__c> siteForUpsert= new List<BS_Site__c>();
        List<BS_Site__c> sites=Structure_Site.getSiteByCodeSite(ste);
        List<Account> clients=Structure_Site.getClientByIdClientAzur(ste);
        //List<BS_Site__c> siteParent=Structure_Site.getSiteParentByCodeSiteAzur(ste);
        /********************************************************************************************************************
* DEBUT MAJ
*********************************************************************************************************************/
        if (sites.size()>0 && ste.codeSiteAz!=null && ste.codeSiteAz!='' ){
            
            //champ owner dans SFDC?
            
            if(ste.Type!=null && ste.Type!=''){
                if(ste.Type=='Site'){
                    sites[0].RecordTypeId=System.Label.BS_nom_recordtype_Site;
                    
                }else if(ste.Type=='Lieu'){
                    sites[0].RecordTypeId=System.Label.BS_nom_recordtype_Lieu;
                }else{
                    //MSG d'erreur :  type site : valeurs possibles => Site, Lieu
                    //OU garder l'ancien type?
                    nbErr++;
                    messageRetourindiv=Structure_Site.typeSiteInvalide(ste);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Type Site obligatoire 
                nbErr++;
                messageRetourindiv=Structure_Site.typeSiteManquant(ste);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            if(ste.idClientAzur!=null && ste.idClientAzur!=''){
                if(clients.size()>0){
                    sites[0].BS_Id_Client_Azur__c=ste.idClientAzur;
                    sites[0].BS_Client__c=clients[0].id;
                    //sites[0].Name=sites[0].BS_Client__r.name;
                }else{
                    //MSG d'erreur : idClient Azur ne correspond à aucun client dans SFDC
                    //OU on garde l'ancien client?
                    nbErr++;
                    messageRetourindiv=Structure_Site.idClientAzInvalide(ste);
                    messageRetour.message+=messageRetourindiv.message;
                }      
            }else{
                //MSG d'erreur : MSG d'erreur : id client Azur obligatoire
                //OU on garde l'ancien client?
                nbErr++;
                messageRetourindiv=Structure_Site.idClientAzurManquant(ste);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            /*
            //Nom site : c'est le nom de résidence. Si null, on met Adresse du Site ou du Lieu
            if(ste.nomResidence!=null && ste.nomResidence!=''){
            	sites[0].Name=ste.nomResidence;     
            }else if(ste.type=='Lieu'){
                sites[0].Name=ste.adresseLieu;
            }
            else{
                sites[0].Name=ste.noVoie+' '+ste.typeVoie+' '+ste.nomVoie+' '+ste.codePostal+' '+ste.ville;
            }*/
            if(ste.codeSiteAz!=null) sites[0].Name=ste.codeSiteAz;
            if(ste.noVoie!=null){
                sites[0].BS_N__c=ste.noVoie;
            }
            /*if(ste.pole!=null && ste.pole!=''){
                sites[0].BS_Pole__c=ste.pole;
            }*/
            if(ste.typeVoie!=null){
                sites[0].BS_Type_voie__c=ste.typeVoie;
            }
            if(ste.nomVoie!=null){
                sites[0].BS_Nom_voie__c=ste.nomVoie;
            }
            if(ste.complementAdr!=null){
                sites[0].BS_Complement__c=ste.complementAdr;
            }
            if(ste.codePostal!=null && ste.codePostal!=''){
                sites[0].BS_Code_Postal__c=Decimal.valueOf(ste.codePostal);
            }else if(ste.codePostal!=null && ste.codePostal==''){
                sites[0].BS_Code_Postal__c=null;
            }
            
            if(ste.ville!=null){
                sites[0].BS_Ville__c=ste.ville;
            }
            if(ste.nomResidence!=null){
                sites[0].BS_Nom_residence__c=ste.nomResidence;
            }
            if(ste.HAB!=null && ste.HAB!=''){
                sites[0].BS_HAB__c=Boolean.valueOf(ste.HAB);
            }
            if(ste.ERT!=null && ste.ERT!=''){
                sites[0].BS_ERT__c=Boolean.valueOf(ste.ERT);
            }
            if(ste.IGH!=null && ste.IGH!=''){
                sites[0].BS_IGH__c=Boolean.valueOf(ste.IGH);
            }
            if(ste.ERP!=null && ste.ERP!=''){
                sites[0].BS_ERP__c=ste.ERP;
            }
            if(ste.ZAR!=null && ste.ZAR!=''){
                sites[0].BS_ZAR__c=Boolean.valueOf(ste.ZAR);
            }
            /*if(ste.situation!=null && ste.situation!=''){
                sites[0].BS_Situation__c=ste.situation;
            }
            if(ste.CodeIRIS!=null && ste.CodeIRIS!=''){
                sites[0].BS_Code_IRIS__c=ste.CodeIRIS;
            }
            if(ste.origine!=null && ste.origine!=''){
                sites[0].BS_Origine__c=ste.origine;
            }*/
            if(ste.dateCreationAzur!=null && ste.dateCreationAzur!=''){
                sites[0].BS_Date_creation_Azur__c=date.ValueOf(ste.dateCreationAzur);
            }else if(ste.dateCreationAzur!=null && ste.dateCreationAzur==''){
                sites[0].BS_Date_creation_Azur__c=null;
            }
            /*if(ste.auteur!=null && ste.auteur!=''){
                sites[0].BS_Auteur_Azur__c=ste.auteur;
            }*/
            if(ste.acces!=null){
                sites[0].BS_Acces__c=ste.acces;
            }
            if(ste.dateChangSyndic!=null && ste.dateChangSyndic!=''){
                sites[0].BS_Date_changement_Syndic__c=date.ValueOf(ste.dateChangSyndic);
            }else if(ste.dateChangSyndic!=null && ste.dateChangSyndic==''){
                sites[0].BS_Date_changement_Syndic__c=null;
            }
            if(ste.ancienClient!=null){
                sites[0].BS_Ancien_client__c=ste.ancienClient;
            }
            if(ste.refClient!=null){
                sites[0].BS_Ref_Client__c=ste.refClient;
            }
            /*if(ste.representePar!=null && ste.representePar!=''){
                sites[0].BS_Facture_represente_par__c=ste.representePar;
            }
            if(ste.total!=null && ste.total!=''){
                sites[0].BS_Total__c=Decimal.valueOf(ste.total);
            }
            if(ste.dateAttestation!=null && ste.dateAttestation!=''){
                sites[0].BS_Date_attestation__c=date.ValueOf(ste.dateAttestation);
            }*/
            if(ste.nbCagesEsc!=null && ste.nbCagesEsc!=''){
                sites[0].BS_nb_cages_escaliers__c=Decimal.valueOf(ste.nbCagesEsc);
            }else if(ste.nbCagesEsc!=null && ste.nbCagesEsc==''){
                sites[0].BS_nb_cages_escaliers__c=null;
            }
            if(ste.LOT!=null && ste.LOT!=''){
                sites[0].BS_LOT__c=Decimal.valueOf(ste.LOT);
            }else if(ste.LOT!=null && ste.LOT==''){
                sites[0].BS_LOT__c=null;
            }
            if(ste.niveau!=null && ste.niveau!=''){
                sites[0].BS_Niveau__c=Decimal.valueOf(ste.niveau);
            }else if(ste.niveau!=null && ste.niveau==''){
                sites[0].BS_Niveau__c=null;
            }
            if(ste.nbPlacesParking!=null && ste.nbPlacesParking!=''){
                sites[0].BS_Nb_places_parking__c=Decimal.valueOf(ste.nbPlacesParking);
            }else if(ste.nbPlacesParking!=null && ste.nbPlacesParking==''){
                sites[0].BS_Nb_places_parking__c=null;
            }
            if(ste.nbAcenseurs!=null && ste.nbAcenseurs!=''){
                sites[0].BS_Nb_ascenseurs__c=Decimal.valueOf(ste.nbAcenseurs);
            }else if(ste.nbAcenseurs!=null && ste.nbAcenseurs==''){
                sites[0].BS_Nb_ascenseurs__c=null;
            }
            if(ste.nomAscensoriste!=null){
                sites[0].BS_Nom_ascensoriste__c=ste.nomAscensoriste;
            }
            /*if(ste.montantImpayes!=null && ste.montantImpayes!=''){
                sites[0].BS_Montant_impayes__c=Decimal.valueOf(ste.montantImpayes);
            }
            if(ste.montantAvoirs!=null && ste.montantAvoirs!=''){
                sites[0].BS_Montant_avoirs_en_cours__c=Decimal.valueOf(ste.montantAvoirs);
            }*/
            if(ste.montantResil!=null && ste.montantResil!=''){
                sites[0].BS_Montant_resiliations_3M__c=Decimal.valueOf(ste.montantResil);
            }else if(ste.montantResil!=null && ste.montantResil==''){
                sites[0].BS_Montant_resiliations_3M__c=0;
            }
            if(ste.adresseLieu!=null){
                sites[0].BS_Adresse_lieu_L1__c=ste.adresseLieu;
            }
            if(ste.dateVisite!=null && ste.dateVisite!=''){
                sites[0].BS_Date_visite__c=Date.valueOf(ste.dateVisite);
            }else if(ste.dateVisite!=null && ste.dateVisite==''){
                sites[0].BS_Date_visite__c=null;
            }
            if(ste.datePrevueVisite!=null && ste.datePrevueVisite!=''){
                sites[0].BS_Date_prevue_visite__c=Date.valueOf(ste.datePrevueVisite);
            }else if(ste.datePrevueVisite!=null && ste.datePrevueVisite==''){
                sites[0].BS_Date_prevue_visite__c=null;
            }
            if(ste.dateCreationVisite!=null && ste.dateCreationVisite!=''){
                sites[0].BS_Date_creation_visite__c=Date.valueOf(ste.dateCreationVisite);
            }else if(ste.dateCreationVisite!=null && ste.dateCreationVisite==''){
                sites[0].BS_Date_creation_visite__c=null;
            }
            /*if(ste.siteParent!=null && ste.siteParent!='' && ste.type=='Lieu' && siteParent.size()>0){
                sites[0].BS_Site_parent__c=siteParent[0].id;
            }*/
            if(ste.caChristal!=null && ste.caChristal!='' ){
                sites[0].BS_CA_Christal__c=Decimal.valueOf(ste.caChristal);
            }else if(ste.caChristal!=null && ste.caChristal=='' ){
                sites[0].BS_CA_Christal__c=0;
            }
            if(ste.CaDiag!=null && ste.CaDiag!='' ){
                sites[0].BS_CA_Diag__c=Decimal.valueOf(ste.CaDiag);
            }else if(ste.CaDiag!=null && ste.CaDiag=='' ){
                sites[0].BS_CA_Diag__c=0;
            }
            if(ste.caSagex!=null && ste.caSagex!=''){
                sites[0].BS_CA_Sagex__c=Decimal.valueOf(ste.caSagex);
            }else if(ste.caSagex!=null && ste.caSagex==''){
                sites[0].BS_CA_Sagex__c=0;
            }
            if(ste.caStech!=null && ste.caStech!='' ){
                sites[0].BS_CA_ST__c=Decimal.valueOf(ste.caStech);
            }else if(ste.caStech!=null && ste.caStech=='' ){
                sites[0].BS_CA_ST__c=0;
            }
            if(ste.montantOffresEnCours!=null && ste.montantOffresEnCours!='' ){
                sites[0].BS_Montant_offres_en_cours__c=Decimal.valueOf(ste.montantOffresEnCours);
            }else if(ste.montantOffresEnCours!=null && ste.montantOffresEnCours=='' ){
                sites[0].BS_Montant_offres_en_cours__c=0;
            }
            if(ste.portfeuilleContractuel!=null && ste.portfeuilleContractuel!='' ){
                sites[0].BS_Portfeuille_Contractuel__c=Decimal.valueOf(ste.portfeuilleContractuel);
            }else if(ste.portfeuilleContractuel!=null && ste.portfeuilleContractuel=='' ){
                sites[0].BS_Portfeuille_Contractuel__c=0;
            }
            if(ste.nbContratsC!=null && ste.nbContratsC!=''){
                sites[0].BS_Nombre_de_contrats_en_C__c=Decimal.valueOf(ste.nbContratsC);
            }else if(ste.nbContratsC!=null && ste.nbContratsC==''){
                sites[0].BS_Nombre_de_contrats_en_C__c=null;
            }
            if(ste.nbContratsS!=null && ste.nbContratsS!=''){
                sites[0].BS_Nombre_de_contrats_en_S__c=Decimal.valueOf(ste.nbContratsS);
            }else if(ste.nbContratsS!=null && ste.nbContratsS==''){
                sites[0].BS_Nombre_de_contrats_en_S__c=null;
            }
            if(ste.nbContratsK!=null && ste.nbContratsK!=''){
                sites[0].BS_Nombre_de_contrats_en_K__c=Decimal.valueOf(ste.nbContratsK);
            }else if(ste.nbContratsK!=null && ste.nbContratsK==''){
                sites[0].BS_Nombre_de_contrats_en_K__c=null;
            }
            if(ste.nbContratsR!=null && ste.nbContratsR!=''){
                sites[0].BS_Nombre_de_contrats_en_R__c=Decimal.valueOf(ste.nbContratsR);
            }else if(ste.nbContratsR!=null && ste.nbContratsR==''){
                sites[0].BS_Nombre_de_contrats_en_R__c=null;
            }
            if(ste.nbContratsO!=null && ste.nbContratsO!=''){
                sites[0].BS_Nombre_de_contrats_en_O__c=Decimal.valueOf(ste.nbContratsO);
            }else if(ste.nbContratsO!=null && ste.nbContratsO==''){
                sites[0].BS_Nombre_de_contrats_en_O__c=null;
            }
            /*if(ste.caGlobal!=null && ste.caGlobal!='' ){
                sites[0].BS_Chiffre_affaires_global__c=Decimal.valueOf(ste.caGlobal);
            }*/
            
            siteForUpsert.add(sites[0]);
            try{
                update siteForUpsert;
            }catch(System.DmlException e){
                //System.debug(e.getDmlMessage());
                messageRetour.message = 'Le site avec le code site '+ste.codeSiteAz+' existe déjà et n\'a pa été mis à jour \n Raisons: '+e.getMessage();
                messageRetour.IdSiteAZ=ste.codeSiteAz;
                messageRetour.IdSFDC=sites[0].id;
                messageRetour.codeErreur =401;
                return messageRetour;
            }
            messageRetour.message = 'Le site avec avec le code site '+ste.codeSiteAz+' Existe déjà et a été mis à jour';
            messageRetour.IdSiteAZ=ste.codeSiteAz;
            messageRetour.IdSFDC=sites[0].id;
            messageRetour.codeErreur = 200;
            return messageRetour;
            
        }
        /********************************************************************************************************************
* FIN MAJ
*********************************************************************************************************************/        
        
        
        
        /********************************************************************************************************************
* DEBUT CREATION
/********************************************************************************************************************/        
        else if(sites.size()<=0 && ste.codeSiteAz!=null && ste.codeSiteAz!=''){
            BS_Site__c NewSite= New BS_Site__c();
            NewSite.Name=ste.codeSiteAz;
            NewSite.BS_Code_Site__c=ste.codeSiteAz;
            NewSite.BS_N__c=ste.noVoie;
            NewSite.BS_Type_voie__c=ste.typeVoie;
            NewSite.BS_Nom_voie__c=ste.nomVoie;
            NewSite.BS_Complement__c=ste.complementAdr;
            if(ste.codePostal!=null && ste.codePostal!='')NewSite.BS_Code_Postal__c=Decimal.valueOf(ste.codePostal);
            NewSite.BS_Ville__c=ste.ville;
            NewSite.BS_Nom_residence__c=ste.nomResidence;
            if(ste.HAB!=null && ste.HAB!='') NewSite.BS_HAB__c=Boolean.valueOf(ste.HAB);
            if(ste.ERT!=null && ste.ERT!='') NewSite.BS_ERT__c=Boolean.valueOf(ste.ERT);
            if(ste.IGH!=null && ste.IGH!='') NewSite.BS_IGH__c=Boolean.valueOf(ste.IGH);
            NewSite.BS_ERP__c=ste.ERP;
            if(ste.ZAR!=null && ste.ZAR!='') NewSite.BS_ZAR__c=Boolean.valueOf(ste.ZAR);
            /*NewSite.BS_Situation__c=ste.situation;
            NewSite.BS_Code_IRIS__c=ste.CodeIRIS;
            NewSite.BS_Origine__c=ste.origine;
            if(ste.pole!=null && ste.pole!=''){
                NewSite.BS_Pole__c=ste.pole;
            }*/
            if(ste.dateCreationAzur!=null && ste.dateCreationAzur!='')NewSite.BS_Date_creation_Azur__c=date.ValueOf(ste.dateCreationAzur);
            NewSite.BS_Acces__c=ste.acces;
            if(ste.dateChangSyndic!=null && ste.dateChangSyndic!='')NewSite.BS_Date_changement_Syndic__c=date.ValueOf(ste.dateChangSyndic);
            if(ste.caChristal!=null && ste.caChristal!='' ) NewSite.BS_CA_Christal__c=Decimal.valueOf(ste.caChristal);
            if(ste.CaDiag!=null && ste.CaDiag!='' )      	NewSite.BS_CA_Diag__c=Decimal.valueOf(ste.CaDiag);
            if(ste.caSagex!=null && ste.caSagex!='')     	NewSite.BS_CA_Sagex__c=Decimal.valueOf(ste.caSagex);
            if(ste.caStech!=null && ste.caStech!='' )    	NewSite.BS_CA_ST__c=Decimal.valueOf(ste.caStech);
            //if(ste.caGlobal!=null && ste.caGlobal!='' )  	NewSite.BS_Chiffre_affaires_global__c=Decimal.valueOf(ste.caGlobal);
           
            NewSite.BS_Ancien_client__c=ste.ancienClient;
            NewSite.BS_Ref_Client__c=ste.refClient;
            /*NewSite.BS_Facture_represente_par__c=ste.representePar;
            if(ste.total!=null && ste.total!='')NewSite.BS_Total__c=Decimal.valueOf(ste.total);
            if(ste.dateAttestation!=null && ste.dateAttestation!='')NewSite.BS_Date_attestation__c=date.ValueOf(ste.dateAttestation);*/	
            if(ste.nbCagesEsc!=null && ste.nbCagesEsc!='')NewSite.BS_nb_cages_escaliers__c=Decimal.valueOf(ste.nbCagesEsc);
            if(ste.LOT!=null && ste.LOT!='') NewSite.BS_LOT__c=Decimal.valueOf(ste.LOT);
            if(ste.niveau!=null && ste.niveau!='')NewSite.BS_Niveau__c=Decimal.valueOf(ste.niveau);
            if(ste.nbPlacesParking!=null && ste.nbPlacesParking!='')NewSite.BS_Nb_places_parking__c=Decimal.valueOf(ste.nbPlacesParking);
            if(ste.LOT!=null && ste.LOT!='')NewSite.BS_Nb_ascenseurs__c=Decimal.valueOf(ste.nbAcenseurs); 
            NewSite.BS_Nom_ascensoriste__c=ste.nomAscensoriste;
            //if(ste.montantImpayes!=null && ste.montantImpayes!='')NewSite.BS_Montant_impayes__c=Decimal.valueOf(ste.montantImpayes);
            //if(ste.montantAvoirs!=null && ste.montantAvoirs!='')NewSite.BS_Montant_avoirs_en_cours__c=Decimal.valueOf(ste.montantAvoirs);
            if(ste.montantResil!=null && ste.montantResil!='')NewSite.BS_Montant_resiliations_3M__c=Decimal.valueOf(ste.montantResil);
            NewSite.BS_Adresse_lieu_L1__c=ste.adresseLieu;
            if(ste.dateVisite!=null && ste.dateVisite!='') NewSite.BS_Date_visite__c=Date.valueOf(ste.dateVisite);
            if(ste.datePrevueVisite!=null && ste.datePrevueVisite!='')NewSite.BS_Date_prevue_visite__c=Date.valueOf(ste.datePrevueVisite);
            if(ste.dateCreationVisite!=null && ste.dateCreationVisite!='')NewSite.BS_Date_creation_visite__c=Date.valueOf(ste.dateCreationVisite);
            if(ste.montantOffresEnCours!=null && ste.montantOffresEnCours!='' )NewSite.BS_Montant_offres_en_cours__c=Decimal.valueOf(ste.montantOffresEnCours);
            if(ste.portfeuilleContractuel!=null && ste.portfeuilleContractuel!='' )NewSite.BS_Portfeuille_Contractuel__c=Decimal.valueOf(ste.portfeuilleContractuel);
           
            if(ste.nbContratsC!=null && ste.nbContratsC!='') NewSite.BS_Nombre_de_contrats_en_C__c=Decimal.valueOf(ste.nbContratsC);
            if(ste.nbContratsS!=null && ste.nbContratsS!='') NewSite.BS_Nombre_de_contrats_en_S__c=Decimal.valueOf(ste.nbContratsS);
            if(ste.nbContratsK!=null && ste.nbContratsK!='') NewSite.BS_Nombre_de_contrats_en_K__c=Decimal.valueOf(ste.nbContratsK);
            if(ste.nbContratsR!=null && ste.nbContratsR!='') NewSite.BS_Nombre_de_contrats_en_R__c=Decimal.valueOf(ste.nbContratsR);
            if(ste.nbContratsO!=null && ste.nbContratsO!='') NewSite.BS_Nombre_de_contrats_en_O__c=Decimal.valueOf(ste.nbContratsO);
            
            
            /*if(ste.siteParent!=null && ste.siteParent!='' && ste.type=='Lieu' && siteParent.size()>0){
                sites[0].BS_Site_parent__c=siteParent[0].id;
            }*/
            
            if(ste.Type!=null && ste.Type!=''){
                if(ste.Type=='Site'){
                    NewSite.RecordTypeId=System.Label.BS_nom_recordtype_Site;
                }else if(ste.Type=='Lieu'){
                    NewSite.RecordTypeId=System.Label.BS_nom_recordtype_Lieu;
                }else{
                    //MSG d'erreur : type site : valeurs possibles => Site, Lieu
                    nbErr++;
                    messageRetourindiv=Structure_Site.typeSiteInvalide(ste);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : type Site obligatoire
                nbErr++;
                messageRetourindiv=Structure_Site.typeSiteManquant(ste);
                messageRetour.message+=nbErr+') '+messageRetourindiv.message;
            }
            /*
            //Nom site : c'est le nom de résidence. Si null, on met Adresse du Site ou du Lieu
            if(ste.nomResidence!=null && ste.nomResidence!=''){
            	NewSite.Name=ste.nomResidence;     
            }else if(ste.type=='Lieu'){
                NewSite.Name=ste.adresseLieu;
            }else{
                NewSite.Name=ste.noVoie+' '+ste.typeVoie+' '+ste.nomVoie+' '+ste.codePostal+' '+ste.ville;
            }
            */
            //Id client Azur
            if(ste.idClientAzur!=null && ste.idClientAzur!=''){
                if(clients.size()>0){
                    NewSite.BS_Id_Client_Azur__c=ste.idClientAzur;
                    NewSite.BS_Client__c=clients[0].id;
                    //NewSite.Name=NewSite.BS_Client__r.name;
                }else{
                    //MSG d'erreur : idClient Azur ne correspond à aucun client dans SFDC
                    nbErr++;
                    messageRetourindiv=Structure_Site.idClientAzInvalide(ste);
                    messageRetour.message+=nbErr+') '+messageRetourindiv.message;
                }      
            }else{
                //MSG d'erreur : MSG d'erreur : id client Azur obligatoire
                nbErr++;
                messageRetourindiv=Structure_Site.idClientAzurManquant(ste);
                messageRetour.message+=nbErr+') '+messageRetourindiv.message;
            }
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.IdSiteAZ=ste.codeSiteAz;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    Database.insert(NewSite);
                }catch(System.Exception e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message =e.getMessage();
                    messageRetour.IdSiteAZ=ste.codeSiteAz;
                    messageRetour.IdSFDC='';
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }}
            list<BS_Site__c> idSite = [Select id, BS_Code_Site__c From BS_Site__c Where id= :NewSite.id];
            if(messageRetour.codeErreur !=401){
                messageRetour.message='Le client avec le code '+ ste.codeSiteAz+' a été créé' ;
                messageRetour.IdSiteAZ=ste.codeSiteAz;
                messageRetour.IdSFDC=idSite[0].id;
                messageRetour.codeErreur=200;
                //return messageRetour;
            }
            return messageRetour;
            
        }
        
        /********************************************************************************************************************
* FIN CREATION
/********************************************************************************************************************/         
        
        else{
            //MSG d'erreur : Code site obligatoire pour la création/MAJ
            nbErr++;
            messageRetourindiv=Structure_Site.codeSiteManquant(ste);
            messageRetour.message+=messageRetourindiv.message;
            return messageRetour;
        }
        
    }
    
}