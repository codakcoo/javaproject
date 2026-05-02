package egovframework.warehouse.service.impl;

import egovframework.warehouse.mapper.WarehouseMapper;
import egovframework.warehouse.service.WarehouseService;
import egovframework.warehouse.vo.WarehouseVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class WarehouseServiceImpl implements WarehouseService {

    @Autowired
    private WarehouseMapper warehouseMapper;

    @Override public List<WarehouseVO> selectWarehouseList(WarehouseVO vo) { return warehouseMapper.selectWarehouseList(vo); }
    @Override public WarehouseVO selectWarehouse(Long id)                   { return warehouseMapper.selectWarehouse(id); }
    @Override public void insertWarehouse(WarehouseVO vo)                   { warehouseMapper.insertWarehouse(vo); }
    @Override public void updateWarehouse(WarehouseVO vo)                   { warehouseMapper.updateWarehouse(vo); }
    @Override public void deleteWarehouse(Long id)                          { warehouseMapper.deleteWarehouse(id); }
}
