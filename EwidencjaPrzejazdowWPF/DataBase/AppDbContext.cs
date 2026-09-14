using EwidencjaPrzejazdowWPF.DataBase.Models;
using Microsoft.EntityFrameworkCore;

namespace EwidencjaPrzejazdowWPF.DataBase;

public class AppDbContext : DbContext
{
    public DbSet<Kierowca> Kierowcy => Set<Kierowca>();
    public DbSet<Pojazd> Pojazdy => Set<Pojazd>();
    public DbSet<Przejazd> Przejazdy => Set<Przejazd>();
    public DbSet<Koszt> Koszty => Set<Koszt>();
    public DbSet<PrawoJazdy> PrawaJazdy => Set<PrawoJazdy>();
    public DbSet<KategoriaPrawaJazdy> KategoriePrawaJazdy => Set<KategoriaPrawaJazdy>();
    public DbSet<PrawoJazdyKategoria> PrawaJazdyKategorie => Set<PrawoJazdyKategoria>();

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlServer(
                "Server=.;Database=EwidencjaPrzejazdow;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=True;");
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<PrawoJazdyKategoria>().HasKey(x => new { x.IdPrawaJazdy, x.IdKategorii });
    }
}
