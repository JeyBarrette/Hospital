using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
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

        public bool check = false;

        public AddOperationPage(Operations operation)
        {
            InitializeComponent();      

            var currentPatient = HospitalEntities.GetContext().Patients.Select(p => (p.PatientSurname + " " + p.PatientFirstName + " " + p.PatientPatronymic)).ToList();
            var currentDoctor = HospitalEntities.GetContext().Doctors.Select(p => p.DoctorSurname + " " + p.DoctorFirstName + " " + p.DoctorPatronymic).ToList();


            foreach (var Patients in currentPatient)
            {
                PatientsCBox.Items.Add(Patients);
            }

            foreach (var Doctors in currentDoctor)
            {   
                DoctorsCBox.Items.Add(Doctors);
            }

            if (operation != null)
            {
                check = true;
                currentOperation = operation;   
                OperationDateDP.Text = currentOperation.OperationDate.ToString();
                PatientsCBox.SelectedIndex = currentOperation.PatientID - 1;
                DoctorsCBox.SelectedIndex = currentOperation.DoctorID - 1;
                OperationDescriptionBox.Text = currentOperation.OperationDescription;

                if (currentOperation.OperationResult == "Успешно")
                {
                    OperationResultBox.SelectedIndex = 0;
                }
                else
                {
                    OperationResultBox.SelectedIndex = 1;
                }

                Console.WriteLine(currentOperation.OperationID);
                Console.WriteLine(DoctorsCBox.Text);
                Console.WriteLine(PatientsCBox.Text);
                Console.WriteLine(OperationDateDP.Text);
                Console.WriteLine(OperationDescriptionBox.Text);
                Console.WriteLine(OperationResultBox.Text);
                Console.WriteLine(PatientsCBox.SelectedIndex.ToString());
                Console.WriteLine(DoctorsCBox.SelectedIndex.ToString());
            }
            else
            {
                OperationIDBox.Visibility = Visibility.Hidden;
                OperationIDTextBox.Visibility = Visibility.Hidden;
                OperationResultBox.SelectedIndex = 0;
                OperationDateDP.SelectedDate = DateTime.Today;
                //currentOperation = new Operations(); 
                //PhotoImage.Source = BitmapFrame.Create(new Uri("/Hospital;component/Hospital/Images/picture.png", UriKind.Relative));
            }
            DataContext = currentOperation; 
        }

        private void ChangePictureBtn_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog myOpenFileDialog = new OpenFileDialog();
            if (myOpenFileDialog.ShowDialog() == true)
            {
                currentOperation.OperationImage = myOpenFileDialog.FileName;
                PhotoImage.Source = new BitmapImage(new Uri(myOpenFileDialog.FileName));
            }
        }

        private void OperationDescriptionBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            string filteredText = new string(textBox.Text.Where(c => char.IsLetter(c) || c == ' ' || c == '-').ToArray());

            if (filteredText != textBox.Text)
            {
                textBox.Text = filteredText;
                textBox.SelectionStart = filteredText.Length;
            }
        }

        private void ClientSave_Click(object sender, RoutedEventArgs e)
        {
            StringBuilder errors = new StringBuilder();
            if (string.IsNullOrWhiteSpace(currentOperation.OperationDescription))
            {
                errors.AppendLine("Укажите описание операции!");
            }
            else if (string.IsNullOrEmpty(currentOperation.OperationDescription.Trim()))
            {
                errors.AppendLine("Описание операции пустое или содержит только пробелы!");
            }
            else if (currentOperation.OperationDescription.Length > 60)
            {
                errors.AppendLine("Слишком длинное описание операции!");
            }

            if (PatientsCBox.SelectedIndex == -1)
            {
                errors.AppendLine("Выберите пациента!");
            }
            if (DoctorsCBox.SelectedIndex == -1)
            {
                errors.AppendLine("Выберите доктора!");
            }

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString());
                return;
            }

            if (OperationResultBox.SelectedIndex == 0)
            {
                currentOperation.OperationResult = "Успешно";
            }
            else
            {
                currentOperation.OperationResult = "Неуспешно";
            }


            currentOperation.PatientID = PatientsCBox.SelectedIndex + 1;
            currentOperation.DoctorID = DoctorsCBox.SelectedIndex + 1;  
            currentOperation.OperationDescription = OperationDescriptionBox.Text;
            currentOperation.OperationDate = (DateTime)OperationDateDP.SelectedDate;

            //currentOperation.currentPatient = PatientsCBox.SelectedItem.ToString();
            //currentOperation.currentDoctor = DoctorsCBox.SelectedIndex.ToString();


            var allOperation = HospitalEntities.GetContext().Operations.ToList();
            allOperation = allOperation.Where(p => p.OperationDescription == currentOperation.OperationDescription).ToList();
            allOperation = allOperation.Where(p => p.OperationDescription == currentOperation.OperationDescription 
            && p.currentPatient == currentOperation.PatientID.ToString()).ToList();

            if (allOperation.Count == 0 || check == true)
            {
                if (currentOperation.OperationID == 0)          
                {
                    HospitalEntities.GetContext().Operations.Add(currentOperation);
                }
                try
                {
                    HospitalEntities.GetContext().SaveChanges();
                    MessageBox.Show("Информация о проведенной операции сохранена.");
                    Manager.MainFrame.GoBack();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message.ToString());
                }
            }
            else
                MessageBox.Show("Такая операция уже была записана.");
        }
    }
}
