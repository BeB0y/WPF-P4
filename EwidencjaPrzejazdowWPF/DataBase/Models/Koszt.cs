using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EwidencjaPrzejazdowWPF.DataBase.Models;

[Table("Koszty")]
public class Koszt
{
    [Key]
    [Column("id_kosztu")]
    public int IdKosztu { get; set; }

    [Column("rodzaj_kosztu")]
    public string RodzajKosztu { get; set; } = string.Empty;

    [Column("kwota")]
    public decimal Kwota { get; set; }

    [Column("data_kosztu")]
    public DateTime DataKosztu { get; set; }

    [Column("opis")]
    public string? Opis { get; set; }

    [Column("id_przejazdu")]
    public int IdPrzejazdu { get; set; }
}
