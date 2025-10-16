# Enrollment System

## Core Features and Responsibilities

### Feature: Student's request to enroll

As a student, I want a way to formally enroll in my courses, to be able to attend classes I need/want.

#### Feature Breakdown:

1. Student opens the enrollment section for their chosen course.
2. The system displays available lecture/practical tickets for that course.
3. Student chooses which ticket(s) to enroll in.
4. The system validates prerequisites and processes enrollment.
5. The system updates student’s schedule and confirms the change.

#### Responsibilities

##### Course collection responsibilities
- Load available courses from the database.
- Fetch lecture and practical sessions for the chosen course.
- Filter out full or inactive sessions.
- Display available options in a clear format.
- Allow student to select one or more session tickets.

##### Enrollment execution responsibilities
- Update the student’s schedule with new sessions.
- Update student enrollment records.

##### Notification responsibilities
- Detect enrollment failures
- Send confirmation of the result via notification or email.

##### Enrollment validation responsibilities
- Verify prerequisites and remaining course capacity.
- Execute enrollment transaction safely.
- Validate selections and check for time conflicts.
- Store valid selections for enrollment processing.

### Feature: Student’s cancellation of enrollment

As a student, I want to be able to cancel an existing enrollment, so that I can reflect real changes in my plan.

#### Feature Breakdown:

1. Student navigates to the list of enrolled courses.
2. Student selects the course to cancel.
3. The system updates the course capacity and student list.
4. The system confirms cancellation to the student via notification/email.

#### Responsibilities

##### Cancellation processing responsibilities
- Update course capacity and student list.
- Log the cancellation event for auditing.
- Remove cancelled course from student's schedule
- Update student capacity and info of tickets for the cancelled enrollment

##### Notification responsibilities
- Send confirmation via notification or email.

##### Course listing responsibilities
- Provide access to the list of enrolled courses.
- Allow course selection for cancellation.

##### Cancellation validation responsitilities
- Validate that the enrollment exists and can be canceled.
- Validate compliance with faculty rules for cancellation
- Block cancellations during non-enrollment times

### Feature: Student profile update

As a student, I want to be able to view and edit my profile, to see and correct my personal information without physically going to student department office.

#### Feature Breakdown:

1. Student navigates to their personal information page.
2. The system loads and displays stored profile data.
3. Student enters edit mode — editable fields are visually indicated.
4. Student modifies desired fields.
5. Student submits the changes.
6. The system validates and updates the database.
7. For sensitive data changes (e.g., IBAN, contact email), the system notifies the SDO via email.
8. The system confirms successful changes with a pop-up and email message.

#### Responsibilities

##### Profile Retrieval Responsibilities
- Request profile data
- Display stored profile data and enable edit mode.

##### Profile Editting Responsibilities
- Provide profile's editting fields
- Save validated changes to the database.
- Sort the students according to certain criteria (Name, Year, etc.)

##### Profile Change Validation Responsibilities
- Validate changes to editable fields.
- Indicate editable fields.
- Check for restricted or sensitive data modifications.
- Log all profile changes for compliance.

##### Notification responsitilities
- Notify the SDO when sensitive data (e.g., IBAN, contact email) changes.
- Send profile change summary notification to email

### Feature: Teacher’s lectures management

As a teacher, I want a way to create and manage my lectures, so that can I plan and officially set up my lectures.

#### Feature Breakdown:

1. Teacher opens the lecture management interface.
2. Teacher creates a new lecture or edits an existing one.
3. Teacher enters details (time, capacity, type — practical/presentation).
4. The system checks for time collisions or conflicts.
5. The system confirms successful creation or displays error messages.

#### Responsibilities

##### Lecture Management Responsibilities
- Facilitate creation of new lectures
- Display existing lectures
- Allow editting of existing lectures
- Update the teacher's list of taught courses
- Log all lecture changes for reference.
- Transmit changes to courses to the database.
- Notify the affected students of the changes.

##### Management Authorization Responsibilities
- Validate teacher permissions.
- Allow granting permissions to other teachers for managing related course tickets

##### Lecture Validation Responsibilities
- Check for time conflicts and invalid entries.
- Check for physical capacities of lecture rooms

### Feature: Teacher – Communication via Email

As a teacher, I want a way to e-mail my enrolled students, to easily provide them with course-relevant information.

#### Feature Breakdown:

1. Teacher opens the “Course Communication” section.
2. The system displays a list of all students currently enrolled in the teacher’s courses.
3. Teacher can filter or select one or multiple students.
4. Teacher writes a message or selects a predefined email template (e.g., assignment reminder, class update).
5. The system automatically fills in recipient details and course context.

#### Responsibilities

##### Communication management responsibilities
- Provide access to the “Course Communication” section.
- Display enrolled students and allow filtering or selection.
- Support single and group message targeting.

##### Automation responsibilities
- Enable writing messages or selecting templates.
- Allow file and image attachments in the message.
- Optionally allow to automatically add the teacher signature at the end of the message.
- Auto-fill course and recipient details according to the information from the lecture page/ details panel.
- Validate message content and recipient list.

##### Notification responsibilities
- Send emails through the system mail service.
- Confirm delivery status to the teacher.
- Log communication events for auditing.

### Feature: Enrollment Lock and Notifications

As a student department officer (SDO), I need the system to automatically lock enrollments and send notifications before and after the processing period, to ensure deadlines are followed.

#### Feature Breakdown:

1. SDO sets the closing date for student enrollments.
2. The system schedules automated notifications for all users (e.g., one day before, on closure, and after).
3. When the date is reached, the system disables new enrollments or modifications.
4. The system processes pending enrollments before fully locking.
5. The system sends confirmation emails to affected students and teachers.
6. SDO can manually reopen or extend enrollment if needed.

#### Responsibilities

##### Enrollment responsibilities
- Allow SDO to set or modify enrollment closing dates.
- Schedule automatic system actions based on deadlines.
- Validate configuration changes.

##### Automated processing responsibilities
- Send pre-closure, closure, and post-closure notifications.
- Disable new enrollments or modifications after deadline.
- Process pending enrollments before full lock.

##### Notifications and override responsibilities
- Send confirmation emails to affected students and teachers.
- Allow SDO to manually reopen or extend enrollment.
- Record all actions in the audit log.

### Feature: Export of Student Personal Data

As a student department officer, I want to export student information, so I can share it easily with institutions such as healthcare or government offices.

#### Feature Breakdown:

1. SDO navigates to the “Data Export” section in the system.
2. The system loads a list of available student data categories (e.g., name, ID, address, enrollment status, IBAN, etc.).
3. SDO selects which data fields should be included in the export.
4. SDO selects the desired export format (e.g., CSV, XLSX, or PDF).
5. The system validates access permissions and confirms data visibility rules.
6. The system generates the export file and anonymizes sensitive data if required.
7. SDO downloads the export file.
8. The system logs the export event for auditing and compliance purposes.

#### Responsibilities

##### Data export responsibilities
- Provide access to the “Data Export” section.
- Display available data categories for selection.
- Allow to export in whichever format (CSV, XLSX, PDF).

##### Data validation responsibilities
- Verify access permissions and visibility rules.
- Compile and anonymize selected data fields.
- Allow to only export selected data.
- Generate the export file in the chosen format.

##### Confirmation respnosibilities
- Enable file download for SDO.
- Log the export event for compliance and tracking.
- Show the progress of the export.
- Notify the user of successful export completion.
- Generate concise file name according to some predefined criteria (Year, Category, etc.).
