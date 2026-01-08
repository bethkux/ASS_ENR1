workspace "Scheduling Software System Workspace" "This workspace documents the architecture of the Scheduling System which facilitates course scheduling and its management." {
    model {
        # Users
	    user = person "User" "Represents all stakeholders who interact with the scheduling system, including teachers, students, committee members, and managers."
        teacher = person "Teacher" "Registers and updates courses, views personal schedules, and receives notifications about conflicts."
        committeeMember = person "Timetable Committee Member" "Schedules courses, resolves conflicts, approves courses, and manages the overall timetable."
        student = person "Student" "Views personal, course, room, or program schedules and receives notifications about schedule changes."
        manager = person "Manager" "Reviews statistics, teacher workloads, room utilization, and historical schedule data to support planning and decision-making."

        # External systems
        emailSystem = softwareSystem "Email System" "Sends notifications to users." "External"
        authService = softwareSystem "Auth Service" "Validates user credentials, issues tokens and provides authorization checks." "External"
        scheduler = softwareSystem "Scheduling System" "Supports course registration, scheduling, conflict detection, schedule viewing, and reporting." {
            # Databases
            courseDB = container "Course Database" "Stores courses and registration data." "" "Database"
            scheduleDB = container "Schedule Database" "Holds finalized schedules, timeslots, teacher and room assignments" "" "Database"
            statisticsDB = container "Statistics Database" "Contains aggregated and historical schedule statistics." "" "Database"
            logDB = container "Log Database" "Stores logs of technically relevant events" "" "Database"

            # Front-end containers
            managementApp = container "Management Web Application" "Allows teachers and committee members to manage courses, schedules, and conflicts." "" "Web" {
                regUI = component "Course Registration UI" "UI for teachers to register or reuse courses and submit them to the committee."
                schedulingUI = component "Scheduling UI" "UI used by committee members to schedule courses, assign rooms/teachers and resolve collisions."
                collisionWidget = component "Collision Highlight Widget" "Frontend widget that highlights conflicts and suggests alternatives."
                
                authWidget = component "Auth Widget" "Login/identity UI element; prompts user to sign in when needed"
            }

            scheduleViewingApp = container "Schedule Viewing Web Application" "Provides students, teachers, committee members, and managers with schedule view." "" "Web" {
                scheduleShowingUI = component "Schedule showing UI" "UI that let's user choose and show desired schedule."
                scheduleShowingUIComponent = component "Schedule showing UI Compoment" "UI compoment that is used by any user with correct rights to view selected schedule."
                scheduleChoosingUIComponent = component "Schedule choosing UI Compoment" "UI compoment that is used by any user with correct rights to choose which scheduler he want's to show."
                scheduleCollisionWidget = component "Schedule Collision Highlight Widget" "Frontend widget that highlights conflicts in currently shown schedule."
            }
            
            statisticsApp = container "Statistics Web Application" "Allows users to view, filter, and export scheduling statistics." "" "Web" {
                statisticsDashboard = component "Statistics Dashboard" "The main UI for displaying statistics categories and overall statistic summary."
                statisticsFilterUI = component "Statistics Filter UI" "UI that allows the user to select filters, such as semester, room, teacher, etc."
                statisticsViewUI = component "Statistics View UI" "UI which displays the computed statistics (tables, graphs, charts) according to applied filters."
                statisticsExportUI = component "Statistics Export UI" "UI that allows the user to export the statistics to formats such as PDF, CSV and JSON."
                errorWidget = component "Error Widget" "Displays errors, warnings, and system messages to the user."
            }

            # Backend services
            courseService = container "Course Service" "Stores and manages course information, teacher assignments, and registration metadata." "" "Service" {
                regControllerAPI = component "Course Registration API" "API endpoint used by Management App UI to submit and update course data."
                courseFetcherAPI = component "Course Fetcher API" "API endpoint used by Management App UI to fetch data about courses."
                courseRequestValidator = component "Course Request Validator" "Validates and processes API request's inputs."
                courseDataBaseManager = component "Course Database Manager" "Manages course database, creates, updates and fetches courses."
            }

            schedulingService = container "Scheduling Service" "Schedules courses, assigns teachers, rooms, and timeslots. Detects conflicts." "" "Service"{
                scheduleDatabaseManager = component "Scheduling Database Manager" "Fetches and persists schedules, timeslots, room assignments, and teacher assignments."
                schedulingAPI = component "Scheduler API" "API endpoint that accepts scheduling requests."
                scheduleAssessor = component "Schedule Assessor" "Assesses if the course is scheduled sufficiently to meet requirements."
                scheduleAssigner = component "Schedule Assigner" "Scheduling engine that allocates courses to timeslots, rooms, and teachers based on constraints."
                conflictDetector = component "Conflict Detector" "Checks schedules for overlapping times or room/teacher conflicts."
                candidateFilterer = component "Candidate Filterer" "Filters candidate teachers/rooms/timeslots and provides suggestions to the UI."
            }

            notificationService = container "Notification Service" "Delivers emails to users about schedule updates, registrations, and conflicts." "" "Service" {
                notificationCreator = component "Notification creator" "Creates notifications for groups of users."
                notificationRules = component "Notification Rules" "Contains rules for generating notifications based on scheduling events."
            }

            scheduleViewerService = container "Schedule Viewer Service" "Provides schedule data filtered by user, room, course, or program for UI display." "" "Service" {
                scheduleShowingAPI = component "Schedule showing API" "API endpoint used by schedule showing UI."
                scheduleShowingRequestValidator = component "Request Validator" "Validates request's schedule filtering atributes."
                scheduleShowingFetcher = component "Data Fetcher" "Fetches and finalizes schedule data from schedule database."
            }
            
            statisticsService = container "Statistics Service" "Generates reports on room usage, teacher workloads, historical schedules, etc." "" "Service" {
                statisticsSnapshooter = component "Statistics Snapshooter" "Periodically snapshots scheduling data for historical statistics."
                statisticsAPI = component "Statistics API" "API endpoint used by Statistics Web App. Accepts requests for statistics and returns computed data."
                statisticsCalculator = component "Statistics Calculator" "Calculates the user selected statistics."
                statisticsExporter = component "Statistics Exporter" "Exports the statistics to various formats, e.g. PDF, CSV, JSON."
                statisticsFilterer = component "Statistics Filterer" "Fetches statistics relevant to user-requested calculations."
                statisticsCache = component "Statistics Cache" "Stores previous statistics for certain time duration."
            }

            loggingService = container "Logging Service" "Logs technical events of the system" "" "Service" {
                loggingAPI = component "Logging API" "API endpoint for storing and retrieving logs"
                loggingRepository = component "Logging Repository" "Persists logs"
            }
        }  

        ### USER INTERACTIONS (L1)
        teacher -> managementApp "Registers courses and reviews scheduling conflicts"
        committeeMember -> managementApp "Schedules courses, resolves conflicts, and approves timetable submissions"
        teacher -> scheduleViewingApp "Views teaching schedules"
        committeeMember -> scheduleViewingApp "Reviews overall timetable and conflict reports"
        student -> scheduleViewingApp "Checks personal course schedule, program schedule, and room availability"
        manager -> statisticsApp "Analyzes statistics on teacher workload, room usage, and historical schedules"
        committeeMember -> statisticsApp "Reviews statistics to support scheduling decisions"
	    user -> statisticsApp "Accesses the statistics front-end"
    	user -> scheduleViewingApp "Views schedules based on input criteria"


        ### USER INTERACTIONS (L2)
        committeeMember -> schedulingUI "Schedules courses, views conflicts"
        teacher -> regUI "Registers courses and reviews scheduling conflicts"
        user -> scheduleShowingUI "Views schedules based on input criteria"
        committeeMember -> statisticsDashboard "Enters dashboard to review statistics to support scheduling decisions"
        manager -> statisticsDashboard "Enters dashboard to analyze statistics"

        ### SERVICE RELATIONSHIPS (L2)
        # schedulingService -> notificationService "Sends scheduling-related notifications"
        # schedulingService -> NotificationServiceBalancer "Sends scheduling-related notifications"
        # NotificationServiceBalancer -> notificationService "Distributes the workload"
        # Management App to backend services
        # managementApp -> courseService "Updates and queries course and teacher assignment information"
        # managementApp -> schedulingService "Performs scheduling operations and requests current schedule data"

        courseService -> courseDB "Stores courses, teacher assignments, and registration data"
        schedulingService -> courseService "Fetches course metadata needed for scheduling and assessing schedules"
        statisticsService -> statisticsDB "Stores and retrieves aggregated statistical data"
        statisticsService -> scheduleDB "Reads current schedule information to compute metrics"
        statisticsService -> courseFetcherAPI "References course metadata"
        
        # Auth service relationships
        scheduleViewingApp -> authService "Obtains tokens / redirects user to login"
        managementApp -> authService "Validates user credentials and authorizations"
        courseService -> authService "Validates user/service tokens and checks authorizations"
        schedulingService -> authService "Validates user/service tokens and checks authorizations"
        scheduleViewerService -> authService "Validates user/service tokens and checks authorizations"

        # Logging service relationships
        statisticsService -> loggingService "Sends logs"
        
 
        ### COMPONENT RELATIONSHIPS (L3)
        # ManagementApp component relationships
        regUI -> regControllerAPI "Submits course registration"        
        regUI -> authWidget "Requests to autenticate user"
        schedulingUI -> authWidget "Requests to autenticate user"
        authWidget -> authService "Uses client to exchange credentials/tokens"
        schedulingUI -> collisionWidget "Calls on scheduling data change"
        schedulingUI -> schedulingAPI "Requests current schedule data and performs scheduling operations"
        
        # ScheduleViewingApp component relationships
        scheduleShowingUI -> scheduleShowingUIComponent "Retrieves UI component from "
        scheduleShowingUI -> scheduleChoosingUIComponent "Retrieves UI component from"
        scheduleShowingUI -> scheduleCollisionWidget "Calls on schedule data change"
        scheduleChoosingUIComponent -> scheduleShowingAPI "Requests schedule data for selected schedule"
        
        # SchedulingViewingSevice component relationships
        scheduleShowingApi -> scheduleShowingRequestValidator "Asks for validation of a request"
        scheduleShowingRequestValidator -> scheduleShowingFetcher "Asks for finalized schedule data"
        scheduleShowingFetcher -> scheduleDB "Fetches data from"
        
        # Notification service compoment relationships
        notificationRules -> notificationCreator "Triggers notification creation based on scheduling events"
        notificationCreator -> emailSystem "Sends notifications using"
        
        # Courser service component relationships
        regControllerAPI -> courseRequestValidator "Asks for validation and execution of a request"
        courseFetcherAPI -> courseRequestValidator "Asks for validation and execution of a request"
        courseRequestValidator -> courseDataBaseManager "Asks for an execution of a request"
        courseDataBaseManager -> courseDB "Manages data in"
        
        # SchedulingService component relationships
        schedulingAPI -> scheduleDatabaseManager "Fetches current schedules"
        schedulingAPI -> authService "Validates user/service tokens and checks authorizations"
        schedulingAPI -> scheduleAssigner "Requests course scheduling operations"
        scheduleDatabaseManager -> scheduleDB "Reads and writes schedule data"
        scheduleAssessor -> courseFetcherAPI "Fetches course metadata needed for assessing schedules"
        scheduleAssigner -> courseFetcherAPI "Performs course scheduling operations"
        scheduleDatabaseManager -> scheduleAssessor "Assesses if the course is scheduled sufficiently to meet requirements"
        scheduleAssigner -> scheduleDatabaseManager "Assigns courses to timeslots, rooms, and teachers"
        scheduleDatabaseManager -> conflictDetector "Detects conflicts in scheduling"
        scheduleDatabaseManager -> candidateFilterer "Asks for candidate teachers/rooms/timeslots suggestions"
        candidateFilterer -> courseFetcherAPI "Fetches course metadata needed for filtering candidates"
        
        # StatisticsApp component relationships
        statisticsDashboard -> statisticsFilterUI "User navigates to filter UI from the dashboard"
        statisticsFilterUI -> statisticsViewUI "User applies filters and computes statistics, moving to the view UI"
        statisticsViewUI -> statisticsExportUI "User chooses to export displayed statistics"
        statisticsViewUI -> statisticsAPI "Requests filtered statistics from the backend"
        statisticsExportUI -> statisticsAPI "Sends export requests to the backend"
        statisticsDashboard -> errorWidget "Displays general errors or warnings"
        statisticsFilterUI -> errorWidget "Displays errors while selecting filters (e.g. invalid user input)"
        statisticsViewUI -> errorWidget "Displays errors if data fetch or processing fails"
        statisticsExportUI -> errorWidget "Displays errors if export fails"

        # StatisticsService component relationships
        statisticsAPI -> statisticsCalculator "Requests computation of statistics based on user input"
        statisticsAPI -> statisticsExporter "Requests export of statistics"        
        statisticsFilterer -> statisticsDB "Fetches historical statistics data from"
        statisticsCalculator -> statisticsCache "Tries to fetch local statistics found in the local storage."
        statisticsCache -> statisticsFilterer "Requests filtered statistics data relevant for calculations"
        statisticsCalculator -> courseService "Reads course metadata for computation"
        statisticsSnapshooter -> scheduleDB "Snapshots scheduling data from"
        statisticsSnapshooter -> statisticsDB "Stores scheduling data snapshots into"

        # LoggingService component relationships
        loggingAPI -> loggingRepository
        loggingRepository -> logDB
        
        # Deployment digrams
        development = deploymentEnvironment "Development" {
            
            deploymentNode "Developer PC"  {
                deploymentNode "Docker Engine" "" "Docker Compose" {
                    deploymentNode "Course Service Container" ""  "Docker container" {
                        containerInstance courseService
                    }
                    deploymentNode "Scheduling Service Container" "" "Docker container" {
                        containerInstance schedulingService
                    }
                    deploymentNode "Notification Service Container" "" "Docker container" {
                        containerInstance notificationService
                    }
                    deploymentNode "Viewer Service Container" "" "Docker container" {
                        containerInstance scheduleViewerService
                    }
                    deploymentNode "Statistics Service Container"  "" "Docker container" {
                        containerInstance statisticsService
                    }
                    deploymentNode "Course DB Server Container" "" "Docker container" {
                        containerInstance courseDB
                    }
                    deploymentNode "Schedule DB Server Container" "" "Docker container" {
                        containerInstance scheduleDB
                    }
                    deploymentNode "Statistics DB Server Container" "" "Docker container" {
                        containerInstance statisticsDB
                    }
                }
                deploymentNode "Local Browser" "" "localhost" {
                    deploymentNode "managementApp" "" "dev-server" {
                        containerInstance managementApp
                    }
                    deploymentNode "scheduleViewingApp" "" "dev-server" {
                        containerInstance scheduleViewingApp
                    }
                    deploymentNode "statisticsApp" "" "dev-server" {
                        containerInstance statisticsApp
                    }
                }
            }
            deploymentNode "Auth Provider (Remote)" "External System" {
                softwareSystemInstance authService
            }
            
            deploymentNode "Email System (Remote)" "External System" {
                softwareSystemInstance emailSystem
            }
        }

        production = deploymentEnvironment "Production" {
            deploymentNode "University Data Center" "" "" {
                deploymentNode "Frontend Server 1" "" "Docker container" {
                    deploymentNode "Docker Engine" "" "Docker Compose" {
                        deploymentNode "SPA Static File Server (Nginx)" "" "nginx" "" "1" {
                            containerInstance managementApp
                            containerInstance scheduleViewingApp
                            containerInstance statisticsApp
                        }
                    }   
                }

                deploymentNode "API Server" "" {
                    APIGateway = infrastructureNode "API Gateway" "Routes requests to backend, with fault tolerance" "" "Infrastructure" {
                    }
                }

                deploymentNode "Statistics Server" "" "Docker compose" {
                    deploymentNode "Application Monitor" "" "" {
                        applicationMonitor = infrastructureNode "Application Monitor" "Monitors status of statistics containers" "Kong Gateway" "Infrastructure" {
                        }
                    }
                    deploymentNode "Statistics Application Server" "" "Docker container" "" "1" {
                        containerInstance statisticsService
                    }
                    
                    deploymentNode "Database Server" "" "" {
                        containerInstance statisticsDB
                    }
                }

                deploymentNode "Course Server" "" "Docker compose" {
                    deploymentNode "Course Load Balancer" "" "" {
                        courseServiceBalancer = infrastructureNode "Course Load Balancer" "Distributes incoming requests across backend service instances." "" "Infrastructure" {
                        }
                    }

                    deploymentNode "Course Service Container" "" "Docker container" "" "3" {
                        containerInstance courseService
                    }
                    
                    deploymentNode "Scheduling Service Container" "" "Docker container" "" "2" {
                        containerInstance schedulingService
                        
                    }
                    deploymentNode "Schedulling Balancer"
                        SchedulingServiceBalancer = infrastructureNode "Scheduling Load Balancer" "Distributes incoming requests across backend service instances." "" "Infrastructure" {
                    }
                    deploymentNode "Notification Balancer"
                        NotificationServiceBalancer = infrastructureNode "Notification Load Balancer" "Distributes incoming requests across backend service instances." "" "Infrastructure" {
                    }
                    deploymentNode "Notification Service Container" "" "Docker container" "" "2" {
                        containerInstance notificationService
                    }
                    deploymentNode "Database Server" "" "" {
                        containerInstance courseDB
                    }
                }

                deploymentNode "Schedule Service" "" "Docker compose" {
                    deploymentNode "Viewer Service Container" "" "Docker container" "" "3" {
                        containerInstance scheduleViewerService
                    }
                    ScheduleViewerBalancer = infrastructureNode "LoadBalancer" "Distributes schedule requests across backend service instances." "" "Infrastructure" {
                    }
                    deploymentNode "Database Server" {
                        containerInstance scheduleDB
                    }
                }
                
                scheduleViewerService -> NotificationServiceBalancer "Submits schedule change for possible notifications"
                NotificationServiceBalancer -> notificationService "Distributes the workload between containers"
                schedulingService -> NotificationServiceBalancer "Sends scheduling-related notifications"
                statisticsApp -> APIGateway "Sends statistics requests"
                APIGateway -> statisticsService "Routes statistics requests"
                statisticsService -> courseServiceBalancer "Sends course requests to the load balancer."
                schedulingService -> courseServiceBalancer "Sends course requests to the load balancer."
                courseServiceBalancer -> courseService "Distributes incoming requests across backend service instances."
                ManagementApp -> SchedulingServiceBalancer "Sends scheduling operations and data requests to the load balancer."
                SchedulingServiceBalancer -> schedulingService "Distributes incoming requests across backend service instances."

                applicationMonitor -> statisticsService " "
                applicationMonitor -> statisticsDB " "

                
                scheduleViewingApp -> ScheduleViewerBalancer "Sends viewing operations and data requests to the load balancer."
                ScheduleViewerBalancer -> scheduleViewerService "Distributes incoming requests across backend service instances."
            }
            deploymentNode "Auth Provider (Remote)" "External System" {
                softwareSystemInstance authService
            }
            deploymentNode "Email System (Remote)" "External System" {
                softwareSystemInstance emailSystem
            }
        }

        testing = deploymentEnvironment "Testing" {
            deploymentNode "University Data Center" "" "" {
                deploymentNode "Frontend Server 1" "" "Docker container" {
                    deploymentNode "Docker Engine" "" "Docker Compose" {
                        deploymentNode "SPA Static File Server (Nginx)" "" "nginx" "" "1" {
                            containerInstance managementApp
                            containerInstance scheduleViewingApp
                            containerInstance statisticsApp
                        }
                    }   
                }

                deploymentNode "API Server" "" {
                    APIGateway2 = infrastructureNode "API Gateway" "Routes requests to backend, with fault tolerance" "" "Infrastructure" {
                    }
                }

                deploymentNode "Statistics Server" "" "Docker compose" {
                    deploymentNode "Application Monitor" "" "" {
                        applicationMonitor2 = infrastructureNode "Application Monitor" "Monitors status of statistics containers" "Kong Gateway" "Infrastructure" {
                        }
                    }
                    deploymentNode "Statistics Application Server" "" "Docker container" "" "1" {
                        containerInstance statisticsService
                    }
                    
                    deploymentNode "Database Server" "" "" {
                        containerInstance statisticsDB
                    }
                }

                deploymentNode "Course Server" "" "Docker compose" {
                    deploymentNode "Course Load Balancer" "" "" {
                        courseServiceBalancer2 = infrastructureNode "Course Load Balancer" "Distributes incoming requests across backend service instances." "" "Infrastructure" {
                        }
                    }

                    deploymentNode "Course Service Container" "" "Docker container" "" "1" {
                        containerInstance courseService
                    }
                    
                    deploymentNode "Scheduling Service Container" "" "Docker container" "" "1" {
                        containerInstance schedulingService
                        
                    }
                    deploymentNode "Schedulling Balancer"
                        SchedulingServiceBalancer2 = infrastructureNode "Scheduling Load Balancer" "Distributes incoming requests across backend service instances." "" "Infrastructure" {
                    }
                    deploymentNode "Notification Balancer"
                        NotificationServiceBalancer2 = infrastructureNode "Notification Load Balancer" "Distributes incoming requests across backend service instances." "" "Infrastructure" {
                    }
                    deploymentNode "Notification Service Container" "" "Docker container" "" "1" {
                        containerInstance notificationService
                    }
                    deploymentNode "Database Server" "" "" {
                        containerInstance courseDB
                    }
                }

                deploymentNode "Schedule Service" "" "Docker compose" {
                    deploymentNode "Viewer Service Container" "" "Docker container" "" "1" {
                        containerInstance scheduleViewerService
                    }
                    ScheduleViewerBalancer2 = infrastructureNode "LoadBalancer" "Distributes schedule requests across backend service instances." "" "Infrastructure" {
                    }
                    deploymentNode "Database Server" {
                        containerInstance scheduleDB
                    }
                }
                
                scheduleViewerService -> NotificationServiceBalancer2 "Submits schedule change for possible notifications"
                NotificationServiceBalancer2 -> notificationService "Distributes the workload between containers"
                schedulingService -> NotificationServiceBalancer2 "Sends scheduling-related notifications"
                statisticsApp -> APIGateway2 "Sends statistics requests"
                APIGateway2 -> statisticsService "Routes statistics requests"
                statisticsService -> courseServiceBalancer2 "Sends course requests to the load balancer."
                schedulingService -> courseServiceBalancer2 "Sends course requests to the load balancer."
                courseServiceBalancer2 -> courseService "Distributes incoming requests across backend service instances."
                ManagementApp -> SchedulingServiceBalancer2 "Sends scheduling operations and data requests to the load balancer."
                SchedulingServiceBalancer2 -> schedulingService "Distributes incoming requests across backend service instances."

                applicationMonitor2 -> statisticsService " "
                applicationMonitor2 -> statisticsDB " "

                
                scheduleViewingApp -> ScheduleViewerBalancer2 "Sends viewing operations and data requests to the load balancer."
                ScheduleViewerBalancer2 -> scheduleViewerService "Distributes incoming requests across backend service instances."
            }
            deploymentNode "Auth Provider (Remote)" "External System" {
                softwareSystemInstance authService
            }
            deploymentNode "Email System (Remote)" "External System" {
                softwareSystemInstance emailSystem
            }
        }
    }



    views {
        systemContext scheduler "schedulerSystemContextDiagram" {
            include *
            exclude user
            autolayout
        }

        container scheduler "schedulerContainerDiagram" {
            include *
            exclude user
            autolayout            
                            
        } 

        component managementApp "managementAppComponentDiagram" {
            include *

            exclude scheduleViewingApp->authService
            exclude courseService->authService
            exclude schedulingService->authService
            exclude notificationService->authService
            exclude schedulingService->courseService

            autoLayout
        }

        component scheduleViewingApp "scheduleViewingAppComponentDiagram" {
            include *
            exclude scheduleViewingApp->authService
           
            autoLayout
        }
        
        component scheduleViewerService "scheduleViewingServiceComponentDiagram" {
            include *
            autoLayout
        }
        
        component courseService "courseServiceComponentDiagram" {
            include *
            autoLayout
        }
        
        component notificationService "notificationServiceComponentDiagram" {
            include *
            autoLayout
        }
        
        component schedulingService "schedulingServiceComponentDiagram" {
            include *

            autolayout
        }
        component statisticsService "statisticsServiceComponentDiagram" {
            include *
            exclude authService

            autolayout
        }

        component statisticsApp "statisticsAppComponentDiagram" {
            include *
            autolayout
        }

        ### DEPLOYMENT DIAGRAM VIEWS
        deployment * development "developmentDeploymentDiagram" {
            include *
            autoLayout 
        }

        deployment * production "productionDeploymentDiagram" {
            include *
            exclude managementApp->schedulingService
            exclude scheduleViewingApp->scheduleViewerService
            autoLayout 
        }

        deployment * testing "testingDeploymentDiagram" {
            include *
            exclude managementApp->schedulingService
            exclude scheduleViewingApp->scheduleViewerService
            autoLayout 
        }

        ### DYNAMIC DIAGRAM VIEWS
        dynamic scheduler "StatisticsViewingScenario" "Scenario: Manager views historical scheduling statistics" {
            user -> statisticsApp "Opens Statistics page and selects category, semester, filters"
            statisticsApp -> statisticsService "Requests statistics for selected semester and filters"
            statisticsService -> statisticsDB "Loads historical statistics snapshots for the semester"
            statisticsService -> courseService "Loads course and teacher metadata (for workloads, departments)"
            statisticsService -> scheduleDB "Loads current schedule data for reference"
            statisticsService -> statisticsApp "Returns computed statistics"
            statisticsApp -> user "Displays tables, graphs and charts with the requested statistics"

	        autolayout bt
        }

        dynamic scheduler "CourseRegistration" "Teacher registers a new course" {
            teacher -> managementApp "Opens management web application page and chooses option 'registering new course'"
            managementApp -> authService "Logs in to the system as a teacher "
            managementApp -> courseService "Submits new or updated course details"
            courseService -> courseDB "Stores course to database"
            autolayout tb
	    }

        dynamic scheduler "CourseScheduling" "Scheduling a Course" {
            committeeMember -> managementApp "Opens management web application page and chooses option 'Scheduling'" 
            managementApp -> authService "Logs in to the system as a committe member "
            managementApp -> schedulingService "Requests current schedule data"
            schedulingService -> courseService "Fetches all courses taught next semester"
            courseService -> courseDB "Gets courses"
            managementApp -> schedulingService "Submits scheduling request for a course"
	        schedulingService -> scheduleDB "Uploads schedules to database"
            # schedulingService -> notificationService "Notifies the teacher about time and room or any issues"
            notificationService -> emailSystem "Sends an email"

            autolayout tb
        }

        dynamic scheduler "ScheduleViewing" "Schedule viewing" {
            user -> scheduleViewingApp "Opens schedule viewing web application page and chooses option 'Schedule'"
            scheduleViewingApp -> authService "Authenticates user"
            scheduleViewingApp -> scheduleViewerService "Selects the criteria for displaying the Schedule"
            scheduleViewerService -> scheduleDB "Fetches specific data"

            autolayout tb
        }

        dynamic schedulingService "CollisionDetection" "Detecting a collision in the schedule" {
            committeeMember -> managementApp "Schedules a new course or edits an existing one using the UI"
            managementApp -> schedulingAPI "Submits the scheduling request"
            schedulingAPI -> scheduleAssigner
            scheduleAssigner -> scheduleDatabaseManager
            scheduleDatabaseManager -> conflictDetector "Detects conflicts in the schedule"
            schedulingAPI -> managementApp "Highlights the conflicting entries in the UI"
            committeeMember -> managementApp "Views the conflict and resolves them using the UI and submits the new scheduling"
            scheduleDatabaseManager -> scheduleDB "Persists all detected conflicts and changes"

            autolayout tb
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
            element "Infrastructure" {
                color "#000000"
            }
        }

        theme default
    }
}
