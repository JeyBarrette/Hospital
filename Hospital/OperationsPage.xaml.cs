using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Hospital
{
    /// <summary>
    /// Логика взаимодействия для OperationsPage.xaml
    /// </summary>
    public partial class OperationsPage : Page
    {
        //List<Operations> selectedOperation = new List<Operations>();

        public OperationsPage()
        {
            InitializeComponent();
            List<Operations> currentOperation = HospitalEntities.GetContext().Operations.ToList();
            OperationsListView.ItemsSource = currentOperation;
            OperationFilterCB.SelectedIndex = 0;
            OperationSortCB.SelectedIndex = 0;
            UpdateOperations();
        }

        private void UpdateOperations()
        {
            var currentOperation = HospitalEntities.GetContext().Operations.ToList();
            currentOperation = currentOperation.Where(p => p.OperationDescription.ToLower().Contains(OperationSearchTB.Text.ToLower())).ToList();

            if (OperationFilterCB.SelectedIndex == 0)
            {

            }
            if (OperationFilterCB.SelectedIndex == 1)
            {
                currentOperation = currentOperation.OrderByDescending(p => p.OperationDate).ToList();
            }
            if (OperationFilterCB.SelectedIndex == 2)
            {
                currentOperation = currentOperation.OrderBy(p => p.OperationDate).ToList();
            }

            if (OperationSortCB.SelectedIndex == 0)
            {

            }
            if (OperationSortCB.SelectedIndex == 1)
            {
                currentOperation = currentOperation.Where(p => p.OperationResult == "Успешно").ToList();
            }
            if (OperationSortCB.SelectedIndex == 2)
            {
                currentOperation = currentOperation.Where(p => p.OperationResult == "Неуспешно").ToList();
            }

            OperationsOverall.Text = HospitalEntities.GetContext().Operations.Count().ToString();
            OperationsOnScreen.Text = currentOperation.Count().ToString();

            OperationsListView.ItemsSource = currentOperation;
        }

        private void OperationSearchTB_TextChanged(object sender, TextChangedEventArgs e)
        {
            UpdateOperations();
        }

        private void OperationFilterCB_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateOperations();
        }

        private void OperationSortCB_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateOperations();
        }

        private void AddOperationBTN_Click(object sender, RoutedEventArgs e)
        {
            Manager.MainFrame.Navigate(new AddOperationPage((sender as Button).DataContext as Operations));   
            UpdateOperations();
        }

        private void MenuItem_EditClick(object sender, RoutedEventArgs e)
        {

        }

        private void MenuItem_DelClick(object sender, RoutedEventArgs e)
        {

        }
    }
}
