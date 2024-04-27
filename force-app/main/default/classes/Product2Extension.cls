public class Product2Extension {

    public List<ProductWrapper> productsToInsert { get; set; }

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for (Schema.PicklistEntry pe : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(pe.getValue(), pe.getLabel()));
        }
        return options;
    }

    public PageReference Save(){
        Savepoint sp = Database.setSavepoint();
        List<Product2> newProducts = new List<Product2>();
        List<PricebookEntry> pricebookEntriesToInsert = new List<PricebookEntry>();

        

        try {
            

            for (ProductWrapper pw : productsToInsert) {
                if (pw.productRecord.Name != null && pw.productRecord.Family != null && pw.pricebookEntryRecord.UnitPrice != null && pw.pricebookEntryRecord.UnitPrice > 0 && pw.productRecord.Family != Constants.SELECT_ONE && pw.productRecord.Initial_Inventory__c != null && pw.productRecord.IsActive != null) {
                    newProducts.add(pw.productRecord);
                }
            }
            insert newProducts;
            for (Product2 p : newProducts) {
                for (ProductWrapper pw : productsToInsert) {
                    if (pw.productRecord.Name == p.Name) {
                        PricebookEntry pbe = new PricebookEntry();
                        pbe.Product2Id = p.Id;
                        pbe.Pricebook2Id = StandardPricebookId;
                        pbe.UnitPrice = pw.pricebookEntryRecord.UnitPrice;
                        pricebookEntriesToInsert.add(pbe);
                        }
                }
            }

            insert pricebookEntriesToInsert;

            // If successful, clear the list and display an informational message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, productsToInsert.size() + ' Inserted'));
            productsToInsert.clear();
            addRows();
        } catch (Exception e){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public class ProductWrapper {
        public Product2 productRecord { get; set; }
        public PricebookEntry pricebookEntryRecord { get; set; }

        public ProductWrapper() {
            productRecord = new Product2();
            pricebookEntryRecord = new PricebookEntry();
        }
    }

    // Constants
    private static final Id StandardPricebookId = Constants.STANDARD_PRICEBOOK_ID;
}