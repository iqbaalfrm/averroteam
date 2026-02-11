package progres

type UpsertRequest struct {
    KelasID        uint   `json:"kelas_id"`
    MateriTerakhir uint   `json:"materi_terakhir"`
    StatusKuis     string `json:"status_kuis"`
}