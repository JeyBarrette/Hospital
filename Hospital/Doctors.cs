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
    
    public partial class Doctors
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Doctors()
        {
            this.MedicalHistory = new HashSet<MedicalHistory>();
            this.Operations = new HashSet<Operations>();
        }
    
        public int DoctorID { get; set; }
        public string DoctorSurname { get; set; }
        public string DoctorFirstName { get; set; }
        public string DoctorPatronymic { get; set; }
        public System.DateTime EmploymentDate { get; set; }
        public string Post { get; set; }
        public string ScientificTitle { get; set; }
        public string Adress { get; set; }
        public Nullable<int> WorkExperience { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MedicalHistory> MedicalHistory { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Operations> Operations { get; set; }
    }
}
