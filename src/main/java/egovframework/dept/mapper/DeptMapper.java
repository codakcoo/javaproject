package egovframework.dept.mapper;

import egovframework.dept.vo.DeptVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import org.apache.ibatis.annotations.Param;
@Mapper
public interface DeptMapper {
    List<DeptVO> selectDeptList();                    // 부서 목록 조회
    DeptVO       selectDeptById(String deptId);       // 부서 단건 조회
    void         insertDept(DeptVO dept);             // 부서 추가
    void         updateDept(DeptVO dept);             // 부서 수정
    void         deleteDept(String deptId);           // 부서 삭제
    int countByDeptId(@Param("deptId") String deptId); // 동일한 부서코드가 DB에 존재하는지 개수 조회
    int countByDeptName(@Param("deptName") String deptName, @Param("excludeId") String excludeId); // 동일한 부서명이 DB에 존재하는지 개수 조회 (수정 시 자기 자신 제외)
}
   
