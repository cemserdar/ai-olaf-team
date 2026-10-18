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
   - Her görev için sorumlu ajanı ve çalışma sırasını ata.

### ADIM 3: AJANLARIN SIRAYLA ÇALIŞTIRILMASI (HANDOVER ZİNCİRİ)
`@pm` olarak aşağıdaki standart teslim zincirini koordine et:

1. **İş Analizi (@ba):** Belirsiz gereksinimleri netleştir, kabul kriterlerini ve edge-case senaryolarını yaz.
2. **Mimari Onay (@architect):** Eklenecek sınıfların, katmanların ve desenlerin mimariye uygunluğunu onayla.
3. **Veritabanı Hazırlığı (@db):** Varsa Entity, Fluent API konfigürasyonu ve Migration oluştur.
4. **Backend Geliştirme (@backend):** Servis, DTO, Repository ve Controller/Endpoint kodlarını yaz.
5. **Gerçek Zamanlı Akış (@realtime):** Gerekliyse Hub, BackgroundService veya Queue consumer kodlarını ekle.
6. **Frontend / Mobil Geliştirme (@frontend / @mobile / @uiux):** UI bileşenlerini ve API entegrasyonlarını yap.
7. **Güvenlik Denetimi (@security):** Yazılan kodun auth, input validation ve yetki kontrollerini sına.
8. **Test Yazımı (@qa):** İlgili fonksiyonlar ve endpoint'ler için birim/entegrasyon testlerini yaz.
9. **Temizlik ve İnceleme (@refactor):** Kod kokularını ve gereksiz tekrarları temizle.
10. **Dokümantasyon (@docs):** Swagger, README veya mimari diyagramları güncelle.
11. **Hukuki / Lisans Denetimi (@legal):** Yeni paket veya kişisel veri eklendiyse denetle.
12. **DevOps & CI/CD (@devops):** Gerekirse Dockerfile ve pipeline ayarlarını güncelle.

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
