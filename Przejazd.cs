using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EwidencjaPrzejazdowWPF.DataBase.Models;

[Table("Przejazd")]
public class Przejazd
{
    [Key]
    [Column("id_przejazdu")]
    public int IdPrzejazdu { get; set; }

    [Column("data_przejazdu")]
    public DateTime DataPrzejazdu { get; set; }

    [Column("cel_przejazdu")]
    public string CelPrzejazdu { get; set; } = string.Empty;

    [Column("trasa")]
    public string Trasa { get; set; } = string.Empty;

    [Column("liczba_kilometrow")]
    public decimal LiczbaKilometrow { get; set; }

    [Column("stan_licznika_przed")]
    public decimal StanLicznikaPrzed { get; set; }

    [Column("stan_licznika_po")]
    public decimal StanLicznikaPo { get; set; }

    [Column("id_kierowcy")]
    public int IdKierowcy { get; set; }

    [Column("id_pojazdu")]
    public int IdPojazdu { get; set; }
}
