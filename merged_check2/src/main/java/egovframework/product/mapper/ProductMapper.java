package egovframework.product.mapper;

import egovframework.product.vo.ProductVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;

@Mapper
public interface ProductMapper {
    List<ProductVO> selectProductList(ProductVO vo);
    ProductVO       selectProduct(Long productId);
    String          selectNextProductCode(String prefix);
    void            insertProduct(ProductVO vo);
    void            updateProduct(ProductVO vo);
    void            deleteProduct(Long productId);
}
