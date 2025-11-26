workspace "Enrollment system" "System for enrolling" {

    !docs docs
    model {

        # software systems
        enrollmentSystem = softwareSystem "Enrollment System" "Manages student enrollments, profiles, and courses, while enabling faculty and staff to oversee enrollments and audit logs." {

            # User Interfaces
            studentUI = container "Student User Interface" "Provides web browser functionality for Student's to manage profile and enrollments" "HTML+JavaScript" "Web Front-End" {
                studentProfileUI = component "Student Profile UI" "Provides UI for viewing profiles and managing student's own profile"
                studentCourseUI = component "Student Course UI" "Provides UI for listing courses and managing student's own enrollments to them"
                studentAuth = component "Student Authenticator" "Prompts to sign-on"
            }
            facultyUI = container "Employee User Interface" "Provides web browser functionality for faculty employees to manage courses" "HTML+JavaScript" "Web Front-End" {
                facultyProfileUI = component "Faculty Profile UI" "Provides UI for listing profiles across faculty"
                facultyCourseUI = component "Faculty Course UI" "Provides UI for listing and managing courses"
                auditDashboardUI = component "Audit Log Dashboard" "Provides UI for viewing audit logs"
                facultyAuth = component "Faculty Employee Authenticator" "Prompts to sign-on"
            }

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
        emailSystem = softwareSystem "Email System" "Notifies users of the system of changes." "Existing System"
        sso = softwareSystem "SSO" "Allows user to log in." "Existing System"

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
        auditDashboardUI -> auditLogAPI "Makes API calls to read audit data"
        userProfileServiceAPI -> auditLogAPI "Sends audit logs"
        courseServiceAPI -> auditLogAPI "Sends audit logs"

        # Front-end page interactions
        studentProfileUI -> userProfileServiceAPI "Makes API calls to view and modify student profile"
        facultyCourseUI -> courseServiceAPI "Makes API calls to read and modify courses"
        facultyProfileUI -> userProfileServiceAPI "Makes API calls to view student profiles"

        # Audit log and notification interactions
        auditLogService -> emailSystem "Sends notifications"

        # SSO interactions
        studentAuth -> sso "Requests authentication tokens"
        facultyAuth -> sso "Requests authentication tokens"
        courseService -> sso "Uses for authentication"
        userProfileService -> sso "Uses for authentication"
        auditLogService -> sso "Uses for authentication"

        # User Info component interactions
        studentProfileUI -> userProfileServiceAPI "Makes API calls to view user profiles"
        facultyProfileUI -> userProfileServiceAPI "Makes API calls to view user profiles"
        userProfileServiceAPI -> userProfileProvider "Calls to read user profile"
        userProfileServiceAPI -> userProfileEditor "Calls to edit user profile"
        userProfileServiceAPI -> sso "Uses to authenticate provided tokens"
        userProfileProvider -> userProfile "Uses domain logic of"
        userProfileEditor -> userProfile "Uses domain logic of"
        userProfile -> userProfileRepository  "Reads and writes student info"
        userProfileRepository -> userProfileDB "Reads student data from"

        # Course component interactions
        studentCourseUI -> courseServiceAPI "Makes API calls to read and enroll courses"
        facultyCourseUI -> courseServiceAPI "Makes API calls to read and manage courses"
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
        auditLogAPI -> auditLogProvider "Calls to read log records from"
        auditLogAPI -> auditLogConsumer "Calls to send incoming logs for ingestion"
        auditLogAPI -> sso "Uses to authenticate provided tokens"
        auditLogConsumer -> auditLogRepository "Stores audit logs"
        auditLogConsumer -> auditNotifier "Sends log data to create audit notification"
        auditNotifier -> emailSystem "Calls to send notification via email"
        auditLogProvider -> auditLogRepository "Reads audit logs"
        auditLogRepository -> auditDB "Persists logs in DB"

        deploymentEnvironment "Production - Enrollments" {
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

        deploymentEnvironment "Production (distributed) - Enrollments" {
            deploymentNode "Student's web browser"{
                containerInstance studentUI
            }
            deploymentNode "Faculty employee's web browser" {
                containerInstance facultyUI
            }

            deploymentNode "User Profile Server" "" "UwUntu 22.10 LTS" {
                deploymentNode "Application Server" {
                    containerInstance userProfileService
                }
                deploymentNode "Relational DB Server" "" "Oracle 19.1.0"{
                    containerInstance userProfileDB
                }
            }

            deploymentNode "Course Server" "" "UwUntu 22.10 LTS" {
                deploymentNode "Application Server" {
                    containerInstance courseService
                }
                deploymentNode "Relational DB Server" "" "Oracle 19.1.0"{
                    containerInstance courseDB
                }
            }

            deploymentNode "Audit Log Server" "" "UwUntu 22.10 LTS" {
                deploymentNode "Application Server" {
                    containerInstance auditLogService
                }
                deploymentNode "Relational DB Server" "" "Oracle 19.1.0"{
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
            exclude sso
            exclude emailSystem
            autoLayout
        }

        component userProfileService "userProfileServiceComponentDiagram" {
            include *
            exclude "studentUI -> sso"
            exclude "facultyUI -> sso"
            exclude "auditLogService -> sso"
            exclude "facultyUI -> auditLogService"
            autoLayout
        }

        component courseService "courseServiceComponentDiagram" {
            include *
            exclude "studentUI -> sso"
            exclude "facultyUI -> sso"
            exclude "auditLogService -> sso"
            exclude "facultyUI -> auditLogService"
            autoLayout
        }

        component auditLogService "auditLogServiceComponentDiagram" {
            include *
            exclude "studentUI -> sso"
            exclude "facultyUI -> sso"
            exclude "facultyUI -> userProfileService"
            exclude "facultyUI -> courseService"
            exclude "auditLogService -> sso"
            exclude "userProfileService -> sso"
            exclude "CourseService -> sso"
            autoLayout
        }

        component studentUI "studentUIComponentDiagram" {
            include *
            exclude "userProfileService -> sso"
            exclude "courseService -> sso"
            autoLayout
        }

        component facultyUI "facultyUIComponentDiagram" {
            include *
            autoLayout
            exclude "userProfileService -> sso"
            exclude "courseService -> sso"
            exclude "userProfileService -> auditLogService"
            exclude "courseService -> auditLogService"
            exclude "auditLogService -> sso"
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

        deployment enrollmentSystem "Production - Enrollments" {
            include *
            autoLayout
        }

        deployment enrollmentSystem "Production (distributed) - Enrollments" {
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
