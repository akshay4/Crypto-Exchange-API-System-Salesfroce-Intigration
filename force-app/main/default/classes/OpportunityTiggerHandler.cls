public class OpportunityTiggerHandler {
    
    public static List<ExchangeRateHistory__c> historyRecordToInsertList = new List<ExchangeRateHistory__c>();
    
    public static void createHistoryExchangeRecord(Map<Id,Opportunity> oldOpportunityMap){
        if(oldOpportunityMap.size() > 0){
            for(Id opp : oldOpportunityMap.keySet()){
                System.debug('oldOpportunityMap.get(opp):: '+ oldOpportunityMap.get(opp));
                if(oldOpportunityMap.get(opp).CurrencyName__c != null && oldOpportunityMap.get(opp).CurrencyType__c != null && oldOpportunityMap.get(opp).Current_Exchange_Rate__c != null){
                    ExchangeRateHistory__c historyRecord = new ExchangeRateHistory__c();
                    historyRecord.CurrencyName__c = oldOpportunityMap.get(opp).CurrencyName__c;
                    historyRecord.CurrencyType__c = oldOpportunityMap.get(opp).CurrencyType__c;
                    historyRecord.Exchange_Rate__c = oldOpportunityMap.get(opp).Current_Exchange_Rate__c;
                    historyRecord.Opportunity__c = opp;
                    historyRecordToInsertList.add(historyRecord);
                }
            }
            
            if(historyRecordToInsertList.size()>0){
                System.debug('historyRecordToInsertList:: '+ historyRecordToInsertList);
                Insert historyRecordToInsertList;
            }
        }
    }
}