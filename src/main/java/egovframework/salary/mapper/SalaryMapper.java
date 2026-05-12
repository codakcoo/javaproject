package egovframework.salary.mapper;

import egovframework.salary.vo.SalaryVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface SalaryMapper {
    List<SalaryVO> selectSalaryList();
    SalaryVO       selectSalaryByMemberId(String memberId);
    void           insertSalary(SalaryVO salary);
    void           updateSalary(SalaryVO salary);
}
