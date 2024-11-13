using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Animation;
using System.Windows;
using System.Windows.Navigation;

namespace Hospital
{
    public class OperationData
    {
        public static bool OperationDataValue(string OperationDescription, int DoctorID, DateTime OperationDate, int PatientID, int OperationResult)
        {
            bool isValid = true;

            // Проверка OperationDescription
            if (string.IsNullOrWhiteSpace(OperationDescription) || (string.IsNullOrEmpty(OperationDescription)))
            {
                isValid = false;
            }

            // Проверка длины OperationDescription
            if (OperationDescription.Length > 60)
            {
                isValid = false;
            }

            // Проверка PatientID
            if (PatientID < 0)
            {
                isValid = false;
            }

            // Проверка DoctorID
            if (DoctorID < 0)
            {
                isValid = false;
            }

            // Проверка OperationResult
            if (OperationResult != 0 && OperationResult != 1)
            {
                isValid = false;
            }

            // Проверка OperationDate
            if (OperationDate == DateTime.MinValue || OperationDate == default(DateTime))
            {
                isValid = false;
            }

            return isValid;
        }
    }
}
