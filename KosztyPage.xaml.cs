using System.Globalization;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using EwidencjaPrzejazdowWPF.DataBase;
using EwidencjaPrzejazdowWPF.DataBase.Models;
using Microsoft.EntityFrameworkCore;

namespace EwidencjaPrzejazdowWPF.Pages;

public partial class KosztyPage : Page
{
    public KosztyPage()
    {
        InitializeComponent();
        DataKosztuDatePicker.SelectedDate = DateTime.Today;
        LoadLookups();
        LoadData();
    }

    private void LoadLookups()
    {
        using var db = new AppDbContext();
        PrzejazdComboBox.ItemsSource = db.Przejazdy.AsNoTracking().OrderByDescending(x => x.IdPrzejazdu).ToList();
    }

    private void LoadData()
    {
        using var db = new AppDbContext();
        KosztyGrid.ItemsSource = db.Koszty.AsNoTracking().OrderByDescending(x => x.DataKosztu).ThenByDescending(x => x.IdKosztu).ToList();
    }

    private void RefreshButton_Click(object sender, RoutedEventArgs e)
    {
        LoadLookups();
        LoadData();
    }

    private void AddButton_Click(object sender, RoutedEventArgs e)
    {
        var rodzaj = (RodzajKosztuComboBox.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? string.Empty;
        if (DataKosztuDatePicker.SelectedDate is null ||
            PrzejazdComboBox.SelectedValue is null ||
            string.IsNullOrWhiteSpace(rodzaj) ||
            !decimal.TryParse(KwotaTextBox.Text.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var kwota))
        {
            MessageBox.Show("Uzupełnij poprawnie wszystkie pola kosztu.");
            return;
        }

        try
        {
            using var db = new AppDbContext();
            db.Koszty.Add(new Koszt
            {
                RodzajKosztu = rodzaj,
                Kwota = kwota,
                DataKosztu = DataKosztuDatePicker.SelectedDate.Value,
                Opis = OpisTextBox.Text.Trim(),
                IdPrzejazdu = (int)PrzejazdComboBox.SelectedValue
            });
            db.SaveChanges();
            KwotaTextBox.Clear();
            OpisTextBox.Clear();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się dodać kosztu.\n{ex.Message}");
        }
    }

    private void DeleteButton_Click(object sender, RoutedEventArgs e)
    {
        if (KosztyGrid.SelectedItem is not Koszt selected)
        {
            MessageBox.Show("Wybierz koszt do usunięcia.");
            return;
        }

        if (MessageBox.Show("Czy na pewno usunąć koszt?", "Potwierdzenie", MessageBoxButton.YesNo) != MessageBoxResult.Yes)
            return;

        try
        {
            using var db = new AppDbContext();
            var entity = db.Koszty.First(x => x.IdKosztu == selected.IdKosztu);
            db.Koszty.Remove(entity);
            db.SaveChanges();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się usunąć kosztu.\n{ex.Message}");
        }
    }
}
