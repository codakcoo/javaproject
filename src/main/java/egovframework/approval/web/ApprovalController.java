package egovframework.approval.web;

import egovframework.approval.service.ApprovalService;
import egovframework.approval.vo.ApprovalDocVO;
import egovframework.approval.vo.ApprovalDocItemVO;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/approval")
public class ApprovalController {

    @Autowired
    private ApprovalService approvalService;

    // ══════════════════════════════════════════
    // 총 결재 목록 (전체)
    // ══════════════════════════════════════════
    @GetMapping("/list.do")
    public String approvalList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        // searchStatus 없으면 전체 조회
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "all");
        return "approval/approvalList";
    }

    // ══════════════════════════════════════════
    // 요청 목록 (PENDING)
    // ══════════════════════════════════════════
    @GetMapping("/pending.do")
    public String pendingList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        vo.setSearchStatus("PENDING");
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "pending");
        return "approval/approvalList";
    }

    // ══════════════════════════════════════════
    // 반려 목록 (REJECTED)
    // ══════════════════════════════════════════
    @GetMapping("/rejected.do")
    public String rejectedList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        vo.setSearchStatus("REJECTED");
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "rejected");
        return "approval/approvalList";
    }

    // ══════════════════════════════════════════
    // 완료 목록 (APPROVED)
    // ══════════════════════════════════════════
    @GetMapping("/approved.do")
    public String approvedList(@ModelAttribute ApprovalDocVO vo, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        vo.setSearchStatus("APPROVED");
        model.addAttribute("docList",    approvalService.getApprovalList(vo));
        model.addAttribute("totalCount", approvalService.getApprovalCount(vo));
        model.addAttribute("searchVO",   vo);
        model.addAttribute("activeTab",  "approved");
        return "approval/approvalList";
    }

    // ══════════════════════════════════════════
    // 상세 조회 (팝업)
    // ══════════════════════════════════════════
    @GetMapping("/detail.do")
    public String approvalDetail(@RequestParam Long docId, Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        model.addAttribute("doc", approvalService.getApproval(docId));
        return "approval/approvalDetail";
    }

    // ══════════════════════════════════════════
    // 결재 문서 등록 폼
    // ══════════════════════════════════════════
    @GetMapping("/form.do")
    public String approvalForm(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "approval/approvalForm";
    }

    // ══════════════════════════════════════════
    // 결재 문서 등록 처리
    // ══════════════════════════════════════════
    @PostMapping("/insert.do")
    public String approvalInsert(@ModelAttribute ApprovalDocVO vo,
                                 @RequestParam(value = "productId",  required = false) List<Long>   productIds,
                                 @RequestParam(value = "qty",        required = false) List<Double> qtys,
                                 @RequestParam(value = "unitCost",   required = false) List<Double> unitCosts,
                                 @RequestParam(value = "itemRemarks",required = false) List<String> itemRemarks,
                                 HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";

        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        vo.setRequesterId(loginUser.getMemberId());

        // 상품 라인 세팅
        if (productIds != null) {
            List<ApprovalDocItemVO> items = new java.util.ArrayList<>();
            for (int i = 0; i < productIds.size(); i++) {
                if (productIds.get(i) == null) continue;
                ApprovalDocItemVO item = new ApprovalDocItemVO();
                item.setProductId(productIds.get(i));
                item.setQty(qtys != null && i < qtys.size() ? qtys.get(i) : 0.0);
                item.setUnitCost(unitCosts != null && i < unitCosts.size() ? unitCosts.get(i) : null);
                item.setRemarks(itemRemarks != null && i < itemRemarks.size() ? itemRemarks.get(i) : null);
                items.add(item);
            }
            vo.setItems(items);
        }

        approvalService.addApproval(vo);
        return "redirect:/approval/list.do";
    }

    // ══════════════════════════════════════════
    // 요청 처리 (DRAFT → PENDING)
    // ══════════════════════════════════════════
    @PostMapping("/request.do")
    public String requestApproval(@RequestParam Long docId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        approvalService.requestApproval(docId);
        return "redirect:/approval/pending.do";
    }

    // ══════════════════════════════════════════
    // 승인 처리 (PENDING → APPROVED)
    // ══════════════════════════════════════════
    @PostMapping("/approve.do")
    public String approveApproval(@RequestParam Long docId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        approvalService.approveApproval(docId, loginUser.getMemberId());
        return "redirect:/approval/approved.do";
    }

    // ══════════════════════════════════════════
    // 반려 처리 (PENDING → REJECTED)
    // ══════════════════════════════════════════
    @PostMapping("/reject.do")
    public String rejectApproval(@RequestParam Long docId,
                                 @RequestParam String rejectReason,
                                 HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        approvalService.rejectApproval(docId, loginUser.getMemberId(), rejectReason);
        return "redirect:/approval/rejected.do";
    }

    // ══════════════════════════════════════════
    // 삭제 (DRAFT만 가능)
    // ══════════════════════════════════════════
    @PostMapping("/delete.do")
    public String deleteApproval(@RequestParam Long docId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        approvalService.removeApproval(docId);
        return "redirect:/approval/list.do";
    }
}