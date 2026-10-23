# 🏃 ACTIVE SPRINT - Aktif Görev ve Ajan Takip Tahtası

> **Sprint / Görev Döngüsü:** {{SPRINT_TITLE}}  
> **Başlangıç Tarihi:** {{SPRINT_START_DATE}}  
> **Koordinatör:** `@pm` (Proje Yöneticisi)  
> **Genel Durum:** 🟡 PLANLANDI / 🟢 DEVAM EDİYOR / 🏁 TAMAMLANDI  

---

## 🎯 1. SPRINT HEDEFİ
{{SPRINT_GOAL}}

---

## 📋 2. GÖREV DAĞILIMI VE AJAN ATAMALARI
Aşağıdaki tablo, görevlerin bağımlılıklarını ve 15 ajanın birbirini bloklamayan işlerinin paralel yürütüldüğü kulvarları belirler:

| Kulvar / Faz | Görev ID | Görev Açıklaması | Sorumlu Ajan(lar) | Bağımlılık | Yürütme Modu | Durum | Çıktı Dosyaları / Etkilenen Kodlar |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **Faz 1: Analiz & Tasarım** | `TASK-01` | Gereksinim ve Kabul Kriterleri Analizi | `@ba` | - | ⚡ Paralel 1 | ⏳ Bekliyor | `docs/requirements.md` |
| **Faz 1: Analiz & Tasarım** | `TASK-02` | Mimari Tasarım ve API/DTO Sözleşmesi | `@architect` | TASK-01 | Sıralı | ⏳ Bekliyor | Mimari şema, DTO modelleri |
| **Faz 1: Analiz & Tasarım** | `TASK-03` | UI/UX Wireframe ve Tasarım Sistemi | `@uiux` | TASK-01 | ⚡ Paralel 1 | ⏳ Bekliyor | Renk paleti, bileşen rehberi |
| **Kulvar A (Backend & DB)** | `TASK-04` | Veritabanı Entity ve Migration Hazırlığı | `@db` | TASK-02 | ⚡ Paralel A | ⏳ Bekliyor | `Entities/`, `Migrations/` |
| **Kulvar A (Backend & DB)** | `TASK-05` | Backend Servis ve Endpoint Geliştirme | `@backend` | TASK-04 | ⚡ Paralel A | ⏳ Bekliyor | `Services/`, `Controllers/` |
| **Kulvar A (Backend & DB)** | `TASK-06` | Gerçek Zamanlı Akış / Mesaj Kuyrukları | `@realtime` | TASK-02 | ⚡ Paralel A | ⏳ Bekliyor | `Hubs/`, `Consumers/` |
| **Kulvar B (Mobil)** | `TASK-07` | Mobil Arayüz ve Ekran Geliştirme | `@mobile` | TASK-02 | ⚡ Paralel B | ⏳ Bekliyor | `screens/`, `hooks/` |
| **Kulvar C (Web Frontend)** | `TASK-08` | Web Frontend Ekran Geliştirme | `@frontend` | TASK-02, 03 | ⚡ Paralel C | ⏳ Bekliyor | `src/pages/`, `src/components/` |
| **Kulvar D (DevOps & Ortam)**| `TASK-09` | Dockerfile, CI/CD Pipeline ve Nginx | `@devops` | TASK-02 | ⚡ Paralel D | ⏳ Bekliyor | `Dockerfile`, `.github/` |
| **Kulvar E (Hukuk & Uyum)**  | `TASK-10` | Lisans, Paket ve KVKK/GDPR Denetimi | `@legal` | TASK-02 | ⚡ Paralel E | ⏳ Bekliyor | Hukuki uyumluluk raporu |
| **Kulvar F (QA Hazırlık)**   | `TASK-11` | Test Senaryoları ve Mock Veri Hazırlığı| `@qa` | TASK-01, 02 | ⚡ Paralel F | ⏳ Bekliyor | Test senaryoları, fixtures |
| **Kulvar G (Dokümantasyon)** | `TASK-12` | API Dokümantasyonu ve README Taslağı | `@docs` | TASK-02 | ⚡ Paralel G | ⏳ Bekliyor | `README.md`, Swagger spec |
| **Faz 3: Güvenlik & Test**   | `TASK-13` | Güvenlik Taraması, Auth ve Yetki | `@security` | TASK-05, 07 | ⚡ Paralel İnceleme | ⏳ Bekliyor | Güvenlik tarama raporu |
| **Faz 3: Güvenlik & Test**   | `TASK-14` | Testlerin Canlı Kodda Koşturulması | `@qa` | TASK-05, 07 | ⚡ Paralel İnceleme | ⏳ Bekliyor | `tests/` çalıştırma sonucu |
| **Faz 3: Kapanış**           | `TASK-15` | Clean Code İncelemesi ve Refactoring | `@refactor` | TASK-13, 14 | Sıralı Kapanış | ⏳ Bekliyor | Temizlenen sınıflar |

---

## 💬 3. AJANLAR ARASI İLETİŞİM VE ONAY NOTLARI
- **`@pm` Notu:** 
- **`@architect` Notu:** 
- **`@security` Onayı:** 
- **`@qa` Test Özeti:** 

---

## 🔄 4. HAFIZA GÜNCELLEME KONTROL LİSTESİ (SPRINT SONU)
Bu sprint tamamlanmadan önce her ajanın kendi skill dosyasını güncellemesi zorunludur:
- [ ] `@backend` -> `.olaf/learned-skills/backend-skills.md` güncellendi mi?
- [ ] `@db` -> `.olaf/learned-skills/db-skills.md` güncellendi mi?
- [ ] `@frontend` -> `.olaf/learned-skills/frontend-skills.md` güncellendi mi?
- [ ] `@mobile` -> `.olaf/learned-skills/mobile-skills.md` güncellendi mi?
- [ ] `@realtime` -> `.olaf/learned-skills/realtime-skills.md` güncellendi mi?
- [ ] `@devops` -> `.olaf/learned-skills/devops-skills.md` güncellendi mi?
- [ ] `@pm` -> `.olaf/memory/project-brain.md` genel durumunu güncelledi mi?
