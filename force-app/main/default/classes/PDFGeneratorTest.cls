@IsTest
private class PDFGeneratorTest {

    @IsTest
    static void testGeneratePDF_Success() {
        // Créer des données de test
        Account acc = new Account(Name = 'Test Account');
        acc.BS_Id_ClientAzur__c = '123456';
        insert acc;

        // Préparer les paramètres pour la méthode invocable
        PDFGenerator.RequestParams params = new PDFGenerator.RequestParams();
        params.pageName = 'Referencement_Techniciens';  // Nom de la page Visualforce valide
        params.recordIds = new List<Id>{ acc.Id };

        List<PDFGenerator.RequestParams> requestParamsList = new List<PDFGenerator.RequestParams>{ params };

        // Configurer le service PDF avec des mocks
        PDFGenerator.setPDFService(new MockPDFService());

        Test.startTest();
        PDFGenerator.generatePDF(requestParamsList);
        Test.stopTest();

        // Vérifier que le ContentVersion a bien été créé
        List<ContentVersion> contentVersions = [SELECT Title, FirstPublishLocationId FROM ContentVersion WHERE FirstPublishLocationId = :acc.Id];
        System.assertEquals(1, contentVersions.size());
        System.assertEquals('Referencement Techniciens', contentVersions[0].Title);
    }

@IsTest
    static void testGeneratePDF_PageNotFound() {
        // Créer des données de test
        Account acc = new Account(Name = 'Test Account');
        acc.BS_Id_ClientAzur__c = '123456';
        insert acc;

        // Préparer les paramètres pour la méthode invocable avec un nom de page incorrect
        PDFGenerator.RequestParams params = new PDFGenerator.RequestParams();
        params.pageName = 'Page_Introuvable';  // Nom de la page Visualforce invalide
        params.recordIds = new List<Id>{ acc.Id };

        List<PDFGenerator.RequestParams> requestParamsList = new List<PDFGenerator.RequestParams>{ params };

        // Appeler la méthode et vérifier que l'exception est levée
        Test.startTest();
        try {
            PDFGenerator.generatePDF(requestParamsList);
            System.assert(false, 'Une exception aurait dû être levée en raison de la page introuvable.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('La page Visualforce "Page_Introuvable" est introuvable.'));
        }
        Test.stopTest();
    }

    @IsTest
    static void testGeneratePDF_BlankPageName() {
        // Créer des données de test
        Account acc = new Account(Name = 'Test Account');
        acc.BS_Id_ClientAzur__c = '123456';
        insert acc;

        // Préparer les paramètres pour la méthode invocable avec un nom de page vide
        PDFGenerator.RequestParams params = new PDFGenerator.RequestParams();
        params.pageName = '';  // Nom de la page vide
        params.recordIds = new List<Id>{ acc.Id };

        List<PDFGenerator.RequestParams> requestParamsList = new List<PDFGenerator.RequestParams>{ params };

        // Appeler la méthode et vérifier que l'exception est levée
        Test.startTest();
        try {
            PDFGenerator.generatePDF(requestParamsList);
            System.assert(false, 'Une exception aurait dû être levée en raison du nom de page vide.');
        } catch (IllegalArgumentException e) {
            System.assert(e.getMessage().contains('Le nom de la page Visualforce est invalide.'));
        }
        Test.stopTest();
    }

    @IsTest
    static void testGeneratePDF_NoRecordIds() {
        // Préparer les paramètres pour la méthode invocable sans enregistrement
        PDFGenerator.RequestParams params = new PDFGenerator.RequestParams();
        params.pageName = 'Referencement_Techniciens';  // Nom de la page valide
        params.recordIds = new List<Id>();  // Liste vide d'ID d'enregistrements

        List<PDFGenerator.RequestParams> requestParamsList = new List<PDFGenerator.RequestParams>{ params };

        // Appeler la méthode invocable et vérifier qu'il n'y a pas d'insertion de ContentVersion
        Test.startTest();
        PDFGenerator.generatePDF(requestParamsList);
        Test.stopTest();

        // Vérifier qu'aucun ContentVersion n'a été créé
        List<ContentVersion> contentVersions = [SELECT Id FROM ContentVersion];
        System.assertEquals(0, contentVersions.size());
    }
    
    private class MockPDFService implements IPDFService {
        public PageReference getPageReference(String pageName) {
            return new PageReference('https://example.com');
        }

        public Blob getContentAsPDF(PageReference pageRef) {
            return Blob.valueOf('Fake PDF content');
        }
    }
}