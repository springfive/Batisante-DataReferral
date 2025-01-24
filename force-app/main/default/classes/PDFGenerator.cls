public with sharing class PDFGenerator {

    private static IPDFService pdfService = new DefaultPDFService();

    @InvocableMethod
    public static void generatePDF(List<RequestParams> requestParamsList) {
        List<ContentVersion> contentVersionList = new List<ContentVersion>();

        for (RequestParams requestParams : requestParamsList) {
            // Vérifier que la page existe
            if (String.isBlank(requestParams.pageName)) {
                throw new IllegalArgumentException('Le nom de la page Visualforce est invalide.');
            }

            // Générer un titre personnalisé en fonction du nom de la page
            String pdfTitle = generateTitle(requestParams.pageName);

            for (Id recordId : requestParams.recordIds) {
                // Obtenir la référence à la page Visualforce spécifiée
                PageReference pdfPage = pdfService.getPageReference(requestParams.pageName);
                if (pdfPage == null) {
                    throw new IllegalArgumentException('La page Visualforce "' + requestParams.pageName + '" est introuvable.');
                }

                // Passer l'ID de l'enregistrement à la page
                pdfPage.getParameters().put('id', recordId);

                // Récupérer le contenu de la page en PDF
                Blob pdfBlob = pdfService.getContentAsPDF(pdfPage);

                // Créer un ContentVersion pour stocker le fichier
                ContentVersion cv = new ContentVersion();
                cv.Title = pdfTitle;
                cv.PathOnClient = pdfTitle + '.pdf';
                cv.VersionData = pdfBlob;
                cv.FirstPublishLocationId = recordId;  // Lien avec l'enregistrement
                cv.IsMajorVersion = true;

                contentVersionList.add(cv);
            }
        }

        if (!contentVersionList.isEmpty()) {
            insert contentVersionList;
        }
    }

    // Méthode pour générer un titre basé sur le nom de la page
    public static String generateTitle(String pageName) {
        switch on pageName {
            when 'Referencement_Techniciens' {
                return 'Referencement Techniciens';
            }
            When Else {
                return 'Document Généré';
            }
        }
    }

    // Méthode pour configurer le service PDF
    public static void setPDFService(IPDFService service) {
        pdfService = service;
    }

    // Classe par défaut pour le service PDF
    private class DefaultPDFService implements IPDFService {
        public PageReference getPageReference(String pageName) {
            if (pageName == 'Referencement_Techniciens') {
                return Page.Referencement_Techniciens;
            }
            return null;
        }

        public Blob getContentAsPDF(PageReference pageRef) {
            return pageRef.getContentAsPDF();
        }
    }

    // Classe interne pour recevoir les paramètres de la méthode invocable
    public class RequestParams {
        @InvocableVariable(required=true)
        public String pageName;  // Nom de la page Visualforce à générer

        @InvocableVariable(required=true)
        public List<Id> recordIds;  // Liste des IDs d'enregistrements auxquels le PDF doit être attaché
    }
}