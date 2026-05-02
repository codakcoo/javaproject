package egovframework.product.service;

import egovframework.product.vo.ProductVO;
import java.util.List;

public interface ProductService {
    List<ProductVO> selectProductList(ProductVO vo);
    ProductVO       selectProduct(Long productId);
    String          generateProductCode(String category);
    void            insertProduct(ProductVO vo);
    void            updateProduct(ProductVO vo);
    void            deleteProduct(Long productId);
}
