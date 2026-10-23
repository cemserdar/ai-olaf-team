# 🧼 /context-handover — Temiz Context ve Görev Devir Protokolü İş Akışı

Bu iş akışı, **AI Olaf Team** bünyesindeki her bir ajan çağrısının gereksiz geçmiş sohbet kirliliğinden arındırılmış, deterministik, tekrarlanabilir (reproducible) ve yalnızca göreve odaklı **temiz bir context** ile başlatılmasını yönetir.

---

## 🎯 İŞ AKIŞI HEDEFİ

Ajan çağrılarında bağlam kirliliğini (context pollution) sıfırlamak; ajanın tüm projeyi veya geçmiş sprint konuşmalarını belleğe yüklemesini engellemek; her görevi yalnızca gereken dosya kapsamı, kabul kriterleri ve önceki iş çıktısıyla sınırlı tutarak token tasarrufu, hız ve maksimum kod kalitesi sağlamak.

---

## ⚖️ CONTEXT BUDGET PRENSİPLERİ

Her ajan çağrısı için katı bir bağlam bütçesi (Context Budget) uygulanır:

| ✅ Context'e GİREN Bileşenler | ❌ Context'e ASLA GİRMEYENLER |
| :--- | :--- |
| **Görev Kimliği & Hedefi:** `TASK-XX` ve DoD (Kabul kriterleri) | **Geçmiş Sohbet:** Önceki sprint veya görev mesajlaşmaları |
| **Kapsam Listesi:** Sadece okunacak/yazılacak dosyaların yolları | **İlgisiz Dosyalar:** Görevle doğrudan ilgisi olmayan kodlar |
| **Öncel Çıktı:** Bağımlı önceki görevin `.olaf/outputs/TASK-YY-output.md` dosyası | **Diğer Kulvarlar:** Paralel yürüyen bağımsız kulvar detayları |
| **Ajan DNA:** `base-agents/<agent>.md` + `.olaf/learned-skills/<agent>-skills.md` | **Tüm Kod Tabanı Taraması:** Gereksiz global arama ve okumalar |
| **Snapshot Hash:** Görevin başladığı andaki Git commit hash'i | **Kullanıcı Ara Sohbetleri:** Görev dışı genel sorular ve diyaloglar |

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### ADIM 1: GÖREV TANIMI VE CONTEXT BRIEF OLUŞTURMA (`@pm`)
`@pm`, sprint tahtasındaki (`active-sprint.md`) bir görevi çalıştırmadan önce:
1. Mevcut Git commit hash'ini alır (`git rev-parse --short HEAD`).
2. `templates/task-context-brief-template.md` şablonunu kullanarak `.olaf/contexts/TASK-XX-brief.md` dosyasını üretir:
   - Görev amacı ve kabul kriterlerini yazar.
   - **Dosya Kapsamı (File Scope):** Ajanın okumasına izin verilen dosyaları (`READ ONLY`) ve değiştirmesine izin verilen dosyaları (`WRITE ALLOWED`) netleştirir.
   - Varsa bağımlı olduğu önceki görevin çıktı dosyasını (`.olaf/outputs/TASK-PREV-output.md`) bağlar.
3. Kapsam dışındaki tüm dosyaları yasaklar (`STRICTLY OUT OF SCOPE`).

> **KESİN KURAL:** Brief dosyası hazır olmayan hiçbir görev için alt ajan çağrılamaz.

---

### ADIM 2: TEMİZ CONTEXT İLE AJAN ÇAĞRISI
`@pm`, ilgili uzman ajana iş emrini verirken **yalnızca** şu talimatı iletir:
```text
@<ajan>, görevin: TASK-XX.
Lütfen yalnızca .olaf/contexts/TASK-XX-brief.md dosyasını oku ve belirtilen dosya kapsamı dışına çıkmadan işi tamamla.
İş bitiminde çıktını .olaf/outputs/TASK-XX-output.md dosyasına yaz.
```
Ajan:
- Önceki konuşma geçmişine bağımlı kalmaz.
- Yalnızca brief dosyasında izin verilen dosyaları okur.
- Kapsam dışı bir dosyaya dokunması gerekirse derhal durur ve `@pm`'den brief genişletmesi talep eder.

---

### ADIM 3: ÇIKTI MANİFESTİ DOLDURMA (`@<ajan>`)
Ajan görevini tamamladığında:
1. `templates/task-output-template.md` şablonunu baz alarak `.olaf/outputs/TASK-XX-output.md` dosyasını doldurur:
   - Değiştirilen dosyaların listesi.
   - Bir sonraki ajanın tüketebileceği model, DTO, interface veya method imzaları.
   - Alınan teknik kararlar ve entegrasyon notları.
2. `.olaf/learned-skills/<agent>-skills.md` dosyasını günceller.
3. `@pm`'e "TASK-XX tamamlandı, çıktısı `.olaf/outputs/TASK-XX-output.md` içine yazıldı" bildirimini yapar.

---

### ADIM 4: BAĞIMLI GÖREVE DEVİR (HANDOVER) VE ZİNCİRLEME (`@pm`)
Eğer `TASK-02`, `TASK-01` çıktısına bağımlıysa:
1. `@pm`, `TASK-02` için `.olaf/contexts/TASK-02-brief.md` dosyasını oluştururken:
   - Bağımlılıklar bölümüne `.olaf/outputs/TASK-01-output.md` linkini ekler.
2. `TASK-02`'yi yürütecek ajan çağrıldığında:
   - `TASK-01`'in uzun konuşmalarını değil, sadece `TASK-01-output.md` içindeki DTO ve sözleşmeleri okur.
   - Bu sayede zincirleme görevler arasında sıfır context kirliliği ile %100 uyum sağlanır.

---

### ADIM 5: SPRINT KAPANIŞI VE CONTEXT ARŞİVLEME
Tüm kulvarlar ve görevler tamamlandığında:
1. `@pm`, `.olaf/outputs/` altındaki tüm manifestoların doğruluğunu denetler.
2. Sprint teslimat raporunu bu manifestolar üzerinden derler.
3. `.olaf/contexts/` ve `.olaf/outputs/` dosyaları bir sonraki sprint öncesinde arşivlenir veya temizlenir; böylece yeni sprint daima sıfır kirlilikle başlar.

---

## 📐 REPRODUCIBILITY (TEKRARLANABİLİRLİK) ÖLÇÜTLERİ

Aynı görevin gelecekte veya farklı bir çalışma ortamında birebir aynı sonucu vermesi için şu formül garanti edilir:

$$\text{Deterministik Çıktı} = f(\text{Context Brief}, \text{Snapshot Commit Hash}, \text{Predecessor Outputs})$$

- **Doğrulama 1 (Hash Tutarlılığı):** Brief içindeki Git Snapshot Hash ile kodun taban sürümü eşleşmelidir.
- **Doğrulama 2 (Kapsam İzolasyonu):** Görev çıktı manifestosundaki değiştirilen dosyalar, brief'teki yazılabilir kapsam listesini aşamaz.
- **Doğrulama 3 (Arayüz Uyumu):** Bağımlı görev çıktısı, öncel görevin manifesto kontratlarına tam uyum sağlamalıdır.
