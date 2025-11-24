# Enrollment System

System designed to streamline academic administrative tasks for Students, Teachers, and Student Department Officers (SDOs) in a university setting. It focuses on course enrollment, managing personal data, helps with organizing classes, and makes sure deadlines and data security rules are followed.

![](embed:enrollmentContainerDiagram)

---

Below are the features broken down by user role, including the user story, the detailed user-system interaction, and the derived responsibilities for implementation.

## Core Features and Responsibilities

### Feature: Student's enrollment self-management

As a student, I want a way to manage my enrollments, so that I can formally attend my classes.

#### Feature Breakdown:

1. Student opens the enrollment section for their chosen course.
2. The system displays available lecture/practical tickets for that course.
3. Student selects ticket(s) for enrollment creation/cancellation.
4. The system validates the request with faculty rules.
5. The system updates student’s schedule and confirms the change.
6. The system updates course ticket capacities.

#### Responsibilities

##### Course collection responsibilities
- Load courses from the database.
- Display available course options.

##### Enrollment execution responsibilities
- Update the student’s schedule.
- Update student enrollment records.
- Update course ticket per enrollment change.

##### Notification responsibilities
- Send result confirmation notifications.

##### Enrollment validation responsibilities
- Validate compliance with faculty rules
- Verify prerequisites and course capacity.
- Execute enrollment transaction safely.
- Check for time conflicts.

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

### Feature: Faculty initiated enrollment management

As a teacher/SDO, I want a way make enrollments on behalf of students, so that they can be enrolled if student's can't make self-enrollments.

#### Feature Breakdown:

1. Teacher opens the lecture management interface.
2. Teacher chooses to create a new enrollment.
2. Teacher selects the course and the student for enrollment.
3  System verifies and registers the enrollment
5. The system sends notifications of the enrollment.

##### Lecture Management Responsibilities
- Add enrollments
- Remove enrollments
- Update course capacity

##### Management Authorization Responsibilities
- Validate teacher permissions.
- Allow granting permissions to other teachers for managing enrollments

##### Enrollment validation responsibilities
- Validate compliance with faculty rules
- Verify course capacity.
- Check for time conflicts.

##### Notification responsibilities
- Notify enrolled student
- Notify of failures

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

---

##  Assignment of Responsibilities

### 1. User Interfaces (L2 Containers)

#### a) `Student User Interface`
* Display available course options (Feature 1).
* Display stored profile data and enable edit mode (Feature 2).
* Provide access to the enrollment/profile sections (General UX).

#### b) `Employee User Interface`
* Display/Facilitate creation/Allow editing of existing lectures (Feature 3).
* Provide access to the “Data Export” section (Feature 5).
* Provide access to adding/removing enrollments section (Feature 4).
* Enable file download for SDO (Feature 5).

---

### 2. User Profile Service (L2 Container)

#### a) `User Profile Service API`
* Verify access permissions and visibility rules for data export (Feature 5).

#### b) `User Profile Provider`
* Load courses from the database (Feature 1).
* Request profile data (Feature 2).
* Display available data categories for selection (Feature 5).

#### c) `User Profile Editor`
* Provide profile's editing fields (Feature 2).
* Validate changes to editable fields, Check for restricted or sensitive data modifications (Feature 2).

#### d) `User Profile Repository`
* Save validated changes to the database (Feature 2).

#### e) *User Profile*
* Compile and anonymize selected data fields (Feature 5).
* Generate the export file in the chosen format (CSV, XLSX, PDF) (Feature 5).

---

### 3. Course Service (L2 Container)

#### a) `Course enrollment API`
* Validate course enrollment requests (initial checks) (Feature 1).
* Validate teacher permissions (using `SSO`) (Feature 3, Feature 4).

#### b) `Course Provider`
* Load courses from the database (Feature 1).

#### c) `Course Manager`
* Update the student’s schedule, Update student enrollment records (Feature 1).
* Validate compliance with faculty rules (Feature 1, Feature 4).
* Verify prerequisites and course capacity (Feature 1, Feature 4).
* Check for time conflicts (Feature 1, Feature 3, Feature 4).
* Update the teacher's list of taught courses, Transmit changes to courses to the database (Feature 3).
* Add/Remove enrollments, Update course capacity (Feature 4).

#### d) `Course Model`
* Update course ticket per enrollment change (Feature 1).

#### e) `Course repository`
* Execute enrollment transaction safely (Feature 1).

---

### 4. Audit Log Service (L2 Container)

#### a) `Audit Log Consumer`
* Log all profile changes for compliance (Feature 2).
* Log the export event for compliance and tracking (Feature 5).
* Log all lecture changes for reference (Feature 3).

#### b) `Audit Notifier`
* Send result confirmation notifications (via `Email System`) (Feature 1).
* Notify the SDO when sensitive data changes (via `Email System`) (Feature 2).
* Send profile change summary notification to email (Feature 2).
* Notify the affected students of the changes (via `Email System`) (Feature 3).
* Notify enrolled student/Notify of failures (via `Email System`) (Feature 4).
* Notify the user of successful export completion (Feature 5).

---

### 5. Databases (L2 Containers)

#### a) `User Profile Database`
* Store user profile data (Feature 2).

#### b) `Course Database`
* Store course and enrollment data (Feature 1).

#### c) `Audit Log Database`
* Persist audit log records (Logging).
