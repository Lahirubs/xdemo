public with sharing class AccountList {

    public List<Account> accounts { get; set; }
    public List<Contact> contacts { get; set; }
    
    public AccountList() {
        accounts = [SELECT ID, Name from Account];
        contacts = [SELECT ID, Name from Contact];
    }
    
    
}