public class assetListWrap{
    @AuraEnabled public String assetId {get;set;}
    @AuraEnabled public String assetName {get;set;}
    
    public assetListWrap(String assetName,String assetId){
        this.assetName = assetName;
        this.assetId = assetId;
    }
}