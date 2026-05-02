package egovframework.product.service.impl;

import egovframework.product.mapper.ProductMapper;
import egovframework.product.service.ProductService;
import egovframework.product.vo.ProductVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    // 카테고리 → prefix 매핑
    private static final Map<String, String> CATEGORY_PREFIX = new HashMap<>();
    static {
        CATEGORY_PREFIX.put("식품",   "FOOD");
        CATEGORY_PREFIX.put("전자",   "ELEC");
        CATEGORY_PREFIX.put("소모품", "CONS");
        CATEGORY_PREFIX.put("원자재", "RAW");
        CATEGORY_PREFIX.put("기타",   "ETC");
    }

    @Override
    public List<ProductVO> selectProductList(ProductVO vo) {
        return productMapper.selectProductList(vo);
    }

    @Override
    public ProductVO selectProduct(Long productId) {
        return productMapper.selectProduct(productId);
    }

    /**
     * 카테고리에 따라 다음 상품코드 자동 생성
     * 예) 식품 → FOOD-001, FOOD-002 ...
     */
    @Override
    public String generateProductCode(String category) {
        String prefix = CATEGORY_PREFIX.getOrDefault(category, "PROD");
        return productMapper.selectNextProductCode(prefix);
    }

    @Override
    public void insertProduct(ProductVO vo) {
        productMapper.insertProduct(vo);
    }

    @Override
    public void updateProduct(ProductVO vo) {
        productMapper.updateProduct(vo);
    }

    @Override
    public void deleteProduct(Long productId) {
        productMapper.deleteProduct(productId);
    }
}
