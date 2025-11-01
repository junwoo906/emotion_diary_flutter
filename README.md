# 🎭 AI 감정 분석 다이어리 앱

**기연프 28조** - AI를 활용한 감정 분석 및 피드백 제공 다이어리 앱

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 프로젝트 개요

사용자가 작성한 일기를 AI가 분석하여 감정 상태를 파악하고, 개인화된 피드백을 제공하는 Flutter 앱입니다.

### 🎯 주요 기능
- 📝 **일기 작성**: 직관적인 UI로 하루 감정 기록
- 🤖 **AI 감정 분석**: 텍스트 기반 감정 상태 분석
- 📊 **감정 통계**: 시간대별 감정 변화 시각화
- 💬 **맞춤 피드백**: AI 기반 개인화된 조언 및 격려
- 🔐 **Google 로그인**: 안전한 사용자 인증 시스템

## 🏗️ 현재 구현 상태

### ✅ **완료된 기능** (2025.11.01)
- 🔐 **완전한 로그인 시스템**
  - Google OAuth 기반 인증
  - JWT 토큰 세션 관리
  - Mock 모드 지원 (백엔드 독립적 개발)
  - 로그인/로그아웃 플로우
  - 사용자 프로필 표시

### 🔄 **진행 예정** 
- 📡 FastAPI 백엔드 연동
- 📝 일기 CRUD 기능
- 🤖 AI 감정 분석 연동
- 📊 통계 및 차트 기능

## 🚀 빠른 시작

### 1️⃣ 프로젝트 클론 및 설정
```bash
git clone https://github.com/junwoo906/emotion_diary_flutter.git
cd emotion_diary_flutter
flutter pub get
```

### 2️⃣ 앱 실행
```bash
# Chrome에서 실행 (권장)
flutter run -d chrome

# Windows에서 실행 (개발자 모드 필요)
flutter run -d windows
```

### 3️⃣ 테스트 계정으로 로그인
- 앱 실행 후 **"테스트 로그인하기"** 버튼 클릭
- Mock 데이터로 전체 플로우 체험 가능

## 👥 팀 역할 분담

| 역할 | 담당자 | 상태 |
|------|--------|------|
| **Frontend (Flutter)** | junwoo906 | ✅ 로그인 시스템 완료 |
| **Backend (FastAPI)** | 팀원들 | 🔄 API 개발 중 |
| **AI 모델** | 팀원들 | 🔄 감정 분석 모델 개발 중 |

## 🔗 백엔드 팀을 위한 API 명세

### 📡 **필요한 API 엔드포인트**

#### 🔐 **인증 관련**
```http
POST /api/auth/google
Content-Type: application/json

# 요청
{
  "google_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6...",
  "access_token": "ya29.a0ARrdaM_abc123...",
  "name": "홍길동",
  "email": "user@example.com", 
  "profile_image": "https://example.com/avatar.jpg"
}

# 응답 (성공)
{
  "jwt_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": "user_123", 
    "name": "홍길동",
    "email": "user@example.com",
    "profile_image": "https://example.com/avatar.jpg"
  }
}

# 응답 (실패)
{
  "error": "invalid_token",
  "message": "Google 토큰이 유효하지 않습니다"
}
```

```http
POST /api/auth/refresh
Authorization: Bearer {jwt_token}

# 응답
{
  "jwt_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

#### 👤 **사용자 관련**
```http
GET /api/user/profile
Authorization: Bearer {jwt_token}

# 응답
{
  "id": "user_123",
  "name": "홍길동", 
  "email": "user@example.com",
  "profile_image": "https://example.com/avatar.jpg",
  "created_at": "2025-11-01T10:00:00Z",
  "diary_count": 15,
  "last_login": "2025-11-01T15:30:00Z"
}
```

#### 📝 **일기 관련**
```http
POST /api/diary
Authorization: Bearer {jwt_token}
Content-Type: application/json

# 요청
{
  "content": "오늘은 정말 좋은 하루였다. 친구들과 즐거운 시간을 보냈고...",
  "date": "2025-11-01T10:00:00Z"
}

# 응답
{
  "diary_id": 123,
  "content": "오늘은 정말 좋은 하루였다...",
  "date": "2025-11-01T10:00:00Z",
  "created_at": "2025-11-01T10:05:00Z",
  "user_id": "user_123"
}
```

```http
GET /api/diaries/recent?limit=5
Authorization: Bearer {jwt_token}

# 응답
{
  "diaries": [
    {
      "diary_id": 123,
      "content": "오늘은 정말 좋은 하루였다...",
      "date": "2025-11-01T10:00:00Z", 
      "emotion_summary": {
        "primary_emotion": "happiness",
        "confidence": 0.85
      }
    }
  ],
  "total_count": 15,
  "page": 1
}
```

```http
GET /api/diary/{diary_id}
Authorization: Bearer {jwt_token}

# 응답
{
  "diary_id": 123,
  "content": "오늘은 정말 좋은 하루였다...",
  "date": "2025-11-01T10:00:00Z",
  "created_at": "2025-11-01T10:05:00Z",
  "emotion_analysis": {
    "primary_emotion": "happiness",
    "emotion_scores": {
      "happiness": 0.85,
      "sadness": 0.05,
      "anger": 0.02,
      "fear": 0.03,
      "surprise": 0.05
    },
    "keywords": ["좋은", "하루", "친구", "즐거운"],
    "confidence_score": 0.92
  }
}
```

#### 🤖 **AI 감정 분석 관련**
```http
POST /api/emotion/analyze
Authorization: Bearer {jwt_token}
Content-Type: application/json

