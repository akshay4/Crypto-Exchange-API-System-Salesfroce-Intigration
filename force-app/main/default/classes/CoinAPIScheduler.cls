public class CoinAPIScheduler Implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        CoinAPIBatch coinAPIBatch = new CoinAPIBatch();
        database.executeBatch(coinAPIBatch);
    } 
}