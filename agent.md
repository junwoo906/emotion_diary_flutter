# 🎭 AI 감정 분석 다이어리 앱 - 개발 가이드

## 📋 프로젝트 개요
- **프로젝트명**: Emotion Diary Flutter
- **팀**: 기연프 28조
- **역할 분담**: 
  - **Frontend (Flutter)**: junwoo906
  - **Backend (FastAPI)**: 팀원들
  - **AI 모델**: 팀원들
- **목표**: AI를 활용한 감정 분석 및 피드백 제공 다이어리 앱

## 🏗️ 현재 구현 상태

### ✅ 완료된 기능
- [x] 기본 UI 구조 (홈, 일기작성, 감정분석 화면)
- [x] 네비게이션 시스템
- [x] 일기 작성 UI
- [x] 감정 분석 결과 표시 화면
- [x] **🔐 사용자 인증 시스템 (Google 로그인) - 2025.11.01 완료**
  - [x] Google Sign-In 패키지 추가 (`google_sign_in: ^6.2.1`)
  - [x] SharedPreferences 패키지 추가 (`shared_preferences: ^2.2.2`)
  - [x] HTTP 통신 패키지 추가 (`http: ^1.1.0`)
  - [x] User 모델 클래스 구현 (`lib/models/user.dart`)
  - [x] AuthService 클래스 구현 (`lib/services/auth_service.dart`)
  - [x] 로그인 화면 UI 구현 (`lib/screens/login_screen.dart`)
  - [x] AuthWrapper 위젯 구현 (`lib/widgets/auth_wrapper.dart`)
  - [x] 사용자 세션 관리 (JWT 토큰 로컬 저장)
  - [x] 홈 화면 사용자 정보 표시 및 로그아웃 기능
  - [x] 완전한 라우팅 시스템 구축
  - [x] **🧪 Mock 모드 지원**: 백엔드 없이도 완전한 테스트 가능

### 🔄 진행 중인 기능 (우선순위 높음)
- [ ] **FastAPI 백엔드 연동**
  - [ ] HTTP 패키지 추가 (`http: ^1.1.0`)
  - [ ] ApiService 클래스 구현 (JWT 토큰 포함)
  - [ ] FastAPI 스웨거 문서 확인 및 모델 클래스 생성
  - [ ] 일기 저장/불러오기 API (사용자별)
  - [ ] AI 감정 분석 API 연동
- [ ] **데이터 모델링**
  - [ ] Diary 모델 클래스
  - [ ] EmotionAnalysis 모델 클래스
  - [ ] JSON 직렬화/역직렬화
- [ ] **로컬 데이터베이스**
  - [ ] SQLite 설정 (`sqflite: ^2.3.0`)
  - [ ] DatabaseHelper 구현
  - [ ] 오프라인 데이터 저장
- [ ] **통계 및 시각화**
  - [ ] 차트 라이브러리 추가 (`fl_chart: ^0.65.0`)
  - [ ] 감정 변화 차트
  - [ ] 주간/월간 통계 화면

## 🚀 추후 구현 예정 기능 (낮은 우선순위)

### 📊 고급 시각화
- [ ] **키워드 클라우드**
  - 일기에서 추출된 키워드들을 시각적으로 표현
  - 감정과 연관된 단어들의 빈도수 분석
  - 시간대별 키워드 변화 추적

### 🔔 알림 및 개인화
- [ ] **일기 작성 알림**
  - 매일 특정 시간 알림 설정
  - 며칠간 작성하지 않았을 때 리마인더
  - 사용자 패턴 학습 기반 맞춤 알림
- [ ] **개인화된 피드백**
  - 사용자별 감정 패턴 분석
  - AI 기반 맞춤 조언 및 격려 메시지
  - 감정 개선 제안사항
- [ ] **목표 설정 및 추적**
  - 감정 관리 목표 설정 (예: 긍정적 감정 70% 유지)
  - 목표 달성률 추적
  - 성취 배지 및 보상 시스템

### 🎤 음성 입력 기능
- [ ] **음성 인식**
  - `speech_to_text` 패키지 활용
  - 실시간 음성-텍스트 변환
  - 음성 품질 최적화
- [ ] **음성 감정 분석**
  - 텍스트뿐만 아니라 음성 톤 분석
  - 말하는 속도, 톤으로 감정 상태 파악
  - 멀티모달 감정 분석 (텍스트 + 음성)

## 🛠️ 기술 스택

### Frontend (Flutter) - 내 담당 영역
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # ✅ 설치 완료된 패키지
  google_sign_in: ^6.2.1    # Google 로그인 (Firebase 없이)
  shared_preferences: ^2.2.2 # JWT 토큰 로컬 저장
  http: ^1.1.0              # API 통신
  
  # 추후 추가 예정
  sqflite: ^2.3.0           # 로컬 데이터베이스
  fl_chart: ^0.65.0         # 차트 라이브러리
  speech_to_text: ^6.6.0    # 음성 인식
  flutter_local_notifications: ^16.3.0 # 로컬 알림
  provider: ^6.1.1          # 상태 관리
