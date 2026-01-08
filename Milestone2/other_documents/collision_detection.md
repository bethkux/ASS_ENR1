### Feature: Collision detection

As a committee member or a teacher, I want the system to notify me when more courses are scheduled in the same room, time, or with the same teacher so I can avoid conflicts in the schedule.

---

### Feature breakdown

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
6. Committee members can view a list of unresolved conflicts at any time, filter them (by teacher, room, or course), and address them later.  

---

### Responsibilities

#### Collision detection responsibilities
- Check new or edited course against all existing scheduled courses.  
- Detect overlapping times for the same room.  
- Detect overlapping times for the same teacher.  
- Provide overall collision detection to ensure all scheduled courses are checked for possible conflicts
- Optionally, detect overlapping courses for the same program or student group.  

#### User notification responsibilities
- Alert the committee member immediately when a collision is detected.  
- Alert the teacher immediately when a collision is detected (teachers who are allowed to schedule seminars) 
- Highlight conflicting courses clearly in the interface.  
- Suggest possible resolutions (alternative rooms, times, or teachers) (optional)

#### Logging and audit responsibilities
- Keep a record of all detected conflicts for future reference.  
- Store how each conflict was resolved (automatic suggestion accepted, manually changed, or ignored).  
- Allow committee members to review unresolved conflicts at any time.

#### Performance and scalability responsibilities
- Efficiently detect collisions even with a large number of scheduled courses.  
- Ensure minimal latency so that scheduling workflow is smooth for committee members.  

#### Quality responsibilities
- Provide clear conflict messages.  
- Allow committee members to quickly filter and review conflicts.
