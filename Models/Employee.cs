using System;
using System.Collections.Generic;

namespace IndividuellDbProject.Models
{
    public partial class Employee
    {
        public Employee()
        {
            Grades = new HashSet<Grade>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public int? DepartmentId { get; set; }
        public DateTime? StartDate { get; set; }
        public decimal? Salary { get; set; }

        public virtual Department? Department { get; set; }
        public virtual ICollection<Grade> Grades { get; set; }
    }
}
