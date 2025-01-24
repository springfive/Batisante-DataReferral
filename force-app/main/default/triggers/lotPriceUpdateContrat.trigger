trigger lotPriceUpdateContrat on Lot__c (after insert, after update) {
    List<String> prestationsString = new List<String>();
    for (Lot__c lot : Trigger.new) {
        if (!prestationsString.contains(lot.Prestation__c)) {
            prestationsString.add(lot.Prestation__c);
        }
    }
    
    System.debug('Nombre de prestation(s) à traiter : ' + prestationsString.size());
    for (String presta : prestationsString) {
        system.debug('Itération sur les prestations');
        Decimal prestaPrice = 0;
        Decimal deplacementPrice = 0;
        Prestation__c prestation = [Select Devis_Pistes__c, Libell__c, Prix_Unitaire_HT__c, Coefficient__c, Coefficient_deplacement__c, Nombre_de_passages_annuels__c, Prix_deplacement__c  From Prestation__c WHERE Id =:presta];
        List<Lot__c> lots = [Select Id, Prix_du_lot__c, Quantite__c, Parametre_de_lot__r.Equivalent_en_lots__c, Parametre_de_lot__r.Name, Parametre_de_lot__r.Niveau_contrat__c from Lot__c where Prestation__c =: presta AND Parametre_de_lot__r.Equivalent_en_lots__c > 0 Order By Parametre_de_lot__r.Name];
        
        if (lots.size() == 0) {
        	continue;
    	}
        
        //Création d'une tâche liée au site dans les cas suivants :
        //		- A la création du lot, la valeur de départ pour la quantité est récupérée sur le site et vaut 0
        //		- A la modification de la quantité d'un lot dont la valeur de départ est récupérée sur le site
        //Les lots concernés sont ceux dont le paramètre de lot a pour nom Cage, Place de parking, Niveau ou contient le mot Lot
        for (Lot__c lot : lots) {
            if (Trigger.newMap.containsKey(lot.id) && (lot.Parametre_de_lot__r.Name == 'Cage' || lot.Parametre_de_lot__r.Name.contains('Lot') || lot.Parametre_de_lot__r.Name == 'Place de Parking' || lot.Parametre_de_lot__r.Name == 'Niveau'|| lot.Parametre_de_lot__r.Name.contains('Ascenseur'))) {
                if ((trigger.isInsert && lot.Quantite__c == 0) || (trigger.isUpdate && lot.Quantite__c != trigger.oldMap.get(lot.Id).Quantite__c)) {
                    List<BS_Devis_from_Lead__c> props = [Select Emplacement__r.BS_Client__c, Emplacement__r.id FROM BS_Devis_from_Lead__c WHERE Id=:prestation.Devis_Pistes__c];
            		Id recordTypeGestionnaireTask = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BS_Tache_gestionnaire').getRecordTypeID();
                    String descriptionTask;
                    if (trigger.isUpdate)
                        descriptionTask = 'Serait-il possible de mettre à jour le site dans Azur avec \'' + lot.Parametre_de_lot__r.Name +'\' : ' + lot.Quantite__c + ' ?';
                    else
                        descriptionTask = 'Serait-il possible de mettre à jour le site dans Azur pour le champ \'' + lot.Parametre_de_lot__r.Name +'\' ?';
                    List<Account> taskOwner = [Select BS_Gestionnaire_de_clientele__c from Account where id =: props[0].Emplacement__r.BS_Client__c LIMIT 1];
                    Date dueDate = Date.today().addDays(2);
                    DateTime dt = (DateTime) dueDate;
                    String dayWeek = dt.format('u');
                    if (dayWeek == '6' || dayWeek == '7')
                        dueDate = dueDate.addDays(2);
                  //  insert new Task(WhatId=props[0].Emplacement__r.id, RecordTypeId=recordTypeGestionnaireTask,Subject='Tâche Gestionnaire', Status='Ouvert',Description=descriptionTask,OwnerId=taskOwner[0].BS_Gestionnaire_de_clientele__c,ActivityDate=dueDate,BS_Action_gest__c='Maj Azur');
                	System.debug(lot.Quantite__c);
                }
            }
        }
        
        if (prestation.Libell__c.contains('2923')) {
            System.debug('Cas du prix particulier contrat 2923');
            if (lots.size() == 3) {
                Lot__c pelle = lots[2];
                List<Palier__c> paliersPelle = [Select Minimum__c, Maximum__c, Prix_forfait__c, Prix_par_lot__c FROM Palier__c where Parametre_de_lot__r.Id =:pelle.Parametre_de_lot__c];
                for (Palier__c palier : paliersPelle) {
                    if (pelle.Quantite__c >= palier.Minimum__c && pelle.Quantite__c <= palier.Maximum__c)
                        prestaPrice += (pelle.Quantite__c * palier.Prix_par_lot__c * pelle.Parametre_de_lot__r.Equivalent_en_lots__c) + palier.Prix_forfait__c;
                }
                Decimal otherLots = (lots[1].Quantite__c * lots[1].Parametre_de_lot__r.Equivalent_en_lots__c) + (lots[0].Quantite__c * lots[0].Parametre_de_lot__r.Equivalent_en_lots__c);
                List<Palier__c> otherPaliers = [Select Minimum__c, Maximum__c, Prix_forfait__c, Prix_par_lot__c FROM Palier__c where Parametre_de_lot__r.Id =:lots[0].Parametre_de_lot__c];
            	System.debug('Param name: ' + lots[0].Parametre_de_lot__r.Name + ', param id: ' + lots[0].Parametre_de_lot__c);
                for (Palier__c palier : otherPaliers) {
                    System.debug('Min: ' + palier.Minimum__c + ', max : ' + palier.Maximum__c + ', actual: ' + otherLots);
                    if (otherLots >= palier.Minimum__c && otherLots <= palier.Maximum__c)
                        prestaPrice += (otherLots * palier.Prix_par_lot__c) + palier.Prix_forfait__c;
                }
            }
        }
        
        if (prestation.Libell__c.contains('5385')||prestation.Libell__c.contains('5387')) {
            System.debug('Cas du prix particulier contrat 5381');
            
             Id param = lots[0].Parametre_de_lot__c;
            decimal Nb_AscenseurPortfeuille = lots[1].Quantite__c;
             List<Palier__c> paliers = [Select Minimum__c, Maximum__c, Prix_forfait__c, Prix_par_lot__c, Prix_deplacement__c FROM Palier__c where Parametre_de_lot__r.Id =:param];
            Decimal equivalenceLot = lots[0].Parametre_de_lot__r.Equivalent_en_lots__c * lots[0].Quantite__c;
            
             for (Palier__c palier: paliers) {
                System.debug('Minumum: ' + palier.Minimum__c + ' Maximum: ' + palier.Maximum__c + ' equivalence lot: ' + equivalenceLot);
                if (palier.Minimum__c <= Nb_AscenseurPortfeuille && Nb_AscenseurPortfeuille <= palier.Maximum__c) {
                    prestaPrice = palier.Prix_forfait__c +  (palier.Prix_par_lot__c * equivalenceLot);
                    deplacementPrice = palier.Prix_deplacement__c;
                    break;
                }
            }
            
            
        }

        else if (lots[0].Parametre_de_lot__r.Niveau_contrat__c) {
            System.debug('Cas du prix remontant sur le contrat');
            Id param = lots[0].Parametre_de_lot__c;
            List<Palier__c> paliers = [Select Minimum__c, Maximum__c, Prix_forfait__c, Prix_par_lot__c, Prix_deplacement__c FROM Palier__c where Parametre_de_lot__r.Id =:param];
            Decimal equivalenceLot = 0;
            for (Lot__c lot : lots) {
                equivalenceLot += (lot.Parametre_de_lot__r.Equivalent_en_lots__c * lot.Quantite__c);
            }
            
            for (Palier__c palier: paliers) {
                System.debug('Minumum: ' + palier.Minimum__c + ' Maximum: ' + palier.Maximum__c + ' equivalence lot: ' + equivalenceLot);
                if (palier.Minimum__c <= equivalenceLot && equivalenceLot <= palier.Maximum__c) {
                    prestaPrice = palier.Prix_forfait__c +  (palier.Prix_par_lot__c * equivalenceLot);
                    deplacementPrice = palier.Prix_deplacement__c;
                    break;
                }
            }
        }
        
        else {
            System.debug('Cas du prix se calculant sur le lot');
            
            for (Lot__c lot : lots) {
                System.debug('Lot étudié: ' + lot.Parametre_de_lot__r);
                List<Palier__c> paliers = [Select Minimum__c, Maximum__c, Prix_forfait__c, Prix_par_lot__c, Prix_deplacement__c FROM Palier__c where Parametre_de_lot__r.Id =:lot.Parametre_de_lot__c];
                Decimal equivalenceLot = lot.Parametre_de_lot__r.Equivalent_en_lots__c * lot.Quantite__c;
                Decimal lotPrice = 0;
                for (Palier__c palier: paliers) {
                    if (palier.Minimum__c <= equivalenceLot && equivalenceLot <= palier.Maximum__c) {
                        lotPrice = palier.Prix_forfait__c +  (palier.Prix_par_lot__c * equivalenceLot);
                        deplacementPrice += palier.Prix_deplacement__c;
                        break;
                    }
                }
                prestaPrice += lotPrice;
            }
        }
        prestation.Prix_lots__c = prestaPrice;
        prestation.Prix_deplacement__c = deplacementPrice;
        Decimal passage = 1;
        if (Trigger.isInsert) {
            List<String> twoPassages = new List<String>{'2401', '2402', '2923', '2005', '2015', '2020', '2025', '2060', '2070'};
            if (twoPassages.indexOf(prestation.Libell__c.substring(0, 4)) != -1)
                passage = 2;
            /*else if (prestation.Libell__c.substring(0, 4) == '2410')
                passage = 0.33;*/
        }
        else
            passage = prestation.Nombre_de_passages_annuels__c;
        System.debug('Nombre de passage: ' + passage);
        prestation.Prix_Unitaire_HT__c = (prestaPrice * prestation.Coefficient__c * passage) + (deplacementPrice * prestation.Coefficient_deplacement__c * passage);
        update prestation;
    }
}