public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST' + Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList){
        List<Product2> needsAnnouncement = new List<Product2>();
        Map<String, Inventory_Setting__mdt> inventorySettings = new Map<String, Inventory_Setting__mdt>();

        // Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        for (Inventory_Setting__mdt setting : [SELECT DeveloperName, Low_Quantity_Alert__c FROM Inventory_Setting__mdt]) {
            inventorySettings.put(setting.DeveloperName, setting);
        }

        // Loop through the Products in newList
        for (Product2 product : newList) {
            // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
            Inventory_Setting__mdt setting = inventorySettings.get(product.Family);

            if (setting != null && product.Quantity_Remaining__c < setting.Low_Quantity_Alert__c) {
                // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert,
                // add it to the needsAnnouncement list
                needsAnnouncement.add(product);
            }
        }

        // Pass records to the postAlerts method
        PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ConnectApi.AnnouncementInput announcementInput = new ConnectApi.AnnouncementInput();
            
            // expires in a day
            announcementInput.expirationDate = Date.today().addDays(1);
            
            // does not notify users via email.
            announcementInput.sendEmails = false;
            
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            textSegmentInput.text = p.Name + '' + Constants.INVENTORY_LEVEL_LOW;
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            announcementInput.body = messageBodyInput;
            toPost.add(announcementInput);
            
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
        AnnouncementQueueable announcementQueueable = new AnnouncementQueueable();
        announcementQueueable.toPost = toPost;
        System.enqueueJob(announcementQueueable);
        
    }
}