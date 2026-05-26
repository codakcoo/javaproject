package egovframework.customer.mapper;

import egovframework.customer.vo.CustomerVO;
import egovframework.partner.vo.PartnerTradeVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface CustomerMapper {
    // 기존 (결재 폼 드롭다운용)
    List<CustomerVO> selectCustomerList();

    // 거래처 관리 CRUD
    List<CustomerVO>    selectCustomerListAll(CustomerVO vo);
    int                 selectCustomerCount(CustomerVO vo);
    CustomerVO          selectCustomer(Long customerId);
    void                insertCustomer(CustomerVO vo);
    void                updateCustomer(CustomerVO vo);
    void                deactivateCustomer(Long customerId);

    // 고객사별 거래 이력 (OUTBOUND 결재 + 수주 UNION)
    List<PartnerTradeVO> selectCustomerTradeList(Long customerId);
    int                  selectCustomerTradeCount(Long customerId);
}
