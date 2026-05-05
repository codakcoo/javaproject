package egovframework.approval.mapper;

import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface ApprovalMapper {

    // ── 목록 조회 ──────────────────────────────
    List<ApprovalDocVO> selectApprovalList(ApprovalDocVO vo);
    int selectApprovalCount(ApprovalDocVO vo);

    // ── 상세 조회 ──────────────────────────────
    ApprovalDocVO selectApproval(Long docId);
    List<ApprovalDocItemVO> selectApprovalItems(Long docId);

    // ── 등록 ──────────────────────────────────
    void insertApprovalDoc(ApprovalDocVO vo);       // useGeneratedKeys → docId 자동 주입
    void insertApprovalItem(ApprovalDocItemVO vo);

    // ── 상태 변경 ──────────────────────────────
    void updateApprovalStatus(ApprovalDocVO vo);    // status, rejectReason, approvedAt

    // ── 삭제 (DRAFT 상태만) ───────────────────
    void deleteApprovalDoc(Long docId);
    void deleteApprovalItems(Long docId);
}