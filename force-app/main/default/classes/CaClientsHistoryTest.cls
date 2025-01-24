@isTest
private class CaClientsHistoryTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        // insert 10 accounts 
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account test '+i,
                RecordTypeId=System.Label.BS_nom_recordtype_ADB	, BS_Id_ClientAzur__c='54392'+i));
        }
        insert accounts;
        
    }
    @isTest static void test() {
        Test.startTest();
        CaClientsHistory caH = new CaClientsHistory();
        Id batchId = Database.executeBatch(caH);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from BS_CA_client_History__c]);
    }
    
    @isTest static void testScheduler () {
        // CRON expression: midnight on March 15. Because this is a test, 
        // job is supposed to execute immediately after Test.stopTest()
        String cronExpr = '0 0 0 15 12 ? 2024';
        String jobRunningTime = '2024-12-15 00:00:00';

       /* List<Account> lst_accounts = new List<Account>();
        for(Integer i = 0; i < 10; i++) {
            lst_accounts.add(New Account(
                Name = 'Test Account' + i,
                
            ));
        }
        insert lst_accounts;
		*/
        Test.startTest();
        ScheduleCaClientsHistory scch= new ScheduleCaClientsHistory();
        //String job = ScheduleCaClientsHistory.scheduleMe();
        String jobId = System.schedule('myJobTestJobName', cronExpr, scch);
        scch.execute(null);
        Test.stopTest();

        // Assert result: Is_Checked__c field must be set to true for all accounts
        Integer actualNumOfAccounts = [SELECT COUNT() FROM ACCOUNT];
        System.assertEquals(10, actualNumOfAccounts); // Asertion FAILED: 
        // Expected numberOfAccounts (=50), but actual is zero.
    }
}