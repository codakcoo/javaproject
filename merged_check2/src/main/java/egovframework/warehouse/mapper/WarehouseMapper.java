package egovframework.warehouse.mapper;

import egovframework.warehouse.vo.WarehouseVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface WarehouseMapper {
    List<WarehouseVO> selectWarehouseList(WarehouseVO vo);
    WarehouseVO       selectWarehouse(Long warehouseId);
    void              insertWarehouse(WarehouseVO vo);
    void              updateWarehouse(WarehouseVO vo);
    void              deleteWarehouse(Long warehouseId);
}
