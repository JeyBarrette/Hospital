//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Hospital
{
    using System;
    using System.Collections.Generic;
    
    public partial class Operations
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Operations()
        {
            this.MedicalHistory = new HashSet<MedicalHistory>();
        }
    
        public int OperationID { get; set; }
        public string OperationDescription { get; set; }
        public int DoctorID { get; set; }
        public System.DateTime OperationDate { get; set; }
        public int PatientID { get; set; }
        public string OperationResult { get; set; }
        public string OperationImage { get; set; }
        public string Surname { get; set; }
        public string FirstName { get; set; }
        public string Patronymic { get; set; }

        public string DoctorFIO
        {
            get
            {
                return Doctors.Surname + " " + Doctors.FirstName + " " + Doctors.Patronymic;
            }
        }

        public string PatientFIO
        {
            get
            {
                return Patients.Surname + " " + Patients.FirstName + " " + Patients.Patronymic;
            }
        }

        public virtual Doctors Doctors { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MedicalHistory> MedicalHistory { get; set; }
        public virtual Patients Patients { get; set; }
    }
}
