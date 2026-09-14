using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EwidencjaPrzejazdowWPF.DataBase.Models;

[Table("PrawoJazdy")]
public class PrawoJazdy
{
    [Key]
    [Column("id_prawa_jazdy")]
    public int IdPrawaJazdy { get; set; }

    [Column("numer_prawa_jazdy")]
    public string NumerPrawaJazdy { get; set; } = string.Empty;

    [Column("data_wydania")]
    public DateTime DataWydania { get; set; }

    [Column("data_waznosci")]
    public DateTime DataWaznosci { get; set; }

    [Column("id_kierowcy")]
    public int IdKierowcy { get; set; }
}