```

### 📝 Firebase 없는 로그인 구조 선택 (2025.11.01)
**결정 사항**: Firebase 대신 **FastAPI + JWT 토큰** 방식 채택
**이유**: 
- 백엔드 팀의 FastAPI 서버와 중복 투자 방지
- Google OAuth → FastAPI JWT 토큰 교환 방식
- 단순하고 통합된 백엔드 구조
- 비용 절약 및 높은 자유도

### Backend (FastAPI) - 팀원들 담당 영역
**예상 API 엔드포인트** (백엔드 팀과 협의 필요):
```python
# FastAPI 서버 구조 예상
# 인증 관련
POST /api/auth/google         # Google OAuth 토큰 검증
POST /api/auth/refresh        # JWT 토큰 갱신
DELETE /api/auth/logout       # 로그아웃

# 사용자 관련
GET  /api/user/profile        # 사용자 프로필 정보
PUT  /api/user/profile        # 프로필 업데이트

# 일기 관련 (모든 요청에 JWT 토큰 필요)
POST /api/diary              # 일기 저장
GET  /api/diaries/recent     # 최근 일기 목록
GET  /api/diary/{diary_id}   # 특정 일기 조회
PUT  /api/diary/{diary_id}   # 일기 수정
DELETE /api/diary/{diary_id} # 일기 삭제

# AI 감정 분석 관련
POST /api/emotion/analyze    # 감정 분석 요청
GET  /api/emotion/today      # 오늘의 감정
POST /api/feedback/generate  # AI 피드백 생성

# 통계 관련
GET  /api/statistics/weekly  # 주간 통계
GET  /api/statistics/monthly # 월간 통계
```

## 📁 폴더 구조 현황

```
lib/
├── main.dart                     # ✅ 메인 앱 + 라우팅 구조 완료
├── models/
│   └── user.dart                 # ✅ 완료 - 사용자 모델
├── services/
│   └── auth_service.dart         # ✅ 완료 - 인증 서비스 (Mock + Real 모드)
├── screens/
│   └── login_screen.dart         # ✅ 완료 - 로그인 화면 (애니메이션 포함)
├── widgets/
│   └── auth_wrapper.dart         # ✅ 완료 - 인증 상태 관리 위젯
└── utils/                        # 추후 추가 예정
```

### 🚧 추후 추가할 파일들
```
lib/
├── models/
│   ├── diary_model.dart
│   ├── emotion_analysis.dart
│   └── user_settings.dart
├── services/
│   ├── api_service.dart
│   ├── database_helper.dart
│   ├── notification_service.dart
│   └── speech_service.dart
├── screens/
│   ├── statistics_screen.dart
│   ├── settings_screen.dart
│   └── voice_input_screen.dart
├── widgets/
│   ├── emotion_chart.dart
│   ├── diary_card.dart
│   ├── keyword_cloud.dart
│   └── custom_app_bar.dart
└── utils/
    ├── constants.dart
    ├── helpers.dart
    └── validators.dart
