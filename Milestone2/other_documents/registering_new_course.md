## Feature: Registering new course
<!-- The feature described in a form of a user story -->
As a teacher i want to register a new course with its information so that it can be schedule and attended by students

### Feature breakdown
<!-- The feature breakdown -->
1. The system should notify teachers registered among teachers by email about the period when subjects can be registered
2. The system recognizes the teacher's account based on their login. 
3. On the home screen, there should be an icon labeled something like "register a course" (which is not visible when a student logs in). 
4. Teachers should be able to choose from a database of subjects they have taught in previous years or create a completely new course.
5. If teacher selected a course he had taught before, the system should ask him if he had made the necessary changes for this year (such as updating the course information) and confirm this. 
   If he wanted to create a course he had not taught before, they should fill in the required information about the subject (such as what the subject is about, how many credits it is worth, which faculty it is for, what its code will be, who the subject is intended for, a link to more detailed information, any prerequisites for enrollment, and which year the subject is intended for).
6. After confirming the subject, it should be submitted to the timetable committee, which will approve it and schedule the time and place. It should also be checked whether the two subjects teach the same thing.

### Responsibilities
<!-- A ##### section for each group of responsibilities -->

#### Privacy responsibilities
* Users who are students do not have the right to create subjects
* Teachers should be able to see which subjects have already been registered by other teachers

#### Notification responsibilities
* The teacher receives a message that it is possible to register for the course during a certain period.
* The teacher receives a message that his/her course has been successfully submitted to the schedule committee.
* The teacher receives a message that his/her course has been approved by the committee.

#### Performance responsibilities
* Ensuring sufficient transmission capacity if multiple teachers were to register at the same time

#### Usability responsibilities
* Ensures that the layout of the course registration screen is clear on all screen sizes
* Everything should be as simple as possible



