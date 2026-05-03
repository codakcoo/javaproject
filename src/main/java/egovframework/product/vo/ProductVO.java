package egovframework.product.vo;

public class ProductVO {

    // ── PRODUCT 테이블 컬럼 ─────────────────────────
    private Long   productId;       // product_id (AUTO_INCREMENT)
    private String productCode;     // product_code (SKU)
    private String productName;     // product_name
    private String category;        // category
    private String unit;            // unit (EA, BOX, KG 등)
    private double reorderPoint;    // reorder_point (안전재고 기준점)
    private double reorderQty;      // reorder_qty
    private double unitCost;        // unit_cost (원가)
    private int    isActive;        // is_active (1=활성, 0=비활성)
    private String createdAt;       // created_at

    // ── INVENTORY JOIN 결과 ─────────────────────────
    private double qtyOnHand;       // qty_on_hand (현재 재고)
    private double qtyReserved;     // qty_reserved (예약 수량)
    private String warehouseName;   // warehouse_name (창고명)
    private Long   warehouseId;     // warehouse_id
    private String warehouseType;   // warehouse type (DEFECT 여부 판단용)

    // ── 검색 조건 ───────────────────────────────────
    private String searchKeyword;
    private String searchCategory;
    private String includeDefect;   // "Y" 이면 불량창고 포함 조회

    // getters / setters
    public Long   getProductId()              { return productId; }
    public void   setProductId(Long v)        { this.productId = v; }
    public String getProductCode()            { return productCode; }
    public void   setProductCode(String v)    { this.productCode = v; }
    public String getProductName()            { return productName; }
    public void   setProductName(String v)    { this.productName = v; }
    public String getCategory()               { return category; }
    public void   setCategory(String v)       { this.category = v; }
    public String getUnit()                   { return unit; }
    public void   setUnit(String v)           { this.unit = v; }
    public double getReorderPoint()           { return reorderPoint; }
    public void   setReorderPoint(double v)   { this.reorderPoint = v; }
    public double getReorderQty()             { return reorderQty; }
    public void   setReorderQty(double v)     { this.reorderQty = v; }
    public double getUnitCost()               { return unitCost; }
    public void   setUnitCost(double v)       { this.unitCost = v; }
    public int    getIsActive()               { return isActive; }
    public void   setIsActive(int v)          { this.isActive = v; }
    public String getCreatedAt()              { return createdAt; }
    public void   setCreatedAt(String v)      { this.createdAt = v; }
    public double getQtyOnHand()              { return qtyOnHand; }
    public void   setQtyOnHand(double v)      { this.qtyOnHand = v; }
    public double getQtyReserved()            { return qtyReserved; }
    public void   setQtyReserved(double v)    { this.qtyReserved = v; }
    public String getWarehouseName()          { return warehouseName; }
    public void   setWarehouseName(String v)  { this.warehouseName = v; }
    public Long   getWarehouseId()            { return warehouseId; }
    public void   setWarehouseId(Long v)      { this.warehouseId = v; }
    public String getWarehouseType()          { return warehouseType; }
    public void   setWarehouseType(String v)  { this.warehouseType = v; }
    public String getSearchKeyword()          { return searchKeyword; }
    public void   setSearchKeyword(String v)  { this.searchKeyword = v; }
    public String getSearchCategory()         { return searchCategory; }
    public void   setSearchCategory(String v) { this.searchCategory = v; }
    public String getIncludeDefect()          { return includeDefect; }
    public void   setIncludeDefect(String v)  { this.includeDefect = v; }
}