# 요청
{
  "diary_id": 123,
  "content": "오늘은 정말 좋은 하루였다..."
}

# 응답
{
  "analysis_id": "analysis_456",
  "diary_id": 123,
  "primary_emotion": "happiness",
  "emotion_scores": {
    "happiness": 0.85,
    "sadness": 0.05, 
    "anger": 0.02,
    "fear": 0.03,
    "surprise": 0.05
  },
  "keywords": ["좋은", "하루", "친구", "즐거운"],
  "confidence_score": 0.92,
  "analyzed_at": "2025-11-01T10:10:00Z"
}
```

```http
POST /api/feedback/generate
Authorization: Bearer {jwt_token}
Content-Type: application/json

# 요청
{
  "diary_id": 123,
  "emotion_analysis": {
    "primary_emotion": "happiness",
    "emotion_scores": {...}
  }
}

# 응답  
{
  "feedback_id": "feedback_789",
  "message": "긍정적인 감정이 잘 표현된 일기네요! 친구들과의 소중한 시간을 기록해주셔서 좋습니다.",
  "suggestions": [
    "이런 즐거운 순간들을 더 자주 만들어보세요",
    "감사한 마음을 표현하는 습관을 가져보세요"
  ],
  "mood_tips": "행복한 감정을 지속하기 위해 규칙적인 운동과 충분한 수면을 권합니다.",
  "generated_at": "2025-11-01T10:15:00Z"
}
```

#### 📊 **통계 관련**
```http
GET /api/statistics/weekly
Authorization: Bearer {jwt_token}

# 응답
{
  "period": {
    "start_date": "2025-10-26",
    "end_date": "2025-11-01"  
  },
  "emotion_distribution": {
    "happiness": 0.45,
    "sadness": 0.15,
    "anger": 0.10,
    "fear": 0.15,
    "surprise": 0.15
  },
  "daily_emotions": [
    {
      "date": "2025-10-26",
      "primary_emotion": "happiness",
      "average_score": 0.8,
      "diary_count": 1
    }
  ],
  "total_diaries": 7,
  "most_frequent_keywords": ["좋은", "하루", "친구"]
}
```

### 🔒 **인증 및 보안**

#### JWT 토큰 형식
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
```

#### 에러 응답 형식
```json
{
  "error": "error_code",
  "message": "사용자 친화적 에러 메시지",
  "details": "개발자용 상세 정보 (optional)"
}
```

#### HTTP 상태 코드
- `200`: 성공
- `201`: 생성 성공
- `400`: 잘못된 요청
- `401`: 인증 실패
- `403`: 권한 없음
- `404`: 리소스 없음
- `500`: 서버 에러

## 🛠️ 개발 환경 설정

### 📋 **요구 사항**
- Flutter SDK 3.9.2+
- Dart 3.9.2+
- Chrome 브라우저 (웹 테스트용)

### 📦 **주요 패키지**
```yaml
dependencies:
  google_sign_in: ^6.2.1      # Google 로그인
  shared_preferences: ^2.2.2   # 로컬 데이터 저장  
  http: ^1.1.0                # HTTP 통신
```

## 📁 프로젝트 구조

```
lib/
├── main.dart                 # 메인 앱 + 라우팅
├── models/
│   └── user.dart             # 사용자 데이터 모델
├── services/  
│   └── auth_service.dart     # 인증 서비스 (Mock + Real 모드)
├── screens/
│   └── login_screen.dart     # 로그인 화면
└── widgets/
    └── auth_wrapper.dart     # 인증 상태 관리 위젯
```

## 🧪 테스트 방법

### 1️⃣ **현재 테스트 (Mock 모드)**
```bash
flutter run -d chrome
```
- ✅ 로그인 화면 → 테스트 로그인 → 홈 화면 이동
- ✅ 사용자 프로필 정보 표시
- ✅ 로그아웃 → 로그인 화면 복귀
- ✅ 앱 재시작 후 로그인 상태 유지

### 2️⃣ **백엔드 연동 후 테스트**
`lib/services/auth_service.dart`에서 설정 변경:
```dart
static const bool _isTestMode = false; // true → false
```

## 🤝 백엔드 팀과의 협업

### 🔄 **현재 상황**
- ✅ **프론트엔드**: 로그인 시스템 완료
- 🔄 **백엔드**: API 엔드포인트 개발 필요
- 🔄 **AI**: 감정 분석 모델 개발 필요

### 📞 **협의 필요 사항**
1. **API 베이스 URL**: 개발/스테이징/프로덕션 환경
2. **JWT 토큰 스펙**: 만료 시간, 갱신 정책
3. **Google OAuth**: 서버에서 토큰 검증 방식
4. **CORS 설정**: Flutter 웹 지원
5. **에러 처리**: 표준 에러 코드 및 메시지

### 🚀 **연동 준비 완료**
프론트엔드는 백엔드 API가 준비되는 즉시 연동 가능한 상태입니다!

## 📞 문의 및 지원

- **프론트엔드 담당**: [@junwoo906](https://github.com/junwoo906)
- **프로젝트 이슈**: [GitHub Issues](https://github.com/junwoo906/emotion_diary_flutter/issues)
- **개발 가이드**: [agent.md](./agent.md)

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.
