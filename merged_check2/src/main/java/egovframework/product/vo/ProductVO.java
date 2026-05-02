package egovframework.product.vo;

public class ProductVO {
    private Long   productId;
    private String productCode;
    private String productName;
    private String category;
    private String unit;
    private Double reorderPoint;
    private Double reorderQty;
    private Double unitCost;
    private Integer isActive;

    // keyword (검색용, DB 컬럼 아님)
    private String keyword;

    public Long   getProductId()    { return productId; }
    public void   setProductId(Long productId) { this.productId = productId; }
    public String getProductCode()  { return productCode; }
    public void   setProductCode(String productCode) { this.productCode = productCode; }
    public String getProductName()  { return productName; }
    public void   setProductName(String productName) { this.productName = productName; }
    public String getCategory()     { return category; }
    public void   setCategory(String category) { this.category = category; }
    public String getUnit()         { return unit; }
    public void   setUnit(String unit) { this.unit = unit; }
    public Double getReorderPoint() { return reorderPoint; }
    public void   setReorderPoint(Double reorderPoint) { this.reorderPoint = reorderPoint; }
    public Double getReorderQty()   { return reorderQty; }
    public void   setReorderQty(Double reorderQty) { this.reorderQty = reorderQty; }
    public Double getUnitCost()     { return unitCost; }
    public void   setUnitCost(Double unitCost) { this.unitCost = unitCost; }
    public Integer getIsActive()    { return isActive; }
    public void   setIsActive(Integer isActive) { this.isActive = isActive; }
    public String getKeyword()      { return keyword; }
    public void   setKeyword(String keyword) { this.keyword = keyword; }
}
