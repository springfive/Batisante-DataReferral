public with sharing class deletePropositionExt {
    
    private final BS_Devis_from_Lead__c prop;
    
    public deletePropositionExt(ApexPages.StandardController controller) {
        prop = (BS_Devis_from_Lead__c)[SELECT Id, Name, Etat2__c FROM BS_Devis_from_Lead__c WHERE Id = :(controller.getRecord().Id)];
    }
    
    public PageReference deleteProp() {
        
        System.debug(System.UserInfo.getProfileId());
        
        if (prop.Etat2__c == 'Transmis' || System.UserInfo.getProfileId() == '00e3X000002VJr7QAG' || System.UserInfo.getProfileId() == '00e3X000001BsaNQAS'){
          return Page.ConfrmDeleteProp;
        }
        
        return Page.NoDelete;
        
    }
    
    public PageReference DeletePropAfterConfirm() {
        delete prop;
        return Page.PropWellDeleted;
    }
    
    public String getEtat() {
        return prop.Etat2__c;
    }
    
    public Id getPropId() {
        return prop.Id;
    }
    
    public String getPropName() {
        return prop.Name;
    }
}