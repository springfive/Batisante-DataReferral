public class PDFGeneratorTestUtil {
    private static PageReference mockPageReference;
    private static Blob mockPdfBlob;
    
    public static void setMockValues(PageReference pageRef, Blob pdfBlob) {
        mockPageReference = pageRef;
        mockPdfBlob = pdfBlob;
    }

    public static PageReference getPageReference(String pageName) {
        return mockPageReference;
    }
    
    public static Blob getContentAsPDF(PageReference pageRef) {
        return mockPdfBlob;
    }
}