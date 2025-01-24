public with sharing class CloneContentDocumentFlowHandler {
    
    @InvocableMethod(label='Clone Content Document' description='Clone a Content Document and link it to an Account')
    public static List<FlowOutput> cloneContentDocument(List<CloneContentDocumentRequest> requests) {
        List<FlowOutput> results = new List<FlowOutput>();
        for (CloneContentDocumentRequest request : requests) {
            FlowOutput output = new FlowOutput();
            try {
                // Obtenir l'original ContentDocument et ContentVersion
                ContentDocument originalDocument = [SELECT Id, LatestPublishedVersionId 
                                                    FROM ContentDocument 
                                                    WHERE Id = :request.contentDocumentId 
                                                    LIMIT 1];

                ContentVersion originalVersion = [SELECT Id, Title, VersionData, PathOnClient, ContentDocumentId
                                                  FROM ContentVersion
                                                  WHERE Id = :originalDocument.LatestPublishedVersionId 
                                                  LIMIT 1];

                // Cloner la ContentVersion
                ContentVersion newVersion = new ContentVersion();
                newVersion.Title = originalVersion.Title + ' v1'; // Ajouter un suffixe pour différencier
                newVersion.VersionData = originalVersion.VersionData; // Copier le contenu
                newVersion.PathOnClient = originalVersion.PathOnClient; // Utiliser le même chemin ou modifier si nécessaire
                newVersion.ContentDocumentId = originalDocument.Id; // Associer au même document

                // Insérer la nouvelle ContentVersion
                insert newVersion;

                // Associer le nouveau ContentDocument à l'Account
                ContentDocumentLink newLink = new ContentDocumentLink();
                newLink.LinkedEntityId = request.accountId;
                newLink.ContentDocumentId = newVersion.ContentDocumentId;
                newLink.ShareType = 'I';
                newLink.Visibility = 'AllUsers';
                insert newLink;

                output.status = 'SUCCESS';
                output.message = 'Document cloned and linked successfully.';
            } catch (Exception e) {
                output.status = 'ERROR';
                output.message = e.getMessage();
            }
            results.add(output);
        }
        return results;
    }

    public class CloneContentDocumentRequest {
        @InvocableVariable(required=true)
        public Id accountId;
        
        @InvocableVariable(required=true)
        public Id contentDocumentId;
    }

    public class FlowOutput {
        @InvocableVariable
        public String status;
        
        @InvocableVariable
        public String message;
    }
}