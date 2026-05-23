package egovframework.supplier.mapper;

import egovframework.partner.vo.PartnerTradeVO;
import egovframework.supplier.vo.SupplierVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface SupplierMapper {
    // 기존 (결재 폼 드롭다운용)
    List<SupplierVO> selectSupplierList();

    // 거래처 관리 CRUD
    List<SupplierVO>    selectSupplierListAll(SupplierVO vo);
    int                 selectSupplierCount(SupplierVO vo);
    SupplierVO          selectSupplier(Long supplierId);
    void                insertSupplier(SupplierVO vo);
    void                updateSupplier(SupplierVO vo);
    void                deactivateSupplier(Long supplierId);

    // 공급업체별 거래 이력 (INBOUND 결재)
    List<PartnerTradeVO> selectSupplierTradeList(Long supplierId);
    int                  selectSupplierTradeCount(Long supplierId);
}
