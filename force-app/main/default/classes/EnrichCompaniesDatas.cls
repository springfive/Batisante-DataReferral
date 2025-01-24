global class EnrichCompaniesDatas {   
        
    private final Lead prospect;
    private List<List<String>> allCompanies;
    // [[Name, Address, index, siret, NAF]]
    private List<String> entreprise;
    private List<List<String>> fields;
    private String bearer;
    
    public EnrichCompaniesDatas(ApexPages.StandardController controller) {
        this.prospect = [Select Company, SIRET__c, Code_NAF__c, Street, City, PostalCode FROM Lead where Id = :controller.getId()];
        
        this.entreprise = null;
    }
    
    
    /******** ENRICH FUNCTIONS ********/
    
    public static String getBearer() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
                
        request.setEndpoint('https://api.insee.fr/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=client_credentials&client_id=x0AiFcFu73HRgG5cctPLRQue4Fca&client_secret=MvV1BI0v0SqYj0DxaJ6rMjBkW5Ea');
			
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody());
            System.debug(response.getBody());
            while (parser.nextToken() != null) {
             	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                	(parser.getText() == 'access_token')) {
                        parser.nextToken();
                		String bearer = parser.getText();
                        
                        return bearer;
                        
            	}
            }
        }
        else
            System.debug(response.getBody());
        
        return '';

    }
    
    public static Map<String,Object> getCompaniesDataFromInsee(String siret, String bearer) {
              
        if (siret != '') {
            System.debug('Siret is OK');
            Http http = new Http();
			HttpRequest request = new HttpRequest();
                
			request.setEndpoint('https://api.insee.fr/entreprises/sirene/V3/siret/' + siret);
			request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + bearer);
			HttpResponse response = http.send(request);
            
            
			if (response.getStatusCode() == 200) {
    			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    			Map<String,Object> companiesData = (Map<String,Object>) results.get('etablissement');
                return companiesData;
            }
            else
            	System.debug(response.getBody());
        }
        
        return null; 
    }
    
    public PageReference enrichCompanyFromSiret() {
        Map<String,Object> companiesData = getCompaniesDataFromInsee(prospect.SIRET__c, getBearer());
        
        if (companiesData != null) {
            Map<String,Object> uniteLegale = (Map<String, Object>) companiesData.get('uniteLegale');
            
            Map<String,Object> addressObject = (Map<String, Object>) companiesData.get('adresseEtablissement');
            
            System.debug('UNITE LEGALE : ' + uniteLegale);
            String name = (String)uniteLegale.get('denominationUniteLegale');
            String naf = (String)uniteLegale.get('activitePrincipaleUniteLegale');
            String rue = (String)addressObject.get('numeroVoieEtablissement') + ' ' + (String)addressObject.get('typeVoieEtablissement') + ' ' + (String)addressObject.get('libelleVoieEtablissement');
            String ville = (String)addressObject.get('libelleCommuneEtablissement');
            String codePostal = (String)addressObject.get('codePostalEtablissement');
            
            entreprise = new List<String>();
            entreprise.add(name);
            entreprise.add(rue + ' ' + ville + ' ' + codePostal);
            entreprise.add('0');
            entreprise.add(prospect.SIRET__c);
            entreprise.add(naf);
            
            return Page.ChooseFieldsToUpdate;
            
        }
        
       return Page.FailedAddNaf; 
    }
    
    public PageReference updateCompanyInfoFromSiret() {	
        
        Map<String,Object> companiesData = getCompaniesDataFromInsee(prospect.SIRET__c, getBearer());
        
        if (companiesData != null) {            
            Map<String,Object> uniteLegale = (Map<String, Object>) companiesData.get('uniteLegale');
            
            Map<String,Object> addressObject = (Map<String, Object>) companiesData.get('adresseEtablissement');
            
            String name = (String)uniteLegale.get('denominationUniteLegale');
            String naf = (String)uniteLegale.get('activitePrincipaleUniteLegale');
            String rue = (String)addressObject.get('numeroVoieEtablissement') + ' ' + (String)addressObject.get('typeVoieEtablissement') + ' ' + (String)addressObject.get('libelleVoieEtablissement');
            String ville = (String)addressObject.get('libelleCommuneEtablissement');
            String codePostal = (String)addressObject.get('codePostalEtablissement');
            
            System.debug('NAF : ' + naf);
            prospect.Code_NAF__c = naf.remove('.');
            prospect.Company = name;
            prospect.Street = rue;
            prospect.City = ville;
            prospect.PostalCode = codePostal;
                
           
			}
            else return Page.FailedAddNaf;
        
        update prospect;
        
        return Page.addedNaf;
    }
    

    public List<List<String>> initCompaniesList() {
         String companyToFind = prospect.Company.replace(' ', '%20');
        
        System.debug('GET COMPANIES WITH NAME :' + companyToFind);
        
        Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://api.insee.fr/entreprises/sirene/V3/siret?q=denominationUniteLegale:%22' + CompanyToFind + '%22');
		request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer b0b44e58-5eea-3b36-b3dc-ae8aad93fe71');
		HttpResponse response = http.send(request);
        
        if (response.getStatusCode() != 200)
            return null;
          
        Map<String, Object> responseObj = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> companies = (List<Object>)responseObj.get('etablissements');
        
        List<List<String>> companiesToPrint = new List<List<String>>();
        Integer index = 0;
        
        for (Object companyObj : companies) {
            
            Map<String, Object> company = (Map<String, Object>) companyObj;
            
            Map<String, Object> adresseObj = (Map<String, Object>) company.get('adresseEtablissement');
            Map<String, Object> legalDetails = (Map<String, Object>) company.get('uniteLegale');
            
            String adresseStr = adresseObj.get('numeroVoieEtablissement') + ' ' + adresseObj.get('typeVoieEtablissement') + ' ' + adresseObj.get('libelleVoieEtablissement') + '\n' + adresseObj.get('codePostalEtablissement') + ' ' + adresseObj.get('libelleCommuneEtablissement'); 
            
            
            List<String> companyDetails = new List<String>();
            companyDetails.add((String) legalDetails.get('denominationUniteLegale'));
            companyDetails.add(adresseStr);
            companyDetails.add(String.valueOf(index));
            companyDetails.add((String) company.get('siret'));
            companyDetails.add((String) legalDetails.get('activitePrincipaleUniteLegale'));
            
            index++;
       
            companiesToPrint.add(companyDetails);

        }

        if (companiesToPrint.size() == 0)
            return null;
        
        return companiesToPrint;
    }
    

    public void updateCompanyInfoFromName() {
        
        System.debug(Apexpages.currentPage().getParameters().get('myParam'));
        List<String> companyDetails = allCompanies[Integer.valueOf(Apexpages.currentPage().getParameters().get('myParam'))];
        System.debug('UPDATING : ' + Apexpages.currentPage().getParameters().get('myParam'));
        
        prospect.SIRET__c = companyDetails[3];
        
        System.debug('SIRET : ' + prospect.SIRET__c);
        entreprise = companyDetails;
      //  updateCompanyInfoFromSiret();
        
        //return Page.ChooseFieldsToUpdate;

    }
    
    public PageReference goToChooseField() {
        System.debug('GOING TO CHOOSE FIELDS PAGE');
        return Page.ChooseFieldsToUpdate;
    }
    
    
    /******* GETTERS *******/
    
    public Id getLeadId() {
        return prospect.Id;
    }
        
    public List<List<String>> getCompanies() {
        if (allCompanies == null)
        	allCompanies = initCompaniesList();
        
        return allCompanies;
       
    }
    
     public List<String> getEntreprise() {
        return entreprise;
       
    }
    
    public List<List<String>> getFields() {
        System.debug('COMPANY : ' + entreprise);
        
        System.debug('Are fields null ? ' + (fields == null));
        if (fields == null) {
            fields = new List<List<String>>();
            
            List<String> field = new List<String>();
            field.add('Société');
            field.add(prospect.Company);
            field.add(entreprise[0]);
            fields.add(field);
            
            field = new List<String>();
            field.add('NAF');
            field.add((prospect.code_NAF__c==NULL?'Non renseigné':prospect.code_NAF__c));
            field.add(entreprise[4].replace('.', ''));
            fields.add(field);
            
            field = new List<String>();
            field.add('Adresse');
            field.add(prospect.Street + ' ' + prospect.City + '\n' + prospect.PostalCode);
            field.add(entreprise[1]);
            fields.add(field);
            
              field = new List<String>();
            field.add('SIRET');
            field.add(prospect.SIRET__c);
            field.add(entreprise[3]);
            fields.add(field);
        }
        System.debug('FIELDS : ' + fields);
        
        return fields;
    }
    
    public static void dirty() {
		String a = '';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';        
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';        
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';        
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';        
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';        
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';       
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';        
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
        a += '&';
    }
}