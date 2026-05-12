package egovframework.salary.service.impl;

import egovframework.salary.mapper.SalaryMapper;
import egovframework.salary.service.SalaryService;
import egovframework.salary.vo.SalaryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SalaryServiceImpl implements SalaryService {

    @Autowired
    private SalaryMapper salaryMapper;

    @Override
    public List<SalaryVO> getSalaryList() {
        return salaryMapper.selectSalaryList();
    }

    @Override
    public SalaryVO getSalaryByMemberId(String memberId) {
        return salaryMapper.selectSalaryByMemberId(memberId);
    }

    @Override
    public void saveSalary(SalaryVO salary) {
        salaryMapper.insertSalary(salary);
    }
}
