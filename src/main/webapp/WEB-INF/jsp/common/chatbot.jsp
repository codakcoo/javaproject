<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ================================================================
     chatbot.jsp  –  우하단 플로팅 챗봇 위젯
     사용법: header.jsp 의 </body> 바로 위에 아래 한 줄 추가
       <%@ include file="/WEB-INF/jsp/common/chatbot.jsp" %>
================================================================ --%>

<style>
/* ── 플로팅 버튼 ──────────────────────────────────────────────── */
#chatbotFab {
    position: fixed;
    bottom: 28px; right: 28px;
    width: 52px; height: 52px;
    background: #2563EB;
    border: none; border-radius: 50%;
    box-shadow: 0 4px 16px rgba(37,99,235,0.45);
    cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    z-index: 9000;
    transition: transform 0.2s, box-shadow 0.2s;
}
#chatbotFab:hover {
    transform: scale(1.08);
    box-shadow: 0 6px 22px rgba(37,99,235,0.55);
}
#chatbotFab svg { width: 26px; height: 26px; fill: #fff; }

/* ── 채팅 패널 ──────────────────────────────────────────────── */
#chatbotPanel {
    position: fixed;
    bottom: 90px; right: 28px;
    width: 360px;
    max-height: 520px;
    background: #fff;
    border: 1px solid #E2E8F0;
    border-radius: 16px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.14);
    display: none;
    flex-direction: column;
    z-index: 8999;
    overflow: hidden;
    font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
}
#chatbotPanel.open { display: flex; }

/* 헤더 */
#chatbotPanel .cb-head {
    background: #2563EB;
    padding: 14px 16px;
    display: flex; align-items: center; justify-content: space-between;
    flex-shrink: 0;
}
#chatbotPanel .cb-head-title {
    color: #fff; font-size: 14px; font-weight: 700;
    display: flex; align-items: center; gap: 8px;
}
#chatbotPanel .cb-head-title svg { width: 18px; height: 18px; fill: #fff; }
#chatbotPanel .cb-close {
    background: transparent; border: none; cursor: pointer;
    color: rgba(255,255,255,0.8); font-size: 20px; line-height: 1; padding: 0;
}
#chatbotPanel .cb-close:hover { color: #fff; }

/* 메시지 영역 */
#chatbotMessages {
    flex: 1;
    overflow-y: auto;
    padding: 14px;
    display: flex; flex-direction: column; gap: 10px;
    background: #F8FAFC;
}
/* 말풍선 공통 */
.cb-msg {
    max-width: 82%;
    padding: 9px 13px;
    border-radius: 12px;
    font-size: 13px;
    line-height: 1.55;
    word-break: break-word;
    white-space: pre-wrap;
}
/* 사용자 말풍선 */
.cb-msg.user {
    background: #2563EB; color: #fff;
    align-self: flex-end;
    border-bottom-right-radius: 3px;
}
/* 봇 말풍선 */
.cb-msg.bot {
    background: #fff; color: #1E293B;
    align-self: flex-start;
    border: 1px solid #E2E8F0;
    border-bottom-left-radius: 3px;
}
/* 로딩 점 애니메이션 */
.cb-msg.loading::after {
    content: '';
    display: inline-block;
    width: 6px; height: 6px;
    background: #94A3B8;
    border-radius: 50%;
    animation: cbDot 1.2s infinite;
    margin-left: 4px;
    vertical-align: middle;
}
@keyframes cbDot {
    0%, 80%, 100% { opacity: 0; transform: scale(0.6); }
    40%           { opacity: 1; transform: scale(1); }
}

/* 빠른 질문 버튼 */
.cb-quick-wrap {
    padding: 8px 14px 4px;
    display: flex; flex-wrap: wrap; gap: 6px;
    background: #F8FAFC;
    flex-shrink: 0;
    border-top: 1px solid #E2E8F0;
}
.cb-quick {
    background: #EFF6FF; color: #2563EB;
    border: 1px solid #BFDBFE;
    border-radius: 20px;
    padding: 4px 10px;
    font-size: 11px; font-family: inherit;
    cursor: pointer;
    transition: background 0.15s;
}
.cb-quick:hover { background: #DBEAFE; }

/* 입력 영역 */
.cb-input-wrap {
    padding: 10px 12px;
    display: flex; gap: 8px; align-items: flex-end;
    border-top: 1px solid #E2E8F0;
    background: #fff;
    flex-shrink: 0;
}
#chatbotInput {
    flex: 1;
    border: 1px solid #CBD5E1;
    border-radius: 10px;
    padding: 8px 12px;
    font-size: 13px; font-family: inherit;
    resize: none;
    outline: none;
    line-height: 1.4;
    max-height: 90px;
    overflow-y: auto;
}
#chatbotInput:focus { border-color: #2563EB; }
#chatbotSend {
    width: 36px; height: 36px;
    background: #2563EB; border: none; border-radius: 10px;
    cursor: pointer; display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
    transition: background 0.15s;
}
#chatbotSend:hover { background: #1D4ED8; }
#chatbotSend svg { width: 18px; height: 18px; fill: #fff; }
#chatbotSend:disabled { background: #94A3B8; cursor: not-allowed; }

