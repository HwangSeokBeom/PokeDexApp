# PokemonDexApp
개요: MVVM 패턴 및 RxSwift를 사용해서 포켓몬 API를 이용한 포켓몬 도감 앱 

## ⏰ 프로젝트 일정
- 시작일: 24/12/30
- 종료일: 24/01/03
---
## 📁 프로젝트 구조

TicketSquare/
├── 📱 APIManager/
│   ├── APIManager.swift          # TMDB API 통신 관리
│   └── Movie.swift              # 영화 데이터 모델
│
├── 🔐 Login/
│   ├── Join.swift               # 회원가입 화면
│   └── Login.swift              # 로그인 화면
│
├── 📋 MainTabBarController/
│   └── MainTabBarController.swift    # 탭바 컨트롤러
│
├── 🏠 MainView/
│   ├── HeaderView.swift              # 헤더 뷰 컴포넌트
│   ├── MainViewController.swift      # 메인 화면 컨트롤러
│   ├── PagingImageCell.swift         # 페이징 이미지 셀
│   └── SmallImageCell.swift          # 작은 이미지 셀
│
├── 🎬 MovieDetail/
│   └── MovieDetailViewController.swift    # 영화 상세 화면
│
├── 👤 MyPage/
│   ├── MyPageViewController.swift         # 마이페이지 화면
│   └── TicketTableViewCell.swift          # 예매 내역 셀
│
├── 🔍 Search/
│   ├── SearchCollectionViewCell.swift     # 검색 결과 그리드 셀
│   ├── SearchTableViewCell.swift          # 검색 결과 리스트 셀
│   ├── SearchView.swift                   # 검색 화면 뷰
│   └── SearchViewController.swift         # 검색 화면 컨트롤러
│
├── 🎫 Ticketing/
│   ├── Ticket.swift                       # 티켓 모델
│   ├── TicketingStepper.swift             # 인원 선택 스테퍼
│   ├── TicketingTimeCollectionViewCell.swift    # 시간 선택 셀
│   ├── TicketingViewController.swift      # 예매 화면 컨트롤러
│   └── TicketManager.swift                # 티켓 데이터 관리
│
└── 🛠 Utility/
    ├── AppDelegate.swift                  # 앱 델리게이트
    ├── Assets.xcassets                    # 에셋 파일
    ├── Info.plist                         # 프로젝트 설정 파일
    ├── LaunchScreen                       # 시작 화면
    ├── MockData                           # 테스트용 더미 데이터
    ├── PreviewProvider                    # SwiftUI 프리뷰 설정
    ├── PriceFormatter                     # 가격 포맷 유틸리티
    ├── SceneDelegate                      # 씬 델리게이트
    ├── UIColorStyle                       # 커스텀 색상 스타일
    ├── UserInfo                           # 사용자 정보 관리
    └── ViewController                     # 기본 뷰 컨트롤러


---

### 🛠 기술 스택
---
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


