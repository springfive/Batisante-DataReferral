public with sharing class saveDevisPDF {
	private final BS_Devis_from_Lead__c devis;
    
    
    public saveDevisPDF(ApexPages.StandardController stdController) {
        
        devis = [SELECT id, name, Email_Prospect__c, Contact_Soci_t__c, Adresse_Site__c, Devis_g_n_r__c, BS_N_Devis__c FROM BS_Devis_from_Lead__c WHERE Id = :((BS_Devis_from_Lead__c)stdController.getRecord()).Id];

            
    }
	

    public PageReference savePDF() {
        
        PageReference PDf =  Page.DevisPistePdf;//Replace attachmentPDf with the page you have rendered as PDF
        PDf.getParameters().put('Id',devis.id);
        PDf.setRedirect(true);
        Blob body;
        if(!Test.isRunningTest()){
            body=PDf.getContentAsPDF();
                }else{
                    body=Blob.valueOf('test');
                }
        ContentVersion versionToInsert = createContentVersion('Devis-'+ devis.BS_N_Devis__c+ '-' + devis.Name + '_' +  getNowDate() + '.pdf', body);
   	
        insert versionToInsert;
        
        versionToInsert = [SELECT Id, ContentDocumentId, versionData FROM ContentVersion WHERE Id = :versionToInsert.Id];
   
            
        ContentDocumentLink contentDocumentLink = createContentDocumentLink(versionToInsert.ContentDocumentId, devis.Id);
        insert contentDocumentLink;
		devis.Devis_g_n_r__c = true;
        update devis;
        return Page.addedFileMessage;
        
    }
    
    public Id getDevisId() {
        return devis.Id;
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

    public String getNowDate() {
        Datetime cDT = System.now();
        String LongDate = cDT.format('d-MM-yy');
        return LongDate;
      }
   
}