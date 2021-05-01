public class CryptoAPIComponentController {

    @AuraEnabled public static Decimal currentRate {get;set;}
    
    public CryptoAPIComponentController(){   
    }
    
    @AuraEnabled
    public static returnWrap getRequiredData(){
        returnWrap wrap = new returnWrap();
        wrap.currentUserName = UserInfo.getName();
        wrap.returnMap = CoinAPIController.getAssets();
            
        return wrap;
    }
    
    @AuraEnabled
    public static Decimal getCryptoRate(String assetsType, String currencyType){
        getExchangeRatesWrapper getExchangeRatesWrap = new getExchangeRatesWrapper();
        getExchangeRatesWrap = CoinAPIController.getExchangeRates(assetsType,currencyType);
        currentRate = getExchangeRatesWrap.rate;
        return currentRate;
    }
    
    public class returnWrap{
        @AuraEnabled public String currentUserName {get;set;}
        @AuraEnabled public Map<String,List<assetListWrap>> returnMap {get;set;}
    }
}