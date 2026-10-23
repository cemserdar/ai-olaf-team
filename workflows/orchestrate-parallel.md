# ⚡ /orchestrate-parallel - Çok Kulvarlı Paralel İcra ve Release Orkestrasyonu

Bu iş akışı, `@pm` (Orkestra Şefi) ve `@devops` (Git Gatekeeper) iş birliğiyle, **birbirini bloklamayan işleri izole Git Worktree alanlarında paralel çalıştırmak** ve tamamlanan işleri güvenle `main` dalına entegre etmek için kullanılır.

---

## 🎯 İŞ AKIŞI HEDEFİ
- Bağımsız görevleri fiziksel olarak izole edilmiş `.olaf/worktrees/task-<ID>` dizinlerinde eş zamanlı yürütmek.
- Geliştirici ajanların (`@backend`, `@mobile`, `@frontend`...) `main` dalına doğrudan dokunmasını engellemek.
- Main dalına entegrasyonu SADECE `@devops` denetiminde **Squash Merge + Doğrulama Kapısı (Quality Gate)** ile gerçekleştirmek.
- Çakışmaları otomatik tespit etmek, Seviye 1 çakışmaları anında çözmek ve derleme/test hatasında güvenle geri almak (rollback).

---

## 📋 ADIM ADIM İCRA PROTOKOLÜ

### ADIM 1: GÖREVLERİN DAG OLARAK MODELLENMESİ (@pm & @architect)
1. Kullanıcı talebi atomik iş paketlerine bölünür.
2. `.olaf/memory/active-sprint.md` tahtasında görev bağımlılıkları belirlenir:
   - **Gelen Derecesi 0 (Bağımsız):** Hemen başlatılacak işler (Örn: `TASK-01` Backend API, `TASK-02` Mobil Ekran).
   - **Bağımlı İşler:** Öncülleri tamamlanana kadar bekleyecek işler (Örn: `TASK-03` Entegrasyon Testi).

### ADIM 2: PARALEL WORKTREE ALANLARININ AÇILMASI (@devops)
`@pm`, bağımsız görevlerin listesini `@devops`'a iletir. `@devops` her görev için izole worktree oluşturur:

```bash
# Windows (PowerShell):
powershell -ExecutionPolicy Bypass -File scripts/olaf-worktree.ps1 start TASK-01 @backend
powershell -ExecutionPolicy Bypass -File scripts/olaf-worktree.ps1 start TASK-02 @mobile

# Linux & macOS (Bash):
./scripts/olaf-worktree.sh start TASK-01 @backend
./scripts/olaf-worktree.sh start TASK-02 @mobile
```

### ADIM 3: İZOLE GELİŞTİRME (@backend, @mobile vb.)
1. Her ajan YALNIZCA kendisine tahsis edilen dizinde çalışır:
   - Backend Ajanı: `.olaf/worktrees/task-01/`
   - Mobil Ajanı: `.olaf/worktrees/task-02/`
2. Ajanlar kendi alanlarında kod yazar ve yerel commit'lerini atar.
3. İş bittiğinde ajan, görevi `@devops`'a teslim eder: *"TASK-01 hazır, merge edilebilir."*

### ADIM 4: MERGE QUEUE, ÇAKIŞMA YÖNETİMİ VE SQUASH MERGE (@devops)
`@devops` tamamlanan işi sıraya alır ve entegrasyon protokolünü işletir:

```bash
# Windows (PowerShell):
powershell -ExecutionPolicy Bypass -File scripts/olaf-worktree.ps1 merge TASK-01 @backend

# Linux & macOS (Bash):
./scripts/olaf-worktree.sh merge TASK-01 @backend
```

Bu komut arka planda sırasıyla:
1. Worktree içindeki son değişiklikleri kaydeder.
2. `main` dalına geçer ve `git merge --squash task/task-01` uygular.
3. **Çakışma Kontrolü:**
   - `package.json` ve `.csproj` gibi yapısal çakışmaları otomatik çözer.
   - Kod çakışması varsa `@architect`'i hakemliğe çağırır; çözülemezse `git reset --hard` ile geri alır.
4. **Doğrulama Kapısı (Quality Gate):**
   - Otomatik `dotnet build` / `npm test` koşturur.
   - Hata varsa derhal geri alır (`rollback`), `main` asla bozulmaz.
5. **Nihai Entegrasyon:**
   - Testler geçerse `main` dalına tekil ve temiz bir commit atar.
   - `.olaf/worktrees/task-01` dizinini ve `task/task-01` branch'ini otomatik temizler.

### ADIM 5: BAĞIMLI GÖREVLERİN KİLİDİNİN AÇILMASI (@pm)
1. `TASK-01` başarıyla merge edildiğinde, `.olaf/memory/active-sprint.md` güncellenir.
2. `TASK-01`'in bitmesini bekleyen bağımlı işlerin kilidi açılır ve Adım 2 tekrarlanarak yeni worktree başlatılır.
3. Tüm DAG tamamlandığında `@pm` kullanıcıya yönetici özetini sunar.

