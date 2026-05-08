package egovframework.order.vo;

public class OrderReceiptItemVO {

    private Long   itemId;
    private Long   receiptId;
    private Long   productId;
    private String productCode;
    private String productName;
    private String unit;
    private Double qty;
    private Double unitCost;
    private Double amount;

    public Long   getItemId()              { return itemId; }
    public void   setItemId(Long v)        { this.itemId = v; }
    public Long   getReceiptId()           { return receiptId; }
    public void   setReceiptId(Long v)     { this.receiptId = v; }
    public Long   getProductId()           { return productId; }
    public void   setProductId(Long v)     { this.productId = v; }
    public String getProductCode()         { return productCode; }
    public void   setProductCode(String v) { this.productCode = v; }
    public String getProductName()         { return productName; }
    public void   setProductName(String v) { this.productName = v; }
    public String getUnit()                { return unit; }
    public void   setUnit(String v)        { this.unit = v; }
    public Double getQty()                 { return qty; }
    public void   setQty(Double v)         { this.qty = v; }
    public Double getUnitCost()            { return unitCost; }
    public void   setUnitCost(Double v)    { this.unitCost = v; }
    public Double getAmount()              { return amount; }
    public void   setAmount(Double v)      { this.amount = v; }
}