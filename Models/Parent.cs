using System;
using System.Collections.Generic;

namespace IndividuellDbProject.Models
{
    public partial class Parent
    {
        public Parent()
        {
            Students = new HashSet<Student>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string ContactInfo { get; set; } = null!;

        public virtual ICollection<Student> Students { get; set; }
    }
}
