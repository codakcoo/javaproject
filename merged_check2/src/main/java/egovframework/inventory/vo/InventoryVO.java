package egovframework.inventory.vo;

public class InventoryVO {
    private Long    inventoryId;
    private Long    productId;
    private Long    warehouseId;
    private Double  qtyOnHand;
    private Double  qtyReserved;
    private String  lotNo;
    private String  expiryDate;
    private String  lastUpdated;

    // 조인용 (읽기 전용)
    private String  productCode;
    private String  productName;
    private String  unit;
    private Double  reorderPoint;
    private String  warehouseCode;
    private String  warehouseName;

    // 검색용
    private String  keyword;
    private String  warehouseType;

    public Long   getInventoryId()   { return inventoryId; }
    public void   setInventoryId(Long inventoryId) { this.inventoryId = inventoryId; }
    public Long   getProductId()     { return productId; }
    public void   setProductId(Long productId) { this.productId = productId; }
    public Long   getWarehouseId()   { return warehouseId; }
    public void   setWarehouseId(Long warehouseId) { this.warehouseId = warehouseId; }
    public Double getQtyOnHand()     { return qtyOnHand; }
    public void   setQtyOnHand(Double qtyOnHand) { this.qtyOnHand = qtyOnHand; }
    public Double getQtyReserved()   { return qtyReserved; }
    public void   setQtyReserved(Double qtyReserved) { this.qtyReserved = qtyReserved; }
    public String getLotNo()         { return lotNo; }
    public void   setLotNo(String lotNo) { this.lotNo = lotNo; }
    public String getExpiryDate()    { return expiryDate; }
    public void   setExpiryDate(String expiryDate) { this.expiryDate = expiryDate; }
    public String getLastUpdated()   { return lastUpdated; }
    public void   setLastUpdated(String lastUpdated) { this.lastUpdated = lastUpdated; }
    public String getProductCode()   { return productCode; }
    public void   setProductCode(String productCode) { this.productCode = productCode; }
    public String getProductName()   { return productName; }
    public void   setProductName(String productName) { this.productName = productName; }
    public String getUnit()          { return unit; }
    public void   setUnit(String unit) { this.unit = unit; }
    public Double getReorderPoint()  { return reorderPoint; }
    public void   setReorderPoint(Double reorderPoint) { this.reorderPoint = reorderPoint; }
    public String getWarehouseCode() { return warehouseCode; }
    public void   setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    public String getWarehouseName() { return warehouseName; }
    public void   setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public String getKeyword()       { return keyword; }
    public void   setKeyword(String keyword) { this.keyword = keyword; }
    public String getWarehouseType() { return warehouseType; }
    public void   setWarehouseType(String warehouseType) { this.warehouseType = warehouseType; }

    // 출고 가능 수량 계산 (앱 레벨)
    public Double getQtyAvailable() {
        if (qtyOnHand == null) return 0.0;
        if (qtyReserved == null) return qtyOnHand;
        return qtyOnHand - qtyReserved;
    }
}
