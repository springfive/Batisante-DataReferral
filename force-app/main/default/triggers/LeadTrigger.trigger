trigger LeadTrigger on Lead (before insert) {
    System.debug('processing Lead');
    
    List<Lead> leads = trigger.New;
    Integer leadsSize = leads.size();
    
    for(integer i=0; i<leadsSize; i++){
        if (leads[i].Company == null) {
            leads[i].Company = '[NON FOURNI]';
            
        }
    }
}