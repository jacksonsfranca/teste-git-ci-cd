public class AccountRepository {
    public AccountRepository() {

    }

    public static Account getAccount(Id accId){
        return [SELECT Id, Name FROM Account WHERE Id =: accId];
    }
}