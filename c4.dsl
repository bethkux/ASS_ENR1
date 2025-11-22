workspace "Enrollment system" "System for enrolling" {

    model {
        # software systems
        enrollmentSystem = softwareSystem "Enrollment System" "The main component for the..." {

            # User Interfaces
            studentUI = container "Student User Interface" "Provides web browser functionality for Student's to manage profile and enrollments" "HTML+JavaScript" "Web Front-End"
            facultyUI = container "Employee User Interface" "Provides web browser functionality for faculty employees to manage courses" "HTML+JavaScript" "Web Front-End"

            # Services
            userProfileService = container "User Profile Service" "Provides logic for user profile management" {
                userProfileServiceAPI = component "User Profile Service API" "API access to read and edit user profile"
                userProfileEditor = component "User Profile Editor" "Domain logic for editing user profile"
                userProfileProvider = component "User Profile Provider" "Domain logic for retrieving user profile"
                userProfile = component "User Profile" "Domain logic of a user's information"
                userProfileRepository = component "User Profile Repository" "Persists user info in DB"
            }
            courseService = container "Course Service" "Provides logic for management of enrollments and courses" {
                courseServiceAPI = component "Course enrollment API" "" "API access to read and manage courses"
                courseProvider = component "Course Provider" "Domain logic for reading courses"
                courseManager = component "Course Manager" "Domain logic for managing courses"
                courseModel = component "Course Model" "Domain logic of a course"
                courseRepository = component "Course repository" "Persists course info in DB"
            }
            auditLogService = container "Audit Log Service" "Provides logic for audit-relevant logs" {
                auditLogAPI = component "Audit Log API" "API access for reading and recording audit logs"
                auditLogConsumer = component "Audit Log Consumer" "Ingestion point incoming audit logs"
                auditLogProvider = component "Audit Log Provider" "Provides log records"
                auditNotifier = component "Audit Notifier" "Creates notification messages of notable logged audit events"
                auditLogRepository = component "Audit Log Repository" "Persists audit logs in DB"
            }

            # Databases
            userProfileDB = container "User Profile Database" " User profile data" "" "Database"
            courseDB = container "Course Database" "Course and enrollment data" "" "Database"
            auditDB = container "Audit Log Database" "Audit log records" "" "Database"
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
        userProfileService -> userProfileDB "Stores user profile data"
        courseService -> courseDB "Stores course data"
        auditLogService -> auditDB "Stores audit logs"

        # Audit
        facultyUI -> auditLogService "Makes API calls to read audit data"
        userProfileService -> auditLogService "Sends audit logs"
        courseService -> auditLogService "Sends audit logs"

        # Front-end page interactions
        studentUI -> courseService "Makes API calls to view courses"
        studentUI -> userProfileService "Makes API calls to view and modify student profile"
        facultyUI -> courseService "Makes API calls to modify courses"

        # Audit log and notification interactions
        auditLogService -> emailSystem "Sends notifications"

        # SSO interactions
        courseService -> sso "Uses for authentication"
        userProfileService -> sso "Uses for authentication"
        auditLogService -> sso "Uses for authentication"
        
        # User Info component interactions
        studentUI -> userProfileServiceAPI "Makes API calls to view user profiles"
        facultyUI -> userProfileServiceAPI "Makes API calls to view user profiles"
        userProfileServiceAPI -> userProfileProvider "Calls to read user profile"
        userProfileServiceAPI -> userProfileEditor "Calls to edit user profile"
        userProfileServiceAPI -> sso "Uses to authenticate provided tokens"
        userProfileProvider -> userProfile "Uses domain logic of"
        userProfileEditor -> userProfile "Uses domain logic of"
        userProfile -> userProfileRepository  "Reads and writes student info"
        userProfileRepository -> userProfileDB "Reads student data from"
        
        # Course component interactions
        studentUI -> courseServiceAPI "Makes API calls to read and enroll courses"
        facultyUI -> courseServiceAPI "Makes API calls to read and manage courses"
        courseServiceAPI -> courseProvider "Calls to read course info"
        courseServiceAPI -> courseManager "Calls to manage course"
        courseServiceAPI -> sso "Uses to authenticate provided tokens"
        courseProvider -> courseModel "Uses domain logic of"
        courseManager -> courseModel "Uses domain logic of"
        courseModel -> courseRepository  "Reads and writes course info"
        courseRepository -> courseDB "Persists course data in DB"

        # Audit component interactions
        courseServiceAPI -> auditLogAPI "Makes API calls to log actions"
        userProfileServiceAPI -> auditLogAPI "Makes API calls to log actions"
        facultyUI -> auditLogAPI "Makes API calls to read logs"
        auditLogAPI -> auditLogProvider "Makes API calls to read log records from"
        auditLogAPI -> auditLogConsumer "Makes API calls  to send logs for ingestion"
        auditLogAPI -> sso "Uses to authenticate provided tokens"
        auditLogConsumer -> auditLogRepository "Stores audit logs"
        auditLogConsumer -> auditNotifier "Sends log data to create audit notification"
        auditNotifier -> emailSystem "Calls to send notification via email"
        auditLogProvider -> auditLogRepository "Reads audit logs"
        auditLogRepository -> auditDB "Persists logs in DB"
        
        deploymentEnvironment "Live - Enrollments" {
            deploymentNode "Student's web browser"{
                containerInstance studentUI
            }
            deploymentNode "Faculty employee's web browser" {
                containerInstance facultyUI
            }
            
            deploymentNode "Enrollment Server" "" "UwUntu 22.10 LTS" {
                deploymentNode "Application Server" {
                    containerInstance userProfileService
                    containerInstance courseService
                    containerInstance auditLogService
                }
                deploymentNode "Relational DB Server" "" "Oracle 19.1.0"{
                    containerInstance userProfileDB
                    containerInstance courseDB
                    containerInstance auditDB
                }
            }
        }
        
        deploymentEnvironment "Development - Enrollments" {
    
            deploymentNode "Enrollment Server" "" "UwUntu 22.10 LTS" {
                
                deploymentNode "Developer's browser" "" "Chrome, Internet explorer" {
                    containerInstance studentUI
                    containerInstance facultyUI
                }
            
                deploymentNode "Application Server" {
                    containerInstance userProfileService
                    containerInstance courseService
                    containerInstance auditLogService
                }
                
                deploymentNode "Relational DB Server" "" "Oracle 19.1.0"{
                    containerInstance userProfileDB
                    containerInstance courseDB
                    containerInstance auditDB
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

        component userProfileService {
            include *
            autoLayout
        }

        component courseService {
            include *
            autoLayout
        }

        component auditLogService {
            include *
            autoLayout
        }
        
        //dynamic enrollmentSystem "studentEnrollment" "Student's enrollment self-management" {
        //    student -> studentUI
        //    studentUI -> enrollmentService      "Request enrollment into the course"
        //    enrollmentService -> courseService 
        //    courseService -> courseDB           "Fetch course data from database"
        //    enrollmentService -> studentService
        //    studentService -> studentDB         "Update course data to student profile"
        //    courseService -> courseDB           "Write updated course data to database"
        //    courseService -> emailSystem        "Request email system to notify"
        //autoLayout
        //}

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
        
        deployment enrollmentSystem "Development - Enrollments" {
            include *
            autoLayout
        }

        theme default   
    }
}
