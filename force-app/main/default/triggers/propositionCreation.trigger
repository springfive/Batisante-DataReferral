trigger propositionCreation on BS_Devis_from_Lead__c (before insert, before update) {
    for (BS_Devis_from_Lead__c prop : Trigger.new) {
        if (prop.Contact_Soci_t__c == null || prop.Contact_Soci_t__c == '' || prop.Contact_Soci_t__c == 'A REMPLIR') {
            if (Trigger.isUpdate && Trigger.oldMap.get(prop.Id).Emplacement__c == Trigger.newMap.get(prop.Id).Emplacement__c) {
                continue;
            }
            System.debug(prop.Nom_Soci_t__c);
            List<Account> accounts = new List<Account>();
            if (prop.Emplacement__c != null) {
                Schema.Location site = [Select id, BS_Client__c from Location where id=:prop.Emplacement__c LIMIT 1];
            	accounts = [Select id, Name from Account where id =: site.BS_Client__c];
            }
            System.debug('Sociétés trouvées: ' + accounts.size());
            if (accounts.size() > 0) {
                List<Contact> contacts = [Select id, Name, Salutation, Phone, Email from Contact where RecordType.Name=:'Contact Client' and BS_Principal__c=True and AccountId =:accounts[0].Id and Title=:'Gestionnaire'];
                if (contacts.size() > 0) {
                    System.debug('Contacts trouvés: ' + contacts.size());
                	prop.Contact_Soci_t__c = contacts[0].Salutation + ' ' + contacts[0].Name;
                    prop.N_de_t_l_phone_Prospect__c = contacts[0].Phone;
                    prop.Email_Prospect__c = contacts[0].Email;
                }
                else
                    prop.Contact_Soci_t__c = 'A REMPLIR';
            }
            else
                prop.Contact_Soci_t__c = 'A REMPLIR';
        }
    }
}