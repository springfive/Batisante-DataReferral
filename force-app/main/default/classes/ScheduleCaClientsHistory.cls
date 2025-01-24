global class ScheduleCaClientsHistory implements Schedulable{

    public static String sched = '0 0 22 01 01 ?';  //Every Year 01 Jan at 22:00 => 0 0 22 01 01
    
    global static String scheduleMe() {
        ScheduleCaClientsHistory SC = new ScheduleCaClientsHistory(); 
        return System.schedule('Historique Clients', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        CaClientsHistory b = new CaClientsHistory();
        ID batchprocessid = Database.executeBatch(b,200);           
    }
}