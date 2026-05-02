package egovframework.stock.vo;

public class StockMovementVO {
    private Long   movementId;
    private Long   productId;
    private Long   warehouseId;
    private String movementType;  // INBOUND / OUTBOUND / TRANSFER / ADJUST / RETURN
    private Double qty;
    private Double unitCost;
    private Long   refOrderId;
    private String refOrderType;
    private String remarks;
    private String createdBy;
    private String createdAt;

    // 조인용 (읽기 전용)
    private String productCode;
    private String productName;
    private String unit;
    private String warehouseCode;
    private String warehouseName;
    private String createdByName; // member.name

    // 검색용
    private String keyword;
    private String fromDate;
    private String toDate;

    public Long   getMovementId()    { return movementId; }
    public void   setMovementId(Long movementId) { this.movementId = movementId; }
    public Long   getProductId()     { return productId; }
    public void   setProductId(Long productId) { this.productId = productId; }
    public Long   getWarehouseId()   { return warehouseId; }
    public void   setWarehouseId(Long warehouseId) { this.warehouseId = warehouseId; }
    public String getMovementType()  { return movementType; }
    public void   setMovementType(String movementType) { this.movementType = movementType; }
    public Double getQty()           { return qty; }
    public void   setQty(Double qty) { this.qty = qty; }
    public Double getUnitCost()      { return unitCost; }
    public void   setUnitCost(Double unitCost) { this.unitCost = unitCost; }
    public Long   getRefOrderId()    { return refOrderId; }
    public void   setRefOrderId(Long refOrderId) { this.refOrderId = refOrderId; }
    public String getRefOrderType()  { return refOrderType; }
    public void   setRefOrderType(String refOrderType) { this.refOrderType = refOrderType; }
    public String getRemarks()       { return remarks; }
    public void   setRemarks(String remarks) { this.remarks = remarks; }
    public String getCreatedBy()     { return createdBy; }
    public void   setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public String getCreatedAt()     { return createdAt; }
    public void   setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public String getProductCode()   { return productCode; }
    public void   setProductCode(String productCode) { this.productCode = productCode; }
    public String getProductName()   { return productName; }
    public void   setProductName(String productName) { this.productName = productName; }
    public String getUnit()          { return unit; }
    public void   setUnit(String unit) { this.unit = unit; }
    public String getWarehouseCode() { return warehouseCode; }
    public void   setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    public String getWarehouseName() { return warehouseName; }
    public void   setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    public String getCreatedByName() { return createdByName; }
    public void   setCreatedByName(String createdByName) { this.createdByName = createdByName; }
    public String getKeyword()       { return keyword; }
    public void   setKeyword(String keyword) { this.keyword = keyword; }
    public String getFromDate()      { return fromDate; }
    public void   setFromDate(String fromDate) { this.fromDate = fromDate; }
    public String getToDate()        { return toDate; }
    public void   setToDate(String toDate) { this.toDate = toDate; }
}