/* 모바일 반응형 */
@media (max-width: 480px) {
    #chatbotPanel { width: calc(100vw - 32px); right: 16px; bottom: 80px; }
    #chatbotFab   { bottom: 20px; right: 16px; }
}
</style>

<!-- ▼ 플로팅 버튼 -->
<button id="chatbotFab" onclick="toggleChatbot()" title="ERP 챗봇">
    <svg viewBox="0 0 24 24"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/></svg>
</button>

<!-- ▼ 채팅 패널 -->
<div id="chatbotPanel">
    <!-- 헤더 -->
    <div class="cb-head">
        <div class="cb-head-title">
            <svg viewBox="0 0 24 24"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
            ERP 데이터 분석 챗봇
        </div>
        <button class="cb-close" onclick="toggleChatbot()">✕</button>
    </div>

    <!-- 메시지 목록 -->
    <div id="chatbotMessages">
        <div class="cb-msg bot">안녕하세요! ERP 데이터 분석 챗봇입니다 😊<br>주문내역, 날짜별 거래, 가격 추이, 베스트셀러 등을 물어보세요.</div>
    </div>

    <!-- 빠른 질문 버튼 -->
    <div class="cb-quick-wrap">
        <button class="cb-quick" onclick="sendQuick('최근 주문내역 10건 알려줘')">📋 최근 주문</button>
        <button class="cb-quick" onclick="sendQuick('이번 달 날짜별 거래 현황을 알려줘')">📅 날짜별 거래</button>
        <button class="cb-quick" onclick="sendQuick('가장 잘 팔린 상품 TOP 5 알려줘')">🏆 베스트셀러</button>
        <button class="cb-quick" onclick="sendQuick('상품 가격 추이를 알려줘')">💰 가격 추이</button>
        <button class="cb-quick" onclick="sendQuick('재고 부족 상품 알려줘')">⚠️ 재고 부족</button>
        <button class="cb-quick" onclick="sendQuick('ERP 전체 현황 요약해줘')">📊 전체 현황</button>
    </div>

    <!-- 입력창 -->
    <div class="cb-input-wrap">
        <textarea id="chatbotInput"
                  placeholder="질문을 입력하세요..."
                  rows="1"
                  onkeydown="handleCbKey(event)"
                  oninput="autoResizeCb(this)"></textarea>
        <button id="chatbotSend" onclick="sendChatMessage()">
            <svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
        </button>
    </div>
</div>

<script>
(function () {
    var _isOpen = false;

    window.toggleChatbot = function () {
        _isOpen = !_isOpen;
        var panel = document.getElementById('chatbotPanel');
        panel.classList.toggle('open', _isOpen);
        if (_isOpen) {
            document.getElementById('chatbotInput').focus();
            scrollToBottom();
        }
    };

    window.sendQuick = function (text) {
        document.getElementById('chatbotInput').value = text;
        sendChatMessage();
    };

    window.handleCbKey = function (e) {
        // Enter: 전송 / Shift+Enter: 줄바꿈
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendChatMessage();
        }
    };

    window.autoResizeCb = function (el) {
        el.style.height = 'auto';
        el.style.height = Math.min(el.scrollHeight, 90) + 'px';
    };

    window.sendChatMessage = function () {
        var input   = document.getElementById('chatbotInput');
        var sendBtn = document.getElementById('chatbotSend');
        var question = input.value.trim();
        if (!question) return;

        // 사용자 말풍선 추가
        appendMsg('user', question);
        input.value = '';
        input.style.height = 'auto';
        sendBtn.disabled = true;

        // 로딩 말풍선
        var loadingId = 'cb-loading-' + Date.now();
        appendMsg('bot loading', '답변을 생성 중입니다', loadingId);
        scrollToBottom();

        // AJAX 요청
        var xhr = new XMLHttpRequest();
        var ctx = getContextPath();
        xhr.open('POST', ctx + '/chat/ask.do', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== 4) return;
            // 로딩 말풍선 제거
            var lm = document.getElementById(loadingId);
            if (lm) lm.parentNode.removeChild(lm);
            sendBtn.disabled = false;

            if (xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText);
                    appendMsg('bot', data.answer || '응답이 없습니다.');
                } catch (e) {
                    appendMsg('bot', '응답 파싱 오류가 발생했습니다.');
                }
            } else {
                appendMsg('bot', '서버 오류가 발생했습니다. (' + xhr.status + ')');
            }
            scrollToBottom();
        };
        xhr.send('question=' + encodeURIComponent(question));
    };

    function appendMsg(cssClass, text, id) {
        var msgs = document.getElementById('chatbotMessages');
        var div  = document.createElement('div');
        div.className = 'cb-msg ' + cssClass;
        div.textContent = text;
        if (id) div.id = id;
        msgs.appendChild(div);
    }

    function scrollToBottom() {
        var msgs = document.getElementById('chatbotMessages');
        msgs.scrollTop = msgs.scrollHeight;
    }

    function getContextPath() {
        // JSP에서 contextPath를 JS 변수로 노출해주는 것이 가장 안전하지만,
        // 없는 경우 location.pathname 에서 추론
        if (typeof window._ctxPath !== 'undefined') return window._ctxPath;
        var path = window.location.pathname;
        var parts = path.split('/');
        return parts.length > 1 ? '/' + parts[1] : '';
    }
})();
</script>
