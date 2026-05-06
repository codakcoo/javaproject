package egovframework.approval.mapper;

import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface ApprovalMapper {
    List<ApprovalDocVO> selectApprovalList(ApprovalDocVO vo);
    int selectApprovalCount(ApprovalDocVO vo);
    Map<String, Object> selectStatusCounts();
    ApprovalDocVO selectApproval(Long docId);
    List<ApprovalDocItemVO> selectApprovalItems(Long docId);
    void insertApprovalDoc(ApprovalDocVO vo);
    void insertApprovalItem(ApprovalDocItemVO vo);
    void updateApprovalStatus(ApprovalDocVO vo);
    void deleteApprovalDoc(Long docId);
    void deleteApprovalItems(Long docId);
}
