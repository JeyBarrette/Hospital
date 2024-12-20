﻿using System;
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
        List<Operations> currentOperations = new List<Operations>();

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
            Manager.MainFrame.Navigate(new AddOperationPage(null));
            UpdateOperations();
        }

        private void MenuItem_EditClick(object sender, RoutedEventArgs e)
        {
            Manager.MainFrame.Navigate(new AddOperationPage((sender as MenuItem).DataContext as Operations));
            UpdateOperations();
        }

        private void MenuItem_DelClick(object sender, RoutedEventArgs e)
        {
            var currentClient = (sender as MenuItem).DataContext as Operations;

            if (currentClient.OperationCount == 0)
            {
                if (MessageBox.Show("Вы точно хотите выполнить удаление?", "Внимание!", MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
                {
                    HospitalEntities.GetContext().Operations.Remove(currentClient);
                    HospitalEntities.GetContext().SaveChanges();
                    OperationsListView.ItemsSource = HospitalEntities.GetContext().Operations.ToList();
                    UpdateOperations();
                }
            }
            else
            {
                MessageBox.Show("Невозможно выполнить удаление, так как данная операция есть в истории болезни пациента!");
            }
        }

        private void Page_IsVisibleChanged(object sender, DependencyPropertyChangedEventArgs e)
        {
            var currentPartners = HospitalEntities.GetContext().Operations.ToList();
            OperationsListView.ItemsSource = currentPartners;
        }
    }
}
