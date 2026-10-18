# 🧠 {{AGENT_NAME}} - Projeye Özel Öğrenilmiş Yetenek ve Kurallar Dosyası

> **Ajan Rolü:** {{AGENT_ROLE}}  
> **Etiket:** `{{AGENT_TAG}}`  
> **Son Güncelleme:** {{LAST_UPDATED}}  
> **Öğrenme Durumu:** {{TRAINING_STATUS}}  

---

## 🎯 1. PROJEYE ÖZEL KEŞFEDİLEN MİMARİ VE TEKNOLOJİ BAĞLAMI
Bu bölümde, ajanın bu spesifik projede yaptığı analizler sonucunda keşfettiği temel mimari kararlar yer alır:

- **Mimari Tip:** (Örn: Clean Architecture, Vertical Slice, Modüler Monolit, Mikroservis vb.)
- **Kullanılan Dil ve Sürüm:** (Örn: .NET 8 / C# 12, Java 21 / Spring Boot 3, TypeScript 5.4 vb.)
- **Aktif Kütüphaneler ve Sürümler:** (Örn: EF Core 8.0, MediatR, FluentValidation, AutoMapper vb.)
- **Katman / Modül Sorumlulukları:** (Örn: Domain, Application, Infrastructure, WebApi)

---

## 📐 2. KESİN KODLAMA VE TASARIM STANDARTLARI (ENFORCED CONVENTIONS)
Bu projenin kaynak kodlarında tespit edilen ve yazılacak her yeni kodda zorunlu uyulacak pratikler:

- **İsimlendirme Kuralları (Naming Conventions):**
  - Dosya ve Sınıf İsimleri:
  - Değişken ve Metot İsimleri:
  - DTO ve Request/Response İsimleri:
- **Metot ve Servis Dönüş Tipleri:** (Örn: `ServiceResult<T>`, `ApiResponse<T>`, `IActionResult` vb.)
- **Dependency Injection Kuralları:** (Örn: Servisler `Scoped`, Doğrulayıcılar `Transient`, Konfigürasyonlar `Singleton`)
- **Hata Yönetimi ve Exception Standartları:** (Örn: Global Exception Middleware, Result pattern, DomainException)
- **Asenkron Programlama:** (Tüm I/O işlemlerinde `async/await` ve `CancellationToken` kullanımı)

---

## 🗄️ 3. İLİŞKİLİ VERİ, MODELLER VE BİLEŞENLER
Ajanın görev alanına giren proje bileşenleri ve bağımlılık haritası:

- **Sorumlu Olduğu Entity / Modeller:**
- **Kullandığı / İncelediği Servisler:**
- **İlişkili Endpoint'ler veya Arayüz Bileşenleri:**
- **Veri Akış Şeması:**

---

## 🚫 4. ASLA YAPILMAYACAKLAR (PROJECT-SPECIFIC ANTI-PATTERNS)
Bu projede kesinlikle ihlal edilmemesi gereken kural dışı durumlar:

- [ ] Projede belirlenen kütüphane dışına çıkma (Örn: EF Core varken Dapper ekleme).
- [ ] İş kurallarını Controller veya UI bileşeni içine yazma.
- [ ] Hardcoded bağlantı dizesi veya şifre bırakma.
- [ ] Asenkron metotlarda `.Result` veya `.Wait()` kullanarak thread kilitleme.
- [ ] Katman bağımlılık yönünü ihlal etme.

---

## ✅ 5. HER GÖREVDE ZORUNLU YAPILACAKLAR (CHECKLIST)
Her kod üretiminde veya düzenlemesinde kontrol edilecek maddeler:

- [ ] `.olaf/memory/project-brain.md` güncel durumunu oku.
- [ ] Mevcut kod desenlerine (design patterns) %100 sadık kal.
- [ ] Yazılan her metot için parametre ve sınır değer kontrollerini yap.
- [ ] Görev tamamlandığında bu dosyadaki öğrenilmiş kuralları güncelle.
- [ ] `@pm` ve ilgili diğer ajanlara durum özeti geç.

---

## 📝 6. ÖĞRENME GÜNLÜĞÜ (LEARNING CHANGELOG)
Ajanın proje geliştikçe hafızasına eklediği kritik dersler:

- **[Tarih - Görev/Commit]:** Öğrenilen yeni kural, eklenen yeni pattern veya düzeltilen anti-pattern detayı.
