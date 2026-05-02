package egovframework.product.vo;

public class SalesVO {

    // ── SALES_ORDER 테이블 컬럼 ─────────────────────
    private Long   soId;            // so_id (AUTO_INCREMENT)
    private String soNo;            // so_no (수주 번호)
    private Long   customerId;      // customer_id (FK)
    private String customerName;    // customer_name (JOIN)
    private String orderDate;       // order_date
    private String deliveryDate;    // delivery_date
    private String status;          // DRAFT·CONFIRMED·PICKING·SHIPPED·CANCELLED
    private String createdBy;       // created_by (member_id)
    private String createdAt;       // created_at

    // ── 검색 조건 ───────────────────────────────────
    private String searchKeyword;
    private String dateFrom;
    private String dateTo;
    private String searchStatus;

    // getters / setters
    public Long   getSoId()                  { return soId; }
    public void   setSoId(Long v)            { this.soId = v; }
    public String getSoNo()                  { return soNo; }
    public void   setSoNo(String v)          { this.soNo = v; }
    public Long   getCustomerId()            { return customerId; }
    public void   setCustomerId(Long v)      { this.customerId = v; }
    public String getCustomerName()          { return customerName; }
    public void   setCustomerName(String v)  { this.customerName = v; }
    public String getOrderDate()             { return orderDate; }
    public void   setOrderDate(String v)     { this.orderDate = v; }
    public String getDeliveryDate()          { return deliveryDate; }
    public void   setDeliveryDate(String v)  { this.deliveryDate = v; }
    public String getStatus()                { return status; }
    public void   setStatus(String v)        { this.status = v; }
    public String getCreatedBy()             { return createdBy; }
    public void   setCreatedBy(String v)     { this.createdBy = v; }
    public String getCreatedAt()             { return createdAt; }
    public void   setCreatedAt(String v)     { this.createdAt = v; }
    public String getSearchKeyword()         { return searchKeyword; }
    public void   setSearchKeyword(String v) { this.searchKeyword = v; }
    public String getDateFrom()              { return dateFrom; }
    public void   setDateFrom(String v)      { this.dateFrom = v; }
    public String getDateTo()                { return dateTo; }
    public void   setDateTo(String v)        { this.dateTo = v; }
    public String getSearchStatus()          { return searchStatus; }
    public void   setSearchStatus(String v)  { this.searchStatus = v; }
}
