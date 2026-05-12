package egovframework.dept.service;

import egovframework.dept.vo.DeptVO;
import java.util.List;

public interface DeptService {
    List<DeptVO> getDeptList();              // 부서 목록
    DeptVO       getDeptById(String deptId); // 부서 단건
    void         insertDept(DeptVO dept);    // 부서 추가
    void         updateDept(DeptVO dept);    // 부서 수정
    void         deleteDept(String deptId);  // 부서 삭제
}
