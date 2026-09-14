using System.Globalization;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using EwidencjaPrzejazdowWPF.DataBase;
using EwidencjaPrzejazdowWPF.DataBase.Models;
using Microsoft.EntityFrameworkCore;

namespace EwidencjaPrzejazdowWPF.Pages;

public partial class PojazdyPage : Page
{
    public PojazdyPage()
    {
        InitializeComponent();
        LoadData();
    }

    private void LoadData()
    {
        using var db = new AppDbContext();
        PojazdyGrid.ItemsSource = db.Pojazdy.AsNoTracking().OrderBy(x => x.NumerRejestracyjny).ToList();
    }

    private void RefreshButton_Click(object sender, RoutedEventArgs e) => LoadData();

    private void AddButton_Click(object sender, RoutedEventArgs e)
    {
        if (!decimal.TryParse(SpalanieTextBox.Text.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var spalanie) ||
            !decimal.TryParse(CenaPaliwaTextBox.Text.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var cena))
        {
            MessageBox.Show("Podaj poprawne wartości liczbowe dla spalania i ceny paliwa.");
            return;
        }

        var typ = (TypWlasnosciComboBox.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? string.Empty;
        var paliwo = (RodzajPaliwaComboBox.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? string.Empty;

        if (string.IsNullOrWhiteSpace(MarkaTextBox.Text) ||
            string.IsNullOrWhiteSpace(ModelTextBox.Text) ||
            string.IsNullOrWhiteSpace(RejestracjaTextBox.Text) ||
            string.IsNullOrWhiteSpace(typ) ||
            string.IsNullOrWhiteSpace(paliwo))
        {
            MessageBox.Show("Uzupełnij wszystkie pola pojazdu.");
            return;
        }

        using var db = new AppDbContext();
        db.Pojazdy.Add(new Pojazd
        {
            Marka = MarkaTextBox.Text.Trim(),
            Model = ModelTextBox.Text.Trim(),
            NumerRejestracyjny = RejestracjaTextBox.Text.Trim(),
            TypWlasnosci = typ,
            RodzajPaliwa = paliwo,
            SrednieSpalanie100km = spalanie,
            CenaPaliwaZaLitr = cena
        });
        db.SaveChanges();
        MarkaTextBox.Clear();
        ModelTextBox.Clear();
        RejestracjaTextBox.Clear();
        SpalanieTextBox.Clear();
        CenaPaliwaTextBox.Clear();
        LoadData();
    }

    private void DeleteButton_Click(object sender, RoutedEventArgs e)
    {
        if (PojazdyGrid.SelectedItem is not Pojazd selected)
        {
            MessageBox.Show("Wybierz pojazd do usunięcia.");
            return;
        }

        if (MessageBox.Show("Czy na pewno usunąć pojazd?", "Potwierdzenie", MessageBoxButton.YesNo) != MessageBoxResult.Yes)
            return;

        try
        {
            using var db = new AppDbContext();
            var entity = db.Pojazdy.First(x => x.IdPojazdu == selected.IdPojazdu);
            db.Pojazdy.Remove(entity);
            db.SaveChanges();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się usunąć pojazdu.\n{ex.Message}");
        }
    }
}
