package egovframework.sales.service.impl;

import egovframework.sales.mapper.SalesOrderMapper;
import egovframework.sales.service.SalesOrderService;
import egovframework.sales.vo.SalesOrderVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SalesOrderServiceImpl implements SalesOrderService {

    @Autowired
    private SalesOrderMapper salesOrderMapper;

    @Override
    public List<SalesOrderVO> selectSalesOrderList(SalesOrderVO vo) {
        return salesOrderMapper.selectSalesOrderList(vo);
    }

    @Override
    public SalesOrderVO selectSalesOrder(Long soId) {
        return salesOrderMapper.selectSalesOrder(soId);
    }

    @Override
    public void insertSalesOrder(SalesOrderVO vo) {
        // 수주번호 자동생성
        vo.setSoNo(salesOrderMapper.selectNextSoNo());
        salesOrderMapper.insertSalesOrder(vo);
    }

    @Override
    public void updateSalesOrder(SalesOrderVO vo) {
        salesOrderMapper.updateSalesOrder(vo);
    }

    @Override
    public void updateSalesOrderStatus(Long soId, String status) {
        SalesOrderVO vo = new SalesOrderVO();
        vo.setSoId(soId);
        vo.setStatus(status);
        salesOrderMapper.updateSalesOrderStatus(vo);
    }
}
