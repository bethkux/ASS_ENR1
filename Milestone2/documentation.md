# Scheduling system

This system is a part of wider university information system. It takes care of scheduling courses, that meaning creating courses and then scheduling them for specific rooms and teachers. System also allows viewing the scheduled courses for specific room, teacher, student and so on. System also enables viewing historical statistics for scheduled courses.

This system uses layered architecture in it's three main parts. We can say that the overall architesture is Modular Monolith. 

---

## Core features and responsibilities

### Feature: Registering new course

As a teacher i want to register a new course with its information so that it can be scheduled and attended by students.

#### Feature breakdown

1. The system recognizes the teacher's account based on their login. 
2. On the home screen, there should be an icon labeled something like "register a course" (which is not visible when a student logs in). 
3. Teachers should be able to choose from a database of subjects they have taught in previous years or create a completely new course.
4. If teacher selected a course he had taught before, the system should ask him if he had made the necessary changes for this year (such as updating the course information) and confirm this. 
   If he wanted to create a course he had not taught before, they should fill in the required information about the subject (such as what the subject is about, how many credits it is worth, which faculty it is for, what its code will be, who the subject is intended for, a link to more detailed information, any prerequisites for enrollment, and which year the subject is intended for).
5. After confirming the subject, it should be submitted to the timetable committee, which will approve it and schedule the time and place. It should also be checked whether the two subjects teach the same thing.

#### Responsibilities

##### Privacy responsibilities
* Only authenticated teachers can register or edit courses. (Auth Service)
* Students cannot create or modify subjects. (Auth Service)
* Teachers can view courses registered by others for reference but cannot edit them. (Auth Service)

##### UI responsibilities
* The teacher is presented with course registration dashboard. (Management App)
* The system can display a course registration form. (Management App)
* The teacher can see all their courses. (Management App)

##### Performance responsibilities
* The system should handle simultaneous submissions efficiently, ensuring responsiveness even when multiple teachers register courses concurrently. (Course Service)
* Course data should be stored and retrieved quickly without significant delays. (Course Service, Course Database)

##### Usability responsibilities
* The registration interface must remain clear and intuitive across all screen sizes and devices. (Management Web Application)
* Form validation should provide immediate feedback (e.g., missing fields, invalid credit values). (Management Web Application)
* Previously entered data should not be lost if an error occurs during submission. (Management Web Application)
* Tooltips or short instructions should guide teachers through each step. (Management Web Application)
* Reusable course templates should minimize redundant typing. (Management Web Application)

##### Data Integrity and Validation Responsibilities

* Input data must be validated before submission (e.g., unique course code, correct credit value range). (Management Web Application)
* Prevent duplicate or conflicting course entries. (Scheduling Service)
* Ensure consistent data format across all registered courses. (Scheduling Service)
* Maintain audit logs of who created, modified, or approved each course. (Scheduling Service)

##### Security Responsibilities

* All communication between the client and server must be encrypted (HTTPS).
Access to course registration features should require proper authentication and authorization checks. (Scheduling Service, Course Service)
* Sensitive information such as teacher IDs or emails must not be publicly visible. (Course Service, Scheduling Service)

---
### Feature: Scheduling a Course

As a committee member, I want to schedule a course by assigning its teacher, time, and room, so that it becomes part of the semester timetable.

#### Feature breakdown

1. Committee member goes to the scheduling page.  
2. The system displays the table of scheduled courses and a list of unscheduled courses for the current semester.  
3. Committee member can filter the displayed courses by year, teacher, or name.  
4. Committee member selects a course to schedule.  
5. The system displays available teachers and times for that course and appropriate rooms (satisfying room types and capacity).  
6. Committee member selects the teacher, time, and room.  
7. The system logs the course schedule information.  

#### Responsibilities


##### Data management responsibilities
- Fetch all courses from persistent storage. (Scheduling Service)
- Fetch course info (Course Service)
- Caching courses (Course Database)
- Store course schedule to persistent database. (scheduling Service)

##### Course Filtering responsibilities
- Filter current semester.  (scheduling Service)
- Show the table of scheduled courses and a list of unscheduled courses. (Management Web Application)
- Filter courses based on user input (year, teacher, name). (scheduling Service)
- Detect courses that are insufficiently scheduled (based on capacities). (scheduling Service)

