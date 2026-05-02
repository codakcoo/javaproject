package egovframework.inventory.service.impl;

import egovframework.inventory.mapper.InventoryMapper;
import egovframework.inventory.service.InventoryService;
import egovframework.inventory.vo.InventoryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class InventoryServiceImpl implements InventoryService {

    @Autowired
    private InventoryMapper inventoryMapper;

    @Override public List<InventoryVO> selectInventoryList(InventoryVO vo) { return inventoryMapper.selectInventoryList(vo); }
    @Override public InventoryVO selectInventory(Long id)                   { return inventoryMapper.selectInventory(id); }
    @Override public void upsertInventory(InventoryVO vo)                   { inventoryMapper.upsertInventory(vo); }
}
