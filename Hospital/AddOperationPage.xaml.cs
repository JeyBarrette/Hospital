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

            if (operation != null)
            {
                check = true;
                currentOperation = operation;
                OperationDateDP.Text = currentOperation.OperationDate.ToString();
                if (currentOperation.OperationResult == "Успешно")
                {
                    OperationResultBox.SelectedIndex = 0;
                }
                else
                {
                    OperationResultBox.SelectedIndex = 1;
                }
            }
            else
            {
                OperationIDBox.Visibility = Visibility.Hidden;
                OperationIDTextBox.Visibility = Visibility.Hidden;
                OperationResultBox.SelectedIndex = 0;
                OperationDateDP.SelectedDate = DateTime.Today;
                //PhotoImage.Source = BitmapFrame.Create(new Uri("/Hospital;component/Hospital/Images/picture.png", UriKind.Relative));
            }
            DataContext = currentOperation;
        }

        private void PatientLastNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            string filteredText = new string(textBox.Text.Where(c => char.IsLetter(c) || c == ' ' || c == '-').ToArray());

            if (filteredText != textBox.Text)
            {
                textBox.Text = filteredText;
                textBox.SelectionStart = filteredText.Length;
            }
        }

        private void PatientFirstNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            string filteredText = new string(textBox.Text.Where(c => char.IsLetter(c) || c == ' ' || c == '-').ToArray());

            if (filteredText != textBox.Text)
            {
                textBox.Text = filteredText;
                textBox.SelectionStart = filteredText.Length;
            }
        }

        private void PatientPatronymicBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            string filteredText = new string(textBox.Text.Where(c => char.IsLetter(c) || c == ' ' || c == '-').ToArray());

            if (filteredText != textBox.Text)
            {
                textBox.Text = filteredText;
                textBox.SelectionStart = filteredText.Length;
            }
        }

        private void DoctorLastNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            string filteredText = new string(textBox.Text.Where(c => char.IsLetter(c) || c == ' ' || c == '-').ToArray());

            if (filteredText != textBox.Text)
            {
                textBox.Text = filteredText;
                textBox.SelectionStart = filteredText.Length;
            }
        }

        private void DoctorFirstNameBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            string filteredText = new string(textBox.Text.Where(c => char.IsLetter(c) || c == ' ' || c == '-').ToArray());

            if (filteredText != textBox.Text)
            {
                textBox.Text = filteredText;
                textBox.SelectionStart = filteredText.Length;
            }
        }

        private void DoctorPatronymicBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox textBox = (TextBox)sender;
            string filteredText = new string(textBox.Text.Where(c => char.IsLetter(c) || c == ' ' || c == '-').ToArray());

            if (filteredText != textBox.Text)
            {
                textBox.Text = filteredText;
                textBox.SelectionStart = filteredText.Length;
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

        private void ChangePictureBtn_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog myOpenFileDialog = new OpenFileDialog();
            if (myOpenFileDialog.ShowDialog() == true)
            {
                currentOperation.OperationImage = myOpenFileDialog.FileName;
                PhotoImage.Source = new BitmapImage(new Uri(myOpenFileDialog.FileName));
            }
        }

        private void ClientSave_Click(object sender, RoutedEventArgs e)
        {
            if (currentOperation.OperationID == 0)
            {
                HospitalEntities.GetContext().Operations.Add(currentOperation);
            }

            StringBuilder errors = new StringBuilder();
            if (string.IsNullOrWhiteSpace(currentOperation.PatientSurname))
                errors.AppendLine("Укажите фамилию пациента!");
            else
            {
                if (currentOperation.PatientSurname.Length > 50)
                    errors.AppendLine("Слишком длинная фамилия пациента!");
            }

            if (string.IsNullOrWhiteSpace(currentOperation.DoctorSurname))
                errors.AppendLine("Укажите фамилию доктора!");
            else
            {
                if (currentOperation.DoctorSurname.Length > 50)
                    errors.AppendLine("Слишком длинная фамилия доктора!");
            }


            if (string.IsNullOrWhiteSpace(currentOperation.PatientFirstName))
                errors.AppendLine("Укажите имя пациента!");
            else
            {
                if (currentOperation.PatientFirstName.Length > 50)
                    errors.AppendLine("Слишком длинное имя пациента!");
            }

            if (string.IsNullOrWhiteSpace(currentOperation.DoctorFirstName))
                errors.AppendLine("Укажите имя доктора!");
            else
            {
                if (currentOperation.DoctorFirstName.Length > 50)
                    errors.AppendLine("Слишком длинное имя доктора!");
            }


            if (string.IsNullOrWhiteSpace(currentOperation.PatientPatronymic))
                currentOperation.PatientPatronymic = null;
            else
            {
                if (currentOperation.PatientPatronymic.Length > 50)
                    errors.AppendLine("Слишком длинное отчество пациента!");
            }

            if (string.IsNullOrWhiteSpace(currentOperation.DoctorPatronymic))
                currentOperation.DoctorPatronymic = null;
            else
            {
                if (currentOperation.DoctorPatronymic.Length > 50)
                    errors.AppendLine("Слишком длинное отчество пациента!");
            }


            if (string.IsNullOrWhiteSpace(currentOperation.OperationDescription))
                errors.AppendLine("Укажите описание операции!");
            else
            {
                if (currentOperation.OperationDescription.Length > 60)
                    errors.AppendLine("Слишком длинное описание операции!");
            }


            //if (OperationDateDP.Text == "")
            //{
            //    errors.AppendLine("Укажите дату операции!");
            //}
            //if (errors.Length > 0)
            //{
            //    MessageBox.Show(errors.ToString());
            //    return;
            //}
            //currentOperation.OperationDate = Convert.ToDateTime(OperationDateDP.Text);


            if (OperationResultBox.SelectedIndex == 0)
            {
                currentOperation.OperationResult = "Успешно";
            }
            else
            {
                currentOperation.OperationResult = "Неуспешно";
            }


            List<Operations> allOperation = HospitalEntities.GetContext().Operations.ToList();
            allOperation = allOperation.Where(p => p.OperationDescription == currentOperation.OperationDescription && p.OperationDate == currentOperation.OperationDate 
            && p.PatientSurname == currentOperation.PatientSurname && p.PatientFirstName == currentOperation.PatientFirstName && p.PatientPatronymic == currentOperation.PatientPatronymic
            && p.DoctorSurname == currentOperation.DoctorSurname && p.DoctorFirstName == currentOperation.DoctorFirstName && p.DoctorPatronymic == currentOperation.DoctorPatronymic 
            && p.OperationResult == currentOperation.OperationResult).ToList();
            if (allOperation.Count == 0 || check == true)
            {
                if (check == false)
                {
                    currentOperation.OperationDate = DateTime.Now;
                }
                if (currentOperation.OperationID == 0)
                {
                    HospitalEntities.GetContext().Operations.Add(currentOperation);
                }
                try
                {
                    HospitalEntities.GetContext().SaveChanges();
                    MessageBox.Show("Информация о проведенной операции сохранена.");
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
