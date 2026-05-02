package egovframework.sales.vo;

public class SalesOrderVO {
    private Long   soId;
    private String soNo;
    private Long   customerId;
    private String orderDate;
    private String deliveryDate;
    private String status;
    private String createdBy;
    private String createdAt;

    // 조인용 (읽기 전용)
    private String customerName;
    private String createdByName;

    // 검색용
    private String keyword;
    private String fromDate;
    private String toDate;

    public Long   getSoId()          { return soId; }
    public void   setSoId(Long soId) { this.soId = soId; }
    public String getSoNo()          { return soNo; }
    public void   setSoNo(String soNo) { this.soNo = soNo; }
    public Long   getCustomerId()    { return customerId; }
    public void   setCustomerId(Long customerId) { this.customerId = customerId; }
    public String getOrderDate()     { return orderDate; }
    public void   setOrderDate(String orderDate) { this.orderDate = orderDate; }
    public String getDeliveryDate()  { return deliveryDate; }
    public void   setDeliveryDate(String deliveryDate) { this.deliveryDate = deliveryDate; }
    public String getStatus()        { return status; }
    public void   setStatus(String status) { this.status = status; }
    public String getCreatedBy()     { return createdBy; }
    public void   setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public String getCreatedAt()     { return createdAt; }
    public void   setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public String getCustomerName()  { return customerName; }
    public void   setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCreatedByName() { return createdByName; }
    public void   setCreatedByName(String createdByName) { this.createdByName = createdByName; }
    public String getKeyword()       { return keyword; }
    public void   setKeyword(String keyword) { this.keyword = keyword; }
    public String getFromDate()      { return fromDate; }
    public void   setFromDate(String fromDate) { this.fromDate = fromDate; }
    public String getToDate()        { return toDate; }
    public void   setToDate(String toDate) { this.toDate = toDate; }
}
