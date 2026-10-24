# 🏛️ Mimari İnceleme Raporu — {{PROJECT_NAME}}

> **Analist:** `@architect`  
> **Tarih:** {{REVIEW_DATE}}  
> **Proje Snapshot (Git Commit):** `{{SNAPSHOT_COMMIT_HASH}}`  
> **Durum:** ⏳ ONAY BEKLENİYOR — **Hiçbir değişiklik yapılmadı, hiçbir şey değiştirilmeyecek**

---

## 📊 Özet Tablo

| Seviye | Adet | Açıklama |
| :--- | :---: | :--- |
| 🔴 Kritik | {{CRITICAL_COUNT}} | Hemen ele alınması önerilen bulgular |
| 🟡 Uyarı | {{WARNING_COUNT}} | Planlanması önerilen bulgular |
| 🟢 Öneri | {{SUGGESTION_COUNT}} | Değerlendirilebilecek iyileştirmeler |
| ✅ Sağlıklı | {{HEALTHY_COUNT}} | İyi durumda olan alanlar |

---

## 🔴 KRİTİK BULGULAR

<!-- Kritik bulgu yoksa bu bölümü "Kritik bulgu tespit edilmedi." ile doldurun -->

### [C-1] {{CRITICAL_TITLE_1}}

- **Etkilenen Alan:** `{{AFFECTED_FILE_OR_LAYER_1}}`
- **Risk:** {{RISK_DESCRIPTION_1}}
- **Neden Kritik:** {{WHY_CRITICAL_1}}
- **Önerilen Çözüm Yönü:** {{SUGGESTED_DIRECTION_1}} *(Uygulama değil, yön tarifi)*
- **Değişiklik Büyüklüğü:** `Küçük / Orta / Büyük`
- **Karar:** ⏳ Bekleniyor

---

## 🟡 UYARILAR

<!-- Uyarı yoksa bu bölümü "Uyarı tespit edilmedi." ile doldurun -->

### [W-1] {{WARNING_TITLE_1}}

- **Etkilenen Alan:** `{{AFFECTED_FILE_OR_LAYER_W1}}`
- **Risk:** {{RISK_DESCRIPTION_W1}}
- **Önerilen Çözüm Yönü:** {{SUGGESTED_DIRECTION_W1}}
- **Değişiklik Büyüklüğü:** `Küçük / Orta / Büyük`
- **Karar:** ⏳ Bekleniyor

---

## 🟢 ÖNERİLER

<!-- Öneri yoksa bu bölümü "Yapısal öneri bulunmuyor." ile doldurun -->

### [S-1] {{SUGGESTION_TITLE_1}}

- **Etkilenen Alan:** `{{AFFECTED_FILE_OR_LAYER_S1}}`
- **Potansiyel Fayda:** {{BENEFIT_S1}}
- **Önerilen Yaklaşım:** {{SUGGESTED_APPROACH_S1}}
- **Değişiklik Büyüklüğü:** `Küçük / Orta / Büyük`
- **Karar:** ⏳ Bekleniyor

---

## ✅ SAĞLIKLI ALANLAR

Aşağıdaki konularda proje iyi durumda, dokunulması önerilmez:

- {{HEALTHY_AREA_1}}
- {{HEALTHY_AREA_2}}

---

## 📋 ONAY TABLOSU

Aşağıdaki her bulgu için bağımsız karar verebilirsiniz:

| Bulgu Kodu | Başlık | Büyüklük | Karar |
| :--- | :--- | :---: | :--- |
| [C-1] | {{CRITICAL_TITLE_1}} | Orta | ⏳ Bekleniyor |
| [W-1] | {{WARNING_TITLE_1}} | Küçük | ⏳ Bekleniyor |
| [S-1] | {{SUGGESTION_TITLE_1}} | Büyük | ⏳ Bekleniyor |

**Yanıt seçenekleri her bulgu için:**
- **`[C-1] Onayla`** → `@pm` bunu sprint'e `TASK-XX` olarak ekler, standart görev akışı başlar
- **`[C-1] Reddet`** → Bu raporda `REDDEDILDI` işaretiyle arşivlenir, dokunulmaz
- **`[C-1] Anlat`** → `@architect` detay açıklar; hiçbir şey değişmez

> [!IMPORTANT]
> Kullanıcı hiçbir şey söylemeden **`@architect` kendi başına hiçbir değişiklik yapmaz**.  
> Bu rapor yalnızca bir bilgilendirme ve karar belgesidir.

---

## 📂 Rapor Arşiv Notu

Bu dosya `.olaf/reports/` dizininde saklanır ve **git'e commit edilmez** (ghost mode).  
Onaylanan bulgular `@pm` tarafından `.olaf/memory/active-sprint.md` dosyasına görev olarak eklenir.

