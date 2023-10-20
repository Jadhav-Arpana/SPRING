trigger UpdateNumberOfContacts on Contact (after insert, after update, after delete, after undelete) {
    // Create a map to hold the count of contacts per account
    Map<Id, Integer> accountContactCountMap = new Map<Id, Integer>();
   // by count method, it can also done by aggregate query
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contact con : Trigger.new) {

            if (con.AccountId != null) {
                //In switch Account case updating old account count
                if(oldMap.get(con.Id).AccountId != con.AccountId){
                    accountContactCountMap.put(oldMap.get(con.Id).AccountId, accountContactCountMap.get(oldMap.get(con.Id).AccountId) - 1);
                }
                // to add count in new contact
                if (accountContactCountMap.containsKey(con.AccountId)) {
                    accountContactCountMap.put(con.AccountId, accountContactCountMap.get(con.AccountId) + 1);
                } else {
                    accountContactCountMap.put(con.AccountId, 1);
                }
                
            }

        }
        
    }

    if (Trigger.isDelete) {
        for (Contact con : Trigger.old) {
            if (con.AccountId != null) {
                if (accountContactCountMap.containsKey(con.AccountId)) {
                    accountContactCountMap.put(con.AccountId, accountContactCountMap.get(con.AccountId) - 1);
                }
            }
        }
    }

    // Update the Number of Contacts field on the related accounts
   
    for(Account acc : [SELECt Id, count__c FROM Account Id IN: accountContactCountMap.KeySet()])
    {
        Integer temp = acc.count__c != null ? acc.count__c : 0;
        acc.count__c = temp + accountContactCountMap.get(acc.Id);
        accountsToUpdate.add(acc);
    }
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
    
}
