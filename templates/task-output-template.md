# 📤 GÖREV ÇIKTI MANİFESTİ — {{TASK_ID}}

> **Görev Kimliği:** `{{TASK_ID}}`  
> **Tamamlayan Ajan:** `{{RESPONSIBLE_AGENT}}`  
> **Tamamlanma Tarihi:** {{COMPLETED_AT}}  
> **Temel Alınan Snapshot Hash:** `{{SNAPSHOT_COMMIT_HASH}}`  
> **Durum:** TAMAMLANDI ✅ <!-- TAMAMLANDI | KISMİ | BAŞARISIZ -->  

---

## 🎯 1. GERÇEKLEŞTİRİLEN İŞİN ÖZETİ
{{EXECUTION_SUMMARY}}

---

## 📂 2. DEĞİŞTİRİLEN VE OLUŞTURULAN DOSYALAR
| Dosya Yolu | İşlem Türü | Açıklama |
| :--- | :--- | :--- |
| `{{FILE_PATH_1}}` | Oluşturuldu / Güncellendi | {{FILE_DESC_1}} |
| `{{FILE_PATH_2}}` | Güncellendi | {{FILE_DESC_2}} |

---

## 🔌 3. ÜRETİLEN KONTRATLAR, MODEL VEYA ARAYÜZLER (SONRAKİ AJANLAR İÇİN)
*Sonraki bağımlı ajanların (örn: frontend, mobile, qa) doğrudan referans alabileceği DTO, endpoint veya method imzaları:*

```{{LANGUAGE}}
{{CONTRACT_OR_SNIPPET}}
```

---

## 💡 4. ALINAN MİMARİ VE TEKNİK KARARLAR
- **Karar 1:** {{DECISION_1}}
- **Karar 2:** {{DECISION_2}}

---

## 🔗 5. BAĞIMLI VE SONRAKİ GÖREVLER İÇİN NOTLAR (HANDOVER NOTES)
- `@{{NEXT_AGENT}}` için entegrasyon notu: {{HANDOVER_NOTE}}

---

## 🧪 6. DOĞRULAMA VE KALİTE RAPORU
- [ ] Kapsam dışı hiçbir dosyaya dokunulmadı.
- [ ] Kod derlendi / sözdizim hatası yok (`dotnet build` / `npm run build` vb. uyumlu).
- [ ] Gerekli birim testler hazırlandı / çalıştırıldı.
- [ ] `.olaf/learned-skills/{{AGENT_SKILL_FILE}}` güncellendi.
