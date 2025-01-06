# PokemonDexApp
개요: MVVM 패턴 및 RxSwift를 사용해서 포켓몬 API를 이용한 포켓몬 도감 앱

## ⏰ 프로젝트 일정
- 시작일: 24/12/30
- 종료일: 24/01/03

📁 프로젝트 구조
```
PokeDexApp
├── Common
│   ├── APIEndpoint                 # API URL 관리
│   ├── NetworkManager              # 네트워크 통신 관리
│
├── Extensions
│   └── UIColor                     # 커스텀 색상 확장
│
├── Model
│   ├── Pokemon                     # 포켓몬 데이터 모델
│   └── PokemonDetail               # 포켓몬 상세 데이터 모델
│
├── UseCase
│   └── PokemonUseCase              # 포켓몬 관련 비즈니스 로직
│
├── Utility
│   ├── PokeDetailsFormatter        # 포켓몬 상세 데이터 포매터
│   ├── PokemonTranslator           # 포켓몬 데이터 번역 유틸리티
│   └── PokemonTypeName             # 포켓몬 타입 이름 관리
│
├── View
│   ├── DetailView                  # 상세 뷰 컴포넌트
│   └── MainView                    # 메인 뷰 컴포넌트
│
├── ViewController
│   ├── DetailViewController        # 상세 화면 컨트롤러
│   ├── MainViewCell                # 메인 뷰 셀
│   └── MainViewController          # 메인 화면 컨트롤러
│
├── ViewModel
│   ├── DetailViewModel             # 상세 화면 뷰모델
│   └── MainViewControllerModel     # 메인 화면 뷰모델
│
├── AppDelegate                    
├── Assets                       
├── Info                            
├── LaunchScreen                    
└── SceneDelegate
```               
## 🎥 시연 영상
|![화면 기록 2025-01-03 오후 8 17 56](https://github.com/user-attachments/assets/79c3623b-ce54-41dc-839f-4a0d86de6500)|![화면 기록 2025-01-03 오후 8 22 05](https://github.com/user-attachments/assets/5b30d50f-07e0-404f-8dba-c3cd701310dc)|
|:---:|:---:|
|메인 페이지|상세 페이지|

### 🛠 기술 스택
#### Development Environment
- IDE: Xcode 16.1
#### Project Target Version
- iOS 16.6+
- Swift 5.0+
#### Dependencies
- SnapKit (~> 5.7.1)
- Alomfire(~> 5.10.2)
- Kingfisher(~> 8.1.3)
- RxSwift(~> 6.8.0)
#### API
- [포켓몬 API](https://pokeapi.co/ )
