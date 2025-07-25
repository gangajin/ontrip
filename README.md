## 📌 프로젝트 이름
<span>
On:Trip - AI 여행 일정 생성 서비스
<img src="src/main/resources/static/Image/header/logo.png" width="50px" style="vertical-align:middle;"/>
</span>



## 1️⃣ 프로젝트 개요

### 📚 소개
이 프로젝트는 여행 일정을 쉽게 계획하지 못 하는 분들을 위해서 AI를 통해서 자동으로 일정을 게획해주는 웹 애플리케이션입니다.

### 🛠️ 기술 스택
<ul>
  <li><b>Frontend</b>
    <ul>
      <li>JavaScript, HTML5, CSS3</li>
    </ul>
  </li>
  <li><b>Backend</b>
    <ul>
      <li>Java (JDK 21), JSP & Servlet, MyBatis</li>
    </ul>
  </li>
  <li><b>Framework / Library</b>
    <ul>
      <li>Spring Boot, Flatpickr, JavaMail</li>
    </ul>
  </li>
  <li><b>API / External Service</b>
    <ul>
      <li>OpenAI API, Kakao Maps API, 행정안전부 공공 API, OAuth(Google, Kakao, Naver)</li>
    </ul>
  </li>
  <li><b>Database</b>
    <ul>
      <li>MySQL, ER Diagram</li>
    </ul>
  </li>
  <li><b>Tool / Environment</b>
    <ul>
      <li>Eclipse STS (Spring Tool Suite), MySQL Workbench, Windows 11, WAS (Apache Tomcat 10.1)</li>
    </ul>
  </li>
  <li><b>Collaboration</b>
    <ul>
      <li>GitHub</li>
    </ul>
  </li>
</ul>

### 👥 팀원 및 담당 역할
- **공통 역할**: DB설계, 메인화면, AI 일정 생성
- **이강진**: 관리자 페이지, 마이페이지, 여행갈 장소 등록(step2), 비회원 문의
- **박상준**: 문의사항 , 숙소 선택, 장소 등록, 여행 일정 확인
- **류지호**: 날짜 및 시간 선택, 회원 관리 및 소셜 로그인(OAuth), 개인정보 수정


## 2️⃣ 설치 및 실행 방법
### 📥 Git clone
    git clone https://github.com/on-trip/ontrip.git
  
    cd ontrip

### ⚙️ 환경설정
1️⃣ MySQL에 ontrip 데이터베이스를 생성합니다.

2️⃣ src/main/resources/application.properties 파일에 DB 접속 정보를 아래와 같이 설정합니다.

    spring.datasource.url=jdbc:mysql://localhost:3306/ontrip

    spring.datasource.username=DB_USERNAME

    spring.datasource.password=DB_PASSWORD

3️⃣ OpenAI API Key, Kakao API Key 등 외부 서비스 키를 application.properties에 추가합니다.

    openai.api.key=YOUR_OPENAI_API_KEY 

    kakao.api.key=YOUR_KAKAO_API_KEY

### ▶️ 빌드 및 실행
아래 명령어로 애플리케이션을 빌드하고 실행합니다.

    ./gradlew build

    ./gradlew bootRun

✅ 실행 후 웹 브라우저에서 http://localhost:8080에 접속해 서비스를 확인하세요.

## 3️⃣ 주요 기능 및 화면
### ✨핵심 주요 기능
<ul>
  <li><b>AI 기반 여행 일정 자동 생성</b>
    <ul>
      <li>사용자가 선택한 여행 기간, 지역, 장소 데이터를 기반으로 OpenAI API를 활용해 일정을 자동으로 생성합니다.</li>
    </ul>
  </li>
  <li><b>여행 기간 선택 및 캘린더 UI</b>
    <ul>
      <li>Flatpickr 라이브러리를 이용한 달력 UI로 여행 시작일과 종료일을 선택할 수 있습니다.</li>
    </ul>
  </li>
  <li><b>장소 및 숙소 선택 (카카오 지도 연동)</b>
    <ul>
      <li>카카오 지도 API와 연동해 사용자가 원하는 장소, 숙소를 검색하고 지도에서 위치를 확인하며 선택할 수 있습니다.</li>
    </ul>
  </li>
  <li><b>여행 일정 저장 및 시각화</b>
    <ul>
      <li>선택한 일정과 숙소 정보를 저장하고, 생성된 일정 화면에서 일정 시간 변경 및 확인이 가능합니다.</li>
    </ul>
  </li>
</ul>

### 💫 부가 주요 기능
<ul>
  <li><b>소셜 로그인(OAuth)</b>
    <ul>
      <li>일반 회원가입 및 로그인, 소셜 로그인 지원(카카오, 네이버, 구글)</li>
    </ul>
  </li>
  <li><b>이메일 전송 후 비밀번호 변경</b>
    <ul>
      <li>JavaMail API로 인증 메일을 발송해 사용자가 비밀번호를 재설정할 수 있도록 지원합니다.</li>
    </ul>
  </li>

  <li><b>문의 사항</b>
    <ul>
      <li>사용자가 문의사항을 등록하고, 관리자 답변을 확인할 수 있습니다.</li>
    </ul>
  </li>

  <li><b>마이페이지</b>
    <ul>
      <li>닉네임 변경</li>
      <li>회원 탈퇴</li>
      <li>작성 중인 여행 계획 조회 및 삭제</li>
      <li>완료된 여행 일정 조회</li>
    </ul>
  </li>

  <li><b>관리자 기능</b>
    <ul>
      <li>문의 내역 확인 및 답변</li>
      <li>장소 등록</li>
      <li>장소 목록 관리</li>
      <li>회원 관리(휴면 ,정상 ,탈퇴)</li>
    </ul>
  </li>

