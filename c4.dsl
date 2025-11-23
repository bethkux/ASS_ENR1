workspace "Enrollment system" "System for enrolling" {

    model {
        # software systems
        enrollmentSystem = softwareSystem "Enrollment System" "Manages student enrollments, profiles, and courses, while enabling faculty and staff to oversee enrollments and audit logs." {

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
        student = person "Student" "Uses the system to enroll into the courses they selected."
        teacher = person "Teacher" "Manages the courses the students are enrolling to."
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
        facultyUI -> userProfileService "Makes API calls to view student profiles"

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
        
        dynamic enrollmentSystem "studentEnrollment" "Student's enrollment self-management" {
            student -> studentUI "Navigate to student's UI"
            studentUI -> courseService "Request all course info and tickets"
            courseService -> courseDB "Fetch all course data from database"
            studentUI -> courseService "Request enrollment into the course"
            courseService -> courseDB "Write and fetch updated course data to database"
            courseService -> auditLogService "Log update"
            auditLogService -> auditDB "Saves the audit log to DB"
            auditLogService -> emailSystem "Request email system to send notification"
        autoLayout
        }
        
        dynamic enrollmentSystem "studentProfileUpdate" "Student profile update" {
            student -> studentUI "Navigate to student's profile page"
            studentUI -> userProfileService "Request student's info"
            userProfileService -> userProfileDB "Fetch student's profile info"
            studentUI -> userProfileService "Student modifies profile"
            userProfileService -> userProfileDB "Write and fetch profile info"
            userProfileService -> auditLogService "Log update"
            auditLogService -> auditDB "Saves the audit log to DB"
            auditLogService -> emailSystem "Request email system to send notification"
        autoLayout
        }
        
        dynamic enrollmentSystem "teacherLectureManagement" "Teacher’s lectures management" {
            teacher -> facultyUI "Navigate to teacher's UI"
            facultyUI -> courseService "Request teacher's courses"
            courseService -> courseDB "Fetch teacher's courses"
            facultyUI -> courseService "Teacher changes course info"
            courseService -> courseDB "Write and fetch course info"
            courseService -> auditLogService "Log update"
            auditLogService -> auditDB "Saves the audit log to DB"
            auditLogService -> emailSystem "Request email system to send notification"
        autoLayout
        }
        
        dynamic enrollmentSystem "sdoLockNotification" "Enrollment Lock and Notifications" {
            sdo -> facultyUI "Navigate to course page"
            facultyUI -> courseService "Request settings"
            courseService -> courseDB "Fetch settings"
            facultyUI -> courseService "Update settings"
            courseService -> courseDB "Write and fetch new settings"
            courseService -> auditLogService "Log update"
            auditLogService -> auditDB "Saves the audit log to DB"
            auditLogService -> emailSystem "Request email system to send notification"
        autoLayout
        }
        
        dynamic enrollmentSystem "exportStudentData" "Export of Student Personal Data" {
            sdo -> facultyUI 
            facultyUI -> userProfileService  "Request all user profiles"
            userProfileService -> userProfileDB "Fetch all user profiles"
            facultyUI -> userProfileService "Request to export selected user profiles"
            userProfileService -> auditLogService "Log update"
            auditLogService -> auditDB "Saves the audit log to DB"
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
        
        deployment enrollmentSystem "Development - Enrollments" {
            include *
            autoLayout
        }

        theme default   
    }
}
