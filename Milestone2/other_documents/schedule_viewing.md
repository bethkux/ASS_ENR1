## Feature: Schedule viewing
<!-- The feature described in a form of a user story -->
As a user I want to be able to view a schedule specific to me, a room, a course or a programme in a specific time window.

### Feature breakdown
<!-- The feature breakdown -->
1. Any user goes to the schedule page
2. In the frontend, user selects which schedule to view:
   - Users schedule (student's or teacher's schedules in specific time window)
   - Room schedule
   - Course schedule
   - Programme schedule
3. System fetches and displays schedule data based on the user’s selection
4. If conflicts are detected (overlapping courses, double bookings, and so on...), frontend displays a warning to the user  
5. User can switch between different schedule types repeating (2.)

### Responsibilities
<!-- A ##### section for each group of responsibilities -->

#### Privacy responsibilities
* Users that are not logged in cannot view any schedules
* Logged-in users can view only schedules that they are authorized to see  

#### User notification responsibilities
* Detect and highlight conflicts (overlapping lectures, room double-booking, and so on...)
* Allert user about canceled course dates (as a student or teacher)
* Detect national holiday and other days without teaching and highligt these days as free

#### Performance and scalability responsibilities
* Handle concurrent access efficiently (many users checking schedules at once)
* Cache frequently accessed schedules (popular courses or rooms)
* Ensure fast and efficient filtering through a lot of schedules data

#### Usability responsibilities
* Ensure schedules are readable on all types of devices
* Make sure that schedule selection is intuitive on all types of devices
* Ensure support for multiple ways of accessing schedules data (mobile app, webapp, and so on...)