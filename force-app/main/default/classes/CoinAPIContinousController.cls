public class CoinAPIContinousController {
    
    public String response {get;set;} 
    public static CoinAPISettings__c coinAPISettings = new CoinAPISettings__c();
    
    @TestVisible
    private static String continuationState;
    
    @AuraEnabled(continuation=true cacheable=true) 
    public static Object requestService(){
        coinAPISettings = CoinAPISettings__c.getOrgDefaults();
        
        //Timeout in seconds, 60 is limit
        Continuation con = new Continuation(60);
        
        // Set callback method
        con.continuationMethod='renderResponse';
        
        HttpRequest http = new HttpRequest();
        http.setEndpoint('https://rest.coinapi.io/v1/assets');
        http.setMethod('GET');
        http.setHeader('X-CoinAPI-Key',coinAPISettings.API_KEY__c);
        //con.addHttpRequest(http);
        // Store the HttRequest and make it accessible for a testing-context
        continuationState = con.addHttpRequest(http);
        con.state = continuationState;

        return con;
    }
    
    @AuraEnabled(cacheable=true) 
    public static Object renderResponse(Object state) {
        
        List<getAssetsWrapper> getAssetsList = new List<getAssetsWrapper>();
        Map<String,List<assetListWrap>> assetMap = new Map<String,List<assetListWrap>>();
		
		System.debug('state:: '+ JSON.serialize(state));
        
        HttpResponse response = Continuation.getResponse ((String) state);
        Integer statusCode = response.getStatusCode();
        
        //String JSONResponceBody = response.getBody(); 
        //Integer statusCode = Integer.valueOf(response.getStatusCode());
        
        /*if(statusCode != 200){
            getAssetsList = (List<getAssetsWrapper>) JSON.deserialize(JSONResponceBody, List<getAssetsWrapper>.class);
            
            for(getAssetsWrapper asset : getAssetsList){
                if(!assetMap.containskey('Crypto')){
                    assetMap.put('Crypto', new List<assetListWrap>());
                }
                if(!assetMap.containskey('Currency')){
                    assetMap.put('Currency', new List<assetListWrap>());
                }
                
                if(asset.type_is_crypto == 0){
                    assetListWrap assetwrap = new assetListWrap(asset.asset_id,asset.name);
                    assetMap.get('Currency').add(assetwrap);
                }
                else if(asset.type_is_crypto == 1){
                    assetListWrap assetwrap = new assetListWrap(asset.asset_id,asset.name);
                    assetMap.get('Crypto').add(assetwrap);
                }
            }
        }
        System.debug('assetMap:: ' +assetMap); */ 
        
        if (statusCode == 200) {
            return response.getBody();
        } else if(statusCode >= 2000) {
            // Handle continutation-specific error codes
            // See <a href="https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Continuation.htm">https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Continuation.htm</a>
            throw new AuraHandledException('Continuation Error: ' + statusCode + ' - ' + response.getBody());
        } else {
            // Handle standard HTTP request errors
            throw new AuraHandledException('HTTP Request Error: ' + statusCode + ' - ' + response.getBody());
        }
    }
}