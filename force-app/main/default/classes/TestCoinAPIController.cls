@isTest
public class TestCoinAPIController {
    
    @testSetup
    public static void testData(){
        Test.startTest();
        Opportunity testOpportunity = new Opportunity(
            StageName = 'Prospecting',
            CloseDate = Date.valueOf('2021-10-01'),
            Name = 'Test Opportunity Triggers',
            CurrencyName__c ='USD',
            CurrencyType__c ='Bitcoin',
            Current_Exchange_Rate__c = 1179.6169075637615713133301016
        );
        Insert testOpportunity;
        
        CoinAPISettings__c coinAPISettings = new CoinAPISettings__c(API_KEY__c = 'C4FAC44D-F734-4CB2-9DA3-4ECAD8F66CA7', 
                                                                    CoinAssets_URL__c='https://rest.coinapi.io/v1/assets',
                                                                    Coinexchangerate_URL__c='https://rest.coinapi.io/v1/exchangerate/',
                                                                    Coinexchanges_URL__c='https://rest.coinapi.io/v1/exchanges');
        Insert coinAPISettings;
        Test.stopTest();
    }
    
    @isTest
    static void testCoinAPI(){
        Test.startTest();
        Id oppRecordId = [SELECT Id, Name, CurrencyType__c, CurrencyName__c, Current_Exchange_Rate__c, StageName 
                          FROM Opportunity LIMIT 1].Id;
        
        Map<String,List<assetListWrap>>	assetMap = new Map<String,List<assetListWrap>>();
        assetMap = CoinAPIController.getInitData();
        Test.setMock(HttpCalloutMock.class, new TestCoinAPIControllerMock());
        String testExchangeRate = CoinAPIController.getExchangeRates('BTC','USD');
        CoinAPIController.moniterCoinUpdateRecord(oppRecordId,'BTC','USD',testExchangeRate);
        Test.stopTest();
    }
    
    @isTest
    static void testCoinAPISchedule(){
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new TestCoinAPIControllerMock());
        CoinAPIScheduler coinAPIScheduler = new CoinAPIScheduler();
        String sch = '0  00 1 3 * ?';
        System.schedule('Test', sch, coinAPIScheduler);
        
        Test.stopTest();
    }
}