package egovframework.dept.service.impl;

import egovframework.dept.mapper.DeptMapper;
import egovframework.dept.service.DeptService;
import egovframework.dept.vo.DeptVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class DeptServiceImpl implements DeptService {

    @Autowired
    private DeptMapper deptMapper;

    @Override
    public List<DeptVO> getDeptList() { return deptMapper.selectDeptList(); }

    @Override
    public DeptVO getDeptById(String deptId) { return deptMapper.selectDeptById(deptId); }

    @Override
    public void insertDept(DeptVO dept) { deptMapper.insertDept(dept); }

    @Override
    public void updateDept(DeptVO dept) { deptMapper.updateDept(dept); }

    @Override
    public void deleteDept(String deptId) { deptMapper.deleteDept(deptId); }

    @Override
    public String checkDuplicate(String deptId, String deptName, String excludeId) {
        if (deptMapper.countByDeptId(deptId) > 0) return "부서코드";
        if (deptMapper.countByDeptName(deptName, excludeId) > 0) return "부서명";
        return null;
    }
}
