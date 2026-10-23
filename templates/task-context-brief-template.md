# 📋 CONTEXT BRIEF — {{TASK_ID}}

> **Görev Kimliği:** `{{TASK_ID}}`  
> **Sorumlu Ajan:** `{{RESPONSIBLE_AGENT}}` <!-- Örn: @backend, @mobile, @frontend -->  
> **Oluşturulma Tarihi:** {{CREATED_AT}}  
> **Proje Brain Snapshot (Git Commit):** `{{SNAPSHOT_COMMIT_HASH}}`  
> **Görev Durumu:** HAZIR <!-- HAZIR | DEVAM | TAMAMLANDI | BLOKE -->  

---

## 🎯 1. GÖREV TANIMI VE KABUL KRİTERLERİ (ACCEPTANCE CRITERIA)

### Görev Amacı
{{TASK_GOAL}}

### Kabul Kriterleri (DoD - Definition of Done)
- [ ] {{CRITERIA_1}}
- [ ] {{CRITERIA_2}}
- [ ] {{CRITERIA_3}}

---

## 📂 2. DOSYA KAPSAMI (FILE SCOPE DISCIPLINE)

> **KESİN KURAL:** Ajan yalnızca bu listede belirtilen dosyaları okuyabilir ve değiştirebilir. Kapsam dışındaki hiçbir dosya açılmamalı, taranmamalı veya değiştirilmemelidir. Başka bir dosyaya ihtiyaç duyulursa `@pm`'e bildirilerek brief güncellenmelidir.

### 📖 Okunabilir Dosyalar (READ ONLY)
- `{{READ_FILE_1}}`
- `{{READ_FILE_2}}`

### ✏️ Yazılabilir / Değiştirilebilir Dosyalar (WRITE ALLOWED)
- `{{WRITE_FILE_1}}`
- `{{WRITE_FILE_2}}`

### 🚫 Kapsam Dışı Dosyalar (STRICTLY OUT OF SCOPE)
- Diğer kulvarların çalışma dosyaları
- `.olaf/` altındaki diğer ajan context ve çıktı dosyaları
- Proje kökündeki global orkestrasyon dosyaları

---

## 🔗 3. BAĞIMLILIKLAR VE ÖNCEL İŞ ÇIKTILARI (PREDECESSOR OUTPUTS)

Bu görevin başlaması için tamamlanmış olması gereken ön koşul görevlerin çıktı özetleri:

| Bağımlı Görev | Sorumlu Ajan | Çıktı Dosyası | Durum |
| :--- | :--- | :--- | :--- |
| `{{PRED_TASK_ID}}` | `{{PRED_AGENT}}` | `.olaf/outputs/{{PRED_TASK_ID}}-output.md` | TAMAMLANDI |

> *Ajan, yalnızca yukarıda linki verilen çıktı dosyasındaki DTO, sözleşme, interface veya veri yapılarını baz alacaktır; önceki görevin geçmiş sohbet loglarını okumaz.*

---

## 🧬 4. AJANIN KULLANACAĞI HAFIZA VE KURALLAR

Bu görev sırasında geçerli olan DNA ve proje yetenekleri:
1. `base-agents/{{AGENT_DNA_FILE}}`
2. `.olaf/learned-skills/{{AGENT_SKILL_FILE}}`

---

## ⚠️ 5. BU GÖREVE ÖZEL DİKKAT EDİLECEK ANTİ-PATTERNLER

- ❌ {{ANTI_PATTERN_1}}
- ❌ {{ANTI_PATTERN_2}}

---

## 📦 6. TESLİMAT VE ÇIKTI TALİMATI

Görev tamamlandığında:
1. Yalnızca kapsamındaki dosyaları değiştirmiş olduğunu doğrula.
2. `.olaf/outputs/{{TASK_ID}}-output.md` dosyasına standart manifesti yaz.
3. `.olaf/learned-skills/{{AGENT_SKILL_FILE}}` dosyasını yeni öğrenilen kurallarla güncelle.
4. `@pm`'e tek cümlelik başarı özeti bildir.
