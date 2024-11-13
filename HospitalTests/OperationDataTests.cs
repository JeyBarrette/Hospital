using Microsoft.VisualStudio.TestTools.UnitTesting;
using Hospital;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hospital.Tests
{
    [TestClass()]
    public class OperationDataTests
    {
        [TestMethod()]
        public void OperationDataValue_ValidData_ReturnsTrue()
        {
            string OperationDescription = "Новая операция";
            int DoctorID = 2;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 3;
            int OperationResult = 0;
            bool expected = true;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_EmptyOperationDescription_ReturnsFalse()
        {
            string OperationDescription = "";
            int DoctorID = 2;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 3;
            int OperationResult = 0;
            bool expected = false;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_WhiteSpacesOperationDescription_ReturnsFalse()
        {
            string OperationDescription = "     ";
            int DoctorID = 2;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 3;
            int OperationResult = 0;
            bool expected = false;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_UpperBoundOperationDescription_ReturnsFalse()
        {
            string OperationDescription = "ЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗ";
            int DoctorID = 3;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 4;
            int OperationResult = 1;
            bool expected = false;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_UpperBoundOperationDescription_ReturnsTrue()
        {
            string OperationDescription = "ЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕЗАПОЛНЕНИЕ";
            int DoctorID = 3;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 4;
            int OperationResult = 1;
            bool expected = true;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_NegativePatientID_ReturnsFalse()
        {
            string OperationDescription = "Тест операция";
            int DoctorID = 6;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = -1;
            int OperationResult = 0;
            bool expected = false;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_NegativeDoctorID_ReturnsFalse()
        {
            string OperationDescription = "Тест Тест";
            int DoctorID = -1;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 5;
            int OperationResult = 0;
            bool expected = false;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_InvalidOperationResult_ReturnsFalse()
        {
            string OperationDescription = "ТестыТестов";
            int DoctorID = 7;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 3;
            int OperationResult = 10;
            bool expected = false;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_ValidDate_ReturnsTrue()
        {
            string OperationDescription = "ТестыТестовТестов";
            int DoctorID = 2;
            DateTime OperationDate = new DateTime(2024, 11, 14);
            int PatientID = 2;
            int OperationResult = 0;
            bool expected = true;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void OperationDataValue_InvalidDate_ReturnsFalse()
        {
            string OperationDescription = "Тестыыыы";
            int DoctorID = 3;
            DateTime OperationDate = DateTime.MinValue;
            int PatientID = 1;
            int OperationResult = 1;
            bool expected = false;

            OperationData operationData = new OperationData();
            bool actual = OperationData.OperationDataValue(OperationDescription, DoctorID, OperationDate, PatientID, OperationResult);

            Assert.AreEqual(expected, actual);
        }
    }
}