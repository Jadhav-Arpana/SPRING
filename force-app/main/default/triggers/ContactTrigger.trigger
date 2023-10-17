trigger UpdateNumberOfContacts on Contact (after insert, after update, after delete, after undelete) {
    // Create a map to hold the count of contacts per account
    Map<Id, Integer> accountContactCountMap = new Map<Id, Integer>();
   // by count method, it can also done by aggregate query
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contact con : Trigger.new) {
            if (con.AccountId != null) {
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
    List<Account> accountsToUpdate = new List<Account>();
    for (Id accountId : accountContactCountMap.keySet()) {
        Account acc = new Account(Id = accountId, Number_of_Contacts__c = accountContactCountMap.get(accountId));
        accountsToUpdate.add(acc);
    }
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
    
}
