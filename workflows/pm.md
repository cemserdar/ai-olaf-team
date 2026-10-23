# 👔 /pm - Proje Yöneticisi ve Takım Orkestrasyonu İş Akışı

Bu iş akışı, kullanıcının talebini alıp 15 kişilik AI Olaf Team'i organize eden `@pm` (Proje Yöneticisi) orkestrasyon motorudur.

---

## 🎯 İŞ AKIŞI HEDEFİ
Kullanıcıdan gelen yeni özellik, hata düzeltme, mimari değişiklik veya optimizasyon talebini analiz etmek, görevleri parçalara ayırmak, doğru uzman ajanları doğru sırayla göreve çağırmak ve iş bitiminde hafızanın güncellenmesini garanti altına almak.

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### ADIM 1: ÖN KOŞUL KONTROLÜ (HAFIZA VE EĞİTİM KONTROLÜ)
1. `.olaf/memory/TRAINING_REQUIRED.flag` dosyasının varlığını kontrol et:
   - **Eğer bayrak varsa:** "⚠️ Proje henüz eğitilmedi. Önce `/olaf-train` iş akışını başlatıyorum..." diyerek `/olaf-train` akışını tetikle veya kullanıcıya bildir.
   - **Eğer bayrak yoksa:** Bir sonraki adıma geç.
2. `.olaf/memory/project-brain.md` dosyasını oku ve projenin güncel mimarisini kavra.

### ADIM 2: KULLANICI TALEBİNİN ANALİZİ VE SPRINT PLANI
1. Kullanıcının talebini analiz et:
   - Yeni bir özellik mi (Feature)?
   - Bir hata düzeltmesi mi (Bugfix)?
   - Performans / Refactor talebi mi?
   - Yeni bir servis / altyapı kurulumu mu?
2. `.olaf/memory/active-sprint.md` dosyasını aç ve sprint tablosunu güncelle:
   - Sprint Hedefini belirle.
   - Görevleri alt iş paketlerine (`TASK-01`, `TASK-02`...) böl.
   - **Bağımlılık Analizi Yap:** Birbirini bloklamayan görevleri belirle ve **paralel kulvarlara (Kulvar A: Backend, Kulvar B: Mobil vb.)** ayır.
   - Yalnızca teknik olarak birbirine bağımlı olan görevlere sıralı önkoşul (blocking dependency) tanımla.

### ADIM 3: AJANLARIN İCRASI (15 AJAN İÇİN ÇOK KULVARLI PARALEL İCRA MATRİSİ)
`@pm` olarak 15 kişilik ekibin tamamını bağımsızlık durumuna göre paralel kulvarlarda koordine et:

#### 1. Faz: Hazırlık, Sözleşme & Tasarım (Paralel Analiz)
Birbirini bloklamayan tasarım ve analiz işleri eş zamanlı başlar:
- `@ba`: Gereksinimleri, kullanıcı hikayelerini ve kabul kriterlerini netleştirir.
- `@architect`: Sistem katmanlarını, entity ilişkilerini ve API/DTO kontratlarını çıkarır.
- `@uiux`: Ekran tasarımlarını, wireframe ve renk paletini hazırlar.

#### 2. Faz: Eş Zamanlı Geliştirme & Altyapı (15 Ajanın Paralel Kulvarları)
*API/DTO sözleşmesi ve temel mimari netleştiği andan itibaren tüm bağımsız kulvarlar aynı anda çalışır:*
- **Kulvar 1 (Veritabanı & Backend):** 
  - `@db`: Entity ve Migration'ları hazırlar.
  - `@backend`: Servis, Repository ve Endpoint kodlarını yazar.
  - `@realtime`: SignalR Hub, Redis Pub/Sub veya RabbitMQ altyapısını kurar.
- **Kulvar 2 (Mobil Geliştirme):** 
  - `@mobile`: Mobil ekranları, yerel state'i (offline-first) ve API istemci katmanını geliştirir.
- **Kulvar 3 (Web Frontend):** 
  - `@frontend`: Web ekranlarını, bileşen kütüphanesini ve state yönetimini geliştirir.
