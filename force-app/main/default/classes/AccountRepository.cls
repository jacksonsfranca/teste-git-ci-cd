virtual
public class AccountRepository {

    virtual
    public Account findAccountById(Id accId){
        return [SELECT Id, Name FROM Account WHERE Id =: accId];
    }

    virtual
    public Account findAccountWithContactsById(Id accId){
        return [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id =: accId];
    }

    virtual
    public Account findAccountByName(String name){
        return [SELECT Id, Name FROM Account WHERE Name LIKE :name];
    }
}