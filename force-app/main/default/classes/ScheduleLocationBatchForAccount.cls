public class ScheduleLocationBatchForAccount implements Schedulable {

    public void execute(SchedulableContext SC) {
        LocationBatchForAccount batchobject = new LocationBatchForAccount();
        Database.executeBatch(batchobject);
    }
        
}