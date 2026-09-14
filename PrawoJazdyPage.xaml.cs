using System.Linq;
using System.Windows;
using System.Windows.Controls;
using EwidencjaPrzejazdowWPF.DataBase;
using EwidencjaPrzejazdowWPF.DataBase.Models;
using Microsoft.EntityFrameworkCore;

namespace EwidencjaPrzejazdowWPF.Pages;

public partial class PrawoJazdyPage : Page
{
    public PrawoJazdyPage()
    {
        InitializeComponent();
        DataWydaniaDatePicker.SelectedDate = DateTime.Today;
        DataWaznosciDatePicker.SelectedDate = DateTime.Today.AddYears(10);
        LoadLookups();
        LoadData();
    }

    private void LoadLookups()
    {
        using var db = new AppDbContext();
        KierowcaComboBox.ItemsSource = db.Kierowcy.AsNoTracking().OrderBy(x => x.Nazwisko).ToList();
        KategoriaComboBox.ItemsSource = db.KategoriePrawaJazdy.AsNoTracking().OrderBy(x => x.NazwaKategorii).ToList();
    }

    private void LoadData()
    {
        using var db = new AppDbContext();
        PrawoJazdyGrid.ItemsSource = db.PrawaJazdy.AsNoTracking().OrderByDescending(x => x.IdPrawaJazdy).ToList();
    }

    private void RefreshButton_Click(object sender, RoutedEventArgs e)
    {
        LoadLookups();
        LoadData();
    }

    private void AddButton_Click(object sender, RoutedEventArgs e)
    {
        if (DataWydaniaDatePicker.SelectedDate is null ||
            DataWaznosciDatePicker.SelectedDate is null ||
            KierowcaComboBox.SelectedValue is null ||
            KategoriaComboBox.SelectedValue is null ||
            string.IsNullOrWhiteSpace(NumerTextBox.Text))
        {
            MessageBox.Show("Uzupełnij wszystkie pola prawa jazdy.");
            return;
        }

        try
        {
            using var db = new AppDbContext();
            var prawo = new PrawoJazdy
            {
                NumerPrawaJazdy = NumerTextBox.Text.Trim(),
                DataWydania = DataWydaniaDatePicker.SelectedDate.Value,
                DataWaznosci = DataWaznosciDatePicker.SelectedDate.Value,
                IdKierowcy = (int)KierowcaComboBox.SelectedValue
            };

            db.PrawaJazdy.Add(prawo);
            db.SaveChanges();

            db.PrawaJazdyKategorie.Add(new PrawoJazdyKategoria
            {
                IdPrawaJazdy = prawo.IdPrawaJazdy,
                IdKategorii = (int)KategoriaComboBox.SelectedValue
            });
            db.SaveChanges();

            NumerTextBox.Clear();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się dodać prawa jazdy.\n{ex.Message}");
        }
    }

    private void DeleteButton_Click(object sender, RoutedEventArgs e)
    {
        if (PrawoJazdyGrid.SelectedItem is not PrawoJazdy selected)
        {
            MessageBox.Show("Wybierz prawo jazdy do usunięcia.");
            return;
        }

        if (MessageBox.Show("Czy na pewno usunąć prawo jazdy?", "Potwierdzenie", MessageBoxButton.YesNo) != MessageBoxResult.Yes)
            return;

        try
        {
            using var db = new AppDbContext();
            var relacje = db.PrawaJazdyKategorie.Where(x => x.IdPrawaJazdy == selected.IdPrawaJazdy).ToList();
            if (relacje.Count > 0)
                db.PrawaJazdyKategorie.RemoveRange(relacje);
            var entity = db.PrawaJazdy.First(x => x.IdPrawaJazdy == selected.IdPrawaJazdy);
            db.PrawaJazdy.Remove(entity);
            db.SaveChanges();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się usunąć prawa jazdy.\n{ex.Message}");
        }
    }
}
