using IndividuellDbProject.Context;
namespace IndividuellDbProject
{
    public class Menu
    {
        public void MenuOptions()
        {
            bool activeMenu = true;

            using (var context = new IndividuellDbContext())
            {
                do
                {

                    Console.WriteLine("                    SCHOOL DATABASE                   ");
                    Console.WriteLine("------------------------------------------------------");
                    Console.WriteLine("|    [1.]  Employees                                | ");
                    Console.WriteLine("|    [2.]  Show information of students             | ");
                    Console.WriteLine("|    [3.]  Show active course                       | ");
                    Console.WriteLine("|    [4.]  Exit application                         | ");
                    Console.WriteLine("------------------------------------------------------");

                    int menuChoice = int.Parse(Console.ReadLine());


                    switch (menuChoice)
                    {
                        case 1:
                            Console.Clear();
                            //Kolla max antal department
                            var maxDepartmentId = context.Departments.Max(e => e.Id);

                            // Loopa genom alla department
                            for (int i = 1; i < maxDepartmentId; i++)
                            {
                                var departmentName = context.Departments
                                   .Where(d => d.Id == i)
                                   .FirstOrDefault();

                                var EmpName = context.Employees
                               .Where(e => e.DepartmentId == i)
                               .Select(e => e.Name)
                               .ToList();

                                //Räkna antal arbetare i den department
                                var employees = context.Employees.ToList();
                                int count = 0;

                                foreach (var employee in employees)
                                {
                                    if (employee.DepartmentId == i)
                                    {
                                        count++;
                                    }
                                }
                                Console.WriteLine("\n");
                                // Loopa department namn och loopa alla Employyes namn
                                if (departmentName != null)
                                {

                                    Console.WriteLine(departmentName.DepartmentName + ": " + count);

                                    foreach (var EmployeesName in EmpName)
                                    {
                                        Console.WriteLine(EmployeesName);
                                    }

                                }

                            }
                            Console.WriteLine("Enter to go back");
                            Console.ReadKey();
                            Console.Clear();
                            break;





                        case 2:
                            Console.Clear();
                            var students = from s in context.Students
                                           join c in context.Classes on s.ClassId equals c.Id
                                           join p in context.Parents on s.ParentId equals p.Id
                                           select new { s.Name, s.SecurityNumber, ClassName = c.Name, s.ContactInfo, ParentName = p.Name, s.EnrollmentDate };

                            foreach (var student in students)
                            {
                                Console.WriteLine("Student Name: " + student.Name);
                                Console.WriteLine("Security Number: " + student.SecurityNumber);
                                Console.WriteLine("Class: " + student.ClassName);
                                Console.WriteLine("Contact Info: " + student.ContactInfo);
                                Console.WriteLine("ParentName: " + student.ParentName);
                                Console.WriteLine("Enrollment Date: " + student.EnrollmentDate);
                                Console.WriteLine("------------------------------------------------");
                            }
                            Console.WriteLine("Enter to go back");
                            Console.ReadKey();
                            Console.Clear();
                            break;



                        case 3:
                            Console.Clear();
                            var courses = context.Courses.ToList();

                            Console.WriteLine("ACTIVE CORSES:");
                            foreach (var course in courses)
                            {
                                
                                if (course.ActiveCourse == true)
                                {
                                    Console.WriteLine(course.Name);
                                }
                            }

                            Console.WriteLine("\nINACTIVE CORSES:");
                            foreach (var course in courses)
                            {
                                
                                if (course.ActiveCourse == false)
                                {
                                    Console.WriteLine(course.Name);
                                }
                            }

                            Console.WriteLine("Enter to go back");
                            Console.ReadKey();
                            Console.Clear();
                            break;



                        case 4:
                            activeMenu = false;
                            break;


                    }

                } while (activeMenu);
            }
        }

    }
}
