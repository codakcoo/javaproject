package egovframework.product.service;

import egovframework.product.vo.ProductVO;
import egovframework.product.vo.SalesVO;
import java.util.List;

public interface ProductService {
    List<ProductVO> getProductList(ProductVO vo);
    ProductVO       getProduct(Long productId);
    int             getProductCount(ProductVO vo);
    void            addProduct(ProductVO vo);
    void            modifyProduct(ProductVO vo);
    void            removeProduct(Long productId);

    List<SalesVO>   getSalesList(SalesVO vo);
    int             getSalesCount(SalesVO vo);
    void            addSales(SalesVO vo);

    // 불량창고 제외
    List<ProductVO> getStockList(ProductVO vo);
    int             getStockCount(ProductVO vo);

    // 불량창고 포함 전체
    List<ProductVO> getStockListAll(ProductVO vo);
    int             getStockCountAll(ProductVO vo);

    void            modifyStock(ProductVO vo);

    int             getTotalProductCount();
    int             getLowStockCount();
}
