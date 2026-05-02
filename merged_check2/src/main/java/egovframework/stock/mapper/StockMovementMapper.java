package egovframework.stock.mapper;

import egovframework.stock.vo.StockMovementVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface StockMovementMapper {
    List<StockMovementVO> selectMovementList(StockMovementVO vo);
    StockMovementVO       selectMovement(Long movementId);
    void                  insertMovement(StockMovementVO vo);
}
