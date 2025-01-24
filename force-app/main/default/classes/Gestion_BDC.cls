/**
* @author Amine SARBOUTE
* @date 27/07/2020
* @description Gestion_BDC : Gestion du flux BDC AZUR=>SFDC
*/
Global with sharing class Gestion_BDC {
    public static Structure_BDC.MessageRetour CheckBDCExistWithExternalID(Structure_BDC.BDCWrapper bdc) {
        Structure_BDC.MessageRetour messageRetour= new Structure_BDC.MessageRetour();
        Structure_BDC.MessageRetour messageRetourindiv= new Structure_BDC.MessageRetour();
        integer nbErr=0;
        messageRetour.message ='Erreur(s): ';
        List<BS_BDC__c> BDCForUpsert= new List<BS_BDC__c>();
        List<BS_BDC__c> BDCs=Structure_BDC.getBDCByNoBDC(bdc);
        List<TypeBDC__mdt> mdtBDC=Structure_BDC.transcoFromPrestation(bdc); 
        List<BS_Site__c> sites=Structure_BDC.getSiteAndClientByCodeSite(bdc.codeSite);
        List<BS_statut_Contrat__mdt> mdtStatut=Structure_BDC.transcoFromCodeStatut(bdc);
        
        BS_BDC_Site__c bdcSite = new BS_BDC_Site__c();
        /********************************************************************************************************************
* DEBUT MAJ
*********************************************************************************************************************/
        if (BDCs.size()>0 && bdc.noBDC!=null && bdc.noBDC!='' ){
            if(bdc.noBDC!=null && bdc.noBDC!=''){
                BDCs[0].BS_N_BDC__c=bdc.noBDC;
                BDCs[0].name=bdc.noBDC;
            }  	
            if(bdc.dateCreaAz!=null && bdc.dateCreaAz!=''){
                BDCs[0].BS_Date_creation_Az__c=Date.valueOf(bdc.dateCreaAz);
            }else if(bdc.dateCreaAz!=null && bdc.dateCreaAz==''){
                BDCs[0].BS_Date_creation_Az__c=null;
            }
            if(bdc.prestation!=null && bdc.prestation!=''){
                BDCs[0].BS_Prestation__c=bdc.prestation;
                if(mdtBDC.size()>0){
                    BDCs[0].BS_Type1__c=mdtBDC[0].BS_Type1__c;
                    BDCs[0].BS_Type2__c=mdtBDC[0].BS_Type2__c; 
                }
            }
            if(bdc.idElmtPropo!=null)  		BDCs[0].BS_N_element__c=bdc.idElmtPropo;
            if(bdc.libelle!=null)  				BDCs[0].BS_Libelle__c=bdc.libelle;
            if(bdc.montantHT!=null && bdc.montantHT!=''){
                BDCs[0].BS_Prix_HT__c=Decimal.ValueOf(bdc.montantHT);
            }else if(bdc.montantHT!=null && bdc.montantHT==''){
                BDCs[0].BS_Prix_HT__c=null;
            }
            if(bdc.societe!=null )  				BDCs[0].BS_Societe__c=bdc.societe;
            if(bdc.pole!=null )  					BDCs[0].BS_Pole__c=bdc.pole;
            if(bdc.dateInsertion!=null && bdc.dateInsertion!=''){
                BDCs[0].BS_Date_insertion__c=Date.valueOf(bdc.dateInsertion);
            }else if(bdc.dateInsertion!=null && bdc.dateInsertion==''){
                BDCs[0].BS_Date_insertion__c=null;
            }
            if(bdc.dateEffet!=null && bdc.dateEffet!=''){
                BDCs[0].BS_Date_effet__c=Date.valueOf(bdc.dateEffet);
            }else if(bdc.dateEffet!=null && bdc.dateEffet==''){
                BDCs[0].BS_Date_effet__c=null;
            } 
            if(bdc.dateFin!=null && bdc.dateFin!=''){
                BDCs[0].BS_Date_de_fin__c=Date.valueOf(bdc.dateFin);
            }else if(bdc.dateFin!=null && bdc.dateFin==''){
                BDCs[0].BS_Date_de_fin__c=null;
            }			
            if(bdc.dateInsertResil!=null && bdc.dateInsertResil!=''){
                BDCs[0].BS_Date_insertion_resiliation__c=Date.valueOf(bdc.dateInsertResil);
            }else if(bdc.dateInsertResil!=null && bdc.dateInsertResil==''){
                BDCs[0].BS_Date_insertion_resiliation__c=null;
            }
            if(bdc.dateEffetResil!=null && bdc.dateEffetResil!=''){
                BDCs[0].BS_Date_effet_resiliation__c=Date.valueOf(bdc.dateEffetResil);
            }else if(bdc.dateEffetResil!=null && bdc.dateEffetResil==''){
                BDCs[0].BS_Date_effet_resiliation__c=null;
            }
            if(bdc.dateAcception!=null && bdc.dateAcception!=''){
                BDCs[0].BS_Date_acceptation__c=Date.valueOf(bdc.dateAcception);
            }else if(bdc.dateAcception!=null && bdc.dateAcception==''){
                BDCs[0].BS_Date_acceptation__c=null;
            }
            if(bdc.statut!=null && bdc.statut!=''){
                if(mdtStatut.size()>0){
                    BDCs[0].BS_Statut__c=mdtStatut[0].BS_Statut__c;
                }else{
                    //MSG d'erreur : Le code statut invalide
                    nbErr++;
                    messageRetourindiv=Structure_BDC.codeStatutInvalide(bdc);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code statut est obligatoire
                nbErr++;
                messageRetourindiv=Structure_BDC.codeStatutManquant(bdc);
                messageRetour.message+=messageRetourindiv.message;
            }
           /* if(bdc.codeSite!=null && bdc.codeSite!=''){
                BDCs[0].BS_Code_site__c=bdc.codeSite;
                if(sites.size()>0){
                    BDCs[0].BS_Site__c=sites[0].id;
                    if(sites[0].BS_Client__c!=null){
                        BDCs[0].BS_Client__c=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_BDC.getGestionnaireByIdClient(sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) BDCs[0].BS_Contact__c=gestionnaire[0].id;
                    }else{
                        //Si Le site n'est associé à aucun client
                        nbErr++;
                        messageRetourindiv=Structure_BDC.clientManquant(bdc);
                        messageRetour.message+=messageRetourindiv.message;
                    } 
                    
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_BDC.codeSiteInvalide(bdc);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_BDC.codeSiteManquant(bdc);
                messageRetour.message+=messageRetourindiv.message;
            }*/
            
            if(bdc.codeSite!=null && bdc.codeSite!=''){
                if(sites.size()>0){
                    List<BS_BDC_Site__c> bdcSites=Structure_BDC.getBdcSiteById(bdc.codeSite,bdc);
                    if(bdcSites.size()==0){
                    	bdcSite.BS_Site__c=sites[0].id;
                        bdcSite.BS_BDC__c =BDCs[0].id;
                        insert bdcSite;
                    }
                    if(sites[0].BS_Client__c!=null){
                        BDCs[0].BS_Client__c=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_BDC.getGestionnaireByIdClient(sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) BDCs[0].BS_Contact__c=gestionnaire[0].id;
                    }else{
                        //Si Le site n'est associé à aucun client=>Impossible
                       /* nbErr++;
                        messageRetourindiv=Structure_BDC.clientManquant(bdc);
                        messageRetour.message+=messageRetourindiv.message;*/
                    } 
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC?
                    nbErr++;
                    messageRetourindiv=Structure_BDC.codeSiteInvalide(bdc);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_BDC.codeSiteManquant(bdc);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            //ACH ajout 20220222 : lien vers proposition facultatif
            if(bdc.idLeadCRM!=null && bdc.idLeadCRM!=''){
                List<BS_Devis_from_Lead__c> resPropo = Structure_BDC.getProposition(bdc);
                if(resPropo!= null && resPropo.size()>0)
                    BDCs[0].Devis_Prospect__c = resPropo[0].Id;
                
            }else if(bdc.idLeadCRM!=null && bdc.idLeadCRM==''){
                BDCs[0].Devis_Prospect__c = null;
            }
            
            BDCForUpsert.add(BDCs[0]);
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.nBDC=bdc.noBDC;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    update BDCForUpsert;
                }catch(System.DmlException e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le BDC avec le N° '+bdc.noBDC+' existe déjà et n\'a pa été mis à jour. \n Raisons: '+e.getMessage();
                    messageRetour.nBDC=bdc.noBDC;
                    messageRetour.IdSFDC=BDCs[0].id;
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            messageRetour.message = 'Le BDC avec le N° '+bdc.noBDC+' Existe déjà et a été mis à jour';
            messageRetour.nBDC=bdc.noBDC;
            messageRetour.IdSFDC=BDCs[0].id;
            messageRetour.codeErreur = 200;
            return messageRetour;
        }
        /********************************************************************************************************************
* FIN MAJ
*********************************************************************************************************************/     
        
        
        /********************************************************************************************************************
* DEBUT CREATION
/********************************************************************************************************************/     
        else if(BDCs.size()<=0 && bdc.noBDC!=null && bdc.noBDC!='' ){
            BS_BDC__c NewBDC= New BS_BDC__c();
            if(bdc.noBDC!=null && bdc.noBDC!=''){
                NewBDC.BS_N_BDC__c=bdc.noBDC;
                NewBDC.name=bdc.noBDC;
            }  	
            
            if(bdc.dateCreaAz!=null && bdc.dateCreaAz!='') NewBDC.BS_Date_creation_Az__c=Date.valueOf(bdc.dateCreaAz);
            if(bdc.prestation!=null && bdc.prestation!=''){
                NewBDC.BS_Prestation__c=bdc.prestation;
                if(mdtBDC.size()>0){
                    NewBDC.BS_Type1__c=mdtBDC[0].BS_Type1__c;
                    NewBDC.BS_Type2__c=mdtBDC[0].BS_Type2__c; 
                }
            }
            if(bdc.idElmtPropo!=null && bdc.idElmtPropo!='')  		NewBDC.BS_N_element__c=bdc.idElmtPropo;
            if(bdc.libelle!=null && bdc.libelle!='')  				NewBDC.BS_Libelle__c=bdc.libelle;
            if(bdc.montantHT!=null && bdc.montantHT!='')  			NewBDC.BS_Prix_HT__c=Decimal.ValueOf(bdc.montantHT);
            if(bdc.societe!=null && bdc.societe!='')  				NewBDC.BS_Societe__c=bdc.societe;
            if(bdc.pole!=null && bdc.pole!='')  					NewBDC.BS_Pole__c=bdc.pole;
            if(bdc.dateInsertion!=null && bdc.dateInsertion!='') 	NewBDC.BS_Date_insertion__c=Date.valueOf(bdc.dateInsertion);
            if(bdc.dateEffet!=null && bdc.dateEffet!='') 		    NewBDC.BS_Date_effet__c=Date.valueOf(bdc.dateEffet);
            if(bdc.dateFin!=null && bdc.dateFin!='') 				NewBDC.BS_Date_de_fin__c=Date.valueOf(bdc.dateFin);
            if(bdc.dateInsertResil!=null && bdc.dateInsertResil!='')NewBDC.BS_Date_insertion_resiliation__c=Date.valueOf(bdc.dateInsertResil);
            if(bdc.dateEffetResil!=null && bdc.dateEffetResil!='')  NewBDC.BS_Date_effet_resiliation__c=Date.valueOf(bdc.dateEffetResil);
            if(bdc.dateAcception!=null && bdc.dateAcception!='') 	NewBDC.BS_Date_acceptation__c=Date.valueOf(bdc.dateAcception);
            if(bdc.statut!=null && bdc.statut!=''){
                if(mdtStatut.size()>0){
                    NewBDC.BS_Statut__c=mdtStatut[0].BS_Statut__c;
                }else{
                    //MSG d'erreur : Le code statut invalide
                    nbErr++;
                    messageRetourindiv=Structure_BDC.codeStatutInvalide(bdc);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code statut est obligatoire
                nbErr++;
                messageRetourindiv=Structure_BDC.codeStatutManquant(bdc);
                messageRetour.message+=messageRetourindiv.message;
            }
            /*
            if(bdc.codeSite!=null && bdc.codeSite!=''){
                NewBDC.BS_Code_site__c=bdc.codeSite;
                if(sites.size()>0){
                    NewBDC.BS_Site__c=sites[0].id;
                    if(sites[0].BS_Client__c!=null){
                        NewBDC.BS_Client__c=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_BDC.getGestionnaireByIdClient(sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) NewBDC.BS_Contact__c=gestionnaire[0].id;
                    }else{
                        //Si Le site n'est associé à aucun client
                        nbErr++;
                        messageRetourindiv=Structure_BDC.clientManquant(bdc);
                        messageRetour.message+=messageRetourindiv.message;
                    } 
                    
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_BDC.codeSiteInvalide(bdc);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_BDC.codeSiteManquant(bdc);
                messageRetour.message+=messageRetourindiv.message;
            }*/
            
            if(bdc.codeSite!=null && bdc.codeSite!=''){
                if(sites.size()>0){
                    bdcSite.BS_Site__c=sites[0].id;
                    if(sites[0].BS_Client__c!=null){
                        NewBDC.BS_Client__c=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_BDC.getGestionnaireByIdClient(sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) NewBDC.BS_Contact__c=gestionnaire[0].id;
                    }else{
                        //Si Le site n'est associé à aucun client=>Impossible
                        /*nbErr++;
                        messageRetourindiv=Structure_BDC.clientManquant(bdc);
                        messageRetour.message+=messageRetourindiv.message;*/
                    } 
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_BDC.codeSiteInvalide(bdc);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_BDC.codeSiteManquant(bdc);
                messageRetour.message+=messageRetourindiv.message;
            }
                        
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.nBDC=bdc.noBDC;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    Database.insert(NewBDC);
                }catch(System.DmlException e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le BDC avec le N° '+bdc.noBDC+' n\'a pas été créé. \n Raisons: '+e.getMessage();
                    messageRetour.nBDC=bdc.noBDC;
                    messageRetour.IdSFDC='';
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            list<BS_BDC__c> idBDC = [Select id, BS_N_BDC__c From BS_BDC__c Where id= :NewBDC.id];
            if(messageRetour.codeErreur !=401){
                bdcSite.BS_BDC__c = idBDC[0].id;
                messageRetour.message = 'Le BDC avec le N° '+bdc.noBDC+' a été créé';
                messageRetour.nBDC=bdc.noBDC;
                messageRetour.IdSFDC=idBDC[0].id;
                messageRetour.codeErreur = 200;
            }
            insert bdcSite;
            return messageRetour;
            
        }
        
        /********************************************************************************************************************
* FIN CREATION
/********************************************************************************************************************/     
        //Si le N de BDC est manquant
        else{
            nbErr++;
            messageRetourindiv=Structure_BDC.nBDCManquant(bdc);
            messageRetour.message+=messageRetourindiv.message;
        }    
        return messageRetour;
    }
    
}