</ul>

### 🖥️ 화면 구현 설명

<details>
<summary>🗓 메인 화면</summary>

- AI 여행 일정 생성 시작 화면으로, 여행 지역과 기간을 입력할 수 있음  
<img src="src/main/resources/static/Image/capture/main.png" alt="메인 화면"/>

</details>

<details>
<summary>📅 날짜 선택(캘린더) 화면</summary>

- 캘린더로 여행 날짜를 선택하고 일정 기간을 설정할 수 있음  
<img src="src/main/resources/static/Image/capture/calendar.png" alt="날짜 선택 화면"/>

</details>

<details>
<summary>🗺️ 지역·날짜 확인 화면</summary>

- 앞에서 선택한 여행 지역과 날짜를 한눈에 확인 가능  
<img src="src/main/resources/static/Image/capture/step1.png" alt="스텝1"/>

</details>

<details>
<summary>📍 명소·식당·카페 선택 화면</summary>

- 명소, 식당, 카페를 선택하고 지도에서 위치를 한눈에 확인 가능  
<img src="src/main/resources/static/Image/capture/step2.png" alt="스텝2"/>

</details>

<details>
<summary>🏨 숙소 선택 화면</summary>

- 여행 날짜별로 숙소를 선택하고 지도에서 위치 확인 가능  
<img src="src/main/resources/static/Image/capture/step3.png" alt="숙소 선택"/>

</details>

<details>
<summary>🗂 일정 상세 화면</summary>

- 선택한 일정과 명소, 식당, 카페, 숙소 등을 확인할 수 있음  
<img src="src/main/resources/static/Image/capture/stepPlan.png" alt="일정 상세"/>

</details>

<details>
<summary>✅ AI 생성 일정 확인 화면</summary>

- AI가 생성한 여행 계획을 날짜별로 확인하고, 각 일차별 동선도 지도에서 시각적으로 확인 가능  
<img src="src/main/resources/static/Image/capture/AiPlan2.png" alt="AI 생성 일정"/>

</details>


## 4️⃣ DB 설계 및 테이블 정보
### 🗂️ ERD 이미지
![ERDiagram](src/main/resources/static/Image/capture/ERDiagram.png)

#### 🧩 테이블 설명
##### 1. `destination` — 여행지 정보 테이블
- 한국어/영어 이름, 위도/경도, 이미지, 소개 등 여행지의 기본 정보를 저장합니다.

---

##### 2. `inquiry` — 문의사항 테이블
- 사용자 문의의 제목, 내용, 상태(`대기`/`완료`), 작성 시각, 작성자 정보를 저장합니다.

---

##### 3. `passwordtoken` — 비밀번호 재설정용 토큰 테이블
- 비밀번호 초기화를 위한 토큰, 사용자 ID, 생성 시간을 저장합니다.

---

##### 4. `place` — 장소 정보 테이블
- 장소명, 카테고리(`명소`, `식당`, `카페`, `호텔`, `기차역`), 주소, 위도/경도, 평점 등을 저장합니다.  
- `destinationNum`을 통해 특정 여행지와 연결됩니다.

---

##### 5. `plan` — 개별 일정 정보 테이블
- 일정 중 특정 날짜에 방문할 장소를 저장합니다.  
- Step2의 `placeList`에서 `+` 버튼 클릭 시 저장됩니다.

---

##### 6. `reply` — 문의 댓글(답변) 테이블
- 문의에 대한 관리자 또는 사용자 답변을 저장합니다.  
- `parentReplyNum`을 통해 대댓글 기능도 지원됩니다.

---

##### 7. `schedule` — 여행 일정 테이블
- 일정의 시작일/종료일, 생성일, 작성자, 상태(`작성중`/`완성`), 목적지 정보를 저장합니다.

---

##### 8. `scheduledetail` — 일정 상세 테이블 (요일별 계획)
- AI가 생성한 하루 단위의 여행 일정을 저장합니다.  
- 방문 장소 순서 및 메모 정보도 포함됩니다.

---

##### 9. `stayhotel` — 숙소 투숙 정보 테이블
- 일정 중 투숙 날짜별 호텔 정보를 저장합니다.

---

##### 10. `user` — 회원 정보 테이블
- 사용자 ID, 비밀번호, 닉네임, 가입일, 권한(`user`/`admin`), 계정 상태(`정상`, `잠금`, `휴면`, `탈퇴`), 소셜 로그인 정보를 저장합니다.


## 5️⃣ 업데이트 및 버전 관리
 ### 📅 개발 기간
 2025.06.06 ~ 2025.07.01

### 주요 작업 내역

  - ERD 설계 및 DB 스키마 작성

  - 예약 및 장소 관리 기능 개발

  - 명소/식당/카페/숙소 선택 기능 구현

  - 날짜별 숙소 선택 및 일정 시간 변경 및 저장 기능 완성

  - AI 여행 일정 생성 기능 개발

  - OpenAI API 연동 및 응답 파싱 로직 구축

  - Kakao Maps API 연동으로 지도 기반 동선 시각화

  - 소셜 로그인(OAuth) 기능 추가

  - 전체 UI 디자인 개선

  - 주요 오류 수정 및 기능 안정화


## 6️⃣ PPT 자료
[👉 Ontrip 자료 다운로드 (Google Drive)](https://drive.google.com/file/d/1KeNt7N2KBka2UqxzCbYXlJLEPfWNa-MT/view?usp=sharing)
  - ontrip.sql을 MySQL에 붙여넣기 하여 DB사용가능
