# 📊 /report — Sektör Standartlarında Teknik ve Yönetsel Raporlama İş Akışı

Bu iş akışı, `@reporter` ajanını devreye sokarak herhangi bir ajanın (`@backend`, `@db`, `@security`, `@qa`, `@devops`, `@pm` vb.), tamamlanan bir görevin (`TASK-XX`) veya aktif bir sprintin uluslararası sektör standartlarında (ISO/IEC 25010, IEEE 829, DORA, OWASP, RFC 7807) raporlanmasını sağlar.

---

## 🎯 İŞ AKIŞI HEDEFİ

Geliştirilen kodların, tamamlanan işlerin ve sistem performansının yalnızca mühendislerin değil; yöneticilerin, denetçilerin ve paydaşların anlayabileceği derinlikte, somut metriklerle ve sektör standartlarına uygun olarak belgelenmesi.

---

## ⚙️ KULLANIM VE TETİKLEYİCİLER

Kullanıcı veya `@pm` şu şekillerde tetikler:

```bash
/report backend      # Backend ajanının son görevleri ve API standartları raporu
/report db           # Veritabanı migrasyon, şema ve ACID denetim raporu
/report security     # OWASP Top 10, CVSS ve AppSec güvenlik denetim raporu
/report qa           # IEEE 829 & ISO 25010 test kapsama ve kalite raporu
/report devops       # DORA metrikleri ve CI/CD pipeline dağıtım raporu
/report sprint       # Aktif sprint ilerleme, hız ve kapsam sapma raporu
/report TASK-05      # Belirli bir atomik görevin uçtan uca teslimat raporu
```

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### ADIM 1: HEDEF VE KAPSAM BELİRLEME
1. Gelen parametreyi çözümle (`[hedef_ajan]`, `[task_id]` veya `sprint`).
2. Hedeflenen çalışmanın `.olaf/contexts/` ve `.olaf/outputs/` dosyalarını tespit et:
   - Eğer ajan belirtildiyse (örn: `backend`), o ajanın tamamladığı son görev manifestolarını (`TASK-XX-output.md`) listele.
   - Eğer görev kimliği belirtildiyse (örn: `TASK-05`), doğrudan o görevin brief ve output dosyalarını aç.
   - Eğer `sprint` belirtildiyse, `.olaf/memory/active-sprint.md` tahtasını incele.

### ADIM 2: SEÇİCİ HAFIZA VE GİT VERİLERİNİ TOPLAMA
`@reporter`, hiçbir varsayım yapmadan kanıt bazlı veriyi çeker:
1. **Dosya Kapsamı ve Çıktı Kontrolü:** İlgili `.olaf/outputs/TASK-XX-output.md` dosyasını oku. Değiştirilen dosyalar brief'teki dosya kapsamı (`READ/WRITE`) sınırlarında kaldı mı denetle.
2. **Seçici Hafıza Sorgusu:**
   ```bash
   # Mimari ve teknoloji bağlamını çek
   ./scripts/olaf-query-memory.sh --file brain --section tech-stack
   ./scripts/olaf-query-memory.sh --file brain --section architecture
   ```
3. **Git Denetim İzi (Commit Trail):**
   ```bash
   # Görevin oluşturduğu commit ve satır değişimlerini doğrula
   git log -1 --stat
   git rev-parse --short HEAD
   ```

### ADIM 3: İLGİLİ SEKTÖR STANDARDINI UYGULAMA
Hedef ajanın uzmanlık alanına göre ilgili kalite çerçevesini uygula:

- **Backend İçin:** RFC 7807 Problem Details hata kontrolü, REST URL standartları, asenkronluk hijyeni, N+1 sorgu denetimi.
- **Database İçin:** Transaction sınırları, Foreign Key ve Index varlığı, Migration rollback betiği kontrolü.
- **Security İçin:** OWASP Top 10 kontrolleri (A01: Broken Access Control, A02: Cryptographic Failures, A03: Injection vb.).
- **QA İçin:** IEEE 829 test şablonu, Boundary Value testleri, Happy/Unhappy path ayrımı, Mock izolasyonu.
- **DevOps İçin:** DORA metrikleri (Deployment Frequency, Lead Time, Change Fail Rate, MTTR), Docker imaj optimizasyonu.
- **PM İçin:** Kapsam sapması oranı, DoD tamamlanma yüzdesi, sprint velocity.

### ADIM 4: RAPORU ÜRET VE KAYDET
1. `templates/sector-report-template.md` şablonunu doldur.
2. Raporu `.olaf/reports/` dizinine kaydet:
   - Örn: `.olaf/reports/REPORT-BACKEND-TASK-05-20261024.md`
   - Örn: `.olaf/reports/REPORT-SECURITY-AUDIT-20261024.md`
   - Örn: `.olaf/reports/REPORT-SPRINT-01-20261024.md`
3. Rapor dizini `.gitignore` ve exclude kapsamında olduğundan **asla commit edilmez (Ghost Modu korunur)**.

### ADIM 5: KULLANICIYA YÖNETİCİ ÖZETİ SUNMA
Kullanıcıya sohbet penceresinde şu formatta profesyonel bir teslimat mesajı sun:
- **Başlık ve Hedef Ajan / Görev**
- **Yönetici Özeti (3-4 maddelik C-Level özet)**
- **Standart Uyumluluk Skoru (Örn: 94/100)**
- **Varsa Tespit Edilen Riskler ve Önerilen Aksiyonlar**
- **Tam Rapor Linki (`file://...`)**

---

## 🔒 RAPORLAMA ETİK KURALLARI

1. **Sıfır Halüsinasyon:** Ölçülmeyen veya test edilmeyen hiçbir metrik raporda "tamamlandı / başarılı" gösterilemez.
2. **Objektif Denetim:** Hatalar veya eksikler örtbas edilmez; profesyonelce "İyileştirme Aksiyonu" olarak sunulur.
3. **Müdahale Yasağı:** `@reporter` yalnızca rapor üretir; kod üzerinde hiçbir değişiklik yapmaz.

