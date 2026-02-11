package database

import "gorm.io/gorm"

type seedKelas struct {
	Judul     string
	Deskripsi string
	Materi    []seedMateri
	Kuis      []seedKuis
}

type seedMateri struct {
	Judul  string
	Konten string
	Urutan int
}

type seedKuis struct {
	Pertanyaan string
	Jawaban    []seedJawaban
}

type seedJawaban struct {
	Teks  string
	Benar bool
}

// SeedDummyLearning memastikan data dummy kelas, materi, kuis, dan jawaban kuis
// tersedia untuk kebutuhan development tanpa membuat duplikasi.
func SeedDummyLearning(db *gorm.DB) error {
	return db.Transaction(func(tx *gorm.DB) error {
		for _, item := range defaultLearningSeeds() {
			kelas := Kelas{}
			if err := tx.Where("judul = ?", item.Judul).First(&kelas).Error; err != nil {
				if err != gorm.ErrRecordNotFound {
					return err
				}
				kelas = Kelas{
					Judul:     item.Judul,
					Deskripsi: item.Deskripsi,
				}
				if err := tx.Create(&kelas).Error; err != nil {
					return err
				}
			}

			for _, materi := range item.Materi {
				exists := Materi{}
				if err := tx.Where("kelas_id = ? AND urutan = ? AND judul = ?", kelas.ID, materi.Urutan, materi.Judul).First(&exists).Error; err != nil {
					if err != gorm.ErrRecordNotFound {
						return err
					}
					if err := tx.Create(&Materi{
						KelasID: kelas.ID,
						Judul:   materi.Judul,
						Konten:  materi.Konten,
						Urutan:  materi.Urutan,
					}).Error; err != nil {
						return err
					}
				}
			}

			for _, kuis := range item.Kuis {
				kuisEntity := Kuis{}
				if err := tx.Where("kelas_id = ? AND pertanyaan = ?", kelas.ID, kuis.Pertanyaan).First(&kuisEntity).Error; err != nil {
					if err != gorm.ErrRecordNotFound {
						return err
					}
					kuisEntity = Kuis{
						KelasID:    kelas.ID,
						Pertanyaan: kuis.Pertanyaan,
					}
					if err := tx.Create(&kuisEntity).Error; err != nil {
						return err
					}
				}

				for _, jawaban := range kuis.Jawaban {
					exists := JawabanKuis{}
					if err := tx.Where("kuis_id = ? AND jawaban = ?", kuisEntity.ID, jawaban.Teks).First(&exists).Error; err != nil {
						if err != gorm.ErrRecordNotFound {
							return err
						}
						if err := tx.Create(&JawabanKuis{
							KuisID:  kuisEntity.ID,
							Jawaban: jawaban.Teks,
							Benar:   jawaban.Benar,
						}).Error; err != nil {
							return err
						}
					}
				}
			}
		}

		return nil
	})
}