##### Candidate filtering responsibilities
- Load course-specific information and constraints. (scheduling Service)
- Find teacher teaching the course and fetch their schedules. (scheduling Service)
- Find rooms with enough capacity matching the room types. (scheduling Service)

##### Validation and collision responsibilities
- Check room schedule for conflicts. (scheduling Service)
- Show result of overall conflict detection (scheduling Service)


##### Notification responsibilities
- Notify teachers assigned to the course. (scheduling Service)
- Notify teacher to schedule their course if it is not scheduled by commitee. (scheduling Service)
- Alert user when room conflict is detected. (Management Web Application)
- Alert user when teacher conflict is detected. (Management Web Application)

---
### Feature: Collision detection


As a committee member or a teacher, I want the system to notify me when more courses are scheduled in the same room, time, or with the same teacher so I can avoid conflicts in the schedule.

#### Feature breakdown

1. Committee member (or a teacher) schedules a course (or edits an existing scheduled course).  
2. The system automatically checks for potential collisions:
   - Room conflicts: two courses assigned to the same room at overlapping times.  
   - Teacher conflicts: a teacher assigned to more than one course at overlapping time.  
   - Student conflicts (optional): courses from the same program overlapping. 
3. If a conflict is detected:
   - The system highlights the conflicting entries in the scheduling interface.  
   - The system persists the conflict in a database to later display the conflict or manage its resolution.
   - The system suggests alternative time slots or rooms where possible. (optional)
4. The committee member resolves the conflict (chooses a different room/time or confirms exception).  
5. The system logs and persists all detected conflicts and resolutions (resolved/unresolved).
6. Committee members can view a list of unresolved conflicts, filter them (by teacher, room, or resolution status).

#### Responsibilities

##### Collision detection responsibilities
- Check new or edited course against all existing scheduled courses. (Scheduling Service)
- Detect overlapping times for the same room. (room conflicts)  (Scheduling Service)
- Detect overlapping times for the same teacher. (teacher conflicts) (Scheduling Service)
- Show courses with collisions (Management Web Application)
- Show teachers with collisions (Management Web Application)
- Show and provide overall collision detection to ensure all scheduled courses are checked for possible conflicts (Scheduling Service)
- Show collison resolution form (a commitee member can manualy resolve a collision by setting a status of the collision) (Management Web Application)
- Optionally, detect overlapping courses for the same program or student group. (Management Web Application) 

##### User notification responsibilities 
- Show room conflict alert (highlight conflicting courses clearly in the interface) (Scheduling Service)
- Show teacher conflict alert (Scheduling Service)
- Suggest possible resolutions (alternative rooms, times, or teachers) (optional) (Scheduling Service)

##### Logging and audit responsibilities 
- Store room and teacher collisions (Scheduling Service)
- Store how each conflict was resolved (collision status).  (Scheduling Service)
- Allow committee members to review unresolved conflicts at any time by room/teacher. (Management Web Application)

##### Performance and scalability responsibilities
- Efficiently detect collisions even with a large number of scheduled courses. (Scheduling Service) 
- Ensure minimal latency so that scheduling workflow is smooth for committee members.  (Scheduling Service, Management Web Application, Schedule Database)

##### Quality responsibilities
- Provide clear conflict messages. (Management Web Application)
- Allow committee members to quickly filter and review conflicts. (Management Web Application)

---
### Feature: Schedule viewing

As a user I want to be able to view a schedule specific to me, a room, a course or a programme in a specific time window.

#### Feature breakdown

1. Any user goes to the schedule page
2. In the frontend, user selects which schedule to view:
   - Users schedule (student's or teacher's schedules in specific time window)
   - Room schedule
   - Course schedule
   - Programme schedule
3. System fetches and displays schedule data based on the user’s selection
4. If conflicts are detected (overlapping courses, double bookings, and so on...), frontend displays a warning to the user  
5. User can switch between different schedule types repeating (2.)

#### Responsibilities

##### Privacy responsibilities
* Users that are not logged in cannot view any schedules (Auth Service, Schedule Viewing Web Application)
* Logged-in users can view only schedules that they are authorized to see (Auth Service, Schedule Viewing Web Application)  