- **Kulvar 4 (DevOps & CI/CD - Bağımsız):** 
  - `@devops`: Geliştirmenin bitmesini beklemez; Dockerfile, docker-compose, GitHub Actions pipeline ve ortam konfigürasyonlarını **paralel** inşa eder.
- **Kulvar 5 (Yasal & Lisans - Bağımsız):** 
  - `@legal`: Kodun tamamlanmasını beklemez; projeye dahil edilen NuGet/NPM paketlerinin lisanslarını ve KVKK/GDPR uyumunu **paralel** denetler.
- **Kulvar 6 (QA & Test Hazırlığı - Bağımsız):** 
  - `@qa`: Kodun yazılmasını beklemez; kabul kriterlerine göre birim/entegrasyon test şablonlarını, fixture'ları ve test senaryolarını **paralel** hazırlar.
- **Kulvar 7 (Dokümantasyon - Bağımsız):** 
  - `@docs`: API sözleşmesi netleştiği andan itibaren OpenAPI/Swagger, mimari diyagramlar ve README dokümanlarını **paralel** yazar.

> **GENEL PARALEL İCRA KURALI:** 15 ajanın tamamı için geçerlidir. Birbirini teknik olarak zorunlu kılmayan (bloklamayan) hiçbir iş paketi sıralı bekletilmez; bağımsız kulvarlarda aynı anda yürütülür.

#### 3. Faz: Doğrulama, Kalite, Git Entegrasyonu ve Kapanış
Kulvarlardaki işler tamamlandığında entegrasyon ve denetim adımları devreye girer:
- **`@devops` (Tek Yetkili Git & Release Gatekeeper):** 
  - Paralel kulvarların task branch'lerini Merge Queue sırasına alır.
  - Ara commit'leri `main` geçmişini kirletmeyecek şekilde **Squash Merge** ile tekil commit'e dönüştürür.
  - Conflict çıktığında çözümü koordine eder, CI/CD test kapısını çalıştırır ve `main`'e resmi entegrasyonu SADECE `@devops` yapar. Worktree temizliğini tamamlar.
- **`@security`:** Yetki, auth, SQLi/XSS ve gizli anahtar taramasını paralel yürütür.
- **`@qa`:** Hazırladığı test senaryolarını canlı kod üzerinde koşturur ve raporlar.
- **`@refactor`:** Kod kokularını, DRY/SOLID ihlallerini ve bellek optimizasyonunu inceler.
- **`@pm`:** Tüm kulvarlar tamamlandığında sprinti kapatır ve kullanıcı özetini sunar.

> **ÖNEMLİ KURAL:** Bir ajanı devreye alırken, o ajanın hem `base-agents/<agent>.md` (genel DNA) hem de `.olaf/learned-skills/<agent>-skills.md` (projeye özel kuralları) dosyalarını hafızada birleştir!

### ADIM 4: SÜREKLİ ÖĞRENME VE HAFIZA GÜNCELLEME KONTROLÜ
İş tamamlandığında `@pm` şu kontrolleri zorunlu kılar:
1. Görevde aktif rol alan her ajan, `.olaf/learned-skills/<agent>-skills.md` dosyasına yeni eklenen modelleri, kuralları veya dikkat edilmesi gereken noktaları yazdı mı?
2. `.olaf/memory/project-brain.md` dosyasındaki teknoloji, entity veya endpoint listesi güncellendi mi?
3. `.olaf/memory/active-sprint.md` içindeki görevlerin durumu "Tamamlandı" olarak işaretlendi mi?

### ADIM 5: KULLANICIYA YÖNETİCİ ÖZETİ RAPORU SUNMA
Kullanıcıya son derece profesyonel, maddeler halinde Türkçe bir teslimat özeti sun:
- Yapılan değişikliklerin özeti
- Değiştirilen / oluşturulan dosyaların listesi
- Çalıştırılan testlerin sonuçları
- Varsa kullanıcının dikkat etmesi gereken ortam değişkenleri veya çalıştırma adımları.
