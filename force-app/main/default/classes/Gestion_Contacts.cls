/**
* @author Amine SARBOUTE
* @date 17/07/2020
* @description Gestion_Clients : Gestion du flux Contact AZUR=>SFDC
*/
global with sharing class Gestion_Contacts {
    public static Structure_Contact.MessageRetour CheckContactExistWithExternalID(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour= new Structure_Contact.MessageRetour();
        Structure_Contact.MessageRetour messageRetourindiv= new Structure_Contact.MessageRetour();
        integer nbErr=0;
        messageRetour.message ='Erreur(s): ';
        List<Contact> contactForUpsert= new List<Contact>();
        List<Contact> contacts=Structure_Contact.getContactByIdContactAzur(ct);
        List<Account> clients=Structure_Contact.getClientByIdSource(ct);
        List<BS_Site__c> sites=Structure_Contact.getSiteByIdSource(ct);
        
        
        /********************************************************************************************************************
* DEBUT MAJ
*********************************************************************************************************************/
        system.debug('Nombre de contacts');
        system.debug(contacts.size());
        if (contacts.size()>0 && ct.idContactAzur!=null && ct.idContactAzur!='' ){
            
            if(ct.idSource!=null && ct.idSource!=''){
                contacts[0].BS_Id_Source__c=ct.idSource;
            }else{
                nbErr++;
                messageRetourindiv=Structure_Contact.idSourceManquant(ct);
                messageRetour.message+=messageRetourindiv.message;                    
            } 
            
            if(ct.codeSource!=null && ct.codeSource!=''){
                contacts[0].BS_Code_source__c=ct.codeSource;
                //Contact Client : récupérer le Client à partir de l'id source
                if(ct.codeSource=='1'){
                    contacts[0].RecordTypeId=System.Label.nom_recordtype_Contact_Client;
                    if(clients.size()>0){
                        contacts[0].AccountId=clients[0].id; 
                        //contacts[0].ownerId=clients[0].ownerId;
                    }else{
                        nbErr++;
                        messageRetourindiv=Structure_Contact.idSourceClientInvalide(ct);
                        messageRetour.message+=messageRetourindiv.message;
                    }
                    
                    //Contact Site: récupérer le Site à partir de l'id source et le client associé   
                }else if(ct.codeSource=='2' || ct.codeSource=='4' ){
                    contacts[0].RecordTypeId=System.Label.nom_recordtype_Contact_Site;
                    if(sites.size()>0){
                        contacts[0].BS_Site__c=sites[0].id;
                        contacts[0].AccountId=sites[0].BS_Client__c;
                    }else{
                        nbErr++;
                        messageRetourindiv=Structure_Contact.idSourceSiteInvalide(ct);
                        messageRetour.message+=messageRetourindiv.message;
                    }
                }else{
                    //MSG d'erreur :  Code Source erroné : Valeurs possibles : 1=>Contact client, 2=>Contact Site, , 4=>Contact Lieu
                    nbErr++;
                    messageRetourindiv=Structure_Contact.codeSourceInvalide(ct);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code source est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Contact.codeSourceManquant(ct);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            if(ct.prenom!=null){
                contacts[0].firstName=ct.prenom;
            }
            
            if(ct.nom!=null && ct.nom!=''){
                contacts[0].lastName=ct.nom;
            }else{
                nbErr++;
                messageRetourindiv=Structure_Contact.nomContactManquant(ct);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            if(ct.civilite!=null){
                contacts[0].Salutation=ct.civilite;
            }
            if(ct.mobile!=null){
                contacts[0].MobilePhone=ct.mobile;
            }
            if(ct.telephone!=null){
                contacts[0].Phone=ct.telephone;
            }
            if(ct.qualite!=null ){
                contacts[0].Title=ct.qualite;
            }
            
            if(ct.dateSortie!=null && ct.dateSortie!=''){
                contacts[0].BS_Date_sortie__c=Date.valueOf(ct.dateSortie);
            }else if(ct.dateSortie!=null && ct.dateSortie==''){
                contacts[0].BS_Date_sortie__c=null;
            }
            
            if(ct.adresseEmail!=null){
                contacts[0].Email=ct.adresseEmail;
            }
            if(ct.adressePostale!=null && ct.adressePostale!=''){
                contacts[0].BS_Adresse_postale__c=ct.adressePostale;
            }else if(ct.codeSource=='1' && clients.size()>0){
                contacts[0].BS_Adresse_postale__c=(clients[0].ShippingStreet!=NULL?clients[0].ShippingStreet:'')+' '+
                    							  (clients[0].ShippingPostalCode!=NULL?clients[0].ShippingPostalCode:'')+' '+
                                                  (clients[0].ShippingCity!=NULL?clients[0].ShippingCity:'');
			}else if (ct.codeSource=='2' && sites.size()>0){
                if(sites[0].BS_Adresse_site__c!=null) contacts[0].BS_Adresse_postale__c=sites[0].BS_Adresse_site__c;
            }else if (ct.codeSource=='4'  && sites.size()>0){
                if(sites[0].BS_Adresse_Lieu__c!=null) contacts[0].BS_Adresse_postale__c=sites[0].BS_Adresse_Lieu__c;
            }
            
            if(ct.creeLeAzur!=null && ct.creeLeAzur!=''){
                contacts[0].BS_Cree_le_Azur__c=Date.valueOf(ct.creeLeAzur);
            }else if(ct.creeLeAzur!=null && ct.creeLeAzur==''){
                contacts[0].BS_Cree_le_Azur__c=null;
            }
            
            if(ct.modifieLeAzur!=null && ct.modifieLeAzur!=''){
                contacts[0].BS_Modifie_le_Azur__c=Date.valueOf(ct.modifieLeAzur);
            }else if(ct.modifieLeAzur!=null && ct.modifieLeAzur==''){
                contacts[0].BS_Modifie_le_Azur__c=null;
            }
            
            if(ct.principal!=null){
                contacts[0].BS_Principal__c=Boolean.valueOf(ct.principal);
            }
            //if(ct.Typologie != null && ct.Typologie != ''){
                contacts[0].BS_Typologie__c = ct.Typologie;
            //}
            contactForUpsert.add(contacts[0]);
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.IdContactAZ=ct.idContactAzur;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
            	try{
                	update contactForUpsert;
            	}catch(System.DmlException e){
                //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le contact avec l\'id '+ct.idContactAzur+' existe déjà et n\'a pa été mis à jour. \n Raisons: '+e.getMessage();
                    messageRetour.IdContactAZ=ct.idContactAzur;
                    messageRetour.IdSFDC=contacts[0].id;
                    messageRetour.codeErreur =401;
                	return messageRetour;
            	}
            }
            messageRetour.message = 'Le contact avec l\'id '+ct.idContactAzur+' Existe déjà et a été mis à jour';
            messageRetour.IdContactAZ=ct.idContactAzur;
            messageRetour.IdSFDC=contacts[0].id;
            messageRetour.codeErreur = 200;
            return messageRetour;
        }  
        /********************************************************************************************************************
* FIN MAJ
*********************************************************************************************************************/           
        
        
        /********************************************************************************************************************
* DEBUT CREATION
/********************************************************************************************************************/             
        
        else if(contacts.size()<=0 && ct.idContactAzur!=null && ct.idContactAzur!=''){
            
            Contact NewContact= New Contact();
            NewContact.BS_Id_Contact_Azur__c=ct.idContactAzur;
            NewContact.BS_Code_source__c=ct.codeSource;
            NewContact.firstName=ct.prenom;
            NewContact.Salutation=ct.civilite;
            NewContact.MobilePhone=ct.mobile;
            NewContact.Phone=ct.telephone;
            NewContact.Fax=ct.fax;
            NewContact.Title=ct.qualite;
            NewContact.Email=ct.adresseEmail;
            NewContact.BS_Typologie__c = ct.Typologie;
            
            if(ct.adressePostale!=null && ct.adressePostale!=''){
                NewContact.BS_Adresse_postale__c=ct.adressePostale;
            }else if( ct.codeSource=='1' && clients.size()>0){
                NewContact.BS_Adresse_postale__c= (clients[0].ShippingStreet!=NULL?clients[0].ShippingStreet:'')+' '+
                    							  (clients[0].ShippingPostalCode!=NULL?clients[0].ShippingPostalCode:'')+' '+
                                                  (clients[0].ShippingCity!=NULL?clients[0].ShippingCity:'');
            }else if (ct.codeSource=='2' && sites.size()>0){
                if(sites[0].BS_Adresse_site__c!=null) NewContact.BS_Adresse_postale__c=sites[0].BS_Adresse_site__c;
            }else if (ct.codeSource=='4' && sites.size()>0){
                if(sites[0].BS_Adresse_Lieu__c!=null) NewContact.BS_Adresse_postale__c=sites[0].BS_Adresse_Lieu__c;
            }
            
            if(ct.principal!=null){
                NewContact.BS_Principal__c=Boolean.valueOf(ct.principal);
            }
            if(ct.creeLeAzur!=null && ct.creeLeAzur!='') NewContact.BS_Cree_le_Azur__c=Date.valueOf(ct.creeLeAzur);
            if(ct.modifieLeAzur!=null && ct.modifieLeAzur!='') NewContact.BS_Modifie_le_Azur__c=Date.valueOf(ct.modifieLeAzur);
            if(ct.dateSortie!=null && ct.dateSortie!='') NewContact.BS_Date_sortie__c=Date.valueOf(ct.dateSortie);
            
            if(ct.nom!=null && ct.nom!=''){
                NewContact.lastName=ct.nom;
            }else{
                nbErr++;
                messageRetourindiv=Structure_Contact.nomContactManquant(ct);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            if(ct.idSource!=null && ct.idSource!=''){
                NewContact.BS_Id_Source__c=ct.idSource;
            }else{
                nbErr++;
                messageRetourindiv=Structure_Contact.idSourceManquant(ct);
                messageRetour.message+=messageRetourindiv.message;                    
            }
            
            if(ct.codeSource!=null && ct.codeSource!=''){
                NewContact.BS_Code_source__c=ct.codeSource;
                //Contact Client : récupérer le Client à partir de l'id source
                if(ct.codeSource=='1'){
                    NewContact.RecordTypeId=System.Label.nom_recordtype_Contact_Client;
                    if(clients.size()>0){
                        NewContact.AccountId=clients[0].id; 
                        //NewContact.ownerId=clients[0].ownerId;
                    }else{
                        nbErr++;
                        messageRetourindiv=Structure_Contact.idSourceClientInvalide(ct);
                        messageRetour.message+=messageRetourindiv.message;
                    }
                    
                    //Contact Site: récupérer le Site à partir de l'id source et le client associé   
                }else if(ct.codeSource=='2'|| ct.codeSource=='4'){
                    NewContact.RecordTypeId=System.Label.nom_recordtype_Contact_Site;
                    if(sites.size()>0){
                        NewContact.BS_Site__c=sites[0].id;
                        NewContact.AccountId=sites[0].BS_Client__c;
                    }else{
                        nbErr++;
                        messageRetourindiv=Structure_Contact.idSourceSiteInvalide(ct);
                        messageRetour.message+=messageRetourindiv.message;
                    }
                }else{
                    //MSG d'erreur :  Code Source erroné : Valeurs possibles : 1=>Contact client, 2=>Contact Site, 4=>Contact Lieu
                    //OU garder l'ancien type?
                    nbErr++;
                    messageRetourindiv=Structure_Contact.codeSourceInvalide(ct);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                //MSG d'erreur : Le code source est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Contact.codeSourceManquant(ct);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.IdContactAZ=ct.idContactAzur;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    Database.insert(NewContact);
                }catch(System.Exception e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message =e.getMessage();
                    messageRetour.IdContactAZ=ct.idContactAzur;
                    messageRetour.IdSFDC='';
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }}
            list<Contact> idContact = [Select id, BS_Id_Contact_Azur__c From Contact Where id= :NewContact.id];
            if(messageRetour.codeErreur !=401 && idContact.size() > 0){
                messageRetour.message='Le contact avec l\'id '+ ct.idContactAzur+' a été créé' ;
                messageRetour.IdContactAZ=ct.idContactAzur;
                messageRetour.IdSFDC=idContact[0].id;
                messageRetour.codeErreur=200;
                //return messageRetour;
            }
            return messageRetour;
        }
        /********************************************************************************************************************
* FIN CREATION
/********************************************************************************************************************/         
        
        
        
        
        else{
            //MSG d'erreur : Le code source est obligatoire
            nbErr++;
            messageRetourindiv=Structure_Contact.idContactManquant(ct);
            messageRetour.message+=messageRetourindiv.message;
        }        
        
        return  messageRetour;
            
    }
    
}