package egovframework.supplier.mapper;

import egovframework.supplier.vo.SupplierVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface SupplierMapper {
    List<SupplierVO> selectSupplierList(); // 활성 공급업체 전체
}