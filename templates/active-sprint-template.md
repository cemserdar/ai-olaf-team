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
Aşağıdaki tablo, görevlerin icra sırasını ve hangi ajanın sorumlu olduğunu belirler:

| Sıra | Görev ID | Görev Açıklaması | Sorumlu Ajan(lar) | Bağımlılık | Durum | Çıktı Dosyaları / Etkilenen Kodlar |
| :---: | :--- | :--- | :--- | :--- | :---: | :--- |
| 1 | `TASK-01` | Gereksinim ve Kullanıcı Hikayesi Analizi | `@ba` | - | ⏳ Bekliyor | `docs/requirements.md` |
| 2 | `TASK-02` | Mimari Tasarım ve Katman Planı | `@architect` | TASK-01 | ⏳ Bekliyor | Mimari şema, DTO modelleri |
| 3 | `TASK-03` | Veritabanı Entity ve Migration Hazırlığı | `@db` | TASK-02 | ⏳ Bekliyor | `Entities/`, `Migrations/` |
| 4 | `TASK-04` | Backend Servis ve Endpoint Geliştirme | `@backend` | TASK-03 | ⏳ Bekliyor | `Services/`, `Controllers/` |
| 5 | `TASK-05` | Gerçek Zamanlı Akış / Mesajlaşma | `@realtime` | TASK-04 | ⏳ Bekliyor | `Hubs/`, `Consumers/` |
| 6 | `TASK-06` | Web Frontend Ekran Geliştirme | `@frontend`, `@uiux` | TASK-04 | ⏳ Bekliyor | `src/pages/`, `src/components/` |
| 7 | `TASK-07` | Mobil Arayüz Entegrasyonu | `@mobile` | TASK-04 | ⏳ Bekliyor | `screens/`, `hooks/` |
| 8 | `TASK-08` | Güvenlik, Auth ve Yetki Denetimi | `@security` | TASK-04, 06 | ⏳ Bekliyor | Güvenlik raporu, fixler |
| 9 | `TASK-09` | Birim ve Entegrasyon Testleri | `@qa` | TASK-04, 06 | ⏳ Bekliyor | `tests/` |
| 10 | `TASK-10` | Kod Temizliği ve Refactoring | `@refactor` | TASK-09 | ⏳ Bekliyor | Temizlenen sınıflar |
| 11 | `TASK-11` | Lisans ve KVKK/GDPR Uyumluluk | `@legal` | TASK-02, 04 | ⏳ Bekliyor | Uyumluluk notu |
| 12 | `TASK-12` | API Dokümantasyonu ve README | `@docs` | TASK-10 | ⏳ Bekliyor | `README.md`, Swagger |
| 13 | `TASK-13` | Docker & CI/CD Pipeline Güncellemesi | `@devops` | TASK-10 | ⏳ Bekliyor | `Dockerfile`, `.github/` |

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
