@isTest
public class AccountRepositoryTest {
    @TestSetup
    static void makeData(){
        Account account = new Account();
        account.Name = 'Test Account';
        account.BillingCity = 'Sao Paulo';
        insert account;
    }

    @isTest
    static void getAccount(){
        AccountRepository accountRepository = new AccountRepository();

        Account acc = accountRepository.findAccountByName('%Test Account');
        Account acc2 = accountRepository.findAccountById(acc.Id);
        Account acc3 = accountRepository.findAccountWithContactsById(acc.Id);
    }
}