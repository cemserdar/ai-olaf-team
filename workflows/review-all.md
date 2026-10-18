# 🛡️ /review-all - Çoklu Ajan ile Bütünsel Proje Denetimi İş Akışı

Bu iş akışı, projeyi 5 farklı uzmanlık alanında (`@architect`, `@security`, `@refactor`, `@qa`, `@legal`) kapsamlı bir denetimden geçirerek bütünsel bir kalite, güvenlik ve uyumluluk raporu sunar.

---

## 🎯 İŞ AKIŞI HEDEFİ
Tek bir komutla projedeki mimari uyumsuzlukları, güvenlik açıklarını, performans darboğazlarını, eksik testleri ve hukuki riskleri tespit edip önceliklendirilmiş aksiyon planı hazırlamak.

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### AŞAMA 1: MİMARİ VE KATMAN DENETİMİ (`@architect`)
1. Katmanlar arası bağımlılık yönlerini kontrol et (Domain katmanına dış bağımlılık sızmış mı?).
2. Tasarım desenlerinin (Repository, UnitOfWork, MediatR, CQRS) doğru kullanılıp kullanılmadığını sına.
3. Spagetti Controller veya tanrı sınıfların (God Object) varlığını tespit et.
4. Çıktı: Mimari Uyumluluk Notu ve Risk Seviyesi.

### AŞAMA 2: SİBER GÜVENLİK VE APPSEC DENETİMİ (`@security`)
1. **OWASP Top 10 Taraması:**
   - SQL Injection (Raw SQL, String interpolation içeren sorgular).
   - XSS ve HTML Injection (Sanitize edilmemiş kullanıcı girdileri).
   - Yetkisiz Erişim (Eksik `[Authorize]` veya rol kontrolleri).
   - CSRF & CORS (Aşırı izin verilmiş `AllowAnyOrigin()` kuralları).
2. **Hassas Veri ve Gizli Anahtar Kontrolü:** Kod içinde unutulmuş şifre, connection string, JWT secret veya API key var mı?
3. Çıktı: Güvenlik Zafiyetleri Tablosu (Kritik, Yüksek, Orta, Düşük).

### AŞAMA 3: CLEAN CODE VE PERFORMANS DENETİMİ (`@refactor`)
1. DRY, KISS ve YAGNI prensiplerine aykırı yinelenen kod bloklarını bul.
2. Asenkron I/O hatalarını kontrol et (Örn: `.Result`, `.Wait()` çağrıları veya eksik `ConfigureAwait` durumları).
3. Bellek sızıntısı ve kaynak tüketimi potansiyeli taşıyan kapatılmamış nesneleri (`IDisposable`, `using` blokları) denetle.
4. Veritabanı sorgularında N+1 problemi veya eksik `AsNoTracking()` kullanımlarını tespit et.
5. Çıktı: Refactoring ve Performans Önerileri Listesi.

### AŞAMA 4: TEST KAPSAMI VE KALİTE GÜVENCE (`@qa`)
1. Projedeki birim ve entegrasyon testlerinin mevcudiyetini kontrol et.
2. Kritik iş kurallarının (Business Rules) test kapsamını analiz et.
3. Mock nesnelerin doğruluğunu ve uç durum (Edge-Case) testlerinin varlığını incele.
4. Çıktı: Test Kapsam Analizi ve Yazılması Gereken Kritik Testler Listesi.

### AŞAMA 5: LİSANS VE KVKK / GDPR DENETİMİ (`@legal`)
1. Projede kullanılan tüm harici kütüphanelerin lisanslarını incele (GPL/AGPL gibi ticari riski olan "copyleft" lisanslar var mı?).
2. Kişisel verilerin (TCKN, telefon, e-posta, kredi kartı vb.) loglara açık metin yazılıp yazılmadığını veya şifrelenmeden saklanıp saklanmadığını denetle.
3. Çıktı: Hukuki Risk ve KVKK Uyumluluk Beyanı.

---

## 📊 BİRLEŞİK DENETİM RAPORU ŞABLONU (KULLANICIYA SUNULACAK ÇIKTI)

```markdown
# 🛡️ AI OLAF TEAM - BÜTÜNSEL PROJE DENETİM RAPORU

## 🚨 ÖZET METRİKLERİ
- **Genel Sağlık Skoru:** XX / 100
- **Kritik (P0) Bulgular:** X adet
- **Yüksek (P1) Bulgular:** X adet
- **Orta/Düşük Bulgular:** X adet

---

### 1. 🏛️ Mimari Raporu (@architect)
- [Bulgu ve Düzeltme Önerisi]

### 2. 🔐 Güvenlik Raporu (@security)
- [Güvenlik Zafiyeti, Etki Alanı ve Kod Yaması]

### 3. ⚡ Performans & Temiz Kod Raporu (@refactor)
- [Kod Kokusu ve İyileştirme Çözümü]

### 4. 🧪 Test & Kalite Raporu (@qa)
- [Eksik Test Senaryoları ve Örnek Test Kodu]

### 5. ⚖️ Hukuk, Lisans & KVKK Raporu (@legal)
- [Lisans Durumu ve Kişisel Veri Güvenliği Notu]

---

## 🛠️ ÖNCELİKLİ AKSİYON PLANI
1. [Adım 1 - Hemen yapılması gerekenler]
2. [Adım 2 - Kısa vadeli geliştirmeler]
```
