package egovframework.inventory.mapper;

import egovframework.inventory.vo.InventoryVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface InventoryMapper {
    List<InventoryVO> selectInventoryList(InventoryVO vo);
    InventoryVO       selectInventory(Long inventoryId);
    // 입출고 처리 시 upsert (있으면 UPDATE, 없으면 INSERT)
    void              upsertInventory(InventoryVO vo);
}
