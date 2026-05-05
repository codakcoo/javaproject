// ── ApprovalService.java ──────────────────────────────────────────────
package egovframework.approval.service;
 
import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import java.util.List;
 
public interface ApprovalService {
    List<ApprovalDocVO> getApprovalList(ApprovalDocVO vo);
    int getApprovalCount(ApprovalDocVO vo);
    ApprovalDocVO getApproval(Long docId);
    List<ApprovalDocItemVO> getApprovalItems(Long docId);
 
    void addApproval(ApprovalDocVO vo);          // 문서 + 상품 라인 일괄 등록
    void requestApproval(Long docId);            // DRAFT → PENDING
    void approveApproval(Long docId, String approverId);   // PENDING → APPROVED
    void rejectApproval(Long docId, String approverId, String reason); // PENDING → REJECTED
    void removeApproval(Long docId);             // DRAFT만 삭제
}