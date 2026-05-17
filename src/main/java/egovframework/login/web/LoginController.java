package egovframework.login.web;

import egovframework.approval.service.ApprovalService;
import egovframework.approval.vo.ApprovalDocVO;
import egovframework.dept.service.DeptService;
import egovframework.member.mapper.MemberMapper;
import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import egovframework.product.mapper.ProductMapper;
import egovframework.product.vo.ProductVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import egovframework.dept.service.DeptService;
import java.util.List;
import java.util.Map;


@Controller
public class LoginController {

    @Autowired private MemberService   memberService;
    @Autowired private MemberMapper    memberMapper;
    @Autowired private ProductMapper   productMapper;
    @Autowired private ApprovalService approvalService;
    @Autowired private DeptService     deptService;

    @GetMapping("/login.do")
    public String loginForm() {
        return "login/loginForm";
    }

    @PostMapping("/loginProcess.do")
    public String loginProcess(@RequestParam("id") String id,
                               @RequestParam("pw") String pw,
                               HttpSession session, Model model) {
        MemberVO member = memberService.login(id, pw);
        if (member != null) {
            session.setAttribute("loginUser", member);
            return "redirect:/main.do";
        }
        model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
        return "login/loginForm";
    }

    @GetMapping("/main.do")
    public String mainPage(HttpSession session, Model model) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        try {
            List<MemberVO> memberList = memberMapper.selectMemberList();
            model.addAttribute("empCount", memberList != null ? memberList.size() : 0);

            ProductVO pvo = new ProductVO();
            pvo.setIsActive(1);
            int productCount = productMapper.selectProductList(pvo) != null
                    ? productMapper.selectProductList(pvo).size() : 0;
            model.addAttribute("productCount", productCount);

            Map<String, Object> tabCounts = approvalService.getStatusCounts();
            int pending    = tabCounts.get("pending")    != null ? ((Number) tabCounts.get("pending")).intValue()    : 0;
            int inProgress = tabCounts.get("inProgress") != null ? ((Number) tabCounts.get("inProgress")).intValue() : 0;
            model.addAttribute("pendingCount", pending + inProgress);
            model.addAttribute("monthOrderCount", 0);

            List lowStockList = productMapper.selectLowStockList();
            model.addAttribute("lowStockList", lowStockList);
            model.addAttribute("lowStockCount", lowStockList != null ? lowStockList.size() : 0);

            ApprovalDocVO searchVO = new ApprovalDocVO();
            List recentApprovals = approvalService.getApprovalList(searchVO);
            if (recentApprovals != null && recentApprovals.size() > 5) {
                recentApprovals = recentApprovals.subList(0, 5);
            }
            model.addAttribute("recentApprovals", recentApprovals);
        } catch (Exception e) {
            model.addAttribute("empCount",       0);
            model.addAttribute("productCount",   0);
            model.addAttribute("pendingCount",   0);
            model.addAttribute("monthOrderCount", 0);
            model.addAttribute("recentApprovals", null);
        }
        return "login/main";
    }

    @GetMapping("/register.do")
    public String registerForm(Model model) {
        model.addAttribute("deptList", deptService.getDeptList());
        return "login/register";
    }

    @PostMapping("/registerProcess.do")
    public String registerProcess(@ModelAttribute MemberVO member, Model model) {
        if (memberService.isDuplicateId(member.getMemberId())) {
            model.addAttribute("errorMsg", "이미 사용 중인 아이디입니다.");
            return "login/register";
        }
        memberService.register(member);
        return "redirect:/login.do";
    }

    @GetMapping("/logout.do")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login.do";
    }
}
