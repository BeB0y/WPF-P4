using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EwidencjaPrzejazdowWPF.DataBase.Models;

[Table("Pojazd")]
public class Pojazd
{
    [Key]
    [Column("id_pojazdu")]
    public int IdPojazdu { get; set; }

    [Column("marka")]
    public string Marka { get; set; } = string.Empty;

    [Column("model")]
    public string Model { get; set; } = string.Empty;

    [Column("numer_rejestracyjny")]
    public string NumerRejestracyjny { get; set; } = string.Empty;

    [Column("typ_wlasnosci")]
    public string TypWlasnosci { get; set; } = string.Empty;

    [Column("rodzaj_paliwa")]
    public string RodzajPaliwa { get; set; } = string.Empty;

    [Column("srednie_spalanie_100km")]
    public decimal SrednieSpalanie100km { get; set; }

    [Column("cena_paliwa_za_litr")]
    public decimal CenaPaliwaZaLitr { get; set; }

    [NotMapped]
    public string WyswietlanaNazwa => $"{NumerRejestracyjny} - {Marka} {Model}";
}