func defaultLearningSeeds() []seedKelas {
	return []seedKelas{
		{
			Judul:     "Dasar Crypto Syariah",
			Deskripsi: "Pengenalan konsep aset digital, risiko, dan prinsip fiqh muamalah pada aktivitas crypto.",
			Materi: []seedMateri{
				{
					Judul:  "Apa itu Crypto dan Blockchain",
					Konten: "Crypto adalah aset digital berbasis kriptografi. Blockchain adalah ledger terdistribusi yang mencatat transaksi secara transparan.",
					Urutan: 1,
				},
				{
					Judul:  "Prinsip Syariah: Riba, Gharar, Maysir",
					Konten: "Evaluasi aset dan aktivitas crypto perlu memperhatikan larangan riba, gharar berlebihan, dan maysir atau spekulasi murni.",
					Urutan: 2,
				},
				{
					Judul:  "Membedakan Investasi dan Spekulasi",
					Konten: "Investasi berfokus pada fundamental proyek dan manajemen risiko. Spekulasi murni cenderung mengejar kenaikan harga jangka sangat pendek tanpa analisis memadai.",
					Urutan: 3,
				},
				{
					Judul:  "Keamanan Dasar Wallet",
					Konten: "Gunakan seed phrase offline, aktifkan 2FA, dan hindari membagikan private key kepada siapa pun.",
					Urutan: 4,
				},
			},
			Kuis: []seedKuis{
				{
					Pertanyaan: "Apa fungsi utama blockchain?",
					Jawaban: []seedJawaban{
						{Teks: "Menyimpan data transaksi secara terdesentralisasi", Benar: true},
						{Teks: "Menggantikan fungsi email", Benar: false},
						{Teks: "Membuat harga selalu naik", Benar: false},
						{Teks: "Menjamin profit tanpa risiko", Benar: false},
					},
				},
				{
					Pertanyaan: "Aktivitas mana yang paling dekat dengan maysir?",
					Jawaban: []seedJawaban{
						{Teks: "Membeli aset tanpa riset lalu berharap untung cepat", Benar: true},
						{Teks: "Membaca whitepaper sebelum investasi", Benar: false},
						{Teks: "Mencatat alokasi portofolio", Benar: false},
						{Teks: "Menggunakan stop loss", Benar: false},
					},
				},
				{
					Pertanyaan: "Mana praktik keamanan wallet yang benar?",
					Jawaban: []seedJawaban{
						{Teks: "Menyimpan seed phrase di catatan online publik", Benar: false},
						{Teks: "Memberi private key ke admin komunitas", Benar: false},
						{Teks: "Menyimpan seed phrase offline dan rahasia", Benar: true},
						{Teks: "Memakai password yang sama di semua akun", Benar: false},
					},
				},
			},
		},
		{
			Judul:     "Manajemen Risiko Portofolio Crypto",
			Deskripsi: "Strategi alokasi aset, kontrol emosi, dan mitigasi kerugian pada pasar crypto yang volatil.",
			Materi: []seedMateri{
				{
					Judul:  "Menyusun Alokasi Aset",
					Konten: "Tentukan persentase modal untuk aset utama, aset risiko tinggi, dan kas cadangan agar portofolio lebih seimbang.",
					Urutan: 1,
				},
				{
					Judul:  "Stop Loss dan Position Sizing",
					Konten: "Batasi kerugian per transaksi dan hindari ukuran posisi terlalu besar agar satu kesalahan tidak merusak seluruh modal.",
					Urutan: 2,
				},
				{
					Judul:  "Diversifikasi yang Masuk Akal",
					Konten: "Diversifikasi lintas kategori aset membantu mengurangi risiko konsentrasi, tetapi tetap harus menjaga kualitas aset.",
					Urutan: 3,
				},
				{
					Judul:  "Psikologi Market dan Disiplin",
					Konten: "FOMO dan panik sering memicu keputusan buruk. Gunakan rencana trading atau investasi yang terdokumentasi.",
					Urutan: 4,
				},
			},
			Kuis: []seedKuis{
				{
					Pertanyaan: "Tujuan utama stop loss adalah?",
					Jawaban: []seedJawaban{
						{Teks: "Mengunci keuntungan maksimal setiap saat", Benar: false},
						{Teks: "Membatasi kerugian saat skenario tidak sesuai rencana", Benar: true},
						{Teks: "Membuat transaksi pasti profit", Benar: false},
						{Teks: "Menaikkan leverage otomatis", Benar: false},
					},
				},
				{
					Pertanyaan: "Apa dampak risiko konsentrasi portofolio?",
					Jawaban: []seedJawaban{
						{Teks: "Risiko menurun karena fokus satu aset", Benar: false},
						{Teks: "Portofolio lebih kebal volatilitas", Benar: false},
						{Teks: "Kerugian bisa besar saat aset utama turun tajam", Benar: true},
						{Teks: "Tidak ada dampak pada hasil akhir", Benar: false},
					},
				},
				{
					Pertanyaan: "Sikap yang tepat saat market sangat volatil?",
					Jawaban: []seedJawaban{
						{Teks: "Masuk posisi besar tanpa rencana", Benar: false},
						{Teks: "Tetap disiplin pada rencana dan batas risiko", Benar: true},
						{Teks: "Mengabaikan manajemen risiko", Benar: false},
						{Teks: "Mengikuti sinyal acak dari media sosial", Benar: false},
					},
				},
			},
		},
		{
			Judul:     "Praktik Halal pada Aktivitas Crypto",
			Deskripsi: "Panduan menilai aktivitas crypto agar selaras dengan etika transaksi syariah.",
			Materi: []seedMateri{
				{
					Judul:  "Checklist Halal untuk Proyek Crypto",
					Konten: "Periksa utilitas, model bisnis, transparansi tim, dan potensi pelanggaran syariah sebelum berpartisipasi.",
					Urutan: 1,
				},
				{
					Judul:  "Menghindari Skema Pump and Dump",
					Konten: "Waspadai kelompok yang mengatur harga sementara lalu meninggalkan investor ritel dengan kerugian.",
					Urutan: 2,
				},
				{
					Judul:  "Zakat Aset Crypto",
					Konten: "Perhitungan zakat aset crypto umumnya mengikuti nilai setara emas saat mencapai nisab dan haul, dengan rujukan ulama yang kredibel.",
					Urutan: 3,
				},
				{
					Judul:  "Etika Berbagi Informasi Investasi",
					Konten: "Hindari klaim profit pasti. Berikan edukasi berbasis data, risiko, dan batasan analisis.",
					Urutan: 4,
				},
			},
			Kuis: []seedKuis{
				{
					Pertanyaan: "Indikasi proyek yang perlu diwaspadai dari sisi etika adalah?",
					Jawaban: []seedJawaban{
						{Teks: "Dokumentasi jelas dan audit terbuka", Benar: false},
						{Teks: "Janji keuntungan pasti tanpa risiko", Benar: true},
						{Teks: "Roadmap realistis dan terukur", Benar: false},
						{Teks: "Komunikasi tim transparan", Benar: false},
					},
				},
				{
					Pertanyaan: "Perilaku yang sesuai etika saat membahas aset crypto adalah?",
					Jawaban: []seedJawaban{
						{Teks: "Memberi disclaimer risiko dan tidak menjamin profit", Benar: true},
						{Teks: "Mendorong orang pakai utang agar cepat kaya", Benar: false},
						{Teks: "Menghapus informasi risiko dari promosi", Benar: false},
						{Teks: "Membagikan rumor tanpa verifikasi", Benar: false},
					},
				},
				{
					Pertanyaan: "Konsep dasar zakat crypto yang benar adalah?",
					Jawaban: []seedJawaban{
						{Teks: "Tidak pernah wajib zakat dalam kondisi apa pun", Benar: false},
						{Teks: "Dipertimbangkan saat mencapai nisab dan haul", Benar: true},
						{Teks: "Selalu 50 persen dari total aset", Benar: false},
						{Teks: "Hanya berlaku untuk stablecoin", Benar: false},
					},
				},
			},
		},
	}
}
