<h1>자바 프로젝트</h1>


<p><strong>버전</strong>: 전자정부프레임워크 4.3</p>
<p><strong>서버</strong>: Tomcat 9.0v</p>
<p><strong>DB</strong>:   MySQL</p>
<hr style="border: 0; height: 2px; background: black; width: 50%;">

<h2>Java/Spring MVC2 팀 프로젝트 협업 가이드</h2>
본 저장소는 전자정부프레임워크(eGovFrame) 기반의 웹 애플리케이션(ERP 시스템 등) 개발을 위한 캡스톤 프로젝트 저장소입니다. 원활한 팀 협업을 위해 아래의 Git 명령어와 규칙을 반드시 숙지하고 개발을 진행해 주세요.


<h3> 📌 1. 팀 협업 기본 원칙 (매우 중요) </h3>

<p>우리 프로젝트의 `main` 브랜치는 완벽하게 작동하는 베이스캠프입니다. 시스템 보호를 위해 **`main` 브랜치에 직접 코드를 올리는 것(Push)은 금지되어 있습니다.**</p>

<p>1. 무조건 본인의 기능 이름으로 **새 브랜치를 생성**하여 작업합니다. (예: `feature/login`, `update-page`)</p>
<p>2. 작업이 완료되면 깃허브 웹사이트에서 팀장에게 **Pull Request(PR)** 를 요청합니다.</p>
<p>3. 팀장의 코드 리뷰 및 **승인(Approve)** 이 완료되어야만 `main`에 코드가 병합(Merge)됩니다.</p>


<br>
<h3>💻 2. 단계별 핵심 Git 명령어</h3>

<h4>[1단계] 프로젝트 처음 시작할 때 (최초 1회)</h4>
<p>저장소의 코드를 내 PC(이클립스 워크스페이스)로 통째로 가져옵니다.</p>
<strong>git 명령어</strong>
<p>git clone https://github.com/codakcoo/javaproject.git</p>
<p>참고: 이클립스에서 가져올 때는 Import -> Existing Maven Projects 로 불러와야 합니다.</p>

<br>
<h4>[2단계] 내 작업 시작하기 (브랜치 생성)</h4>
<p>가져온 폴더 안으로 이동(cd javaproject)한 후, 내 작업방을 만들고 이동합니다.</p>
<p>최신 상태 업데이트 후, 새로운 브랜치 생성 및 이동</p>
<p>git pull origin main</p>
<p>git checkout -b feature/내기능이름</p>

<br>
<h4>[3단계] 코드 저장 및 업로드</h4>
<p>기능 개발이 끝났거나 중간 저장이 필요할 때 깃허브로 코드를 쏘아 올립니다.</p>

<p>git add . </p>
<p>git commit -m "feat: OOO 기능 구현 및 폼 UI 완성" </p>
<p>git push origin feature/내기능이름 </p>

<br>
<h4>[4단계] 다른 팀원이 올린 최신 코드 반영하기</h4>
<p>내 코드를 짜기 전, 또는 작업 중간에 수시로 main의 최신 상태를 내 컴퓨터로 가져옵니다.</p>

<p>git checkout main</p>
<p>git pull origin main</p>

<br>
<h3>🗑️ 3. .gitignore 설정 및 캐시 초기화 (충돌 방지)</h3>
<p>이클립스 개인 설정 파일(.classpath, .project 등)이 깃허브에 올라가면 팀원 간 Merge Conflict(병합 충돌) 가 발생합니다. 만약 이미 찌꺼기 파일이 깃허브에 올라갔다면, 아래 명령어를 통해 Git의 기억을 지우고 블랙리스트를 다시 적용해야 합니다.</p>

<p><strong>[Git 캐시 삭제 및 .gitignore 재적용 명령어]</strong></p>

<p>1. Git의 추적 목록에서 파일들 임시 삭제 (실제 파일은 지워지지 않음)</p>
<p>git rm -r --cached . </p>

<p>2. .gitignore가 적용된 상태로 순수 소스코드만 다시 장바구니에 담기</p>
<p>git add .</p>

<p>3. 확정 도장 찍기</p>
<p>git commit -m "chore: gitignore 세팅 및 불필요한 설정 파일 캐시 삭제"</p>

<p>4. 깃허브에 올리기</p>
<p>git push origin 현재브랜치명</p>

<br>
<h3>💡 4. 자주 겪는 에러 및 해결법 </h3>
<p>fatal: not a git repository</p>
<p>원인: 현재 터미널 위치가 프로젝트 폴더(.git이 있는 곳) 내부가 아닙니다.</p>
<p>해결: cd 폴더명 명령어로 프로젝트 내부로 한 칸 들어갑니다.</p>
<br>
<p>fatal: 'origin' does not appear to be a git repository</p>
<p>원인: 깃허브 서버 주소(origin) 연결이 끊어졌습니다.</p>
<p>해결: git remote add origin https://github.com/codakcoo/javaproject.git 입력하여 재연결.</p>

<br>
<h4>추신</h4>
<p>깃(Git)이 이 주소록을 컴퓨터의 임시 기억 장치(RAM)에 잠깐 외워두는 것이 아니라, 프로젝트 폴더 안의 숨겨진 파일에 진짜 텍스트로 꾹꾹 눌러 적어둔다.</p>
<p>실제로 어디에 적혀있는지 직접 두 눈으로 확인해 보실 수 있다.</p>
<p>방금 작업하시던 프로젝트 폴더 안을 봅니다. (윈도우 탐색기에서 '숨긴 항목 보기'가 켜져 있어야 합니다.)</p>
<p>.git 이라는 이름의 폴더가 있습니다. 그 안으로 들어갑니다.</p>
<p>config 라는 이름의 파일이 있습니다. 이 파일을 마우스 우클릭해서 '메모장'으로 열어보세요.</p>
<p></p>그러면 파일 안에 아래와 같은 내용이 또렷하게 적혀있는 것을 보실 수 있습니다.</p>
<p>[remote "origin"]</p>
<p>&emsp;url = https://github.com/codakcoo/javaproject.git</p>
<p>&emsp;fetch = +refs/heads/*:refs/remotes/origin/*<p></p>


<br>
<hr style="border: 0; height: 2px; background: black; width: 50%;">
<h3>git 명령어</h3>
<img width="843" height="267" alt="image" src="https://github.com/user-attachments/assets/be1bdd6d-1825-4af9-ad4c-3139c090c884" />
<hr style="border: 0; height: 2px; background: black; width: 50%;">
<h3>진행상황</h3>
<h5>로그인 화면</h5>
<img width="1904" height="1071" alt="image" src="https://github.com/user-attachments/assets/518b20ac-a3de-4fdf-8279-5b3fae7a2d70" />
<h5>회원가입 화면</h5>
<img width="1904" height="1071" alt="image" src="https://github.com/user-attachments/assets/7e765dd5-61d0-47ba-81d5-e02c08e6b2d5" />






