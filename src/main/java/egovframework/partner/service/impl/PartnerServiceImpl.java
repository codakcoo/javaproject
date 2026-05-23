package egovframework.partner.service.impl;

import egovframework.customer.mapper.CustomerMapper;
import egovframework.customer.vo.CustomerVO;
import egovframework.partner.service.PartnerService;
import egovframework.partner.vo.PartnerTradeVO;
import egovframework.supplier.mapper.SupplierMapper;
import egovframework.supplier.vo.SupplierVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PartnerServiceImpl implements PartnerService {

    @Autowired private CustomerMapper customerMapper;
    @Autowired private SupplierMapper supplierMapper;

    // ── 고객사 CRUD ─────────────────────────────────
    @Override public List<CustomerVO>     getCustomerList(CustomerVO vo)  { return customerMapper.selectCustomerListAll(vo); }
    @Override public int                  getCustomerCount(CustomerVO vo) { return customerMapper.selectCustomerCount(vo); }
    @Override public CustomerVO           getCustomer(Long id)            { return customerMapper.selectCustomer(id); }
    @Override public void                 addCustomer(CustomerVO vo)      { vo.setIsActive(1); customerMapper.insertCustomer(vo); }
    @Override public void                 modifyCustomer(CustomerVO vo)   { customerMapper.updateCustomer(vo); }
    @Override public void                 removeCustomer(Long id)         { customerMapper.deactivateCustomer(id); }

    // ── 고객사 거래 이력 ────────────────────────────
    @Override public List<PartnerTradeVO> getCustomerTradeList(Long id)  { return customerMapper.selectCustomerTradeList(id); }
    @Override public int                  getCustomerTradeCount(Long id) { return customerMapper.selectCustomerTradeCount(id); }

    // ── 공급업체 CRUD ───────────────────────────────
    @Override public List<SupplierVO>     getSupplierList(SupplierVO vo)  { return supplierMapper.selectSupplierListAll(vo); }
    @Override public int                  getSupplierCount(SupplierVO vo) { return supplierMapper.selectSupplierCount(vo); }
    @Override public SupplierVO           getSupplier(Long id)            { return supplierMapper.selectSupplier(id); }
    @Override public void                 addSupplier(SupplierVO vo)      { vo.setIsActive(1); supplierMapper.insertSupplier(vo); }
    @Override public void                 modifySupplier(SupplierVO vo)   { supplierMapper.updateSupplier(vo); }
    @Override public void                 removeSupplier(Long id)         { supplierMapper.deactivateSupplier(id); }

    // ── 공급업체 거래 이력 ──────────────────────────
    @Override public List<PartnerTradeVO> getSupplierTradeList(Long id)  { return supplierMapper.selectSupplierTradeList(id); }
    @Override public int                  getSupplierTradeCount(Long id) { return supplierMapper.selectSupplierTradeCount(id); }
}
