# 🏛️ /arch-review — Proaktif Mimari İnceleme ve Öneri İş Akışı

Bu iş akışı, `@architect` ajanının mevcut projeyi derinlemesine analiz edip hataları, performans risklerini ve daha uygun mimari alternatifleri **hiçbir değişiklik yapmadan** kullanıcıya sunmasını sağlar.

---

## 🎯 İŞ AKIŞI HEDEFİ

Kullanıcının projesindeki mimari sorunları, yavaşlık risklerini ve iyileştirme fırsatlarını tespit ederek önceliklendirilmiş bir rapor üretmek. **Kullanıcı açıkça onaylamadan hiçbir değişiklik yapılmaz.**

---

## ⚙️ TETİKLEYİCİLER

Bu iş akışı şu durumlarda çalışır:

1. **Kullanıcı doğrudan tetikler:** `/arch-review` komutunu yazar.
2. **`/olaf-train` sonrası otomatik:** Eğitim tamamlandığında `@architect` özet analiz raporu çıkarır.
3. **Büyük sprint başlangıcında:** `@pm` 3 veya daha fazla görevli sprint planlarken `@architect`'e paralel analiz yaptırır.

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### ADIM 1: HAFIZAyı YÜKLE (SEÇİCİ GETİRME)

`@architect` analizi başlatmadan önce seçici hafıza motoruyla ilgili bölümleri çeker:

```bash
# Mimari yapı ve teknoloji yığını
./scripts/olaf-query-memory.sh --file brain --section architecture
./scripts/olaf-query-memory.sh --file brain --section tech-stack
./scripts/olaf-query-memory.sh --file brain --section database
./scripts/olaf-query-memory.sh --file skills --agent architect --section architecture
```

### ADIM 2: PROJE TARAMASI (DOSYA KAPSAMI İÇİNDE)

`@architect` yalnızca şu dosyaları okur (değiştirmez):

| Kategori | Hedef Dosyalar |
| :--- | :--- |
| **Yapılandırma** | `*.sln`, `*.csproj`, `pom.xml`, `package.json`, `build.gradle`, `pyproject.toml` |
| **Katman Yapısı** | Proje kök klasörü ve alt klasör hiyerarşisi |
| **API Tanımları** | `*Controller.cs`, `*Router.*`, `*Handler.*`, `endpoints/**` |
| **Veri Erişimi** | `*Repository.*`, `*DbContext.*`, `*Migration.*`, `schema.*` |
| **Bağımlılık Tanımları** | `appsettings.json`, `.env.example`, `docker-compose.yml` |
| **Test Altyapısı** | `tests/**`, `__tests__/**`, `spec/**` |

> **KURAL:** `@architect` bu adımda **yalnızca okur**, tek bir satır değiştirmez.

### ADIM 3: BULGU ANALİZİ

`@architect` tarama sonuçlarını şu başlıklarda değerlendirir:

#### 🔴 Kritik Bulgular (Hemen düzeltilmeli)
- **Katman Bağımlılık İhlali:** Web/API katmanı Domain katmanına doğrudan bağımlı mı?
- **N+1 Sorgu Riski:** Repository içinde döngü içinde sorgu var mı?
- **Hardcoded Secret/Credential:** Kaynak kodda API anahtarı veya şifre var mı?
- **Async Deadlock Riski:** `.Result` veya `.Wait()` async context içinde kullanılıyor mu?
- **SQL Injection Riski:** Parametresiz ham SQL string birleştirme var mı?
- **Auth Eksikliği:** Kritik endpoint'lerde yetkilendirme kontrolü yok mu?

#### 🟡 Uyarılar (Planlanmalı)
- **Eski/Desteksiz Kütüphane:** LTS dışı veya son sürümün 2+ major gerisinde paket var mı?
- **Test Kapsamı Eksikliği:** Birim test hiç yok mu veya kritik iş kuralı test edilmemiş mi?
- **Anemic Domain Model:** Entity'ler yalnızca get/set property içeriyor, davranış yok mu?
- **Tanrı Sınıf (God Class):** Tek bir sınıf çok fazla sorumluluk üstlenmiş mi?
- **Konfigürasyon Karmaşası:** Environment-specific değerler hardcoded mi?

#### 🟢 Öneriler (Değerlendirilebilir)
- **Mimari Alternatif:** Mevcut yapıya göre daha uygun bir mimari var mı?
- **Cache Katmanı:** Sık erişilen sorgular için Redis/MemoryCache eklenmeli mi?
- **Pagination Eksikliği:** Liste sorguları sınırsız veri döndürüyor mu?
- **CQRS Fırsatı:** Okuma ve yazma operasyonları ayrılabilir mi?
- **Circuit Breaker:** Dış servis çağrılarında dayanıklılık mekanizması var mı?

### ADIM 4: RAPOR OLUŞTUR

`@architect`, `templates/arch-review-report-template.md` şablonunu kullanarak raporu `.olaf/reports/arch-review-{TARİH}.md` dosyasına yazar. Rapor **ghost modda** tutulur — hiçbir zaman commit edilmez.

### ADIM 5: KULLANICIYA SUN VE KARAR BEKLE

`@architect` raporu kullanıcıya sunar ve **her bulgu için ayrı ayrı** onay ister:

```
📋 Mimari İnceleme Tamamlandı — {PROJE_ADI}

🔴 Kritik: {N} bulgu
🟡 Uyarı:  {N} bulgu  
🟢 Öneri:  {N} bulgu

Her bulgu için kararınızı bildirin:
  [A-1] Onayla  → @pm sprint'e ekler
  [A-1] Reddet  → kayıt tutulur, dokunulmaz
  [A-1] Anlat   → @architect detay açıklar
```

> [!CAUTION]
> **MUTLAK KURAL:** Kullanıcı "Onayla" demeden **hiçbir bulgu için** kod, konfigürasyon veya herhangi bir proje dosyası değiştirilmez. `@architect` yalnızca açıklar ve bekler.

### ADIM 6: ONAY SONRASI HAREKET

Kullanıcı bir bulguyu onaylarsa:

1. `@pm`, onaylanan bulguyu aktif sprint'e yeni bir `TASK-XX` olarak ekler.
2. İlgili ajan için `templates/task-context-brief-template.md` şablonuyla brief hazırlanır.
3. Standart orkestrasyon akışı başlar (`/pm` iş akışı devreye girer).
4. Reddedilen bulgular `.olaf/reports/arch-review-{TARİH}.md` içinde `REDDEDILDI` işaretiyle arşivlenir.

---

## 🔒 DEĞİŞİKLİK KAPISI (CHANGE GATE — DEĞİŞTİRİLEMEZ KURAL)

```
ANALIZ → RAPOR → KULLANICI KARARI → (Onaylandıysa) SPRINT PLANLAMASI → DEĞİŞİKLİK
```

Bu zincirin **her halkası** tamamlanmadan bir sonrakine geçilemez. `@architect` analiz ve rapor aşamasından öteye tek başına ilerleyemez.

---

## 📂 ÇIKTI DOSYALARI

| Dosya | Nerede | Git'e Girer mi? |
| :--- | :--- | :--- |
| `.olaf/reports/arch-review-{TARİH}.md` | `.olaf/reports/` | ❌ Hayır (ghost mode) |
| Onaylanan bulgular → aktif sprint | `.olaf/memory/active-sprint.md` | ❌ Hayır (ghost mode) |

