public interface IPDFService {
    PageReference getPageReference(String pageName);
    Blob getContentAsPDF(PageReference pageRef);
}