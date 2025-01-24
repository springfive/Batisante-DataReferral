@IsTest
private class PDFGeneratorTestUtilTest {

    @IsTest
    static void testSetMockValues() {
        // Préparer les valeurs de mock
        PageReference mockPageRef = new PageReference('https://example.com');
        Blob mockPdfBlob = Blob.valueOf('Fake PDF content');

        // Appeler la méthode pour définir les valeurs simulées
        PDFGeneratorTestUtil.setMockValues(mockPageRef, mockPdfBlob);

        // Vérifier que les valeurs ont été correctement définies
        System.assertEquals(mockPageRef, PDFGeneratorTestUtil.getPageReference('AnyPageName'));
        System.assertEquals(mockPdfBlob, PDFGeneratorTestUtil.getContentAsPDF(mockPageRef));
    }
    
    @IsTest
    static void testGetPageReference() {
        // Préparer une page de référence fictive
        PageReference mockPageRef = new PageReference('https://example.com');
        
        // Définir la valeur de mock
        PDFGeneratorTestUtil.setMockValues(mockPageRef, Blob.valueOf('Fake PDF content'));
        
        // Vérifier que la méthode renvoie la bonne page de référence
        System.assertEquals(mockPageRef, PDFGeneratorTestUtil.getPageReference('AnyPageName'));
    }

    @IsTest
    static void testGetContentAsPDF() {
        // Préparer un contenu PDF fictif
        Blob mockPdfBlob = Blob.valueOf('Fake PDF content');
        
        // Définir la valeur de mock
        PDFGeneratorTestUtil.setMockValues(new PageReference('https://example.com'), mockPdfBlob);
        
        // Vérifier que la méthode renvoie le bon contenu PDF
        System.assertEquals(mockPdfBlob, PDFGeneratorTestUtil.getContentAsPDF(new PageReference('https://example.com')));
    }
}