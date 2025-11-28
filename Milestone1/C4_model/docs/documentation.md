# Enrollment System

System designed to streamline academic administrative tasks for Students, Teachers, and Student Department Officers (SDOs) in a university setting. It focuses on course enrollment, managing personal data, helps with organizing classes, and makes sure deadlines and data security rules are followed.

![](embed:enrollmentContainerDiagram)

## Brief overview

We have divided three subdomains, corresponding to the following service containers

1. `User Profile Service` focusing on domain logic relevant to user profiles.
2. `Course Service` for domain logic around courses + enrollments, and managing them as a faculty employee.
3. `Audit Log Service` for audit logging across the enrollment system, also triggerering notifications when.

Each has their respective database container, with which they can be deployed into User-Profile- or Course- or Audit-Log- server.
That is, if we have enough physical resources, and would like services to function, despite other being unavailable.

---

##  Assignment of Responsibilities

### Student User Interface (L2 Container)

#### `Student Course UI`
* Display available courses
* Provide interface for making enrollmment

#### `Student Profile UI`
* Search and display user profiles
* Provide interface for editting your own profile

#### `Student Authenticator`
* Provides interface with single sign-on

---

### Employee User Interface (L2 Container)
* Display/Facilitate creation/Allow editing of existing lectures

#### `Faculty Profile UI`
* Display profile info
* Provide access to the “Data Export” section
* Enable file download for SDO of "Data Export"

#### `Faculty Course UI`
* Display relevant courses
* Provide interface for management of courses and their enrollments

#### `Faculty Authenticator`
* Provides interface with single sign-on

Note: For `Faculty Authenticator` and `Student Authenticator` the same shared library for authentication can be used. Other UI components differ in behavior, with faculty UIs allowing more.

---

### User Profile Service (L2 Container)

#### `User Profile Service API`
* Verify access permissions and visibility rules for data export
* Verify provided authentication tokens

#### `User Profile Provider`
* Load courses from the database
* Request profile data

#### `User Profile Editor`
* Make requested changes to profile
* Validate changes to editable fields
* Check for restricted or sensitive data modifications

#### `User Profile Repository`
* Save validated changes to the database (Feature 2).

#### `User Profile`
* Prescribe user profile data
* Compile and anonymize selected data fields
* Generate the export file in the chosen format

---

### Course Service (L2 Container)

#### `Course enrollment API`
* Validate course enrollment requests (initial checks)
* Validate teacher permissions (using `SSO`)

#### `Course Provider`
* Load existing courses

#### `Course Manager`
* Update student enrollment records
* Validate compliance with faculty rules
* Verify prerequisites and course capacity
* Check for time conflicts
* Update the teacher's list of taught courses,
* Transmit changes to courses to the database
* Add/Remove enrollments, Update course capacity

#### `Course Model`
* Prescribe course data
* Update course ticket per enrollment change

#### `Course repository`
* Execute enrollment transaction safely

---

### Audit Log Service (L2 Container)

#### `Audit Log Consumer`
* Log all profile changes for compliance
* Log all lecture changes for reference
* Log the export event for compliance and tracking
* Pass notable logs to `Audit Notifier`

#### `Audit Notifier`
* Send result confirmation notifications (via `Email System`)
* Notify the SDO when sensitive data changes (via `Email System`)
* Send profile change summary notification to email
* Notify the affected students of the changes (via `Email System`)
* Notify enrolled student/Notify of failures (via `Email System`)
* Notify the user of successful export completion

---

### Databases (L2 Containers)

#### `User Profile Database`
* Contains user profile data

#### `Course Database`
* Contains course and enrollment data

#### `Audit Log Database`
* Contains audit log records
