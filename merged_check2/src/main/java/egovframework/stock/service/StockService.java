package egovframework.stock.service;

import egovframework.stock.vo.StockMovementVO;
import egovframework.inventory.vo.InventoryVO;
import java.util.List;

public interface StockService {
    List<StockMovementVO> selectMovementList(StockMovementVO vo);
    StockMovementVO       selectMovement(Long movementId);
    // 입출고 등록 — STOCK_MOVEMENT insert + INVENTORY upsert 트랜잭션
    void processMovement(StockMovementVO vo);
}
