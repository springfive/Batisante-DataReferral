trigger TRG_prestation on Prestation__c (after insert, after update) {
    System.debug(userinfo.getProfileId());
    if (Trigger.IsAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        List<Prestation__c> Prestation=trigger.new;
        System.debug('News size' + Prestation.size());        
        List<Dictionnaire_Prestations__c> d = [Select Id from Dictionnaire_Prestations__c];
        System.debug('dico : ' + d);
        
        List<Prestation__c> UpdatePrestation = new List<Prestation__c>();
        List<string> Libelle= new List<string>();
        List<Dictionnaire_Prestations__c> Dictionnaire= new List<Dictionnaire_Prestations__c>();
        
        IF (Prestation.size()>0){
            For(integer i=0;i<Prestation.size();i++){
                string dicoName = '';
                if ( Prestation[i].Dictionnaire_Prestations__c != null) {
                    List<Dictionnaire_Prestations__c> dicos = [Select ID,Name from Dictionnaire_Prestations__c where ID =  :Prestation[i].Dictionnaire_Prestations__c];
                    if (dicos.size()>0)
                        dicoName = dicos[0].Name;
                }
                System.debug('Prestation : ' + Prestation[i].Dictionnaire_Prestations__c);
                if (Prestation[i].Libell__c != dicoName){
                    Libelle.add(Prestation[i].Libell__c);   
                }
            }
             System.debug('Libelle size' + Libelle.size());
        
            If(Libelle.size()>0){
                Dictionnaire = [Select ID,Name from Dictionnaire_Prestations__c where Name IN :Libelle ];
            }    
        }
        if (Dictionnaire.size()>0){
            For(integer i=0;i<Prestation.size();i++){
                string dicoName = '';
                if ( Prestation[i].Dictionnaire_Prestations__c != null)
                    dicoName = [Select ID,Name from Dictionnaire_Prestations__c where ID = :Prestation[i].Dictionnaire_Prestations__c][0].Name;
               
                if(Prestation[i].Libell__c != dicoName){
                    Prestation__c NewPrestation = new Prestation__c();
                    for(integer j=0;j<Dictionnaire.size();j++){
                        if(Prestation[i].Libell__c==Dictionnaire[j].Name){
                           NewPrestation.id=Prestation[i].id;
                           NewPrestation.Dictionnaire_Prestations__c=Dictionnaire[j].id;
                        }   
                    }
                    if(NewPrestation.id != null){
                        UpdatePrestation.add(NewPrestation);
                    } 
                }
            }
        }
        
        System.debug('Update presta size : ' + UpdatePrestation.size());
        If(UpdatePrestation.size()>0){
            Update UpdatePrestation;
        }    
    }
    
    //Gestion des prestations de type 'Contrat' - Création des lots
    if (trigger.isAfter && trigger.isInsert) {
        List<Lot__c> nvxLots = new List<Lot__c>();
    
        for (Prestation__c presta : Trigger.new) {
            List<Parametre_de_lot__c> parametres = [Select id, Name, Dictionnaire_Prestations__r.Name from Parametre_de_lot__c where Dictionnaire_Prestations__r.Name =: presta.Libell__c ORDER BY Id];
            List<BS_Devis_from_Lead__c> props = [Select Emplacement__r.BS_Client__c, Emplacement__r.id, Emplacement__r.BS_LOT__c, Emplacement__r.BS_nb_cages_escaliers__c, Emplacement__r.BS_Nb_places_parking__c, Emplacement__r.BS_Niveau__c,Emplacement__r.BS_Nb_ascenseurs__c FROM BS_Devis_from_Lead__c WHERE Id=:presta.Devis_Pistes__c];

            for (Parametre_de_lot__c param : parametres) {
                Decimal quant = 0;
                
                //Cas où des les quantités de lots peuvent être récupérées depuis le site de la proposition à laquelle appartient la prestation
                if (props.size() > 0) {
                    if (param.Name == 'Cage' || param.Name == 'Cages d\'escaliers') {
                        quant = props[0].Emplacement__r.BS_nb_cages_escaliers__c == null ? 0 : props[0].Emplacement__r.BS_nb_cages_escaliers__c;
                        
                    }
                    else if (param.Name.contains( '1ère Cage') ){
                        quant = props[0].Emplacement__r.BS_nb_cages_escaliers__c == null ? 0 : 1;
                    }
                     else if (param.Name.contains( 'Cage suivantes') ){
                        quant = props[0].Emplacement__r.BS_nb_cages_escaliers__c == null ? 0 : props[0].Emplacement__r.BS_nb_cages_escaliers__c-1;
                    }
                    else if (param.Name.contains('Lot')) {
                        quant = props[0].Emplacement__r.BS_LOT__c == null ? 0 : props[0].Emplacement__r.BS_LOT__c;
                    }
                    else if (param.Name == 'Place de Parking') {
                        quant = props[0].Emplacement__r.BS_Nb_places_parking__c == null ? 0 : props[0].Emplacement__r.BS_Nb_places_parking__c;
                    }
                    else if (param.Name == 'Niveau') {
                        quant = props[0].Emplacement__r.BS_Niveau__c == null ? 0 : props[0].Emplacement__r.BS_Niveau__c;
                    }
                    else if (param.Name == 'Défibrillateur') {
                        quant = 1;
                    }
                    else if(param.Name=='Nb Ascenseurs'||(param.Name.contains('Ascenseur')&& props[0].Emplacement__r.BS_Nb_ascenseurs__c==null||(param.Name.contains('Ascenseur')&& props[0].Emplacement__r.BS_Nb_ascenseurs__c==0) )){
                         quant = props[0].Emplacement__r.BS_Nb_ascenseurs__c == null ? 0 : props[0].Emplacement__r.BS_Nb_ascenseurs__c;
                        
                    }
                    else if (param.Name.contains('Ascenseur')) {
                        if(param.Name=='Nb Ascenseurs portefeuille'){
                            
                        }
                        //dev sur les ascenseurs separee sur le 1 2 3 ascenceurs
                        else if(param.Name.contains('1')){
                            quant=1;
                            
                            
                        }else{
                          integer numLot=integer.valueOf(param.Name.substring(0,1));
                             System.debug('Numero extrait lynda'+numLot);
                            double resultatLot=props[0].Emplacement__r.BS_Nb_ascenseurs__c-numLot;
                            if(resultatLot>=0){
                                if(numLot!=5|| resultatLot==0)
                                {quant=1;}else{
                                   quant=resultatLot+1; 
                                }
                                
                                
                            }else{
                                quant=0;
                            }
                            
                            
                            //if(props[0].Site__r.BS_Nb_ascenseurs__c){}  
                        } //--dev sur les ascenseurs separee sur le 1 2 3 ascenceurs
                        
                        //quant = props[0].Site__r.BS_Nb_ascenseurs__c == null ? 0 : props[0].Site__r.BS_Nb_ascenseurs__c;
                    }
                }
                
                //Ajout d'un lot à créer à la fin du trigger
                Lot__c lot = new Lot__c(Parametre_de_lot__c=param.Id, Prestation__c=presta.Id, Prix_du_lot__c=0, Quantite__c=quant);
                nvxLots.add(lot);
            }
        }
        //Création des lots
        if (nvxLots.size() > 0) {
            System.debug('Insertion de ' + nvxLots.size() + + ' nouveaux lots');
            insert nvxLots;
        }
    }
}