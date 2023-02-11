using System;
using System.Collections.Generic;

namespace IndividuellDbProject.Models
{
    public partial class Student
    {
        public Student()
        {
            Grades = new HashSet<Grade>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string SecurityNumber { get; set; } = null!;
        public string ContactInfo { get; set; } = null!;
        public int? ParentId { get; set; }
        public int? ClassId { get; set; }
        public DateTime? EnrollmentDate { get; set; }

        public virtual Class? Class { get; set; }
        public virtual Parent? Parent { get; set; }
        public virtual ICollection<Grade> Grades { get; set; }
    }
}
