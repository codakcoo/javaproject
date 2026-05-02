package egovframework.warehouse.web;

import egovframework.warehouse.service.WarehouseService;
import egovframework.warehouse.vo.WarehouseVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/warehouse")
public class WarehouseController {

    @Autowired
    private WarehouseService warehouseService;

    @GetMapping("/list.do")
    public String list(WarehouseVO vo, Model model) {
        model.addAttribute("warehouseList", warehouseService.selectWarehouseList(vo));
        model.addAttribute("searchVO", vo);
        return "warehouse/warehouseList";
    }

    @GetMapping("/insertForm.do")
    public String insertForm() { return "warehouse/warehouseForm"; }

    @PostMapping("/insert.do")
    public String insert(@ModelAttribute WarehouseVO vo) {
        warehouseService.insertWarehouse(vo);
        return "redirect:/warehouse/list.do";
    }

    @GetMapping("/updateForm.do")
    public String updateForm(@RequestParam Long warehouseId, Model model) {
        model.addAttribute("warehouse", warehouseService.selectWarehouse(warehouseId));
        return "warehouse/warehouseForm";
    }

    @PostMapping("/update.do")
    public String update(@ModelAttribute WarehouseVO vo) {
        warehouseService.updateWarehouse(vo);
        return "redirect:/warehouse/list.do";
    }

    @PostMapping("/delete.do")
    public String delete(@RequestParam Long warehouseId) {
        warehouseService.deleteWarehouse(warehouseId);
        return "redirect:/warehouse/list.do";
    }
}
