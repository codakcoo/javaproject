package egovframework.chatbot.web;
import egovframework.chatbot.mapper.ChatMapper;
import egovframework.member.vo.MemberVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

/**
 * 챗봇 Controller  (Gemini API 버전)
 * POST /chat/ask.do  →  DB 데이터를 조회해 Gemini API에 전달 후 답변 반환
 */
@Controller
@RequestMapping("/chat")
public class ChatController {
	
	// ── Gemini API 설정 ──────────────────────────────────────────
	// API 키는 DB의 app_config 테이블에서 가져옵니다.
	// 팀원이 DB에 키 삽입: INSERT INTO app_config VALUES ('gemini.api.key', 'AIzaSy...키값...');
	private final String GEMINI_MODEL = "gemini-2.5-flash-lite";

	/** DB에서 Gemini API 키 조회 */
	private String getApiKey() {
	    try {
	        return chatMapper.selectConfig("gemini.api.key");
	    } catch (Exception e) {
	        return null;
	    }
	}
    // 엔드포인트 (키를 URL 파라미터로 전달)
  

    @Autowired
    private ChatMapper chatMapper;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 챗봇 질문 처리
     */
    @PostMapping("/ask.do")
    @ResponseBody
    public String ask(@RequestParam("question") String question,
                      HttpSession session) {

        if (session.getAttribute("loginUser") == null) {
            return "{\"answer\":\"로그인이 필요합니다.\"}";
        }

        try {
            // ── 1. DB 데이터 수집 ───────────────────────────────
            String dbContext = buildDbContext(question);
            

            // ── 2. Gemini API 호출 ──────────────────────────────
            String systemPrompt =
                "당신은 ERP 시스템의 데이터 분석 어시스턴트입니다. " +
                "아래의 실시간 DB 데이터를 기반으로 사용자의 질문에 한국어로 간결하고 정확하게 답변하세요. " +
                "숫자는 천 단위 구분자(쉼표)를 사용하고, 금액은 '원' 단위로 표기하세요. " +
                "유해한 답변들은 대답할 수 없다고 얘기하세요."+
                "데이터가 없을 경우 '해당 데이터가 없습니다'라고 답하세요.\n\n" +
                "=== 현재 ERP 데이터 ===\n" + dbContext;

            String answer = callGemini(systemPrompt, question);
            return "{\"answer\":" + objectMapper.writeValueAsString(answer) + "}";

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"answer\":\"오류가 발생했습니다: " + escapeJson(e.getMessage()) + "\"}";
        }
    }

