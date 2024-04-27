@isTest
public class OrderTests {

    @TestSetup
    static void setupTestData(){
        TestDataFactory.InsertTestData(1);
    }
    @isTest
    static void testAfterUpdateTrigger() {
        // Create test data
        Product2 product = new Product2(Name = 'Test Product', Quantity_Ordered__c = 0);
        insert product;

        List<PricebookEntry> pricebookEntries = TestDataFactory.ConstructPricebookEntries(new List<Product2>{product});
        insert pricebookEntries;

        List<Account> accList = TestDataFactory.ConstructAccounts(1);
        insert accList;
        
        Order order = new Order(Status = 'Draft', AccountId = accList[0].Id, EffectiveDate = Date.today(), Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID);
        insert order;
        
        /*OrderItem orderItem = new OrderItem(OrderId = order.Id, Product2Id = product.Id, Quantity = 10, pricebookEntryId = pricebookEntries[0].Id, UnitPrice = 10);
        insert orderItem;*/
        
        // Trigger the after update event
        /*Test.startTest();
        order.Status = Constants.ACTIVATED_ORDER_STATUS;
        update order;
        Test.stopTest();
        
        // Verify the results
        Product2 updatedProduct = [SELECT Quantity_Ordered__c FROM Product2 WHERE Id = :product.Id];
        System.assertEquals(10, updatedProduct.Quantity_Ordered__c);*/
    }
    
    @isTest
    static void testRollUpOrderItems() {
        // Create test data
        Product2 product1 = new Product2(Name = 'Test Product 1', Quantity_Ordered__c = 0);
        insert product1;
        
        Product2 product2 = new Product2(Name = 'Test Product 2', Quantity_Ordered__c = 0);
        insert product2;

        List<PricebookEntry> pricebookEntries = TestDataFactory.ConstructPricebookEntries(new List<Product2>{product1, product2});
        insert pricebookEntries;

        String pricebookentryId1 = pricebookEntries[0].Id;
        String pricebookentryId2 = pricebookEntries[1].Id;

        List<Account> accList = TestDataFactory.ConstructAccounts(1);
        insert accList;
        
        Order order1 = new Order(Status = 'Draft', AccountId = accList[0].Id, EffectiveDate = Date.today(), Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID);
        insert order1;
        
        Order order2 = new Order(Status = 'Draft', AccountId = accList[0].Id, EffectiveDate = Date.today(), Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID);
        insert order2;
        
        /*OrderItem orderItem1 = new OrderItem(OrderId = order1.Id, Product2Id = product1.Id, Quantity = 10, pricebookEntryId = pricebookentryId1, UnitPrice = 10);
        insert orderItem1;
        
        OrderItem orderItem2 = new OrderItem(OrderId = order2.Id, Product2Id = product2.Id, Quantity = 5, pricebookEntryId = pricebookentryId2, UnitPrice = 10);
        insert orderItem2;


        Test.startTest();
        order1.Status = Constants.ACTIVATED_ORDER_STATUS;
        update order1;
        
        order2.Status = Constants.ACTIVATED_ORDER_STATUS;
        update order2;
        
        // Call the RollUpOrderItems method
        Test.stopTest();
        
        // Verify the results
        Product2 updatedProduct1 = [SELECT Quantity_Ordered__c FROM Product2 WHERE Id = :product1.Id];
        System.assertEquals(10, updatedProduct1.Quantity_Ordered__c);
        
        Product2 updatedProduct2 = [SELECT Quantity_Ordered__c FROM Product2 WHERE Id = :product2.Id];
        System.assertEquals(5, updatedProduct2.Quantity_Ordered__c);

        TestDataFactory.VerifyQuantityOrdered(product1, updatedProduct1, 10);
        TestDataFactory.VerifyQuantityOrdered(product2, updatedProduct2, 5);*/
    }

    @isTest
    static void OrderExtension_UnitTest() {
        // Create test data
        TestDataFactory.InsertTestData(1);
        Order od = [SELECT Id FROM Order LIMIT 1];
        // Create a test instance of ApexPages.StandardController and pass the test data
        ApexPages.StandardController standardController = new ApexPages.StandardController(od);

        // Create an instance of the OrderExtension class
        OrderExtension orderExtension = new OrderExtension(standardController);
        orderExtension.OnFieldChange();
        orderExtension.selectFamily();
        orderExtension.Save();
        orderExtension.First();
        orderExtension.Next();
        orderExtension.Previous();
        orderExtension.getHasPrevious();
        orderExtension.getHasNext();
        orderExtension.GetTotalPages();
        orderExtension.GetPageNumber();
        orderExtension.GetFamilyOptions();
        //orderExtension.QueryOrderRecord(Od.Id);

        // Test the methods of the OrderExtension class
        // ...

        // Assert the expected results
        // ...
    }

    @isTest private static void OrderUpdate_UnitTest() {
        Test.startTest();
        
        Order o = [SELECT Id, Status FROM Order LIMIT 1];
        Product2 p = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];
        
        o.status = Constants.ACTIVATED_ORDER_STATUS;
        update o;
        
        Product2 p2 =  [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];      
        
        TestDataFactory.VerifyQuantityOrdered(p, p2, Constants.DEFAULT_ROWS);
        
        Test.stopTest();
    }
}