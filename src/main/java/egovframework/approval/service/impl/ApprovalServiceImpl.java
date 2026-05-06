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
import java.util.Map;

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
    public Map<String, Object> getStatusCounts() {
        return approvalMapper.selectStatusCounts();
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
        String docNo = "AP-" + new SimpleDateFormat("yyyyMMdd-HHmmss").format(new Date());
        vo.setDocNo(docNo);

        approvalMapper.insertApprovalDoc(vo);

        if (vo.getItems() != null) {
            for (ApprovalDocItemVO item : vo.getItems()) {
                item.setDocId(vo.getDocId());
                approvalMapper.insertApprovalItem(item);
            }
        }
    }

    @Override
    public void changeStatus(Long docId, String status, String approverId, String reason) {
        ApprovalDocVO vo = new ApprovalDocVO();
        vo.setDocId(docId);
        vo.setStatus(status);
        vo.setApproverId(approverId);
        vo.setRejectReason(reason);
        approvalMapper.updateApprovalStatus(vo);
    }

    @Override
    public void approveApproval(Long docId, String approverId) {
        changeStatus(docId, "APPROVED", approverId, null);
    }

    @Override
    public void rejectApproval(Long docId, String approverId, String reason) {
        changeStatus(docId, "REJECTED", approverId, reason);
    }

    @Override
    @Transactional
    public void removeApproval(Long docId) {
        approvalMapper.deleteApprovalItems(docId);
        approvalMapper.deleteApprovalDoc(docId);
    }
}
