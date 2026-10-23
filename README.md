# 🚀 AI OLAF TEAM - Otonom, Projeden Bağımsız ve Kendi Kendini Eğiten (Self-Training) 15 Kişilik Yazılım Takımı

[![License: MIT](https://img.shields.io/badge/Lisans-MIT-blue.svg)](LICENSE)
[![Platform: Cross-Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue.svg)]()
[![IDE: Antigravity & VS Code](https://img.shields.io/badge/IDE-Antigravity%20%7C%20VS%20Code%20%7C%20Cursor-purple.svg)]()
[![Agents: 15 Experts](https://img.shields.io/badge/Ekip-15%20Uzman%20Ajan-brightgreen.svg)]()

> **"Tek bir terminal komutuyla (`olaf-init`) istediğiniz herhangi bir projeye bağlanan; mimarisini inceleyip kendi kurallarını kendisi yazan ve masaüstü/laptop bilgisayarlarınız arasında GitHub üzerinden kusursuz senkronize olan profesyonel AI yazılım takımı."**

---

## 📑 İÇİNDEKİLER
1. [🧠 Mimari Felsefe: Sabit DNA vs. Dinamik Hafıza](#-1-mimari-felsefe-sabit-dna-vs-dinamik-haf%C4%B1za)
2. [👥 15 Kişilik Uzman Kadro](#-2-15-ki%C5%9Filik-uzman-kadro)
3. [💻 İlk Kurulum ve GitHub Senkronizasyonu (Masaüstü & Laptop)](#-3-%C4%B0lk-kurulum-ve-github-senkronizasyonu-masa%C3%BCst%C3%BC--laptop)
4. [⚡ Senaryo 1: Mevcut Bir Projeye Entegrasyon (Brownfield)](#-4-senaryo-1-mevcut-bir-projeye-entegrasyon-brownfield)
5. [🌱 Senaryo 2: Sıfırdan Yeni Proje Başlatma (Greenfield)](#-5-senaryo-2-s%C4%B1f%C4%B1rdan-yeni-proje-ba%C5%9Flatma-greenfield)
6. [🛠️ Günlük İş Akışları ve /Slash Komutları](#-6-g%C3%BCnl%C3%BCk-%C4%B0%C5%9F-ak%C4%B1%C5%9Flar%C4%B1-ve-slash-komutlar%C4%B1)
7. [🏷️ Doğrudan Ajan Çağırma Örnekleri (@etiket)](#-7-do%C4%9Frudan-ajan-%C3%87a%C4%9F%C4%B1rma-%C3%96rnekleri-etiket)
8. [🛡️ Git ve Commit İzolasyonu: Sıfır Kirlilik (Ghost Modu)](#-8-git-ve-commit-izolasyonu-s%C4%B1f%C4%B1r-kirlilik-ghost-modu)
9. [📁 Merkezi Repo Dizin Mimarisi](#-9-merkezi-repo-dizin-mimarisi)

---

## 🧠 1. MİMARİ FELSEFE: SABİT DNA VS. DİNAMİK HAFIZA

Geleneksel AI prompt sistemlerinin en büyük sorunu şudur: Her projede aynı genel tavsiyeleri verirler ve projenizin kendine has mimarisini, kütüphanelerini veya özel kurallarını unuturlar.

**AI Olaf Team** bu problemi **İki Kademeli Hafıza Modeli** ile çözer:

```text
┌──────────────────────────────────────────────────────────────┐
│  ~/ai-olaf-team/base-agents/ (SABİT ÇEKİRDEK DNA)            │
│  - 15 Ajanın evrensel mesleki uzmanlığı, temiz kod ilkeleri  │
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

## 👥 2. 15 KİŞİLİK UZMAN KADRO

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
│   └── 15-legal-agent.md           # Bilişim Hukuku ve Lisans Denetçisi (@legal)
├── workflows/                      # Antigravity & VS Code Slash (/komut) İş Akışları
│   ├── olaf-train.md               # /olaf-train : Projeyi baştan aşağı tarar ve eğitir
│   ├── pm.md                       # /pm : PM ajanını başlatır ve koordine eder
│   ├── sync-skills.md              # /sync-skills : Son kod değişikliklerini hafızaya işler
│   └── review-all.md               # /review-all : Çoklu ajan denetim raporu sunar
├── templates/                      # Projeye kopyalanacak boş hafıza ve yetenek şablonları
│   ├── learned-skill-template.md   # Her ajanın projeye özel dolduracağı skill şablonu
│   ├── project-brain-template.md   # Projenin mimari beyni ve teknoloji haritası şablonu
│   └── active-sprint-template.md   # Aktif görev ve ajan takip tahtası şablonu
├── install-windows.bat             # Windows: Tek tıkla otomatik kurulum sihirbazı başlatıcısı
├── scripts/
│   ├── olaf-init.sh                # Linux & macOS: Projeye takımı bağlayan entegrasyon betiği (Bash)
│   ├── install-global-alias.sh     # Linux & macOS: Sisteme 'olaf-init' global komutunu ekleyen sihirbaz
│   ├── olaf-init.ps1               # Windows: PowerShell ile projeye takımı bağlayan entegrasyon motoru
│   ├── olaf-init.cmd               # Windows: CMD / Terminal başlatıcısı (Bypass korumalı)
│   ├── install-global-alias.ps1    # Windows: PowerShell Profiline ve PATH'e 'olaf-init' ekleyen sihirbaz
│   └── install-windows.bat         # Windows: scripts içi yedek tek tık başlatıcı
├── .gitignore                      # Git yoksayma kuralları
└── README.md                       # Çok detaylı Türkçe Kullanım ve Senkronizasyon Kılavuzu
```

---

<p align="center">
  <b>AI Olaf Team</b> ile projelerinizde hız, kalite ve kurumsal mimari disiplini her an yanınızda! 🎯
</p>
