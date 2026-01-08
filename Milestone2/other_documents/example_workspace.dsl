workspace "HealthTracker Workspace" "This workspace documents the architecture of the HealthTracker system which enables remote patient health monitoring and automated diagnosis of diseases and health disorders." {
    
    model {
        # software systems
        healthTracker = softwareSystem "HealthTracker" "Remotely monitors patient's health and performs automated diagnosis of diseases and health disorders."  {

            # Health Tracker front-end containers
            adminApp = container "Administration Application" "Delivers HTML content to administer patients and devices in the system."  {
                group "Presentation Layer"  {
                    adminWebUI = component "Administration User Interface" "Provides HTML of the UI"
                    adminDeviceController = component "Device Administration Controller" "Processes users' requests to manage devices"
                    adminPatientController = component "Patient Administration Controller" "Processes users' requests to manage patient registrations"
                }
                group "Business Layer"  {
                    adminDeviceModel = component "Device" "Business logic for devices"
                    adminPatientModel = component "Patient" "Business logic for patients"
                }
                group "Persistence Layer"  {
                    adminDeviceRepository = component "Device Repository" "Persists devices in the database"
                    adminPatientRepository = component "Patient Repository" "Persists patients in the database"
                }
            }
            adminHTML = container "Administration HTML" "Provides funcitonality for patient and device administration in a web browser." "HTML+JavaScript" "Web Front-End"

            dashboardApp = container "Dashboard Web Application" "Delivers content to present health status information."
            dashboardHTML = container "Dashboard HTML" "Provides functionality for presenting health status information in a web browser."  "HTML+React.JS" "Web Front-End"

            # Health Tracker back-end containers
            healthStatusManager = container "Health Status Manager" "Provides the history of patients' health status."

            # Health Tracker measurements handling containers
            measurementsCapturer = container "Measurements Capturer" "Captures measured health indicators from all remote measuring devices"
            measurementsAnalyzer = container "Measurements Analyzer" "Analyzes measured health indicators for a given patient, evaluates and stores their health status"    {
                measurementsSelector = component "Selector" "Picks up the next sequence of measured health indicators for the analysis"
                measurementsCache = component "Cache" "Caches measured health indicators for further evaluation"
                healthStatusEvaluator = component "Evaluator" "Evaluates the health status of a patient based on the recent history of measured health indicators"
                alerter = component "Alerter" "Alerts a responsible and backup nurse"
            }

            # Health Tracker databases
            healthStatusDB = container "Health Status Database" "Stores the actual and historical health statuses of patients" "" "Database"
            patientDB = container "Patient Database" "Stores registrations of patients" "" "Database"
            deviceDB = container "Device Database" "Stores registrations of devices." "" "Database"
            auditLogDB = container "Audit Log Database" "Stores audit log records." "" "Database"

            
        }

        measuringDevice = softwareSystem "Measuring Device" "Continuously measures a specific health indicator using a small HW device attached to the patients body." "Existing System"

        hospitalIS = softwareSystem "Hospital Information System" "Manages and stores comprehensive patient records, including their medical treatments, drug prescriptions, surgeries, and examinations." "Existing System"

        # actors
        nurse = person "Nurse" "Monitors health indicators of patients and acts when notified about worsening health conditions."
        doctor = person "Doctor" "Assesses the health status of patients based on the analyses of the health indicators."
        patient = person "Patient" "Wears health monitoring devices and watches their measured health indicators."
        admin = person "Technical administrator" "Administers measuring devices."

        ## relationships of HealthTraker containers
        dashboardApp -> dashboardHTML "Delivers content to"
        dashboardHTML -> healthStatusManager "Makes API calls to"

        healthStatusManager -> healthStatusDB "Reads from"
        healthStatusManager -> patientDB "Reads from"
        healthStatusManager -> auditLogDB "Writes to"
        healthStatusManager -> hospitalIS "Makes API calls to read patient information from"

        measuringDevice -> measurementsCapturer "Streams health indicator measures to"
        measurementsCapturer -> deviceDB "Reads from for device verification"

        measurementsAnalyzer -> hospitalIS "Makes API calls to read health related data about patients"

        admin -> adminHTML "Manages registrations of devices in the system"
        patient -> dashboardHTML "Views current health status and history of statuses"
        nurse -> dashboardHTML "Monitors health status of assigned patients"
        doctor -> dashboardHTML "Views and analyzes measured health indicators of selected patients"

        ### relationships of Measurements Analyzer components

        measurementsCapturer -> measurementsSelector "Provides measured health indicators to"

        measurementsSelector -> measurementsCache "Writes to"
        measurementsSelector -> healthStatusEvaluator "Notifies"
    
        healthStatusEvaluator -> measurementsCache "Reads from"
        healthStatusEvaluator -> healthStatusDB "Writes to"
        healthStatusEvaluator -> hospitalIS "Makes API calls to read health relate data about patients"
        healthStatusEvaluator -> alerter "Reports to"

        alerter -> healthStatusManager "Alerts"
        alerter -> nurse "Alerts assigned nurse about worsening health conditions"

        # relationships of Administration Application components

        adminHTML -> adminDeviceController "Sends requests to"
        adminHTML -> adminPatientController "Sends requests to"
        adminDeviceController -> adminHTML "Delivers content to"
        adminPatientController -> adminHTML "Delivers content to"

        adminDeviceController -> adminWebUI "Uses to render content for device management"
        adminDeviceController -> adminDeviceModel "Gets and updates device data"

        adminPatientController ->  adminWebUI "Uses to render content for patient management"
        adminPatientController -> adminPatientModel "Gets and updates patient data"

        adminDeviceModel -> adminDeviceRepository "Uses to persist device data"
        adminPatientModel -> adminPatientRepository "uses to persist patient data"
        adminPatientModel -> hospitalIS "Makes API calls to read patient information from"

        adminDeviceRepository -> deviceDB "Reads from and writes to"
        adminPatientRepository -> patientDB "Reads from and writes to"

        deploymentEnvironment "Live"    {
            deploymentNode "Admin's web browser" "" ""    {
                adminHTMLInstance = containerInstance adminHTML
            }
            deploymentNode "User's web browser" "" ""    {
                dashboardHTMLInstance = containerInstance dashboardHTML
            }
            deploymentNode "Application Server" "" "Ubuntu 18.04 LTS"   {
                deploymentNode "Web server" "" "Apache Tomcat 10.1.15"  {
                    adminAppInstance = containerInstance adminApp
                    dashboardAppInstance = containerInstance dashboardApp
                    healthStatusManagerInstance = containerInstance healthStatusManager
                }
            }
            deploymentNode "Analytical Server" "" "Ubuntu 18.04 LTS"   {
                measurementsAnalyzerInstance = containerInstance measurementsAnalyzer
            }
            deploymentNode "Capture Server" "" "Ubuntu 18.04 LTS"   {
                measurementsCapturerInstance = containerInstance measurementsCapturer
            }
            deploymentNode "Database Server" "" "Ubuntu 18.04 LTS"   {
                deploymentNode "Relational DB server" "" "Oracle 19.1.0" {
                    healthStatusDBInstance = containerInstance healthStatusDB
                    patientDBInstance = containerInstance patientDB
                    deviceDBInstance = containerInstance deviceDB
                }
                deploymentNode "Log storage" "" "Elasticsearch 8.10.4"  {
                    auditLogDBInstance = containerInstance auditLogDB
                }
            }
            
        }
    }

    views {

        systemContext healthTracker "healthTrackerSystemContextDiagram" {
            include *
        }

        container healthTracker "healthTrackerContainerDiagram" {
            include *
        }

        component measurementsAnalyzer "measurementAnalyzerComponentDiagram" {
            include *
            exclude "healthStatusManager -> hospitalIS"
            exclude "healthStatusManager -> healthStatusDB"
        }

        component adminApp "adminAppComponentDiagram" {
            include *
        }

        deployment healthTracker "Live" "Live_Deployment"   {
            include *
        }

        theme default

        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }

            element "Web Front-End"  {
                shape WebBrowser
            }

            element "Database"  {
                shape Cylinder
            }
        }

    }
    

}