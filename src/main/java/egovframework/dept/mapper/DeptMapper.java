package egovframework.dept.mapper;

import egovframework.dept.vo.DeptVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface DeptMapper {
    List<DeptVO> selectDeptList();              // 부서 목록 조회
    DeptVO       selectDeptById(String deptId); // 부서 단건 조회
    void         insertDept(DeptVO dept);        // 부서 추가
    void         updateDept(DeptVO dept);        // 부서 수정
    void         deleteDept(String deptId);      // 부서 삭제
}
