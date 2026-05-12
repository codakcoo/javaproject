package egovframework.dept.web;

import egovframework.dept.service.DeptService;
import egovframework.dept.vo.DeptVO;
import egovframework.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/dept")
public class DeptController {

    @Autowired
    private DeptService deptService;

    /** 부서 목록 */
    @GetMapping("/list.do")
    public String deptList(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        List<DeptVO> deptList = deptService.getDeptList();
        model.addAttribute("deptList", deptList);
        return "dept/deptList";
    }

    /** 부서 추가 처리 */
    @PostMapping("/insert.do")
    public String insertDept(@ModelAttribute DeptVO dept, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        deptService.insertDept(dept);
        return "redirect:/dept/list.do";
    }

    /** 부서 수정 처리 */
    @PostMapping("/update.do")
    public String updateDept(@ModelAttribute DeptVO dept, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        deptService.updateDept(dept);
        return "redirect:/dept/list.do";
    }

    /** 부서 삭제 처리 */
    @PostMapping("/delete.do")
    public String deleteDept(@RequestParam("deptId") String deptId, HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login.do";
        deptService.deleteDept(deptId);
        return "redirect:/dept/list.do";
    }
}
