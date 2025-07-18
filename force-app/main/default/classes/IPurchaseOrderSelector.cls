public interface IPurchaseOrderSelector {
    List<PurchaseOrder__c> getPaginatedOrders(Integer pageNumber, Integer pageSize);
    Integer getOrderCount();
    List<PurchaseOrder__c> getOrderById(Id orderId);
}