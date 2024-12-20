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
    
    public partial class MedicalHistory
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MedicalHistory()
        {
            this.TreatmentSheet = new HashSet<TreatmentSheet>();
        }
    
        public int HistoryID { get; set; }
        public int PatientID { get; set; }
        public int DoctorID { get; set; }
        public string Diagnosis { get; set; }
        public System.DateTime DateOfIllness { get; set; }
        public System.DateTime DateOfCure { get; set; }
        public string TreatmentType { get; set; }
        public int OperationID { get; set; }
        public string PatientSurname { get; set; }
        public string PatientFirstName { get; set; }
        public string PatientPatronymic { get; set; }
        public string DoctorSurname { get; set; }
        public string DoctorFirstName { get; set; }
        public string DoctorPatronymic { get; set; }
        public string currentPatient { get; set; }

        public virtual Doctors Doctors { get; set; }
        public virtual Operations Operations { get; set; }
        public virtual Patients Patients { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<TreatmentSheet> TreatmentSheet { get; set; }
    }
}
