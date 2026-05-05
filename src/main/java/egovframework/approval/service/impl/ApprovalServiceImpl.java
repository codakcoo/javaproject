// ── ApprovalServiceImpl.java ──────────────────────────────────────────
package egovframework.approval.service.impl;
 
import egovframework.approval.mapper.ApprovalMapper;
import egovframework.approval.service.ApprovalService;
import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
 
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
 
@Service
public class ApprovalServiceImpl implements ApprovalService {
 
    @Autowired
    private ApprovalMapper approvalMapper;
 
    @Override
    public List<ApprovalDocVO> getApprovalList(ApprovalDocVO vo) {
        return approvalMapper.selectApprovalList(vo);
    }
 
    @Override
    public int getApprovalCount(ApprovalDocVO vo) {
        return approvalMapper.selectApprovalCount(vo);
    }
 
    @Override
    public ApprovalDocVO getApproval(Long docId) {
        ApprovalDocVO doc = approvalMapper.selectApproval(docId);
        if (doc != null) {
            doc.setItems(approvalMapper.selectApprovalItems(docId));
        }
        return doc;
    }
 
    @Override
    public List<ApprovalDocItemVO> getApprovalItems(Long docId) {
        return approvalMapper.selectApprovalItems(docId);
    }
 
    @Override
    @Transactional
    public void addApproval(ApprovalDocVO vo) {
        // 문서번호 자동 생성: AP-YYYYMMDD-HHmmss
        String docNo = "AP-" + new SimpleDateFormat("yyyyMMdd-HHmmss").format(new Date());
        vo.setDocNo(docNo);
        vo.setStatus("DRAFT");
 
        // 헤더 INSERT (useGeneratedKeys로 docId 자동 세팅)
        approvalMapper.insertApprovalDoc(vo);
 
        // 상품 라인 INSERT
        if (vo.getItems() != null) {
            for (ApprovalDocItemVO item : vo.getItems()) {
                item.setDocId(vo.getDocId());  // 방금 생성된 docId
                approvalMapper.insertApprovalItem(item);
            }
        }
    }
 
    @Override
    public void requestApproval(Long docId) {
        ApprovalDocVO vo = new ApprovalDocVO();
        vo.setDocId(docId);
        vo.setStatus("PENDING");
        approvalMapper.updateApprovalStatus(vo);
    }
 
    @Override
    public void approveApproval(Long docId, String approverId) {
        ApprovalDocVO vo = new ApprovalDocVO();
        vo.setDocId(docId);
        vo.setStatus("APPROVED");
        vo.setApproverId(approverId);
        approvalMapper.updateApprovalStatus(vo);
    }
 
    @Override
    public void rejectApproval(Long docId, String approverId, String reason) {
        ApprovalDocVO vo = new ApprovalDocVO();
        vo.setDocId(docId);
        vo.setStatus("REJECTED");
        vo.setApproverId(approverId);
        vo.setRejectReason(reason);
        approvalMapper.updateApprovalStatus(vo);
    }
 
    @Override
    @Transactional
    public void removeApproval(Long docId) {
        approvalMapper.deleteApprovalItems(docId);
        approvalMapper.deleteApprovalDoc(docId);
    }
}