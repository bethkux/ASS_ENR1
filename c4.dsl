workspace "Enrollment system" "System for enrolling" {

    model {
        # software systems
        enrollmentSystem = softwareSystem "Enrollment System" "The main component for the..." {

            # User Interfaces
            studentUI = container "Student User Interface" "Provides web browser functionality for Student's to manage profile and enrollments" "HTML+JavaScript" "Web Front-End"
            facultyUI = container "Employee User Interface" "Provides web browser functionality for faculty employees to manage courses" "HTML+JavaScript" "Web Front-End"

            # Services
            studentService = container "Student Service" "Provides logic for Student management" {
                studentServiceAPI = component "Student enrollment API" "API access to read and edit student info"
                studentReader = component "Student Reader" "Domain logic for reading student info"
                studentEditor = component "Student Editor" "Domain logic for editing student info"
                studentModel = component "Student Model" "Domain logic of a student"
                studentRepository = component "Student repository" "Persists student info in DB"
            }
            courseService = container "Course Service" "Provides logic for Course management" {
                courseServiceAPI = component "Course enrollment API" "" "API access to read and manage courses"
                courseReader = component "Course Reader" "Domain logic for reading courses"
                courseManager = component "Course Manager" "Domain logic for managing courses"
                courseModel = component "Course Model" "Domain logic of a course"
                courseRepository = component "Course repository" "Persists course info in DB"
            }
            enrollmentService = container "Enrollment Service" {
                enrollmentAPI = component "Enrollment API"
                studentEnrollmentReader = component "Enrollment Reader" "Provides functionality to read student enrollment data."
                studentEnrollmentModel = component "Enrollment Model" "Domain logic for student enrollment changes."
                studentEnrollmentRecorder = component "Enrollment Recorder" "Logic of recording changes in enrolling"
                studentEnrollmentRepository = component "Enrollment Repository" "Perists enrollment info in DB"
            }

            # Databases
            studentDB = container "Student Database" "Stores student data" "" "Database"
            courseDB = container "Course Database" "Stores course and enrollment data" "" "Database"
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
        enrollmentService -> auditLogDB "Stores audit logs of Enrollments"


        # Front-end page interactions
        studentUI -> enrollmentService "Makes API calls to make Student's course self-management"
        studentUI -> courseService "Makes API calls to view lists of courses"
        studentUI -> studentService "Makes API calls to view and modify student profile"
        facultyUI -> enrollmentService "Makes API calls to edit course data, and manage enrollments on behalf of Students"
        facultyUI -> courseService "Makes API calls to modify courses"

        # Enrollment service interactions
        studentUI -> enrollmentAPI  "Makes API calls to manage self-enrollments"
        facultyUI -> enrollmentAPI "Makes API calls to manage enrollments on behalf of Students"
        enrollmentService -> courseDB "Makes API calls to read and modify Enrollment info"
        enrollmentAPI -> studentEnrollmentReader "calls to read student enrollment data"
        enrollmentAPI -> studentEnrollmentRecorder "calls to write changes in students enrollment"
        studentEnrollmentRepository -> courseDB "Reads enrollment data"
        studentEnrollmentReader -> studentEnrollmentModel "Uses domain logic of"
        studentEnrollmentRecorder -> studentEnrollmentModel "Uses domain logic of"
        studentEnrollmentModel -> studentEnrollmentRepository "reads / writes enrollments"


        # Notification interactions
        studentService -> emailSystem "Make notification of events"
        courseService ->  emailSystem "Make notification of events"

        # SSO interactions
        courseService -> sso "Uses for authentication"
        studentService -> sso "Uses for authentication"
        
        # Relations
        studentUI -> studentServiceAPI "Makes API calls to view student info"
        studentServiceAPI -> studentReader "Calls to read student info"
        studentServiceAPI -> studentEditor "Calls to edit student info"
        studentReader -> studentModel "Uses domain logic of"
        studentEditor -> studentModel "Uses domain logic of"
        studentModel -> studentRepository  "Reads and writes student info"
        studentRepository -> studentDB "Reads student data from"
        
        facultyUI -> courseServiceAPI "Makes API calls to read and manage courses"
        facultyUI -> StudentService "Makes API calls to read student info"
        courseServiceAPI -> courseReader "Calls to read course info"
        courseServiceAPI -> courseManager "Calls to manage course"
        courseReader -> courseModel "Uses domain logic of"
        courseManager -> courseModel "Uses domain logic of"
        courseModel -> courseRepository  "Reads and writes course info"
        courseRepository -> courseDB "Persists course data in DB"
        
        deploymentEnvironment "Live - Enrollments" {
            deploymentNode "Student's web browser" "" "" {
                containerInstance studentUI
            }
            deploymentNode "Faculty employee's web browser" "" "" {
                containerInstance "facultyUI"
            }


            deploymentNode "Enrollments Server"Ubuntu 18.04 LTS"   {
                deploymentNode "Application server" "" "Oracle 19.1.0" {
                    containerInstance courseService
                    containerInstance studentService
                    containerInstance enrollmentService
                }
                deploymentNode "Relational DB server" "" "Oracle 19.1.0" {
                    containerInstance courseDB
                    containerInstance studentDB
                }
            }
        }
    }


    views {

        systemContext enrollmentSystem "enrollmentSystemContextDiagram" {
            include *
            autoLayout
        }

        container enrollmentSystem "enrollmentContainerDiagram" {
            include *
            autoLayout
        }

        component enrollmentService {
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
        
        deployment enrollmentSystem "Live - Enrollments" {
            include *
            autoLayout
        }

        theme default   
    }
}
