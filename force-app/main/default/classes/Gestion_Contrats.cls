/**
* @author Amine SARBOUTE
* @date 23/07/2020
* @description Gestion_Contrats : Gestion du flux Contrat AZUR=>SFDC
*/
Global with sharing class Gestion_Contrats {
    public static Structure_Contrat.MessageRetour CheckContratExistWithExternalID(Structure_Contrat.ContratWrapper ctr) {
        Structure_Contrat.MessageRetour messageRetour= new Structure_Contrat.MessageRetour();
        Structure_Contrat.MessageRetour messageRetourindiv= new Structure_Contrat.MessageRetour();
        integer nbErr=0;
        messageRetour.message ='Erreur(s): ';
        List<Contract> ContratForUpsert= new List<Contract>();
        List<Contract> contrats=Structure_Contrat.getContratByNcontrat(ctr);
        List<BS_Typologie_Contrat__mdt> mdtTypeContrat=Structure_Contrat.transcoFromNContrat(ctr);
        List<BS_statut_Contrat__mdt> mdtStatut=Structure_Contrat.transcoFromCodeStatut(ctr);
        List<BS_Site__c> sites=Structure_Contrat.getSiteAndClientByCodeSite(ctr.codeSite);
        /********************************************************************************************************************
* DEBUT MAJ
*********************************************************************************************************************/
        if (contrats.size()>0 && ctr.noPosition!=null && ctr.noPosition!='' ){
            
            if(ctr.noPosition!=null){
                contrats[0].BS_N_contrat__c=ctr.noPosition;
				contrats[0].Name=ctr.noPosition;                
            }  	
            if(ctr.creeLe!=null && ctr.creeLe!=''){
                contrats[0].BS_Date_creation_Azur__c=Date.valueOf(ctr.creeLe);
            }else if(ctr.creeLe!=null && ctr.creeLe==''){
                contrats[0].BS_Date_creation_Azur__c=null;
            }
            if(ctr.noContrat!=null && ctr.noContrat!=''){
                contrats[0].BS_Prestation__c=ctr.noContrat;
                if(mdtTypeContrat.size()>0){
                    contrats[0].BS_Type_1__c=mdtTypeContrat[0].BS_Type_1__c;
                    contrats[0].BS_Type_2__c=mdtTypeContrat[0].BS_Type_2__c;
                    if(mdtTypeContrat[0].BS_Ordre__c!=null && mdtTypeContrat[0].BS_Ordre__c!='') contrats[0].BS_Ordre__c=Decimal.valueOf(mdtTypeContrat[0].BS_Ordre__c);
                }
            } 
            if(ctr.libelleContrat!=null)  	contrats[0].BS_Libelle_du_contrat__c=ctr.libelleContrat;
            if(ctr.montantHT!=null && ctr.montantHT!=''){
                contrats[0].BS_Montant_total_HT__c=Decimal.ValueOf(ctr.montantHT);
            }else if(ctr.montantHT!=null && ctr.montantHT==''){
                contrats[0].BS_Montant_total_HT__c=0;
            }
            
            if(ctr.statut!=null && ctr.statut!=''){
                if(mdtStatut.size()>0){
                    contrats[0].Status=mdtStatut[0].BS_Statut__c;
                }else{
                    //MSG d'erreur : Le code statut invalide
                    nbErr++;
                    messageRetourindiv=Structure_Contrat.codeStatutInvalide(ctr);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code statut est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Contrat.codeStatutManquant(ctr);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            if(ctr.dateInsertion!=null && ctr.dateInsertion!=''){
                contrats[0].BS_Date_insertion__c=Date.valueOf(ctr.dateInsertion);
            }else if(ctr.dateInsertion!=null && ctr.dateInsertion==''){
                contrats[0].BS_Date_insertion__c=null;
            }
            if(ctr.dateAcception!=null && ctr.dateAcception!=''){
                contrats[0].BS_Date_acceptation__c=Date.valueOf(ctr.dateAcception);
            }else if(ctr.dateAcception!=null && ctr.dateAcception==''){
                contrats[0].BS_Date_acceptation__c=null;
            }
            if(ctr.dateEffet!=null && ctr.dateEffet!=''){
                contrats[0].BS_Date_effet__c=Date.valueOf(ctr.dateEffet);
            }else if(ctr.dateEffet!=null && ctr.dateEffet==''){
                contrats[0].BS_Date_effet__c=null;
            }
            if(ctr.dateInsertResil!=null && ctr.dateInsertResil!=''){
                contrats[0].BS_date_insertion_resiliation__c=Date.valueOf(ctr.dateInsertResil);
            }else if(ctr.dateInsertResil!=null && ctr.dateInsertResil==''){
                contrats[0].BS_date_insertion_resiliation__c=null;
            }
            if(ctr.dateEffetResil!=null && ctr.dateEffetResil!=''){
                contrats[0].BS_Date_effet_resiliation__c=Date.valueOf(ctr.dateEffetResil);
            }else if(ctr.dateEffetResil!=null && ctr.dateEffetResil==''){
                contrats[0].BS_Date_effet_resiliation__c=null;
            }
            if(ctr.dateSuspension!=null && ctr.dateSuspension!=''){
                contrats[0].BS_Date_suspension__c=Date.valueOf(ctr.dateSuspension);
            }else if(ctr.dateSuspension!=null && ctr.dateSuspension==''){
                contrats[0].BS_Date_suspension__c=null;
            }
            if(ctr.societe!=null)      contrats[0].BS_Societe__c=ctr.societe;
            if(ctr.pole!=null)   	   contrats[0].BS_Pole__c=ctr.pole;
            
            if(ctr.DatePropo!=null && ctr.DatePropo!=''){
                contrats[0].BS_Date_propo__c=Date.valueOf(ctr.DatePropo);
            }else if(ctr.DatePropo!=null && ctr.DatePropo==''){
                contrats[0].BS_Date_propo__c=null;
            }
            
            if(ctr.codeSite!=null && ctr.codeSite!=''){
                contrats[0].BS_Code_site__c=ctr.codeSite;
                if(sites.size()>0){
                    contrats[0].BS_Site__c=sites[0].id;
                    if(sites[0].BS_Client__c!=null){
                        contrats[0].AccountId=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_Contrat.getGestionnaireByIdClient(sites[0].BS_Client__c);
                           system.debug('condition set'+sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) {
                            //system.debug('condition set');
                            contrats[0].BS_Gestionnaire__c=gestionnaire[0].id;}
                    }else{
                        //Si Le site n'est associé à aucun client=> ce cas n'existe pas, le client est obligatoire
                        /*nbErr++;
                        messageRetourindiv=Structure_Contrat.clientManquant(ctr);
                        messageRetour.message+=messageRetourindiv.message;*/
                    } 
                    
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_Contrat.codeSiteInvalide(ctr);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Contrat.codeSiteManquant(ctr);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            //ACH ajout 20220222 : lien vers proposition facultatif
            if(ctr.idLeadCRM!=null && ctr.idLeadCRM!=''){
                List<BS_Devis_from_Lead__c> resPropo = Structure_Contrat.getProposition(ctr);
                if(resPropo!= null && resPropo.size()>0)
                    contrats[0].Devis_Prospect__c = resPropo[0].Id;
                
            }else if(ctr.idLeadCRM!=null && ctr.idLeadCRM==''){
                contrats[0].Devis_Prospect__c = null;
            }
            
            ContratForUpsert.add(contrats[0]);
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.nContrat=ctr.noPosition;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    update ContratForUpsert;
                }catch(System.DmlException e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le contrat avec le nContrat '+ctr.noPosition+' existe déjà et n\'a pa été mis à jour. \n Raisons: '+e.getMessage();
                    messageRetour.nContrat=ctr.noPosition;
                    messageRetour.IdSFDC=contrats[0].id;
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            messageRetour.message = 'Le contrat avec le nContrat '+ctr.noPosition+' Existe déjà et a été mis à jour';
            messageRetour.nContrat=ctr.noPosition;
            messageRetour.IdSFDC=contrats[0].id;
            messageRetour.codeErreur = 200;
            return messageRetour;
            
        }
        
        
        /********************************************************************************************************************
* FIN MAJ
*********************************************************************************************************************/     
        
        
        /********************************************************************************************************************
* DEBUT CREATION
/********************************************************************************************************************/     
        else if (contrats.size()<=0 && ctr.noPosition!=null && ctr.noPosition!='' ){
            Contract NewContrat= New Contract();
            if(ctr.noPosition!=null && ctr.noPosition!=''){
                NewContrat.BS_N_contrat__c=ctr.noPosition;
                NewContrat.name	=ctr.noPosition;
            }  	
            if(ctr.creeLe!=null && ctr.creeLe!='')  NewContrat.BS_Date_creation_Azur__c=Date.valueOf(ctr.creeLe);
            if(ctr.noContrat!=null && ctr.noContrat!=''){
                NewContrat.BS_Prestation__c=ctr.noContrat;
                if(mdtTypeContrat.size()>0){
                    NewContrat.BS_Type_1__c=mdtTypeContrat[0].BS_Type_1__c;
                    NewContrat.BS_Type_2__c=mdtTypeContrat[0].BS_Type_2__c;
                    if(mdtTypeContrat[0].BS_Ordre__c!=null && mdtTypeContrat[0].BS_Ordre__c!='') NewContrat.BS_Ordre__c=Decimal.valueOf(mdtTypeContrat[0].BS_Ordre__c);
                }
            } 
            if(ctr.libelleContrat!=null && ctr.libelleContrat!='')  	NewContrat.BS_Libelle_du_contrat__c=ctr.libelleContrat;
            if(ctr.montantHT!=null && ctr.montantHT!='')  			NewContrat.BS_Montant_total_HT__c=Decimal.ValueOf(ctr.montantHT);
            
            if(ctr.statut!=null && ctr.statut!=''){
                if(mdtStatut.size()>0){
                    NewContrat.Status=mdtStatut[0].BS_Statut__c;
                }else{
                    //MSG d'erreur : Le code statut invalide
                    nbErr++;
                    messageRetourindiv=Structure_Contrat.codeStatutInvalide(ctr);
                    messageRetour.message+= messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code statut est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Contrat.codeStatutManquant(ctr);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            if(ctr.dateInsertion!=null && ctr.dateInsertion!='')  	  NewContrat.BS_Date_insertion__c=Date.valueOf(ctr.dateInsertion);
            if(ctr.dateAcception!=null && ctr.dateAcception!='')      NewContrat.BS_Date_acceptation__c=Date.valueOf(ctr.dateAcception);
            if(ctr.dateEffet!=null && ctr.dateEffet!='')  			  NewContrat.BS_Date_effet__c=Date.valueOf(ctr.dateEffet);
            if(ctr.dateInsertResil!=null && ctr.dateInsertResil!='')  NewContrat.BS_date_insertion_resiliation__c=Date.valueOf(ctr.dateInsertResil);
            if(ctr.dateEffetResil!=null && ctr.dateEffetResil!='')    NewContrat.BS_Date_effet_resiliation__c=Date.valueOf(ctr.dateEffetResil);
            if(ctr.dateSuspension!=null && ctr.dateSuspension!='')    NewContrat.BS_Date_suspension__c=Date.valueOf(ctr.dateSuspension);
            if(ctr.societe!=null && ctr.societe!='')   				  NewContrat.BS_Societe__c=ctr.societe;
            if(ctr.pole!=null && ctr.pole!='')   	   				  NewContrat.BS_Pole__c=ctr.pole;
            if(ctr.DatePropo!=null && ctr.DatePropo!='')              NewContrat.BS_Date_propo__c=Date.valueOf(ctr.DatePropo);
            
            if(ctr.codeSite!=null && ctr.codeSite!=''){
                NewContrat.BS_Code_site__c=ctr.codeSite;
                if(sites.size()>0){
                    NewContrat.BS_Site__c=sites[0].id;
                    if(sites[0].BS_Client__c!=null){
                        NewContrat.AccountId=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_Contrat.getGestionnaireByIdClient(sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) NewContrat.BS_Gestionnaire__c=gestionnaire[0].id;
                    }else{
                        //Si Le site n'est associé à aucun client=> ce cas n'existe pas, le client est obligatoire
                        /*nbErr++;
                        messageRetourindiv=Structure_Contrat.clientManquant(ctr);
                        messageRetour.message+=messageRetourindiv.message;*/
                    } 
                    
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_Contrat.codeSiteInvalide(ctr);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Contrat.codeSiteManquant(ctr);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            //ACH ajout 20220222 : lien vers proposition facultatif
            if(ctr.idLeadCRM!=null && ctr.idLeadCRM!=''){
                List<BS_Devis_from_Lead__c> resPropo = Structure_Contrat.getProposition(ctr);
                if(resPropo!= null && resPropo.size()>0)
                    NewContrat.Devis_Prospect__c = resPropo[0].Id;
                
            }else if(ctr.idLeadCRM!=null && ctr.idLeadCRM==''){
                NewContrat.Devis_Prospect__c = null;
            }
            
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.nContrat=ctr.noPosition;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    Database.insert(NewContrat);
                }catch(System.DmlException e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le contrat avec le nContrat '+ctr.noPosition+' n\'a pas été créé. \n Raisons: '+e.getMessage();
                    messageRetour.nContrat=ctr.noPosition;
                    messageRetour.IdSFDC='';
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            list<Contract> idContrat = [Select id, BS_N_contrat__c From Contract Where id= :NewContrat.id];
            if(messageRetour.codeErreur !=401){
                messageRetour.message = 'Le contrat avec le nContrat '+ctr.noPosition+' a été créé';
                messageRetour.nContrat=ctr.noPosition;
                messageRetour.IdSFDC=idContrat[0].id;
                messageRetour.codeErreur = 200;
            }
            return messageRetour;
            
        } 
        /********************************************************************************************************************
* FIN CREATION
/********************************************************************************************************************/     
       //Si le N de contrat est manquant
        else{
            nbErr++;
            messageRetourindiv=Structure_Contrat.nContratManquant(ctr);
            messageRetour.message+=messageRetourindiv.message;
        }
        return messageRetour;
    }
}