    // ── DB 데이터 수집 ────────────────────────────────────────────
    private String buildDbContext(String question) {
        StringBuilder sb = new StringBuilder();
        String q = question.toLowerCase();

        
     // 결재 관련
        if (containsAny(q, "결재", "기안", "승인", "반려", "진행중", "대기")) {
            try {
                Map<String, Object> stats = chatMapper.selectApprovalStats();
                if (stats != null) {
                    sb.append("[이번달 결재 현황]\n");
                    sb.append(String.format("- 대기: %s건, 진행중: %s건, 승인: %s건, 반려: %s건\n",
                        nvl(stats.get("pending_count")), nvl(stats.get("progress_count")),
                        nvl(stats.get("approved_count")), nvl(stats.get("rejected_count"))));
                }
                List<Map<String, Object>> pending = chatMapper.selectPendingApprovals();
                sb.append("[결재 대기/진행중 문서]\n");
                for (Map<String, Object> row : pending) {
                    sb.append(String.format("- [%s] %s | 요청자: %s | %s\n",
                        nvl(row.get("status")), nvl(row.get("title")),
                        nvl(row.get("requester_id")), nvl(row.get("created_at"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 입출고 관련
        if (containsAny(q, "입고", "출고", "입출고", "재고이동")) {
            try {
                List<Map<String, Object>> history = chatMapper.selectStockHistory(20);
                sb.append("[최근 입출고 내역]\n");
                for (Map<String, Object> row : history) {
                    sb.append(String.format("- [%s] %s: %s개, %.0f원 | %s\n",
                        nvl(row.get("doc_type")), nvl(row.get("product_name")),
                        nvl(row.get("qty")), toDouble(row.get("amount")),
                        nvl(row.get("order_date"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 급여 관련
        if (containsAny(q, "급여", "월급", "연봉", "페이", "salary")) {
            try {
                List<Map<String, Object>> salary = chatMapper.selectSalarySummary();
                sb.append("[이번달 부서별 급여 현황]\n");
                for (Map<String, Object> row : salary) {
                    sb.append(String.format("- %s: %s명, 기본급 %.0f원, 실수령 %.0f원\n",
                        nvl(row.get("dept_name")), nvl(row.get("emp_count")),
                        toDouble(row.get("total_base")), toDouble(row.get("total_net"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 인사 관련
        if (containsAny(q, "인사", "직원", "부서", "인원", "headcount")) {
            try {
                List<Map<String, Object>> dept = chatMapper.selectDeptHeadcount();
                sb.append("[부서별 인원 현황]\n");
                for (Map<String, Object> row : dept) {
                    sb.append(String.format("- %s: 총 %s명 (재직 %s명)\n",
                        nvl(row.get("dept_name")), nvl(row.get("headcount")),
                        nvl(row.get("active_count"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }
        // 주문내역
        if (containsAny(q, "주문", "영수증", "거래내역", "order")) {
            try {
                List<Map<String, Object>> rows = chatMapper.selectRecentOrders(10);
                sb.append("[최근 주문내역 (최근 10건)]\n");
                for (Map<String, Object> row : rows) {
                    sb.append(String.format("- %s | %s | %s | %.0f원\n",
                        nvl(row.get("receipt_no")), nvl(row.get("doc_type")),
                        nvl(row.get("partner_name")), toDouble(row.get("total_amount"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 날짜별 거래
        if (containsAny(q, "날짜", "일별", "월별", "기간", "언제", "추이", "trend")) {
            try {
                List<Map<String, Object>> rows = chatMapper.selectDailyOrderSummary(30);
                sb.append("[최근 30일 날짜별 거래 현황]\n");
                for (Map<String, Object> row : rows) {
                    sb.append(String.format("- %s: %s건, 합계 %.0f원\n",
                        nvl(row.get("order_date")), nvl(row.get("order_count")),
                        toDouble(row.get("total_amount"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 가격 추이
        if (containsAny(q, "가격", "단가", "원가", "price", "cost", "추이", "변동")) {
            try {
                List<Map<String, Object>> rows = chatMapper.selectPriceHistory(20);
                sb.append("[상품 가격 정보 (최근 20개)]\n");
                for (Map<String, Object> row : rows) {
                    sb.append(String.format("- %s(%s): %.0f원 [%s]\n",
                        nvl(row.get("product_name")), nvl(row.get("product_code")),
                        toDouble(row.get("unit_cost")), nvl(row.get("created_at"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 베스트셀러
        if (containsAny(q, "베스트", "best", "많이 팔", "인기", "top", "순위", "판매량")) {
            try {
                List<Map<String, Object>> rows = chatMapper.selectBestSellers(10);
                sb.append("[판매 상위 상품 TOP 10]\n");
                int rank = 1;
                for (Map<String, Object> row : rows) {
                    sb.append(String.format("%d. %s: 총 %.0f개 판매, 매출 %.0f원\n",
                        rank++, nvl(row.get("product_name")),
                        toDouble(row.get("total_qty")), toDouble(row.get("total_amount"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 재고
        if (containsAny(q, "재고", "stock", "inventory", "부족", "창고")) {
            try {
                List<Map<String, Object>> rows = chatMapper.selectStockSummary();
                sb.append("[재고 현황]\n");
                for (Map<String, Object> row : rows) {
                    sb.append(String.format("- %s(%s): %.0f%s [창고:%s]\n",
                        nvl(row.get("product_name")), nvl(row.get("product_code")),
                        toDouble(row.get("qty_on_hand")), nvl(row.get("unit")),
                        nvl(row.get("warehouse_name"))));
                }
                sb.append("\n");
            } catch (Exception ignored) {}
        }

        // 아무 키워드도 없으면 전체 요약
        if (sb.length() == 0) {
            try {
                Map<String, Object> summary = chatMapper.selectErpSummary();
                if (summary != null) {
                    sb.append("[ERP 전체 현황 요약]\n");
                    sb.append(String.format("- 전체 상품 수: %s개\n",       nvl(summary.get("product_count"))));
                    sb.append(String.format("- 이번 달 주문 건수: %s건\n",   nvl(summary.get("month_order_count"))));
                    sb.append(String.format("- 이번 달 총 거래금액: %.0f원\n", toDouble(summary.get("month_total"))));
                    sb.append(String.format("- 재고 부족 상품: %s개\n",      nvl(summary.get("low_stock_count"))));
                    sb.append(String.format("- 결재 대기 건수: %s건\n",      nvl(summary.get("pending_count"))));
                }
            } catch (Exception ignored) {}
        }

        return sb.length() > 0 ? sb.toString() : "현재 조회 가능한 데이터가 없습니다.";
    }

    // ── Gemini API 호출 ───────────────────────────────────────────
    private String callGemini(String systemPrompt, String userMessage) throws Exception {
        int maxRetry = 3;
        for (int i = 0; i < maxRetry; i++) {
            try {
            	return callGeminiOnce(systemPrompt, userMessage);
            } catch (RuntimeException e) {
                if (e.getMessage() != null && e.getMessage().contains("503") && i < maxRetry - 1) {
                    Thread.sleep(2000 * (i + 1)); // 2초, 4초
                } else {
                    throw e;
                }
            }
        }
        return "잠시 후 다시 시도해주세요.";
    }

    private String callGeminiOnce(String systemPrompt, String userMessage) throws Exception {
        String requestBody = "{"
            + "\"system_instruction\":{\"parts\":[{\"text\":"
            + objectMapper.writeValueAsString(systemPrompt) + "}]},"
            + "\"contents\":[{\"parts\":[{\"text\":"
            + objectMapper.writeValueAsString(userMessage) + "}]}]"
            + "}";
        String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/"
                + "gemini-2.5-flash-lite" + ":generateContent";

        URL url = new URL(apiUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setRequestProperty("Authorization", "Bearer " + getApiKey());
        con.setDoOutput(true);
        con.setConnectTimeout(10000);
        con.setReadTimeout(30000);

        try (OutputStream os = con.getOutputStream()) {
            os.write(requestBody.getBytes(StandardCharsets.UTF_8));
        }

        int status = con.getResponseCode();
        System.out.println("### Gemini 상태: " + status); // ← 추가

        InputStream is = (status == 200) ? con.getInputStream() : con.getErrorStream();
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        System.out.println("### Gemini 응답: " + sb.toString()); // ← 추가

        if (status != 200) {
            throw new RuntimeException("Gemini API 오류 (" + status + "): " + sb);
        }

        @SuppressWarnings("unchecked")
        Map<String, Object> resp = objectMapper.readValue(sb.toString(), Map.class);
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> candidates = (List<Map<String, Object>>) resp.get("candidates");
        if (candidates != null && !candidates.isEmpty()) {
            @SuppressWarnings("unchecked")
            Map<String, Object> content = (Map<String, Object>) candidates.get(0).get("content");
            if (content != null) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");
                if (parts != null && !parts.isEmpty()) {
                    Object text = parts.get(0).get("text");
                    return text != null ? text.toString() : "응답을 받지 못했습니다.";
                }
            }
        }
        return "응답을 받지 못했습니다";
    }

    // ── 유틸 ──────────────────────────────────────────────────────
    private boolean containsAny(String text, String... keywords) {
        for (String kw : keywords) {
            if (text.contains(kw)) return true;
        }
        return false;
    }
    private String nvl(Object val)    { return val == null ? "-" : val.toString(); }
    private double toDouble(Object val) {
        if (val == null) return 0;
        try { return Double.parseDouble(val.toString()); } catch (Exception e) { return 0; }
    }
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
