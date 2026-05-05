package egovframework.product.service;

import egovframework.product.vo.ProductVO;
import egovframework.product.vo.SalesVO;

import java.util.List;

public interface ProductService {

    // 상품 관리
    List<ProductVO> getProductList(ProductVO vo);
    ProductVO       getProduct(Long productId);
    int             getProductCount(ProductVO vo);
    void            addProduct(ProductVO vo);
    void            modifyProduct(ProductVO vo);
    void            removeProduct(Long productId);

    // 판매 현황
    List<SalesVO>   getSalesList(SalesVO vo);
    int             getSalesCount(SalesVO vo);
    void            addSales(SalesVO vo);

    // 재고 현황 - 불량창고 제외
    List<ProductVO> getStockList(ProductVO vo);
    int             getStockCount(ProductVO vo);

    // 재고 현황 - 불량창고 포함
    List<ProductVO> getStockListAll(ProductVO vo);
    int             getStockCountAll(ProductVO vo);

    void            modifyStock(ProductVO vo);

    // 대시보드 통계
    int             getTotalProductCount();
    int             getLowStockCount();

    // 안전재고 부족 여부 체크
    boolean         isLowStock(ProductVO vo);

    // 자동 채번: 카테고리 선택 시 다음 상품코드 생성
    String          generateNextProductCode(String category);
}
