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

    List<ProductVO> getStockList(ProductVO vo);
    int             getStockCount(ProductVO vo);
    void            modifyStock(ProductVO vo);

    int             getTotalProductCount();
    int             getLowStockCount();
}
