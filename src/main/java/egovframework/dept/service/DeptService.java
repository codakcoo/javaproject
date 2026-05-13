package egovframework.dept.service;
import egovframework.dept.vo.DeptVO;
import java.util.List;
public interface DeptService {
    List<DeptVO> getDeptList();					// 부서 목록
    DeptVO       getDeptById(String deptId);	// 부서 단건
    void         insertDept(DeptVO dept);		// 부서 추가
    void         updateDept(DeptVO dept);		// 부서 수정
    void         deleteDept(String deptId);		// 부서 삭제
    boolean      isDeptDuplicate(String deptId, String deptName); // 추가
    String       checkDuplicate(String deptId, String deptName, String excludeId);
    // 부서코드/부서명 중복 체크, 중복 필드명 반환 (없으면 null)
}


