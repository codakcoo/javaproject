package egovframework.partner.service;

import egovframework.customer.vo.CustomerVO;
import egovframework.partner.vo.PartnerTradeVO;
import egovframework.supplier.vo.SupplierVO;
import java.util.List;

public interface PartnerService {

    // ── 고객사 CRUD ─────────────────────────────────
    List<CustomerVO>     getCustomerList(CustomerVO vo);
    int                  getCustomerCount(CustomerVO vo);
    CustomerVO           getCustomer(Long customerId);
    void                 addCustomer(CustomerVO vo);
    void                 modifyCustomer(CustomerVO vo);
    void                 removeCustomer(Long customerId);

    // ── 고객사 거래 이력 ────────────────────────────
    List<PartnerTradeVO> getCustomerTradeList(Long customerId);
    int                  getCustomerTradeCount(Long customerId);

    // ── 공급업체 CRUD ───────────────────────────────
    List<SupplierVO>     getSupplierList(SupplierVO vo);
    int                  getSupplierCount(SupplierVO vo);
    SupplierVO           getSupplier(Long supplierId);
    void                 addSupplier(SupplierVO vo);
    void                 modifySupplier(SupplierVO vo);
    void                 removeSupplier(Long supplierId);

    // ── 공급업체 거래 이력 ──────────────────────────
    List<PartnerTradeVO> getSupplierTradeList(Long supplierId);
    int                  getSupplierTradeCount(Long supplierId);
}
