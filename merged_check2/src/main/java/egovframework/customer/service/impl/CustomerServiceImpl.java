package egovframework.customer.service.impl;

import egovframework.customer.mapper.CustomerMapper;
import egovframework.customer.service.CustomerService;
import egovframework.customer.vo.CustomerVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired private CustomerMapper customerMapper;

    @Override public List<CustomerVO> selectCustomerList(CustomerVO vo) { return customerMapper.selectCustomerList(vo); }
    @Override public CustomerVO selectCustomer(Long id)                  { return customerMapper.selectCustomer(id); }
    @Override public void insertCustomer(CustomerVO vo)                  { customerMapper.insertCustomer(vo); }
    @Override public void updateCustomer(CustomerVO vo)                  { customerMapper.updateCustomer(vo); }
    @Override public void deleteCustomer(Long id)                        { customerMapper.deleteCustomer(id); }
}
