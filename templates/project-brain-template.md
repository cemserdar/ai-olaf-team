# 🧠 PROJECT BRAIN - Proje Genel Mimari Beyni ve Teknoloji Haritası

> **Proje Adı:** {{PROJECT_NAME}}  
> **Proje Türü:** {{PROJECT_TYPE}} <!-- BROWNFIELD veya GREENFIELD -->  
> **Oluşturulma Tarihi:** {{CREATED_AT}}  
> **Son Güncelleme:** {{LAST_UPDATED}}  
> **Eğitim Durumu:** {{TRAINING_STATUS}} <!-- HAZIR / EĞİTİM GEREKLİ -->  

---

## 📌 1. PROJE KİMLİĞİ VE HEDEFİ
- **Proje Amacı:** {{PROJECT_GOAL}}
- **Hedef Kitle / Kullanıcı Profili:** {{TARGET_AUDIENCE}}
- **Temel Fonksiyonel Yetenekler:**
  - 
  - 

---

## 💻 2. TEKNOLOJİ YIĞINI (TECH STACK)
| Katman / Alan | Teknoloji & Kütüphaneler | Sürüm | Açıklama |
| :--- | :--- | :--- | :--- |
| **Backend Çalışma Zamanı** | {{BACKEND_RUNTIME}} | | Örn: .NET 8 / Java 21 / Node.js 20 |
| **Backend Framework** | {{BACKEND_FRAMEWORK}} | | Örn: ASP.NET Core Web API / Spring Boot |
| **Veritabanı & ORM** | {{DB_AND_ORM}} | | Örn: PostgreSQL 16 + EF Core 8.0 |
| **Gerçek Zamanlı & Kuyruk** | {{REALTIME_AND_QUEUE}} | | Örn: SignalR + RabbitMQ / Redis |
| **Frontend Web** | {{FRONTEND_TECH}} | | Örn: React 18 + TypeScript + Tailwind CSS |
| **Mobil Uygulama** | {{MOBILE_TECH}} | | Örn: React Native + Expo |
| **Kimlik & Güvenlik** | {{AUTH_AND_SECURITY}} | | Örn: JWT Bearer + Refresh Token + BCrypt |
| **DevOps & Dağıtım** | {{DEVOPS_STACK}} | | Örn: Docker + Docker Compose + GitHub Actions |
| **Test Altyapısı** | {{TEST_STACK}} | | Örn: xUnit + Moq + FluentAssertions / Jest |

---

## 🏛️ 3. MİMARİ YAPI VE KLASÖR DÜZENİ
Projenin benimsediği mimari yaklaşım (Clean Architecture, Vertical Slice, Modüler vb.):

```text
{{PROJECT_FOLDER_TREE}}
```

### Katman Sorumlulukları ve Bağımlılık Yönleri:
1. **Domain:** Çekirdek iş modelleri, Entity'ler, Value Object'ler, Domain Event'ler (Sıfır dış bağımlılık).
2. **Application:** CQRS Handler'ları, Servis arayüzleri, DTO'lar, İş mantığı doğrulamaları (FluentValidation).
3. **Infrastructure:** Veritabanı erişimi (DbContext), dış servis entegrasyonları, dosya depolama, mesaj kuyrukları.
4. **Presentation / API / Web:** Controller'lar, Minimal API'lar, SignalR Hub'ları, Middleware'ler.

---

## 🗄️ 4. VERİTABANI VE VERİ MODELLERİ
- **Veritabanı Türü:** {{DB_ENGINE}}
- **Migration Yönetimi:** {{MIGRATION_TOOL}}
- **Mevcut Temel Varlıklar (Entities):**
  - `{{ENTITY_1}}`: 
  - `{{ENTITY_2}}`: 

---

## 🔌 5. API STANDARTLARI VE İLETİŞİM
- **API Türü:** RESTful / JSON / WebSockets / gRPC
- **Standart Yanıt Formatı:**
```json
{
  "success": true,
  "data": {},
  "message": "İşlem başarılı",
  "errors": []
}
```
- **Hata Yönetimi:** Standart RFC 7807 Problem Details veya Özel `ServiceResult` sarmalayıcısı.

---

## 🔐 6. GÜVENLİK VE YETKİLENDİRME KURALLARI
- Kimlik Doğrulama: `Authorization: Bearer <JWT>`
- Rol ve Politika Dağılımı: 
- Hassas Veri Koruması: Parolalar, API anahtarları asla koda gömülmez; Environment Variables veya Secret Store kullanılır.

---

## 📦 7. DEVOPS VE CI/CD YAPILANDIRMASI
- **Konteyner Desteği:** Dockerfile & docker-compose.yml
- **Pipeline:** `.github/workflows/` (Build, Test, Lint, Deploy)
- **Ortamlar:** Development, Staging, Production

---

## 🔄 8. GİT GEÇMİŞİ VE SON DEĞİŞİKLİKLER
Bu bölüm her commit sonrasında post-commit hook veya sync-skills tarafından otomatik güncellenir:

- **Son Commit ID:** {{LAST_COMMIT_HASH}}
- **Son Commit Mesajı:** {{LAST_COMMIT_MSG}}
- **Son Değişiklik Tarihi:** {{LAST_COMMIT_DATE}}

---

## 🤝 9. TAKIM ANLAŞMASI VE ÇALIŞMA KURALLARI
1. Kod yazmadan önce ilgili ajanın `.olaf/learned-skills/<agent>-skills.md` dosyası incelenir.
2. Yeni bir kütüphane eklenecekse önce `@architect` ve `@legal` onayı gerekir.
3. Görev bitiminde mutlaka testler (`@qa`) ve güvenlik taraması (`@security`) yapılır.
4. Yapılan her değişiklik sonrası ilgili ajan kendi yetenek dosyasını günceller.
