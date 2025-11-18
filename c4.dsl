workspace "Enrollment system" "System for enrolling" {

    model {
        # software systems
        enrollmentSystem = softwareSystem "Enrolment System" "The main component for the..." {

            # User Interfaces
            enrollmentPage = container "Enrollment Page" "Provides web browser funcitonality for Student's self-enrollment." "HTML+JavaScript" "Web Front-End"
            courseManagementPage = container "Course Management Page" "Provides web browser funcitonality managing courses" "HTML+JavaScript" "Web Front-End"

            # Services
            studentService = container "Self-enrollment Service" "Provides logic for Student management" {
                studentServiceAPI = component "Student enrollment API" "" ""
            }
            courseService = container "Course Service" "Provides logic for Course management" {
                courseServiceAPI = component "Course enrollment API" "" ""
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
        student -> enrollmentPage "Enrolls into the course using the system"
        teacher -> courseManagementPage "Manages courses and enrollments"
        sdo -> courseManagementPage "Manages enrollments"

        # Database interactions
        studentService -> studentDB "Reads and stores Student data"
        courseService -> courseDB "Reads and stores Course data"
        studentService -> auditLogDB "Stores audit logs for Student changes"
        courseService -> auditLogDB "Stores autit logs for Course changes"

        # The rest of the relationships
        enrollmentPage -> studentService "Makes API calls to make Student's course self-management"
        courseManagementPage -> courseService "Makes API calls to edit course data, and manage enrollments on behalf of Students"

        studentService -> emailSystem "Make notification of events"
        courseService ->  emailSystem "Make notification of events"

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
