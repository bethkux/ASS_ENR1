workspace "Enrollment system" "System for enrolling" {

    model {
        # software systems
        enrollmentSystem = softwareSystem "Enrolment System" "The main component for the..." {

            #Enrollment system UI
            EnrollmentUI = container "Enrollment page" "UI for the enrollment page"

            # Enrollment system providers
            StudentInfoProvider = container "Student Info provider" "Provides access to student info" {
                component StudentValidator "Checks student profile field validity"
                component StudentDataProcessor "Compiles and anonymizes profile data"
                component Sign-on handler "Interacts with SSO"
            }
            CourseInfoProvider = container "Course Info provider" "Provides access to courses"
            EmailProvider = container "Email Provider" "Provides access to email"

            # Enrollment system repositories
            StudentInfoRepository = container "Student info repository" "Persists user info in the database"
            CourseRepository = container "Course repository" "Persists course data in the database"

            AuditLogger = container "Audit logger" "Persists audit logs the database"

            # Enrollment system database
            StudentInfoDB = container "Student info database" "Store student info data in the database" "" "Database"
            CourseDB = container "Course database" "Store course data in the database" "" "Database"
            auditLogDB = container "Audit Log Database" "Stores audit log records in the database." "" "Database"

        }

        # Other systems
        emailSystem = softwareSystem "Email System" "" "Existing System"
        sso = softwareSystem "SSO" "Allow user log in" "Existing System"

        # actors
        student = person "Student" "Student is the one who uses the system to enroll into the courses they selected."
        teacher = person "Teacher" "The one who manages the courses the students are enrolling to."
        sdo = person "Student department officer" "Manages and informs the students about changes and helps them with their problems."

        # relationships between actors and Enrollment system
        student -> EnrollmentUI "Enrolls into the course using the system"
        teacher -> EnrollmentUI "Manages the courses"
        sdo -> EnrollmentUI "Manages student affairs"

        # repository-DB relationships
        StudentInfoRepository -> StudentInfoDB ""
        CourseRepository -> CourseDB ""
        AuditLogger -> AuditLogDB ""

        StudentInfoProvider -> StudentInfoRepository ""
        CourseInfoProvider -> CourseRepository ""


        # The rest of the relationships
        EnrollmentUI -> StudentInfoProvider "Navigate to Student info page"
        EnrollmentUI -> CourseInfoProvider "Navigate to Course page"
        EnrollmentUI -> EmailProvider "Navigate to Email page"

        StudentInfoProvider -> EmailProvider "Notify"
        CourseInfoProvider ->  EmailProvider "Notify"
        EmailProvider -> emailSystem "Reads/sends emails"

        EmailProvider -> sso "Authenticates for email"
        CourseInfoProvider -> sso "Authenticates for course access"
        StudentInfoProvider -> sso "Autheticates for profile access"

        StudentInfoProvider -> AuditLogger "Logs student profile events"
        CourseInfoProvider -> AuditLogger  "Logs course info events"
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

        component StudentInfoProvider {
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
        }

        theme default
    }
}
