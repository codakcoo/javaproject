package egovframework.hr.web;

import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.List;
import egovframework.dept.service.DeptService;
import egovframework.dept.vo.DeptVO;

@Controller
@RequestMapping("/hr")
public class HrController {

    @Autowired
    private MemberService memberService;
    @Autowired
    private DeptService deptService;

    /** 직원 목록 (DB 연동) */
    @GetMapping("/list.do")
    public String empList(
            @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
            @RequestParam(value="deptId", required=false, defaultValue="") String deptId,
            Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        MemberVO searchVO = new MemberVO();
        searchVO.setKeyword(keyword);
        searchVO.setDeptId(deptId);
        List<MemberVO> empList = memberService.getEmpList(searchVO);
        model.addAttribute("empList", empList);
        model.addAttribute("keyword", keyword);
        model.addAttribute("deptId", deptId);
        return "hr/empList";
    }

    /** 직원 등록 폼 */
    @GetMapping("/insertForm.do")
    public String insertForm(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        return "hr/empForm";
    }

    /** 직원 수정 폼 */
    @GetMapping("/updateForm.do")
    public String updateForm(@RequestParam("memberId") String memberId,
                             Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        MemberVO member = memberService.getMemberById(memberId);
        model.addAttribute("member", member);
        model.addAttribute("deptList", deptService.getDeptList());
        return "hr/empUpdateForm";
    }
        return "hr/empUpdateForm";
    }

    /** 직원 수정 처리 */
    @PostMapping("/update.do")
    public String update(@ModelAttribute MemberVO member, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        memberService.updateMember(member);
        return "redirect:/hr/list.do";
    }

    /** 직원 삭제 처리 */
    @PostMapping("/delete.do")
    public String delete(@RequestParam("memberId") String memberId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        memberService.deleteMember(memberId);
        return "redirect:/hr/list.do";
    }

    /** 가입 승인 관리 목록 */
    @GetMapping("/approval.do")
    public String approvalList(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        List<MemberVO> pendingList = memberService.getPendingList();
        model.addAttribute("pendingList", pendingList);
        return "hr/memberApproval";
    }

    /** 승인 처리 */
    @PostMapping("/approve.do")
    public String approve(@RequestParam("memberId") String memberId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        memberService.updateMemberStatus(memberId, "ACTIVE");
        return "redirect:/hr/approval.do";
    }

    /** 거절 처리 */
    @PostMapping("/reject.do")
    public String reject(@RequestParam("memberId") String memberId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        memberService.updateMemberStatus(memberId, "REJECTED");
        return "redirect:/hr/approval.do";
    }
}