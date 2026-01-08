workspace "Scheduling Software System Workspace" "This workspace documents the architecture of the Scheduling System which facilitates course scheduling and its management." {
    model {
        # Users
        teacher = person "Teacher" "Registers and updates courses, submits scheduling preferences, views personal schedules, and receives notifications about conflicts."
        committeeMember = person "Timetable Committee Member" "Schedules courses, resolves conflicts, approves courses, and manages the overall timetable."
        student = person "Student" "Views personal, course, room, or program schedules and receives notifications about schedule changes."
        manager = person "Manager" "Reviews statistics, teacher workloads, room utilization, and historical schedule data to support planning and decision-making."

        # External systems
        enrollmentSystem = softwareSystem "Enrollment System" "Registers students for courses and manages the enrollment process." "External"
        emailSystem = softwareSystem "Email System" "Sends notifications to users." "External"
        authService = softwareSystem "Auth Service" "Validates user credentials, issues tokens and provides authorization checks." "External"
        scheduler = softwareSystem "Scheduling System" "Supports course registration, scheduling, conflict detection, schedule viewing, and reporting." {
            # Databases
            courseDB = container "Course Database" "Stores courses, teacher assignments, and registration data." "" "Database"
            scheduleDB = container "Schedule Database" "Holds finalized schedules, timeslots, and conflict metadata." "" "Database"
            statisticsDB = container "Statistics Database" "Contains aggregated and historical schedule statistics." "" "Database"

            # Front-end containers
            managementApp = container "Management Web Application" "Allows teachers and committee members to manage courses, schedules, and conflicts." "" "Web" {
                regUI = component "Course Registration UI" "UI for teachers to register or reuse courses and submit them to the committee."
                schedulingUI = component "Scheduling UI" "UI used by committee members to schedule courses, assign rooms/teachers and resolve collisions."
                collisionWidget = component "Collision Highlight Widget" "Frontend widget that highlights conflicts and suggests alternatives."
                regController = component "Registration Controller" "API endpoint used by regUI to submit and update course data. (server-side app)"
                schedulingController = component "Scheduling Controller" "API endpoint used by schedulingUI to request scheduling operations and apply decisions. (server-side app)"
                candidateFilterer = component "Candidate Filterer" "Filters candidate teachers/rooms/timeslots and performs client-side validation rules to reduce backend load; provides suggestions and reusable templates to the UI."
                authWidget = component "Auth Widget" "Login/identity UI element; prompts user to sign in when needed"
            }

            viewingApp = container "Viewing Web Application" "Provides students, teachers, committee members, and managers with schedule and statistics views." "" "Web"

            # Backend services
            courseService = container "Course Service" "Stores and manages course information, teacher assignments, and registration metadata." "" "Service"
            schedulingService = container "Scheduling Service" "Calculates schedules, assigns teachers, rooms, and timeslots." "" "Service"
            notificationService = container "Notification Service" "Delivers emails to users about schedule updates, registrations, and conflicts." "" "Service"
            scheduleViewerService = container "Schedule Viewer Service" "Provides schedule data filtered by user, room, course, or program for UI display." "" "Service"
            statisticsService = container "Statistics Service" "Generates reports on room usage, teacher workloads, historical schedules, etc." "" "Service"
            collisionService = container "Collision Service" "Detects scheduling conflicts and provides alerts to affected users." "" "Service" {

                conflictController = component "Conflict Controller" "API endpoint providing conflict reports and resolution actions."
                conflictDetector = component "Conflict Detector" "Checks schedules for overlapping times or room/teacher conflicts."
                conflictRepository = component "Conflict Repository" "Persists conflicts and their resolution statuses."
                conflictNotifier = component "Conflict Notifier" "Publishes in-app conflict alerts for UI; optionally can trigger email notifications (disabled by default)."

            }
        }
        # Auth service relationships
        viewingApp -> authService "Obtains tokens / redirects user to login"
        managementApp -> authService "Validates user credentials and authorizations"
        courseService -> authService "Validates user/service tokens and checks authorizations"
        schedulingService -> authService "Validates user/service tokens and checks authorizations"
        collisionService -> authService "Validates user/service tokens and checks authorizations"
        scheduleViewerService -> authService "Validates user/service tokens and checks authorizations"
        notificationService -> authService "Validates user/service tokens and checks authorizations"
        statisticsService -> authService "Validates user/service tokens and checks authorizations"

        # User interactions
        teacher -> managementApp "Registers courses, submits preferences, and reviews scheduling conflicts"
        committeeMember -> managementApp "Schedules courses, resolves conflicts, and approves timetable submissions"
        teacher -> viewingApp "Views teaching schedules and receives notifications of conflicts"
        committeeMember -> viewingApp "Reviews overall timetable and conflict reports"
        student -> viewingApp "Checks personal course schedule, program schedule, and room availability"
        manager -> viewingApp "Analyzes statistics on teacher workload, room usage, and historical schedules"

        # Management App to backend services
        managementApp -> courseService "Updates and queries course and teacher assignment information"
        managementApp -> schedulingService "Requests scheduling computations for courses and room allocations"
        managementApp -> collisionService "Validates proposed schedules and identifies conflicts"
        
        # Viewing App to backend services
        viewingApp -> scheduleViewerService "Retrieves filtered schedules for display"
        viewingApp -> statisticsService "Fetches historical statistics for reporting and analysis"

        # Service relationships
        courseService -> courseDB "Stores courses, teacher assignments, and registration data"
        schedulingService -> scheduleDB "Reads schedules for computation and stores finalized allocations"
        schedulingService -> courseDB "Fetches course metadata needed for scheduling calculations"
        schedulingService -> collisionService "Checks proposed schedules for conflicts"
        collisionService -> scheduleDB "Analyzes existing schedules to detect conflicts"
        collisionService -> courseDB "References course and teacher data to validate conflicts"
        collisionService -> notificationService "Alerts affected users about detected conflicts"
        scheduleViewerService -> scheduleDB "Reads finalized schedules for user queries"
        statisticsService -> statisticsDB "Stores and retrieves aggregated statistical data"
        statisticsService -> scheduleDB "Reads historical schedule information to compute metrics"
        statisticsService -> courseDB "References course metadata for historical context"
        notificationService -> emailSystem "Delivers scheduling notifications to users"
        scheduler -> enrollmentSystem "Fetches enrollment data if needed, e.g. for statistics."
        
        # component relationships

        # CollisionService component relationships
        conflictController -> conflictDetector "Detects conflicts for new/edited schedules"
        conflictDetector -> conflictRepository "Stores detected conflicts"
        conflictRepository -> scheduleDB "Reads and writes conflict data"
        conflictNotifier -> scheduleViewerService "Publishes in-app conflict alerts for UI"
        conflictController -> AuthService "Validates user/service tokens and checks authorizations"

        # ManagementApp component relationships
        regUI -> regController "Submits course registration"
        regUI -> candidateFilterer "Performs client-side validation and candidate filtering"
        candidateFilterer -> regController "Sends validated data and candidate selections to registration endpoint"
        regController -> courseService "Creates/updates course data"
        regController -> notificationService "Requests submission notifications"
        regController -> collisionService "Requests immediate conflict check for submitted/edited course (sync)"
        schedulingUI -> schedulingController "Initiates scheduling actions"
        schedulingController -> schedulingService "Requests schedule computations"
        schedulingController -> conflictController "Requests conflict checks for proposed schedules"
        schedulingController -> collisionWidget "Asks UI to render conflict suggestions"
        collisionWidget -> conflictController "Fetches conflict details for highlighting"
        conflictController -> conflictNotifier "Publishes conflict summaries to UI"
        conflictNotifier -> scheduleViewerService "Publishes in-app conflict alerts for viewers"
        regUI -> authWidget "Prompts login / shows auth status when needed"
        schedulingUI -> authWidget "Prompts login / shows auth status when needed"
        authWidget -> authService "Uses client to exchange credentials/tokens"
        viewingApp -> authWidget "Prompts login / shows auth status when needed"
    }

    views {
        systemContext scheduler "schedulerSystemContextDiagram" {
            include *
            autolayout
        }

        container scheduler "schedulerContainerDiagram" {
            include *
            autolayout
        }
        component collisionService "collisionServiceComponentDiagram" {
            include *
            exclude managementApp->authService
            exclude scheduleViewerService->authService
            autolayout
        }

        component managementApp "managementAppComponentDiagram" {
            include *
            exclude viewingApp->authService
            exclude collisionService->notificationService
            exclude schedulingService->collisionService
            exclude courseService->authService
            exclude schedulingService->authService
            exclude notificationService->authService
            exclude collisionService->authService
            autoLayout
        }

        

        styles {
            element "Person" {
                background "#07427a"
                color "#ffffff"
                shape person
                height 500
                width 500
            }
            element "Software System" {
                background "#438dd4"
                color "#ffffff"
            }
            element "External" {
                background "#999999"
                color "#ffffff"
            }
            element "Container" {
                background "#438dd4"
                color "#ffffff"
            }
            element "Service" {
                background "#1565c0"
                color "#ffffff"
            }
            element "Web" {
                shape WebBrowser
                background "#85c1e2"
                color "#000000"
            }
            element "Database" {
                shape Cylinder
                background "#e65100"
                color "#ffffff"
            }
        }

        theme default
    }
}
