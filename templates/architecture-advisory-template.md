# 💡 PROAKTİF MİMARİ DANIŞMANLIK BÜLTENİ (ARCHITECTURE ADVISORY)

> **Proje Adı:** {{PROJECT_NAME}}  
> **Tarih:** {{ADVISORY_DATE}}  
> **Analist:** `@architect`  
> **Konu:** {{ADVISORY_SUBJECT}}  
> **Durum:** ⏳ KULLANICI KARARI BEKLENİYOR — **Kodda hiçbir değişiklik yapılmadı**  

---

## 🔍 1. TESPİT VE MEVCUT DURUM
- **İlgili Dosya / Katman:** `{{AFFECTED_COMPONENT}}`
- **Mevcut Yapı:** {{CURRENT_IMPLEMENTATION}}
- **Tespit Türü:** 🔴 Mimari Hata / 🟡 Yavaşlık & Darboğaz / 🟢 Daha Uygun Alternatif

---

## ⚠️ 2. RİSK ANALİZİ (NEDEN DEĞİŞMELİ?)
- **Teknik / Performans Riski:** {{TECHNICAL_RISK}}
- **Büyüme & Bakım Maliyeti:** {{MAINTENANCE_IMPACT}}
- **Potansiyel Çökme / Tıkanma Senaryosu:** {{FAILURE_SCENARIO}}

---

## 🚀 3. ÖNERİLEN ÇÖZÜM VEYA ALTERNATİF MİMARİ
- **Önerilen Model:** {{PROPOSED_ARCHITECTURE}}
- **Sağlayacağı Faydalar:**
  - ⚡ {{BENEFIT_1}}
  - 🛡️ {{BENEFIT_2}}
- **Değişiklik Büyüklüğü (Efor):** `Küçük (1-2 dosya) / Orta (Modül seviyesi) / Büyük (Mimari geçiş)`
- **Geriye Dönük Uyumluluk (Breaking Change):** `YOK / VAR (Geçiş stratejisi ile)`

---

## 🔒 4. KULLANICI KARAR KAPISI (ZERO-TOUCH CONSENT GATE)

Aşağıdaki seçeneklerden birini belirterek kararınızı iletebilirsiniz:

- **👉 [1] Mevcut Yapıyı Koru (Öneriyi Reddet):**  
  Mevcut mimarinize ve kodlama alışkanlığınıza %100 sadık kalınarak geliştirmeye devam edilir. Bu karar `project-brain.md` içine *"Kullanıcı Tercihi"* olarak kaydedilir ve aynı öneri bir daha tekrarlanmaz.

- **👉 [2] Öneriyi Onayla ve Planla:**  
  `@pm` bu iyileştirmeyi kontrollü bir refactoring görevi (`TASK-XX`) olarak sprint tahtasına ekler. Dosya kapsamı belirlenir ve güvenli geçiş sağlanır.

- **👉 [3] Detay Açıkla / Tartış:**  
  `@architect` teknik gerekçeleri, benchmark verilerini ve mimari detayları açıklar; karar verene kadar hiçbir kod değiştirilmez.

> [!CAUTION]
> **GARANTİ:** Kullanıcı açıkça **"Onayla"** veya **"[2]"** demedikçe, AI Olaf Team projenizin mimarisinde, paketlerinde veya kodlarında **kesinlikle hiçbir değişiklik yapamaz**.
