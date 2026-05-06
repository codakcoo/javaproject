package egovframework.approval.web;

import egovframework.approval.service.ApprovalService;
import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import egovframework.member.mapper.MemberMapper;
import egovframework.member.vo.MemberVO;
import egovframework.product.mapper.ProductMapper;
import egovframework.product.vo.ProductVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/approval")
public class ApprovalController {

    @Autowired private ApprovalService approvalService;
    @Autowired private ProductMapper   productMapper;
    @Autowired private MemberMapper    memberMapper;

    // ── 탭 카운트 공통 ─────────────────────────────
    private void addTabCounts(Model model) {
        try { model.addAttribute("tabCounts", approvalService.getStatusCounts()); }
        catch (Exception ignored) {}
    }

    // ── 전체 목록 ──────────────────────────────────
    @GetMapping("/list.do")
    public String approvalList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        addTabCounts(model);
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "all");
        return "approval/approvalList";
    }

    // ── 기안중 ─────────────────────────────────────
    @GetMapping("/pending.do")
    public String pendingList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        vo.setSearchStatus("PENDING");
        addTabCounts(model);
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "pending");
        return "approval/approvalList";
    }

    // ── 진행중 ─────────────────────────────────────
    @GetMapping("/inProgress.do")
    public String inProgressList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        vo.setSearchStatus("IN_PROGRESS");
        addTabCounts(model);
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "inProgress");
        return "approval/approvalList";
    }

    // ── 반려 ───────────────────────────────────────
    @GetMapping("/rejected.do")
    public String rejectedList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        vo.setSearchStatus("REJECTED");
        addTabCounts(model);
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "rejected");
        return "approval/approvalList";
    }

    // ── 결재 완료 ──────────────────────────────────
    @GetMapping("/approved.do")
    public String approvedList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        vo.setSearchStatus("APPROVED");
        addTabCounts(model);
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "approved");
        return "approval/approvalList";
    }

    // ── 상세 (팝업) ────────────────────────────────
    @GetMapping("/detail.do")
    public String approvalDetail(@RequestParam Long docId, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        model.addAttribute("doc", approvalService.getApproval(docId));
        return "approval/approvalDetail";
    }

    // ── 등록 폼 (팝업) ─────────────────────────────
    // ★ 핵심: 상품목록, 회원목록을 model에 담아 JSP로 전달
    @GetMapping("/form.do")
    public String approvalForm(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        // 상품 목록 (활성 상품만)
        ProductVO pvo = new ProductVO();
        pvo.setIsActive(1);
        List<ProductVO> productList = productMapper.selectProductList(pvo);
        model.addAttribute("productList", productList);

        // 회원 목록 (결재자 선택용)
        List<MemberVO> memberList = memberMapper.selectMemberList();
        model.addAttribute("memberList", memberList);

        return "approval/approvalForm";
    }

    // ── 등록 처리 ──────────────────────────────────
    @PostMapping("/insert.do")
    @ResponseBody
    public String approvalInsert(
            @ModelAttribute ApprovalDocVO vo,
            @RequestParam(value = "productId",   required = false) List<Long>   productIds,
            @RequestParam(value = "qty",         required = false) List<Double> qtys,
            @RequestParam(value = "unitCost",    required = false) List<Double> unitCosts,
            @RequestParam(value = "itemRemarks", required = false) List<String> itemRemarks,
            HttpSession session) {

        if (session.getAttribute("loginUser") == null) return "FAIL";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        vo.setRequesterId(loginUser.getMemberId());
        vo.setStatus("PENDING");

        if (productIds != null) {
            List<ApprovalDocItemVO> items = new ArrayList<>();
            for (int i = 0; i < productIds.size(); i++) {
                if (productIds.get(i) == null || productIds.get(i) == 0) continue;
                ApprovalDocItemVO item = new ApprovalDocItemVO();
                item.setProductId(productIds.get(i));
                item.setQty(qtys != null && i < qtys.size() ? qtys.get(i) : 0.0);
                item.setUnitCost(unitCosts != null && i < unitCosts.size() ? unitCosts.get(i) : null);
                item.setRemarks(itemRemarks != null && i < itemRemarks.size() ? itemRemarks.get(i) : null);
                items.add(item);
            }
            vo.setItems(items);
        }
        try {
            approvalService.addApproval(vo);
            return "OK";
        } catch (Exception e) {
            return "FAIL";
        }
    }

    // ── 검토 시작 (PENDING → IN_PROGRESS) ─────────
    @PostMapping("/startReview.do")
    @ResponseBody
    public String startReview(@RequestParam Long docId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "FAIL";
        approvalService.changeStatus(docId, "IN_PROGRESS", null, null);
        return "OK";
    }

    // ── 승인 ───────────────────────────────────────
    @PostMapping("/approve.do")
    @ResponseBody
    public String approveApproval(@RequestParam Long docId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "FAIL";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        approvalService.approveApproval(docId, loginUser.getMemberId());
        return "OK";
    }

    // ── 반려 ───────────────────────────────────────
    @PostMapping("/reject.do")
    @ResponseBody
    public String rejectApproval(@RequestParam Long docId,
                                 @RequestParam String rejectReason,
                                 HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "FAIL";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        approvalService.rejectApproval(docId, loginUser.getMemberId(), rejectReason);
        return "OK";
    }

    // ── 삭제 ───────────────────────────────────────
    @PostMapping("/delete.do")
    @ResponseBody
    public String deleteApproval(@RequestParam Long docId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "FAIL";
        approvalService.removeApproval(docId);
        return "OK";
    }
}
