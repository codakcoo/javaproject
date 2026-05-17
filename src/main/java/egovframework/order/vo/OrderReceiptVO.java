package egovframework.order.vo;

import java.util.List;

public class OrderReceiptVO {

    private Long   receiptId;
    private String receiptNo;
    private Long   docId;
    private String docType;
    private String orderDate;
    private String partnerName;
    private String requesterId;
    private String approverId;
    private Double totalAmount;
    private String createdAt;

    // JOIN 조회용
    private String requesterName;
    private String approverName;
    private String docNo;         // 원본 결재 문서번호

    // 상품 라인 목록
    private List<OrderReceiptItemVO> items;

    // 검색 조건
    private String searchDocType;
    private String searchKeyword;

    public Long   getReceiptId()             { return receiptId; }
    public void   setReceiptId(Long v)       { this.receiptId = v; }
    public String getReceiptNo()             { return receiptNo; }
    public void   setReceiptNo(String v)     { this.receiptNo = v; }
    public Long   getDocId()                 { return docId; }
    public void   setDocId(Long v)           { this.docId = v; }
    public String getDocType()               { return docType; }
    public void   setDocType(String v)       { this.docType = v; }
    public String getOrderDate()             { return orderDate; }
    public void   setOrderDate(String v)     { this.orderDate = v; }
    public String getPartnerName()           { return partnerName; }
    public void   setPartnerName(String v)   { this.partnerName = v; }
    public String getRequesterId()           { return requesterId; }
    public void   setRequesterId(String v)   { this.requesterId = v; }
    public String getApproverId()            { return approverId; }
    public void   setApproverId(String v)    { this.approverId = v; }
    public Double getTotalAmount()           { return totalAmount; }
    public void   setTotalAmount(Double v)   { this.totalAmount = v; }
    public String getCreatedAt()             { return createdAt; }
    public void   setCreatedAt(String v)     { this.createdAt = v; }
    public String getRequesterName()         { return requesterName; }
    public void   setRequesterName(String v) { this.requesterName = v; }
    public String getApproverName()          { return approverName; }
    public void   setApproverName(String v)  { this.approverName = v; }
    public String getDocNo()                 { return docNo; }
    public void   setDocNo(String v)         { this.docNo = v; }
    public List<OrderReceiptItemVO> getItems()           { return items; }
    public void setItems(List<OrderReceiptItemVO> items) { this.items = items; }
    public String getSearchDocType()         { return searchDocType; }
    public void   setSearchDocType(String v) { this.searchDocType = v; }
    public String getSearchKeyword()         { return searchKeyword; }
    public void   setSearchKeyword(String v) { this.searchKeyword = v; }
}