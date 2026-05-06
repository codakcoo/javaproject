// 해당 VO는 결재를 넣기위한 문서 구조
package egovframework.approval.vo;

import java.util.List;

public class ApprovalDocVO {

    private Long   docId;
    private String docNo;
    private String docType;      // INBOUND / OUTBOUND / STOCK_ADJ	(입고,출고,재고)
    private String title;
    private String status;       // DRAFT / PENDING / IN_PROGRESS / APPROVED / REJECTED (총/기안/진행/결재/반려)
    private String rejectReason;
    private Long   customerId;
    private Long   supplierId;
    private String requesterId;
    private String approverId;
    private String requestedAt;
    private String approvedAt;
    private String createdAt;

    // JOIN 조회용
    private String partnerName;
    private String partnerAddress;
    private String requesterName;
    private String approverName;

    // 상품 라인
    private List<ApprovalDocItemVO> items;			// 결재 상품들 -> 문서:1 = 상품:n

    // 검색 조건
    private String searchStatus;
    private String searchTitle;
    private String searchDocType;					// 검색 문서 타입

    public Long   getDocId()            { return docId; }
    public void   setDocId(Long v)      { this.docId = v; }
    public String getDocNo()            { return docNo; }
    public void   setDocNo(String v)    { this.docNo = v; }
    public String getDocType()          { return docType; }
    public void   setDocType(String v)  { this.docType = v; }
    public String getTitle()            { return title; }
    public void   setTitle(String v)    { this.title = v; }
    public String getStatus()           { return status; }
    public void   setStatus(String v)   { this.status = v; }
    public String getRejectReason()         { return rejectReason; }
    public void   setRejectReason(String v) { this.rejectReason = v; }
    public Long   getCustomerId()           { return customerId; }
    public void   setCustomerId(Long v)     { this.customerId = v; }
    public Long   getSupplierId()           { return supplierId; }
    public void   setSupplierId(Long v)     { this.supplierId = v; }
    public String getRequesterId()          { return requesterId; }
    public void   setRequesterId(String v)  { this.requesterId = v; }
    public String getApproverId()           { return approverId; }
    public void   setApproverId(String v)   { this.approverId = v; }
    public String getRequestedAt()          { return requestedAt; }
    public void   setRequestedAt(String v)  { this.requestedAt = v; }
    public String getApprovedAt()           { return approvedAt; }
    public void   setApprovedAt(String v)   { this.approvedAt = v; }
    public String getCreatedAt()            { return createdAt; }
    public void   setCreatedAt(String v)    { this.createdAt = v; }
    public String getPartnerName()              { return partnerName; }
    public void   setPartnerName(String v)      { this.partnerName = v; }
    public String getPartnerAddress()           { return partnerAddress; }
    public void   setPartnerAddress(String v)   { this.partnerAddress = v; }
    public String getRequesterName()            { return requesterName; }
    public void   setRequesterName(String v)    { this.requesterName = v; }
    public String getApproverName()             { return approverName; }
    public void   setApproverName(String v)     { this.approverName = v; }
    public List<ApprovalDocItemVO> getItems()           { return items; }
    public void setItems(List<ApprovalDocItemVO> v)     { this.items = v; }
    public String getSearchStatus()             { return searchStatus; }
    public void   setSearchStatus(String v)     { this.searchStatus = v; }
    public String getSearchTitle()              { return searchTitle; }
    public void   setSearchTitle(String v)      { this.searchTitle = v; }
    public String getSearchDocType()            { return searchDocType; }
    public void   setSearchDocType(String v)    { this.searchDocType = v; }
}
