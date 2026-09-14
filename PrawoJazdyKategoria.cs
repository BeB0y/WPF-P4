using System.ComponentModel.DataAnnotations.Schema;

namespace EwidencjaPrzejazdowWPF.DataBase.Models;

[Table("PrawoJazdy_Kategoria")]
public class PrawoJazdyKategoria
{
    [Column("id_prawa_jazdy")]
    public int IdPrawaJazdy { get; set; }

    [Column("id_kategorii")]
    public int IdKategorii { get; set; }
}
