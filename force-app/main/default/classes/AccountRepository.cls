public class AccountRepository {
    public AccountRepository() {

    }

    public static Account getAccount(Id accId){
        return [SELECT Id, Name FROM Account WHERE Id =: accId];
    }

    public static Account getAccountWithContacts(Id accId){
        return [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id =: accId];
    }
}