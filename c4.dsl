workspace "Enrollment system" "System for enrolling" {

    model {
        # software systems
        enrollmentSystem = softwareSystem "Enrollment System" "The main component for the..." {

            # User Interfaces
            studentUI = container "Student User Interface" "Provides web browser functionality for Student's to manage profile and enrollments" "HTML+JavaScript" "Web Front-End"
            facultyUI = container "Employee User Interface" "Provides web browser functionality for faculty employees to manage courses" "HTML+JavaScript" "Web Front-End"

            # Services
            studentService = container "Student Service" "Provides logic for Student management" {
                studentServiceAPI = component "Student enrollment API" "" ""
                studentRepository = component "Student repository"
            }
            courseService = container "Course Service" "Provides logic for Course management" {
                courseServiceAPI = component "Course enrollment API" "" ""
                courseRepository = component "Course repository"
            }
            enrollmentService = container "Enrollment Service" {
                enrollmentAPI = component "Enrollment API"
            }

            # Databases
            studentDB = container "Student info database" "Stores student info data" "" "Database"
            courseDB = container "Course database" "Stores course data" "" "Database"
            auditLogDB = container "Audit Log Database" "Stores audit log records" "" "Database"
        }

        # Other systems
        emailSystem = softwareSystem "Email System" "" "Existing System"
        sso = softwareSystem "SSO" "Allow user log in" "Existing System"

        # actors
        student = person "Student" "Student is the one who uses the system to enroll into the courses they selected."
        teacher = person "Teacher" "The one who manages the courses the students are enrolling to."
        sdo = person "Student department officer" "Manages and informs the students about changes and helps them with their problems."

        # relationships between actors and Enrollment system
        student -> studentUI "Enrolls into the course using the system"
        teacher -> facultyUI  "Manages courses and enrollments"
        sdo -> facultyUI  "Manages enrollments"

        # Database interactions
        studentService -> studentDB "Reads and stores Student data"
        courseService -> courseDB "Reads and stores Course data"
        studentService -> auditLogDB "Stores audit logs of Student changes"
        courseService -> auditLogDB "Stores autit logs of Course changes"

        # Front-end page interactions
        studentUI -> enrollmentService "Makes API calls to make Student's course self-management"
        studentUI -> courseService "Makes API calls to view lists of courses"
        studentUI -> studentService "Makes API calls to view and modify student profile"
        facultyUI -> enrollmentService "Makes API calls to edit course data, and manage enrollments on behalf of Students"
        facultyUI -> courseService "Makes API calls to modify courses"

        # Enrollment service interactions
        enrollmentService -> studentService "Makes API calls to read and modify Student info"
        enrollmentService -> courseService "Makes API calls to read and modify Course info"

        # Notification interactions
        studentService -> emailSystem "Make notification of events"
        courseService ->  emailSystem "Make notification of events"

        # SSO interactions
        courseService -> sso "Uses for authentication"
        studentService -> sso "Uses for authentication"
    }

    views {

        systemContext enrollmentSystem "enrollmentSystemContextDiagram" {
            include *
            autoLayout
        }

        container enrollmentSystem "enrolmentContainerDiagram" {
            include *
            autoLayout
        }

        component studentService {
            include *
            autoLayout
        }

        component courseService {
            include *
            autoLayout
        }

        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element Container {
                width 300
                height 200
            }
            element "Database"  {
                shape Cylinder
            }
            element "Web Front-End"  {
                shape WebBrowser
            }
        }

        theme default
    
    }
}
