package egovframework.product.mapper;

import egovframework.product.vo.ProductVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper
public interface ProductMapper {

    // 상품 관리
    List<ProductVO> selectProductList(ProductVO vo);
    ProductVO       selectProduct(Long productId);
    int             selectProductCount(ProductVO vo);
    void            insertProduct(ProductVO vo);
    void            updateProduct(ProductVO vo);
    void            deleteProduct(Long productId);
    void            deleteInventoryByProductId(Long productId);

    // 재고 현황 (INVENTORY JOIN) - 불량창고 제외
    List<ProductVO> selectStockList(ProductVO vo);
    int             selectStockCount(ProductVO vo);

    // 재고 현황 (INVENTORY JOIN) - 불량창고 포함 전체
    List<ProductVO> selectStockListAll(ProductVO vo);
    int             selectStockCountAll(ProductVO vo);

    void            updateStock(ProductVO vo);
    void            updateInventoryQty(ProductVO vo);
    void            setInventoryQty(ProductVO vo);
    void            insertStockMovement(ProductVO vo);
    Long            selectMainWarehouseId();
    double          selectInventoryByProductAndWarehouse(ProductVO vo);

    // 대시보드
    int             selectTotalProductCount();
    int             selectLowStockCount();
    List<ProductVO> selectLowStockList();

    // 자동 채번
    String          selectLastProductCodeByCategory(String category);

    // 기본 창고 조회
    Long            selectDefaultWarehouseId();

    // INVENTORY 레코드 생성 (상품 등록 시)
    void            insertInventory(ProductVO vo);
}
