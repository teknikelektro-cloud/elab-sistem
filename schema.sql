-- =============================================
-- E-Laboratory - Supabase Database Schema
-- Universitas Teknologi Sumbawa
-- =============================================

-- 1. USERS
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  nama TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'mahasiswa',
  nim TEXT,
  nidn TEXT,
  email TEXT,
  hp TEXT,
  angkatan TEXT
);

-- 2. KURIKULUM (MK Praktikum)
CREATE TABLE IF NOT EXISTS kurikulum (
  id TEXT PRIMARY KEY,
  kode TEXT,
  nama TEXT,
  sks INTEGER DEFAULT 0,
  semester INTEGER DEFAULT 1
);

-- 3. JADWAL (Praktikum)
CREATE TABLE IF NOT EXISTS jadwal (
  id TEXT PRIMARY KEY,
  matkul TEXT NOT NULL,
  percobaan TEXT,
  tanggal TEXT,
  tanggal_selesai TEXT,
  mulai TEXT,
  selesai TEXT,
  ruangan TEXT,
  dosen TEXT,
  asisten JSONB DEFAULT '[]',
  kapasitas INTEGER DEFAULT 0,
  peserta JSONB DEFAULT '[]',
  ketua JSONB DEFAULT '[]',
  extra JSONB DEFAULT '{}',
  ditutup BOOLEAN DEFAULT FALSE,
  ditutup_at TEXT,
  tahun_akademik TEXT,
  semester TEXT
);

-- 4. INVENTARIS
CREATE TABLE IF NOT EXISTS inventaris (
  id TEXT PRIMARY KEY,
  nama TEXT NOT NULL,
  kode TEXT,
  kategori TEXT,
  tipe TEXT,
  pabrikan TEXT,
  tahun_pengadaan TEXT,
  jumlah INTEGER DEFAULT 0,
  kondisi TEXT DEFAULT 'Baik',
  ket TEXT
);

-- 5. PEMINJAMAN
CREATE TABLE IF NOT EXISTS peminjaman (
  id TEXT PRIMARY KEY,
  nama TEXT NOT NULL,
  nim TEXT,
  hp TEXT,
  email TEXT,
  alat JSONB DEFAULT '[]',
  tanggal TEXT,
  rencanakembali TEXT,
  aktual_kembali TEXT,
  ket TEXT,
  status TEXT DEFAULT 'menunggu',
  role TEXT DEFAULT 'mahasiswa',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. NILAI (composite key: jadwal_id + nim)
CREATE TABLE IF NOT EXISTS nilai (
  jadwal_id TEXT NOT NULL,
  nim TEXT NOT NULL,
  pre NUMERIC DEFAULT 0,
  prak NUMERIC DEFAULT 0,
  lap NUMERIC DEFAULT 0,
  total NUMERIC DEFAULT 0,
  lap_acc BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (jadwal_id, nim)
);

-- 7. ABSENSI (composite key: jadwal_id + nim)
CREATE TABLE IF NOT EXISTS absensi (
  jadwal_id TEXT NOT NULL,
  nim TEXT NOT NULL,
  status TEXT DEFAULT 'alfa',
  PRIMARY KEY (jadwal_id, nim)
);

-- 8. REGISTRASI
CREATE TABLE IF NOT EXISTS registrasi (
  id TEXT PRIMARY KEY,
  nama TEXT NOT NULL,
  nim TEXT,
  hp TEXT,
  email TEXT,
  angkatan TEXT,
  ket TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. NOTIFIKASI
CREATE TABLE IF NOT EXISTS notifikasi (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  message TEXT,
  icon TEXT DEFAULT '🔔',
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  link TEXT
);

-- 10. SETTINGS (key-value)
CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT
);

-- 11. SURAT BEBAS LAB
CREATE TABLE IF NOT EXISTS surat_bebas (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  nama TEXT,
  nim TEXT,
  angkatan TEXT,
  status TEXT DEFAULT 'menunggu',
  nomor_urut INTEGER,
  penandatangan JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  processed_at TEXT,
  processed_by TEXT
);

-- 12. SURAT TUGAS
CREATE TABLE IF NOT EXISTS surat_tugas (
  id TEXT PRIMARY KEY,
  jadwal_id TEXT,
  dosen_id TEXT,
  dosen_nama TEXT,
  dosen_nim TEXT,
  matkul TEXT,
  percobaan TEXT,
  tanggal TEXT,
  tanggal_selesai TEXT,
  tahun_akademik TEXT,
  semester TEXT,
  nomor_urut INTEGER,
  penandatangan JSONB,
  status TEXT DEFAULT 'terbit',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 13. SERTIFIKAT ASISTEN
CREATE TABLE IF NOT EXISTS sertifikat_asisten (
  id TEXT PRIMARY KEY,
  jadwal_id TEXT,
  asisten_id TEXT,
  asisten_nama TEXT,
  asisten_nim TEXT,
  matkul TEXT,
  percobaan TEXT,
  tanggal TEXT,
  tanggal_selesai TEXT,
  tahun_akademik TEXT,
  semester TEXT,
  nomor_urut INTEGER,
  penandatangan JSONB,
  status TEXT DEFAULT 'terbit',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 14. LAPORAN
CREATE TABLE IF NOT EXISTS laporan (
  id TEXT PRIMARY KEY,
  jadwal_id TEXT,
  user_id TEXT,
  nama TEXT,
  nim TEXT,
  file_name TEXT,
  file_data TEXT,
  status TEXT DEFAULT 'pending',
  catatan TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Disable RLS for all tables (simple app auth)
-- =============================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE kurikulum ENABLE ROW LEVEL SECURITY;
ALTER TABLE jadwal ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventaris ENABLE ROW LEVEL SECURITY;
ALTER TABLE peminjaman ENABLE ROW LEVEL SECURITY;
ALTER TABLE nilai ENABLE ROW LEVEL SECURITY;
ALTER TABLE absensi ENABLE ROW LEVEL SECURITY;
ALTER TABLE registrasi ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifikasi ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE surat_bebas ENABLE ROW LEVEL SECURITY;
ALTER TABLE surat_tugas ENABLE ROW LEVEL SECURITY;
ALTER TABLE sertifikat_asisten ENABLE ROW LEVEL SECURITY;
ALTER TABLE laporan ENABLE ROW LEVEL SECURITY;

-- Allow anon key full access (app handles auth in JS)
CREATE POLICY "Allow all" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON kurikulum FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON jadwal FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON inventaris FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON peminjaman FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON nilai FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON absensi FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON registrasi FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON notifikasi FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON surat_bebas FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON surat_tugas FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON sertifikat_asisten FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all" ON laporan FOR ALL USING (true) WITH CHECK (true);

-- Insert default admin user
INSERT INTO users (id, username, password, nama, role, nim)
VALUES ('u1', 'admin', 'admin2024', 'Administrator', 'admin', '')
ON CONFLICT (id) DO NOTHING;
