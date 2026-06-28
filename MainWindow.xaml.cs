using System.Windows;
using EwidencjaPrzejazdowWPF.Pages;

namespace EwidencjaPrzejazdowWPF;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        MainFrame.Navigate(new HomePage());
    }

    private void HomeButton_Click(object sender, RoutedEventArgs e) => MainFrame.Navigate(new HomePage());
    private void KierowcyButton_Click(object sender, RoutedEventArgs e) => MainFrame.Navigate(new KierowcyPage());
    private void PojazdyButton_Click(object sender, RoutedEventArgs e) => MainFrame.Navigate(new PojazdyPage());
    private void PrzejazdyButton_Click(object sender, RoutedEventArgs e) => MainFrame.Navigate(new PrzejazdyPage());
    private void KosztyButton_Click(object sender, RoutedEventArgs e) => MainFrame.Navigate(new KosztyPage());
    private void PrawoJazdyButton_Click(object sender, RoutedEventArgs e) => MainFrame.Navigate(new PrawoJazdyPage());
}
