package egovframework.product.service.impl;

import egovframework.product.mapper.ProductMapper;
import egovframework.product.service.ProductService;
import egovframework.product.vo.ProductVO;
import egovframework.product.vo.SalesVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Override public List<ProductVO> getProductList(ProductVO vo)  { return productMapper.selectProductList(vo); }
    @Override public ProductVO       getProduct(Long productId)    { return productMapper.selectProduct(productId); }
    @Override public int             getProductCount(ProductVO vo) { return productMapper.selectProductCount(vo); }
    @Override public void            addProduct(ProductVO vo)      { productMapper.insertProduct(vo); }
    @Override public void            modifyProduct(ProductVO vo)   { productMapper.updateProduct(vo); }
    @Override public void            removeProduct(Long productId) { productMapper.deleteProduct(productId); }

    @Override public List<SalesVO>   getSalesList(SalesVO vo)     { return productMapper.selectSalesList(vo); }
    @Override public int             getSalesCount(SalesVO vo)    { return productMapper.selectSalesCount(vo); }
    @Override public void            addSales(SalesVO vo)         { productMapper.insertSales(vo); }

    @Override public List<ProductVO> getStockList(ProductVO vo)   { return productMapper.selectStockList(vo); }
    @Override public int             getStockCount(ProductVO vo)  { return productMapper.selectStockCount(vo); }
    @Override public void            modifyStock(ProductVO vo)    { productMapper.updateStock(vo); }

    @Override public int             getTotalProductCount()       { return productMapper.selectTotalProductCount(); }
    @Override public int             getLowStockCount()           { return productMapper.selectLowStockCount(); }
}
