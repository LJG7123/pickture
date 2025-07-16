# 📸 Pickture

> 사진 기반의 SNS 기능을 제공하는 Flutter 기반 모바일 애플리케이션입니다. Firebase를 이용한 사용자 인증, 실시간 채팅, 푸시 알림, 프로필 관리, 게시글 작성 등 다양한 기능을 통해 실제 서비스에 가까운 구조로 개발하였습니다.

---

## 🧾 프로젝트 개요

- **개발 기간**: 2025년 1월 ~ 2월 (4주)
- **기술 스택**: Flutter (Dart), Firebase, Riverpod, go_router
- **상태 관리**: Riverpod 사용
- **백엔드**: Firebase Authentication, Firestore, Storage, Cloud Functions, FCM
- **지원 플랫폼**: Android

---

## ✨ 주요 기능

| 기능 | 설명 |
|------|------|
| 🔐 회원가입/로그인 | Firebase 인증 기반 이메일 회원가입 및 로그인 |
| 📝 게시글 업로드 | 이미지 + 텍스트 기반 게시물 업로드 (Firestore 저장) |
| 📂 개인 피드 | 내가 작성한 게시물 및 프로필 정보 확인 가능 |
| 🔄 실시간 채팅 | 사용자 간 1:1 채팅 구현 (Firestore) |
| 📷 프로필 사진 수정 | 갤러리에서 이미지 선택 후 Storage에 저장 |
| 🔔 푸시 알림 | FCM을 통한 알림 메시지 전송 |

---

## 📱 앱 화면 미리보기

### 🔑 회원가입
<img src="https://github.com/user-attachments/assets/425666de-3011-4bae-a369-b2c55d4fc142" width="300"/>

### 🏠 메인 피드 (게시물 리스트)
<img src="https://github.com/user-attachments/assets/f8a3353c-6746-40c6-965d-ab3677c8875e" width="300"/>

### 💬 실시간 채팅
<img src="https://github.com/user-attachments/assets/50fb41b0-59c6-4a1c-a6c5-14fbf512d705" width="300"/>

### 📸 알림 메시지 (FCM)
<img src="https://github.com/user-attachments/assets/a14f006a-ba15-4c38-a340-37b0d90e8902" width="300"/>

### 👤 프로필 사진 편집
<img src="https://github.com/user-attachments/assets/2aaad02c-5692-4a85-be88-e418ab4bae8c" width="300"/>

---

## 🛠 사용 기술

| 분류 | 기술 |
|------|------|
| 언어 | Dart |
| 프레임워크 | Flutter |
| 상태 관리 | Riverpod |
| 라우팅 | go_router |
| 인증 및 DB | Firebase Authentication, Firestore |
| 저장소 | Firebase Storage |
| 백엔드 기능 | Firebase Functions, FCM |
| 툴 | Android Studio, Git, GitHub |

---

## 🧠 주요 경험 / 트러블슈팅

- **회원가입 기능 구현**  
  Firebase의 Authentication을 이용한 회원가입 및 로그인, 소셜 로그인(구글) 구현.  

- **새 메시지 알림 기능 구현** (다른 프로젝트 경험에 포함 가능)  
  Firebase의 Functions와 FCM을 이용하여 새로운 메시지가 도착하면 사용자에게 알림으로 알려주도록 구현.  

- **TextEditingController 관련 트러블슈팅**  
  구현 과정에서, 위젯의 생명 주기에 따라 관리되어야 할 TextEditingController가 Provider에 존재해도 되는지에 대해 의문이 생김.   
  Riverpod에서는 TextEditingController를 Provider 내부에서 관리하는 것을 권장하지 않음.   
  그래서 ConsumerWidget -> ConsumerStatefulWidget으로 변경하고 위젯 내부에서 관리하도록 수정.   

---
