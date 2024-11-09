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
    /// Логика взаимодействия для AddOperationPage.xaml
    /// </summary>
    public partial class AddOperationPage : Page
    {
        private Operations currentOperation = new Operations();

        public AddOperationPage(Operations currentOperations)
        {
            InitializeComponent();
            DataContext = currentOperations;
        }

        private void PatientLastNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void PatientFirstNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void PatientPatronymicBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void DoctorLastNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void DoctorFirstNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void DoctorPatronymicBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void OperationDescriptionBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void ChangePictureBtn_Click(object sender, RoutedEventArgs e)
        {

        }

        private void ClientSave_Click(object sender, RoutedEventArgs e)
        {

        }
    }
}
