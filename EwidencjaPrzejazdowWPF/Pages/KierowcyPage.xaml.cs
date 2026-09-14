using System.Linq;
using System.Windows;
using System.Windows.Controls;
using EwidencjaPrzejazdowWPF.DataBase;
using EwidencjaPrzejazdowWPF.DataBase.Models;
using Microsoft.EntityFrameworkCore;

namespace EwidencjaPrzejazdowWPF.Pages;

public partial class KierowcyPage : Page
{
    public KierowcyPage()
    {
        InitializeComponent();
        LoadData();
    }

    private void LoadData()
    {
        using var db = new AppDbContext();
        KierowcyGrid.ItemsSource = db.Kierowcy.AsNoTracking().OrderBy(x => x.Nazwisko).ThenBy(x => x.Imie).ToList();
    }

    private void RefreshButton_Click(object sender, RoutedEventArgs e) => LoadData();

    private void AddButton_Click(object sender, RoutedEventArgs e)
    {
        if (string.IsNullOrWhiteSpace(ImieTextBox.Text) ||
            string.IsNullOrWhiteSpace(NazwiskoTextBox.Text) ||
            string.IsNullOrWhiteSpace(DzialTextBox.Text) ||
            string.IsNullOrWhiteSpace(StanowiskoTextBox.Text))
        {
            MessageBox.Show("Uzupełnij wszystkie pola kierowcy.");
            return;
        }

        using var db = new AppDbContext();
        db.Kierowcy.Add(new Kierowca
        {
            Imie = ImieTextBox.Text.Trim(),
            Nazwisko = NazwiskoTextBox.Text.Trim(),
            Dzial = DzialTextBox.Text.Trim(),
            Stanowisko = StanowiskoTextBox.Text.Trim()
        });
        db.SaveChanges();
        ImieTextBox.Clear();
        NazwiskoTextBox.Clear();
        DzialTextBox.Clear();
        StanowiskoTextBox.Clear();
        LoadData();
    }

    private void DeleteButton_Click(object sender, RoutedEventArgs e)
    {
        if (KierowcyGrid.SelectedItem is not Kierowca selected)
        {
            MessageBox.Show("Wybierz kierowcę do usunięcia.");
            return;
        }

        if (MessageBox.Show("Czy na pewno usunąć kierowcę?", "Potwierdzenie", MessageBoxButton.YesNo) != MessageBoxResult.Yes)
            return;

        try
        {
            using var db = new AppDbContext();
            var entity = db.Kierowcy.First(x => x.IdKierowcy == selected.IdKierowcy);
            db.Kierowcy.Remove(entity);
            db.SaveChanges();
            LoadData();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Nie udało się usunąć kierowcy.\n{ex.Message}");
        }
    }
}
