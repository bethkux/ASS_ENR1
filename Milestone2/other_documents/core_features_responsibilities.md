# Scheduling System

## Core features and responsibilities

### Feature: Registering new course

As a teacher i want to register a new course with its information so that it can be scheduled and attended by students.

#### Feature breakdown

1. The system should notify teachers registered among teachers by email about the period when subjects can be registered
2. The system recognizes the teacher's account based on their login. 
3. On the home screen, there should be an icon labeled something like "register a course" (which is not visible when a student logs in). 
4. Teachers should be able to choose from a database of subjects they have taught in previous years or create a completely new course.
5. If teacher selected a course he had taught before, the system should ask him if he had made the necessary changes for this year (such as updating the course information) and confirm this. 
   If he wanted to create a course he had not taught before, they should fill in the required information about the subject (such as what the subject is about, how many credits it is worth, which faculty it is for, what its code will be, who the subject is intended for, a link to more detailed information, any prerequisites for enrollment, and which year the subject is intended for).
6. After confirming the subject, it should be submitted to the timetable committee, which will approve it and schedule the time and place. It should also be checked whether the two subjects teach the same thing.

#### Responsibilities

##### Privacy responsibilities
* Only authenticated teachers can register or edit courses.
* Students cannot create or modify subjects.
* Teachers can view courses registered by others for reference but cannot edit them.

##### Notification responsibilities
* The teacher receives an automated notification when:
       The registration period opens.
       A course is successfully submitted to the schedule committee.
       A course is approved or rejected by the committee (with reasons for rejection if applicable).
* The system can send reminders before the registration period closes.

##### Performance responsibilities
* The system should handle simultaneous submissions efficiently, ensuring responsiveness even when multiple teachers register courses concurrently.
* Course data should be stored and retrieved quickly without significant delays.

##### Usability responsibilities
* The registration interface must remain clear and intuitive across all screen sizes and devices.
* Form validation should provide immediate feedback (e.g., missing fields, invalid credit values).
* Previously entered data should not be lost if an error occurs during submission.
* Tooltips or short instructions should guide teachers through each step.
* Reusable course templates should minimize redundant typing.

##### Data Integrity and Validation Responsibilities

* Input data must be validated before submission (e.g., unique course code, correct credit value range).
* Prevent duplicate or conflicting course entries.
* Ensure consistent data format across all registered courses.
* Maintain audit logs of who created, modified, or approved each course.

##### Security Responsibilities

* All communication between the client and server must be encrypted (HTTPS).
Access to course registration features should require proper authentication and authorization checks.
* Sensitive information such as teacher IDs or emails must not be publicly visible.

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
- Fetch all courses from persistent storage.
- Fetch course info
- Caching courses
- Store course schedule to persistent database.

##### Course Filtering responsibilities
- Filter current semester. 
- Show the table of scheduled courses and a list of unscheduled courses.
- Filter courses based on user input (year, teacher, name).
- Detect courses that are insufficiently scheduled (based on capacities).

##### Candidate filtering responsibilities
- Load course-specific information and constraints.  
- Find teacher teaching the course and fetch their schedules.  
- Find rooms with enough capacity matching the room types.  

##### Validation and collision responsibilities
- Check room schedule for conflicts.
- Show result of overall conflict detection


##### Notification responsibilities
- Notify teachers assigned to the course.
- Notify teacher to schedule their course if it is not scheduled by commitee.
- Alert user when room conflict is detected.
- Alert user when teacher conflict is detected.

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
- Check new or edited course against all existing scheduled courses.  
- Detect overlapping times for the same room. (room conflicts)  
- Detect overlapping times for the same teacher. (teacher conflicts)
- Show courses with collisions
- Show teachers with collisions 
- Show and provide overall collision detection to ensure all scheduled courses are checked for possible conflicts
- Show collison resolution form (a commitee member can manualy resolve a collision by setting a status of the collision)
- Optionally, detect overlapping courses for the same program or student group.  

##### User notification responsibilities 
- Show room conflict alert (highlight conflicting courses clearly in the interface) 
- Show teacher conflict alert
- Suggest possible resolutions (alternative rooms, times, or teachers) (optional)

##### Logging and audit responsibilities 
- Store room and teacher collisions 
- Store how each conflict was resolved (collision status).  
- Allow committee members to review unresolved conflicts at any time by room/teacher.

##### Performance and scalability responsibilities
- Efficiently detect collisions even with a large number of scheduled courses.  
- Ensure minimal latency so that scheduling workflow is smooth for committee members.  

##### Quality responsibilities
- Provide clear conflict messages.  
- Allow committee members to quickly filter and review conflicts.

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
* Users that are not logged in cannot view any schedules
* Logged-in users can view only schedules that they are authorized to see  

##### User notification responsibilities
* Detect and highlight conflicts (overlapping lectures, room double-booking, and so on...)
* Allert user about canceled course dates (as a student or teacher)
* Detect national holiday and other days without teaching and highligt these days as free

##### Performance and scalability responsibilities
* Fetching schedules data 
* Handle concurrent access efficiently (many users checking schedules at once)
* Cache frequently accessed schedules (popular courses or rooms)
* Ensure fast and efficient filtering through a lot of schedules data

##### Usability responsibilities
* Showing schedule based on user selection
* Ensure schedules are readable on all types of devices
* Make sure that schedule selection is intuitive on all types of devices
* Ensure support for multiple ways of accessing schedules data (mobile app, webapp, and so on...)

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
- Retrieve historical data from persistent storage.
- Cache commonly requested statistics or semesters to optimize performance.
- Handle historical datasets efficiently.

##### Statistics computation responsibilities:
- Run the appropriate statistical calculations based on the selected category and filters.
- Store the statistical results.

##### Filtering responsibilities:
- Validate user selections (for example, ensure chosen semester exists in storage).
- Apply the chosen filters based on the category.
- Provide suggestions if filters are too restrictive (for example if there is no data for given room &rarr; try all rooms instead)

##### User interaction and visualization responsibilities:
- Present the available statistics categories and filter options.
- Display the computed results to the user using appropriate visualization (tables, graphs, charts...).
- Provide intuitive navigation between different statistical views.

##### Usability responsibilities:
- Ensure responsive design for all devices and screen sizes.

##### Error handling responsibilities:
- Alert the user when no results can be generated (for example, no data is available for selected filters)
- Display clear messages during loading, failure, or empty states.
