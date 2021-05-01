trigger OpportunityTigger on Opportunity (before Update) {
	
    if(Trigger.isbefore){
        if(Trigger.isUpdate){
            OpportunityTiggerHandler.createHistoryExchangeRecord(Trigger.oldMap);
        }
    }
}