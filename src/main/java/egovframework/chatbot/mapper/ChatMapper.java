package egovframework.chatbot.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

/**
 * 챗봇용 데이터 조회 Mapper
 * - 주문내역, 날짜별 거래, 가격추이, 베스트셀러, 재고 현황, ERP 요약
 */
@Mapper
public interface ChatMapper {

    /** 최근 N건 주문내역 */
    List<Map<String, Object>> selectRecentOrders(int limit);

    /** 최근 N일 날짜별 주문 건수 및 합계 금액 */
    List<Map<String, Object>> selectDailyOrderSummary(int days);

    /** 상품 가격 정보 (최근 등록/수정순) */
    List<Map<String, Object>> selectPriceHistory(int limit);

    /** 판매량 기준 베스트셀러 TOP N */
    List<Map<String, Object>> selectBestSellers(int limit);

    /** 재고 현황 전체 요약 */
    List<Map<String, Object>> selectStockSummary();

    /** ERP 전체 현황 수치 요약 (대시보드용) */
    Map<String, Object> selectErpSummary();
    /** 결재 대기/진행중 문서 */
    List<Map<String, Object>> selectPendingApprovals();

    /** 결재 현황 통계 */
    Map<String, Object> selectApprovalStats();

    /** 재고 입출고 내역 */
    List<Map<String, Object>> selectStockHistory(int limit);

    /** 부서별 급여 합계 */
    List<Map<String, Object>> selectSalarySummary();

    /** 부서별 인원 현황 */
    List<Map<String, Object>> selectDeptHeadcount();
    
}
