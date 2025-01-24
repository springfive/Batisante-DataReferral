@isTest(SeeAllData = true)
public class testSchedulerGestionnaireContrat {
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';
    static testMethod void myTestMethod() { 
        Contract m=new Contract();
       // m.accountID='001MU000002aXVZYA2';
       // m.BS_N_contrat__c='12345';
        //insert m;
    Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new schedulerGestionnaireContrat());
        Test.stopTest();}

}