@IsTest
public class CloneContentDocumentFlowHandlerTest {

    @IsTest
    static void testCloneContentDocument() {
        // Création d'un Account de test
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.BS_Id_ClientAzur__c = '1234567';
        insert testAccount;

        // Création d'une version de contenu de test
        ContentVersion testVersion = new ContentVersion(
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test file content'), // Contenu du fichier en base64
            PathOnClient = 'TestFile.txt'
        );
        insert testVersion;

        // Requête pour obtenir ContentDocumentId directement depuis la ContentVersion insérée
        testVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :testVersion.Id LIMIT 1];
		system.debug('testVersion init  '+testVersion);
        // Préparer la requête pour la méthode invocable
        CloneContentDocumentFlowHandler.CloneContentDocumentRequest request = new CloneContentDocumentFlowHandler.CloneContentDocumentRequest();
        request.accountId = testAccount.Id;
        request.contentDocumentId = testVersion.ContentDocumentId;

        List<CloneContentDocumentFlowHandler.CloneContentDocumentRequest> requests = new List<CloneContentDocumentFlowHandler.CloneContentDocumentRequest>{request};

        // Appeler la méthode invocable
        Test.startTest();
        List<CloneContentDocumentFlowHandler.FlowOutput> results = CloneContentDocumentFlowHandler.cloneContentDocument(requests);
        Test.stopTest();

        // Vérifier le résultat de la méthode invocable
        System.assertEquals('SUCCESS', results[0].status, 'L\'opération devrait réussir.');
    }
}