#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# periksa-repo.sh — memeriksa kesiapan repositori tim antrean-kampus (TI3510 P3)
#
# Jalankan DARI DALAM folder repositori yang sudah diklona:
#     bash periksa-repo.sh
#
# Skrip ini hanya MEMBACA. Ia tidak mengubah apa pun di repositori kalian.
# ---------------------------------------------------------------------------
set -u

lulus=0; gagal=0
ok()   { printf '  [ OK  ] %s\n' "$1"; lulus=$((lulus+1)); }
no()   { printf '  [GAGAL] %s\n' "$1"; gagal=$((gagal+1)); }
judul(){ printf '\n%s\n' "$1"; }

printf '=== Pemeriksaan repositori tim — TI3510 Pertemuan 3 ===\n'

judul '1. Repositori Git'
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ok "folder ini adalah repositori Git"
else
  no "folder ini BUKAN repositori Git — jalankan dari dalam folder hasil git clone"
  exit 1
fi

cabang=$(git branch --show-current 2>/dev/null)
if [ "$cabang" = "main" ]; then ok "cabang aktif: main"
else no "cabang aktif '$cabang', seharusnya 'main'"; fi

if git remote get-url origin >/dev/null 2>&1; then
  url=$(git remote get-url origin)
  ok "remote origin: $url"
  case "$url" in
    git@github.com:*) ok "remote memakai SSH (benar untuk kelas ini)" ;;
    https://*)        no "remote memakai HTTPS — ganti ke SSH agar kunci kalian terpakai" ;;
  esac
else
  no "belum ada remote bernama origin"
fi

judul '2. Berkas wajib'
for f in README.md .gitignore .gitattributes; do
  if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then ok "$f terlacak Git"
  else no "$f belum ada atau belum ter-commit"; fi
done
for d in app docs; do
  if [ -d "$d" ]; then ok "folder $d/ ada"; else no "folder $d/ belum ada"; fi
done

judul '3. Identitas Git pengguna ini'
nama=$(git config user.name  || true)
surel=$(git config user.email || true)
if [ -n "$nama" ]; then ok "user.name  = $nama"; else no "user.name belum diatur"; fi
if [ -n "$surel" ]; then ok "user.email = $surel"; else no "user.email belum diatur"; fi

judul '4. Uji .gitignore (berkas rahasia harus diabaikan)'
for pola in .env id_ed25519 __pycache__/x.pyc app.log .DS_Store; do
  if git check-ignore -q "$pola"; then ok "$pola diabaikan"
  else no "$pola TIDAK diabaikan — periksa .gitignore"; fi
done
if git check-ignore -q .env.example; then
  no ".env.example ikut diabaikan — seharusnya dikecualikan dengan !"
else
  ok ".env.example tidak diabaikan (benar)"
fi

judul '5. Rahasia yang mungkin sudah terlanjur ter-commit'
tersangka=$(git ls-files | grep -Ei '(^|/)(\.env$|.*\.pem$|.*\.key$|id_rsa|id_ed25519|credentials\.json)' || true)
if [ -z "$tersangka" ]; then ok "tidak ada berkas rahasia yang terlacak"
else no "ADA berkas rahasia terlacak:"; printf '         %s\n' $tersangka
     printf '         Laporkan ke dosen. Menghapus berkasnya saja TIDAK cukup.\n'; fi

judul '6. Kontribusi tiap anggota'
jml=$(git log --oneline 2>/dev/null | wc -l | tr -d ' ')
printf '  jumlah commit: %s\n' "$jml"
printf '  penulis commit:\n'
git log --format='    %an <%ae>' 2>/dev/null | sort -u
penulis=$(git log --format='%ae' 2>/dev/null | sort -u | wc -l | tr -d ' ')
if [ "$penulis" -ge 2 ]; then ok "ada $penulis penulis berbeda"
else no "baru $penulis penulis — tiap anggota tim harus punya commit atas namanya sendiri"; fi

printf '\n=== Ringkasan: %s lulus, %s gagal ===\n' "$lulus" "$gagal"
if [ "$gagal" -eq 0 ]; then
  printf 'Repositori tim kalian siap. Lampirkan tangkapan layar keluaran ini ke checkpoint.\n'; exit 0
else
  printf 'Perbaiki butir bertanda GAGAL, lalu jalankan ulang skrip ini.\n'; exit 1
fi
