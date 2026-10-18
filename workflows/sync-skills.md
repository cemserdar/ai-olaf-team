# 🔄 /sync-skills - Hafıza Eşitleme ve Dinamik Yetenek Güncelleme İş Akışı

Bu iş akışı, projede manuel olarak veya diğer araçlarla yapılan son kod değişikliklerini tarayarak 15 kişilik AI Olaf Team'in hafıza dosyalarını (`.olaf/learned-skills/`) ve mimari beynini (`.olaf/memory/project-brain.md`) anlık olarak günceller.

---

## 🎯 İŞ AKIŞI HEDEFİ
Projedeki son git commit'leri, staging değişiklikleri veya yeni eklenen dosya ve paketleri analiz ederek ajanların güncel kod gerçekliğinden kopmasını engellemek ve hafızalarını taze tutmak.

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### ADIM 1: GİT DURUMU VE DEĞİŞİKLİK TARAMASI
1. Projedeki son değişiklikleri listele:
   - `git status --short` komutu ile staged ve unstaged dosyaları gör.
   - `git diff --stat HEAD~1` veya son commit diff'lerini incele.
   - Eğer git yoksa, dosya oluşturma/değiştirme zaman damgalarını (mtime) tara.
2. Değiştirilen dosyaları sorumluluk alanlarına göre sınıflandır:
   - `*.cs`, `*.java`, `Controllers/`, `Services/` -> `@backend`
   - `DbContext`, `Migrations/`, `*.sql`, `Entities/` -> `@db`
   - `Hubs/`, `Consumers/`, `Workers/`, `RabbitMQ` -> `@realtime`
   - `src/components/`, `src/pages/`, `*.tsx`, `*.vue` -> `@frontend`, `@uiux`
   - `screens/`, `navigation/`, `app.json` -> `@mobile`
   - `Dockerfile`, `docker-compose.yml`, `.github/` -> `@devops`
   - `tests/`, `*.Tests.cs`, `*.spec.ts` -> `@qa`
   - `package.json`, `*.csproj`, `pom.xml` -> `@legal`, `@security`, `@architect`

### ADIM 2: İLGİLİ AJANLARIN SKILL DOSYALARINI GÜNCELLE
Tespit edilen her dosya grubu için ilgili ajanın `.olaf/learned-skills/<agent>-skills.md` dosyasını aç:
1. **Yeni Eklenen Sınıf veya Modeller:** Ajanın sorumlu olduğu modeller listesine ekle.
2. **Değişen Metot İmzaları / Kurallar:** Yeni bir servis sonucu tipi (örn. `Result<T>`) veya yeni bir doğrulama kuralı geldiyse kurallar bölümüne kaydet.
3. **Yeni Bağımlılıklar (NuGet / NPM / Maven):** İlgili kütüphaneyi ve sürümünü ajanın araç çantasına ekle.
4. **Öğrenme Günlüğü:** `ÖĞRENME GÜNLÜĞÜ (LEARNING CHANGELOG)` altına bugünün tarihini ve yapılan güncellemeyi tek satır olarak not düş.

### ADIM 3: `.olaf/memory/project-brain.md` BEYNİNİ TAZELE
1. Son commit ID'sini, tarihini ve commit mesajını dosyanın `GİT GEÇMİŞİ VE SON DEĞİŞİKLİKLER` bölümüne yaz.
2. Varsa yeni açılan API endpoint'lerini veya veritabanı tablolarını mimari haritaya ekle.

### ADIM 4: KULLANICIYA GÜNCELLEME RAPORU VER
Kullanıcıya hangi ajanların hafızasının güncellendiğini listeleyen kısa ve net bir Türkçe bildirim göster:
- Güncellenen ajan skill dosyaları (örn: `@backend` -> `backend-skills.md`, `@db` -> `db-skills.md`)
- Tespit edilen yeni mimari veya kural değişiklikleri
- Takımın son kod yapısıyla tamamen senkronize olduğu teyidi.
