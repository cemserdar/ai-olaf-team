# 📊 TEKNİK DENETİM VE DEĞERLENDİRME RAPORU
## {{REPORT_TITLE}}

> **Proje:** `{{PROJECT_NAME}}`  
> **Raporlayan:** `@reporter` (Kıdemli Teknik Raporlama Uzmanı)  
> **İncelenen Kapsam / Ajan:** `{{TARGET_AGENT_OR_TASK}}`  
> **Tarih:** {{REPORT_DATE}}  
> **Git Snapshot Hash:** `{{SNAPSHOT_COMMIT_HASH}}`  
> **Uygulanan Sektör Standardı:** `{{APPLIED_STANDARD}}` <!-- Örn: ISO/IEC 25010, IEEE 829, DORA, OWASP Top 10, RFC 7807 -->  

---

## Executive Summary (Yönetici Özeti — 60 Saniyelik Bakış)

{{EXECUTIVE_SUMMARY}}

### 🚦 Genel Değerlendirme Özeti
- **Operasyonel Durum:** 🟢 BAŞARILI / 🟡 DİKKAT GEREKTİRİR / 🔴 KRİTİK RİSK
- **Standart Uyumluluk Skoru:** `{{COMPLIANCE_SCORE}} / 100`
- **Teslim Edilen Yetenek:** {{FEATURE_DELIVERED_SUMMARY}}
- **Öne Çıkan Değer:** {{BUSINESS_VALUE_DELIVERED}}

---

## 🎯 1. GÖREV KAPSAMI VE DOĞRULANAN ÇIKTILAR

| Kriter | Detay / Durum | Doğrulama Kaynağı |
| :--- | :--- | :--- |
| **İncelenen Görev ID** | `{{TASK_ID}}` | `.olaf/contexts/{{TASK_ID}}-brief.md` |
| **Sorumlu Ajan** | `{{RESPONSIBLE_AGENT}}` | `.olaf/outputs/{{TASK_ID}}-output.md` |
| **Dosya Kapsamı Sadakati** | 🟢 %100 Kapsam İçi / ⚠️ Kapsam Aşımı Var | File Scope Karşılaştırması |
| **Kabul Kriterleri (DoD)** | `{{DOD_PASSED_COUNT}} / {{DOD_TOTAL_COUNT}}` Tamamlandı | DoD Kontrol Listesi |

### 📁 Değiştirilen / Üretilen Dosyalar:
```text
{{MODIFIED_FILES_LIST}}
```

---

## 🔬 2. TEKNİK DERİNLİK VE MİMARİ ANALİZ (TECHNICAL DEEP-DIVE)

### Mimari Entegrasyon ve Veri Akışı
{{ARCHITECTURE_BREAKDOWN}}

### Uygulanan Tasarım Desenleri ve Pratikler:
- **Tasarım Deseni:** `{{DESIGN_PATTERNS_USED}}`
- **Hata Yönetimi Standardı:** `{{ERROR_HANDLING_STANDARD}}`
- **Asenkronluk ve Kaynak Yönetimi:** `{{ASYNC_RESOURCE_MANAGEMENT}}`

---

## 📐 3. SEKTÖR STANDARTLARI VE KALİTE METRİKLERİ TABLOSU

Aşağıdaki tablo, `{{APPLIED_STANDARD}}` çerçevesinde yapılan ölçüm ve değerlendirmeleri içerir:

| Kalite Boyutu / Metrik | Ölçülen Değer / Durum | Hedef / Standart Eşiği | Değerlendirme |
| :--- | :--- | :--- | :---: |
| **Fonksiyonel Uygunluk** | {{METRIC_1_VAL}} | %100 DoD Kapsamı | 🟢 Başarılı |
| **Performans & Verimlilik** | {{METRIC_2_VAL}} | SLA < 200ms / Sıfır N+1 | 🟢 Başarılı |
| **Güvenilirlik & Hata Toleransı** | {{METRIC_3_VAL}} | Global Exception & Log | 🟢 Başarılı |
| **Sürdürülebilirlik & Clean Code** | {{METRIC_4_VAL}} | SOLID / Düşük Karmaşıklık | 🟢 Başarılı |
| **Güvenlik & AppSec Hijyeni** | {{METRIC_5_VAL}} | OWASP Sıfır Kritik Açık | 🟢 Başarılı |

---

## ⚠️ 4. RİSK ANALİZİ VE TEKNİK BORÇ ENVANTERİ

İnceleme sonucunda tespit edilen potansiyel riskler ve iyileştirme tavsiyeleri:

| Risk / Eksiklik | Seviye | Olası Etki | Önerilen Aksiyon |
| :--- | :---: | :--- | :--- |
| `{{RISK_1_TITLE}}` | 🔴 Yüksek / 🟡 Orta / 🟢 Düşük | {{RISK_1_IMPACT}} | {{RISK_1_ACTION}} |
| `{{RISK_2_TITLE}}` | 🔴 Yüksek / 🟡 Orta / 🟢 Düşük | {{RISK_2_IMPACT}} | {{RISK_2_ACTION}} |

---

## 🔒 5. DENETİM İZİ VE İMZA (AUDIT TRAIL & REPRODUCIBILITY)

Bu rapor, AI Olaf Team izole denetim motoru tarafından deterministik olarak üretilmiştir:
- **Rapor ID:** `REP-{{REPORT_ID}}`
- **Denetlenen Snapshot:** `git rev-parse --short HEAD` -> `{{SNAPSHOT_COMMIT_HASH}}`
- **Rapor Dosya Yolu:** `.olaf/reports/{{REPORT_FILENAME}}`
- **Raporlayan:** `@reporter` (Kıdemli Teknik Raporlama Uzmanı)  
- **Tarih & Saat:** {{TIMESTAMP}}  

> *Not: Bu rapor `.olaf/reports/` altında saklanır ve projenin iş kodları reposuna sızmaz (Ghost Modu).*

