package egovframework.stock.service.impl;

import egovframework.inventory.mapper.InventoryMapper;
import egovframework.inventory.vo.InventoryVO;
import egovframework.stock.mapper.StockMovementMapper;
import egovframework.stock.service.StockService;
import egovframework.stock.vo.StockMovementVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class StockServiceImpl implements StockService {

    @Autowired private StockMovementMapper movementMapper;
    @Autowired private InventoryMapper     inventoryMapper;

    @Override
    public List<StockMovementVO> selectMovementList(StockMovementVO vo) {
        return movementMapper.selectMovementList(vo);
    }

    @Override
    public StockMovementVO selectMovement(Long movementId) {
        return movementMapper.selectMovement(movementId);
    }

    @Override
    @Transactional
    public void processMovement(StockMovementVO vo) {
        // 1. 이동 이력 등록 (append-only)
        movementMapper.insertMovement(vo);

        // 2. INVENTORY upsert — 방향에 따라 delta 결정
        double delta = resolveQtyDelta(vo.getMovementType(), vo.getQty());

        InventoryVO inv = new InventoryVO();
        inv.setProductId(vo.getProductId());
        inv.setWarehouseId(vo.getWarehouseId());
        inv.setQtyOnHand(delta);  // ON DUPLICATE KEY UPDATE qty_on_hand = qty_on_hand + #{qtyOnHand}
        inv.setLotNo(vo.getRemarks()); // lot_no 별도 파라미터 없을 때 null
        inventoryMapper.upsertInventory(inv);
    }

    /**
     * 이동 유형에 따라 INVENTORY qty_on_hand 에 적용할 delta 반환
     * INBOUND  / RETURN  → +qty
     * OUTBOUND           → -qty
     * ADJUST             → qty (부호 포함, 폼에서 +/- 직접 입력)
     * TRANSFER           → 출발 창고 -qty / 도착 창고 +qty (확장 시 처리)
     */
    private double resolveQtyDelta(String type, Double qty) {
        if (qty == null) return 0;
        switch (type) {
            case "OUTBOUND": return -Math.abs(qty);
            case "INBOUND":
            case "RETURN":   return Math.abs(qty);
            case "ADJUST":   return qty; // 폼에서 부호 포함 입력
            default:         return qty;
        }
    }
}
