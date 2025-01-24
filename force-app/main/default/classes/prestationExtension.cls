public class prestationExtension {
    private final Prestation__c prestations;
    private final Map<String, Schema.SObjectField> fieldMap;
    List<Lot__c> paramsLots;
    List<Palier__c> paliers;
    
    public prestationExtension(ApexPages.StandardController stdController) {
        prestations = (Prestation__c)[SELECT Id, Name, Libell__c, Coefficient__c, Coefficient_deplacement__c, P_le__c,  Nombre_de_passages_annuels__c,Cout_de_l_installation__c, PrixUnitaireTTC__c, Prix_Unitaire_HT__c,
                                       Dictionnaire_Prestations__r.Name, Dictionnaire_Prestations__r.Titre_du_PDF__c, Dictionnaire_Prestations__r.Colonnes_Prestations_du_PDF__c, Dictionnaire_Prestations__r.Nombre_de_mois_contractuel__c, Dictionnaire_Prestations__r.PDF_Personnalis__c,
                                      Dictionnaire_Prestations__r.Titre_du_PDF_text__c, Dictionnaire_Prestations__r.Ajouter_Cadre_L_gal_l_objet_du_PDF__c,Dictionnaire_Prestations__r.Ajouter_Contexte_au_PDF_picklist__c, Dictionnaire_Prestations__r.Descriptif_de_la_prestation__c,Dictionnaire_Prestations__r.description_Pdf_richText_rest__c, Dictionnaire_Prestations__r.Exclusions__c, Dictionnaire_Prestations__r.Facturation_janvier__c,Dictionnaire_Prestations__r.Garanties_et_Avantages__c,Dictionnaire_Prestations__r.Prestataire__c, Dictionnaire_Prestations__r.Phrase_prix__c  
                                      FROM Prestation__c WHERE Id = :(stdcontroller.getRecord().Id)];
        paramsLots = [SELECT Parametre_de_lot__r.Name, Parametre_de_lot__r.Equivalent_en_lots__c, Parametre_de_lot__r.Intitul_PDF__c, Quantite__c, Parametre_de_lot__r.Dictionnaire_Prestations__r.Name, Prix_du_lot__c
                      FROM Lot__c WHERE Prestation__r.Id=:prestations.Id];
        paliers = [SELECT Prix_forfait__c, Prix_par_lot__c, Parametre_de_lot__r.Name, Parametre_de_lot__r.Dictionnaire_Prestations__r.Name FROM Palier__c];
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Prestation__c');
        fieldMap = leadSchema.getDescribe().fields.getMap();

    }
    
    public Id getPrestationId() {
        return prestations.Id;
    }
    
    //Initial checks + display of pdf
    public pageReference initCheck() {
        
    //Check if the warning page (see PrestationContratValidation)
        if (prestations.Name.substring(0, 5).trim() == '2864' && getLotEmpty() != '')
            return null;
   
    // Display the contract as a PDF if warning is useless 
        // False if a custom page is set in PDF_Personnalis__c , True if field is empty
        Boolean isPDFDefault = prestations.Dictionnaire_Prestations__r.PDF_Personnalis__c == ''
                                || prestations.Dictionnaire_Prestations__r.PDF_Personnalis__c == null; 
     
        String defaultPolePagePDFName = (prestations.P_le__c == 'Maintenance réseaux' || prestations.P_le__c =='Volt\'Air' ? 
                                             'prestationcontratvoltairpdf' : 
                                             (prestations.P_le__c == 'Diagnostic et contrôle' ? 
                                                'prestationcontratdeppdf' : 'prestationcontratpdf'));
           
        String pageReferenceURL = '/apex/' + (isPDFDefault ? defaultPolePagePDFName
                                                            : prestations.Dictionnaire_Prestations__r.PDF_Personnalis__c);
        
        // For Maintenance Réseau and Diagnotic et controle   
        Page.PrestationContratVoltairPdf.setRedirect(true);
        return new PageReference(pageReferenceURL);
  
    }
    
    /*
     * Retourne la liste des lots et de leur quantité sous forme de string, avec un retour à la ligne systématique
    */
    public String getLotsAsString() {
        String result = '';
        for (Lot__c lot : [Select Quantite__c, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id=:prestations.Id]) {
            result += lot.Parametre_de_lot__r.Name + ' : ' + lot.Quantite__c + '<br/>';
        }
        return result;
    }
    
    public String getLotsAsStringNoCage() {
        String result = '';
        for (Lot__c lot : [Select Quantite__c, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id=:prestations.Id]) {
            if (!lot.Parametre_de_lot__r.Name.contains('Cage'))
                result += lot.Parametre_de_lot__r.Name + ' : ' + lot.Quantite__c + '<br/>';
        }
        
        if(prestations.Dictionnaire_Prestations__r.Name.contains('5384')
           ||prestations.Dictionnaire_Prestations__r.Name.contains('5385')
          ||prestations.Dictionnaire_Prestations__r.Name.contains('5386')
          ||prestations.Dictionnaire_Prestations__r.Name.contains('5387')){
             result +='Date de réalisation du prochain CTO : <br/>Ascensoriste :<br/><br/>';  
             result+='<div style="display:flex;">'
                 +'<div>&nbsp;&nbsp;<i style=" width  : 10px!important;height : 6px !important;border: 1px solid; ">&nbsp;&nbsp;&nbsp;&nbsp;</i>  <i>*Je renonce expressément à l’exercice du droit de rétractation dont je bénéficie en vertu de l’article L 121-21 du Code de la <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Consommation.</i></div></div>'
      
                 +'<i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Merci de cocher cette case, à défaut nous respecterons'
                 +' un délai minimum de 14 jours pour exécuter votre commande </i>';
        }
        return result;
    
    }
    
     public String getCoefAsString() {
        String result = '';
        String label = fieldMap.get('Coefficient__c').getDescribe().getLabel();
        
         result += label + ' : ' + prestations.Coefficient__c;
        return result;
    }
    
     public String getDepCoefAsString() {
       String result = '';
        String label = fieldMap.get('Coefficient_deplacement__c').getDescribe().getLabel();
        
         result += label + ' : ' + prestations.Coefficient_deplacement__c;
        return result;
    }
    
    public pageReference confirmContract() {
        return Page.PrestationContratPdf;
    }
    
    public String getPDFPerso() {
        System.debug(prestations.Dictionnaire_Prestations__r.PDF_Personnalis__c);
        return prestations.Dictionnaire_Prestations__r.PDF_Personnalis__c;
    }
    
    // Si un seul lot est à 0, la fonction retourne le nom du paramètre de lot qui y est associé. Sinon, retourne ''. Cette fonction est utilisée dans la page 'PrestationContratValidation' pour avertir qu'un lot du contrat 2864 est à 0. Dans le cas de tous les contrats même le 2864, si tous les lots sont à 0 le contrat en lui-même ne s'affiche pas.
    public String getLotEmpty() {
        List<Lot__c> lots = [Select Quantite__c, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id=:prestations.Id];
        Decimal quantite = 0;
        String res = '';
        for (Lot__c lot: lots) {
            if (lot.Quantite__c == 0)
                res = lot.Parametre_de_lot__r.Name;
            else
                quantite += lot.Quantite__c;
        }
        if (quantite != 0)
            return res;
        return '';
    }
    
    public String getPole() {
        return [Select P_le__c from prestation__c where id=:prestations.id].P_le__c;
    }
    
    public String getPrestataire() {
        return prestations.Dictionnaire_Prestations__r.Prestataire__c;
    }
    
    public String getPhrasePrix() {
        return prestations.Dictionnaire_Prestations__r.Phrase_Prix__c;
    }
    
    public String getAvantages() {
        return prestations.Dictionnaire_Prestations__r.Garanties_et_Avantages__c;
    }
    
    public String getExclusions() {
        return prestations.Dictionnaire_Prestations__r.Exclusions__c;
    } 
    
    public String getChiffrageNameBlocage() {
        List<Lot__c> lots = [Select Quantite__c, Parametre_de_lot__r.Name, Parametre_de_lot__r.Equivalent_en_lots__c FROM Lot__c WHERE Prestation__r.Id=:prestations.Id AND Quantite__c = 0 ];
        String result = ''; //lots.size() == 0 ? '' : '"' + lots[0].Parametre_de_lot__r.Name + '"';
        Integer actualyUsedParams = 0;
        Integer usedParams = getNumberOfUsedParam();
        
        
        System.debug('Used Params : ' + usedParams);
        for (Integer i = 0; i < lots.size(); i++) {
            if (i == 0)
                result = '"';
            if (i != 0 && lots[i].Parametre_de_lot__r.Equivalent_en_lots__c > 0 && actualyUsedParams != usedParams - 1)
                result += ', "';
            
            if (lots[i].Parametre_de_lot__r.Equivalent_en_lots__c > 0) { 
                System.debug('Actually used : ' + lots[i].Parametre_de_lot__r.Name);
                if (actualyUsedParams == usedParams - 1)
                      result += getNumberOfUsedParam() > 1 ? ' et "' + lots[i].Parametre_de_lot__r.Name + '"' : lots[i].Parametre_de_lot__r.Name + '"';
                else
                    result += lots[i].Parametre_de_lot__r.Name + '"';
                actualyUsedParams++;
            }
            
        }
      
        return result;
    }
    
    private Integer getNumberOfUsedParam(){
         Integer nb = 0;
        for(Lot__c param : paramsLots) {
            if ( param.Parametre_de_lot__r.Equivalent_en_lots__c != 0)
                nb++;
        } 
        return nb;
    }
    
    public String getCompletePrestaName() {
        String name = [Select Name From Prestation__c where prestation__c.id=:prestations.id Limit 1].Name;
        System.debug(name);
        if (name.contains('2310'))
            return 'Désinsectisation préventive parties communes (avec extension de garantie aux parties privatives)';
        else if (name.contains('2810'))
            return 'Traitement biologique des canalisations d\'eaux usées (avec extension de garantie aux prestations hydrodynamiques)';
        else if (name.contains('2805'))
            return 'Traitement biologique des canalisations d\'eaux usées et Curage hydrodynamique des branchements horizontaux';
        else if (name.contains('2864'))
            return 'Curage général hyrodynamique des canalisations';
        else if (name.contains('2104') || name.contains('2150'))
            return 'Prévention rongeurs';
        else if (name.contains('1200'))
            return 'Vérification de l\'éclairage de sécurité par blocs autonomes (B.A.E.S.) - TR2N';
        else if (name.contains('1280'))
            return 'Vérification de l\'éclairage de sécurité par blocs autonomes (B.A.E.S.) - FNCP';
        else if (name.contains('1385'))
            return 'Vérification et mise en eau des colonnes sèches - FNC<br/>Contrôles visuels, essais hydrostatique annuel & hydrodynamique quinquennal';
        else if (name.contains('1933'))
            return 'Vérification de l\'éclairage de sécurité (B.A.E.S.), des extincteurs et des systèmes de mise à l\'abri des fumèes - FNC';
        else if (name.contains('29154')||name.contains('29253')||name.contains('29068')||name.contains('29206')||name.contains('29254')||name.contains('29052')||name.contains('29110'))
        {List<String> titre =name.split('-', 3);
        return titre[1];
        }
        return name.substring(7);
    }
    
    public String getContactName() {
        return [Select prestation__c.Devis_Pistes__r.Contact_Soci_t__c from Prestation__c where prestation__c.id=:prestations.id Limit 1].Devis_Pistes__r.Contact_Soci_t__c;
    }
    
    public Boolean getCanceled() {
        return [Select prestation__c.Annule_et_remplace__c FROM Prestation__c where prestation__c.id =:prestations.id limit 1].Annule_et_remplace__c;
    }
    
    public String getTitle() {
        return (prestations.Dictionnaire_Prestations__r.Titre_du_PDF__c==NULL?prestations.Dictionnaire_Prestations__r.Titre_du_PDF_text__c:prestations.Dictionnaire_Prestations__r.Titre_du_PDF__c);
    }
    
    public String getLegalText() {
        return prestations.Dictionnaire_Prestations__r.Ajouter_Cadre_L_gal_l_objet_du_PDF__c;
    }
    
    public Integer getNumberOfObjectArticle() {
        if (prestations.Dictionnaire_Prestations__r.Ajouter_Contexte_au_PDF_picklist__c == NULL)
            return 1;
        
        return 3;
        
    }
    
    public String getDescriptifPrestation() {
        return prestations.Dictionnaire_Prestations__r.Descriptif_de_la_prestation__c;
    }
    //Ajout PDF LOT 6
    public String getDescriptifPrestationText() {
        return prestations.Dictionnaire_Prestations__r.description_Pdf_richText_rest__c;
    }
    
    public String buildHTMLArrayRows(List<List<String>> values) {
        String rows = '';
        for (List<String> row : values) {
            rows += '<tr>';
            for (String value : row) {
                rows += '<td>' + value + '</td>';
            }
            
            rows += '</tr>';
            
        }
        return rows;
    }
    
    public String getValueOfColumn(String header) {
         switch on header {
             when 'PERIODICITE' {
                 return String.valueOf(prestations.Dictionnaire_Prestations__r.Nombre_de_mois_contractuel__c) + ' mois';
             }
             when 'GARANTIE' {
                 return 'NON';                    
             }
             when 'NB DE PASSAGES' {
                 return prestations.Nombre_de_passages_annuels__c + ' / annuel';
             }
             when 'DATE D\'EFFET' {
                 return '';
             }
             when else {
                 return null;
             }
         }
    }
    
    public String getNbMounthLabel(Decimal nbMonth) {
        if(nbMonth <= 12)
            return 'annuel';
        if (nbMonth <= 24) 
            return 'biennal';
        if (nbMonth <= 36)
            return 'triennal';
        
        return '';
        
    }
    
    public String getNbMounthLabelOfPrestation() {
         return getNbMounthLabel(prestations.Dictionnaire_Prestations__r.Nombre_de_mois_contractuel__c);
    }
    
    public String getPrestationArray(){
        
        List<String> columnHeaders = prestations.Dictionnaire_Prestations__r.Colonnes_Prestations_du_PDF__c.split(';');
      
        
        String prestationArray = '<table class="blue_array" width="100%">' +
                                 '<tr>' +
                                     '<th colspan="' + (columnHeaders.size()+1) + '">' +
                                        'Contrat ' + getNbMounthLabel(prestations.Dictionnaire_Prestations__r.Nombre_de_mois_contractuel__c) +
                                        ' - Selon votre demande' +
                                    '</th>' +
                                '</tr>';
  
        List<List<String>> prestationsArrayValues = new List<List<String>>();
        
        for (Lot__c lot : paramsLots) {
          
            List<String> lotValues = new List<String>();
            
            String lotName = (lot.Parametre_de_lot__r.Intitul_PDF__c==''|| lot.Parametre_de_lot__r.Intitul_PDF__c==NULL)?lot.Parametre_de_lot__r.Name:lot.Parametre_de_lot__r.Intitul_PDF__c;
                       
            lotValues.add('<bold>' + lotName + '<bold>');
            
            for (String header : columnHeaders) {
                lotValues.add(getValueOfColumn(header));
            }
            
            prestationsArrayValues.add(lotValues);
        }
        
        for (Integer i = 0; i < columnHeaders.size(); i++){
            columnHeaders[i] = '<bold>' + columnHeaders[i] + '</bold>';
        }
        columnHeaders.add(0, '<bold>PRESTATION</bold>');
        
        prestationsArrayValues.add(0, columnHeaders);
        
        prestationArray += buildHTMLArrayRows(prestationsArrayValues);
        
        prestationArray += '</table>';
        return prestationArray;
    }
    
    public String getInstallationArray() {
        String prestationArray = '<table class="blue_array" width="100%">' +
                                 '<tr>' +
                                     '<th>' +
                                        'PRESTATION' +
                                    '</th>' +
                                    '<th>' +
                                        'INSTALLATIONS' +
                                    '</th>' +
                                  '</tr>';
        List<List<String>> installationArrayValues = new List<List<String>>();
         for (Lot__c lot : paramsLots) {
          
            List<String> lotValues = new List<String>();
            
            String lotName = (lot.Parametre_de_lot__r.Intitul_PDF__c==''|| lot.Parametre_de_lot__r.Intitul_PDF__c==NULL)?lot.Parametre_de_lot__r.Name:lot.Parametre_de_lot__r.Intitul_PDF__c;
                       
            lotValues.add('<bold>' + lotName + '<bold>');
            
            lotValues.add(String.valueOf(lot.Quantite__c));
            installationArrayValues.add(lotValues);
         }
        
        prestationArray += buildHTMLArrayRows(installationArrayValues) + '</table>';
        
      return prestationArray;
        
    }
    
    public String getTarifsArray(){
        String arrayTitle = (prestations.Dictionnaire_Prestations__r.Name.startsWith('C014')?
                                ('Contrôle Elec PC d’un bâtiment' 
                                 + (prestations.Dictionnaire_Prestations__r.Name.startsWith('C0142')?' + Option Premium' : ''))
                                : prestations.Dictionnaire_Prestations__r.Name);
        
         String tarifArray = '<table class="blue_array" width="100%">' +
                                 '<tr>' +
                                     '<th>' +
                                        arrayTitle +
                                    '</th>' +
                                    '<th>' +
                                        'Unité' +
                                    '</th>' +
                                     '<th>' +
                                        'Quantité' +
                                    '</th>' +
                                    '<th>' +
                                        'Prix Unitaire H.T.' +
                                    '</th>' +
                                    '<th>' +
                                        'Montant Total H.T.' +
                                    '</th>' +
                                '</tr>';
        
         List<List<String>> tarifArrayValues = new List<List<String>>();
         for (Lot__c lot : paramsLots) {
          
            List<String> lotValues = new List<String>();
            String lotName = (lot.Parametre_de_lot__r.Intitul_PDF__c==''|| lot.Parametre_de_lot__r.Intitul_PDF__c==NULL)?lot.Parametre_de_lot__r.Name:lot.Parametre_de_lot__r.Intitul_PDF__c;
            Palier__c palier = findPalierOfLot(lot.Parametre_de_lot__r.Name, lot.Parametre_de_lot__r.Dictionnaire_Prestations__r.Name);           
            String prixUnitaire = ( palier.Prix_par_lot__c==0 || palier.Prix_forfait__c==0 ?
                                        String.valueOf(palier.Prix_forfait__c==0 ? palier.Prix_par_lot__c : palier.Prix_forfait__c)
                                        : (String.valueOf(palier.Prix_forfait__c) + ' + ' + String.valueOf(lot.Quantite__c) + 'x' + String.valueOf(palier.Prix_par_lot__c)));
             
            lotValues.add('<bold>' + lotName + '<bold>');
            lotValues.add(palier.Prix_forfait__c==0?'Unité':(palier.Prix_par_lot__c==0?'Forfait':'Forfait + Unité'));
            lotValues.add(String.valueOf(lot.Quantite__c));
            lotValues.add(prixUnitaire);
            lotValues.add(String.valueOf(palier.Prix_forfait__c + lot.Quantite__c*palier.Prix_par_lot__c));
            
            tarifArrayValues.add(lotValues);
         }
        
        tarifArray += buildHTMLArrayRows(tarifArrayValues) ;
        
         tarifArray += 
                            '<tr>' + 
                                '<td style="border:none;" colspan="3"></td>'+
                                '<th > Montant total H.T. </th>' +
                                '<th style=" font-size: 20px">' + prestations.Prix_Unitaire_HT__c +  ' €</th>' +
                            '</tr>' +
                            '<tr>' + 
                                '<td style="border:none;" colspan="3"></td>'+
                                '<th > T.V.A. 20 % </th>' +
                                '<th >' + String.ValueOf(prestations.Prix_Unitaire_HT__c*20/100) +  ' €</th>' +
                            '</tr>' +
             
                            '<tr>' + 
                                '<td style="border:none;" colspan="3"></td>'+
                                '<th > Montant total T.T.C </th>' +
                                '<th style=" font-size: 20px">' + prestations.PrixUnitaireTTC__c +  ' €</th>' +
                            '</tr>' +
                        '</table>';
        return tarifArray;
    }
    
    public Palier__c findPalierOfLot(String nameOfLot,String nameOfPresta) {
        for (Palier__c palier : paliers ) {
            if (palier.Parametre_de_lot__r.Dictionnaire_Prestations__r.Name == nameOfPresta && palier.Parametre_de_lot__r.Name == nameOfLot)
                return palier;
        }
        return null;
    }
    public String getAttestationPoliceSize() {
        String attestationType = getAttestationType();
        System.debug(attestationType);
        if (attestationType == 'Loi Chatel')
            return 'font-size: 13px;';
        else
            return 'font-size: 15px;';
    }
    
    public String getAttestationType() {
        return [Select prestation__c.Type_resiliation__c FROM Prestation__c where prestation__c.id =:prestations.id limit 1].Type_resiliation__c;
    }
    
    public Boolean getTvaAttestation() {
        return [Select Attestation_TVA__c FROM Prestation__c where Id=:prestations.id Limit 1].Attestation_TVA__c;
    }
    
    public String getCompagnyName() {
        return [Select Devis_Pistes__r.Nom_Soci_t__c From prestation__c where id=:prestations.id Limit 1].Devis_Pistes__r.Nom_Soci_t__c;
    }
    
    public List<String> splitCity(String adress) {
        List<String> result = new List<String>();
        if (adress != '' && adress != null) {
            result.add(adress.split(' [0-9]{5}(.)*')[0]);
            result.add(adress.substring(result[0].length()));
        }
        return result;
    }
    
    public Boolean getSiteAdresseAvailable() {
        return [Select Devis_Pistes__r.Adresse_Site__c From prestation__c where id=:prestations.id].size() != 0;
    }
    
    public Boolean getCompagnyAdressAvailable() {
        return [Select Devis_Pistes__r.Adresse_Prospect__c From prestation__c where id=:prestations.id].size() != 0;
    }
    
    public String getCompagnyAdress() {
        Address compagnyAdd = [Select Devis_Pistes__r.Emplacement__r.BS_Client__r.ShippingAddress from Prestation__c where id=:prestations.id LIMIT 1].Devis_Pistes__r.Emplacement__r.BS_Client__r.ShippingAddress;
        return compagnyAdd.getStreet() + '<br/><br/>' + compagnyAdd.getPostalCode() + ' ' + compagnyAdd.getCity();
    }
    
    public String getSiteAdress() {
        String adress = [Select Devis_Pistes__r.Adresse_Site__c From prestation__c where id=:prestations.id Limit 1].Devis_Pistes__r.Adresse_Site__c;
        return adress.split(' [0-9]{5}(.)*')[0] + '<br/>' + adress.substring(adress.split(' [0-9]{5}(.)*')[0].length());
    }
    
    public List<String> getCompetitorAdress() {
        return splitCity([Select Adresse_confrere__c from prestation__c where id=:prestations.id Limit 1].Adresse_confrere__c);
    }
    
    public String getCompetitorName() {
        return [Select Confrere__c from prestation__c where id=:prestations.id Limit 1].Confrere__c;
    }
    
    public String getCodeDict() {
        return [Select prestation__c.Name from Prestation__c where prestation__c.id=:prestations.id].Name.substring(0, 5).trim();
    }
    public String getCodeDictNum() {
        return [Select Dictionnaire_Prestations__r.Name from Prestation__c where prestation__c.id=:prestations.id].Dictionnaire_Prestations__r.Name.substring(0, 5).trim();
    }
    
    public String getPrestaProposition() {
        return [Select prestation__c.Devis_Pistes__r.BS_N_Devis__c from Prestation__c where prestation__c.id=:prestations.id limit 1].Devis_Pistes__r.BS_N_Devis__c;
    }
    
    public Decimal getCodePresta() {
        String code = [Select prestation__c.Name from Prestation__c where prestation__c.id=:prestations.id].Name.substring(0, 5).trim();
        return Decimal.valueOf(code);
    }
    
    public String getPassageFrequencyName() {
        Decimal frequency = getPassageFrequency();
        return getPrimeName(frequency);
    }
    
    public String getPrimeName(Decimal frequency) {
        if (frequency == 1)
            return 'annuelle';
        else if (frequency == 2)
            return 'semestrielle';
        else if (frequency == 3)
            return 'quadrimestrielle';
        else if (frequency == 4)
            return 'trimestrielle';
        else if (frequency == 6)
            return 'bimestrielle';
        else if (frequency == 12)
            return 'mensuelle';
        else
            return 'de passage';
    }    
    
    public Decimal getPassageFrequency() {
        return [Select Nombre_de_passages_annuels__c FROM Prestation__c where Id=:prestations.Id AND Nombre_de_passages_annuels__c!=NULL].Nombre_de_passages_annuels__c.setScale(0);
    }
    
    public Decimal getTotalPrice() {
        return [Select Prix_Unitaire_HT__c FROM Prestation__c where Id=:prestations.Id limit 1].Prix_Unitaire_HT__c.setScale(2);
    }
    
    public Decimal getTotalPriceTTC() {
        return prestations.PrixUnitaireTTC__c;
    }
    
    public Decimal getInstallPrice() {
        return prestations.Cout_de_l_installation__c;
    }
    
    public Decimal getDeplacementPrice() {
        Prestation__c p = [Select Coefficient_deplacement__c, Prix_deplacement__c FROM Prestation__c where Id=:prestations.Id Limit 1];
        Decimal res = p.Coefficient_deplacement__c * p.Prix_deplacement__c;
        return res.setScale(2);
    }
    
    public Decimal getLotsPrice() {
        return getTotalPrice() - getDeplacementPrice();
    }
    
    public String getPoliceSize() {
        String result = 'font-size: ';
        if (prestations.Libell__c.contains('2105')) {
            result += '9px;';
        }
        else if (prestations.Libell__c.contains('2104') || prestations.Libell__c.contains('2150') || prestations.Libell__c.contains('1385')) {
            result += '10px';
        }
        else if (prestations.Libell__c.contains('2103') || prestations.Libell__c.contains('2223') || prestations.Libell__c.contains('2035')) {
            result += '11px';
        }
        else {
            result += '12px';
        }
        return result;
    }
    
    public Decimal getPassagePrice() {
        Prestation__c presta = [Select Prix_lots__c, Coefficient__c from prestation__c where Id=:prestations.Id];
        Decimal result = presta == null ? 0 : presta.Prix_lots__c * presta.Coefficient__c;
        return result.setScale(2);
    }

    public String getShortDict() {
        String name = [Select Dictionnaire_Prestations__r.Name From Prestation__c WHERE Id=:prestations.Id].Dictionnaire_Prestations__r.Name;
        return name.substring(name.indexOf('-') + 2);
    }
    
    public Decimal getLotsQuantity() {
        List<Lot__c> lots = [Select Quantite__c, Parametre_de_lot__r.Equivalent_en_lots__c, Parametre_de_lot__r.Obligatoire__c FROM Lot__c WHERE Prestation__r.Id=:prestations.Id]; 
        Decimal result = 0;
        for (Lot__c lot: lots) {
            if (lot.Parametre_de_lot__r.Equivalent_en_lots__c > 0)
                result += lot.Quantite__c;
            if (lot.Parametre_de_lot__r.Obligatoire__c && lot.Quantite__c == 0)
                return 0;
        }
        return result.setScale(0);
    }
    
    public String getFirstLetters(String myString) {
        String finalWord = '';
        List<String> words = myString.split(' ');
        for (String word: words) {
            String res = word.substring(0, 1);
            if (res != '(' && res != ')')
                finalWord += word.substring(0, 1);
        }
        return finalWord;
    }
    
    public List<Decimal> getLotsQuantityOrderedByName() {
        List<Lot__c> lots = [Select Quantite__c, Parametre_de_lot__r.Id, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id=:prestations.Id ORDER BY Parametre_de_lot__r.Name];
        List<Decimal> lotsQuantity = new List<Decimal>();
        for (Lot__c lot : lots)
            lotsQuantity.add(lot.Quantite__c);
        return lotsQuantity;
    }
    
    /*Contrat 2105
    *Récupération et envoi du nombre de lots sous forme de tableau.
    *results[0] : Cage
    *results[1] : Autres lots
    */
    public List<Decimal> getLotsQuantityDetails() { // Contrat 2105
        List<Lot__c> lots = [Select Quantite__c, Parametre_de_lot__r.Id, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id=:prestations.Id];
        List<Decimal> results = new List<Decimal>{0, 0};
        for (Lot__c lot: lots) {
            if (lot.Parametre_de_lot__r.Name.contains('Cage')) {
                results[0] += lot.Quantite__c;
            }
            else {
                results[1] += lot.Quantite__c;
            }
        }
        return results;
    }
    
    //Contrats Hygiène détaillant les parties communes et privatives
    public String getLotsDetailPCPP() {
        String prestaName = getShortDict();
        List<Lot__c> lots = [Select Quantite__c, Parametre_de_lot__r.Id, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id=:prestations.Id];
        String result = 'Parties communes';
        List<String> lotString = new List<String>();
        List<Decimal> lotDecimal = new List<Decimal>();
        for (Lot__c lot: lots) {
            if (lot.Parametre_de_lot__r.Name == 'Cage')
                continue;
            String firstLetters = getFirstLetters(lot.Parametre_de_lot__r.Name);
            Integer index = lotString.indexOf(firstLetters);
            if (index >= 0) {
               lotDecimal[index] += lot.Quantite__c;
            }
            else {
                lotString.add(firstLetters);
                lotDecimal.add(lot.Quantite__c);
            }
        }
        for (Integer i = 0; i < lotString.size(); i++) {
            if (lotDecimal[i] > 0) {
                result += ' + ' + lotDecimal[i] + lotString[i];
            }
        }
        return result;
    }
    
    public Decimal getCageQuantity() {
       return [Select Quantite__c, Parametre_de_lot__r.Id, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id=:prestations.Id and Parametre_de_lot__r.Name=:'Cage' LIMIT 1].Quantite__c;
    }
    
    /*
     * Récupère les informations nécessaires à tous les contrats.
     * Les informations renvoyées sous forme de liste sont affichées sous le nom des contrats
    */
    public List<String> getDevisInfos() {
        List<Prestation__c> devisInfos = [Select Devis_Pistes__r.Ref_Client__c, Devis_Pistes__r.Adresse_Site__c, Devis_Pistes__r.Nom_Soci_t__c, Devis_Pistes__r.Adresse_Prospect__c, Devis_Pistes__r.Emplacement__c From Prestation__c WHERE Id=:prestations.Id];
        List<Schema.Location> sites = [Select BS_Code_Site__c, BS_Adresse_site__c, BS_Ref_Client__c, BS_Client__r.Name, BS_Client__r.BillingAddress From Location where Id=:devisInfos[0].Devis_Pistes__r.Emplacement__c];
        String[] res = new List<String>();
        if (devisInfos == null || sites == null || devisInfos.size() == 0)
            return res;
        Prestation__c devisInfo = devisInfos[0];
        Schema.Location site = null;
        if (sites.size() > 0)
            site = sites[0];
        //Référence client
        String refClient = '';
        if (site != null && Site.BS_Ref_Client__c != null)
            refClient = Site.BS_Ref_Client__c;
        if (devisInfo.Devis_Pistes__r.Ref_Client__c != null)
            refClient += ' / ' + devisInfo.Devis_Pistes__r.Ref_Client__c;
        res.add(refClient);
        //Concernant l'immeuble
        if (devisInfo.Devis_Pistes__r.Adresse_Site__c != null)
            res.add(devisInfo.Devis_Pistes__r.Adresse_Site__c);
        else if (site != null)
            res.add(Site.BS_Adresse_site__c);
        //Représenté par
        if (devisInfo.Devis_Pistes__r.Nom_Soci_t__c != null && devisInfo.Devis_Pistes__r.Nom_Soci_t__c != '[non fourni]')
            res.add(devisInfo.Devis_Pistes__r.Nom_Soci_t__c);
        else if (site != null)
            res.add(Site.BS_Client__r.Name);
        //Représenté par / adresse
        if (devisInfo.Devis_Pistes__r.Adresse_Prospect__c != null && devisInfo.Devis_Pistes__r.Adresse_Prospect__c != '')
            res.add(devisInfo.Devis_Pistes__r.Adresse_Prospect__c);
        //Code immeuble
        if (site != null && res.size() == 4)
            res.add(site.BS_Code_Site__c);
        System.debug('Nb d\'infos: ' + res.size());
        System.debug('Infos sur le devis: ' + res);
        return res;
    }
    
    /*
     * En se basant sur la fonction getDevisInfos, cette fonction détermine si des informations requises sont manquantes.
     * Dans ce cas, le contrat n'est pas affiché, mais un message demandant à l'utilisateur de compléter les informations.
    */
    public String getMissingInfos() {
        List<String> devisInfos = getDevisInfos();
        String result = '';
        System.debug(devisInfos);
        System.debug('Devis infos size: ' + devisInfos.size());
        if (devisInfos.size() < 4 || devisInfos.contains(null) || devisInfos.contains('')) {
            result = 'Merci de veillez à ajouter les informations suivantes avant de générer ce document : Référence client, Adresse Site, Société et Adresse (cf proposition ou site relié à la proposition)';
        }
        return result;
    }
    
    
    /*
     * Le contrat 2410 a été désactivé à la demande du client.
     * La fonction ci-dessous permettait de récupérer les informations nécessaires à l'affichage de ce contrat.
     * Elle a été commenté et non supprimée au cas où le client viendrait à changer d'avis à nouveaux
    */
    /* public List<String> getPrestations2410Infos() {
        //Récupération et calcul des informations requises pour l'affichage du contrat
        Map<String, Decimal> details = new Map<String, Decimal>();
        List<Prestation__c> presta = [Select Devis_Pistes__c from Prestation__c where id=:prestations.id];
        List<Prestation__c> linkedPresta = [Select Prix_Unitaire_HT__c, Nombre_de_passages_annuels__c from Prestation__c where Libell__c =: '2402 - Désinfection nettoyage des colonnes vide-ordures' and Devis_Pistes__c =: presta[0].Devis_Pistes__c];
        if (linkedPresta.size() != 0) {
            Prestation__c prestaVO = linkedPresta[0];
            Set<Id> records = new Set<Id>{prestaVO.Id, prestations.id};
            List<Lot__c> lots = [Select Quantite__c, Parametre_de_lot__r.Id, Parametre_de_lot__r.Name FROM Lot__c WHERE Prestation__r.Id in :records];
            details.put('Prix', prestaVO.Prix_Unitaire_HT__c.setScale(2));
            details.put('Nombre de passages', prestaVO.Nombre_de_passages_annuels__c.setScale(0));
            for (Lot__c lot : lots) {
                system.debug(lot.Parametre_de_lot__r.Name);
                details.put(lot.Parametre_de_lot__r.Name, lot.Quantite__c);
            }
        }
        Decimal passage = details.get('Prix') / details.get('Nombre de passages');
        
        //Renvoie les informations nécessaires sous forme de tableau pour pemettre de facilement retrouver les informations adéquates dans la Visualforce page pour l'affichage du contrat
        List<String> infos = new List<String>{
            getPrimeName(details.get('Nombre de passages')),
            String.valueOf(details.get('Prix')),
            String.valueOf(details.get('Nombre de passages')),
            String.valueOf(details.get('Colonne')),
            String.valueOf(details.get('Niveau')),
            String.valueOf(passage),
            String.valueOf(details.get('Local Vide-Ordures'))
        };
        return infos;
    }*/
    
    /*
     * Cette fonction était utilisée avant la désactivation du contrat 2410.
     * Elle permettait de vérifier que le contrat 2410 était bien associé à un contrat 2402.
    */
    /*
    public boolean getCorrectPrestationOption() {
        if (prestations.Libell__c.contains('2410')) {
            List<Prestation__c> presta = [Select Devis_Pistes__c from Prestation__c where id=:prestations.id];
            List<Prestation__c> linkedPresta = [Select Id from Prestation__c where Libell__c =: '2402 - Désinfection nettoyage des colonnes vide-ordures' and Devis_Pistes__c =: presta[0].Devis_Pistes__c];
            System.debug('Taille de la liste des prestation 2402 sur le même contrat : ' + linkedPresta.size());
            return linkedPresta.size() == 1;
        }
        System.debug('returned true');
        return true;
    }*/
}