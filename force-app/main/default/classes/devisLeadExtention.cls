public class devisLeadExtention {
	  private final BS_Devis_from_Lead__c devis;
      private List<Prestation__c> prestas = new List<Prestation__c>();
 
    public devisLeadExtention(ApexPages.StandardController stdController) {
        this.devis = ((BS_Devis_from_Lead__c)stdController.getRecord());
        
    }
    
    public List<Prestation__c> getPrestas() {
        System.debug([SELECT name, option__c, Prix_Unitaire_HT__c, TVA__c, PrixUnitaireTTC__c, Devis_Pistes__c, Dictionnaire_Prestations__r.Description_courte__c, Dictionnaire_Prestations__r.Lien_vers_description__c FROM Prestation__c]);
        
        List<Prestation__c> prestas = [SELECT name, option__c, Prix_Unitaire_HT__c, TVA__c, PrixUnitaireTTC__c, Devis_Pistes__c, Dictionnaire_Prestations__r.Description_courte__c, Dictionnaire_Prestations__r.Lien_vers_description__c FROM Prestation__c WHERE Devis_pistes__c = :devis.Id ORDER BY PrixUnitaireTTC__c DESC];//new List<Prestation__c>();
        List<Prestation__c> sortedPrestas = new List<Prestation__c>();
        for (Prestation__c presta : prestas)
        {
            if (!presta.Option__c)
                sortedPrestas.add(presta);
        }
        
        for (Prestation__c presta : prestas)
        {
            if (presta.Option__c)
                sortedPrestas.add(presta);
        }
        return prestas;  
       
    }
    
    public Integer getPrestasSize() {
        return getPrestas().size();
    }
    
    public String getPrestaDico() {        
        Prestation__c[] prestas = [SELECT Libell__c FROM Prestation__c WHERE Devis_pistes__r.BS_N_Devis__c = :devis.BS_N_Devis__c];
        Dictionnaire_Prestations__c[] prestaDicos = [SELECT Name, Description_courte__c, Description_longue__c FROM Dictionnaire_Prestations__c];
        
        String rendered = '';
        
        
        for (Dictionnaire_Prestations__c prestaDico : prestaDicos) {
            for (Prestation__c presta : prestas)
            {
                if (presta.Libell__c.contains(prestaDico.Name.split(' ')[0])) {
            		rendered += '<b>' + prestaDico.Name + ':</b>\n';
            		rendered += '<p style="font-style: italic;">' + prestaDico.Description_courte__c.replace('\n', '<br />') + '</p>';
            		rendered += '<p>' + prestaDico.Description_longue__c.replace('\n', '<br />') + '</p>';
                }
            }
        }
        
        
        return rendered;
    }

    public Decimal getImageHeight() {
        switch on devis.P_le__c {
            when 'Sécurité incendie'{
                return 54;
            }
            when 'Maintenance réseaux' {
                return 48.5;
            }
            when 'Hygiène' {
                return 45.5;
            }
            when else {
                return 62;
            }
        }
    }
    
    public Boolean getrefClient() {
        return devis.Ref_Client__c ==NULL;
    }
}