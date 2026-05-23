package egovframework.partner.web;

import egovframework.customer.vo.CustomerVO;
import egovframework.partner.service.PartnerService;
import egovframework.supplier.vo.SupplierVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/partner")
public class PartnerController {

    @Autowired private PartnerService partnerService;

    private boolean isNotLoggedIn(HttpSession session) {
        return session.getAttribute("loginUser") == null;
    }

    // ════════════════════════════════════════════════
    //  고객사 관리
    // ════════════════════════════════════════════════

    @GetMapping("/customer/list.do")
    public String customerList(@ModelAttribute CustomerVO vo, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        model.addAttribute("customerList", partnerService.getCustomerList(vo));
        model.addAttribute("totalCount",   partnerService.getCustomerCount(vo));
        model.addAttribute("searchVO",     vo);
        return "partner/customerList";
    }

    @PostMapping("/customer/insert.do")
    public String customerInsert(@ModelAttribute CustomerVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        partnerService.addCustomer(vo);
        return "redirect:/partner/customer/list.do";
    }

    @PostMapping("/customer/update.do")
    public String customerUpdate(@ModelAttribute CustomerVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        partnerService.modifyCustomer(vo);
        return "redirect:/partner/customer/list.do";
    }

    @PostMapping("/customer/deactivate.do")
    public String customerDeactivate(@RequestParam Long customerId, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        partnerService.removeCustomer(customerId);
        return "redirect:/partner/customer/list.do";
    }

    @GetMapping("/customer/detail.do")
    @ResponseBody
    public String customerDetail(@RequestParam Long customerId, HttpSession session) {
        if (isNotLoggedIn(session)) return "UNAUTHORIZED";
        CustomerVO c = partnerService.getCustomer(customerId);
        if (c == null) return "NOT_FOUND";
        return "{\"customerId\":" + c.getCustomerId()
            + ",\"customerName\":\"" + esc(c.getCustomerName()) + "\""
            + ",\"contact\":\""      + esc(c.getContact())      + "\""
            + ",\"phone\":\""        + esc(c.getPhone())         + "\""
            + ",\"address\":\""      + esc(c.getAddress())       + "\""
            + ",\"isActive\":"       + c.getIsActive()
            + "}";
    }

    /** 고객사 거래 이력 페이지 */
    @GetMapping("/customer/trades.do")
    public String customerTrades(@RequestParam Long customerId, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        CustomerVO customer = partnerService.getCustomer(customerId);
        if (customer == null) return "redirect:/partner/customer/list.do";
        model.addAttribute("customer",   customer);
        model.addAttribute("tradeList",  partnerService.getCustomerTradeList(customerId));
        model.addAttribute("tradeCount", partnerService.getCustomerTradeCount(customerId));
        return "partner/customerTrades";
    }

    // ════════════════════════════════════════════════
    //  공급업체 관리
    // ════════════════════════════════════════════════

    @GetMapping("/supplier/list.do")
    public String supplierList(@ModelAttribute SupplierVO vo, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        model.addAttribute("supplierList", partnerService.getSupplierList(vo));
        model.addAttribute("totalCount",   partnerService.getSupplierCount(vo));
        model.addAttribute("searchVO",     vo);
        return "partner/supplierList";
    }

    @PostMapping("/supplier/insert.do")
    public String supplierInsert(@ModelAttribute SupplierVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        partnerService.addSupplier(vo);
        return "redirect:/partner/supplier/list.do";
    }

    @PostMapping("/supplier/update.do")
    public String supplierUpdate(@ModelAttribute SupplierVO vo, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        partnerService.modifySupplier(vo);
        return "redirect:/partner/supplier/list.do";
    }

    @PostMapping("/supplier/deactivate.do")
    public String supplierDeactivate(@RequestParam Long supplierId, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        partnerService.removeSupplier(supplierId);
        return "redirect:/partner/supplier/list.do";
    }

    @GetMapping("/supplier/detail.do")
    @ResponseBody
    public String supplierDetail(@RequestParam Long supplierId, HttpSession session) {
        if (isNotLoggedIn(session)) return "UNAUTHORIZED";
        SupplierVO s = partnerService.getSupplier(supplierId);
        if (s == null) return "NOT_FOUND";
        return "{\"supplierId\":" + s.getSupplierId()
            + ",\"supplierName\":\"" + esc(s.getSupplierName()) + "\""
            + ",\"contact\":\""      + esc(s.getContact())      + "\""
            + ",\"phone\":\""        + esc(s.getPhone())         + "\""
            + ",\"address\":\""      + esc(s.getAddress())       + "\""
            + ",\"isActive\":"       + s.getIsActive()
            + "}";
    }

    /** 공급업체 거래 이력 페이지 */
    @GetMapping("/supplier/trades.do")
    public String supplierTrades(@RequestParam Long supplierId, Model model, HttpSession session) {
        if (isNotLoggedIn(session)) return "redirect:/login.do";
        SupplierVO supplier = partnerService.getSupplier(supplierId);
        if (supplier == null) return "redirect:/partner/supplier/list.do";
        model.addAttribute("supplier",   supplier);
        model.addAttribute("tradeList",  partnerService.getSupplierTradeList(supplierId));
        model.addAttribute("tradeCount", partnerService.getSupplierTradeCount(supplierId));
        return "partner/supplierTrades";
    }

    private String esc(String s) {
        return s == null ? "" : s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
