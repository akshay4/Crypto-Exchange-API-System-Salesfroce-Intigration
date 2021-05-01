public class CoinAPIBatch Implements Database.batchable<sObject>,Database.AllowsCallouts{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, CurrencyType__c, CurrencyName__c, Current_Exchange_Rate__c FROM Opportunity';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity> scope){
        List<Opportunity> OpportunityToUpdates = new List<Opportunity>();      
        for(Opportunity opp : scope){
            Opportunity opps = new Opportunity();
            String exchangeRate = CoinAPIController.getExchangeRates(opp.CurrencyType__c,opp.CurrencyName__c);
            opps.Id = opp.Id;
            opps.CurrencyType__c = opp.CurrencyType__c;
            opps.CurrencyName__c = opp.CurrencyName__c;
            opps.Current_Exchange_Rate__c = Decimal.valueOf(exchangeRate);
            OpportunityToUpdates.add(opps);
        }
        if(OpportunityToUpdates.size()>0){
            update OpportunityToUpdates;
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}