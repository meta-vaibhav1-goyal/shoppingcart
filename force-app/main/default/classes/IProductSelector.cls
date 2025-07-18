public interface IProductSelector {
    List<Product2> searchProduct(String searchTerm);
    List<Product2> getPaginatedProducts(Integer pageNumber, Integer pageSize);
    Integer getProductCount();
    List<Product2> getProductsByIdSet(Set<Id> idSet);
}