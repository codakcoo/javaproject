// 해당 VO는 문서 하나에 들어가는 여러개의 item을 만들 수 있는 구조
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

    // 아이템ID
    public Long getItemId()             { return itemId; }
    public void setItemId(Long itemId)  { this.itemId = itemId; }

    // 문서ID
    public Long getDocId()              { return docId; }
    public void setDocId(Long docId)    { this.docId = docId; }
    
    // 상품ID
    public Long getProductId()                  { return productId; }
    public void setProductId(Long productId)    { this.productId = productId; }

    // 수량
    public Double getQty()              { return qty; }
    public void setQty(Double qty)      { this.qty = qty; }

    // 단가
    public Double getUnitCost()                 { return unitCost; }
    public void setUnitCost(Double unitCost)    { this.unitCost = unitCost; }

    // 비고
    public String getRemarks()              { return remarks; }
    public void setRemarks(String remarks)  { this.remarks = remarks; }

    // 상품코드
    public String getProductCode()                  { return productCode; }
    public void setProductCode(String productCode)  { this.productCode = productCode; }

    // 상품이름
    public String getProductName()                  { return productName; }
    public void setProductName(String productName)  { this.productName = productName; }

    public String getUnit()             { return unit; }
    public void setUnit(String unit)    { this.unit = unit; }
}