##### User notification responsibilities
* Detect and highlight conflicts (overlapping lectures, room double-booking, and so on...) (Schedule Viewing Web Application)
* Allert user about canceled course dates (as a student or teacher) (Notification Service)
* Detect national holiday and other days without teaching and highligt these days as free (Schedule Viewing Web Application)

##### Performance and scalability responsibilities
* Fetching schedules data (Schedule Viewer Service)
* Handle concurrent access efficiently (many users checking schedules at once) (Schedule Viewer Service)
* Cache frequently accessed schedules (popular courses or rooms) (Schedule Database)
* Ensure fast and efficient filtering through a lot of schedules data (Schedule Viewer Service, Schedule Service)

##### Usability responsibilities
* Showing schedule based on user selection (Schedule Viewing Web Application)
* Ensure schedules are readable on all types of devices (Schedule Viewing Web Application)
* Make sure that schedule selection is intuitive on all types of devices (Schedule Viewing Web Application)
* Ensure support for multiple ways of accessing schedules data (mobile app, webapp, and so on...) (Schedule Viewing Web Application)

---
### Feature: Statistics Viewing

As a user, I want to be able to see the statistics from previous years, such as room utilization and teacher workload, so that I can support better planning and decision-making based on past data.

***Note:** User refers to any user of the system.*

#### Feature breakdown:
1. Any user navigates to the Statistics page.
2. The system presents available statistics categories:
    - **Room utilization**
    - **Teacher workload**
    - **Peak scheduling hours/days**
    - **Past schedules**
