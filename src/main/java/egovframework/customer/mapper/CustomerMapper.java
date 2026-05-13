package egovframework.customer.mapper;

import egovframework.customer.vo.CustomerVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface CustomerMapper {
    List<CustomerVO> selectCustomerList(); // 활성 고객사 전체
}