@isTest
public class EnrichCompaniesDatasTest {

    @testSetup
    public static void setup(){
        Lead lead = new Lead();
        lead.RecordTypeId = '0127Z000001IssrQAC'; //FOR SANDBOX
        //lead.RecordTypeId = '0123X000000SP4OQAW'; //FOR PROD
        lead.Company = 'Test comp';
        lead.Fonction__c = 'DAF';
        lead.Status = 'Qualification';
        lead.Source__c = 'Appel entrant';
        lead.SIRET__c = '45132382800066';
		lead.LastName = 'TEST';
        
      // insert lead;
    }
    
    @isTest static void testCreateBearer(){
        //Lead lead = [Select Id, Siret__c FROM Lead WHERE NOT(Siret__c = null) LIMIT 1];
        //System.debug(lead);        
        
        Test.setMock(HttpCalloutMock.class, new EnrichMockCallOut());
        
        
       /* ApexPages.StandardController stdLead = new ApexPages.StandardController(lead);
        EnrichCompaniesDatas EnrichCompaniesDatas = new EnrichCompaniesDatas(stdLead);
        */
        
        String bearer = EnrichCompaniesDatas.getBearer();
        
        Test.setMock(HttpCalloutMock.class, new EnrichMockCallOut());
        
       	EnrichCompaniesDatas.getCompaniesDataFromInsee('45132382800066', bearer);
        
        EnrichCompaniesDatas.dirty();
   
    }
    
    @isTest static void testGetCompaniesDataFromInsee(){
        
    }
    
    
}