public class TestCoinAPIControllerMock implements HttpCalloutMock {     
    public HTTPResponse respond(HTTPRequest req) {
        String response='{"time": "2017-08-09T14:31:18.3150000Z", "asset_id_base": "BTC","asset_id_quote": "USD", "rate": 3260.3514321215056208129867667 }';
        HTTPResponse res = new HTTPResponse();
        res.setBody(response);
        res.setStatusCode(200);
        return res;        
    }
}