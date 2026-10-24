# 🚀 AI OLAF TEAM - Otonom, Projeden Bağımsız ve Kendi Kendini Eğiten (Self-Training) 16 Kişilik Yazılım Takımı

[![License: MIT](https://img.shields.io/badge/Lisans-MIT-blue.svg)](LICENSE)
[![Platform: Cross-Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue.svg)]()
[![IDE: Antigravity & VS Code](https://img.shields.io/badge/IDE-Antigravity%20%7C%20VS%20Code%20%7C%20Cursor-purple.svg)]()
[![Agents: 16 Experts](https://img.shields.io/badge/Ekip-16%20Uzman%20Ajan-brightgreen.svg)]()

> **"Tek bir terminal komutuyla (`olaf-init`) istediğiniz herhangi bir projeye bağlanan; mimarisini inceleyip kendi kurallarını kendisi yazan ve masaüstü/laptop bilgisayarlarınız arasında GitHub üzerinden kusursuz senkronize olan profesyonel AI yazılım takımı."**

---

## 📑 İÇİNDEKİLER
1. [🧠 Mimari Felsefe: Sabit DNA vs. Dinamik Hafıza](#-1-mimari-felsefe-sabit-dna-vs-dinamik-haf%C4%B1za)
2. [👥 16 Kişilik Uzman Kadro](#-2-16-ki%C5%9Filik-uzman-kadro)
3. [💻 İlk Kurulum ve GitHub Senkronizasyonu (Masaüstü & Laptop)](#-3-%C4%B0lk-kurulum-ve-github-senkronizasyonu-masa%C3%BCst%C3%BC--laptop)
4. [⚡ Senaryo 1: Mevcut Bir Projeye Entegrasyon (Brownfield)](#-4-senaryo-1-mevcut-bir-projeye-entegrasyon-brownfield)
5. [🌱 Senaryo 2: Sıfırdan Yeni Proje Başlatma (Greenfield)](#-5-senaryo-2-s%C4%B1f%C4%B1rdan-yeni-proje-ba%C5%9Flatma-greenfield)
6. [🛠️ Günlük İş Akışları ve /Slash Komutları](#-6-g%C3%BCnl%C3%BCk-%C4%B0%C5%9F-ak%C4%B1%C5%9Flar%C4%B1-ve-slash-komutlar%C4%B1)
7. [🏷️ Doğrudan Ajan Çağırma Örnekleri (@etiket)](#-7-do%C4%9Frudan-ajan-%C3%87a%C4%9F%C4%B1rma-%C3%96rnekleri-etiket)
8. [🛡️ Git ve Commit İzolasyonu: Sıfır Kirlilik (Ghost Modu)](#-8-git-ve-commit-izolasyonu-s%C4%B1f%C4%B1r-kirlilik-ghost-modu)
9. [📁 Merkezi Repo Dizin Mimarisi](#-9-merkezi-repo-dizin-mimarisi)
10. [⚡ Çok Kulvarlı Paralel İcra ve DevOps Release Kapısı (/orchestrate-parallel)](#-10-%C3%A7ok-kulvarl%C4%B1-paralel-%C4%B0cra-ve-devops-release-kap%C4%B1s%C4%B1-orchestrate-parallel)
11. [🧹 Temiz Context ve Görev Devir Protokolü (/context-handover)](#-11-temiz-context-ve-g%C3%B6rev-devir-protokol%C3%BC-context-handover)
12. [🧠 Seçici Hafıza ve İsteğe Bağlı Getirme (Selective Memory Retrieval — ADR-11 İla ADR-14)](#-12-se%C3%A7ici-haf%C4%B1za-ve-%C4%B0ste%C4%9Fe-ba%C4%9Fl%C4%B1-getirme-selective-memory-retrieval--adr-11-%C4%B0la-adr-14)
13. [🏛️ Proaktif Mimari İnceleme (/arch-review)](#-13-proaktif-mimari-%C4%B0nceleme-arch-review)
14. [📊 Sektör Standartlarında Raporlama Motoru (/report & @reporter)](#-14-sekt%C3%B6r-standartlar%C4%B1nda-raporlama-motoru-report--reporter)

---

## 🧠 1. MİMARİ FELSEFE: SABİT DNA VS. DİNAMİK HAFIZA

Geleneksel AI prompt sistemlerinin en büyük sorunu şudur: Her projede aynı genel tavsiyeleri verirler ve projenizin kendine has mimarisini, kütüphanelerini veya özel kurallarını unuturlar.

**AI Olaf Team** bu problemi **İki Kademeli Hafıza Modeli** ile çözer:

```text
┌──────────────────────────────────────────────────────────────┐
│  ~/ai-olaf-team/base-agents/ (SABİT ÇEKİRDEK DNA)            │
│  - 16 Ajanın evrensel mesleki uzmanlığı, temiz kod ilkeleri  │
│  - GitHub ile Masaüstü ve Laptop arasında senkronize olur    │
└──────────────────────────────┬───────────────────────────────┘
                               │ olaf-init ile projeye bağlanır
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  <projeniz>/.olaf/ (DİNAMİK ÖĞRENİLMİŞ HAFIZA)               │
│  ├── memory/project-brain.md (Projenin mimari beyni)         │
│  └── learned-skills/<agent>-skills.md (Her ajanın o          │
│      projede kendi eliyle yazdığı kurallar ve modeller)       │
└──────────────────────────────────────────────────────────────┘
```

1. **Sabit Çekirdek DNA (`base-agents/`):** Ajanların genel mühendislik bilgisi, SOLID kuralları, güvenlik hassasiyetleri ve mesleki refleksleridir. Projeden bağımsız olarak `~/ai-olaf-team/` altında yaşar.
2. **Projeye Özel Dinamik Hafıza (`.olaf/learned-skills/`):** Takım bir projeye girdiğinde, o projenin kaynak kodlarını okur. Örneğin `@backend` ajanı projede Entity Framework Core kullanıldığını, servislerin `ServiceResult<T>` döndürdüğünü ve Dapper'ın yasak olduğunu anlar ve bunu bizzat kendi `backend-skills.md` dosyasına yazar.
3. **Temiz Context ve Görev Devir Protokolü (`.olaf/contexts/` & `.olaf/outputs/`):** Ajanlar geçmiş sohbet kirliliğini belleğe yüklemez. Her görev için `@pm` izole bir Context Brief üretir; ajan yalnızca izin verilen dosya kapsamı (`File Scope`) içinde çalışır ve çıktısını standart manifesto dosyasına yazar. Bağımlı görevler yalnızca bu manifestoyu referans alır.

---

## 👥 2. 16 KİŞİLİK UZMAN KADRO

| No | Etiket | Rol | Uzmanlık ve Sorumluluk Alanı |
| :---: | :--- | :--- | :--- |
| **01** | `@pm` | Proje Yöneticisi & Orkestra Şefi | İşi atomik görevlere böler, sprint tahtasını yönetir, ajanları koordine eder. |
| **02** | `@architect` | Baş Yazılım Mimarı | Clean Architecture, Vertical Slice, DDD, CQRS, katman sınırları ve desenler. |
| **03** | `@ba` | İş Analisti & Product Owner | İş kuralları, kullanıcı hikayeleri, kabul kriterleri (Gherkin) ve uç durumlar. |
| **04** | `@backend` | Kıdemli Backend Uzmanı | .NET 8+, ASP.NET Core Web API, EF Core, Java Spring Boot, SOLID, async/await. |
| **05** | `@db` | Veritabanı ve ORM Uzmanı | PostgreSQL, MSSQL, Migration yönetimi, Fluent API, indeksleme ve N+1 çözümleri. |
| **06** | `@realtime` | Gerçek Zamanlı Sistemler Uzmanı | SignalR Hub mimarisi, RabbitMQ (MassTransit), Worker servisleri, Redis Pub/Sub. |
| **07** | `@frontend` | Kıdemli Web Frontend Uzmanı | React, Angular, TypeScript, Tailwind CSS, Zustand, Redux, API interceptor. |
| **08** | `@mobile` | Cross-Platform Mobil Uzmanı | React Native, Expo, Expo Router, offline-first, yerel donanım ve derleme. |
| **09** | `@uiux` | UI/UX Tasarım ve Ergonomi | Minimalist tasarım, HSL renk paletleri, dark mode, skeleton screens, WCAG. |
| **10** | `@security` | Siber Güvenlik & AppSec Uzmanı | OWASP Top 10, JWT, RBAC, SQLi, XSS, CORS, rate limiting ve gizli anahtar denetimi. |
| **11** | `@devops` | DevOps, Linux ve CI/CD | Linux, multi-stage Dockerfile, Docker Compose, GitHub Actions, Nginx. |
| **12** | `@qa` | Kalite Güvence ve Test Uzmanı | Birim (xUnit, Jest), entegrasyon (WebApplicationFactory), mocklama ve edge-case. |
| **13** | `@refactor` | Clean Code ve Performans | Kod kokuları, DRY/KISS/YAGNI, bellek sızıntıları, Guard Clauses, CPU optimizasyonu. |
| **14** | `@docs` | Teknik Yazar & Dokümantasyon | README, Swagger/OpenAPI, Mermaid.js akış diyagramları, ADR kayıtları, Changelog. |
| **15** | `@legal` | Bilişim Hukuku ve Lisans | KVKK/GDPR kişisel veri gizliliği, veri anonimleştirme, NuGet/NPM lisans denetimi. |
| **16** | `@reporter` | Kıdemli Teknik Raporlama Uzmanı | ISO/IEC 25010, IEEE 829, DORA ve OWASP uyumlu operasyonel & yönetsel denetim raporları. |

---

## 💻 3. İLK KURULUM VE GITHUB SENKRONİZASYONU (MASAÜSTÜ & LAPTOP)

Takımınızı bir kere kurduktan sonra hem masaüstü hem laptop bilgisayarınızda aynı güncel versiyonu kullanabilirsiniz.

### 1. Adım: Ana Bilgisayarınızda (Örn: Masaüstü) Repoyu Hazırlayın ve GitHub'a Yükleyin
```bash
# Merkezi repo dizinine geçin
cd ~/ai-olaf-team

# Git reposunu başlatın
git init
git add .
git commit -m "feat: AI Olaf Team 15 kişilik otonom takım ilk kurulumu"

# GitHub üzerinde özel (private) bir repo oluşturun ve bağlayın
git branch -M main
git remote add origin git@github.com:KULLANICI_ADINIZ/ai-olaf-team.git
git push -u origin main
```

### 2. Adım: Global Komut Kurulumunu Yapın (`olaf-init`)

Sisteminizin türüne göre ilgili kurulum betiğini bir defa çalıştırın:

#### 🐧 Linux & 🍎 macOS (Bash / Zsh):
Bu komut `~/.local/bin`, `~/.bashrc`, `~/.zshrc` ve macOS `~/.zprofile` dosyalarınıza `olaf-init` komutunu ve PATH ayarlarını ekler:
```bash
bash ~/ai-olaf-team/scripts/install-global-alias.sh

# Terminalinizi yenileyin
source ~/.bashrc   # veya zsh kullanıyorsanız: source ~/.zshrc
```

#### 🪟 Windows (PowerShell, CMD veya Git Bash):
Windows kullanıcıları için **tek tıkla kurulum** veya terminal komutları hazırlanmıştır:

**1. Yöntem (En Kolay - Tek Tık):**
Repo klasöründeki `install-windows.bat` dosyasına çift tıklayın! Betik çalıştırma izinlerini (ExecutionPolicy) otomatik yapılandırır, PATH ve çalıştırıcıları hazırlar.

**2. Yöntem (PowerShell):**
```powershell
cd ai-olaf-team
powershell -ExecutionPolicy Bypass -File scripts\install-global-alias.ps1
```

**3. Yöntem (CMD):**
```cmd
cd ai-olaf-team
install-windows.bat
```

> **💡 Not:** Kurulum tamamlandıktan sonra terminalinizi (PowerShell, CMD, Git Bash veya VS Code) bir kez kapatıp yeniden açın. Artık herhangi bir proje klasöründe doğrudan `olaf-init` yazabilirsiniz!
*(CMD ve Batch için `olaf-init.cmd` / `.bat`, Git Bash için `olaf-init` kabuk betiği otomatik olarak PATH'e eklenmiştir.)*

### 3. Adım: İkinci Bilgisayarınızda (Örn: Laptop) Repoyu Klonlayın
```bash
# Linux / macOS:
cd ~
git clone git@github.com:KULLANICI_ADINIZ/ai-olaf-team.git
cd ~/ai-olaf-team && bash scripts/install-global-alias.sh

# Windows (PowerShell / CMD):
cd $HOME
git clone git@github.com:KULLANICI_ADINIZ/ai-olaf-team.git
cd ai-olaf-team && .\install-windows.bat
```

> **🔄 Senkronizasyon İpucu:** Masaüstünde bir ajanın genel DNA'sını (`base-agents/`) güncellediğinizde `git push` yapın, laptopunuza geçtiğinizde `git pull` yaparak ekibinizi her an güncel tutun!

---

## ⚡ 4. SENARYO 1: MEVCUT BİR PROJEYE ENTEGRASYON (BROWNFIELD)

Halihazırda yazılmış kodları olan bir projeye (C#, TypeScript, Java, Python vb.) ekibi dahil etme adımları:

```text
[Mevcut Proje Klasörü] -> olaf-init -> [.olaf Kurulur + Röntgen Çekilir]
           -> IDE'yi Aç -> /olaf-train -> [15 Ajan Eğitilir & Hazır!]
```

### 1. Adım: Proje Klasöründe `olaf-init` Çalıştırın
```bash
cd ~/Projelerim/eticaret-backend
olaf-init
```
**Neler Olur?**
- Betik kaynak kodları otomatik tespit eder ve projeyi **BROWNFIELD** olarak işaretler.
- `package.json`, `*.csproj`, `pom.xml`, `Dockerfile` gibi dosyaları tarar ve ilk röntgeni `.olaf/memory/project-brain.md` dosyasına yazar.
- Eğitimin zorunlu olduğunu belirten `.olaf/memory/TRAINING_REQUIRED.flag` bayrağını diker.
- IDE kural köprülerini (`GEMINI.md`, `AGENTS.md`, `.cursorrules`, `.agent/workflows/`) otomatik kurar.

### 2. Adım: IDE'de /olaf-train Komutunu Çalıştırın
Antigravity IDE veya VS Code sohbet kutusunu açın ve şunu yazın:
```text
/olaf-train
```
**Ajanlar Ne Yapar?**
- Gerçek kod dosyalarını (`Program.cs`, `DbContext`, `Controllers`, `Services`, `App.tsx` vb.) baştan aşağı okurlar.
- 15 ajanın her biri kendi `.olaf/learned-skills/<agent>-skills.md` dosyasını açar ve projenin kurallarını ajanın kendi ağzından yazar.
- Eğitim tamamlandığında `TRAINING_REQUIRED.flag` otomatik silinir ve takım göreve hazır hale gelir!

---

## 🌱 5. SENARYO 2: SIFIRDAN YENİ PROJE BAŞLATMA (GREENFIELD)

Tamamen boş bir dizinde sıfırdan kurumsal mimarili bir proje başlatma adımları:

### 1. Adım: Boş Klasör Oluşturup `olaf-init` Çalıştırın
```bash
mkdir ~/Projelerim/yeni-finans-uygulamasi
cd ~/Projelerim/yeni-finans-uygulamasi
olaf-init
```
**Neler Olur?**
- Betik kod olmadığını anlar ve projeyi **GREENFIELD** olarak işaretler.
- 15 ajanın temel şablonları hazırlanır, bayrak dosyası konmaz.

### 2. Adım: IDE'de @pm ile Projeyi Tarif Edin
Antigravity veya VS Code sohbetinde şunu yazın:
```text
/pm .NET 8 Web API ve React TypeScript kullanarak çok kiracılı (multi-tenant) bir fatura takip sistemi kurmak istiyorum. Mimariyi Clean Architecture olarak planla.
```
**Orkestrasyon ve Paralel İcra Nasıl İşler?**
1. `@pm` görevi alır ve `.olaf/memory/active-sprint.md` tahtasına iş paketlerini yazar.
2. `@ba` iş kurallarını, `@architect` ise ortak veri modelleri ve API/DTO sözleşmesini netleştirir.
3. **⚡ Paralel Kulvarlar (Birbirini Bloklamayan İşler Eş Zamanlı Yürütülür):**
   - **Kulvar A (Backend & DB):** `@db` migration ve entity'leri hazırlar, `@backend` servis ve endpoint kodlarını yazar.
   - **Kulvar B (Mobil & Frontend):** `@mobile` ve `@frontend` UI bileşenlerini, state yönetimini ve istemci katmanını backend'i beklemeden eş zamanlı inşa eder.
4. **Konsolidasyon:** Ortak uçlar bağlandıktan sonra `@security` güvenlik taramasını, `@qa` testlerini, `@refactor` temizliğini yapar ve `@pm` sprinti kapatır.
5. Kod yazıldıkça her ajan kendi `learned-skills` dosyasını adım adım doldurur.

---

## 🛠️ 6. GÜNLÜK İŞ AKIŞLARI VE /SLASH KOMUTLARI

Antigravity IDE ve VS Code içinde doğrudan kullanabileceğiniz hazır slash komutları:

| Komut | Açıklama | Hangi Ajanlar Devreye Girer? |
| :--- | :--- | :--- |
| **`/olaf-train`** | Projeyi derinlemesine tarar, mimari beyni (`project-brain.md`) doldurur ve 15 ajanı eğitir. | Tüm Takım (15 Ajan) |
| **`/pm [görev]`** | Verilen görevi analiz eder, parçalara böler ve doğru sırayla uzman ajanları çalıştırır. | `@pm` (ve atanan alt ajanlar) |
| **`/sync-skills`** | Git diff ve dosya değişikliklerini tarayarak ajanların hafıza dosyalarını günceller. | Değişiklikten etkilenen tüm ajanlar |
| **`/review-all`** | Projeyi Mimari, Güvenlik, Performans, Test ve Hukuk açısından denetler, birleşik rapor sunar. | `@architect`, `@security`, `@refactor`, `@qa`, `@legal` |
| **`/orchestrate-parallel`** | Bağımsız işleri izole Git Worktree alanlarında paralel çalıştırır, `@devops` ile test kapısından geçirip Squash Merge eder. | `@pm`, `@devops`, `@architect` ve atanan paralel ajanlar |
| **`/context-handover`** | Her ajan çağrısını temiz context brief'i, dosya kapsamı kısıtı ve çıktı manifestosu ile yönetir; bağlam kirliliğini sıfırlar. | `@pm` ve atanan tüm uzman ajanlar |

---

## 🏷️ 7. DOĞRUDAN AJAN ÇAĞIRMA ÖRNEKLERİ (@ETİKET)

İhtiyacınıza göre belirli bir uzmana doğrudan seslenebilirsiniz:

- **Backend Uzmanına:**
  ```text
  @backend Kullanıcı şifre sıfırlama işlemi için bir endpoint ve servis yaz. Projedeki Result pattern'a ve EF Core kurallarına tam uy.
  ```
- **Veritabanı Uzmanına:**
  ```text
  @db Orders tablosuna TenantId ve Status indeksleri ekleyen yeni bir EF Core migration hazırla.
  ```
- **Gerçek Zamanlı Uzmanına:**
  ```text
  @realtime Canlı borsa fiyat akışını frontend'e basacak bir SignalR Hub ve RabbitMQ consumer kurgula.
  ```
- **Mobil Uzmanına:**
  ```text
  @mobile Expo Router kullanan projemize çevrimdışı çalışabilen bir SQLite yerel önbellek katmanı yaz.
  ```
- **Siber Güvenlik Uzmanına:**
  ```text
  @security AuthController üzerindeki refresh token ve cookie akışını OWASP standartlarına göre denetle.
  ```
- **DevOps Uzmanına:**
  ```text
  @devops Bu proje için multi-stage Dockerfile ve GitHub Actions otomatik test/derleme pipeline'ı hazırla.
  ```

---

## 🛡️ 8. GİT VE COMMIT İZOLASYONU: SIFIR KİRLİLİK (GHOST MODU)

AI Olaf Team, projelerinize yardımcı olmak için bağlanan **"Hayalet Bir Mühendislik Ekibi"** gibi çalışır.

> **⚠️ ALTIN KURAL:** AI Olaf Team altyapı ve hafıza dosyaları (`.olaf/`, `AGENTS.md`, `GEMINI.md`, `.cursorrules`, `.clinerules`, `.agent/`, `.agents/`) **çalıştığınız projenin Git geçmişine ASLA dahil edilmez ve commit edilmez!**  
> Repoya yalnızca projenizin gerçek kaynak kodları, testleri ve dokümantasyonları commit edilir.

### 🔒 3 Kademeli Otomatik Koruma Kalkanı:
1. **Kademe 1 - Git Global Ignore (`~/.gitignore_global`):**
   `install-windows.bat` veya `install-global-alias.sh` çalıştırıldığında sistem genelindeki `core.excludesfile` otomatik yapılandırılır. Bilgisayarınızdaki mevcut veya yeni klonlanan tüm Git repolarında Olaf dosyaları otomatik olarak Git için görünmez hale gelir.
2. **Kademe 2 - Yerel Gizleme (`.git/info/exclude` & `.gitignore`):**
   Bir projede `olaf-init` çalıştırıldığında, projenin `.git/info/exclude` ve kök `.gitignore` dosyalarına izolasyon kuralları eklenir. `git status` çıktısında Olaf dosyaları untracked olarak bile listelenmez.
3. **Kademe 3 - Pre-Commit Guard (Son Savunma Hattı):**
   Geliştirici veya bir IDE eklentisi kazara `git add .` veya zorla stage işlemi yapsa dahi, `.git/hooks/pre-commit` kancası commit anında devreye girer. Olaf dosyalarını otomatik olarak `un-stage` yapar ve sadece projenin kaynak kodlarının commit edilmesini sağlar.
   > **Mevcut Hook'ları Koruma Güvencesi:** Projenizde zaten var olan `eslint`, `prettier` veya birim test kancaları asla silinmez. Olaf Guard kancanın sonuna eklenir. Eğer projenin kendi lint/test kontrolleri hata verirse, commit **durdurulur**. Hata düzeltildiğinde ise commit devam eder ve Olaf dosyaları commit dışı bırakılır.

#### 🧪 Canlı Pre-Commit & Ghost Modu Testi:
Mevcut hook'ların korunduğunu ve lint hatası anında commit'in durduğunu kendiniz test etmek için:
```powershell
# Windows PowerShell:
.\scripts\demo-hook-test.ps1

# Linux & macOS (Bash):
./scripts/demo-hook-test.sh
```

### 🔄 Bilgisayarlar Arası Senkronizasyon:
- Ekibin temel beyni, 15 ajanın mesleki DNA'sı ve iş akışları `~/ai-olaf-team/` merkezi repo dizininizde yaşar.
- Masaüstünüzde veya laptopunuzda `~/ai-olaf-team/` dizinindeyken `git push` ve `git pull` yaparak ekibinizi her zaman güncel tutabilirsiniz.
- Yeni bir bilgisayarda projenizi klonladığınızda, sadece proje klasöründe `olaf-init` yazmanız ekibin projeye anında adapte olması için yeterlidir.

---

## 📁 9. MERKEZİ REPO DİZİN MİMARİSİ

```text
~/ai-olaf-team/
├── base-agents/                    # 15 Uzman Ajanın Temel DNA / Karakter Dosyaları
│   ├── 01-pm-agent.md              # Proje Yöneticisi & Takım Orkestra Şefi (@pm)
│   ├── 02-architect-agent.md       # Baş Yazılım Mimarı (@architect)
│   ├── 03-ba-agent.md              # İş Analisti & Product Owner (@ba)
│   ├── 04-backend-agent.md         # Kıdemli Backend Uzmanı (@backend)
│   ├── 05-db-agent.md              # Veritabanı, Veri Mimarisi ve ORM Uzmanı (@db)
│   ├── 06-realtime-agent.md        # Gerçek Zamanlı Sistemler ve Worker Uzmanı (@realtime)
│   ├── 07-frontend-agent.md        # Kıdemli Web Frontend Uzmanı (@frontend)
│   ├── 08-mobile-agent.md          # Cross-Platform Mobil Uygulama Uzmanı (@mobile)
│   ├── 09-uiux-agent.md            # UI/UX Tasarım ve Ergonomi Uzmanı (@uiux)
│   ├── 10-security-agent.md        # Siber Güvenlik ve AppSec Uzmanı (@security)
│   ├── 11-devops-agent.md          # DevOps, Linux, Docker ve CI/CD Uzmanı (@devops)
│   ├── 12-qa-agent.md              # Kalite Güvence ve Test Otomasyon Uzmanı (@qa)
│   ├── 13-refactor-agent.md        # Clean Code ve Performans Uzmanı (@refactor)
│   ├── 14-docs-agent.md            # Teknik Yazar ve API Docs Uzmanı (@docs)
│   ├── 15-legal-agent.md           # Bilişim Hukuku ve Lisans Denetçisi (@legal)
│   └── 16-reporter-agent.md        # Kıdemli Teknik Raporlama Uzmanı (@reporter)
├── workflows/                      # Antigravity & VS Code Slash (/komut) İş Akışları
│   ├── olaf-train.md               # /olaf-train : Projeyi baştan aşağı tarar ve eğitir
│   ├── pm.md                       # /pm : PM ajanını başlatır ve koordine eder
│   ├── sync-skills.md              # /sync-skills : Son kod değişikliklerini hafızaya işler
│   ├── review-all.md               # /review-all : Çoklu ajan denetim raporu sunar
│   ├── orchestrate-parallel.md     # /orchestrate-parallel : 16 ajanlı paralel Git Worktree orkestrasyonu
│   ├── context-handover.md         # /context-handover : Temiz context bütçesi ve görev devri
│   ├── arch-review.md              # /arch-review : Proaktif mimari analiz ve öneri bülteni
│   └── report.md                   # /report : Sektör standartlarında teknik/yönetsel denetim raporu
├── templates/                      # Projeye kopyalanacak boş hafıza ve yetenek şablonları
│   ├── learned-skill-template.md   # Her ajanın projeye özel dolduracağı skill şablonu
│   ├── project-brain-template.md   # Projenin mimari beyni ve teknoloji haritası şablonu
│   ├── active-sprint-template.md   # Aktif görev ve 7 paralel kulvar takip tahtası şablonu
│   ├── task-context-brief-template.md # Görev öncesi izole context brief şablonu
│   ├── task-output-template.md     # Görev tamamlama ve çıktı manifestosu şablonu
│   ├── arch-review-report-template.md # Mimari analiz ve risk envanteri şablonu
│   ├── architecture-advisory-template.md # Proaktif mimari öneri bülteni şablonu
│   └── sector-report-template.md   # Sektör standardı teknik denetim raporu şablonu
├── install-windows.bat             # Windows: Tek tıkla otomatik kurulum sihirbazı başlatıcısı
├── scripts/
│   ├── olaf-init.sh                # Linux & macOS: Projeye takımı bağlayan entegrasyon betiği (Bash)
│   ├── install-global-alias.sh     # Linux & macOS: Sisteme 'olaf-init' global komutunu ekleyen sihirbaz
│   ├── olaf-init.ps1               # Windows: PowerShell ile projeye takımı bağlayan entegrasyon motoru
│   ├── olaf-init.cmd               # Windows: CMD / Terminal başlatıcısı (Bypass korumalı)
│   ├── install-global-alias.ps1    # Windows: PowerShell Profiline ve PATH'e 'olaf-init' ekleyen sihirbaz
│   ├── install-windows.bat         # Windows: scripts içi yedek tek tık başlatıcı
│   ├── olaf-worktree.ps1           # Windows: İzole Git Worktree, Squash Merge & Release Kapısı motoru
│   ├── olaf-worktree.sh            # Linux & macOS: İzole Git Worktree motoru (Bash)
│   ├── demo-hook-test.ps1          # Windows: Pre-commit lint koruma ve Ghost modu canlı doğrulama testi
│   ├── demo-hook-test.sh           # Linux & macOS: Pre-commit lint koruma canlı doğrulama testi
│   ├── olaf-query-memory.ps1       # Windows: Seçici hafıza sorgulama CLI motoru
│   ├── olaf-query-memory.sh        # Linux & macOS: Seçici hafıza sorgulama CLI motoru
│   ├── olaf-memory-test.ps1        # Windows: Seçici hafıza 5/5 doğrulama test paketi
│   └── olaf-memory-test.sh         # Linux & macOS: Seçici hafıza 5/5 doğrulama test paketi
├── .gitignore                      # Git yoksayma kuralları
└── README.md                       # Çok detaylı Türkçe Kullanım ve Senkronizasyon Kılavuzu
```

---

## ⚡ 10. ÇOK KULVARLI PARALEL İCRA VE DEVOPS RELEASE KAPISI (`/orchestrate-parallel`)

AI Olaf Team, 16 ajanın tamamını bağımsızlık durumuna göre paralel kulvarlarda çalıştırmak üzere **Git Worktree Tabanlı Çok Kulvarlı Orkestrasyon** mimarisini benimser.

```text
                     [@pm Sprint Planlama & Görev Dağıtımı]
                                        │
    ┌──────────────────────┬────────────┴────────────┬──────────────────────┐
    ▼                      ▼                         ▼                      ▼
[Kulvar A: Backend]   [Kulvar B: Mobil]        [Kulvar C: DevOps]     [Kulvar D: QA/Docs]
(.olaf/worktrees/     (.olaf/worktrees/        (.olaf/worktrees/      (.olaf/worktrees/
 task-01)              task-02)                 task-03)               task-04)
    │                      │                         │                      │
    └──────────────────────┴────────────┬────────────┴──────────────────────┘
                                        ▼
                   [@devops Release Gatekeeper & Merge Queue]
                                        │
                         1. Sıralı Squash Merge
                         2. Otomatik Semantik Çakışma Çözümü (Lvl 1 & 2)
                         3. Kalite Kapısı (Build & Test)
                         4. Temiz 'main' Entegrasyonu & Worktree Temizliği
```

### 🔑 Temel Prensipler:
1. **İzole Çalışma Alanı (Git Worktrees):** Her bağımsız görev (`TASK-XX`), `.olaf/worktrees/task-xx/` dizininde kendi fiziksel çalışma alanına ve `task/task-xx` branch'ine sahiptir. Ajanlar birbirinin kodunu ezemez.
2. **Tek Yetkili Git Gatekeeper (`@devops`):** Bireysel geliştirici ajanlar (`@backend`, `@mobile`, `@frontend`) asla doğrudan `main` dalına merge yapamaz. `main` dalına resmi entegrasyon yetkisi **yalnızca `@devops`** ajanındadır.
3. **Squash Merge ile Temiz Tarihçe:** Görev içindeki çok sayıda ara commit `main` dalına tekil, anlamlı bir commit (`feat(task-xx): ...`) olarak yansıtılır.
4. **Kalite Kapısı (Quality Gate):** Merge öncesinde `dotnet build` veya `npm test` otomatik koşturulur. Hata varsa merge reddedilir ve `main` korunur.
5. **Otomatik Çakışma Çözümü (Conflict Resolution):** `package.json`, `.csproj` gibi paket dosyalarında çakışma çıkarsa sistem her iki tarafın paketlerini birleştirerek otomatik çözer.

### 🛠️ Worktree Motoru Komutları:
```powershell
# Windows PowerShell:
.olaf\scripts\olaf-worktree.ps1 -Action start -TaskId "TASK-01" -Agent "@backend"
.olaf\scripts\olaf-worktree.ps1 -Action list
.olaf\scripts\olaf-worktree.ps1 -Action status -TaskId "TASK-01"
.olaf\scripts\olaf-worktree.ps1 -Action merge -TaskId "TASK-01" -Agent "@backend"
.olaf\scripts\olaf-worktree.ps1 -Action cleanup -TaskId "TASK-01"

# Linux & macOS (Bash):
./.olaf/scripts/olaf-worktree.sh start TASK-01 "@backend"
./.olaf/scripts/olaf-worktree.sh list
./.olaf/scripts/olaf-worktree.sh merge TASK-01 "@backend"
./.olaf/scripts/olaf-worktree.sh cleanup TASK-01
```

---

## 🧼 11. TEMİZ CONTEXT BÜTÇESİ VE GÖREV DEVİR PROTOKOLÜ (`/context-handover`)

Herhangi bir ajana iş verilirken önceki konuşmaların tüm sohbet geçmişini belleğe taşımak token maliyetini katlar, ajanın dikkatini dağıtır ve kod kalitesini düşürür. AI Olaf Team, **Temiz Context ve Çift Manifestolu Devir Standardı** uygular.

```text
[@pm] ──(1. Brief Yaz)──► [.olaf/contexts/TASK-01-brief.md]
                                   │
                         (2. Temiz Çağrı)
                                   ▼
                            [@backend İcra]
                      (Yalnızca File Scope'a dokunur)
                                   │
                         (3. Output Manifestosu)
                                   ▼
                       [.olaf/outputs/TASK-01-output.md]
                                   │
      ┌────────────────────────────┴───────────────────────────┐
      ▼                                                        ▼
[@pm Sprint Denetimi]                     [@mobile / TASK-02 Brief'ine Linklenir]
(Gereksiz sohbet geçmişi sıfırlanır)       (Yalnızca kontrat ve DTO'ları okur)
```

### ⚖️ Context Budget: Ne Girer, Ne Girmez?
| ✅ Context'e GİREN Veriler | ❌ Context'e ASLA GİRMEYENLER |
| :--- | :--- |
| **Görev Kimliği & Hedefi:** `TASK-XX` ve kabul kriterleri (DoD) | **Geçmiş Sohbet:** Önceki sprint veya görev sohbet geçmişi |
| **Dosya Kapsamı (File Scope):** Sadece okunacak/yazılacak dosyalar | **İlgisiz Dosyalar:** Görevle doğrudan bağı olmayan dosyalar |
| **Öncel Çıktı:** Bağımlı görevin `.olaf/outputs/TASK-YY-output.md` dosyası | **Diğer Kulvarlar:** Paralel yürüyen bağımsız kulvarların iç detayları |
| **Ajan DNA:** `base-agents/<agent>.md` + `learned-skills/<agent>-skills.md` | **Tüm Kod Tabanı Taraması:** Gereksiz global aramalar |
| **Snapshot Hash:** Görevin başladığı andaki Git commit hash'i | **Kullanıcı Ara Sohbetleri:** Görev dışı genel diyaloglar |

### 📐 Reproducibility (Tekrarlanabilirlik) Garantisi:
Her Context Brief başlangıç Git Snapshot Hash'ini içerir. Aynı girdi, aynı hash ve aynı brief ile icra edilen her görev deterministik olarak aynı sonucu üretir:
$$\text{Deterministik Sonuç} = f(\text{Context Brief}, \text{Snapshot Hash}, \text{Predecessor Outputs})$$

---

## 🧠 12. SEÇİCİ HAFIZA VE İSTEĞE BAĞLI GETİRME (SELECTIVE MEMORY RETRIEVAL — ADR-11 İLA ADR-14)

Her agent çağrısında tüm hafıza dosyalarını (`project-brain.md`, `active-sprint.md`, `<agent>-skills.md`) baştan sona yüklemek yerine, **yalnızca görevle ilgili bölümler on-demand getirilir**. Bu sayede context token tüketimi **%70 - %88** oranında azaltılır, bayat veri riski önlenir ve context kirliliği sıfırlanır.

### 📊 Token Tüketimi Karşılaştırması:
| Senaryo | Eski Davranış (Tam Yükleme) | Yeni Davranış (Seçici Getirme) | Tasarruf |
| :--- | :--- | :--- | :--- |
| **Dar Görev (Tek Task)** | ~5.000 token | ~600 token | **~88%** |
| **Orta Görev (Mimari Karar)** | ~6.000 token | ~1.200 token | **~80%** |
| **Geniş Görev (Sprint İnceleme)** | ~8.000 token | ~2.500 token | **~69%** |

### 🛠️ Seçici Hafıza Motoru Komutları (`scripts/olaf-query-memory`):
```powershell
# Windows PowerShell:
# 1. Yalnızca teknoloji yığınını çek:
.\scripts\olaf-query-memory.ps1 -File brain -Section tech-stack

# 2. Sprint tahtasından tek bir görevi çek:
.\scripts\olaf-query-memory.ps1 -File sprint -Task TASK-07

# 3. Belirli bir ajanın kodlama standartlarını çek:
.\scripts\olaf-query-memory.ps1 -File skills -Agent backend -Section conventions

# 4. Güncellik uyarısı (7 günden eski kararları uyar):
.\scripts\olaf-query-memory.ps1 -File brain -Section tech-stack -MaxAgeDays 7

# 5. Geriye dönük uyumluluk (tam dosya yükleme):
.\scripts\olaf-query-memory.ps1 -File brain -Full

# Linux & macOS (Bash):
./scripts/olaf-query-memory.sh -f brain -s tech-stack
./scripts/olaf-query-memory.sh -f sprint -t TASK-07
./scripts/olaf-query-memory.sh -f skills -a backend -s conventions
./scripts/olaf-query-memory.sh -f brain -s tech-stack --max-age 7
./scripts/olaf-query-memory.sh -f brain --full
```

### 🧪 Doğrulama ve Güvenlik Test Paketi (`scripts/olaf-memory-test`):
```powershell
# Windows PowerShell:
.\scripts\olaf-memory-test.ps1

# Linux & macOS (Bash):
./scripts/olaf-memory-test.sh
```
- **Test A:** Token & satır tasarrufu (seçici çıktı $\le \%30$)
- **Test B:** Bölüm izolasyonu (`tech-stack` çekildiğinde `architecture` sızmaz)
- **Test C:** Güncellik uyarısı (`--max-age` eski kayıtlarda `⚠️ UYARI` verir)
- **Test D:** Sınır dışı güvenlik (Path Traversal `../../etc/passwd` derhal engellenir)
- **Test E:** Geriye dönük uyumluluk (`--full` tam dosya bütünlüğünü korur)

---

## 🏛️ 13. PROAKTİF MİMARİ İNCELEME (`/arch-review`)

`@architect` ajanı projenizi pasif bekleme yerine **aktif olarak izler** — hata, yavaşlık ve daha uygun mimari alternatifleri tespit edip size sunar. Ancak **sormadan asla değişiklik yapmaz.**

### 🔎 Nasıl Tetiklenir?

| Yöntem | Açıklama |
| :--- | :--- |
| `/arch-review` | Kullanıcı doğrudan tetikler |
| `/olaf-train` sonrası | Eğitim tamamlanınca otomatik özet analiz |
| Büyük sprint başlangıcı | `@pm`, ≥3 görevli sprintlerde paralel analiz yaptırır |

### 📊 Bulgu Önceliklendirme Sistemi

| Seviye | Örnekler |
| :--- | :--- |
| 🔴 **Kritik** | N+1 sorgu, katman bağımlılık ihlali, hardcoded secret, async deadlock |
| 🟡 **Uyarı** | Eski kütüphane sürümü, test kapsamı %0, anemic domain model |
| 🟢 **Öneri** | Cache katmanı, CQRS fırsatı, pagination eksikliği, circuit breaker |

### 🔒 Sıfır İzinli Değişiklik Kapısı (Zero-Touch Consent Gate — Kesin Kural)

```
ANALIZ → ÖNERİ BÜLTENİ SUNULUR → KULLANICI SEÇİMİ
  ├─ [1] "Mevcut Yapıyı Koru" → project-brain'e kaydedilir, mevcut koda %100 sadık kalınır (aynı öneri tekrarlanmaz)
  ├─ [2] "Onayla ve Planla"   → @pm sprint'e TASK-XX ekler → Kontrollü refactoring başlar
  └─ [3] "Detay Açıkla"       → @architect teknik gerekçeleri izah eder, yine hiçbir şey değişmez
```

> **🛡️ KESİN GÜVENLİK GARANTİSİ:**  
> Kullanıcı açıkça **"Onayla"** veya **"[2]"** demedikçe, AI Olaf Team projenizin mimarisinde, paketlerinde veya kodlarında **kesinlikle hiçbir değişiklik yapamaz**. `@architect` teşhis koyar, dürüstçe önerir; karar daima kullanıcıya aittir.

### 📋 Örnek Öneri Bülteni Çıktısı

```
💡 [MİMARİ ÖNERİ] — OrderRepository N+1 Sorgu ve Bellek Tıkanması Riski
- 🔍 Mevcut Durum: Döngü içinde her sipariş için veritabanına tekil sorgu atılıyor.
- ⚠️ Tespit Edilen Risk: 1.000 siparişte 1.001 SQL sorgusu oluşur, API kilitlenir.
- 🚀 Önerilen Alternatif: Eager loading (Include) veya Split Query deseni.
- ⏳ Tahmini Efor / Etki: Küçük (1 dosya, 4 satır değişiklik, API sözleşmesi bozulmaz).

👉 Ne Yapmak İstersiniz?
- [1] Mevcut Yapıyı Koru (Öneriyi Reddet)
- [2] Öneriyi Onayla ve Planla
- [3] Detay Açıkla
```

Raporlar `.olaf/reports/` altında saklanır — ghost modda, asla commit edilmez. Kullanıcının ret tercihleri `.olaf/memory/project-brain.md` içinde `user-architectural-preferences` altına işlenir.

---

## 📊 14. SEKTÖR STANDARTLARINDA RAPORLAMA MOTORU (`/report` & `@reporter`)

AI Olaf Team, 16. uzmanı olan **`@reporter`** (Kıdemli Teknik Raporlama ve Bağımsız Denetim Uzmanı) ile projede icra edilen her teknik çalışmayı uluslararası mühendislik ve kalite çerçevelerine (ISO/IEC 25010, IEEE 829, DORA, OWASP, RFC 7807, ACID) göre raporlar.

```text
Kullanıcı / @pm Tetikler: /report [hedef]
                        │
                        ▼
[@reporter Bağımsız Denetçi]
  ├─ 1. Kapsam ve Kanıtları Toplar (.olaf/outputs/TASK-XX-output.md, Git Diff, Seçici Hafıza)
  ├─ 2. İlgili Sektör Standardını Uygular (ISO 25010, OWASP Top 10, IEEE 829, DORA)
  ├─ 3. Metrik ve Kabul Kriterlerini Doğrular (Sözleşme Bütünlüğü, SLA, Test Kapsamı)
  └─ 4. İki Kademeli Standart Rapor Üretir (.olaf/reports/report-<hedef>-<tarih>.md)
        ├─ 👔 Yönetsel Özet (C-Level / PO: Karar, Risk, Hız)
        └─ 🔬 Teknik Derinlemesine İnceleme (Mühendisler: RFC, Kod İzi, Güvenlik)
```

### 🎯 Desteklenen Sektör Standartları Matrisi

| Standart / Çerçeve | Uygulanan Ajan / Alan | Raporlanan Temel Metrikler ve Kriterler |
| :--- | :--- | :--- |
| **ISO/IEC 25010** | `@architect`, Genel Kalite | Modülerlik, sürdürülebilirlik, hata toleransı, kaynak kullanımı, taşınabilirlik. |
| **IEEE 829** | `@qa` Test Mühendisliği | Test vaka tasarımı, pass/fail oranları, boundary value analizi, mock doğrulaması. |
| **DORA Metrikleri** | `@devops` CI/CD | Dağıtım sıklığı (Deployment Frequency), MTTR, Change Failure Rate, Lead Time. |
| **OWASP Top 10 & ASVS** | `@security` Siber Güvenlik | A01 Yetki aşımı, A02 Kriptografik zaafiyetler, A03 Injection, secret sızıntıları. |
| **RFC 7807 & REST** | `@backend` Web API | Problem Details hata yanıt formatı, HTTP durum kodları, idempotent metodlar. |
| **ACID / CAP Teoremi** | `@db` Veritabanı | Transaction izolasyon seviyeleri, rollback garantisi, Foreign Key ve Indexleme. |

### 🛠️ Kullanım ve Komut Örnekleri

```bash
# Antigravity veya VS Code terminalinde/chatinde:
/report backend      # Backend ajanının son görevlerini, REST & RFC 7807 uyumunu raporlar
/report db           # Veritabanı şema değişiklikleri, migration rollback ve ACID denetimi
/report security     # OWASP Top 10 açıkları, secret taraması ve CVSS risk skorları
/report qa           # IEEE 829 test koşum sonuçları, edge-case kapsamı ve regresyon riski
/report devops       # CI/CD süreleri, multi-stage Docker optimizasyonu ve DORA metrikleri
/report sprint       # Aktif sprint tamamlama oranı, kulvar hızları ve kapsam sapması
/report TASK-03      # Belirli bir atomik görevin baştan sona teslimat ve uyumluluk raporu
```

### 🔒 Ghost Modu ve Rapor Arşivi

Tüm raporlar `.olaf/reports/` klasöründe zaman damgalı olarak üretilir (`report-backend-20261024-173000.md`). Bu klasör `.gitignore` ile yerel geliştirme alanında tutulur ve Git geçmişine sızdırılmaz.

---

<p align="center">
  <b>AI Olaf Team</b> ile projelerinizde hız, kalite ve kurumsal mimari disiplini her an yanınızda! 🎯
</p>
