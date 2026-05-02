package egovframework.inventory.service;

import egovframework.inventory.vo.InventoryVO;
import java.util.List;

public interface InventoryService {
    List<InventoryVO> selectInventoryList(InventoryVO vo);
    InventoryVO       selectInventory(Long inventoryId);
    void              upsertInventory(InventoryVO vo);
}
