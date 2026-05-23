package egovframework.partner.vo;

/**
 * 거래처별 거래 이력 통합 VO
 * - 고객사: approval_doc(OUTBOUND) + sales_order UNION
 * - 공급업체: approval_doc(INBOUND)
 */
public class PartnerTradeVO {

    private String tradeType;       // "결재문서" / "수주"
    private String docType;         // OUTBOUND / INBOUND / SALES_ORDER
    private String docNo;           // 문서번호
    private String title;           // 제목 (결재문서) or soNo (수주)
    private String status;          // 결재상태 or 수주상태
    private String statusLabel;     // 화면 표시용 한글 상태
    private String tradeDate;       // 거래일자
    private String requesterName;   // 기안자 / 작성자
    private Long   refId;           // doc_id or so_id (상세 링크용)

    // 검색 조건
    private Long   customerId;
    private Long   supplierId;

    public String getTradeType()              { return tradeType; }
    public void   setTradeType(String v)      { this.tradeType = v; }
    public String getDocType()                { return docType; }
    public void   setDocType(String v)        { this.docType = v; }
    public String getDocNo()                  { return docNo; }
    public void   setDocNo(String v)          { this.docNo = v; }
    public String getTitle()                  { return title; }
    public void   setTitle(String v)          { this.title = v; }
    public String getStatus()                 { return status; }
    public void   setStatus(String v)         { this.status = v; }
    public String getStatusLabel()            { return statusLabel; }
    public void   setStatusLabel(String v)    { this.statusLabel = v; }
    public String getTradeDate()              { return tradeDate; }
    public void   setTradeDate(String v)      { this.tradeDate = v; }
    public String getRequesterName()          { return requesterName; }
    public void   setRequesterName(String v)  { this.requesterName = v; }
    public Long   getRefId()                  { return refId; }
    public void   setRefId(Long v)            { this.refId = v; }
    public Long   getCustomerId()             { return customerId; }
    public void   setCustomerId(Long v)       { this.customerId = v; }
    public Long   getSupplierId()             { return supplierId; }
    public void   setSupplierId(Long v)       { this.supplierId = v; }
}
