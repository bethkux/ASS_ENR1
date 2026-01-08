## Feature: Statistics Viewing

*As a user, I want to be able to see the statistics from previous years, such as room utilization and teacher workload, so that I can support better planning and decision-making based on past data.*

***Note:** User refers to any user of the system.*

---

### Feature breakdown:
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
    - **Past schedules** &rarr; filtering and viewing works as described in [Schedule viewing](schedule_viewing.md) feature.
6. The user confirms their selection.
7. The system retrieves the historical scheduling data from persistent storage.
8. The system computes the requested statistics.
9. The system displays the results to the user visually:
    - **Tables**
    - **Graphs**
    - **Charts**
    - ...

---

### Responsibilities

#### **Data retrieval responsibilities:**
- Retrieve historical data from persistent storage.
- Cache commonly requested statistics or semesters to optimize performance.
- Handle historical datasets efficiently.

#### **Statistics computation responsibilities:**
- Run the appropriate statistical calculations based on the selected category and filters.
- Store the statistical results.

#### **Filtering responsibilities:**
- Validate user selections (for example, ensure chosen semester exists in storage).
- Apply the chosen filters based on the category.
- Provide suggestions if filters are too restrictive (for example if there is no data for given room &rarr; try all rooms instead)

### **User interaction and visualization responsibilities**:
- Present the available statistics categories and filter options.
- Display the computed results to the user using appropriate visualization (tables, graphs, charts...).
- Provide intuitive navigation between different statistical views.

### **Usability responsibilities:**
- Ensure responsive design for all devices and screen sizes.

### **Error handling responsibilities:**
- Alert the user when no results can be generated (for example, no data is available for selected filters)
- Display clear messages during loading, failure, or empty states.
