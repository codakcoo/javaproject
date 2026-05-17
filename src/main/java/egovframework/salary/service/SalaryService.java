package egovframework.salary.service;

import egovframework.salary.vo.SalaryVO;
import java.util.List;

public interface SalaryService {
    List<SalaryVO> getSalaryList();
    SalaryVO       getSalaryByMemberId(String memberId);
    void           saveSalary(SalaryVO salary);
}
