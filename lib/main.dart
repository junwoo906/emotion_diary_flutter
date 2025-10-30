import 'package:flutter/material.dart';

void main() {
  runApp(EmotionDiaryApp());
}

class EmotionDiaryApp extends StatelessWidget {
  const EmotionDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '감정 다이어리',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('감정 다이어리'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 오늘의 감정 카드 - 백엔드 API: GET /api/emotion/today
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 감정',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '😊 긍정적',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '전반적으로 밝은 하루를 보내고 계시네요!',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // 빠른 액션 버튼들
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    // 일기 작성 화면으로 이동
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiaryWriteScreen()),
                      );
                    },
                    icon: Icon(Icons.edit),
                    label: Text('일기 쓰기'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnalysisScreen()),
                      );
                    },
                    icon: Icon(Icons.analytics),
                    label: Text('감정 분석'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            Text(
              '최근 일기',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 16),
            
            // 최근 일기 목록 - 백엔드 API: GET /api/diaries/recent?limit=5
            ...List.generate(3, (index) {
              final emotions = ['😊', '😢', '🤔'];
              final dates = ['10월 30일', '10월 29일', '10월 28일'];
              final previews = [
                '오늘은 정말 좋은 하루였다...',
                '조금 우울한 하루였지만...',
                '복잡한 하루였다...'
              ];
              
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    child: Text(emotions[index], style: TextStyle(fontSize: 20)),
                  ),
                  title: Text(dates[index]),
                  subtitle: Text(previews[index]),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: 백엔드 API: GET /api/diary/{diary_id} - 일기 상세 보기
                  },
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiaryWriteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// 일기 작성 화면
class DiaryWriteScreen extends StatefulWidget {
  const DiaryWriteScreen({super.key});

  @override
  _DiaryWriteScreenState createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends State<DiaryWriteScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일기 쓰기'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isAnalyzing ? null : _analyzeEmotion,
            child: Text('분석하기'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            
            SizedBox(height: 20),
            
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: '오늘 하루는 어땠나요?\n자유롭게 적어보세요...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeEmotion,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isAnalyzing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('분석 중...'),
                        ],
                      )
                    : Text('감정 분석하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _analyzeEmotion() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기를 작성해주세요.')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);
    
    // 백엔드 API 호출 필요:
    // 1. POST /api/diary - 일기 저장
    // 2. POST /api/emotion/analyze - 감정 분석 요청
    await Future.delayed(Duration(seconds: 2)); // API 호출 시뮬레이션
    
    setState(() => _isAnalyzing = false);
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnalysisScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// 감정 분석 결과 화면
class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('감정 분석 결과'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 주요 감정 표시 - 백엔드 API: GET /api/emotion/analysis/{diary_id}
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.pink.shade300],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text('😊', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 12),
                  Text(
                    '긍정적',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '85% 긍정적인 감정이 감지되었습니다',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // 감정 분포 차트
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '감정 분포',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildEmotionBar('기쁨', 0.4, Colors.yellow),
                    _buildEmotionBar('만족', 0.3, Colors.green),
                    _buildEmotionBar('평온', 0.15, Colors.blue),
                    _buildEmotionBar('우울', 0.1, Colors.grey),
                    _buildEmotionBar('분노', 0.05, Colors.red),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // 키워드 분석 - 백엔드 데이터: keywords 배열
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주요 키워드',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: ['친구', '성공', '기쁨', '만족', '성취감']
                          .map((keyword) => Chip(label: Text(keyword)))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // AI 피드백 받기 버튼 - 백엔드 API: POST /api/feedback/generate
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: AI 피드백 화면으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('피드백 기능은 백엔드 연동 후 구현됩니다.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('맞춤 피드백 받기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionBar(String emotion, double value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(emotion)),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(width: 8),
          Text('${(value * 100).toInt()}%'),
        ],
      ),
    );
  }
}
