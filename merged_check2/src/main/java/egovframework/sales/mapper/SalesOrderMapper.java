package egovframework.sales.mapper;

import egovframework.sales.vo.SalesOrderVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface SalesOrderMapper {
    List<SalesOrderVO> selectSalesOrderList(SalesOrderVO vo);
    SalesOrderVO       selectSalesOrder(Long soId);
    String             selectNextSoNo();
    void               insertSalesOrder(SalesOrderVO vo);
    void               updateSalesOrder(SalesOrderVO vo);
    void               updateSalesOrderStatus(SalesOrderVO vo);
}
