package egovframework.customer.service;

import egovframework.customer.vo.CustomerVO;
import java.util.List;

public interface CustomerService {
    List<CustomerVO> selectCustomerList(CustomerVO vo);
    CustomerVO       selectCustomer(Long customerId);
    void             insertCustomer(CustomerVO vo);
    void             updateCustomer(CustomerVO vo);
    void             deleteCustomer(Long customerId);
}
