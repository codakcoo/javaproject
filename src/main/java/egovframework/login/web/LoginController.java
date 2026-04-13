package egovframework.login.web;

import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController 
{
	// 1. 로그인 화면 띄우기 (Get요청)
	@GetMapping("/login.do")
	public String loginForm()
	{
		// views 폴더 안의 loginForm.jsp를 찾아 화면에 뿌림
		return "login/loginForm";
	}
	
	// 2. 로그인 버튼 눌렀을 때 처리 (Post요청)
	@PostMapping("/loginProcess.do")
	public String LoginProcess(@RequestParam("id") String id,
							@RequestParam("pw") String pw,
							HttpSession session,
							Model model)
	{
		if("admin".equals(id) && "1234".equals(pw))
		{
			// 성공: 세션에 로그인 정보를 저장 (상태 유지)
			session.setAttribute("loginUser", id);
			return "redirect:/main.do";
		}
		else
		{
			// 실패: 에러 메시지를 Model에 담앙 다시 로그인 화면으로 보냄
			model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
			return "login/loginForm";
		}
	}
	
	// 3. 로그인 성공 시 보게 될 메인 페이지
	@GetMapping("/main.do")
	public String mainPage(HttpSession session)
	{
		// 세션에 'loginUser' 값이 있는지 확인
		String userId = (String)session.getAttribute("loginUser");
		
		if(userId == null)
		{
			// 로그인을 안 하고 주소창에 /main.do를 치고 들어온 경우 쫓아냄
			return "redirect:/login.do";
		}
		// main.jsp로 이동
		return "login/main";
	}
}
