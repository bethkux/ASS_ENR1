# Enrollment System

System designed to streamline academic administrative tasks for Students, Teachers, and Student Department Officers (SDOs) in a university setting. It focuses on course enrollment, managing personal data, helps with organizing classes, and makes sure deadlines and data security rules are followed.

---

##  Features, User Stories, and Interaction Breakdowns

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
---
##  Assignment of Responsibilities

## 1.  Feature: Student's enrollment self-management

### a). Course Collection Responsibilities
* Student User Interface: Display available course options.
* Course Service / Course Provider: Load courses from the database.

### b). Enrollment Execution Responsibilities
* Course Service / Course Manager: Update the student’s schedule, Update student enrollment records.
* Course Service / Course Model: Update course ticket per enrollment change.
* Course Service / Course repository: Execute enrollment transaction safely.
* Course Database: Store course and enrollment data.

### c). Validation & Notification Responsibilities
* Course Service / Course Manager: Validate compliance with faculty rules, Verify prerequisites and course capacity, Check for time conflicts.
* Course Service / Course enrollment API: Validate course enrollment requests (initial checks).
* Audit Log Service / Audit Notifier: Send result confirmation notifications (via Email System).

---

