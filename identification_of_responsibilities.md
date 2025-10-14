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

### Feature: Student’s cancellation of enrollment

As a student, I want to be able to cancel an existing enrollment, so that I can reflect real changes in my plan.

#### Feature Breakdown:

1. Student navigates to the list of enrolled courses.
2. Student selects the course to cancel.
3. The system updates the course capacity and student list.
4. The system confirms cancellation to the student via notification/email.

#### Responsibilities

### Feature: Student profile update

As a student, I want to be able to view and edit my profile, to see and correct my personal information without physicically going to student department office.

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

### Feature: Teacher’s lectures management

As a teacher, I want a way to create and manage my lectures, so that can I plan and officially set up my lectures.

#### Feature Breakdown:

1. Teacher opens the lecture management interface.
2. Teacher creates a new lecture or edits an existing one.
3. Teacher enters details (time, capacity, type — practical/presentation).
4. The system checks for time collisions or conflicts.
5. The system confirms successful creation or displays error messages.

#### Responsibilities

### Feature: Teacher – Communication via Email

As a teacher, I want a way to e-mail my enrolled students, to easily provide them with course-relevant information.

#### Feature Breakdown:

1. Teacher opens the “Course Communication” section.
2. The system displays a list of all students currently enrolled in the teacher’s courses.
3. Teacher can filter or select one or multiple students.
4. Teacher writes a message or selects a predefined email template (e.g., assignment reminder, class update).
5. The system automatically fills in recipient details and course context.

#### Responsibilities

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

