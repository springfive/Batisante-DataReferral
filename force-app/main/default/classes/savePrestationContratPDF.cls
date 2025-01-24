public with sharing class savePrestationContratPDF {
    public final Prestation__c prestations;
    
    public savePrestationContratPDF(ApexPages.StandardController stdController) {
        prestations = [Select Id, Name, P_le__c, Prix_Unitaire_HT__c, Devis_Pistes__c, Devis_Pistes__r.BS_N_Devis__c, Devis_Pistes__r.Emplacement__r.Name FROM Prestation__c WHERE Id = :((Prestation__c)stdController.getRecord()).Id];
    }
    
    public PageReference saveContratPDF() {
        PageReference Pdf = (prestations.P_le__c == 'Maintenance réseaux'?Page.PrestationContratVoltairPdf:(prestations.P_le__c == 'Diagnostic et contrôle' ? Page.PrestationContratDEPPdf : Page.PrestationContratPdf));
        String nameSite = prestations.Devis_Pistes__r.Emplacement__r.Name != null ? prestations.Devis_Pistes__r.Emplacement__r.Name : prestations.Devis_Pistes__r.BS_N_Devis__c;
        String name = 'Contrat - ' + nameSite + ' - ' + prestations.name.substring(0, 4) + '.pdf';
        
        return savePDF(pdf, name);
    }
    
    public PageReference saveContratTVAPDF() {
        PageReference Pdf = Page.PrestationContratAttestationTVAPDF;
        String nameSite = prestations.Devis_Pistes__r.Emplacement__r.Name != null ? prestations.Devis_Pistes__r.Emplacement__r.Name : prestations.Devis_Pistes__r.BS_N_Devis__c;
        String name = 'TVA - ' + nameSite + ' - ' + prestations.name.substring(0, 4) + '.pdf';
        return savePDF(pdf, name);
    }
    
    public PageReference saveContratResiliationPDF() {
        PageReference Pdf = Page.PrestationContratResiliationPDF;
        String nameSite = prestations.Devis_Pistes__r.Emplacement__r.Name != null ? prestations.Devis_Pistes__r.Emplacement__r.Name : prestations.Devis_Pistes__r.BS_N_Devis__c;
        String name = 'Résiliation - ' + nameSite + ' - ' + prestations.name.substring(0, 4) + '.pdf';
        return savePDF(pdf, name);
    }
    
    public PageReference savePDF(PageReference Pdf, String name) {
        Pdf.getParameters().put('Id',prestations.id);
        Pdf.setRedirect(true);
        Blob body;
        if(!Test.isRunningTest()) {
            body=Pdf.getContentAsPDF();
        }
        else {
            body=Blob.valueOf('test');
        }
        ContentVersion versionToInsert = createContentVersion(name, body);
        
        insert versionToInsert;
        
        versionToInsert = [SELECT Id, ContentDocumentId, versionData FROM ContentVersion WHERE Id = :versionToInsert.Id];
        ContentDocumentLink contentDocumentLink = createContentDocumentLink(versionToInsert.ContentDocumentId, prestations.Id);
        
        insert contentDocumentLink;
        return Page.addedPrestationContratMessage;
    }
    
    public ContentVersion createContentVersion(String name, Blob body) {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
        contentVersion.PathOnClient = name;
        contentVersion.Title = name;
        contentVersion.VersionData = body; 
        return contentVersion;
    }
    
    private ContentDocumentLink createContentDocumentLink(Id contentDocumentId, Id parentId){
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = contentDocumentId;
        contentDocumentLink.LinkedEntityId = parentId;
        contentDocumentLink.ShareType = 'I'; // Inferred permission
        contentDocumentLink.Visibility = 'AllUsers';
        return contentDocumentLink;
    }
    
    public Id getContratId() {
        return prestations.Id;
    }

    public String getNowDate() {
        Datetime cDT = System.now();
        String LongDate = cDT.format('d-MM-yy');
        return LongDate;
      }
}