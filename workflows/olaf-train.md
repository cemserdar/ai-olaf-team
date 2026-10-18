# 🚀 /olaf-train - Otonom Proje Tarama ve 15 Ajanı Eğitme İş Akışı

Bu iş akışı, projenin mevcut kod tabanını baştan aşağı tarayarak 15 kişilik AI Olaf Team'i o projeye özel eğitir.

---

## 🎯 İŞ AKIŞI HEDEFİ
Projedeki tüm kodları, kütüphaneleri, mimari desenleri ve kuralları analiz etmek; `.olaf/memory/project-brain.md` dosyasını doldurmak ve 15 ajanın `.olaf/learned-skills/<agent>-skills.md` dosyalarını bizzat o projenin kurallarıyla sıfırdan yazarak `TRAINING_REQUIRED.flag` dosyasını kaldırmak.

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### ADIM 1: KÖK DİZİN VE PROJE TÜRÜ TARAMASI
1. Projenin kök dizinindeki konfigürasyon ve paket dosyalarını tara:
   - .NET / C#: `*.sln`, `*.csproj`, `appsettings.json`, `Program.cs`
   - Node / Web / Mobil: `package.json`, `tsconfig.json`, `app.json`, `eas.json`
   - Java: `pom.xml`, `build.gradle`, `application.properties` / `application.yml`
   - Python: `requirements.txt`, `pyproject.toml`, `Pipfile`
   - Go / Rust: `go.mod`, `Cargo.toml`
   - DevOps: `Dockerfile`, `docker-compose.yml`, `.github/workflows/`
2. Projedeki klasör ağacını çıkar ve katmanlaşma yapısını (Clean Architecture, Vertical Slice, Modüler vb.) belirle.

### ADIM 2: DERİN KOD ANALİZİ (DEEP CODE INSPECTION)
Aşağıdaki kritik kod bloklarını doğrudan aç ve oku:
- **Giriş Noktaları (Entry Points):** `Program.cs`, `main.ts`, `App.tsx`, `index.js`, `Startup.cs`
- **Veri ve ORM:** `DbContext`, Migration dosyaları, Entity/Model sınıfları, Repository'ler
- **İş Mantığı ve Servisler:** Service arayüzleri ve implementasyonları, Handler'lar, CQRS komutları
- **Sunum / API:** Controller sınıfları, Minimal API route'ları, Middleware'ler, DTO'lar
- **Frontend / Mobil:** State yönetimi (Zustand/Redux), API istemcileri (Axios interceptor), sayfa ve bileşen hiyerarşisi
- **Gerçek Zamanlı Sistemler:** SignalR Hub sınıfları, RabbitMQ / MassTransit consumer'ları, BackgroundService / Worker'lar
- **Güvenlik ve Konfigürasyon:** JWT ayarları, CORS politikaları, Authorization policy'leri

### ADIM 3: `.olaf/memory/project-brain.md` DOSYASINI DOLDUR
Tespit edilen bulguları `.olaf/memory/project-brain.md` içine tam metin olarak yaz:
- Proje türü: BROWNFIELD
- Gerçek dil, framework ve kütüphane sürümleri
- Katmanlar ve klasör mimarisi
- Entity ve veritabanı şeması
- Standart API yanıt formatları ve hata fırlatma modelleri
- Docker, CI/CD ve çalışma ortamı değişkenleri

### ADIM 4: 15 AJANIN SKILL DOSYALARINI DİNAMİK OLARAK YAZ
Aşağıdaki 15 ajanın her biri için `.olaf/learned-skills/<agent>-skills.md` dosyasını aç ve ajanın ağzından o projeye özel öğrenilen kuralları yaz:

1. **`pm-skills.md`**: Proje teslim kuralları, aktif sprint hedefleri, hangi ajanın hangi modülden sorumlu olduğu.
2. **`architect-skills.md`**: Katman kuralları, izin verilen referans yönleri, tasarım desenleri (Repository, Mediator, CQRS).
3. **`ba-skills.md`**: Kodlardan ve Entity'lerden çıkarılan iş kuralları (Domain logic), sipariş/ödeme/kullanıcı akışları.
4. **`backend-skills.md`**: Projenin gerçek backend kuralları (örn: "EF Core kullanılmaktadır, Dapper yasaktır, Servisler Scoped tanımlanır, dönüş tipi `ServiceResult<T>`'dir, async/await zorunludur").
5. **`db-skills.md`**: Veritabanı motoru (PostgreSQL, MSSQL vb.), Migration kuralları, AsNoTracking stratejisi, Index yapıları.
6. **`realtime-skills.md`**: SignalR hub URL'leri, event isimleri, RabbitMQ kuyruk isimleri, retry stratejileri.
7. **`frontend-skills.md`**: React/Angular kuralları, Tailwind class desenleri, form doğrulama kütüphanesi, global state kuralı.
8. **`mobile-skills.md`**: Expo/React Native konfigürasyonu, offline storage kullanımı, ekran navigasyon yapısı.
9. **`uiux-skills.md`**: Renk paleti (primary, secondary, background, surface), Dark mode token'ları, font ailesi, buton stilleri.
10. **`security-skills.md`**: JWT claim yapısı, roller, CORS origin listesi, şifreleme algoritmaları, sanitization kuralları.
11. **`devops-skills.md`**: Docker portları, environment dosyaları, GitHub Actions workflow adımları, build komutları.
12. **`qa-skills.md`**: Test kütüphaneleri (xUnit, Jest), mock standartları, test klasör dizilimi, test veri üretimi.
13. **`refactor-skills.md`**: Projede dikkat çeken kod kokuları, refactor edilecek sıcak noktalar, isimlendirme disiplini.
14. **`docs-skills.md`**: Dokümantasyon formatı, Swagger endpoint açıklamaları, Mermaid şema kuralları.
15. **`legal-skills.md`**: Tespit edilen NuGet/NPM paket lisansları, KVKK/GDPR kişisel veri içeren alanlar (TCKN, telefon, e-posta).

### ADIM 5: EĞİTİMİ TAMAMLA VE BAYRAĞI KALDIR
- `.olaf/memory/TRAINING_REQUIRED.flag` dosyasını sil.
- Kullanıcıya detaylı bir Türkçe rapor sun:
  - Keşfedilen Mimari ve Teknoloji Özeti
  - Eğitilen 15 Ajanın Öğrendiği Temel Kurallar
  - Takımın göreve hazır olduğu müjdesi ve ilk görev için `/pm` komutu önerisi.
