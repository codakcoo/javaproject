package egovframework.product.service.impl;

import egovframework.product.mapper.ProductMapper;
import egovframework.product.service.ProductService;
import egovframework.product.vo.ProductVO;
import egovframework.product.vo.SalesVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    // 카테고리 → 코드 접두어 매핑 (Java 8 호환)
    private static final Map<String, String> CATEGORY_PREFIX;
    static {
        CATEGORY_PREFIX = new HashMap<>();
        CATEGORY_PREFIX.put("식품",   "FOOD");
        CATEGORY_PREFIX.put("전자",   "ELEC");
        CATEGORY_PREFIX.put("소모품", "CONS");
        CATEGORY_PREFIX.put("원자재", "RAW");
        CATEGORY_PREFIX.put("기타",   "ETC");
    }

    // ── 상품 관리 ───────────────────────────────────
    @Override public List<ProductVO> getProductList(ProductVO vo)  { return productMapper.selectProductList(vo); }
    @Override public ProductVO       getProduct(Long productId)    { return productMapper.selectProduct(productId); }
    @Override public int             getProductCount(ProductVO vo) { return productMapper.selectProductCount(vo); }
    @Override public void            addProduct(ProductVO vo)      { productMapper.insertProduct(vo); }
    @Override public void            modifyProduct(ProductVO vo)   { productMapper.updateProduct(vo); }
    @Override public void            removeProduct(Long productId) { productMapper.deleteProduct(productId); }

    // ── 판매 현황 ───────────────────────────────────
    @Override public List<SalesVO>   getSalesList(SalesVO vo)     { return productMapper.selectSalesList(vo); }
    @Override public int             getSalesCount(SalesVO vo)    { return productMapper.selectSalesCount(vo); }
    @Override public void            addSales(SalesVO vo)         { productMapper.insertSales(vo); }

    // ── 재고 현황 ───────────────────────────────────
    @Override public List<ProductVO> getStockList(ProductVO vo)    { return productMapper.selectStockList(vo); }
    @Override public int             getStockCount(ProductVO vo)   { return productMapper.selectStockCount(vo); }
    @Override public List<ProductVO> getStockListAll(ProductVO vo) { return productMapper.selectStockListAll(vo); }
    @Override public int             getStockCountAll(ProductVO vo){ return productMapper.selectStockCountAll(vo); }
    @Override public void            modifyStock(ProductVO vo)     { productMapper.updateStock(vo); }

    // ── 대시보드 ────────────────────────────────────
    @Override public int             getTotalProductCount()        { return productMapper.selectTotalProductCount(); }
    @Override public int             getLowStockCount()            { return productMapper.selectLowStockCount(); }

    // ── 비즈니스 로직: 안전재고 부족 여부 ─────────────
    @Override
    public boolean isLowStock(ProductVO vo) {
        return vo.getQtyOnHand() <= vo.getReorderPoint();
    }

    /**
     * 카테고리 기반 다음 상품코드 자동 생성
     * 형식: PREFIX-NNN (예: FOOD-001, ELEC-012)
     * DB에 해당 카테고리 상품이 없으면 PREFIX-001 반환
     */
    @Override
    public String generateNextProductCode(String category) {
        String prefix = CATEGORY_PREFIX.getOrDefault(category, "ETC");
        String lastCode = productMapper.selectLastProductCodeByCategory(category);

        if (lastCode == null || lastCode.isEmpty()) {
            return prefix + "-001";
        }

        // PREFIX-NNN 형식에서 번호 파싱
        try {
            String[] parts = lastCode.split("-");
            int lastNum = Integer.parseInt(parts[parts.length - 1]);
            return prefix + "-" + String.format("%03d", lastNum + 1);
        } catch (Exception e) {
            // 파싱 실패 시 안전하게 001 반환
            return prefix + "-001";
        }
    }
}
