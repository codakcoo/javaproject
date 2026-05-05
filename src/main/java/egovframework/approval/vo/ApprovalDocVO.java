package egovframework.approval.vo;

import java.util.List;

public class ApprovalDocVO {

    private Long   docId;
    private String docNo;
    private String title;
    private String status;
    private String rejectReason;
    private Long   customerId;
    private Long   supplierId;
    private String requesterId;
    private String approverId;
    private String requestedAt;
    private String approvedAt;
    private String createdAt;

    // JOIN 조회용 (읽기 전용)
    private String partnerName;    // 거래처명 (customer or supplier)
    private String partnerAddress; // 거래처 주소
    private String requesterName;  // 요청자 이름
    private String approverName;   // 결재자 이름

    // 상품 라인 목록 (1문서 N상품)
    private List<ApprovalDocItemVO> items;

    // 검색 조건용
    private String searchStatus;
    private String searchTitle;

    // ── Getters / Setters ──────────────────────

    public Long getDocId()              { return docId; }
    public void setDocId(Long docId)    { this.docId = docId; }

    public String getDocNo()            { return docNo; }
    public void setDocNo(String docNo)  { this.docNo = docNo; }

    public String getTitle()            { return title; }
    public void setTitle(String title)  { this.title = title; }

    public String getStatus()               { return status; }
    public void setStatus(String status)    { this.status = status; }

    public String getRejectReason()                     { return rejectReason; }
    public void setRejectReason(String rejectReason)    { this.rejectReason = rejectReason; }

    public Long getCustomerId()                 { return customerId; }
    public void setCustomerId(Long customerId)  { this.customerId = customerId; }

    public Long getSupplierId()                 { return supplierId; }
    public void setSupplierId(Long supplierId)  { this.supplierId = supplierId; }

    public String getRequesterId()                  { return requesterId; }
    public void setRequesterId(String requesterId)  { this.requesterId = requesterId; }

    public String getApproverId()                   { return approverId; }
    public void setApproverId(String approverId)    { this.approverId = approverId; }

    public String getRequestedAt()                  { return requestedAt; }
    public void setRequestedAt(String requestedAt)  { this.requestedAt = requestedAt; }

    public String getApprovedAt()                   { return approvedAt; }
    public void setApprovedAt(String approvedAt)    { this.approvedAt = approvedAt; }

    public String getCreatedAt()                    { return createdAt; }
    public void setCreatedAt(String createdAt)      { this.createdAt = createdAt; }

    public String getPartnerName()                  { return partnerName; }
    public void setPartnerName(String partnerName)  { this.partnerName = partnerName; }

    public String getPartnerAddress()                       { return partnerAddress; }
    public void setPartnerAddress(String partnerAddress)    { this.partnerAddress = partnerAddress; }

    public String getRequesterName()                    { return requesterName; }
    public void setRequesterName(String requesterName)  { this.requesterName = requesterName; }

    public String getApproverName()                     { return approverName; }
    public void setApproverName(String approverName)    { this.approverName = approverName; }

    public List<ApprovalDocItemVO> getItems()               { return items; }
    public void setItems(List<ApprovalDocItemVO> items)     { this.items = items; }

    public String getSearchStatus()                     { return searchStatus; }
    public void setSearchStatus(String searchStatus)    { this.searchStatus = searchStatus; }

    public String getSearchTitle()                  { return searchTitle; }
    public void setSearchTitle(String searchTitle)  { this.searchTitle = searchTitle; }
}