/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cg.CanHaveGuests = false;
        cg.CollaborationType = 'Public';
        cg.IsArchived = false;
        cg.IsAutoArchiveDisabled = false;
        return cg;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> products = new List<Product2>();
        Set<String> usedNames = new Set<String>();
        List<Schema.picklistEntry> productFamilies = Constants.PRODUCT_FAMILY;
        
        for (Integer i = 0; i < cnt; i++) {
            String productName = generateUniqueName('Product', usedNames);
            Integer index = Math.mod(i, productFamilies.size());
            String productFamily = productFamilies[index].getLabel();
            
            Product2 p = new Product2();
            p.Name = productName;
            p.Family = productFamily;
            p.IsActive = true;
            p.Initial_Inventory__c = 10;
            
            products.add(p);
        }
        
        return products;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        Id standardPricebookId = Constants.STANDARD_PRICEBOOK_ID;
        
        for (Product2 p : prods) {
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = standardPricebookId;
            pbe.UnitPrice = 10.0;
            pbe.IsActive = true;
            
            pricebookEntries.add(pbe);
        }
        
        return pricebookEntries;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accounts = new List<Account>();
        Set<String> usedNames = new Set<String>();
        
        for (Integer i = 0; i < cnt; i++) {
            String accountName = generateUniqueName('Account', usedNames);
            
            Account a = new Account();
            a.Name = accountName;
            // Set other required fields as needed
            
            accounts.add(a);
        }
        
        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contact records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> contacts = new List<Contact>();
        Set<String> usedNames = new Set<String>();
        
        for (Integer i = 0; i < cnt; i++) {
            String contactName = generateUniqueName('Contact', usedNames);
            Integer index = Math.mod(i, accts.size());
            Account relatedAccount = accts[index];
            
            Contact c = new Contact();
            c.FirstName = contactName;
            c.LastName = 'Last Name';
            c.AccountId = relatedAccount.Id;
            // Set other required fields as needed
            
            contacts.add(c);
        }
        
        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> orders = new List<Order>();
        Set<String> usedNames = new Set<String>();
        
        for (Integer i = 0; i < cnt; i++) {
            String orderName = generateUniqueName('Order', usedNames);
            Integer index = Math.mod(i, accts.size());
            Account relatedAccount = accts[index];
            
            Order o = new Order();
            o.Name = orderName;
            o.AccountId = relatedAccount.Id;
            o.Status = Constants.DRAFT_ORDER_STATUS;
            o.EffectiveDate = Date.today();
            //set pricebook on order
            o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;

            // Set other required fields as needed
            
            orders.add(o);
        }
        
        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(Integer cnt, List<PricebookEntry> pbes, List<Order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> orderItems = new List<OrderItem>();
        
        for (Integer i = 0; i < cnt; i++) {
            Integer index = Math.mod(i, pbes.size());
            Integer index2 = Math.mod(i, ords.size());
            PricebookEntry relatedPBE = pbes[index];
            Order relatedOrder = ords[index2];
            
            OrderItem oi = new OrderItem();
            oi.PricebookEntryId = relatedPBE.Id;
            oi.OrderId = relatedOrder.Id;
            oi.Quantity = Constants.DEFAULT_ROWS;
            oi.UnitPrice = relatedPBE.UnitPrice;

            // Set other required fields as needed
            
            orderItems.add(oi);
        }
        
        return orderItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        List<Product2> products = ConstructProducts(cnt);
        insert products;
        List<PricebookEntry> pricebookEntries = ConstructPricebookEntries(products);
        insert pricebookEntries;
        List<Account> accounts = ConstructAccounts(cnt);
        insert accounts;
        List<Contact> contacts = ConstructContacts(cnt, accounts);
        insert contacts;
        List<Order> orders = ConstructOrders(cnt, accounts);
        insert orders;
        List<OrderItem> orderItems = ConstructOrderItems(cnt, pricebookEntries, orders);
        insert orderItems;
    }
    
    private static String generateUniqueName(String prefix, Set<String> usedNames) {
        String name = prefix;
        Integer suffix = 1;
        
        while (usedNames.contains(name)) {
            name = prefix + suffix;
            suffix++;
        }
        
        usedNames.add(name);
        return name;
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals(originalProduct.Quantity_Ordered__c + qtyOrdered, updatedProduct.Quantity_Ordered__c);
    }
}