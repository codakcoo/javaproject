package egovframework.approval.vo;

public class ApprovalDocItemVO {

    private Long   itemId;
    private Long   docId;
    private Long   productId;
    private Double qty;
    private Double unitCost;
    private String remarks;

    // JOIN 조회용 (읽기 전용)
    private String productCode;
    private String productName;
    private String unit;

    // ── Getters / Setters ──────────────────────

    public Long getItemId()             { return itemId; }
    public void setItemId(Long itemId)  { this.itemId = itemId; }

    public Long getDocId()              { return docId; }
    public void setDocId(Long docId)    { this.docId = docId; }

    public Long getProductId()                  { return productId; }
    public void setProductId(Long productId)    { this.productId = productId; }

    public Double getQty()              { return qty; }
    public void setQty(Double qty)      { this.qty = qty; }

    public Double getUnitCost()                 { return unitCost; }
    public void setUnitCost(Double unitCost)    { this.unitCost = unitCost; }

    public String getRemarks()              { return remarks; }
    public void setRemarks(String remarks)  { this.remarks = remarks; }

    public String getProductCode()                  { return productCode; }
    public void setProductCode(String productCode)  { this.productCode = productCode; }

    public String getProductName()                  { return productName; }
    public void setProductName(String productName)  { this.productName = productName; }

    public String getUnit()             { return unit; }
    public void setUnit(String unit)    { this.unit = unit; }
}