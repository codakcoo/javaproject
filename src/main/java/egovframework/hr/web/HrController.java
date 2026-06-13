package egovframework.hr.web;

import egovframework.member.service.MemberService;
import egovframework.member.vo.MemberVO;
import egovframework.salary.service.SalaryService;
import egovframework.salary.vo.SalaryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import egovframework.dept.service.DeptService;
import egovframework.dept.vo.DeptVO;

@Controller
@RequestMapping("/hr")
public class HrController {

    @Autowired
    private MemberService memberService;
    @Autowired
    private SalaryService salaryService;
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
        model.addAttribute("deptList", deptService.getDeptList());
        return "hr/empList";
    }

    /** 직원 등록 폼 */
    @GetMapping("/insertForm.do")
    public String insertForm(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        model.addAttribute("deptList", deptService.getDeptList());
        return "hr/empForm";
    }
    
    /** 직원 등록 처리 */

    @PostMapping("/insert.do")
    public String insertEmp(MemberVO member, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        try {
            member.setStatus("ACTIVE"); // 관리자 직접 등록은 바로 ACTIVE
            member.setRole("USER");
            memberService.insertMember(member);

            // salary 자동 생성
            if (salaryService.getSalaryByMemberId(member.getMemberId()) == null) {
                SalaryVO salary = new SalaryVO();
                salary.setMemberId(member.getMemberId());
                salary.setPayYear(LocalDate.now().getYear());
                salary.setPayMonth(LocalDate.now().getMonthValue());
                salaryService.saveSalary(salary);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/hr/list.do";
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

    /** 직원 수정 처리 */
    @PostMapping("/update.do")
    public String update(@ModelAttribute MemberVO member, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        try {
            memberService.updateMember(member);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/hr/list.do";
    }

    /** 직원 삭제 처리 (논리 삭제 - status = RESIGN) */
    @PostMapping("/delete.do")
    public String delete(@RequestParam("memberId") String memberId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        try {
            memberService.deleteMember(memberId);
        } catch (Exception e) {
            e.printStackTrace();
        }
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

        // ★ 급여 레코드 자동 생성 (없는 경우에만)
        try {
            if (salaryService.getSalaryByMemberId(memberId) == null) {
                SalaryVO salary = new SalaryVO();
                salary.setMemberId(memberId);
                salary.setPayYear(LocalDate.now().getYear());
                salary.setPayMonth(LocalDate.now().getMonthValue());
                salaryService.saveSalary(salary);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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