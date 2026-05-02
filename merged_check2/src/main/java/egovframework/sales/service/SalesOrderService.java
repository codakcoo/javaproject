package egovframework.sales.service;

import egovframework.sales.vo.SalesOrderVO;
import java.util.List;

public interface SalesOrderService {
    List<SalesOrderVO> selectSalesOrderList(SalesOrderVO vo);
    SalesOrderVO       selectSalesOrder(Long soId);
    void               insertSalesOrder(SalesOrderVO vo);
    void               updateSalesOrder(SalesOrderVO vo);
    void               updateSalesOrderStatus(Long soId, String status);
}
