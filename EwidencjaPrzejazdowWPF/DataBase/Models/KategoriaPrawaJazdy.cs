using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EwidencjaPrzejazdowWPF.DataBase.Models;

[Table("KategoriaPrawaJazdy")]
public class KategoriaPrawaJazdy
{
    [Key]
    [Column("id_kategorii")]
    public int IdKategorii { get; set; }

    [Column("nazwa_kategorii")]
    public string NazwaKategorii { get; set; } = string.Empty;
}