```

## 🎯 개발 로드맵

### Phase 1: 핵심 기능 구현 (2-3주) - **50% 완료**
1. **✅ 사용자 인증 시스템 구축 (완료 - 2025.11.01)**
   - ✅ Google 로그인 UI 및 로직 구현
   - ✅ JWT 토큰 기반 사용자 세션 관리
   - ✅ Mock 모드로 백엔드 없이도 완전 테스트 가능
   - ✅ 로그인/로그아웃 플로우 완성
   - ✅ 사용자 프로필 정보 표시
2. **🔄 FastAPI 백엔드 연동 (진행 예정)**
   - [ ] 팀원들이 만든 API 엔드포인트와 연결
   - [x] JWT 토큰 기반 인증 구조 준비 완료
   - [ ] JSON 응답 파싱 및 에러 처리
   - **⚙️ AuthService에서 `_isTestMode = false`로 전환하면 즉시 연동 가능**
3. **로컬 데이터베이스 구축**
   - [ ] SQLite 설정 및 사용자 ID 기반 데이터 저장
4. **실제 데이터 기반 UI 개선**

### Phase 2: 고급 기능 추가 (3-4주)
1. 차트 및 시각화 완성
2. 오프라인 모드 지원
3. 사용자 설정 및 개인화
4. 성능 최적화

### Phase 3: 부가 기능 (추후)
1. 음성 입력 기능
2. 키워드 클라우드
3. 알림 시스템
4. 고급 개인화 기능

## 🐛 알려진 이슈 및 수정사항

### ✅ 해결된 문제들 (2025.11.01)
1. **MaterialApp 라우팅 충돌 해결**
   - 문제: `home`과 `routes['/'']` 중복으로 앱 크래시
   - 해결: `home` 제거하고 `initialRoute`로 변경

### 수정 필요한 부분
1. **홈 화면의 하드코딩된 데이터**
   - 현재: 정적 감정 데이터 표시
   - 수정: API에서 실시간 데이터 가져오기

2. **최근 일기 목록**
   - 현재: 더미 데이터 사용
   - 수정: 실제 데이터베이스 연동

3. **감정 분석 결과**
   - 현재: 하드코딩된 분석 결과
   - 수정: 실제 AI 분석 결과 표시

### 🧪 현재 테스트 방법 (Mock 모드)
```bash
# Chrome에서 실행 (권장)
flutter run -d chrome

# Windows에서 실행 (개발자 모드 필요)
flutter run -d windows
```

### 🚀 백엔드 연동 준비 완료
**AuthService 실제 모드 전환 방법:**
```dart
// lib/services/auth_service.dart 파일에서
static const bool _isTestMode = false; // true → false로 변경
```

## 📝 개발 노트

### 중요 고려사항
- **사용자 인증**: Google OAuth 2.0 기반 안전한 로그인
- **데이터 보안**: JWT 토큰 기반 API 인증, 사용자별 데이터 분리
- **오프라인 모드**: 로그인 후 인터넷 연결 없이도 일기 작성 가능
- **개인정보 보호**: 민감한 일기 데이터 암호화 저장
- **사용자 경험**: 직관적이고 감정적으로 편안한 UI/UX
- **성능**: 대량의 일기 데이터 처리 최적화
- **계정 동기화**: 여러 기기에서 같은 계정으로 데이터 동기화

### 팀 협업 사항
**🔥 우선순위 높음 - 백엔드 팀과 협의 필요:**
- **API 스펙 정의**: FastAPI 스웨거 문서 확인 필요
- **인증 방식**: Google OAuth + JWT 토큰 처리 방식
- **데이터 모델**: 요청/응답 JSON 스키마 정의
- **에러 처리**: HTTP 상태 코드 및 에러 메시지 포맷
- **CORS 설정**: Flutter 웹 버전 고려한 CORS 정책

**AI 팀과 협의 사항:**
- **감정 분석 결과 포맷**: JSON 응답 구조
- **분석 시간**: 실시간 vs 배치 처리
- **신뢰도 점수**: UI에 표시할 confidence score

**개발 환경 설정:**
- **API 베이스 URL**: 개발/스테이징/프로덕션 환경별
- **테스트 데이터**: 개발 중 사용할 더미 데이터

### 테스트 계획
- Unit Test: 모델 클래스, 유틸리티 함수
- Widget Test: 주요 화면 컴포넌트
- Integration Test: API 연동, 데이터베이스 CRUD

## 🤝 백엔드 팀과 협업 체크리스트

### 즉시 필요한 정보
- [ ] **API 베이스 URL**: FastAPI 서버 주소
- [ ] **스웨거 문서**: `/docs` 엔드포인트 확인
- [ ] **인증 스키마**: Google OAuth 토큰 처리 방식
- [ ] **에러 응답 포맷**: 표준 에러 메시지 구조

### API 테스트 방법
```bash
# FastAPI 서버 실행 확인
curl -X GET "http://localhost:8000/docs"

# 헬스체크 엔드포인트
curl -X GET "http://localhost:8000/health"
```

### 데이터 모델 예시 (협의 필요)
```json
// 일기 생성 요청
{
  "content": "오늘은 정말 좋은 하루였다...",
  "date": "2025-11-01T10:00:00Z"
}

// 감정 분석 응답
{
  "diary_id": 123,
  "primary_emotion": "happiness",
  "emotion_scores": {
    "happiness": 0.85,
    "sadness": 0.10,
    "anger": 0.05
  },
  "keywords": ["좋은", "하루", "행복"],
  "confidence_score": 0.92,
  "ai_feedback": "긍정적인 감정이 잘 표현된 일기네요!"
}
```

## 🎉 **2025.11.01 작업 완료 사항**

### ✅ **로그인 시스템 완전 구현**
1. **패키지 설치**: `google_sign_in`, `shared_preferences`, `http`
2. **User 모델 클래스**: JSON 직렬화/역직렬화 완료
3. **AuthService**: Mock 모드 + 실제 연동 준비 완료
4. **LoginScreen**: 아름다운 애니메이션 + UX
5. **AuthWrapper**: 로그인 상태 자동 관리
6. **홈 화면 업그레이드**: 사용자 정보 + 로그아웃 기능
7. **완전한 라우팅**: 조건부 화면 전환

### 🧪 **테스트 완료된 기능들**
- ✅ 앱 시작 → 로그인 화면 표시
- ✅ Mock 로그인 → 2초 로딩 → 홈 화면 이동  
- ✅ 사용자 환영 메시지 및 프로필 정보
- ✅ 프로필 메뉴 → 정보 보기/로그아웃
- ✅ 로그인 상태 유지 (새로고침 후에도)

### 🚀 **즉시 가능한 백엔드 연동**
AuthService에서 `_isTestMode = false`로 변경하면:
- Google OAuth → FastAPI JWT 토큰 교환
- 모든 API 호출에 JWT 토큰 자동 포함
- 에러 처리 및 재인증 로직 완비

---

**마지막 업데이트**: 2025년 11월 1일 - 로그인 시스템 완료 🎉
**현재 상태**: Phase 1 50% 완료 (인증 시스템 완료)
**다음 우선순위**: FastAPI 백엔드 연동
**백엔드 팀 미팅**: JWT 토큰 스펙 및 API 엔드포인트 확정