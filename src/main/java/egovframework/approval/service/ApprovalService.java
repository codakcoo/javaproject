package egovframework.approval.service;

import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import java.util.List;
import java.util.Map;

public interface ApprovalService {
    List<ApprovalDocVO> getApprovalList(ApprovalDocVO vo);								// 결재 리스트 Get
    int getApprovalCount(ApprovalDocVO vo);												// 결재 카운트 Get
    Map<String, Object> getStatusCounts();												// 
    ApprovalDocVO getApproval(Long docId);												// 결재 Get
    List<ApprovalDocItemVO> getApprovalItems(Long docId);								// 결재 아이템ID Get
    void addApproval(ApprovalDocVO vo);													// 결재 추가
    void changeStatus(Long docId, String status, String approverId, String reason);		// 결재 상태변경
    void approveApproval(Long docId, String approverId);								// 결재 승인
    void rejectApproval(Long docId, String approverId, String reason);					// 결재 반려
    void removeApproval(Long docId);													// 결재 삭제
}