3. The user selects one statistic category to view.
4. The system asks the user to select a specific semester, defined by its academic year and whether it is the winter or summer term.
5. The user is then presented with optional filters depending on the selected statistic:
    - **Room utilization** &rarr; filter by building, specific room or room type (e.g. lab, lecture hall, etc.)
    - **Teacher workload** &rarr; filter by specific teacher, department or faculty
    - **Peak scheduling hours/days** &rarr; filter by building and room type
    - **Past schedules** &rarr; filtering and viewing works as described in [Schedule viewing](#feature-schedule-viewing) feature.
6. The user confirms their selection.
7. The system retrieves the historical scheduling data from persistent storage.
8. The system computes the requested statistics.
9. The system displays the results to the user visually:
    - **Tables**
    - **Graphs**
    - **Charts**


#### Responsibilities

##### Data retrieval responsibilities:
- Retrieve historical data from persistent storage. (Statistics Service)
- Cache commonly requested statistics or semesters to optimize performance. (Statistics Database)
- Handle historical datasets efficiently. (Statistics Service)

##### Statistics computation responsibilities:
- Run the appropriate statistical calculations based on the selected category and filters. (Statistics Service)
- Store the statistical results. (Statistics Service)

##### Filtering responsibilities:
- Validate user selections (for example, ensure chosen semester exists in storage). (Statistics Service)
- Apply the chosen filters based on the category. (Statistics Service)
- Provide suggestions if filters are too restrictive (for example if there is no data for given room &rarr; try all rooms instead) (Statistics Web Application)

##### User interaction and visualization responsibilities:
- Present the available statistics categories and filter options. (Statistics Web Application)
- Display the computed results to the user using appropriate visualization (tables, graphs, charts...). (Statistics Web Application)
- Provide intuitive navigation between different statistical views. (Statistics Web Application)

##### Usability responsibilities:
- Ensure responsive design for all devices and screen sizes. (Statistics Web Application)

##### Error handling responsibilities:
- Alert the user when no results can be generated (for example, no data is available for selected filters) (Statistics Web Application)
- Display clear messages during loading, failure, or empty states. (Statistics Web Application)

---

## Final software architecture (in C4 model)

### L1 diagram
![L1 diagram](/images/L1_diagram.png)

As you can see in L1 diagram, we identified 4 types of users, for this part of the university information system no more should be needed. Also we idenfified 3 bindings to the wider university system, also no more will be needed. 

### L2 diagram
![L2 diagram](/images/L2_diagram.png)

We identified 3 types of user interfaces needed for the scheduling system (3 different web pages/web apps UIs), but multiple request paths. It depends on the type of user, if the user will have access to that page. The schedule viewing part is the simplest, so we tried to make the request path also simple/short, following standard web application layered architecture (one UI/fronted, one backend part and one database). The statistics viewing part needs Course service to access course data, it uses it just for that, otherways it follows the same layered architecture to make the request path as short as posible. The scheduling part is the most complex, the request path can split in multiple nodes, still following the layered architecture, but with multiple possible request paths. We created 3 databases, 2 of them are accessible just from one container to make it simpler. The Schedule database cannot be splitted because, if did, we would just multiple the data as multiple containers need the same data but do different things with them.

### Frontend containers

#### Statistics web application diagram
![statistics web app diagram](/images/statistics_web_application_diagram.png)

There are multiple components, 2 of them making API calls to the backend.

#### Management web application diagram

![management web app diagram](/images/management_we_application_diagram.png)
There are multpile component responsible for course registration and course scheduling parts of the Management application, pointing to multiple backends.

#### Schedule viewing web application diagram
![schedule viewing web app diagram](/images/schedule_viewing_web_application_diagram.png)

Also multiple UI components, just one making API calls to backend.

### Backend containers

#### Statistics service diagram
![statistics service diagram](/images/statistics_service_diagram.png)

Multiple components, two of them accessing database. There's one standalone component, Statistics snapshooter, which fill the Statistics Database.

#### Course service diagram
![course service diagram](/images/course_service_diagram.png)

This service is used to by other containers to access the Course databese, so it is the only container which accesses it. 

#### Scheduling service diagram
![scheduling service diagram](/images/scheduling_service_diagram.png)

Container responsible for creating and validating created schedules for some courses. This container accesses two other containers to do common work for the container with the other backend containers.

#### Notification service diagram
![notification service diagram](/images/notification_service_diagram.png)

Container used for notifiing user by email. The container has one standallone component that runs and checks if we need to notify user.

#### Schedule viewer service diagram
![schedule viewer service diagram](/images/schedule_viewer_service.png)

Straight forward implementation of processing API calls from frontend to access database just for reading.

### Dynamic diagrams

#### Course registration dynamic diagram
![course registration dynamic diagram](/images/dynamic_course_registration.png)

#### Course scheduling dynamic diagram
![course scheduling dynamic diagram](/images/dynamic_course_scheduling.png)

#### Schedule viewing dynamic diagram
![schedule viewing dynamic diagram](/images/dynamic_schedule_viewing.png)

#### Statistics viewing dynamic diagram
![statistics viewing dynamic diagram](/images/dynamic_statistics_viewing.png)

### Deployment diagrams

#### Development deployment diagram
![development deployment diagram](/images/development_deployment_diagram.png)
The development diagram consists of backend services and databases running inside local Docker containers, while frontend applications run locally via dev-servers. This enables fast UI iteration with hot-reload and instant rebuilds, while the backend benefits from isolated containerized environments that guarantee consistency (dependencies, versions, configurations) across all developers. Containerized databases allow developers to work independently without affecting shared resources and are easy to set up. Except for external services, everything runs locally which simplifies the development process.

#### Production deployment diagram
![production deployment diagram](/images/production_deployment_diagram.png)
The production environment is deployed on university’s servers and consists of several servers hosting a combination of Dockerized backend services, dedicated virtual machine for databases and static frontend applications served from a Dockerized single NGINX instance. Backend databases run on a VM to provide stable long-term storage and security polices. Stateless backend services are deployed as Docker containers, with traffic-intesive components (Scheduling Service, Schedule Viewing Service) replicated up to 3 instances with corresponding load balancers for improved throughput, while lighter internal services use a single instance. Frontend applications (SPAs) are delivered by NGINX server, which centralizes routing and hosting all three frontends on a single NGINX instance due to lightweight nature of static files simplifies maintainence. 

Overall, the production environment consists of 4 servers:

1. **Frontend server** – serves all frontend applications.  
2. **Backend Server 1** – hosts all backend services except from Schedule Viewing Service
3. **Backend Server 2** –  hosts three instances of the Schedule Viewing Service behind a load balancer.  
4. **Database server (VM)** – hosts all three production databases.

Backend services are separated into two servers to distribute load, with the main bottleneck expected to be the Schedule Viewing Service due to its time-consuming filtering operations and the highest request volume. This arrangement isolates the most demanding component.