public class CoinAPIController {

    @AuraEnabled
    public static Map<String,List<assetListWrap>> getInitData(){
        Map<String,List<assetListWrap>>	assetMap = new Map<String,List<assetListWrap>>();
        List<assetListWrap> coinList = new List<assetListWrap>();
        List<assetListWrap> currencyList = new List<assetListWrap>();
        
        for(CoinAPI__mdt asset : [SELECT Id, DeveloperName, MasterLabel, Label, Asset_Id__c FROM CoinAPI__mdt]){
            assetListWrap assetwrap = new assetListWrap(asset.Asset_Id__c,asset.Label);
            coinList.add(assetwrap);
        }
        for(CurrencyTypes__mdt asset : [SELECT Id, DeveloperName, MasterLabel, Label, Asset_Id__c FROM CurrencyTypes__mdt]){
            assetListWrap assetwrap = new assetListWrap(asset.Asset_Id__c,asset.Label);
            currencyList.add(assetwrap);
        }
        
        assetMap.put('Crypto', coinList);
        assetMap.put('Currency', currencyList);
        
        return assetMap;   
    }
 
    @AuraEnabled
    public static String getExchangeRates(String assetsType, String currencyType){
        CoinAPISettings__c coinAPISettings = CoinAPISettings__c.getOrgDefaults();
        getExchangeRatesWrapper getExchangeRatesWrap = new getExchangeRatesWrapper();
        String exchangeRate = '';
        
        HttpRequest http = new HttpRequest();
        http.setEndpoint(coinAPISettings.Coinexchangerate_URL__c+'/'+assetsType+'/'+currencyType);
        http.setMethod('GET');
        http.setHeader('X-CoinAPI-Key',coinAPISettings.API_KEY__c);
        
        Http con = new Http();
        HttpResponse hs = con.send(http);   
        
        System.debug('##Response## '+ hs.getBody());
        
        String JSONResponceBody = hs.getBody();
        Integer statusCode = hs.getStatusCode();
        
        if(statusCode == 200){
            getExchangeRatesWrap = (getExchangeRatesWrapper) JSON.deserialize(JSONResponceBody, getExchangeRatesWrapper.class);
            System.debug('getExchangeRatesWrap:: '+ getExchangeRatesWrap);
            exchangeRate = String.valueOf(getExchangeRatesWrap.rate); 
        }
        System.debug('exchangeRate:: '+ exchangeRate);
        return exchangeRate;
    }
    
    @AuraEnabled
    public static void moniterCoinUpdateRecord(Id recordId, String assetsType, String currencyType, String rate){
        System.debug('recordId:: '+ recordId);
        System.debug('assetsType:: '+ assetsType);
        System.debug('currencyType:: '+ currencyType);
        System.debug('rate:: '+ rate);
        
        Opportunity oppRecord = [SELECT Id, Name, CurrencyType__c, CurrencyName__c, Current_Exchange_Rate__c, StageName 
                                 FROM Opportunity 
                                 WHERE Id =: recordId LIMIT 1];
        
        System.debug('oppRecord:: '+ oppRecord);
        
        if(String.isNotBlank(assetsType) && String.isNotBlank(currencyType) && String.isNotBlank(rate) && assetsType != null && currencyType != null && rate != null){
            oppRecord.CurrencyType__c = currencyType;
            oppRecord.CurrencyName__c = assetsType;
            oppRecord.StageName = 'Value Proposition';
            oppRecord.Current_Exchange_Rate__c = Decimal.valueOf(rate);
            Update oppRecord;
        }
    }
}