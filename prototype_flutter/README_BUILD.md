이 저장소의 prototype_flutter 폴더는 MindTalk 시제품의 Flutter 소스입니다.

빌드 지침 (로컬 환경):
1. Flutter 설치: https://flutter.dev/docs/get-started/install
2. 터미널에서 프로젝트 루트로 이동:
   cd prototype_flutter
3. 플랫폼 디렉토리가 없을 경우 생성:
   flutter create .
4. 의존성 설치 및 디버그 APK 빌드:
   flutter pub get
   flutter build apk --debug
5. 생성된 APK 경로:
   build/app/outputs/flutter-apk/app-debug.apk

CI 빌드:
- .github/workflows/flutter-build.yml 파일이 포함되어 있습니다. GitHub Actions에서 push 또는 수동 실행으로 debug APK를 빌드하고 아티팩트로 업로드합니다.

주의:
- 릴리스 APK(signing)가 필요하면 signing config와 비밀(keystore) 설정이 추가로 필요합니다.
