package egovframework.warehouse.service;

import egovframework.warehouse.vo.WarehouseVO;
import java.util.List;

public interface WarehouseService {
    List<WarehouseVO> selectWarehouseList(WarehouseVO vo);
    WarehouseVO       selectWarehouse(Long warehouseId);
    void              insertWarehouse(WarehouseVO vo);
    void              updateWarehouse(WarehouseVO vo);
    void              deleteWarehouse(Long warehouseId);
}
