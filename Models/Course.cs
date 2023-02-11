using System;
using System.Collections.Generic;

namespace IndividuellDbProject.Models
{
    public partial class Course
    {
        public Course()
        {
            Grades = new HashSet<Grade>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public bool? ActiveCourse { get; set; }

        public virtual ICollection<Grade> Grades { get; set; }
    }
}
