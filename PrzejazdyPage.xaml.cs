using System.Globalization;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using EwidencjaPrzejazdowWPF.DataBase;
using EwidencjaPrzejazdowWPF.DataBase.Models;
using Microsoft.EntityFrameworkCore;

namespace EwidencjaPrzejazdowWPF.Pages;

public partial class PrzejazdyPage : Page
{
    public PrzejazdyPage()
    {
        InitializeComponent();
        DataDatePicker.SelectedDate = DateTime.Today;
        LoadLookups();
        LoadData();
    }

    private void LoadLookups()
    {
        using var db = new AppDbContext();
        KierowcaComboBox.ItemsSource = db.Kierowcy.AsNoTracking().OrderBy(x => x.Nazwisko).ToList();
        PojazdComboBox.ItemsSource = db.Pojazdy.AsNoTracking().OrderBy(x => x.NumerRejestracyjny).ToList();
    }

    private void LoadData()
    {
        using var db = new AppDbContext();
        PrzejazdyGrid.ItemsSource = db.Przejazdy.AsNoTracking().OrderByDescending(x => x.DataPrzejazdu).ThenByDescending(x => x.IdPrzejazdu).ToList();
    }

    private void RefreshButton_Click(object sender, RoutedEventArgs e)
    {
        LoadLookups();
        LoadData();
    }

    private void AddButton_Click(object sender, RoutedEventArgs e)
    {
        if (DataDatePicker.SelectedDate is null ||
            KierowcaComboBox.SelectedValue is null ||
            PojazdComboBox.SelectedValue is null ||
            !decimal.TryParse(KilometryTextBox.Text.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var km) ||
            !decimal.TryParse(LicznikPrzedTextBox.Text.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var lp) ||
            !decimal.TryParse(LicznikPoTextBox.Text.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var lpo))
        {
            MessageBox.Show("Uzupełnij poprawnie wszystkie pola przejazdu.");
            return;
        }

        if (string.IsNullOrWhiteSpace(CelTextBox.Text) || string.IsNullOrWhiteSpace(TrasaTextBox.Text))
        {
            MessageBox.Show("Podaj cel i trasę przejazdu.");
            return;
        }

        try
        {
            using var db = new AppDbContext();
            db.Przejazdy.Add(new Przejazd
            {
                DataPrzejazdu = DataDatePicker.SelectedDate.Value,
                CelPrzejazdu = CelTextBox.Text.Trim(),
                Trasa = TrasaTextBox.Text.Trim(),
                LiczbaKilometrow = km,
                StanLicznikaPrzed = lp,
                StanLicznikaPo = lpo,
                IdKierowcy = (int)KierowcaComboBox.SelectedValue,
                IdPojazdu = (int)PojazdComboBox.SelectedValue
            });
            db.SaveChanges();
            CelTextBox.Clear();
            TrasaTextBox.Clear();
            KilometryTextBox.Clear();
            LicznikPrzedTextBox.Clear();
            LicznikPoTextBox.Clear();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się dodać przejazdu.\n{ex.Message}");
        }
    }

    private void DeleteButton_Click(object sender, RoutedEventArgs e)
    {
        if (PrzejazdyGrid.SelectedItem is not Przejazd selected)
        {
            MessageBox.Show("Wybierz przejazd do usunięcia.");
            return;
        }

        if (MessageBox.Show("Czy na pewno usunąć przejazd?", "Potwierdzenie", MessageBoxButton.YesNo) != MessageBoxResult.Yes)
            return;

        try
        {
            using var db = new AppDbContext();
            var koszty = db.Koszty.Where(x => x.IdPrzejazdu == selected.IdPrzejazdu).ToList();
            if (koszty.Count > 0)
                db.Koszty.RemoveRange(koszty);
            var entity = db.Przejazdy.First(x => x.IdPrzejazdu == selected.IdPrzejazdu);
            db.Przejazdy.Remove(entity);
            db.SaveChanges();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się usunąć przejazdu.\n{ex.Message}");
        }
    }
}
