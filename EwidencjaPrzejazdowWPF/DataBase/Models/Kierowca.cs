using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EwidencjaPrzejazdowWPF.DataBase.Models;

[Table("Kierowcy")]
public class Kierowca
{
    [Key]
    [Column("id_kierowcy")]
    public int IdKierowcy { get; set; }

    [Column("imie")]
    public string Imie { get; set; } = string.Empty;

    [Column("nazwisko")]
    public string Nazwisko { get; set; } = string.Empty;

    [Column("dzial")]
    public string Dzial { get; set; } = string.Empty;

    [Column("stanowisko")]
    public string Stanowisko { get; set; } = string.Empty;

    [NotMapped]
    public string WyswietlanaNazwa => $"{Nazwisko} {Imie}";
}
