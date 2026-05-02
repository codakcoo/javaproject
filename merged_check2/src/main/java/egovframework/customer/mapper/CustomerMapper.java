package egovframework.customer.mapper;

import egovframework.customer.vo.CustomerVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface CustomerMapper {
    List<CustomerVO> selectCustomerList(CustomerVO vo);
    CustomerVO       selectCustomer(Long customerId);
    void             insertCustomer(CustomerVO vo);
    void             updateCustomer(CustomerVO vo);
    void             deleteCustomer(Long customerId);
}
